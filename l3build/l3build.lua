--[[

  File l3build.lua (C) Copyright 2014 The LaTeX3 Project

 It may be distributed and/or modified under the conditions of the
 LaTeX Project Public License (LPPL), either version 1.3c of this
 license or (at your option) any later version.  The latest version
 of this license is in the file

    http://www.latex-project.org/lppl.txt

 This file is part of the "l3build bundle" (The Work in LPPL)
 and all files in that bundle must be distributed together.

 The released version of this bundle is available from CTAN.

--]]

-- Ensure the module and bundle exist
module = module or ""
bundle = bundle or ""

-- Directory structure for the build system
-- Use Unix-style path separators
maindir     = maindir or "."

-- Substructure for tests and support files
testfiledir = testfiledir or "testfiles" -- Set to "" to cancel any tests
testsupdir  = testsupdir  or testfiledir .. "/support"
supportdir  = supportdir  or maindir .. "/support"

-- Structure within a development area
distribdir  = distribdir or maindir .. "/build/distrib"
localdir    = localdir   or maindir .. "/build/local"
testdir     = testdir    or maindir .. "/build/test"
typesetdir  = typesetdir or maindir .. "/build/doc"
unpackdir   = unpackdir  or maindir .. "/build/unpacked"

-- Substructure for CTAN release material
ctandir     = ctandir or distribdir .. "/ctan"
tdsdir      = tdsdir  or distribdir .. "/tds"
tdsroot     = tdsroot or "latex"

-- Location for installation on CTAN or in TEXMFHOME
if bundle == "" then
  moduledir = tdsroot .. "/" .. module
else
  moduledir = tdsroot .. "/" .. bundle .. "/" .. module
end

-- File types for various operations
-- Use Unix-style globs
-- All of these may be set earlier, so a initialised conditionally
binaryfiles      = binaryfiles      or {"*.pdf", "*.zip"}
checkfiles       = checkfiles       or { } -- Extra files unpacked purely for tests
checksuppfiles   = checksuppfiles   or {"*.cls", "*.def", "*.lua", "*.sty", "*.tex"}
cmdchkfiles      = cmdchkfiles      or { }
demofiles        = demofiles        or { }
cleanfiles       = cleanfiles       or {"*.pdf", "*.zip"}
excludefiles     = excludefiles     or {"*~"}             -- Any Emacs stuff
installfiles     = installfiles     or {"*.sty"}
sourcefiles      = sourcefiles      or {"*.dtx", "*.ins"} -- Files to copy for unpacking
txtfiles         = txtfiles         or {"*.markdown"}
typesetfiles     = typesetfiles     or {"*.dtx"}
typesetsuppfiles = typesetsuppfiles or { }
unpackfiles      = unpackfiles      or {"*.ins"}          -- Files to actually unpack
unpacksuppfiles  = unpacksuppfiles  or { }

-- Roots which should be unpacked to support unpacking/testing/typesetting
checkdeps   = checkdeps   or { }
typesetdeps = typesetdeps or { }
unpackdeps  = unpackdeps  or { }

-- Executable names plus following options
typesetexe = typesetexe or "pdflatex"
unpackexe  = unpackexe  or "tex"
zipexe     = "zip"

checkopts   = checkopts   or "-interaction=batchmode"
cmdchkopts  = cmdchkopts  or "-interaction=batchmode"
typesetopts = typesetopts or "-interaction=nonstopmode"
unpackopts  = unpackopts  or ""
zipopts     = zipopts     or "-v -r -X"

-- Engines for testing
chkengines = chkengines or {"pdftex", "xetex", "luatex"}
stdengine  = stdengine  or "pdftex"

-- Enable access to trees outside of the repo
-- As these may be set false, a more elaborate test than normal is needed
-- here
if checksearch == nil then
  checksearch = true
end
if typesetsearch == nil then
  typesetsearch = true
end
if unpacksearch == nil then
  unpacksearch = true
end

-- Other required settings
checkruns   = checkruns   or 1
scriptname  = scriptname  or "build.lua" -- Script used in each directory
typesetcmds = typesetcmds or ""

-- Extensions for various file types: used to abstract out stuff a bit
logext = logext or ".log"
lvtext = lvtext or ".lvt"
tlgext = tlgext or ".tlg"

-- Convert a file glob into a pattern for use by e.g. string.gub
-- Based on https://github.com/davidm/lua-glob-pattern
-- Simplified substantially: "[...]" syntax not supported as is not
-- required by the file patterns used by the team. Also note style
-- changes to match coding approach in rest of this file.
--
-- License for original globtopattern
--[[

  (c) 2008-2011 David Manura.  Licensed under the same terms as Lua (MIT).

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files (the "Software"), to deal
  in the Software without restriction, including without limitation the rights
  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
  copies of the Software, and to permit persons to whom the Software is
  furnished to do so, subject to the following conditions:

  The above copyright notice and this permission notice shall be included in
  all copies or substantial portions of the Software.

  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
  THE SOFTWARE.
  (end license)

--]]
function glob_to_pattern (glob)

  local pattern = "^" -- pattern being built
  local i = 0 -- index in glob
  local char -- char at index i in glob

  -- escape pattern char
  local function escape (char)
    return string.match (char, "^%w$") and char or "%" .. char
  end

  -- Convert tokens.
  while true do
    i = i + 1
    char = string.sub (glob, i, i)
    if char == "" then
      pattern = pattern .. "$"
      break
    elseif char == "?" then
      pattern = pattern .. "."
    elseif char == "*" then
      pattern = pattern .. ".*"
    elseif char == "[" then
      -- Ignored
      print ("[...] syntax not supported in globs!")
    elseif char == "\\" then
      i = i + 1
      char = string.sub(glob, i, i)
      if char == "" then
        pattern = pattern .. "\\$"
        break
      end
      pattern = pattern .. escape (char)
    else
      pattern = pattern .. escape (char)
    end
  end
  return pattern
end

-- File operation support
-- Much of this is OS-dependent as Lua offers a very limited range of file
-- operations 'natively'.

-- Detect the operating system in use
-- See http://www.lua.org/manual/5.2/manual.html#pdf-package.config for details
-- of the string used here to pick up the operating system (Windows or
-- 'not-Windows'
-- Support items are defined here for cases where a single string can cover
-- both Windows and Unix cases: more complex situations are handled inside
-- the support functions
if string.sub (package.config, 1, 1) == "\\" then
  os_concat   = "&"
  os_diffext  = ".fc"
  os_diffexe  = "fc /n"
  os_null     = "nul"
  os_pathsep  = ";"
  os_setenv   = "set"
  os_windows  = true
else
  os_concat   = ";"
  os_diffext  = ".diff"
  os_diffexe  = "diff -c"
  os_null     = "/dev/null"
  os_pathsep  = ":"
  os_setenv   = "export"
  os_windows  = false
end

-- File operations are aided by the LuaFileSystem module, which is available
-- within texlua
lfs = require ("lfs")

-- For cleaning out a directory, which also ensures that it exists
function cleandir (dir)
  mkdir (dir)
  rm (dir, "*")
end

-- Copy files 'quietly'
function cp (glob, source, dest)
  for _,i in ipairs (filelist (source, glob)) do
    local source = source .. "/" .. i
    if os_windows then
      os.execute (
          "copy /y " .. unix_to_win (source) .. " "
            .. unix_to_win (dest) .. " > nul"
        )
    else
      os.execute ("cp -f " .. source .. " " .. dest)
    end
  end
end

-- OS-dependent test for a directory
function direxists (dir)
  local errorlevel
  if os_windows then
    errorlevel =
      os.execute ("if not exist \"" .. unix_to_win (dir) .. "\" exit 1")
  else
    errorlevel = os.execute ("[ -d " .. dir .. " ]")
  end
  if errorlevel ~= 0 then
    return (false)
  end
  return (true)
end

function fileexists (file)
  local f = io.open (file, "r")
  if f ~= nil then
    io.close(f)
    return true
  else
    return false
  end
end

-- Generate a table containing all file names of the given glob or all files
-- if absent
-- Not actually OS-dependent but in the same area
function filelist (path, glob)
  local files = { }
  local pattern
  if glob then
    pattern = glob_to_pattern (glob)
  end
  if direxists (path) then
    for entry in lfs.dir (path) do
      if pattern then
        if string.match (entry, pattern) then
          table.insert (files, entry)
        end
      else
        if entry ~= "." and entry ~= ".." then
          table.insert (files, entry)
        end
      end
    end
  end
  return files
end

function mkdir (dir)
  if os_windows then
    -- Windows (with the extensions) will automatically make directory trees
    -- but issues a warning if the dir already exists: avoid by including a test
    local dir = unix_to_win (dir)
    os.execute ("if not exist "  .. dir .. "\\nul " .. "mkdir " .. dir)
  else
    os.execute ("mkdir -p " .. dir)
  end
end

-- Rename
function ren (dir, source, dest)
  local dir = dir .. "/"
  if os_windows then
    os.execute ("ren " .. unix_to_win (dir) .. source .. " " .. dest)
  else
    os.execute ("mv " .. dir .. source .. " " .. dir .. dest)
  end
end

-- Remove file(s) based on a glob
function rm (source, glob)
  for _,i in ipairs (filelist (source, glob)) do
    os.remove (source .. "/" .. i)
  end
end

-- Remove a directory tree
function rmdir (dir)
  -- First, make sure it exists to avoid any errors
  mkdir (dir)
  if os_windows then
    os.execute ("rmdir /s /q " .. unix_to_win (dir) )
  else
    os.execute ("rm -r " .. dir)
  end
end

-- Run a command in a given directory
function run (dir, cmd)
  local errorlevel = os.execute ("cd " .. dir .. os_concat .. cmd)
  return (errorlevel)
end

-- Deal with the fact that Windows and Unix use different path separators
function unix_to_win (path)
  local path = string.gsub (path, "/", "\\")
  return path
end

--
-- Auxiliary functions which are used by more than one main function
--

-- Do some subtarget for all modules in a bundle
function allmodules (target)
  local errorlevel = 0
  for _,i in ipairs (modules) do
    print (
        "Running script " .. scriptname .. " with target \"" .. target .. "\" for module "
          .. i
      )
    errorlevel = run (i, "texlua " .. scriptname .. " " .. target)
    if errorlevel > 0 then
      return (errorlevel)
    end
  end
  return (errorlevel)
end

-- Set up the check system files: needed for checking one or more tests and
-- for saving the test files
function checkinit ()
  cleandir (localdir)
  cleandir (testdir)
  cleandir (unpackdir)
  depinstall (checkdeps)
  for _,i in ipairs (filelist (localdir)) do
    cp (i, localdir, testdir)
  end
  bundleunpack ()
  for _,i in ipairs (installfiles) do
    cp (i, unpackdir, testdir)
  end
  for _,i in ipairs (checkfiles) do
    cp (i, unpackdir, testdir)
  end
  if direxists (testsupdir) then
    for _,i in ipairs (filelist (testsupdir)) do
      cp (i, testsupdir, testdir)
    end
  end
  for _,i in ipairs (checksuppfiles) do
    cp (i, supportdir, testdir)
  end
end

-- Unpack files needed to support testing/typesetting/unpacking
function depinstall (deps)
  for _,i in ipairs (deps) do
    print ("Installing dependency: " .. i)
    run (i, "texlua " .. scriptname .. " localinstall")
    cleandir (unpackdir)
  end
end

-- Convert the raw log file into one for comparison/storage: keeps only
-- the 'business' part from the tests and removes system-dependent stuff
function formatlog (logfile, newfile)
  local function killcheck (line, kill)
    local killnext = false
    local line = line
      -- Skip lines containing file dates
      if string.match (line, "[^<]%d%d%d%d/%d%d/%d%d") then
        line = ""
      elseif
      -- Skip \openin/\openout lines in web2c 7.x
      -- As Lua doesn't allow "(in|out)", a slightly complex approach:
      -- do a substitution to check the line is exactly what is required!
        string.match (
            string.gsub (line, "^\\openin", "\\openout"), "^\\openout%d = "
          )
          then
          line = ""
      elseif
        -- Various things that only LuaTeX adds to boxes: at least while
        -- we don't have bidi tests these lines can be removed
        string.match (line, "^%.*\\whatsit$")                 or
        string.match (line, "^%.*\\localinterlinepenalty=0$") or
        string.match (line, "^%.*\\localbrokenpenalty=0$")    or
        string.match (line, "^%.*\\localleftbox=null$")       or
        string.match (line, "^%.*\\localrightbox=null$")      then
        line = ""
      -- Pick up LuaTeX's \discretionary line and remove it and the next
      -- line
      elseif
        string.match (line, "%.+\\discretionary") then
          line = ""
          killnext = true
      elseif kill then
        line = ""
      end
    return line, killnext
  end
    -- Substitutions to remove some non-useful changes
  local function normalize (line)
    local line = line
    -- Remove test file name from lines
    line = string.gsub (line, string.match (logfile, ".*/(.*)%" .. logext .. "$"), "")
    -- Zap ./ at begin of filename
    line = string.gsub (line, "%(%.%/", "(")
    -- XeTeX knows only the smaller set of dimension units
    line = string.gsub (
        line, "cm, mm, dd, cc, bp, or sp", "cm, mm, dd, cc, nd, nc, bp, or sp"
      )
    -- Normalise a case where fixing a TeX bug changes the message text
    line = string.gsub (line, "\\csname\\endcsname ", "\\csname\\endcsname")
    -- Zap "on line <num>" and replace with "on line ..."
    line = string.gsub (line, "on line %d*", "on line ...")
    -- Remove spaces at the start of lines: deals with the fact that LuaTeX
    -- uses a different number to the other engines
    line = string.gsub (line, "^%s+", "")
    -- LuaTeX can give slightly different glue setting to pdfTeX:
    -- handle this by restricting to four decimal places
    line = string.gsub (
        line, "glue set (%d+.%d%d%d%d)%dfil", "glue set %1fil"
      )
    -- For the present, remove direction information on boxes
    line = string.gsub (line, ", direction TLT", "")
    -- LuaTeX displays low chars differently: tidy up to ^^ notation
    for i = 1, 31, 1 do
      line = string.gsub (line, string.char (i), "^^" .. string.char (64 + i))
    end
    -- Minor LuaTeX bug: it prints an extra "'" in one message: add enough
    -- context to hopefully hit only the bug
    line = string.gsub (
        line, "I''m going to assume", "I'm going to assume"
      )
    return line
  end
  local newlog = ""
  local prestart = true
  local skipping = false
  local killnext = false
  for line in io.lines (logfile) do
    if line == "START-TEST-LOG" then
      prestart = false
    elseif line == "END-TEST-LOG" then
      break
    elseif line == "OMIT" then
      skipping = true
    elseif line == "TIMO" then
      skipping = false
    elseif not prestart and not skipping then
      line = normalize (line)
      line, killnext = killcheck (line, killnext)
      if not string.match (line, "^ *$") then
        newlog = newlog .. line .. "\n"
      end
    end
  end
  local newfile = io.open (newfile, "w")
  io.output (newfile)
  io.write (newlog)
  io.close (newfile)
end

-- Runs a single test: needs the name of the test rather than the .lvt file
-- One 'test' here may apply to multiple engines
function runcheck (name, engine, hide)
  local chkengines = chkengines
  if engine then
    chkengines = {engine}
  end
  local errorlevel = 0
  for _,i in ipairs (chkengines) do
    runtest (name, i, hide)
    local testname = name .. "." .. i
    local difffile = testdir .. "/" .. testname .. os_diffext
    local newfile  = testdir .. "/" .. testname .. logext
    -- Use engine-specific file if available
    local tlgfile  = testfiledir .. "/" .. name ..  "." .. i .. tlgext
    if not fileexists (tlgfile) then
      tlgfile  = testfiledir .. "/" .. name .. tlgext
    end
    if os_windows then
      tlgfile = unix_to_win (tlgfile)
    end
    local errlevel = os.execute (
        os_diffexe .. " " .. tlgfile .. " " .. newfile .. " > " .. difffile
      )
    if errlevel == 0 then
      os.remove (difffile)
    else
      errorlevel = errlevel
    end
  end
  return (errorlevel)
end

-- Run one of the test files: doesn't check the result so suitable for
-- both creating and verifying .tlg files
function runtest (name, engine, hide)
  cp (name .. lvtext, testfiledir, testdir)
  local engine = engine or stdengine
  -- Engine name doesn't include the "la" for LaTeX!
  local cmd = string.gsub (engine, "tex$", "latex")
  local logfile = testdir .. "/" .. name .. logext
  local lvtfile = name .. lvtext
  local newfile = testdir .. "/" .. name .. "." .. engine .. logext
  for i = 1, checkruns, 1 do
    run (
        testdir,
        os_setenv .. " TEXINPUTS=." .. (checksearch and os_pathsep or "")
          .. os_concat ..
        cmd ..  " " .. checkopts .. " " .. lvtfile
          .. (hide and (" > " .. os_null) or "")
      )
  end
  formatlog (logfile, newfile)
end

-- Strip the extension from a file name
function stripext (file)
  local name = string.gsub (file, "%..*$", "")
  return name
end

function testexists (test)
  if fileexists (testfiledir .. "/" .. test .. lvtext) then
    return true
  else
    return false
  end
end

-- Standard versions of the main targets for building modules

-- Simply print out how to use the build system
help = help or function ()
  print ""
  if testfiledir ~= "" then
    print " build check                    - run automated check system                "
  end
  if module ~= "" and testfiledir ~= "" then
    print " build checklvt <name>          - check one test file <name> for all engines"
    print " build checklvt <name> <engine> - check one test file <name> for <engine>   "
  end
  print " build clean                    - clean out directory tree                  "
  if next (cmdchkfiles) ~= nil then
    print " build cmdcheck                 - check commands documented are defined     "
  end
  if module == "" or bundle == "" then
    print " build ctan                     - create CTAN-ready archive                 "
  end
  print " build doc                      - runs all documentation files              "
  print " build install                  - install files in local texmf tree         "
  if module ~= "" and testfiledir ~= "" then
    print " build savetlg <name>           - save test log for <name> for all engines  "
    print " build savetlg <name> <engine>  - save test log for <name> for <engine>     "
  end
  print " build unpack                   - extract packages                          "
  print ""
end

function check ()
  checkinit ()
  local errorlevel = 0
  print ("Running checks on")
  for _,i in ipairs (filelist (testfiledir, "*" .. lvtext)) do
    local name = stripext (i)
    print ("  " .. name)
    local errlevel = runcheck (name, nil, true)
    if errlevel ~= 0 then
      errorlevel = 1
    end
  end
  if errorlevel ~= 0 then
    print ("\n  Check failed with difference files")
    for _,i in ipairs (filelist (testdir, "*" .. os_diffext)) do
      print ("  - " .. testdir .. "/" .. i)
    end
    print ("")
  else
    print ("\n  All checks passed\n")
  end
  return (errorlevel)
end

function checklvt (name, engine)
  local engine = engine or stdengine
  if testexists (name) then
    checkinit ()
    print ("Running checks on " .. name)
    runcheck (name, engine)
    if fileexists (testdir .. "/" .. name .. "." .. engine .. os_diffext) then
      print ("  Check fails with diff file")
      print (
        "  " .. testdir .. os_dirsep .. name .. "." .. engine .. os_diffext)
    else
      print ("  Check passes")
    end
  else
    print ("Test \"" .. name .. "\" not set up!")
  end
end

-- Remove all generated files
function clean ()
  cleandir (localdir)
  cleandir (testdir)
  cleandir (typesetdir)
  cleandir (unpackdir)
  for _,i in ipairs (cleanfiles) do
    rm (".", i)
  end
end

function bundleclean ()
  allmodules ("clean")
  for _,i in ipairs (cleanfiles) do
    rm (".", i)
  end
  rmdir (ctandir)
  rmdir (tdsdir)
end

-- Check commands are defined
function cmdcheck ()
  cleandir (localdir)
  cleandir (testdir)
  depinstall (checkdeps)
  local engine = string.gsub (stdengine, "tex$", "latex")
  print ("Checking source files")
  for _,i in ipairs (cmdchkfiles) do
    for _,j in ipairs (filelist (".", i)) do
      print ("  " .. stripext (j))
      os.execute (
          os_setenv .. " TEXINPUTS=." .. os_pathsep .. localdir ..
            (checksearch and os_pathsep or "") .. os_concat ..
          engine .. " " .. cmdchkopts .. " -output-directory=" .. testdir ..
            " \"\\PassOptionsToClass{check}{l3doc} \\input " .. j .. "\""
            .. " > " .. os_null
        )
      for line in io.lines (testdir .. "/" .. stripext (j) .. ".cmds") do
        if string.match (line, "^%!") then
          print ("   - " .. string.match (line, "^%! (.*)"))
        end
      end
    end
  end
end

function ctan (standalone)
  local function dirzip (dir, name)
    local zipname = name .. ".zip"
    local function tab_to_str (table)
      local string = ""
      for _,i in ipairs (table) do
        string = string .. " " .. "\"" .. i .. "\""
      end
      return string
    end
    -- Convert the tables of files to quoted strings
    local binfiles = tab_to_str (binaryfiles)
    local exclude = tab_to_str (excludefiles)
    -- First, zip up all of the text files
    run (
        dir,
        zipexe .. " " .. zipopts .. " -ll ".. zipname .. " " .. "." .. " -x"
          .. binfiles .. " " .. exclude
      )
    -- Then add the binary ones
    run (
        dir,
        zipexe .. " " .. zipopts .. " -g ".. zipname .. " " .. ". -i" ..
          binfiles .. " -x" .. exclude
      )
  end
  if standalone then
    clean ()
    bundle = module
  else
    bundleclean ()
  end
  mkdir (ctandir .. "/" .. bundle)
  mkdir (tdsdir)
  local errorlevel
  if standalone then
    errorlevel = bundlectan ()
  else
    errorlevel = allmodules ("bundlectan")
  end
  if errorlevel == 0 then
    for _,i in ipairs (txtfiles) do
      for _,j in ipairs (filelist (".", i)) do
        local function installtxt (name, dir)
          cp (name, ".", dir)
          ren (dir, name, stripext (name))
        end
        installtxt (j, ctandir .. "/" .. bundle)
        installtxt (j, tdsdir .. "/doc/" .. tdsroot .. "/" .. bundle)
      end
    end
    dirzip (tdsdir, bundle .. ".tds")
    cp (bundle .. ".tds.zip", tdsdir, ctandir)
    dirzip (ctandir, bundle)
    cp (bundle .. ".zip", ctandir, ".")
  else
    print ("\n====================")
    print ("Zip creation failed!")
    print ("====================\n")
  end
end

function bundlectan ()
  local function install (source, dest, files, ctan)
    local installdir  = tdsdir .. "/"  .. dest .. "/" .. moduledir
    mkdir (installdir)
    for _,i in ipairs (files) do
      if ctan then
        cp (i, source, ctandir .. "/" .. bundle)
      end
      cp (i, source, installdir)
    end
  end
  unpack ()
  install (unpackdir, "tex", installfiles, false)
  local errorlevel = doc ()
  if errorlevel == 0 then
    -- Convert input names for typesetting into names of PDF files
    local pdffiles = { }
    for _,i in ipairs (typesetfiles) do
      table.insert (pdffiles, (string.gsub (i, "%.%w+$", ".pdf")))
    end
    install (".", "doc", pdffiles, true)
    install (".", "doc", demofiles, true)
    install (".", "source", typesetfiles, true)
    install (".", "source", sourcefiles, true)
  end
  return (errorlevel)
end

-- Typeset all required documents
-- This function has several sub-parts, but as most are not needed anywhere
-- else everything is done locally within the main function
function doc ()
  local function typeset (file)
    local name = stripext (file)
    -- A couple of short functions to deal with the repeated steps in a
    -- clear way
    local function index (name)
      run (
          typesetdir ,
          "makeindex -s gind.ist -o " .. name .. ".ind " .. name .. ".idx"
        )
    end
    local function typeset (file)
      local errorlevel =
        os.execute (
            os_setenv .. " TEXINPUTS=" .. typesetdir .. 
              os_pathsep .. localdir .. (typesetsearch and os_pathsep or "") ..
              os_concat ..
            typesetexe .. " " .. typesetopts .. 
              " -output-directory=" .. typesetdir ..
              " \"" .. typesetcmds .. 
              "\\input " .. typesetdir .. "/" .. file .. "\""
          )
      return errorlevel
    end
    os.remove (name .. ".pdf")
    print ("Typesetting " .. name)
    local errorlevel = typeset (file)
    if errorlevel ~= 0 then
      print (" ! Compilation failed")
      return (errorlevel)
    else
      for i = 1, 2 do -- Do twice
        index (name)
        typeset (file)
      end
      cp (name .. ".pdf", typesetdir, ".")
    end
    return (errorlevel)
  end
  -- Set up
  cleandir (localdir)
  mkdir (typesetdir)
  for _,i in ipairs (sourcefiles) do
    cp (i, ".", typesetdir)
  end
  for _,i in ipairs (typesetfiles) do
    cp (i, ".", typesetdir)
  end
  for _,i in ipairs (typesetsuppfiles) do
    cp (i, supportdir, localdir)
  end
  depinstall (typesetdeps)
  -- Main loop for doc creation
  for _,i in ipairs (typesetfiles) do
    for _,j in ipairs (filelist (".", i)) do
      local errorlevel = typeset (j)
      if errorlevel ~= 0 then
        return (errorlevel)
      end
    end
  end
  return 0
end

-- Unpack then install
function localinstall ()
  unpack ()
  for _,i in ipairs (installfiles) do
    cp (i, unpackdir, localdir)
  end
end

-- Locally install files: only deals with those extracted, not docs etc.
function install ()
  unpack ()
  kpse.set_program_name ("latex")
  local texmfhome = kpse.var_value ("TEXMFHOME")
  local installdir = texmfhome .. "/tex/" .. moduledir
  cleandir (installdir)
  for _,i in ipairs (installfiles) do
    cp (i, unpackdir, installdir)
  end
end

function savetlg (name, engine)
  local tlgfile = name .. (engine and ("." .. engine) or "") .. tlgext
  local newfile = name .. "." .. (engine or stdengine) .. logext
  if fileexists (testfiledir .. "/" .. name .. lvtext) then
    checkinit ()
    print ("Creating and copying " .. tlgfile)
    runtest (name, engine, false)
    ren (testdir, newfile, tlgfile)
    cp (tlgfile, testdir, testfiledir)
  else
    print (
      "Test input \"" .. testfiledir .. "/" .. name .. lvtext ..
        "\" not found"
      )
  end
end

-- Unpack the package files using an 'isolated' system: this requires
-- a copy of the 'basic' DocStrip program, which is used then removed
function unpack ()
  depinstall (unpackdeps)
  bundleunpack ()
end

-- Split off from the main unpack so it can be used on a bundle and not
-- leave only one modules files
function bundleunpack ()
  mkdir (unpackdir)
  mkdir (localdir)
  for _,i in ipairs (sourcefiles) do
    cp (i, ".", unpackdir)
  end
  for _,i in ipairs (unpacksuppfiles) do
    cp (i, supportdir, localdir)
  end
  for _,i in ipairs (unpackfiles) do
    for _,j in ipairs (filelist (unpackdir, i)) do
      -- Note this is all run from 'here' as otherwise the localdir var
      -- will not point to the correct place to find e.g. l3docstrip
      os.execute (
          -- Notice that os.execute is used from 'here' as this ensures that
          -- localdir points to the correct place: running 'inside'
          -- unpackdir would avoid the need for setting -output-directory
          -- but at the cost of needing to correct the relative position
          -- of localdir w.r.t. unpackdir
          os_setenv .. " TEXINPUTS=" .. unpackdir .. os_pathsep .. localdir ..
            (unpacksearch and os_pathsep or "") .. os_concat ..
          unpackexe .. " " .. unpackopts .. " -output-directory=" .. unpackdir
            .. " " .. unpackdir .. "/" .. j
        )
    end
  end
end

function version ()
  print ("\nl3build Release 2014-06-05")
end

--
-- The overall main function
--

function stdmain (target, file, engine)
  -- If the module name is empty, the script is running in a bundle:
  -- apart from ctan all of the targets are then just mappings
  if module == "" then
    -- Detect all of the modules
    modules = { }
    for entry in lfs.dir (".") do
      if entry ~= "." and entry ~= ".." then
        local attr = lfs.attributes (entry)
        assert (type (attr) == "table")
        if attr.mode == "directory" then
          table.insert (modules, entry)
        end
      end
    end
    if target == "doc" then
      allmodules ("doc")
    elseif target == "check" then
      local errorlevel = allmodules ("bundlecheck")
      if errorlevel ~=0 then
        print ("There were errors: checks halted!\n")
        os.exit (errorlevel)
      end
    elseif target == "clean" then
      bundleclean ()
    elseif target == "cmdcheck" and next (cmdchkfiles) ~= nil then
      allmodules ("cmdcheck")
    elseif target == "ctan" then
      ctan ()
    elseif target == "install" then
      allmodules ("install")
    elseif target == "unpack" then
      -- bundleunpack avoids cleaning out the dir, so do it once here
      cleandir (unpackdir)
      allmodules ("bundleunpack")
    elseif target == "version" then
      version ()
    else
      help ()
    end
  else
    if target == "bundleunpack" then -- 'Hidden' as only needed 'higher up'
      depinstall (unpackdeps)
      bundleunpack ()
    elseif target == "bundlecheck" then
      if testfiledir ~= "" then  -- Ignore if there are no testfiles
        local errorlevel = check ()
        os.exit (errorlevel)
      end
    elseif target == "bundlectan" then
      bundlectan ()
    elseif target == "doc" then
      doc ()
    elseif target == "check" and testfiledir ~= "" then
      check ()
    elseif target == "checklvt" and testfiledir ~= "" then
      if file then
        checklvt (file, engine)
      else
        help ()
      end
    elseif target == "clean" then
      clean ()
    elseif target == "cmdcheck" and next (cmdchkfiles) ~= nil then
      cmdcheck ()
    elseif target == "ctan" and bundle == "" then  -- Stand-alone module
      ctan (true)
    elseif target == "install" then
      install ()
    elseif target == "localinstall" then -- 'Hidden' target
      localinstall ()
    elseif target == "savetlg" and testfiledir ~= "" then
      if file then
        savetlg (file, engine)
      else
        help ()
      end
    elseif target == "unpack" then
      unpack ()
    elseif target == "version" then
      version ()
    else
      help ()
    end
  end
end

-- Allow main function to be disabled 'higher up'
main = main or stdmain

-- Call the main function
main (arg[1], arg[2], arg[3])

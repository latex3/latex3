-- Common material for LaTeX3 make scripts
-- Functions needed for both building single modules and bundles

-- Ensure the module exists: empty if not applicable
module = module or ""

-- Directory structure for the build system
-- Use Unix-style path separators
distribdir  = maindir .. "/distrib"

ctandir     = distribdir .. "/ctan"
moduledir   = "latex/" .. bundle .. "/" .. module
supportdir  = maindir .. "/support"
tdsdir      = distribdir .. "/tds"
testdir     = maindir .. "/test"
testfiledir = testfiledir or "testfiles" -- Set to "" to cancel any tests
unpackdir   = maindir .. "/unpacked"

-- File types for various operations
-- Use Unix-style globs
-- All of these may be set earlier, so a initialised conditionally
auxfiles     = auxfiles     or
  {
    "*.aux", "*.cmds", "*.glo", "*.gls", "*.hd", "*.idx", "*.ilg", "*.ind",
    "*.log", "*.out", "*.synctex.gz", "*.tmp", "*.toc", "*.xref"
  }
binaryfiles  = binaryfiles  or {"*.pdf", "*.zip"}
cleanfiles   = cleanfiles   or {"*.cls", "*.def", "*.pdf", "*.sty", "*.zip"}
excludefiles = excludefiles or {"*~"}             -- Any Emacs stuff
installfiles = installfiles or {"*.sty"}
txtfiles     = txtfiles     or {"*.markdown"}
typesetfiles = typesetfiles or {"*.dtx"}
unpackfiles  = unpackfiles  or {"*.dtx", "*.ins"} -- Files to copy for unpacking
unpacklist   = unpacklist   or {"*.ins"}          -- Files to actually unpack

-- Executable names plus following options
checkexe   = checkexe   or "pdflatex -interaction=batchmode"
typesetexe = typesetexe or "pdflatex -interaction=nonstopmode"
unpackexe  = unpackexe  or "tex"
zipexe     = "zip -v -r -X"

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
-- operations 'natively', and looping over individual files to apply for
-- example os.remove is not really attractive!

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
  os_setenv   = "set"
  os_windows  = true
else
  os_concat   = ";"
  os_diffext  = ".diff"
  os_diffexe  = "diff -c"
  os_null     = "/dev/null"
  os_setenv   = "export"
  os_windows  = false
end

-- File operations are aided by the LuaFileSystem module, which is available
-- within texlua
lfs = require ("lfs")

-- For cleaning out a directory, which also ensures that it exists
function cleandir (dir)
  mkdir (dir)
  local files = dir .. "/*"
  if os_windows then
    os.execute ("del /q " .. unix_to_win (files))
  else
    os.execute ("rm -rf " .. files)
  end
end

-- Copy files 'quietly'
function cp (source, dest)
  if os_windows then
    os.execute
      ("copy /y " .. unix_to_win (source) .. " " .. unix_to_win (dest) .. " > nul")
  else
    os.execute ("cp -f " .. source .. " " .. dest)
  end
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
function listfiles (path, glob)
  local files = { }
  for entry in lfs.dir (path) do
    if glob then
      if string.match (entry, glob_to_pattern (glob)) then
        table.insert (files, entry)
      end
    else
      table.insert (files, entry)
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
    os.execute
      ("ren " .. unix_to_win (dir) .. source .. " " .. dest)
  else
    os.execute ("mv " .. dir .. source .. " " .. dir .. dest)
  end
end

-- Remove file(s) based on a glob: done using the OS-dependent commands for
-- speed
function rm (glob)
  if os_windows then
    os.execute ("if exist " .. glob .. " del /q " .. glob)
  else
    os.execute ("rm -rf " .. glob)
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
    errorlevel = run (i, "texlua make.lua " .. target)
    if errorlevel > 0 then
      return (errorlevel)
    end
  end
  return (errorlevel)
end

-- Set up the check system files: needed for checking one or more tests and
-- for saving the test files
function checkinit ()
  unpack ()
  cleandir (testdir)
  for _,i in pairs (installfiles) do
    cp (unpackdir .. "/" .. i, testdir)
  end
  cp (supportdir .. "/regression-test.tex", testdir)
end

-- Remove auxiliary files, either all in the simple case or selectively if
-- a file name stem is given
function cleanaux (name)
  for _,i in ipairs (auxfiles) do
    if not name then
      rm (i)
    else
      rm (name .. string.gsub (i, "^.*%.", "."))
    end
  end
end

-- Convert the raw log file into one for comparison/storage: keeps only
-- the 'business' part from the tests and removes system-dependent stuff
function formatlog (logfile, newfile)
  local function killcheck (line)
    local line = line
      -- Skip lines containing file dates
      if string.match (line, "[^<]%d%d%d%d/%d%d/%d%d") then
        line = ""
      elseif
      -- Skip \openin/\openout lines in web2c 7.x
      -- As Lua doesn't allow "(in|out)", a slightly complex approach:
      -- do a substitution to check the line is exactly what is required!
        string.match
          (string.gsub (line, "^\\openin", "\\openout"), "^\\openout%d = ")
          then
          line = ""
      end
    return line
  end
    -- Substitutions to remove some non-useful changes
  local function normalize (line)
    local line = line
    -- Zap ./ at begin of filename
    line = string.gsub (line, "%(%.%/", "(")
    -- Normalise a case where fixing a TeX bug changes the message text
    line = string.gsub (line, "\\csname\\endcsname ", "\\csname\\endcsname")
    -- Zap "on line <num>" and replace with "on line ..."
    line = string.gsub (line, "on line %d*", "on line ...")
    return line
  end
  local newlog = ""
  local prestart = true
  local skipping = false
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
      line = killcheck (line)
      if not string.match (line, "^ *$") then
        newlog = newlog .. line .. "\n"
      end
    end
  end
  local newfile = io.open (newfile, "w")
  newfile:write (newlog)
  io.close (newfile)
end

-- Runs a single test: needs the name of the test rather than the .lvt file
function runcheck (name, hide)
  local difffile = name .. os_diffext
  local logfile  = name .. ".log"
  local lvtfile  = name .. ".lvt"
  local newfile  = name .. ".new.log"
  local tlgfile  = name .. ".tlg"
  cp (testfiledir .. "/" .. lvtfile, testdir)
  cp (testfiledir .. "/" .. tlgfile, testdir)
  run
    (
      testdir, checkexe .. " " .. lvtfile .. 
        (hide and (" > " .. os_null) or "")
    )
  formatlog (testdir .. "/" .. logfile, testdir .. "/" .. newfile)
  run
    (
      testdir,
      os_diffexe .. " " .. tlgfile .. " " .. newfile .. " > " .. difffile
    )
  -- A test to see if there was a difference. The two programs used give
  -- different results: diff leaves an empty file, fc gives a defined
  -- second line. The test is done to check both of those so there is no
  -- need to worry about OS at this stage.
  difffile  = testdir .. "/" .. difffile -- Add path to reduce repetition
  file = assert (io.open (difffile, "r"))
  io.input (file)
  a = io.read ("*line")  -- First line
  b = io.read ("*line")  -- Second line
  io.close (file)
  -- If there were no differences, remove the diff file
  if not a and not windows then
    -- First line null using Unix: the Windows test is a backup in case
    -- things died entirely
    os.remove (difffile)
  else
    if b == "FC: no differences encountered" then
      os.remove (difffile)
    end
  end
end

-- Strip the extension from a file name
function stripext (file)
  local name = string.gsub (file, "%..*$", "")
  return name
end

function testexists (test)
  if fileexists (testfiledir .. "/" .. test .. ".lvt")
    and fileexists (testfiledir .. "/" .. test .. ".tlg") then
    return true
  else
    return false
  end
end

-- Standard versions of the main targets for building modules

-- Simply print out how to use the build system
function help ()
  print ""
  if testfiledir ~= "" then
    print " make check           - run automated check system       "
  end
  if module ~= "" and testfiledir ~= "" then
    print " make checklvt <name> - check one test file <name>       "
  end
  if module == "" then
    print " make ctan            - create CTAN-ready archive        "
  end
  print " make doc             - runs all documentation files     "
  print " make clean           - clean out directory tree         "
  print " make localinstall    - install files in local texmf tree"
  if module ~= "" and testfiledir ~= "" then
    print " make savetlg <name>  - save test log for <name>         "
  end
  print " make unpack          - extract packages                 "
  print ""
end

function check ()
  checkinit ()
  print ("Running checks on")
  for _,i in ipairs (listfiles (testfiledir, "*.tlg")) do
    local name = stripext (i)
    print ("  " .. name)
    runcheck (name, true)
  end
  local failures = listfiles (testdir, "*" .. os_diffext)
  -- As listfiles always returns a table, the key here is whether there are any
  -- entries
  if failures[1] then
    print ("\n  Check failed with difference files")
    for _,i in ipairs (failures) do
      print ("  - " .. i)
    end
    print ("")
    return 1
  else
    print ("\n  All checks passed\n")
    return 0
  end
end

function checklvt (name)
  if testexists (name) then
    checkinit ()
    print ("Running checks on " .. name)
    runcheck (name)
    if fileexists (testdir .. "/" .. name .. os_diffext) then
      print ("  Check fails")
    else
      print ("  Check passes")
    end
  else
    print ("Test \"" .. name .. "\" not set up!")
  end
end

-- Remove all generated files
function clean ()
  cleandir (unpackdir)
  cleandir (testdir)
  if modules == "" then -- Clean up fully for bundles
    cleandir (ctandir)
    cleandir (tdsdir)
  end
  cleanaux ()
  for _,i in ipairs (cleanfiles) do
    rm (i)
  end
end

function ctan ()
  local function dirzip (dir, name)
    local zipname = name .. ".zip"
    local function tab_to_str (table)
      local string = ""
      for _,i in pairs (table) do
        string = string .. " " .. "\"" .. i .. "\""
      end
      return string
    end
    -- Convert the tables of files to quoted strings
    local binfiles = tab_to_str (binaryfiles)
    local exclude = tab_to_str (excludefiles)
    -- First, zip up all of the text files
    run
      (
        dir,
        zipexe .. " -ll ".. zipname .. " " .. "." .. " -x" .. binfiles
          .. " " .. exclude
      )
    -- Then add the binary ones
    run
      (
        dir,
        zipexe .. " -g ".. zipname .. " " .. ". -i" .. binfiles .. " -x"
          .. exclude
      )
    cp (dir .. "/" .. zipname, ".")
  end
  clean ()
  mkdir (ctandir .. "/" .. bundle)
  mkdir (tdsdir)
  allmodules ("bundlectan")
  dirzip (tdsdir, bundle .. ".tds")
  cp (tdsdir .. "/" .. bundle .. ".tds.zip", ctandir)
  local bundledir = ctandir .. "/" .. bundle
  cp ("README.markdown", bundledir)
  ren (bundledir, "README.markdown", "README")
  dirzip (ctandir, bundle)
end

function bundlectan ()
  local function install (source, dest, files, ctan)
    local installdir  = tdsdir .. "/"  .. dest .. "/" .. moduledir
    mkdir (installdir)
    for _,i in pairs (files) do
      if ctan then
        cp (source .. "/" .. i, ctandir .. "/" .. bundle)
      end
      cp (source .. "/" .. i, installdir)
    end
  end
  unpack ()
  doc ()
  -- Convert input names for typesetting into names of PDF files
  local pdffiles = { }
  for _,i in pairs (typesetfiles) do
    table.insert (pdffiles, (string.gsub (i, "%.%w+$", ".pdf")))
  end
  install (".", "doc", pdffiles, true)
  install (".", "source", typesetfiles, true)
  install (".", "source", unpackfiles, true)
  install (unpackdir, "tex", installfiles, false)
end

-- Typeset all required documents
-- This function has several sub-parts, but as most are not needed anywhere
-- else everything is done locally within the main function
-- Notice that the first step taken is to remove all auxiliary files and
-- any existing PDF associated with the current file: this hopefully avoids
-- errors 'hanging about'
function doc ()
  local function typeset (file)
    local name = stripext (file)
    -- A couple of short functions to deal with the repeated steps in a
    -- clear way
    local function index (name)
      os.execute
        ("makeindex -s l3doc.ist -o " .. name .. ".ind " .. name .. ".idx")
    end
    local function typeset (file)
       local errorlevel = os.execute (typesetexe .. " " .. file)
       return errorlevel
    end
    cleanaux (name)
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
      cleanaux (name)
    end
    return (errorlevel)
  end
  -- Main loop for doc creation
  for _,i in ipairs (typesetfiles) do
    for _,j in ipairs (listfiles (".", i)) do
      local errorlevel = typeset (j)
      if errorlevel ~= 0 then
        return (errorlevel)
      end
    end
  end
end

-- Locally install files: only deals with those extracted, not docs etc.
function localinstall ()
  unpack ()
  -- The variable TEXMFHOME may not be set: if so, get the value using
  -- kpsewhich.
  local texmfhome = os.getenv ("TEXMFHOME")
  if not texmfhome then
    os.execute ("kpsewhich --var-value=TEXMFHOME > texmf.tmp")
    local tmp = assert (io.open ("texmf.tmp", "rb"))
    io.input (tmp)
    texmfhome = io.read ("*line")
    io.close (tmp)
    os.remove ("texmf.tmp")
  end
  local installdir = texmfhome .. "/tex/" .. moduledir
  cleandir (installdir)
  for _,i in pairs (installfiles) do
    cp (unpackdir .. "/" .. i, installdir)
  end
end

function savetlg (name)
  local difffile = name .. os_diffext
  local lvtfile  = name .. ".lvt"
  local tlgfile  = name .. ".tlg"
  if fileexists (testfiledir .. "/" .. lvtfile) then
    checkinit ()
    print ("Creating and copying " .. tlgfile)
    cp (testfiledir .. "/" .. lvtfile, testdir)
    run (testdir, checkexe .. " " .. lvtfile)
    formatlog (testdir .. "/" .. name .. ".log", testdir .. "/" .. tlgfile)
    cp (testdir .. "/" .. tlgfile, testfiledir)
  else
    print ("Test input \"" .. name .. "\" not found")
  end
end

-- Unpack the package files using an 'isolated' system: this requires
-- a copy of the 'basic' DocStrip program, which is used then removed
function unpack ()
  cleandir (unpackdir)
  bundleunpack ()
end

-- Split off from the main unpack so it can be used on a bundle and not
-- leave only one modules files
function bundleunpack ()
  for _,i in pairs (unpackfiles) do
    cp (i, unpackdir)
  end
  cp (supportdir .. "/docstrip.tex", unpackdir)
  for _,i in ipairs (unpacklist) do
    for _,j in ipairs (listfiles (unpackdir, i)) do
      run
       (
          unpackdir,
          -- Stop TeX system finding any files outside of current dir
--          os_setenv .. " TEXINPUTS=." .. os_concat ..
          unpackexe .. " " .. j
        )
    end
  end
  os.remove (unpackdir .. "/docstrip.tex")
end

--
-- The overall main function
--

function main (target, file)
  -- If the module name is empty, the script is running in a bundle:
  -- apart from ctan all of the targets are then just mappings
  if module == "" then
    if target == "doc" then
      allmodules ("doc")
    elseif target == "check" then
      local errorlevel = allmodules ("bundlecheck")
      if errorlevel > 0 then
        print ("There were errors: checks halted!\n")
        os.exit (errorlevel)
      end
    elseif target == "clean" then
      allmodules ("clean")
      for _,i in ipairs (cleanfiles) do
        rm (i)
      end
    elseif target == "ctan" then
      ctan ()
    elseif target == "localinstall" then
      allmodules ("localinstall")
    elseif target == "unpack" then
      -- bundleunpack avoids cleaning out the dir, so do it once here
      cleandir (unpackdir)
      allmodules ("bundleunpack")
    else
      help ()
    end
  else
    if target == "bundleunpack" then -- 'Hidden' as only needed 'higher up'
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
        checklvt (file)
      else
        help ()
      end
    elseif target == "clean" then
      clean ()
    elseif target == "localinstall" then
      localinstall ()
    elseif target == "savetlg" and testfiledir ~= "" then
      if file then
        savetlg (file)
      else
        help ()
      end
    elseif target == "unpack" then
      unpack ()
    else
      help ()
    end
  end
end

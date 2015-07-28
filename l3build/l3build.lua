--[[

  File l3build.lua (C) Copyright 2014-2015 The LaTeX3 Project

 It may be distributed and/or modified under the conditions of the
 LaTeX Project Public License (LPPL), either version 1.3c of this
 license or(at your option) any later version.  The latest version
 of this license is in the file

    http://www.latex-project.org/lppl.txt

 This file is part of the "l3build bundle" (The Work in LPPL)
 and all files in that bundle must be distributed together.

 The released version of this bundle is available from CTAN.

--]]

-- Version information: should be identical to that in l3build.dtx
release_date = "2015/06/25"
release_ver  = "5639"

-- "module" is a deprecated function in Lua 5.2: as we want the name
-- for other purposes, and it should eventually be 'free', simply
-- remove the built-in
if type(module) == "function" then
  module = nil
end

-- Ensure the module and bundle exist
module = module or ""
bundle = bundle or ""

-- Sanity check
if module == "" and bundle == "" then
  if string.match(arg[0], ".*l3build%.lua$") then
    print(
        "\n" ..
        "Error: Call l3build using a configuration file, not directly.\n"
      )
  else
    print(
      "\n" ..
      "Error: Specify either bundle or module in configuration script.\n"
      )
  end
  os.exit(1)
end

-- Directory structure for the build system
-- Use Unix-style path separators
maindir     = maindir or "."

-- Substructure for tests and support files
testfiledir = testfiledir or "testfiles" -- Set to "" to cancel any tests
testsuppdir = testsuppdir or testfiledir .. "/support"
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
  ctanpkg   = ctanpkg or module
else
  moduledir = tdsroot .. "/" .. bundle .. "/" .. module
  ctanpkg   = ctanpkg or bundle
end

-- File types for various operations
-- Use Unix-style globs
-- All of these may be set earlier, so a initialised conditionally
bibfiles         = bibfiles         or {"*.bib"}
binaryfiles      = binaryfiles      or {"*.pdf", "*.zip"}
bstfiles         = bstfiles         or {"*.bst"}
checkfiles       = checkfiles       or { }
checksuppfiles   = checksuppfiles   or { }
cmdchkfiles      = cmdchkfiles      or { }
cleanfiles       = cleanfiles       or {"*.log", "*.pdf", "*.zip"}
demofiles        = demofiles        or { }
docfiles         = docfiles         or { }
excludefiles     = excludefiles     or {"*~"}
installfiles     = installfiles     or {"*.sty"}
makeindexfiles   = makeindexfiles   or {"*.ist"}
readmefiles      = readmefiles      or {"README.md", "README.markdown", "README.txt"}
sourcefiles      = sourcefiles      or {"*.dtx", "*.ins"}
textfiles        = textfiles        or { }
typesetfiles     = typesetfiles     or {"*.dtx"}
typesetsuppfiles = typesetsuppfiles or { }
unpackfiles      = unpackfiles      or {"*.ins"}
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
checkengines = checkengines or {"pdftex", "xetex", "luatex"}
checkformat  = checkformat  or "latex"
stdengine    = stdengine    or "pdftex"

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

-- Additional settings to fine-tune typesetting
glossarystyle = glossarystyle or "gglo.ist"
indexstyle    = indexstyle    or "gind.ist"

-- Supporting binaries and options
biberexe      = biberexe      or "biber"
biberopts     = biberopts     or ""
bibtexexe     = bibtexexe     or "bibtex8"
bibtexopts    = bibtexopts    or "-W"
makeindexexe  = makeindexexe  or "makeindex"
makeindexopts = makeindexopts or ""

-- Other required settings
checkruns   = checkruns   or 1
packtdszip  = packtdszip  or false -- Not actually needed but clearer
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

  (c) 2008-2011 David Manura.  Licensed under the same terms as Lua(MIT).

  Permission is hereby granted, free of charge, to any person obtaining a copy
  of this software and associated documentation files(the "Software"), to deal
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
function glob_to_pattern(glob)

  local pattern = "^" -- pattern being built
  local i = 0 -- index in glob
  local char -- char at index i in glob

  -- escape pattern char
  local function escape(char)
    return string.match(char, "^%w$") and char or "%" .. char
  end

  -- Convert tokens.
  while true do
    i = i + 1
    char = string.sub(glob, i, i)
    if char == "" then
      pattern = pattern .. "$"
      break
    elseif char == "?" then
      pattern = pattern .. "."
    elseif char == "*" then
      pattern = pattern .. ".*"
    elseif char == "[" then
      -- Ignored
      print("[...] syntax not supported in globs!")
    elseif char == "\\" then
      i = i + 1
      char = string.sub(glob, i, i)
      if char == "" then
        pattern = pattern .. "\\$"
        break
      end
      pattern = pattern .. escape(char)
    else
      pattern = pattern .. escape(char)
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
if string.sub(package.config, 1, 1) == "\\" then
  os_concat   = "&"
  os_diffext  = ".fc"
  os_diffexe  = "fc /n"
  os_grepexe  = "findstr /r"
  os_null     = "nul"
  os_pathsep  = ";"
  os_setenv   = "set"
  os_windows  = true
  os_yes      = "for /l %I in(1,1,200) do @echo y"
else
  os_concat   = ";"
  os_diffext  = ".diff"
  os_diffexe  = "diff -c --strip-trailing-cr"
  os_grepexe  = "grep"
  os_null     = "/dev/null"
  os_pathsep  = ":"
  os_setenv   = "export"
  os_windows  = false
  os_yes      = "printf 'y\\n%.0s' {1..200}"
end

-- File operations are aided by the LuaFileSystem module, which is available
-- within texlua
lfs = require("lfs")

-- For cleaning out a directory, which also ensures that it exists
function cleandir(dir)
  mkdir(dir)
  rm(dir, "*")
end

-- Copy files 'quietly'
function cp(glob, source, dest)
  for _,i in ipairs(filelist(source, glob)) do
    local source = source .. "/" .. i
    if os_windows then
      os.execute(
          "copy /y " .. unix_to_win(source) .. " "
            .. unix_to_win(dest) .. " > nul"
        )
    else
      os.execute("cp -f " .. source .. " " .. dest)
    end
  end
end

-- OS-dependent test for a directory
function direxists(dir)
  local errorlevel
  if os_windows then
    errorlevel =
      os.execute("if not exist \"" .. unix_to_win(dir) .. "\" exit 1")
  else
    errorlevel = os.execute("[ -d " .. dir .. " ]")
  end
  if errorlevel ~= 0 then
    return false
  end
  return true
end

function fileexists(file)
  local f = io.open(file, "r")
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
function filelist(path, glob)
  local files = { }
  local pattern
  if glob then
    pattern = glob_to_pattern(glob)
  end
  if direxists(path) then
    for entry in lfs.dir(path) do
      if pattern then
        if string.match(entry, pattern) then
          table.insert(files, entry)
        end
      else
        if entry ~= "." and entry ~= ".." then
          table.insert(files, entry)
        end
      end
    end
  end
  return files
end

function mkdir(dir)
  if os_windows then
    -- Windows (with the extensions) will automatically make directory trees
    -- but issues a warning if the dir already exists: avoid by including a test
    local dir = unix_to_win(dir)
    os.execute("if not exist "  .. dir .. "\\nul " .. "mkdir " .. dir)
  else
    os.execute("mkdir -p " .. dir)
  end
end

-- Find the relationship between two directories
function relpath(target, source)
  -- A shortcut for the case where the two are the same
  if target == source then
    return ""
  end
  local resultdir = ""
  local trimpattern = "^[^/]*/"
  -- Trim off identical leading directories
  while 
    (string.match(target, trimpattern) or "X") ==
    (string.match(target, trimpattern) or "Y") do
    target = string.gsub(target, trimpattern, "")
    source = string.gsub(source, trimpattern, "")
  end
  -- Go up from the source 
  for i = 0, select(2, string.gsub(target, "/", "")) do
    resultdir = resultdir .. "../"
  end
  -- Return the relative part plus the unique part of the target
  return resultdir .. target
end

-- Rename
function ren(dir, source, dest)
  local dir = dir .. "/"
  if os_windows then
    os.execute("ren " .. unix_to_win(dir) .. source .. " " .. dest)
  else
    os.execute("mv " .. dir .. source .. " " .. dir .. dest)
  end
end

-- Remove file(s) based on a glob
function rm(source, glob)
  for _,i in ipairs(filelist(source, glob)) do
    os.remove(source .. "/" .. i)
  end
end

-- Remove a directory tree
function rmdir(dir)
  -- First, make sure it exists to avoid any errors
  mkdir(dir)
  if os_windows then
    os.execute("rmdir /s /q " .. unix_to_win(dir) )
  else
    os.execute("rm -r " .. dir)
  end
end

-- Run a command in a given directory
function run(dir, cmd)
  local errorlevel = os.execute("cd " .. dir .. os_concat .. cmd)
  return errorlevel
end

-- Deal with the fact that Windows and Unix use different path separators
function unix_to_win(path)
  local path = string.gsub(path, "/", "\\")
  return path
end

--
-- Auxiliary functions which are used by more than one main function
--

-- Do some subtarget for all modules in a bundle
function allmodules(target)
  local errorlevel = 0
  for _,i in ipairs(modules) do
    print(
        "Running script " .. scriptname .. " with target \"" .. target .. "\" for module "
          .. i
      )
    errorlevel = run(i, "texlua " .. scriptname .. " " .. target)
    if errorlevel > 0 then
      return errorlevel
    end
  end
  return errorlevel
end

-- Set up the check system files: needed for checking one or more tests and
-- for saving the test files
function checkinit()
  cleandir(testdir)
  depinstall(checkdeps)
  -- Copy dependencies to the test directory itself: this makes the paths
  -- a lot easier to manage, and is important for dealing with the log and
  -- with file input/output tests
  for _,i in ipairs(filelist(localdir)) do
    cp(i, localdir, testdir)
  end
  bundleunpack()
  for _,i in ipairs(installfiles) do
    cp(i, unpackdir, testdir)
  end
  for _,i in ipairs(checkfiles) do
    cp(i, unpackdir, testdir)
  end
  if direxists(testsuppdir) then
    for _,i in ipairs(filelist(testsuppdir)) do
      cp(i, testsuppdir, testdir)
    end
  end
  for _,i in ipairs(checksuppfiles) do
    cp(i, supportdir, testdir)
  end
end

-- Copy files to the main CTAN release directory
function copyctan()
  -- Do all of the copying in one go
  for _,i in ipairs(
      {
        bibfiles,
        demofiles,
        docfiles,
        pdffiles,
        sourcefiles,
        textfiles,
        typesetlist
      }
    ) do
    for _,j in ipairs(i) do
      cp(j, ".", ctandir .. "/" .. ctanpkg)
    end
  end
end

-- Copy files to the correct places in the TDS tree
function copytds()
  local function install(source, dest, files, tool)
    local moduledir = moduledir
    -- For material associated with secondary tools (BibTeX, MakeIndex)
    -- the structure needed is slightly different from those items going
    -- into the tex/doc/source trees
    if tool then
      -- "base" is reserved for the tools themselves: make the assumption
      -- in this case that the tdsroot name is the right place for stuff to
      -- go (really just for the team)
      if module == "base" then
        moduledir = tdsroot
      else
        moduledir = module
      end
    end
    local installdir = tdsdir .. "/" .. dest .. "/" .. moduledir
    -- Convert the file table(s) to a list of individual files
    local filenames = { }
    for _,i in ipairs(files) do
      for _,j in ipairs(i) do
        for _,k in ipairs(filelist(source, j)) do
          table.insert(filenames, k)
        end
      end
    end
    -- The target is only created if there are actual files to install
    if next(filenames) ~= nil then
      mkdir(installdir)
      for _,i in ipairs(filenames) do
        cp(i, source, installdir)
      end
    end
  end
  install(
    ".",
    "doc",
    {bibfiles, demofiles, docfiles, pdffiles, textfiles, typesetlist}
  )
  install(unpackdir, "makeindex", {makeindexfiles}, true)
  install(unpackdir, "bibtex/bst", {bstfiles}, true)
  install(".", "source", {sourcelist})
  install(unpackdir, "tex", {installfiles})
end

-- Unpack files needed to support testing/typesetting/unpacking
function depinstall(deps)
  for _,i in ipairs(deps) do
    print("Installing dependency: " .. i)
    run(i, "texlua " .. scriptname .. " unpack")
  end
end

-- Convert the raw log file into one for comparison/storage: keeps only
-- the 'business' part from the tests and removes system-dependent stuff
function formatlog(logfile, newfile)
  local function killcheck(line)
      -- Skip lines containing file dates
      if string.match(line, "[^<]%d%d%d%d/%d%d/%d%d") then
        return true
      elseif
      -- Skip \openin/\openout lines in web2c 7.x
      -- As Lua doesn't allow "(in|out)", a slightly complex approach:
      -- do a substitution to check the line is exactly what is required!
        string.match(
            string.gsub(line, "^\\openin", "\\openout"), "^\\openout%d%d? = "
          ) then
        return true
      end
    return false
  end
    -- Substitutions to remove some non-useful changes
  local function normalize(line)
    local line = line
    -- Remove test file name from lines
    -- This needs to extract the base name from the log name,
    -- and one to allow for the case that there might be "-" chars
    -- in the name (other cases are ignored)
    line = string.gsub(
      line,
      string.gsub(
        string.match("/" .. logfile, ".*/(.*)%" .. logext .. "$"),
        "-",
        "%%-"
      ),
      ""
    )
    -- Zap ./ at begin of filename
    line = string.gsub(line, "%(%.%/", "(")
    -- Zap paths if places other than 'here' are accessible
    if checksearch then
      line = string.gsub(line, "%(.*/([%w-]+%.[%w-]+)%s*$", "(../%1")
    end
    -- Zap map loading of map
    line = string.gsub(line, "%{[%w/%-]*/pdftex%.map%}", "")
    -- TeX90/XeTeX knows only the smaller set of dimension units
    line = string.gsub(
        line, "cm, mm, dd, cc, bp, or sp", "cm, mm, dd, cc, nd, nc, bp, or sp"
      )
    -- Normalise a case where fixing a TeX bug changes the message text
    line = string.gsub(line, "\\csname\\endcsname ", "\\csname\\endcsname")
    -- Zap "on line <num>" and replace with "on line ..."
    line = string.gsub(line, "on line %d*", "on line ...")
    -- Zap line numbers from \show, \showbox, \box_show and the like
    line = string.gsub(line, "^l%.%d+ ", "l. ...")
    -- Tidy up to ^^ notation
    for i = 1, 31, 1 do
      line = string.gsub(line, string.char(i), "^^" .. string.char(64 + i))
    end
    -- Remove spaces at the start of lines: deals with the fact that LuaTeX
    -- uses a different number to the other engines
    line = string.gsub(line, "^%s+", "")
    -- Unicode engines display chars in the upper half of the 8-bit range:
    -- tidy up to match pdfTeX
    local utf8 = unicode.utf8
    for i = 128, 255, 1 do
      line = string.gsub(line, utf8.char(i), "^^" .. string.format("%02x", i))
    end
    return line
  end
  local newlog = ""
  local prestart = true
  local skipping = false
  for line in io.lines(logfile) do
    if line == "START-TEST-LOG" then
      prestart = false
    elseif line == "END-TEST-LOG" then
      break
    elseif line == "OMIT" then
      skipping = true
    elseif line == "TIMO" then
      skipping = false
    elseif not prestart and not skipping and not killcheck(line) then
      line = normalize(line)
      if not string.match(line, "^ *$") then
        newlog = newlog .. line .. "\n"
      end
    end
  end
  local newfile = io.open(newfile, "w")
  io.output(newfile)
  io.write(newlog)
  io.close(newfile)
end

-- Additional normalization for LuaTeX
function formatlualog(logfile, newfile)
  local function normalize(line, lastline, dropping)
    local line = line
    -- Find discretionary lines skip: may get re-added
    if string.match(line, "^%.+\\discretionary$") then
      return "", line, false
    end
    -- Find whatsit lines skip: may get re-added
    if string.match(line, "^%.+\\whatsit$") then
      return "", line, false
    end
    -- Remove 'display' at end of display math boxes:
    -- LuaTeX omits this as it includes direction in all cases
    line = string.gsub(line, "(\\hbox%(.*), display$", "%1")
    -- Remove 'normal' direction information on boxes:
    -- any bidi/vertical stuff will still show
    line = string.gsub(line, ", direction TLT", "")
    -- Find glue setting and round out the last place
    line = string.gsub(
        line,
        "glue set(%-? ?)%d+.%d+fil$",
        "glue set %1" .. string.format(
            "%.4f", string.match(line, "glue set %-? ?(%d+.%d+)fil$") or 0
          )
          .. "fil"
      )
    -- Remove U+ notation in the "Missing character" message
    line = string.gsub(
        line,
        "Missing character: There is no(%^%^..) %(U%+(....)%)",
        "Missing character: There is no %1"
      )
    -- Where the last line was a discretionary, looks for the
    -- info one level in about what it represents
    if string.match(lastline, "^%.+\\discretionary$") then
      prefix = string.gsub(string.match(lastline, "^(%.+)"), "%.", "%%.")
      if string.match(line, prefix .. "%.") or
         string.match(line, prefix .. "%|") then
        return "", lastline, true
      else
        if dropping then
          -- End of a \discretionary block
          return line, "", false
        else
          -- A normal (TeX90) discretionary:
          -- add with the line break reintroduced
          return lastline .. "\n" .. line, ""
        end
      end
    end
    -- Much the same idea when the last line was a whatsit,
    -- but things are simpler in this case
    if string.match(lastline, "^%.+\\whatsit$") then
      prefix = string.gsub(string.match(lastline, "^(%.+)"), "%.", "%%.")
      if string.match(line, prefix .. "%.") then
        return "", lastline, true
      else
        -- End of a \whatsit block
        return line, "", false
      end
    end
    return line, lastline, false
  end
  local newlog = ""
  local lastline = ""
  local dropping = false
  for line in io.lines(logfile) do
    line, lastline, dropping = normalize(line, lastline, dropping)
    if not string.match(line, "^ *$") then
      newlog = newlog .. line .. "\n"
    end
  end
  local newfile = io.open(newfile, "w")
  io.output(newfile)
  io.write(newlog)
  io.close(newfile)
end

-- Look for files, directory by directory, and return the first existing
function locate(dirs, names)
  for _,i in ipairs(dirs) do
    for _,j in ipairs(names) do
      local path = i .. "/" .. j
      if fileexists(path) then
        return path
      end
    end
  end
end

-- List all modules
function listmodules()
  local modules = { }
  local exclmodules = exclmodules or { }
  for entry in lfs.dir(".") do
    if entry ~= "." and entry ~= ".." then
      local attr = lfs.attributes(entry)
      assert(type(attr) == "table")
      if attr.mode == "directory" then
        if not exclmodules[entry] then
          table.insert(modules, entry)
        end
      end
    end
  end
  return modules
end

-- Runs a single test: needs the name of the test rather than the .lvt file
-- One 'test' here may apply to multiple engines
function runcheck(name, engine, hide)
  local checkengines = checkengines
  if engine then
    checkengines = {engine}
  end
  local errorlevel = 0
  for _,i in ipairs(checkengines) do
    cp(name .. tlgext, testfiledir, testdir)
    runtest(name, i, hide)
    local testname = name .. "." .. i
    local difffile = testdir .. "/" .. testname .. os_diffext
    local newfile  = testdir .. "/" .. testname .. logext
    -- Use engine-specific file if available
    local tlgfile  = locate(
      {testfiledir, unpackdir},
      {name ..  "." .. i .. tlgext, name .. tlgext}
    )
    if not tlgfile then
      print("Error: failed to find " .. tlgext .. " file for " .. name .. "!")
      os.exit(1)
    end
    if os_windows then
      tlgfile = unix_to_win(tlgfile)
    end
    local errlevel
    -- Do additional log formatting if the engine is LuaTeX, there is no
    -- LuaTeX-specific .tlg file and the default engine is not LuaTeX
    if i == "luatex"
      and tlgfile ~= name ..  "." .. i .. tlgext
      and stdengine ~= "luatex" then
      local luatlgfile = testdir .. "/" .. name .. ".luatex" ..  tlgext
      if os_windows then
        luatlgfile = unix_to_win(luatlgfile)
      end
      formatlualog(tlgfile, luatlgfile)
      formatlualog(newfile, newfile)
      errlevel = os.execute(
        os_diffexe .. " " .. luatlgfile .. " " .. newfile
          .. " > " .. difffile
      )      
    else
      errlevel = os.execute(
        os_diffexe .. " " .. tlgfile .. " " .. newfile .. " > " .. difffile
      )
    end
    if errlevel == 0 then
      os.remove(difffile)
    else
      errorlevel = errlevel
    end
  end
  return errorlevel
end

-- Run one of the test files: doesn't check the result so suitable for
-- both creating and verifying .tlg files
function runtest(name, engine, hide)
  local lvtfile = name .. lvtext
  cp(lvtfile, fileexists(testfiledir .. "/" .. lvtfile)
    and testfiledir or unpackdir, testdir)
  local engine = engine or stdengine
  -- Set up the format file name if it's one ending "...tex"
  local format
  if
    string.match(checkformat, "tex$") and
    not string.match(engine, checkformat) then
    format = " -fmt=" .. string.gsub(engine, "(.*)tex$", "%1") .. checkformat
  else
    format = ""
  end
  local logfile = testdir .. "/" .. name .. logext
  local newfile = testdir .. "/" .. name .. "." .. engine .. logext
  for i = 1, checkruns do
    run(
        testdir,
        -- No use of localdir here as the files get copied to testdir:
        -- avoids any paths in the logs
        os_setenv .. " TEXINPUTS=." .. (checksearch and os_pathsep or "")
          .. os_concat ..
        engine ..  format .. " " .. checkopts .. " " .. lvtfile
          .. (hide and(" > " .. os_null) or "")
      )
  end
  formatlog(logfile, newfile)
  -- Store secondary files for this engine
  for _,i in ipairs(filelist(testdir, name .. ".???")) do
    local ext = string.match(i, "%....")
    if ext ~= lvtext and ext ~= tlgext and ext ~= logext then
      if not fileexists(testsuppdir .. "/" .. i) then
        ren(
          testdir, i, string.gsub(
            i, string.gsub(name, "%-", "%%-"), name .. "." .. engine
          )
        )
      end
    end
  end
end

-- Strip the extension from a file name (if present)
function stripext(file)
  local name = string.match(file, "^(.*)%.")
  return name or file
end

-- Look for a test: could be in the testfiledir or the unpackdir
function testexists(test)
  return(locate({testfiledir, unpackdir}, {test .. lvtext}))
end

--
-- Auxiliary functions for typesetting: need to be generally available
--

-- An auxiliary used to set up the environmental variables
function runtool(envvar, command)
  return(
    run(
      typesetdir,
      os_setenv .. " " .. envvar .. "=." .. os_pathsep
        .. relpath(localdir, typesetdir)
        .. (typesetsearch and os_pathsep or "") ..
      os_concat ..
      command         
    )
  )
end

function biber(name)
  if fileexists(typesetdir .. "/" .. name .. ".bcf") then
    return(
      runtool("BIBINPUTS",  biberexe .. " " .. biberopts .. " " .. name)
    )
  end
  return 0
end

function bibtex(name)
  if fileexists(typesetdir .. "/" .. name .. ".aux") then
    -- LaTeX always generates an .aux file, so there is a need to
    -- look inside it for a \citation line
    local grep
    if os_windows then
      grep = "\\\\"
    else
     grep = "\\\\\\\\"
    end
    if run(
        typesetdir,
        os_grepexe .. " \"^" .. grep .. "citation{\" " .. name .. ".aux > "
          .. os_null
      ) + run(
        typesetdir,
        os_grepexe .. " \"^" .. grep .. "bibdata{\" " .. name .. ".aux > "
          .. os_null
      ) == 0 then
      return(
        -- Cheat slightly as we need to set two variables
        runtool(
          "BIBINPUTS",
          os_setenv .. " BSTINPUTS=." .. os_pathsep
            .. relpath(localdir, typesetdir)
            .. (typesetsearch and os_pathsep or "") ..
          os_concat .. 
          bibtexexe .. " " .. bibtexopts .. " " .. name
        )
      )
    end
  end
  return 0
end

function makeindex(name, inext, outext, logext, style)
  if fileexists(typesetdir .. "/" .. name .. inext) then
    return(
      runtool(
        "INDEXSTYLE",
        makeindexexe .. " " .. makeindexopts .. " "
          .. " -s " .. style .. " -o " .. name .. outext
          .. " -t " .. name .. logext .. " "  .. name .. inext
      )
    )
  end
  return 0
end

function tex(file)
  return(
    runtool(
      "TEXINPUTS",
      typesetexe .. " " .. typesetopts .. " \"" .. typesetcmds
        .. "\\input " .. file .. "\""
    )
  )
end

function typesetpdf(file)
  local name = stripext(file)
  print("Typesetting " .. name)
  local errorlevel = typeset(file)
  if errorlevel == 0 then
    os.remove(name .. ".pdf")
    cp(name .. ".pdf", typesetdir, ".")
  else
    print(" ! Compilation failed")
  end
  return errorlevel
end

typeset = typeset or function(file)
  local errorlevel = tex(file)
  if errorlevel ~= 0 then
    return errorlevel
  else
    local name = stripext(file)
    -- Return a non-zero errorlevel if something goes wrong
    -- without having loads of nested tests
    return(
      biber(name)  +
      bibtex(name) +
      makeindex(name, ".glo", ".gls", ".glg", glossarystyle) +
      makeindex(name, ".idx", ".ind", ".ilg", indexstyle)    +
      tex(file) +
      tex(file)
    )
  end
end

-- Standard versions of the main targets for building modules

-- Simply print out how to use the build system
help = help or function()
  print ""
  if testfiledir ~= "" then
    print " build check                 - run all automated tests for all engines"
  end
  if module ~= "" and testfiledir ~= "" then
    print " build check <name>          - check one test file <name> for all engines"
    print " build check <name> <engine> - check one test file <name> for <engine>   "
  end
  print " build clean                 - clean out directory tree                  "
  if next(cmdchkfiles) ~= nil then
    print " build cmdcheck              - check commands documented are defined     "
  end
  if module == "" or bundle == "" then
    print " build ctan                  - create CTAN-ready archive                 "
  end
  print " build doc                   - runs all documentation files              "
  print " build install               - install files in local texmf tree         "
  if module ~= "" and testfiledir ~= "" then
    print " build save <name>           - save test log for <name> for all engines  "
    print " build save <name> <engine>  - save test log for <name> for <engine>     "
  end
  print ""
end

function check(name, engine)
  local errorlevel = 0
  if name then
    errorlevel = checklvt(name, engine)
  else
    errorlevel = checkall()
  end
  return errorlevel
end

function checkall()
  local errorlevel = 0
  if testfiledir ~= "" and direxists(testfiledir) then
    local function execute(name)
      local name = stripext(name)
      print("  " .. name)
      local errlevel = runcheck(name, nil, true)
      if errlevel ~= 0 then
        errorlevel = 1
      end
    end
    checkinit()
    print("Running checks on")
    for _,i in ipairs(filelist(testfiledir, "*" .. lvtext)) do
      execute(i)
    end
    for _,i in ipairs(filelist(unpackdir, "*" .. lvtext)) do
      if fileexists(testfiledir .. "/" .. i) then
        print("Duplicate test file: " .. i)
        errorlevel = 1
        break
      else
        execute(i)
      end
    end
    if errorlevel ~= 0 then
      checkdiff()
    else
      print("\n  All checks passed\n")
    end
  end
  return errorlevel
end

function checklvt(name, engine)
  checkinit()
  if testexists(name) then
    print("Running checks on " .. name)
    local errorlevel = runcheck(name, engine)
    if errorlevel ~= 0 then
      checkdiff()
    else
      if engine then
        print("  Check passes")
      else
        print("\n  All checks passed\n")
      end
    end
  else
    print("Test \"" .. name .. "\" not set up!")
  end
end

-- A short auxiliary to print the list of differences for check
function checkdiff()
  print("\n  Check failed with difference files")
  for _,i in ipairs(filelist(testdir, "*" .. os_diffext)) do
    print("  - " .. testdir .. "/" .. i)
  end
  print("")
end

-- Remove all generated files
function clean()
  -- To make sure that distribdir never contains any stray subdirs,
  -- it is entirely removed then recreated rather than simply deleting
  -- all of the files
  rmdir(distribdir)
  mkdir(distribdir)
  cleandir(localdir)
  cleandir(testdir)
  cleandir(typesetdir)
  cleandir(unpackdir)
  for _,i in ipairs(cleanfiles) do
    rm(".", i)
  end
end

function bundleclean()
  allmodules("clean")
  for _,i in ipairs(cleanfiles) do
    rm(".", i)
  end
  rmdir(ctandir)
  rmdir(tdsdir)
end

-- Check commands are defined
function cmdcheck()
  mkdir(localdir)
  cleandir(testdir)
  depinstall(checkdeps)
  local engine = string.gsub(stdengine, "tex$", "latex")
  local localdir = relpath(localdir, testdir)
  print("Checking source files")
  for _,i in ipairs(cmdchkfiles) do
    for _,j in ipairs(filelist(".", i)) do
      print("  " .. stripext(j))
      cp(j, ".", testdir)
      run(
        testdir,
        os_setenv .. " TEXINPUTS=." .. os_pathsep .. localdir
          .. os_pathsep ..
        os_concat ..
        engine .. " " .. cmdchkopts .. 
          " \"\\PassOptionsToClass{check}{l3doc} \\input " .. j .. "\""
          .. " > " .. os_null
      )
      for line in io.lines(testdir .. "/" .. stripext(j) .. ".cmds") do
        if string.match(line, "^%!") then
          print("   - " .. string.match(line, "^%! (.*)"))
        end
      end
    end
  end
end

function ctan(standalone)
  local function dirzip(dir, name)
    local zipname = name .. ".zip"
    local function tab_to_str(table)
      local string = ""
      for _,i in ipairs(table) do
        string = string .. " " .. "\"" .. i .. "\""
      end
      return string
    end
    -- Convert the tables of files to quoted strings
    local binfiles = tab_to_str(binaryfiles)
    local exclude = tab_to_str(excludefiles)
    -- First, zip up all of the text files
    run(
        dir,
        zipexe .. " " .. zipopts .. " -ll ".. zipname .. " " .. "." .. " -x"
          .. binfiles .. " " .. exclude
      )
    -- Then add the binary ones
    run(
        dir,
        zipexe .. " " .. zipopts .. " -g ".. zipname .. " " .. ". -i" ..
          binfiles .. " -x" .. exclude
      )
  end
  local errorlevel
  if standalone then
    errorlevel = check()
    bundle = module
  else
    errorlevel = allmodules("bundlecheck")
  end
  if errorlevel == 0 then
    rmdir(ctandir)
    mkdir(ctandir .. "/" .. ctanpkg)
    rmdir(tdsdir)
    mkdir(tdsdir)
    if standalone then
      errorlevel = bundlectan()
    else
      errorlevel = allmodules("bundlectan")
    end
  else
    print("\n====================")
    print("Tests failed, zip stage skipped!")
    print("====================\n")
    return errorlevel
  end
  if errorlevel == 0 then
    for _,i in ipairs(readmefiles) do
      for _,j in ipairs(filelist(".", i)) do
        local function installtxt(name, dir)
          cp(name, ".", dir)
          ren(dir, name, stripext(name))
        end
        installtxt(j, ctandir .. "/" .. ctanpkg)
        installtxt(j, tdsdir .. "/doc/" .. tdsroot .. "/" .. bundle)
      end
    end
    dirzip(tdsdir, ctanpkg .. ".tds")
    if packtdszip then
      cp(ctanpkg .. ".tds.zip", tdsdir, ctandir)
    end
    dirzip(ctandir, ctanpkg)
    cp(ctanpkg .. ".zip", ctandir, ".")
  else
    print("\n====================")
    print("Typesetting failed, zip stage skipped!")
    print("====================\n")
  end
  return errorlevel
end

function bundlectan()
  -- Generate a list of individual file names excluding those in the second
  -- argument: the latter is a table
  local function excludelist(include, exclude)
    local includelist = { }
    local excludelist = { }
    for _,i in ipairs(exclude) do
      for _,j in ipairs(i) do
        for _,k in ipairs(filelist(".", j)) do
          excludelist[k] = true
        end
      end
    end
    for _,i in ipairs(include) do
      for _,j in ipairs(filelist(".", i)) do
        if not excludelist[j] then
          table.insert(includelist, j)
        end
      end
    end
    return includelist
  end
  unpack()
  local errorlevel = doc()
  if errorlevel == 0 then
    -- Work out what PDF files are available
    pdffiles = { }
    for _,i in ipairs(typesetfiles) do
      table.insert(pdffiles, (string.gsub(i, "%.%w+$", ".pdf")))
    end
    typesetlist = excludelist(typesetfiles, {sourcefiles})
    sourcelist = excludelist(
      sourcefiles, {bstfiles, installfiles, makeindexfiles}
    )
    copyctan()
    copytds()
  end
  return errorlevel
end

-- Typeset all required documents
-- Uses a set of dedicated auxiliaries that need to be available to others
function doc()
  -- Set up
  cleandir(typesetdir)
  for _,i in ipairs({bibfiles, docfiles, sourcefiles, typesetfiles}) do
    for _,j in ipairs(i) do
      cp(j, ".", typesetdir)
    end
  end
  for _,i in ipairs(typesetsuppfiles) do
    cp(i, supportdir, typesetdir)
  end
  depinstall(typesetdeps)
  unpack()
  -- Main loop for doc creation
  for _,i in ipairs(typesetfiles) do
    for _,j in ipairs(filelist(".", i)) do
      local errorlevel = typesetpdf(j)
      if errorlevel ~= 0 then
        return errorlevel
      end
    end
  end
  return 0
end

-- Locally install files: only deals with those extracted, not docs etc.
function install()
  unpack()
  kpse.set_program_name("latex")
  local texmfhome = kpse.var_value("TEXMFHOME")
  local installdir = texmfhome .. "/tex/" .. moduledir
  cleandir(installdir)
  for _,i in ipairs(installfiles) do
    cp(i, unpackdir, installdir)
  end
end

function save(name, engine)
  local tlgfile = name .. (engine and("." .. engine) or "") .. tlgext
  local newfile = name .. "." .. (engine or stdengine) .. logext
  checkinit()
  if testexists(name) then
    print("Creating and copying " .. tlgfile)
    runtest(name, engine, false)
    ren(testdir, newfile, tlgfile)
    cp(tlgfile, testdir, testfiledir)
    if fileexists(unpackdir .. "/" .. tlgfile) then
      print(
        "Saved " .. tlgext
          .. " file overrides unpacked version of the same name"
      )
    end
  else
    print(
      "Test input \"" .. testfiledir .. "/" .. name .. lvtext
        .. "\" not found"
      )
  end
end

-- Unpack the package files using an 'isolated' system: this requires
-- a copy of the 'basic' DocStrip program, which is used then removed
function unpack()
  depinstall(unpackdeps)
  bundleunpack()
  for _,i in ipairs(installfiles) do
    cp(i, unpackdir, localdir)
  end
end

-- Split off from the main unpack so it can be used on a bundle and not
-- leave only one modules files
bundleunpack = bundleunpack or function()
  mkdir(localdir)
  cleandir(unpackdir)
  for _,i in ipairs(sourcefiles) do
    cp(i, ".", unpackdir)
  end
  for _,i in ipairs(unpacksuppfiles) do
    cp(i, supportdir, localdir)
  end
  for _,i in ipairs(unpackfiles) do
    for _,j in ipairs(filelist(unpackdir, i)) do
      -- This 'yes' business is needed to pass a series of "y\n" to
      -- TeX if \askforoverwrite is true
      -- That is all done using a file as it's the only way on Windows and
      -- on Unix the "yes" command can't be used inside os.execute (it never
      -- stops, which confuses Lua)
      os.execute(os_yes .. ">>" .. localdir .. "/yes")
      local localdir = relpath(localdir, unpackdir)
      run(
        unpackdir,
        os_setenv .. " TEXINPUTS=." .. os_pathsep
          .. localdir .. (unpacksearch and os_pathsep or "") ..
        os_concat ..
        unpackexe .. " " .. unpackopts .. " " .. j .. " < " 
          .. localdir .. "/yes"
      )
    end
  end
end

function version()
  print(
    "\nl3build Release " .. string.gsub(release_date, "/", "-") ..
    " (SVN r" .. release_ver .. ")\n"
  )
end

--
-- The overall main function
--

function stdmain(target, file, engine)
  local errorlevel
  -- If the module name is empty, the script is running in a bundle:
  -- apart from ctan all of the targets are then just mappings
  if module == "" then
    -- Detect all of the modules
    modules = modules or listmodules()
    if target == "doc" then
      errorlevel = allmodules("doc")
    elseif target == "check" then
      errorlevel = allmodules("bundlecheck")
      if errorlevel ~=0 then
        print("There were errors: checks halted!\n")
      end
    elseif target == "clean" then
      errorlevel = bundleclean()
    elseif target == "cmdcheck" and next(cmdchkfiles) ~= nil then
      errorlevel = allmodules("cmdcheck")
    elseif target == "ctan" then
      errorlevel = ctan()
    elseif target == "install" then
      errorlevel = allmodules("install")
    elseif target == "unpack" then
      errorlevel = allmodules("bundleunpack")
    elseif target == "version" then
      version()
    else
      help()
    end
  else
    if target == "bundleunpack" then -- 'Hidden' as only needed 'higher up'
      depinstall(unpackdeps)
      errorlevel = bundleunpack()
    elseif target == "bundlecheck" then
      errorlevel = check()
    elseif target == "bundlectan" then
      errorlevel = bundlectan()
    elseif target == "doc" then
      errorlevel = doc()
    elseif target == "check" and testfiledir ~= "" then
      errorlevel = check(file, engine)
    elseif target == "clean" then
      errorlevel = clean()
    elseif target == "cmdcheck" and next(cmdchkfiles) ~= nil then
      errorlevel = cmdcheck()
    elseif target == "ctan" and bundle == "" then  -- Stand-alone module
      errorlevel = ctan(true)
    elseif target == "install" then
      errorlevel = install()
    elseif target == "save" and testfiledir ~= "" then
      if file then
        errorlevel = save(file, engine)
      else
        help()
      end
    elseif target == "unpack" then
      unpack()
    elseif target == "version" then
      version()
    else
      help()
    end
  end
  os.exit(errorlevel)
end

-- Allow main function to be disabled 'higher up'
main = main or stdmain

-- Call the main function
main(arg[1], arg[2], arg[3])

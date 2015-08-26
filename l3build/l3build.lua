--[[

  File l3build.lua (C) Copyright 2014-2015 The LaTeX3 Project

 It may be distributed and/or modified under the conditions of the
 LaTeX Project Public License (LPPL), either version 1.3c of this
 license or (at your option) any later version.  The latest version
 of this license is in the file

    http://www.latex-project.org/lppl.txt

 This file is part of the "l3build bundle" (The Work in LPPL)
 and all files in that bundle must be distributed together.

 The released version of this bundle is available from CTAN.

--]]

-- Version information: should be identical to that in l3build.dtx
release_date = "2015/08/18"
release_ver  = "5866"

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
sourcefiles      = sourcefiles      or {"*.dtx", "*.ins"}
textfiles        = textfiles        or {"*.md", "*.txt"}
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
checkruns    = checkruns    or 1
packtdszip   = packtdszip   or false -- Not actually needed but clearer
scriptname   = scriptname   or "build.lua" -- Script used in each directory
typesetcmds  = typesetcmds  or ""

-- Extensions for various file types: used to abstract out stuff a bit
logext = logext or ".log"
lveext = lveext or ".lve"
lvtext = lvtext or ".lvt"
tlgext = tlgext or ".tlg"

-- Run time options
-- These are parsed into a global table, and all optional args
-- are made available as a related global var

function argparse()
  local result = { }
  local files  = { }
  local long_options =
    {
      engine              = "engine",
      ["halt-on-error"]   = "halt"  ,
      ["halt-on-failure"] = "halt"  ,
      help                = "help"
    }
  local short_options =
    {
      e = "engine",
      h = "help"  ,
      H = "halt"
    }
  local option_args =
    {
      engine = true ,
      halt   = false,
      help   = false
    }
  -- arg[1] is a special case: must be a command or "-h"/"--help"
  -- Deal with this by assuming help and storing only apparently-valid
  -- input
  local a = arg[1]
  result["target"] = "help"
  if a then
    -- No options are allowed in position 1, so filter those out
    if not string.match(a, "^%-") then
      result["target"] = a
    end
  end
  -- Stop here if help is required
  if result["target"] == "help" then
    return result
  end
  -- An auxiliary to grab all file names into a table
  local function remainder(num)
    local i
    local files = { }
    for i = num, #arg do
      table.insert(files, arg[i])
    end
    return files
  end
  -- Examine all other arguments
  -- Use a while loop rather than for as this makes it easier
  -- to grab arg for optionals where appropriate
  local i = 2
  while i <= #arg do
    local a = arg[i]
    -- Terminate search for options
    if a == "--" then
      files = remainder(i + 1)
      break
    end
    -- Look for optionals
    local opt, optarg
    local opts
    -- Look for and option and get it into a variable
    if string.match(a, "^%-") then
      if string.match(a, "^%-%-") then
        opts = long_options
        local pos = string.find(a, "=", 1, true)
        if pos then
          opt    = string.sub(a, 3, pos - 1)
          optarg = string.sub(a, pos + 1)
        else
          opt = string.sub(a,3)
        end
      else
        opts = short_options
        opt  = string.sub(a, 2, 2)
        -- Only set optarg if it is there
        if #a > 2 then
          optarg = string.sub(a, 3)
        end
      end
      -- Now check that the option is valid and sort out the argument
      -- if required
      local optname = opts[opt]
      if optname then
        local reqarg = option_args[optname]
        -- Tidy up arguments
        if reqarg and not optarg then
          optarg = arg[i + 1]
          if not optarg then
            io.stderr:write("Missing value for option " .. a .."\n")
            return {"help"}
          end
          i = i + 1
        end
        if not reqarg and optarg then
          io.stderr:write("Value not allowed for option " .. a .."\n")
          return {"help"}
        end
      else
        io.stderr:write("Unknown option " .. a .."\n")
        return {"help"}
      end
      -- Store the result
      if optarg then
        local opts = result[optname] or { }
        local match
        for match in string.gmatch(optarg, "([^,%s]+)") do
          table.insert(opts, match)
        end
        result[optname] = opts
      else
        result[optname] = true
      end
      i = i + 1
    end
    if not opt then
      files = remainder(i)
      break
    end
  end
  result["files"] = files
  return result
end

userargs = argparse()

optengines = userargs["engine"]
opthalt    = userargs["halt"]
opthelp    = userargs["help"]

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
  os_newline  = "\r\n"
  os_null     = "nul"
  os_pathsep  = ";"
  os_setenv   = "set"
  os_windows  = true
  os_yes      = "for /l %I in (1,1,200) do @echo y"
else
  os_concat   = ";"
  os_diffext  = ".diff"
  os_diffexe  = "diff -c --strip-trailing-cr"
  os_grepexe  = "grep"
  os_newline  = "\n"
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
  return os.execute("cd " .. dir .. os_concat .. cmd)
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
  local errorlevel
  for _,i in ipairs(modules) do
    print(
        "Running script " .. scriptname .. " with target \"" .. target .. "\" for module "
          .. i
      )
    local engines = ""
    if optengines then
      engines = " --engine=" .. table.concat(optengines, ",")
    end
    errorlevel = run(
      i, "texlua " .. scriptname .. " " .. target
        .. (opthalt and " -H" or "")
        .. engines
    )
    if errorlevel ~= 0 then
      return errorlevel
    end
  end
  return 0
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
  bundleunpack({".", testfiledir})
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
function formatlog(logfile, newfile, engine)
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
  local function normalize(line, maxprintline)
    -- Allow for wrapped lines: preserve the content and wrap
    if (string.len(line) == maxprintline) then
      lastline = (lastline or "") .. line
      return ""
    end
    local line = (lastline or "") .. line
    lastline = ""
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
    -- Tidy up to ^^ notation
    for i = 1, 31, 1 do
      line = string.gsub(line, string.char(i), "^^" .. string.char(64 + i))
    end
    -- Zap line numbers from \show, \showbox, \box_show and the like
    -- Two stages as line wrapping alters some of them and restore the break
    line = string.gsub(line, "^l%.%d+ ", "l. ...")
    line = string.gsub(line, "%.%.%.l%.%d+ ( *)%}$", "...\nl. ...%1}")
    -- Remove spaces at the start of lines: deals with the fact that LuaTeX
    -- uses a different number to the other engines
    line = string.gsub(line, "^%s+", "")
    -- Remove 'normal' direction information on boxes with (u)pTeX
    line = string.gsub(line, ", yoko direction", "")
    -- Unicode engines display chars in the upper half of the 8-bit range:
    -- tidy up to match pdfTeX
    local utf8 = unicode.utf8
    for i = 128, 255, 1 do
      line = string.gsub(line, utf8.char(i), "^^" .. string.format("%02x", i))
    end
    return line
  end
  local kpse = require("kpse")
  kpse.set_program_name(engine)
  local maxprintline = tonumber(kpse.expand_var("$max_print_line"))
  if engine == "luatex" then
    maxprintline = maxprintline + 1 -- Deal with an out-by-one error
  end
  local lastline = ""
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
    elseif not prestart and not skipping then
      line = normalize(line, maxprintline)
      if not string.match(line, "^ *$") and not killcheck(line) then
        newlog = newlog .. line .. os_newline
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
        "glue set (%-? ?)%d+.%d+fil$",
        "glue set %1" .. string.format(
            "%.4f", string.match(line, "glue set %-? ?(%d+.%d+)fil$") or 0
          )
          .. "fil"
      )
    -- Remove U+ notation in the "Missing character" message
    line = string.gsub(
        line,
        "Missing character: There is no (%^%^..) %(U%+(....)%)",
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
function runcheck(name, hide)
  local checkengines = checkengines
  if optengines then
    checkengines = optengines
  end
  local errorlevel = 0
  for _,i in ipairs(checkengines) do
    local testname = name .. "." .. i
    local difffile = testdir .. "/" .. testname .. os_diffext
    local newfile  = testdir .. "/" .. testname .. logext
    -- Use engine-specific file if available
    local tlgfile  = locate(
      {testfiledir, unpackdir},
      {testname .. tlgext, name .. tlgext}
    )
    if tlgfile then
      cp(name .. tlgext, testfiledir, testdir)
    else
      -- Attempt to generate missing test goal from expectation
      tlgfile = testdir .. "/" .. testname .. tlgext
      if not locate({unpackdir, testfiledir}, {name .. lveext}) then
        print(
          "Error: failed to find " .. tlgext .. " or "
          .. lveext .. " file for " .. name .. "!"
        )
        os.exit(1)
      end
      runtest(name, i, hide, lveext)
      ren(testdir, testname .. logext, testname .. tlgext)
    end
    runtest(name, i, hide, lvtext)
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
      if opthalt then
        checkdiff()
        return errlevel
      end
      errorlevel = errlevel
    end
  end
  return errorlevel
end

-- Run one of the test files: doesn't check the result so suitable for
-- both creating and verifying .tlg files
function runtest(name, engine, hide, ext)
  local lvtfile = name .. (ext or lvtext)
  cp(lvtfile, fileexists(testfiledir .. "/" .. lvtfile)
    and testfiledir or unpackdir, testdir)
  local engine = engine or stdengine
  -- Set up the format file name if it's one ending "...tex"
  local realengine = engine
  local format
  if
    string.match(checkformat, "tex$") and
    not string.match(engine, checkformat) then
    format = " -fmt=" .. string.gsub(engine, "(.*)tex$", "%1") .. checkformat
  else
    format = ""
  end
  -- Special casing for (u)pTeX LaTeX formats
  if
    string.match(checkformat, "^latex$") and
    string.match(engine, "^u?ptex$") then
    realengine = "e" .. engine
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
        realengine ..  format .. " " .. checkopts .. " " .. lvtfile
          .. (hide and (" > " .. os_null) or "")
      )
  end
  formatlog(logfile, newfile, engine)
  -- Store secondary files for this engine
  for _,i in ipairs(filelist(testdir, name .. ".???")) do
    local ext = string.match(i, "%....")
    if ext ~= lvtext and ext ~= tlgext and ext ~= lveext and ext ~= logext then
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
    errorlevel = biber(name) + bibtex(name)
    if errorlevel == 0 then
      local function cycle(name)
        return(
          makeindex(name, ".glo", ".gls", ".glg", glossarystyle) +
          makeindex(name, ".idx", ".ind", ".ilg", indexstyle)    +
          tex(file)
        )
      end
      errorlevel = cycle(name)
      if errorlevel ~= 0 then
        errorlevel = cycle(name)
      end
    end
    return errorlevel
  end
end

-- Standard versions of the main targets for building modules

-- Simply print out how to use the build system
help = help or function()
  print("usage: " .. arg[0] .. " <command> [<options>] [<names>]")
  print("")
  print("The most commonly used l3build commands are:")
  if testfiledir ~= "" then
    print("   check      Run all automated tests")
  end
  print("   clean      Clean out directory tree")
  if next(cmdchkfiles) ~= nil then
    print("   cmdcheck   Check commands documented are defined")
  end
  if module == "" or bundle == "" then
    print("   ctan       Create CTAN-ready archive")
  end
  print("   doc        Typesets all documentation files")
  print("   install    Installs files into the local texmf tree")
  if module ~= "" and testfiledir ~= "" then
    print("   save       Saves test validation log")
  end
  print("")
  print("Valid options are:")
  print("   --engine|-e         Sets the engine to use for running test")
  print("   --halt-on-error|-H  Stops running tests after the first failure")
  print("")
end

function check(names)
  local errorlevel = 0
  if testfiledir ~= "" and direxists(testfiledir) then
    checkinit()
    local hide = true
    if names and next(names) then
      hide = false
    end
    local i
    names = names or { }
    -- No names passed: find all test files
    if not next(names) then
      for _,i in pairs(filelist(testfiledir, "*" .. lvtext)) do
        table.insert(names, stripext(i))
      end
      for _,i in ipairs(filelist(unpackdir, "*" .. lvtext)) do
        if fileexists(testfiledir .. "/" .. i) then
          print("Duplicate test file: " .. i)
          return 1
        else
          table.insert(stripext(i))
        end
      end
    end
    -- Actually run the tests
    print("Running checks on")
    local name
    for _,name in ipairs(names) do
      print("  " .. name)
      local errlevel = runcheck(name, hide)
      -- Return value must be 1 not errlevel
      if errlevel ~= 0 then
        if opthalt then 
          return 1
        else
          errorlevel = 1
        end
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
  -- Always run tests for all engines
  optengines = nil
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
        zipexe .. " " .. zipopts .. " -ll ".. zipname .. " " .. "." 
          .. ( 
            (binfiles or  exclude) and (" -x" .. binfiles .. " " .. exclude)
            or ""
          )  
      )
    -- Then add the binary ones
    run(
        dir,
        zipexe .. " " .. zipopts .. " -g ".. zipname .. " " .. ". -i" ..
          binfiles .. (exclude and (" -x" .. exclude) or "")
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
    for _,i in ipairs(textfiles) do
      cp(i, ".", ctandir .. "/" .. ctanpkg)
      cp(i, ".", tdsdir .. "/doc/" .. tdsroot .. "/" .. bundle)
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
function doc(files)
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
      -- Allow for command line selection of files
      local typeset = true
      if files and next(files) then
        local k
        typeset = false
        for _,k in ipairs(files) do
          if k == stripext(j) then
            typeset = true
            break
          end
        end
      end
      if typeset then
        local errorlevel = typesetpdf(j)
        if errorlevel ~= 0 then
          return errorlevel
        end  
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

function save(names)
  checkinit()
  local engines = optengines or {stdengine}
  local name
  for _,name in pairs(names) do
    local engine
    for _,engine in pairs(engines) do
      local tlgengine = ((engine == stdengine and "") or "." .. engine)
      local tlgfile = name .. tlgengine .. tlgext
      local newfile = name .. "." .. engine .. logext
      if testexists(name) then
        print("Creating and copying " .. tlgfile)
        runtest(name, engine, false, lvtext)
        ren(testdir, newfile, tlgfile)
        cp(tlgfile, testdir, testfiledir)
        if fileexists(unpackdir .. "/" .. tlgfile) then
          print(
            "Saved " .. tlgext
              .. " file overrides unpacked version of the same name"
          )
        end
      elseif locate({unpackdir, testfiledir}, {name .. lveext}) then
        print(
          "Saved " .. tlgext .. " file overrides a "
            .. lveext .. " file of the same name"
        )
      else
        print(
          "Test input \"" .. testfiledir .. "/" .. name .. lvtext
            .. "\" not found"
          )
      end
    end
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
bundleunpack = bundleunpack or function(sourcedir)
  mkdir(localdir)
  cleandir(unpackdir)
  for _,i in ipairs(sourcedir or {"."}) do
    for _,j in ipairs(sourcefiles) do
      print(j, i, unpackdir)
      cp(j, i, unpackdir)
    end
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

function stdmain(target, files)
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
      errorlevel = doc(files)
    elseif target == "check" and testfiledir ~= "" then
      errorlevel = check(files)
    elseif target == "clean" then
      errorlevel = clean()
    elseif target == "cmdcheck" and next(cmdchkfiles) ~= nil then
      errorlevel = cmdcheck()
    elseif target == "ctan" and bundle == "" then  -- Stand-alone module
      errorlevel = ctan(true)
    elseif target == "install" then
      errorlevel = install()
    elseif target == "save" and testfiledir ~= "" then
      if next(files) then
        errorlevel = save(files)
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
main(userargs["target"], userargs["files"])

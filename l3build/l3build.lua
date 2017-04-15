--[[

File l3build.lua Copyright (C) 2014-2017 The LaTeX3 Project

It may be distributed and/or modified under the conditions of the
LaTeX Project Public License (LPPL), either version 1.3c of this
license or (at your option) any later version.  The latest version
of this license is in the file

   http://www.latex-project.org/lppl.txt

This file is part of the "l3build bundle" (The Work in LPPL)
and all files in that bundle must be distributed together.

-----------------------------------------------------------------------

The development version of the bundle can be found at

   https://github.com/latex3/latex3

for those people who are interested.

--]]

-- Version information
release_date = "2017/04/01"

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
  if string.match(arg[0], "l3build%.lua$") then
    print(
      "\n"
        .. "Error: Call l3build using a configuration file, not directly.\n"
    )
  else
    print(
      "\n"
        .. "Error: Specify either bundle or module in configuration script.\n"
    )
  end
  os.exit(1)
end

-- Directory structure for the build system
-- Use Unix-style path separators
maindir     = maindir or "."

-- Substructure for tests and support files
testfiledir = testfiledir or "testfiles"
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
versionfiles     = versionfiles     or {"*.dtx"}

-- Roots which should be unpacked to support unpacking/testing/typesetting
checkdeps   = checkdeps   or { }
typesetdeps = typesetdeps or { }
unpackdeps  = unpackdeps  or { }

-- Executable names plus following options
typesetexe = typesetexe or "pdflatex"
unpackexe  = unpackexe  or "tex"
zipexe     = zipexe     or "zip"

checkopts   = checkopts   or "-interaction=nonstopmode"
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
asciiengines = asciiengines or {"pdftex"}
checkruns    = checkruns    or 1
epoch        = epoch        or 1463734800
maxprintline = maxprintline or 79
packtdszip   = packtdszip   or false
scriptname   = scriptname   or "build.lua"
typesetcmds  = typesetcmds  or ""
versionform  = versionform  or ""

-- Extensions for various file types: used to abstract out stuff a bit
bakext = bakext or ".bak"
dviext = dviext or ".dvi"
logext = logext or ".log"
lveext = lveext or ".lve"
lvtext = lvtext or ".lvt"
pdfext = pdfext or ".pdf"
psext  = psext  or ".ps"
tlgext = tlgext or ".tlg"

-- File operations are aided by the LuaFileSystem module
local lfs = require("lfs")

-- Local access to functions
local ipairs           = ipairs
local print            = print
local select           = select
local tonumber         = tonumber
local close            = io.close
local lines            = io.lines
local open             = io.open
local output           = io.output
local stderr           = io.stderr
local write            = io.write
local set_program_name = kpse.set_program_name
local var_value        = kpse.var_value
local lfs_attributes   = lfs.attributes
local lfs_dir          = lfs.dir
local os_date          = os.date
local execute          = os.execute
local exit             = os.exit
local getenv           = os.getenv
local os_remove        = os.remove
local os_type          = os.type
local luatex_revision  = status.luatex_revision
local luatex_version   = status.luatex_version
local char             = string.char
local find             = string.find
local format           = string.format
local gmatch           = string.gmatch
local gsub             = string.gsub
local len              = string.len
local match            = string.match
local sub              = string.sub
local concat           = table.concat
local insert           = table.insert
local utf8_char        = unicode.utf8.char

-- Parse command line options
-- This is done as a function (rather than do ... end) as it allows early
-- termination (break)
local function argparse()
  local result = { }
  local files  = { }
  local long_options =
    {
      date                = "date"       ,
      engine              = "engine"     ,
      ["halt-on-error"]   = "halt"       ,
      ["halt-on-failure"] = "halt"       ,
      help                = "help"       ,
      pdf                 = "pdf"        ,
      quiet               = "quiet"      ,
      release             = "release"    ,
      testfiledir         = "testfiledir"
    }
  local short_options =
    {
      d = "date"       ,
      e = "engine"     ,
      h = "help"       ,
      H = "halt"       ,
      p = "pdf"        ,
      q = "quiet"      ,
      r = "release"    ,
      t = "testfiledir"
    }
  local option_args =
    {
      date        = true ,
      engine      = true ,
      halt        = false,
      help        = false,
      pdf         = false,
      quiet       = false,
      release     = true,
      testfiledir = true
    }
  local args = args
  -- arg[1] is a special case: must be a command or "-h"/"--help"
  -- Deal with this by assuming help and storing only apparently-valid
  -- input
  local a = arg[1]
  result["target"] = "help"
  if a then
    -- No options are allowed in position 1, so filter those out
    if not match(a, "^%-") then
      result["target"] = a
    end
  end
  -- Stop here if help is required
  if result["target"] == "help" then
    return result
  end
  -- An auxiliary to grab all file names into a table
  local function remainder(num)
    local files = { }
    for i = num, #arg do
      insert(files, arg[i])
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
    local opt
    local optarg
    local opts
    -- Look for and option and get it into a variable
    if match(a, "^%-") then
      if match(a, "^%-%-") then
        opts = long_options
        local pos = find(a, "=", 1, true)
        if pos then
          opt    = sub(a, 3, pos - 1)
          optarg = sub(a, pos + 1)
        else
          opt = sub(a, 3)
        end
      else
        opts = short_options
        opt  = sub(a, 2, 2)
        -- Only set optarg if it is there
        if #a > 2 then
          optarg = sub(a, 3)
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
            stderr:write("Missing value for option " .. a .."\n")
            return {"help"}
          end
          i = i + 1
        end
        if not reqarg and optarg then
          stderr:write("Value not allowed for option " .. a .."\n")
          return {"help"}
        end
      else
        stderr:write("Unknown option " .. a .."\n")
        return {"help"}
      end
      -- Store the result
      if optarg then
        local opts = result[optname] or { }
        for hit in gmatch(optarg, "([^,%s]+)") do
          insert(opts, hit)
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

options = argparse()

local optdate    = options["date"]
local optengines = options["engine"]
local opthalt    = options["halt"]
local optpdf     = options["pdf"]
local optquiet   = options["quiet"]
local optrelease = options["release"]

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
local function glob_to_pattern(glob)

  local pattern = "^" -- pattern being built
  local i = 0 -- index in glob
  local char -- char at index i in glob

  -- escape pattern char
  local function escape(char)
    return match(char, "^%w$") and char or "%" .. char
  end

  -- Convert tokens.
  while true do
    i = i + 1
    char = sub(glob, i, i)
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
      char = sub(glob, i, i)
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

-- Detect the operating system in use
-- Support items are defined here for cases where a single string can cover
-- both Windows and Unix cases: more complex situations are handled inside
-- the support functions
local os_ascii   = "echo \"\""
local os_cmpexe  = getenv("cmpexe") or "cmp"
local os_cmpext  = getenv("cmpext") or ".cmp"
local os_concat  = ";"
local os_diffext = getenv("diffext") or ".diff"
local os_diffexe = getenv("diffexe") or "diff -c --strip-trailing-cr"
local os_grepexe = "grep"
local os_newline = "\n"
local os_null    = "/dev/null"
local os_pathsep = ":"
local os_setenv  = "export"
local os_windows = false
local os_yes     = "printf 'y\\n%.0s' {1..200}"
if os_type == "windows" then
  os_ascii   = "@echo."
  os_cmpexe  = getenv("cmpexe") or "fc /b"
  os_cmpext  = getenv("cmpext") or ".cmp"
  os_concat  = "&"
  os_diffext = getenv("diffext") or ".fc"
  os_diffexe = getenv("diffexe") or "fc /n"
  os_grepexe = "findstr /r"
  os_newline = "\n"
  if tonumber(luatex_version) < 100 or
     (tonumber(luatex_version) == 100
       and tonumber(luatex_revision) < 4) then
    os_newline = "\r\n"
  end
  os_null    = "nul"
  os_pathsep = ";"
  os_setenv  = "set"
  os_windows = true
  os_yes     = "for /l %I in (1,1,200) do @echo y"
end

-- For cleaning out a directory, which also ensures that it exists
function cleandir(dir)
  local errorlevel = mkdir(dir)
  if errorlevel ~= 0 then
    return errorlevel
  end
  return rm(dir, "*")
end

-- Copy files 'quietly'
function cp(glob, source, dest)
  local errorlevel
  for _,i in ipairs(filelist(source, glob)) do
    local source = source .. "/" .. i
    if os_windows then
      if lfs_attributes(source)["mode"] == "directory" then
        errorlevel = execute(
          "xcopy /y /e /i " .. unix_to_win(source) .. " "
             .. unix_to_win(dest .. "/" .. i) .. " > nul"
        )
      else
        errorlevel = execute(
          "xcopy /y " .. unix_to_win(source) .. " "
             .. unix_to_win(dest) .. " > nul"
        )
      end
    else
      errorlevel = execute("cp -rf " .. source .. " " .. dest)
    end
    if errorlevel ~=0 then
      return errorlevel
    end
  end
  return 0
end

-- OS-dependent test for a directory
function direxists(dir)
  local errorlevel
  if os_windows then
    errorlevel =
      execute("if not exist \"" .. unix_to_win(dir) .. "\" exit 1")
  else
    errorlevel = execute("[ -d " .. dir .. " ]")
  end
  if errorlevel ~= 0 then
    return false
  end
  return true
end

function fileexists(file)
  local f = open(file, "r")
  if f ~= nil then
    close(f)
    return true
  else
    return false
  end
end

-- Generate a table containing all file names of the given glob or all files
-- if absent
function filelist(path, glob)
  local files = { }
  local pattern
  if glob then
    pattern = glob_to_pattern(glob)
  end
  if direxists(path) then
    for entry in lfs_dir(path) do
      if pattern then
        if match(entry, pattern) then
          insert(files, entry)
        end
      else
        if entry ~= "." and entry ~= ".." then
          insert(files, entry)
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
    return execute(
      "if not exist "  .. dir .. "\\nul " .. "mkdir " .. dir
    )
  else
    return execute("mkdir -p " .. dir)
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
    (match(target, trimpattern) or "X") ==
    (match(target, trimpattern) or "Y") do
    target = gsub(target, trimpattern, "")
    source = gsub(source, trimpattern, "")
  end
  -- Go up from the source
  for i = 0, select(2, gsub(target, "/", "")) do
    resultdir = resultdir .. "../"
  end
  -- Return the relative part plus the unique part of the target
  return resultdir .. target
end

-- Rename
function ren(dir, source, dest)
  local dir = dir .. "/"
  if os_windows then
    return execute("ren " .. unix_to_win(dir) .. source .. " " .. dest)
  else
    return execute("mv " .. dir .. source .. " " .. dir .. dest)
  end
end

-- Remove file(s) based on a glob
function rm(source, glob)
  for _,i in ipairs(filelist(source, glob)) do
    os_remove(source .. "/" .. i)
  end
  -- os_remove doesn't give a sensible errorlevel
  return 0
end

-- Remove a directory tree
function rmdir(dir)
  -- First, make sure it exists to avoid any errors
  mkdir(dir)
  if os_windows then
    return execute("rmdir /s /q " .. unix_to_win(dir))
  else
    return execute("rm -r " .. dir)
  end
end

-- Run a command in a given directory
function run(dir, cmd)
  return execute("cd " .. dir .. os_concat .. cmd)
end

-- Deal with the fact that Windows and Unix use different path separators
function unix_to_win(path)
  return gsub(path, "/", "\\")
end

--
-- Auxiliary functions which are used by more than one main function
--

-- Do some subtarget for all modules in a bundle
function allmodules(target)
  local date = ""
  if optdate then
    date = " --date=" .. optdate[1]
  end
  local engines = ""
  if optengines then
    engines = " --engine=" .. concat(optengines, ",")
  end
  local release = ""
  if optrelease then
    release = " --release=" .. optrelease[1]
  end
  for _,i in ipairs(modules) do
    print(
      "Running script " .. scriptname .. " with target \"" .. target
        .. "\" for module "
        .. i
    )
    local errorlevel = run(
      i,
      "texlua " .. scriptname .. " " .. target
        .. (opthalt and " -H" or "")
        .. date
        .. engines
        .. (optpdf and " -p" or "")
        .. (optquiet and " -q" or "")
        .. release
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
  execute(os_ascii .. ">" .. testdir .. "/ascii.tcx")
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
          insert(filenames, k)
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
  local errorlevel
  for _,i in ipairs(deps) do
    print("Installing dependency: " .. i)
    errorlevel = run(i, "texlua " .. scriptname .. " unpack -q")
    if errorlevel ~= 0 then
      return errorlevel
    end
  end
  return 0
end

-- Convert the raw log file into one for comparison/storage: keeps only
-- the 'business' part from the tests and removes system-dependent stuff
function formatlog(logfile, newfile, engine)
  local maxprintline = maxprintline
  if engine == "luatex" or engine == "luajittex" then
    maxprintline = maxprintline + 1 -- Deal with an out-by-one error
  end
  local function killcheck(line)
      -- Skip lines containing file dates
      if match(line, "[^<]%d%d%d%d/%d%d/%d%d") then
        return true
      elseif
      -- Skip \openin/\openout lines in web2c 7.x
      -- As Lua doesn't allow "(in|out)", a slightly complex approach:
      -- do a substitution to check the line is exactly what is required!
        match(
          gsub(line, "^\\openin", "\\openout"), "^\\openout%d%d? = "
        ) then
        return true
      end
    return false
  end
    -- Substitutions to remove some non-useful changes
  local function normalize(line, lastline)
    -- Zap line numbers from \show, \showbox, \box_show and the like:
    -- do this before wrapping lines
    line = gsub(line, "^l%.%d+ ", "l. ...")
    -- Also from lua stack traces.
    line = gsub(line, "lua:%d+: in function", "lua:...: in function")
    -- Allow for wrapped lines: preserve the content and wrap
    -- Skip lines that have an explicit marker for truncation
    if len(line) == maxprintline  and
       not match(line, "%.%.%.$") then
      return "", (lastline or "") .. line
    end
    local line = (lastline or "") .. line
    lastline = ""
    -- Remove test file name from lines
    -- This needs to extract the base name from the log name,
    -- and one to allow for the case that there might be "-" chars
    -- in the name (other cases are ignored)
    line = gsub(
      line,
      gsub(
        match("/" .. logfile, ".*/(.*)%" .. logext .. "$"),
        "-",
        "%%-"
      ),
      ""
    )
    -- Zap ./ at begin of filename
    line = gsub(line, "%(%.%/", "(")
    -- Zap paths if places other than 'here' are accessible
    if checksearch then
      local pattern = "%w?:?/[^ ]*/([^/%(%)]*%.%w*)"
      -- Files loaded from TeX: all start ( -- )
      line = gsub(line, "%(" .. pattern, "(../%1")
      -- luaotfload files start with keywords
      line = gsub(line, "from " .. pattern .. "%(", "from. ./%1(")
      line = gsub(line, ": " .. pattern .. "%)", ": ../%1)")
    end
    -- Deal with the fact that "(.aux)" may have still a leading space
    line = gsub(line, "^ %(%.aux%)", "(.aux)")
    -- Merge all of .fd data into one line so will be removed later
    if match(line, "^ *%([%.%/%w]+%.fd[^%)]*$") then
      lastline = (lastline or "") .. line
      return "", (lastline or "") .. line
    end
    -- TeX90/XeTeX knows only the smaller set of dimension units
    line = gsub(
      line,
      "cm, mm, dd, cc, bp, or sp", "cm, mm, dd, cc, nd, nc, bp, or sp"
    )
    -- Normalise a case where fixing a TeX bug changes the message text
    line = gsub(line, "\\csname\\endcsname ", "\\csname\\endcsname")
    -- Zap "on line <num>" and replace with "on line ..."
    -- Two similar cases, Lua patterns mean we need to do them separately
    line = gsub(line, "on line %d*", "on line ...")
    line = gsub(line, "on input line %d*", "on input line ...")
    -- Tidy up to ^^ notation
    for i = 0, 31 do
      line = gsub(line, char(i), "^^" .. char(64 + i))
    end
    -- Remove 'normal' direction information on boxes with (u)pTeX
    line = gsub(line, ",? yoko direction,?", "")
    -- Remove the \special line that in DVI mode keeps PDFs comparable
    if match(line, "^%.*\\special%{pdf: docinfo << /Creator") then
      return ""
    end
    -- Remove the \special line possibly present in DVI mode for paper size
    if match(line, "^%.*\\special%{papersize") then
      return ""
    end
    -- Remove ConTeXt stuff
    if match(line, "^backend         >") or
       match(line, "^close source    >") or
       match(line, "^mkiv lua stats  >") or
       match(line, "^pages           >") or
       match(line, "^system          >") or
       match(line, "^used file       >") or
       match(line, "^used option     >") or
       match(line, "^used structure  >") then
       return ""
    end
    -- A tidy-up to keep LuaTeX and other engines in sync
    line = gsub(line, utf8_char(127), "^^?")
    -- Unicode engines display chars in the upper half of the 8-bit range:
    -- tidy up to match pdfTeX if an ASCII engine is in use
    if next(asciiengines) then
      for i = 128, 255 do
        line = gsub(line, utf8_char(i), "^^" .. format("%02x", i))
      end
    end
    return line, lastline
  end
  local lastline = ""
  local newlog = ""
  local prestart = true
  local skipping = false
  -- Read the entire log file as a binary: deals with ^@/^[, etc.
  local file = assert(open(logfile, "rb"))
  local contents = gsub(file:read("*all") .. "\n", "\r\n", "\n")
  close(file)
  for line in gmatch(contents, "([^\n]*)\n") do
    if line == "START-TEST-LOG" then
      prestart = false
    elseif line == "END-TEST-LOG" then
      break
    elseif line == "OMIT" then
      skipping = true
    elseif match(line, "^%)?TIMO$") then
      skipping = false
    elseif not prestart and not skipping then
      line, lastline = normalize(line, lastline)
      if not match(line, "^ *$") and not killcheck(line) then
        newlog = newlog .. line .. os_newline
      end
    end
  end
  local newfile = open(newfile, "w")
  output(newfile)
  write(newlog)
  close(newfile)
end

-- Additional normalization for LuaTeX
function formatlualog(logfile, newfile)
  local function normalize(line, lastline, dropping)
    -- Find \discretionary or \whatsit lines:
    -- These may come back later
    if match(line, "^%.+\\discretionary$")                or
       match(line, "^%.+\\discretionary %(penalty 50%)$") or
       match(line, "^%.+\\discretionary50%|$")            or
       match(line, "^%.+\\discretionary50%| replacing $") or
       match(line, "^%.+\\whatsit$")                      then
      return "", line
    end
    -- For \mathon, we always need this line but the next
    -- may be affected
    if match(line, "^%.+\\mathon$") then
      return line, line
    end
    -- LuaTeX has a flexible output box
    line = gsub(line,"\\box\\outputbox", "\\box255")
    -- LuaTeX identifies spaceskip glue
    line = gsub(line,"%(\\spaceskip%) ", " ")
    -- Remove 'display' at end of display math boxes:
    -- LuaTeX omits this as it includes direction in all cases
    line = gsub(line, "(\\hbox%(.*), display$", "%1")
    -- Remove 'normal' direction information on boxes:
    -- any bidi/vertical stuff will still show
    line = gsub(line, ", direction TLT", "")
    -- Find glue setting and round out the last place
    local function round_digits(l, m)
      return gsub(
        l,
        m .. " (%-?)%d+%.%d+",
        m .. " %1"
          .. format(
            "%.3f",
            match(line, m .. " %-?(%d+%.%d+)") or 0
          )
      )
    end
    if match(line, "glue set %-?%d+%.%d+") then
      line = round_digits(line, "glue set")
    end
    if match(
        line, "glue %-?%d+%.%d+ plus %-?%d+%.%d+ minus %-?%d+%.%d+$"
      )
      then
      line = round_digits(line, "glue")
      line = round_digits(line, "plus")
      line = round_digits(line, "minus")
    end
    -- LuaTeX writes ^^M as a new line, which we lose
    line = gsub(line, "%^%^M", "")
    -- Remove U+ notation in the "Missing character" message
    line = gsub(
        line,
        "Missing character: There is no (%^%^..) %(U%+(....)%)",
        "Missing character: There is no %1"
      )
    -- A function to handle the box prefix part
    local function boxprefix(s)
      return gsub(match(s, "^(%.+)"), "%.", "%%.")
    end
    -- 'Recover' some discretionary data
    if match(lastline, "^%.+\\discretionary %(penalty 50%)$") and
       match(line, boxprefix(lastline) .. "%.= ") then
       return gsub(line, "%.= ", ""),""
    end
    -- Where the last line was a discretionary, looks for the
    -- info one level in about what it represents
    if match(lastline, "^%.+\\discretionary$")                or
       match(lastline, "^%.+\\discretionary %(penalty 50%)$") or
       match(lastline, "^%.+\\discretionary50%|$")            or
       match(lastline, "^%.+\\discretionary50%| replacing $") then
      local prefix = boxprefix(lastline)
      if match(line, prefix .. "%.") or
         match(line, prefix .. "%|") then
         if match(lastline, " replacing $") and
            not dropping then
           -- Modify the return line
           return gsub(line, "^%.", ""), lastline, true
         else
           return "", lastline, true
         end
      else
        if dropping then
          -- End of a \discretionary block
          return line, ""
        else
          -- Not quite a normal discretionary
          if match(lastline, "^%.+\\discretionary50%|$") then
            lastline =  gsub(lastline, "50%|$", "")
          end
          -- Remove some info that TeX90 lacks
          lastline = gsub(lastline, " %(penalty 50%)$", "")
          -- A normal (TeX90) discretionary:
          -- add with the line break reintroduced
          return lastline .. os_newline .. line, ""
        end
      end
    end
    -- Look for another form of \discretionary, replacing a "-"
    pattern = "^%.+\\discretionary replacing *$"
    if match(line, pattern) then
      return "", line
    else
      if match(lastline, pattern) then
        local prefix = boxprefix(lastline)
        if match(line, prefix .. "%.\\kern") then
          return gsub(line, "^%.", ""), lastline, true
        elseif dropping then
          return "", ""
        else
          return lastline .. os_newline .. line, ""
        end
      end
    end
    -- For \mathon, if the current line is an empty \hbox then
    -- drop it
    if match(lastline, "^%.+\\mathon$") then
      local prefix = boxprefix(lastline)
      if match(line, prefix .. "\\hbox%(0%.0%+0%.0%)x0%.0$") then
        return "", ""
      end
    end
    -- Various \local... things that other engines do not do:
    -- Only remove the no-op versions
    if match(line, "^%.+\\localpar$")                or
       match(line, "^%.+\\localinterlinepenalty=0$") or
       match(line, "^%.+\\localbrokenpenalty=0$")    or
       match(line, "^%.+\\localleftbox=null$")       or
       match(line, "^%.+\\localrightbox=null$")      then
       return "", ""
    end
    -- Older LuaTeX versions set the above up as a whatsit
    -- (at some stage this can therefore go)
    if match(lastline, "^%.+\\whatsit$") then
      local prefix = boxprefix(lastline)
      if match(line, prefix .. "%.") then
        return "", lastline, true
      else
        -- End of a \whatsit block
        return line, ""
      end
    end
    -- Wrap some cases that can be picked out
    -- In some places LuaTeX does use max_print_line, then we
    -- get into issues with different wrapping approaches
    if len(line) == maxprintline then
      return "", lastline .. line
    elseif len(lastline) == maxprintline then
      if match(line, "\\ETC%.%}$") then
        -- If the line wrapped at \ETC we might have lost a space
        return lastline
          .. ((match(line, "^\\ETC%.%}$") and " ") or "")
          .. line, ""
      elseif match(line, "^%}%}%}$") then
        return lastline .. line, ""
      else
        return lastline .. os_newline .. line, ""
      end
    -- Return all of the text for a wrapped (multi)line
    elseif len(lastline) > maxprintline then
      return lastline .. line, ""
    end
    -- Remove spaces at the start of lines: deals with the fact that LuaTeX
    -- uses a different number to the other engines
    return gsub(line, "^%s+", ""), ""
  end
  local newlog = ""
  local lastline = ""
  local dropping = false
  -- Read the entire log file as a binary: deals with ^@/^[, etc.
  local file = assert(open(logfile, "rb"))
  local contents = gsub(file:read("*all") .. "\n", "\r\n", "\n")
  close(file)
  for line in gmatch(contents, "([^\n]*)\n") do
    line, lastline, dropping = normalize(line, lastline, dropping)
    if not match(line, "^ *$") then
      newlog = newlog .. line .. os_newline
    end
  end
  local newfile = open(newfile, "w")
  output(newfile)
  write(newlog)
  close(newfile)
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
  for entry in lfs_dir(".") do
    if entry ~= "." and entry ~= ".." then
      local attr = lfs_attributes(entry)
      assert(type(attr) == "table")
      if attr.mode == "directory" then
        if not exclmodules[entry] then
          insert(modules, entry)
        end
      end
    end
  end
  return modules
end

-- Run one test which may have multiple engine-dependent comparisons
-- Should create a difference file for each failed test
function runcheck(name, hide)
  local checkengines = checkengines
  if optengines then
    checkengines = optengines
  end
  local errorlevel = 0
  for _,i in ipairs(checkengines) do
    -- Allow for luatex == luajittex for .tlg purposes
    local engine = i
    if i == "luajittex" then
      engine = "luatex"
    end
    checkpdf = setup_check(name, engine)
    runtest(name, i, hide, lvtext, checkpdf)
    -- Generation of results depends on test type
    local errlevel
    if checkpdf then
      errlevel = compare_pdf(name, engine)
    else
      errlevel = compare_tlg(name, engine)
    end
    if errlevel ~= 0 and opthalt then
      showfaileddiff()
      if errlevel ~= 0 then
        return 1
      end
    end
    if errlevel > errorlevel then
      errorlevel = errlevel
    end
  end
  return errorlevel
end

function setup_check(name, engine)
  local testname = name .. "." .. engine
  local pdffile = locate(
    {testfiledir, unpackdir},
    {testname .. pdfext, name .. pdfext}
  )
  local tlgfile = locate(
    {testfiledir, unpackdir},
    {testname .. tlgext, name .. tlgext}
  )
  -- Attempt to generate missing reference file from expectation
  if not (pdffile or tlgfile) then
    if not locate({unpackdir, testfiledir}, {name .. lveext}) then
      print(
        "Error: failed to find " .. pdfext .. ", " .. tlgext .. " or "
          .. lveext .. " file for " .. name .. "!"
      )
      exit(1)
    end
    runtest(name, engine, true, lveext, true)
    pdffile = testdir .. "/" .. testname .. pdfext
    -- If a PDF is generated use it for comparisons
    if not fileexists(pdffile) then
      pdffile = nil
      ren(testdir, testname .. logext, testname .. tlgext)
    end
  else
    -- Install comparison files found
    for _,v in pairs({pdffile, tlgfile}) do
      if v then
        cp(
          match(v, ".*/(.*)"),
          match(v, "(.*)/.*"),
          testdir
        )
      end
    end
  end
  if pdffile then
    local pdffile = match(pdffile, ".*/(.*)")
    ren(
      testdir,
      pdffile,
      gsub(pdffile, pdfext .. "$", ".ref" .. pdfext)
    )
    return true
  else
    return false
  end
end

function compare_pdf(name, engine)
  local errorlevel
  local testname = name .. "." .. engine
  local cmpfile    = testdir .. "/" .. testname .. os_cmpext
  local pdffile    = testdir .. "/" .. testname .. pdfext
  local refpdffile = locate(
    {testdir}, {testname .. ".ref" .. pdfext, name .. ".ref" .. pdfext}
  )
  if not refpdffile then
    return
  end
  if os_windows then
    refpdffile = unix_to_win(refpdffile)
  end
  errorlevel = execute(
    os_cmpexe .. " " .. refpdffile .. " " .. pdffile .. " > " .. cmpfile
  )
  if errorlevel == 0 then
    os_remove(cmpfile)
  end
  return errorlevel
end

function compare_tlg(name, engine)
  local errorlevel
  local testname = name .. "." .. engine
  local difffile = testdir .. "/" .. testname .. os_diffext
  local logfile  = testdir .. "/" .. testname .. logext
  local tlgfile  = locate({testdir}, {testname .. tlgext, name .. tlgext})
  if not tlgfile then
    return
  end
  if os_windows then
    tlgfile = unix_to_win(tlgfile)
  end
  -- Do additional log formatting if the engine is LuaTeX, there is no
  -- LuaTeX-specific .tlg file and the default engine is not LuaTeX
  if engine == "luatex"
    and not match(tlgfile, "%.luatex" .. "%" .. tlgext)
    and stdengine ~= "luatex"
    and stdengine ~= "luajittex"
    then
    local luatlgfile = testdir .. "/" .. name .. ".luatex" ..  tlgext
    if os_windows then
      luatlgfile = unix_to_win(luatlgfile)
    end
    formatlualog(tlgfile, luatlgfile)
    formatlualog(logfile, logfile)
    -- This allows code sharing below: we only need the .tlg name in one place
    tlgfile = luatlgfile
  end
  errorlevel = execute(
    os_diffexe .. " " .. tlgfile .. " " .. logfile .. " > " .. difffile
  )
  if errorlevel == 0 then
    os_remove(difffile)
  end
  return errorlevel
end

-- Run one of the test files: doesn't check the result so suitable for
-- both creating and verifying .tlg files
function runtest(name, engine, hide, ext, makepdf)
  local lvtfile = name .. (ext or lvtext)
  cp(lvtfile, fileexists(testfiledir .. "/" .. lvtfile)
    and testfiledir or unpackdir, testdir)
  local engine = engine or stdengine
  -- Set up the format file name if it's one ending "...tex"
  local realengine = engine
  local format
  if
    match(checkformat, "tex$") and
    not match(engine, checkformat) then
    format = " -fmt=" .. gsub(engine, "(.*)tex$", "%1") .. checkformat
  else
    format = ""
  end
  -- Special casing for e-LaTeX format
  if
    match(checkformat, "^latex$") and
    match(engine, "^etex$") then
    format = " -fmt=latex"
  end
  -- Special casing for (u)pTeX LaTeX formats
  if
    match(checkformat, "^latex$") and
    match(engine, "^u?ptex$") then
    realengine = "e" .. engine
  end
  -- Special casing for XeTeX engine
  local checkopts = checkopts
  if match(engine, "xetex") and not makepdf then
    checkopts = checkopts .. " -no-pdf"
  end
  -- Special casing for ConTeXt
  if match(checkformat, "^context$") then
    format = ""
    if engine == "luatex" or engine == "luajittex" then
      realengine = "context"
    elseif engine == "pdftex" then
      realengine = "texexec"
    elseif engine == "xetex" then
      realengine = "texexec --xetex"
    else
      print("Engine incompatible with format")
      exit(1)
    end
  end
  local logfile = testdir .. "/" .. name .. logext
  local newfile = testdir .. "/" .. name .. "." .. engine .. logext
  local asciiopt = ""
  for _,i in ipairs(asciiengines) do
    if realengine == i then
      asciiopt = "-translate-file ./ascii.tcx "
      break
    end
  end
  for i = 1, checkruns do
    run(
      testdir,
      -- No use of localdir here as the files get copied to testdir:
      -- avoids any paths in the logs
      os_setenv .. " TEXINPUTS=." .. (checksearch and os_pathsep or "")
        .. os_concat ..
      -- Avoid spurious output from (u)pTeX
      os_setenv .. " GUESS_INPUT_KANJI_ENCODING=0"
        .. os_concat ..
      -- Fix the time of the run
      os_setenv .. " SOURCE_DATE_EPOCH=" .. epoch
        .. os_concat ..
      os_setenv .. " SOURCE_DATE_EPOCH_TEX_PRIMITIVES=1"
        .. os_concat ..
      -- Ensure lines are of a known length
      os_setenv .. " max_print_line=" .. maxprintline
        .. os_concat ..
      realengine ..  format .. " "
        .. checkopts .. " " .. asciiopt .. lvtfile
        .. (hide and (" > " .. os_null) or "")
        .. os_concat ..
      runtest_tasks(stripext(lvtfile))
    )
  end
  if makepdf and fileexists(testdir .. "/" .. name .. dviext) then
    dvitopdf(name, testdir, engine, hide)
  end
  formatlog(logfile, newfile, engine)
  -- Store secondary files for this engine
  for _,i in ipairs(filelist(testdir, name .. ".???")) do
    local ext = match(i, "%....")
    if ext ~= lvtext and ext ~= tlgext and ext ~= lveext and ext ~= logext then
      if not fileexists(testsuppdir .. "/" .. i) then
        ren(
          testdir, i, gsub(
            i, gsub(name, "%-", "%%-"), name .. "." .. engine
          )
        )
      end
    end
  end
end

-- A hook to allow additional tasks to run for the tests
runtest_tasks = runtest_tasks or function(name)
  return ""
end

function dvitopdf(name, dir, engine, hide)
  if match(engine, "^u?ptex$") then
    run(
      dir,
      os_setenv .. " SOURCE_DATE_EPOCH=" .. epoch
        .. os_concat ..
     "dvipdfmx  " .. name .. dviext
       .. (hide and (" > " .. os_null) or "")
    )
  else
    run(
      dir,
      os_setenv .. " SOURCE_DATE_EPOCH=" .. epoch
        .. os_concat ..
     "dvips " .. name .. dviext
       .. (hide and (" > " .. os_null) or "")
       .. os_concat ..
     "ps2pdf " .. name .. psext
        .. (hide and (" > " .. os_null) or "")
    )
  end
end

-- Strip the extension from a file name (if present)
function stripext(file)
  local name = match(file, "^(.*)%.")
  return name or file
end

-- Strip the path from a file name (if present)
function basename(file)
  local name = match(file, "^.*/([^/]*)$")
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
  local name = stripext(basename(file))
  print("Typesetting " .. name)
  local errorlevel = typeset(file)
  if errorlevel == 0 then
    os_remove(name .. ".pdf")
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
    local name = stripext(basename(file))
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
      if errorlevel == 0 then
        errorlevel = cycle(name)
      end
    end
    return errorlevel
  end
end

-- Standard versions of the main targets for building modules

-- Simply print out how to use the build system
function help()
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
  print("   setversion Update version information in sources")
  print("")
  print("Valid options are:")
  print("   --date|-d           Sets the date to insert into sources")
  print("   --engine|-e         Sets the engine to use for running test")
  print("   --halt-on-error|-H  Stops running tests after the first failure")
  print("   --pdf|-p            Check/save PDF files")
  print("   --quiet|-q          Suppresses TeX output when unpacking")
  print("   --release|-r        Sets the release to insert into sources")
  print("   --testfiledir|-t    Selects the specified testfile location")
  print("")
  print("See l3build.pdf for further details.")
end

function check(names)
  local errorlevel = 0
  if testfiledir ~= "" and direxists(testfiledir) then
    checkinit()
    local hide = true
    if names and next(names) then
      hide = false
    end
    names = names or { }
    -- No names passed: find all test files
    if not next(names) then
      for _,i in pairs(filelist(testfiledir, "*" .. lvtext)) do
        insert(names, stripext(i))
      end
      for _,i in ipairs(filelist(unpackdir, "*" .. lvtext)) do
        if fileexists(testfiledir .. "/" .. i) then
          print("Duplicate test file: " .. i)
          return 1
        else
          insert(names, stripext(i))
        end
      end
    end
    -- Actually run the tests
    print("Running checks on")
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
  for _,i in ipairs(filelist(testdir, "*" .. os_cmpext)) do
    print("  - " .. testdir .. "/" .. i)
  end
  print("")
end

function showfaileddiff()
  print("\nCheck failed with difference file")
  for _,i in ipairs(filelist(testdir, "*" .. os_diffext)) do
    print("  - " .. testdir .. "/" .. i)
    print("")
    local f = open(testdir .. "/" .. i,"r")
    local content = f:read("*all")
    f:close()
    print("-----------------------------------------------------------------------------------")
    print(content)
    print("-----------------------------------------------------------------------------------")
  end
  for _,i in ipairs(filelist(testdir, "*" .. os_cmpext)) do
    print("  - " .. testdir .. "/" .. i)
  end
end

-- Remove all generated files
function clean()
  -- To make sure that distribdir never contains any stray subdirs,
  -- it is entirely removed then recreated rather than simply deleting
  -- all of the files
  local errorlevel =
    rmdir(distribdir)    +
    mkdir(distribdir)    +
    cleandir(localdir)   +
    cleandir(testdir)    +
    cleandir(typesetdir) +
    cleandir(unpackdir)
  for _,i in ipairs(cleanfiles) do
    errorlevel = rm(".", i) + errorlevel
  end
  return errorlevel
end

function bundleclean()
  local errorlevel = allmodules("clean")
  for _,i in ipairs(cleanfiles) do
    errorlevel = rm(".", i) + errorlevel
  end
  return (
    errorlevel     +
    rmdir(ctandir) +
    rmdir(tdsdir)
  )
end

-- Check commands are defined
function cmdcheck()
  mkdir(localdir)
  cleandir(testdir)
  depinstall(checkdeps)
  for _,i in ipairs({bibfiles, docfiles, sourcefiles, typesetfiles}) do
    for _,j in ipairs(i) do
      cp(j, ".", testdir)
    end
  end
  for _,i in ipairs(typesetsuppfiles) do
    cp(i, supportdir, testdir)
  end
  local engine = gsub(stdengine, "tex$", "latex")
  local localdir = relpath(localdir, testdir)
  print("Checking source files")
  for _,i in ipairs(cmdchkfiles) do
    for _,j in ipairs(filelist(".", i)) do
      print("  " .. stripext(j))
      run(
        testdir,
        os_setenv .. " TEXINPUTS=." .. os_pathsep .. localdir
          .. os_pathsep ..
        os_concat ..
        engine .. " " .. cmdchkopts ..
          " \"\\PassOptionsToClass{check}{l3doc} \\input " .. j .. "\""
          .. " > " .. os_null
      )
      for line in lines(testdir .. "/" .. stripext(j) .. ".cmds") do
        if match(line, "^%!") then
          print("   - " .. match(line, "^%! (.*)"))
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
          (binfiles or exclude) and (" -x" .. binfiles .. " " .. exclude)
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
      for _,j in pairs({unpackdir, "."}) do
        cp(i, j, ctandir .. "/" .. ctanpkg)
        cp(i, j, tdsdir .. "/doc/" .. tdsroot .. "/" .. bundle)
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
          insert(includelist, j)
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
      insert(pdffiles, (gsub(i, "%.%w+$", ".pdf")))
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
    for _, dir in ipairs({unpackdir, typesetdir}) do
      for _,j in ipairs(filelist(dir, i)) do
        -- Allow for command line selection of files
        local typeset = true
        if files and next(files) then
          typeset = false
          for _,k in ipairs(files) do
            if k == stripext(j) then
              typeset = true
              break
            end
          end
        end
        if typeset then
          local errorlevel = typesetpdf(relpath(dir, ".") .. "/" .. j)
          if errorlevel ~= 0 then
            return errorlevel
          end
        end
      end
    end
  end
  return 0
end

-- Locally install files: only deals with those extracted, not docs etc.
function install()
  local errorlevel = unpack()
  if errorlevel ~= 0 then
    return errorlevel
  end
  set_program_name("latex")
  local texmfhome = var_value("TEXMFHOME")
  local installdir = texmfhome .. "/tex/" .. moduledir
  errorlevel = cleandir(installdir)
  if errorlevel ~= 0 then
    return errorlevel
  end
  for _,i in ipairs(installfiles) do
    errorlevel = cp(i, unpackdir, installdir)
    if errorlevel ~= 0 then
      return errorlevel
    end
  end
  return 0
end

function save(names)
  checkinit()
  local engines = optengines or {stdengine}
  for _,name in pairs(names) do
    local engine
    for _,engine in pairs(engines) do
      local tlgengine = ((engine == stdengine and "") or "." .. engine)
      local tlgfile  = name .. tlgengine .. tlgext
      local spdffile = name .. tlgengine .. pdfext
      local newfile  = name .. "." .. engine .. logext
      local pdffile  = name .. "." .. engine .. pdfext
      local refext = ((optpdf and pdfext) or tlgext)
      if testexists(name) then
        print("Creating and copying " .. refext)
        runtest(name, engine, false, lvtext, optpdf)
        if optpdf then
          ren(testdir, pdffile, spdffile)
          cp(spdffile, testdir, testfiledir)
        else
          ren(testdir, newfile, tlgfile)
          cp(tlgfile, testdir, testfiledir)
        end
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

-- Provide some standard search-and-replace functions
if versionform ~= "" and not setversion_update_line then
  if versionform == "ProvidesPackage" then
    function setversion_update_line(line, date, release)
      -- No real regex so do it one type at a time
      for _,i in pairs({"Class", "File", "Package"}) do
        if match(
          line,
          "^\\Provides" .. i .. "{[a-zA-Z0-9%-%.]+}%[[^%]]*%]$"
        ) then
          line = gsub(line, "%[%d%d%d%d/%d%d/%d%d", "["
            .. gsub(date, "%-", "/"))
          line = gsub(
            line, "(%[%d%d%d%d/%d%d/%d%d) [^ ]*", "%1 " .. release
          )
          break
        end
      end
      return line
    end
  elseif versionform == "ProvidesExplPackage" then
    function setversion_update_line(line, date, release)
      -- No real regex so do it one type at a time
      for _,i in pairs({"Class", "File", "Package"}) do
        if match(
          line,
          "^\\ProvidesExpl" .. i .. " *{[a-zA-Z0-9%-%.]+}"
        ) then
          line = gsub(
            line,
            "{%d%d%d%d/%d%d/%d%d}( *){[^}]*}",
            "{" .. gsub(date, "%-", "/") .. "}%1{" .. release .. "}"
          )
          break
        end
      end
      return line
    end
  elseif versionform == "filename" then
    function setversion_update_line(line, date, release)
      if match(line, "^\\def\\filedate{%d%d%d%d/%d%d/%d%d}$") then
        line = "\\def\\filedate{" .. gsub(date, "%-", "/") .. "}"
      end
      if match(line, "^\\def\\fileversion{[^}]+}$") then
        line = "\\def\\fileversion{" .. release .. "}"
      end
      return line
    end
  elseif versionform == "ExplFileDate" then
    function setversion_update_line(line, date, release)
      if match(line, "^\\def\\ExplFileDate{%d%d%d%d/%d%d/%d%d}$") then
        line = "\\def\\ExplFileDate{" .. gsub(date, "%-", "/") .. "}"
      end
      if match(line, "^\\def\\ExplFileVersion{[^}]+}$") then
        line = "\\def\\ExplFileVersion{" .. release .. "}"
      end
      return line
    end
  end
end

-- Used to actually carry out search-and-replace
setversion_update_line = setversion_update_line or function(line, date, release)
  return line
end

function setversion(dir)
  local function rewrite(dir, file, date, release)
    local changed = false
    local result = ""
    for line in lines(dir .. "/" .. file) do
      local newline = setversion_update_line(line, date, release)
      if newline ~= line then
        line = newline
        changed = true
      end
      result = result .. line .. os_newline
    end
    if changed then
      -- Avoid adding/removing end-of-file newline
      local f = open(dir .. "/" .. file, "rb")
      local content = f:read("*all")
      close(f)
      if not match(content, os_newline .. "$") then
        gsub(result, os_newline .. "$", "")
      end
      -- Write the new file
      ren(dir, file, file .. bakext)
      local f = open(dir .. "/" .. file, "w")
      output(f)
      write(result)
      close(f)
      rm(dir, file .. bakext)
    end
  end
  local date = os_date("%Y-%m-%d")
  if optdate then
    date = optdate[1] or date
  end
  local release = -1
  if optrelease then
    release = optrelease[1] or release
  end
  local dir = dir or "."
  for _,i in pairs(versionfiles) do
    for _,j in pairs(filelist(dir, i)) do
      rewrite(dir, j, date, release)
    end
  end
  return 0
end

-- Unpack the package files using an 'isolated' system: this requires
-- a copy of the 'basic' DocStrip program, which is used then removed
function unpack()
  local errorlevel = depinstall(unpackdeps)
  if errorlevel ~= 0 then
    return errorlevel
  end
  errorlevel = bundleunpack()
  if errorlevel ~= 0 then
    return errorlevel
  end
  for _,i in ipairs(installfiles) do
    errorlevel = cp(i, unpackdir, localdir)
    if errorlevel ~= 0 then
      return errorlevel
    end
  end
  return 0
end

-- Split off from the main unpack so it can be used on a bundle and not
-- leave only one modules files
bundleunpack = bundleunpack or function(sourcedir)
  local errorlevel = mkdir(localdir)
  if errorlevel ~=0 then
    return errorlevel
  end
  errorlevel = cleandir(unpackdir)
  if errorlevel ~=0 then
    return errorlevel
  end
  for _,i in ipairs(sourcedir or {"."}) do
    for _,j in ipairs(sourcefiles) do
      errorlevel = cp(j, i, unpackdir)
      if errorlevel ~=0 then
        return errorlevel
      end
    end
  end
  for _,i in ipairs(unpacksuppfiles) do
    errorlevel = cp(i, supportdir, localdir)
    if errorlevel ~=0 then
      return errorlevel
    end
  end
  for _,i in ipairs(unpackfiles) do
    for _,j in ipairs(filelist(unpackdir, i)) do
      -- This 'yes' business is needed to pass a series of "y\n" to
      -- TeX if \askforoverwrite is true
      -- That is all done using a file as it's the only way on Windows and
      -- on Unix the "yes" command can't be used inside execute (it never
      -- stops, which confuses Lua)
      execute(os_yes .. ">>" .. localdir .. "/yes")
      local localdir = relpath(localdir, unpackdir)
      errorlevel = run(
        unpackdir,
        os_setenv .. " TEXINPUTS=." .. os_pathsep
          .. localdir .. (unpacksearch and os_pathsep or "") ..
        os_concat ..
        unpackexe .. " " .. unpackopts .. " " .. j .. " < "
          .. localdir .. "/yes"
          .. (optquiet and (" > " .. os_null) or "")
      )
      if errorlevel ~=0 then
        return errorlevel
      end
    end
  end
  return 0
end

function version()
  print(
    "\n"
    .. "l3build Release " .. gsub(release_date, "/", "-") .. "\n"
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
    elseif target == "setversion" then
      errorlevel = allmodules("setversion")
      -- Deal with any files in the bundle dir itself
      if errorlevel == 0 then
        errorlevel = setversion()
      end
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
    elseif target == "check" then
      errorlevel = check(files)
    elseif target == "clean" then
      errorlevel = clean()
    elseif target == "cmdcheck" and next(cmdchkfiles) ~= nil then
      errorlevel = cmdcheck()
    elseif target == "ctan" and bundle == "" then  -- Stand-alone module
      errorlevel = ctan(true)
    elseif target == "install" then
      errorlevel = install()
    elseif target == "save" then
      if next(files) then
        errorlevel = save(files)
      else
        help()
      end
    elseif target == "setversion" then
      errorlevel = setversion()
    elseif target == "unpack" then
      errorlevel = unpack()
    elseif target == "version" then
      version()
    else
      help()
    end
  end
  if errorlevel ~= 0 then
    exit(1)
  else
    exit(0)
  end
end

-- Allow main function to be disabled 'higher up'
main = main or stdmain

-- Pick up and read any per-run testfiledir
if options["testfiledir"] then
  if #options["testfiledir"] == 1 then
    testfiledir = options["testfiledir"][1]
    if fileexists(testfiledir .. "/config.lua") then
      dofile(testfiledir .. "/config.lua")
    end
  else
    print("Cannot use more than one testfile dir at a time!")
    return 1
  end
end

-- Call the main function
main(options["target"], options["files"])

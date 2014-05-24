#!/usr/bin/env texlua

-- Make script for LaTeX3 "l3kernel" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3kernel"
module = ""

-- Location of main directory: use Unix-style path separators
maindir = ".."

-- Non-standard settings
checkfiles   = {"l3names.def"}
installfiles = {"*.def", "*.cls", "*.sty", "*.tex"}
typesetfiles =
  {
    "expl3.dtx", "l3docstrip.dtx", "interface3.tex", "l3syntax-changes.tex",
    "l3styleguide.tex", "source3.tex"
  }
unpackfiles  = {"l3.ins"}

-- Load the common build code: this is the one place that a path needs to be
-- hard-coded
-- As the build system is 'self-contained' there is no module set up here: just
--load the file in a similar way to a TeX \input
dofile (maindir .. "/support/l3make.lua")

-- Unlike other parts of the build system, l3kernel has quite a number of
-- non-standard requirements and so a number of the functions are rewritten
-- with modification here
-- Some of these are as simple as the fact that there is no module/bundle
-- variation here

-- There are no modules: just use the bundle name
moduledir   = "latex/" .. bundle

-- l3kernel does all of the targets itself
function help ()
  print ""
  print " make check                    - run automated check system                "
  print " make checklvt <name>          - check one test file <name> for all engines"
  print " make checklvt <name> <engine> - check one test file <name> for <engine>   "
  print " make clean                    - clean out directory tree                  "
  print " make cmdcheck                 - check commands documented are defined     "
  print " make ctan                     - create CTAN-ready archive                 "
  print " make doc                      - runs all documentation files              "
  print " make format                   - create a format file using pdfTeX         "
  print " make format <engine>          - create a format file using <engine>       "
  print " make localinstall             - install files in local texmf tree         "
  print " make savetlg <name>           - save test log for <name> for all engines  "
  print " make savetlg <name> <engine>  - save test log for <name> for <engine>     "
  print " make unpack                   - extract packages                          "
  print ""
end

-- ctan () uses allmodules () to deal with each module
-- As this is the only use relied on in l3kernel, a simple change here
-- allows code sharing
function allmodules (target)
  bundlectan ()
end

-- Avoid an infinite loop
function unpack ()
  cleandir (unpackdir)
  bundleunpack ()
end

-- Check commands are defined: somewhat hard-coded at present
function cmdcheck ()
  cleandir (localdir)
  cleandir (testdir)
  unpack_kernel ()
  local cmd = string.gsub (stdengine, "tex$", "latex")
  print ("Checking source files")
  for _,i in ipairs (filelist (".", "*.dtx")) do
    print ("  " .. stripext (i))
    os.execute
      (
        -- Set TEXINPUTS to look here, local dir, then std tree
        os_setenv .. " TEXINPUTS=." .. os_pathsep .. localdir ..
          os_pathsep .. os_concat ..
        cmd .. " " .. checkopts .. " -output-directory=" .. testdir ..
          " \"\\PassOptionsToClass{check}{l3doc} \\input " .. i .. "\""
          .. " > " .. os_null
      )
    for line in io.lines (testdir .. "/" .. stripext (i) .. ".cmds") do
      if string.match (line, "^%!") then
        print ("   - " .. string.match (line, "^%! (.*)"))
      end
    end
  end
end

function format (engine)
  local engine = engine or "pdftex"
  unpack ()
  os.execute
   (
      -- Set TEXINPUTS to look in the unpack then local dirs only
      -- See notes in l3make.lua for unpack ()
      os_setenv .. " TEXINPUTS=" .. unpackdir .. os_pathsep .. localdir ..
        os_concat ..
      unpackexe .. " " .. unpackopts .. " -output-directory=" .. unpackdir
        .. " " .. unpackdir .. "/" .. "l3format.ins"
    )
  run
    (
      unpackdir,
      -- Only look 'here'
      os_setenv .. " TEXINPUTS=." .. os_concat ..
      engine .. " -etex -ini l3format.ltx"
    )
end

-- l3kernel does all of the targets itself
function main (target, file, engine)
  local errorlevel
  if target == "check" then
    errorlevel = check ()
      if errorlevel ~=0 then
        print ("There were errors: checks halted!\n")
        os.exit (errorlevel)
      end
  elseif target == "checklvt"  then
    if file then
      checklvt (file, engine)
    else
      help ()
    end
  elseif target == "clean" then
    clean ()
  elseif target == "cmdcheck" then
    cmdcheck ()
  elseif target == "ctan" then
    ctan ()
  elseif target == "doc" then
    doc ()
  elseif target == "format" then
    local engine = file -- Args are a bit wrong!
    format (engine)
  elseif target == "localinstall" then
    localinstall ()
  elseif target == "savetlg" then
    if file then
      savetlg (file, engine)
    else
      help ()
    end
  elseif target == "unpack" then
    unpack ()
    -- Additional for l3kernel: put the unpacked files somewhere known
    for _,i in ipairs (installfiles) do
      cp (i, unpackdir, localdir)
   end
  else
    help ()
  end
end

-- Call the main function which is defined in l3make.lua
main (arg[1], arg[2], arg[3])

#!/usr/bin/env texlua

-- Build script for LaTeX3 "l3kernel" files

-- Identify the bundle and module
module = "l3kernel"
bundle = ""

-- Location of main directory: use Unix-style path separators
maindir = ".."

-- Non-standard settings
checkfiles   = {"l3names.def"}
cmdchkfiles  = -- Need to miss a few .dtx files
  {
    -- Missing l3doc, l3fp and subfiles
    "expl3.dtx", "l3alloc.dtx", "l3basics.dtx", "l3bootstrap.dtx",
    "l3box.dtx", "l3candidates.dtx", "l3clist.dtx", "l3coffins.dtx",
    "l3color.dtx", "l3docstrip.dtx", "l3drivers.dtx", "l3expan.dtx",
    "l3file.dtx", "l3final.dtx", "l3int.dtx", "l3keys.dtx",
    "l3msg.dtx", "l3names.dtx", "l3prg.dtx", "l3prop.dtx", "l3quark.dtx",
    "l3seq.dtx", "l3skip.dtx", "l3tl.dtx", "l3token.dtx"
  }
installfiles =
  {
    "l3dvipdfmx.def", "l3dvips.def", "l3pdfmode.def", "l3xdvipdfmx.def",
    "*.cls", "*.sty", "*.tex"
  }
typesetfiles =
  {
    "expl3.dtx", "l3docstrip.dtx", "interface3.tex", "l3syntax-changes.tex",
    "l3styleguide.tex", "source3.tex"
  }
unpackfiles  = {"l3.ins"}

-- No deps other than the test system
checkdeps   = {maindir .. "/l3build"}
typesetdeps = { }
unpackdeps  = { }

-- Some customised functions

-- l3kernel does all of the targets itself
function help ()
  print ""
  print " build check                    - run automated check system                "
  print " build checklvt <name>          - check one test file <name> for all engines"
  print " build checklvt <name> <engine> - check one test file <name> for <engine>   "
  print " build clean                    - clean out directory tree                  "
  print " build cmdcheck                 - check commands documented are defined     "
  print " build ctan                     - create CTAN-ready archive                 "
  print " build doc                      - runs all documentation files              "
  print " build format                   - create a format file using pdfTeX         "
  print " build format <engine>          - create a format file using <engine>       "
  print " build install                  - install files in local texmf tree         "
  print " build savetlg <name>           - save test log for <name> for all engines  "
  print " build savetlg <name> <engine>  - save test log for <name> for <engine>     "
  print " build unpack                   - extract packages                          "
  print ""
end

function format (engine)
  local engine = engine or "pdftex"
  unpack ()
  os.execute (
      -- Set TEXINPUTS to look in the unpack then local dirs only
      -- See notes in l3build.lua for unpack ()
      os_setenv .. " TEXINPUTS=" .. unpackdir .. os_pathsep .. localdir ..
        os_concat ..
      unpackexe .. " " .. unpackopts .. " -output-directory=" .. unpackdir
        .. " " .. unpackdir .. "/" .. "l3format.ins"
    )
  run (
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
    ctan (true)
  elseif target == "doc" then
    doc ()
  elseif target == "format" then
    local engine = file -- Args are a bit wrong!
    format (engine)
  elseif target == "install" then
    install ()
  elseif target == "localinstall" then -- 'Hidden' target
      localinstall ()
  elseif target == "savetlg" then
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

-- Load the common build code: this is the one place that a path needs to be
-- hard-coded
-- As the build system is 'self-contained' there is no module set up here: just
--load the file in a similar way to a TeX \input
dofile (maindir .. "/l3build/l3build-config.lua")
dofile (maindir .. "/l3build/l3build.lua")

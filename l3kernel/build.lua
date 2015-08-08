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
docfiles     = {"source3body.tex"}
installfiles =
  {
    "l3dvipdfmx.def", "l3dvips.def", "l3pdfmode.def", "l3unicode-data.def",
    "l3xdvipdfmx.def",
    "*.cls", "*.sty", "*.tex"
  }
sourcefiles  = {"l3unicode-data.def", "*.dtx", "*.ins"}
typesetfiles =
  {
    "expl3.dtx", "l3docstrip.dtx", "interface3.tex", "l3syntax-changes.tex",
    "l3styleguide.tex", "source3.tex"
  }
typesetskipfiles = {"source3-body.tex"}
unpackfiles  = {"l3.ins"}

-- No deps other than the test system
checkdeps   = {maindir .. "/l3build"}
typesetdeps = {maindir .. "/l3packages/xparse"}
unpackdeps  = { }

-- Some customised functions
function help()
  print("usage: " .. arg[0] .. " <command> [<options>] [<names>]")
  print("")
  print("The most commonly used l3build commands are:")
  print("   check      Run all automated tests")
  print("   clean      Clean out directory tree")
  print("   cmdcheck   Check commands documented are defined")
  print("   ctan       Create CTAN-ready archive")
  print("   doc        Typesets all documentation files")
  print("   format     Builds a format")
  print("   install    Installs files into the local texmf tree")
  print("   save       Saves test validation log")
  print("")
  print("Valid options are:")
  print("   --engine|-e         Sets the engine to use for running test")
  print("   --halt-on-error|-H  Stops running tests after the first failure")
  print("")
end

function format()
  local engines = checkengines
  if optengine then
    engines = {optengine}
  end
  unpack()
  os.execute(
      -- Set TEXINPUTS to look in the unpack then local dirs only
      -- See notes in l3build.lua for unpack ()
      os_setenv .. " TEXINPUTS=" .. unpackdir .. os_pathsep .. localdir ..
        os_concat ..
      unpackexe .. " " .. unpackopts .. " -output-directory=" .. unpackdir
        .. " " .. unpackdir .. "/" .. "l3format.ins"
    )
  local engine
  for _,engine in pairs(engines) do
    run(
        unpackdir,
        -- Only look 'here'
        os_setenv .. " TEXINPUTS=." .. os_concat ..
        engine .. " -etex -ini l3format.ltx"
      )
  end
end

-- l3kernel does all of the targets itself
function main(target, files)
  local errorlevel
  if target == "check" then
    check(files)
  elseif target == "clean" then
    clean()
  elseif target == "cmdcheck" then
    cmdcheck()
  elseif target == "ctan" then
    ctan(true)
  elseif target == "doc" then
    doc()
  elseif target == "format" then
    format()
  elseif target == "install" then
    install()
  elseif target == "save" then
    if next(files) then
      save(files)
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

-- Load the common build code: this is the one place that a path needs to be
-- hard-coded
-- As the build system is 'self-contained' there is no module set up here: just
--load the file in a similar way to a TeX \input
dofile (maindir .. "/build-config.lua")
dofile (maindir .. "/l3build/l3build.lua")

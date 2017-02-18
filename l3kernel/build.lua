#!/usr/bin/env texlua

-- Build script for LaTeX3 "l3kernel" files

-- Identify the bundle and module
module = "l3kernel"
bundle = ""

-- Location of main directory: use Unix-style path separators
maindir = ".."

-- Non-standard settings
checkfiles   = {"l3names.def"}
cleanfiles   = {"*.fmt", "*.log", "*.pdf", "*.zip"}
cmdchkfiles  = {"source3.tex"}
docfiles     = {"source3body.tex"}
installfiles =
  {
    "l3dvipdfmx.def", "l3dvips.def", "l3dvisvgm.def", "l3pdfmode.def",
    "l3xdvipdfmx.def",
    "expl3.lua",
    "*.cls", "*.sty", "*.tex"
  }
sourcefiles  = {"*.dtx", "*.ins"}
typesetfiles =
  {
    "expl3.dtx", "l3docstrip.dtx", "interface3.tex", "l3syntax-changes.tex",
    "l3styleguide.tex", "source3.tex"
  }
typesetskipfiles = {"source3-body.tex"}
unpackfiles      = {"l3.ins"}
versionfiles     = {"expl3.dtx", "l3oldmodules.dtx", "README.md"}

-- No deps other than the test system
checkdeps   = {maindir .. "/l3build"}
typesetdeps = {maindir .. "/l3packages/xparse"}
unpackdeps  = { }

function format()
  local engines = checkengines
  if optengines then
    engines = optengines
  end
  local errorlevel = unpack()
  if errorlevel ~=0 then
    return errorlevel
  end
  local localdir = relpath(localdir, unpackdir)
  errorlevel = run(
    unpackdir,
    os_setenv .. " TEXINPUTS=." .. os_pathsep
      .. localdir .. (unpacksearch and os_pathsep or "") ..
    os_concat ..
    unpackexe .. " " .. unpackopts .. " l3format.ins"
  )
  local function mkformat(engine)
    local realengine = engine
    -- Special casing for (u)pTeX
    if string.match(engine, "^u?ptex$") then
      realengine = "e" .. engine
    end
    local errorlevel = run(
      unpackdir,
      realengine .. " -etex -ini l3format.ltx"
     )
     if errorlevel ~=0 then
       return errorlevel
     end
     local fmtname = "l3" .. engine .. ".fmt"
     ren(unpackdir, "l3format.fmt", fmtname)
     cp(fmtname, unpackdir, ".")
     return 0
  end
  local engine
  for _,engine in pairs(engines) do
    errorlevel = mkformat(engine)
    if errorlevel ~=0 then
      return errorlevel
    end
  end
  return 0
end

-- l3kernel does all of the targets itself
function main(target, files)
  local errorlevel = 0
  if target == "check" then
    errorlevel = check(files)
  elseif target == "clean" then
    clean()
  elseif target == "cmdcheck" then
    errorlevel = cmdcheck()
  elseif target == "ctan" then
    errorlevel = ctan(true)
  elseif target == "doc" then
    errorlevel = doc(files)
  elseif target == "format" then
    errorlevel = format()
  elseif target == "install" then
    install()
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
  os.exit(errorlevel)
end

-- We need more runs than the default for source3.

function typeset(file)
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
      if errorlevel == 0 then
        errorlevel = cycle(name)
        if errorlevel == 0 then
          errorlevel = tex(file)
        end
      end
    end
    return errorlevel
  end
end

-- Load the common build code: this is the one place that a path needs to be
-- hard-coded
-- As the build system is 'self-contained' there is no module set up here: just
--load the file in a similar way to a TeX \input
dofile (maindir .. "/build-config.lua")
dofile (maindir .. "/l3build/l3build.lua")

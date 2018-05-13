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
docfiles     = {"source3body.tex"}
installfiles =
  {
    "l3dvipdfmx.def", "l3dvips.def", "l3dvisvgm.def", "l3pdfmode.def",
    "l3xdvipdfmx.def",
    "expl3.lua",
    "*.cls", "*.sty", "*.tex"
  }
sourcefiles  = {"*.dtx", "*.ins"}
tagfiles     =
  {
    "*.dtx", "README.md",
    "interface3.tex", "l3styleguide.tex",
    "l3syntax-changes.tex", "source3.tex"
  }
typesetfiles =
  {
    "expl3.dtx", "l3docstrip.dtx","interface3.tex", "l3syntax-changes.tex",
    "l3styleguide.tex", "source3.tex"
  }
typesetskipfiles = {"source3-body.tex"}
typesetruns      = 3
unpackfiles      = {"l3.ins"}

-- No deps other than the test system
typesetdeps = {maindir .. "/l3packages/xparse"}
unpackdeps  = { }

-- Load the common build code
dofile(maindir .. "/build-config.lua")

-- Detail how to set the version automatically
function update_tag(file,content,tagname,tagdate)
  local iso = "%d%d%d%d%-%d%d%-%d%d"
  if string.match(file,"expl3%.dtx$") then
    content = string.gsub(content,
      "\n\\def\\ExplFileDate{" .. iso .. "}%%\n",
      "\n\\def\\ExplFileDate{" .. tagname .. "}%%\n")
  elseif string.match(file,"l3drivers%.dtx$") then
    content = string.gsub(content,
      "\n  ({l3%w+%.def}){" .. iso .. "}",
      "\n  %1{" .. tagname .. "}")
  end
  if string.match(file,"%.dtx$") or string.match(file,"%.tex$") then
    return string.gsub(content,
      "\n(%%*%s*)\\date{Released " .. iso .. "}\n",
      "\n%1\\date{Released " .. tagname .. "}\n")
  elseif string.match(file, "%.md$") then
    return string.gsub(content,
      "\nRelease " .. iso .. "\n",
      "\nRelease " .. tagname .. "\n")
  end
  return content
end

function cmdcheck()
  mkdir(localdir)
  cleandir(testdir)
  depinstall(checkdeps)
  for _,filetype in pairs(
      {bibfiles, docfiles, typesetfiles, typesetdemofiles}
    ) do
    for _,file in pairs(filetype) do
      cp(file, docfiledir, testdir)
    end
  end
  for _,file in pairs(sourcefiles) do
    cp(file, sourcefiledir, testdir)
  end
  for _,file in pairs(typesetsuppfiles) do
    cp(file, supportdir, testdir)
  end
  print("Checking source3")
  run(
    testdir,
    os_setenv .. " TEXINPUTS=." .. os_pathsep .. abspath(localdir)
      .. os_pathsep ..
    os_concat ..
    string.gsub(stdengine, "tex$", "latex") .. " --interaction=batchmode" ..
      " \"\\PassOptionsToClass{check}{l3doc} \\input source3.tex \""
      .. " > " .. os_null
  )
  for line in io.lines(testdir .. "/source3.cmds") do
    if string.match(line, "^%!") then
      print("   - " .. string.match(line, "^%! (.*)"))
    end
  end
end

function format()
  local engines = checkengines
  if optengines then
    engines = optengines
  end
  local errorlevel = unpack()
  if errorlevel ~=0 then
    return errorlevel
  end
  local localdir = abspath(localdir)
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
  elseif target == "tag" then
    if options["names"] and #options["names"] == 1 then
      tag(options["names"][1])
    else
      print("Tag name required")
      help()
      exit(1)
    end
  elseif target == "unpack" then
    errorlevel = unpack()
  elseif target == "version" then
    version()
  else
    help()
  end
  os.exit(errorlevel)
end


-- Find and run the build system
kpse.set_program_name("kpsewhich")
if not release_date then
  dofile(kpse.lookup("l3build.lua"))
end


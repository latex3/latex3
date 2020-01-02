#!/usr/bin/env texlua

-- Build script for LaTeX3 "l3kernel" files

-- Identify the bundle and module
module = "l3kernel"
bundle = ""

-- Location of main directory: use Unix-style path separators
maindir = ".."
docfiledir = "./doc"

-- Non-standard settings
checkfiles   = {"l3names.def"}
cleanfiles   = {"*.fmt", "*.log", "*.pdf", "*.zip"}
docfiles     = {"source3body.tex", "l3prefixes.csv"}
installfiles =
  {
    "l3dvipdfmx.def", "l3dvips.def", "l3dvisvgm.def", "l3pdfmode.def",
    "l3xdvipdfmx.def",
    "l3str-enc-*.def",
    "l3debug.def", "l3deprecation.def", "l3sys.def",
    "expl3.lua","expl3.ltx",
    "*.cls", "*.sty", "*.tex"
  }
sourcefiles  = {"*.dtx", "*.ins"}
tagfiles     =
  {
    "*.dtx", "CHANGELOG.md", "README.md",
    "interface3.tex", "l3styleguide.tex",
    "l3syntax-changes.tex",
    "l3term-glossary.tex",
    "source3.tex",
    "*.ins"
  }
typesetfiles =
  {
    "expl3.dtx", "l3docstrip.dtx","interface3.tex", "l3syntax-changes.tex",
    "l3styleguide.tex", "l3term-glossary.tex", "source3.tex",
    "l3prefixes.tex",
    "l3news*.tex"
  }
typesetskipfiles = {"source3-body.tex"}
typesetruns      = 3
unpackfiles      = {"l3.ins"}

checkdeps   = {maindir .. "/l3backend"}
typesetdeps = {maindir .. "/l3backend", maindir .. "/l3packages/xparse"}
unpackdeps  = { }

-- Load the common build code
dofile(maindir .. "/build-config.lua")

-- Detail how to set the version automatically
function update_tag(file,content,tagname,tagdate)
  local iso = "%d%d%d%d%-%d%d%-%d%d"
  local url = "https://github.com/latex3/latex3/compare/"
  if string.match(content,"%(C%)%s*[%d%-,]+ The LaTeX3 Project") then
    local year = os.date("%Y")
    content = string.gsub(content,
      "%(C%)%s*([%d%-,]+) The LaTeX3 Project",
      "(C) %1," .. year .. " The LaTeX3 Project")
   content = string.gsub(content,year .. "," .. year,year)
   content = string.gsub(content,
     "%-" .. tonumber(year) - 1 .. "," .. year,
     "-" .. year)
   content = string.gsub(content,
     tonumber(year) - 2 .. "," .. tonumber(year) - 1 .. "," .. year,
     tonumber(year) - 2 .. "-" .. year)
  end
  if string.match(file,"expl3%.dtx$") then
    content = string.gsub(content,
      "\n\\def\\ExplFileDate{" .. iso .. "}%%\n",
      "\n\\def\\ExplFileDate{" .. tagname .. "}%%\n")
  end
  if string.match(file,"%.dtx$") or string.match(file,"%.tex$") then
    return string.gsub(content,
      "\n(%%*%s*)\\date{Released " .. iso .. "}\n",
      "\n%1\\date{Released " .. tagname .. "}\n")
  elseif string.match(file, "%.md$") then
    if string.match(file,"CHANGELOG.md") then
      local previous = string.match(content,"compare/(" .. iso .. ")%.%.%.HEAD")
      if tagname == previous then return content end
      content = string.gsub(content,
        "## %[Unreleased%]",
        "## [Unreleased]\n\n## [" .. tagname .."]")
      return string.gsub(content,
        iso .. "%.%.%.HEAD",
        tagname .. "...HEAD\n[" .. tagname .. "]: " .. url .. previous
          .. "..." .. tagname)
    end
    return string.gsub(content,
      "\nRelease " .. iso .. "\n",
      "\nRelease " .. tagname .. "\n")
  end
  return content
end

uploadconfig = {
  author      = "The LaTeX Team",
  license     = "lppl1.3c",
  summary     = "LaTeX3 programming conventions",
  topic       = {"macro-supp","latex3","expl3"},
  ctanPath    = "/macros/latex/contrib/l3kernel",
  repository  = "https://github.com/latex3/latex3/",
  bugtracker  = "https://github.com/latex3/latex3/issues",
  update      = true,
  description = [[
The l3k­er­nel bun­dle pro­vides an im­ple­men­ta­tion of the LaTeX3 pro­gram­mers'
in­ter­face, as a set of pack­ages that run un­der LaTeX2e. The in­ter­face
pro­vides the foun­da­tion on which the LaTeX3 ker­nel and other fu­ture code
are built: it is an API for TeX pro­gram­mers. The pack­ages are set up so that
the LaTeX3 con­ven­tions can be used with reg­u­lar LaTeX2e pack­ages. 
  ]]
}

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
  local localtexmf = ""
  if texmfdir and texmfdir ~= "" then
    localtexmf = os_pathsep .. abspath(texmfdir) .. "//"
  end
  errorlevel = run(
    unpackdir,
    os_setenv .. " TEXINPUTS=." .. localtexmf .. os_pathsep
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

target_list = target_list or { }
target_list.cmdcheck =
  {
    func = cmdcheck,
    desc = "Run cmd cover test"
  }
target_list.format =
  {
    func = format,
    desc = "Create l3formats"
  }

-- Find and run the build system
kpse.set_program_name("kpsewhich")
if not release_date then
  dofile(kpse.lookup("l3build.lua"))
end


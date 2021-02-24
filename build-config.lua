-- Common settings for LaTeX3 development repo, used by l3build script

checkdeps   = checkdeps   or {maindir .. "/l3backend", maindir .. "/l3kernel"}
typesetdeps = typesetdeps or checkdeps

checkengines    = checkengines
  or {"pdftex", "xetex", "luatex", "ptex", "uptex"}
checksuppfiles  = checksuppfiles  or
  {
    "regression-test.cfg",
    "regression-test.tex",
    "sRGB_v4_ICC_preference.icc"
  }
tagfiles = tagfiles or {"*.dtx", "README.md", "CHANGELOG.md", "*.ins"}
unpacksuppfiles = unpacksuppfiles or
  {
    "*.ini",
    "docstrip.tex",
    "hyphen.cfg",
    "lualatexquotejobname.lua",
    "luatexconfig.tex",
    "pdftexconfig.tex",
    "texsys.cfg",
    "UShyphen.tex"
  }

packtdszip  = true

typesetcmds = typesetcmds or "\\AtBeginDocument{\\csname DisableImplementation\\endcsname}"

typesetexe = "pdftex"
typesetopts = "--fmt=pdflatex -interaction=nonstopmode"

maxprintline = 9999

if checksearch == nil then
  checksearch = false
end
if unpacksearch == nil then
  unpacksearch = false
end

-- Detail how to set the version automatically
function update_tag(file,content,tagname,tagdate)
  local iso = "%d%d%d%d%-%d%d%-%d%d"
  local url = "https://github.com/latex3/latex3/compare/"
  if string.match(content,"%(C%)%s*[%d%-,]+ The LaTeX Project") then
    local year = os.date("%Y")
    content = string.gsub(content,
      "%(C%)%s*([%d%-,]+) The LaTeX Project",
      "(C) %1," .. year .. " The LaTeX Project")
   content = string.gsub(content,year .. "," .. year,year)
   content = string.gsub(content,
     "%-" .. math.tointeger(year - 1) .. "," .. year,
     "-" .. year)
   content = string.gsub(content,
     math.tointeger(year - 2) .. "," .. math.tointeger(year - 1) .. "," .. year,
     math.tointeger(year - 2) .. "-" .. year)
  end
  if string.match(file,"%.dtx$") then
    content = string.gsub(content,
      "\n\\ProvidesExpl" .. "(%w+ *{[^}]+} *){" .. iso .. "}",
      "\n\\ProvidesExpl%1{" .. tagname .. "}")
    return string.gsub(content,
      "\n%% \\date{Released " .. iso .. "}\n",
      "\n%% \\date{Released " .. tagname .. "}\n")
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

-- Need to build format files
local function fmt(engines,dest)
  local function mkfmt(engine)
    -- Standard (u)pTeX engines don't have e-TeX
    local cmd = engine
    if string.match(engine,"uptex") then
      cmd = "euptex"
    elseif string.match(engine,"ptex") then
      cmd = "eptex"
    elseif string.match(engine,"luatex") then
      cmd = "luahbtex"
    end
    -- Use .ini files if available
    local src = "latex.ltx"
    local ini = string.gsub(engine,"tex","") .. "latex.ini"
    if fileexists(supportdir .. "/" .. ini) then
      src = ini
    end
    print("Building format for " .. engine)
    local errorlevel = os.execute(
      os_setenv .. " TEXINPUTS=" .. unpackdir .. os_pathsep .. localdir
      .. os_pathsep .. texmfdir .. "//"
      .. os_concat ..
      os_setenv .. " LUAINPUTS=" .. unpackdir .. os_pathsep .. localdir
      .. os_pathsep .. texmfdir .. "//"
      .. os_concat .. cmd .. " -etex -ini -output-directory=" .. unpackdir
      .. " " .. src .. " > " .. os_null)
    if errorlevel ~= 0 then
      -- Remove file extension: https://stackoverflow.com/a/34326069/6015190
      local basename = src:match("(.+)%..+$")
      local f = io.open(unpackdir .. "/" .. basename .. '.log',"r")
      local content = f:read("*all")
      io.close(f)
      print("-------------------------------------------------------------------------------")
      print(content)
      print("-------------------------------------------------------------------------------")
      print("Failed building LaTeX format for " .. engine)
      print("  Look for errors in the transcript above")
      print("-------------------------------------------------------------------------------")
      return errorlevel
    end

    local engname = string.match(src,"^[^.]*") .. ".fmt"
    local fmtname = string.gsub(engine,"tex$","") .. "latex.fmt"
    if engname ~= fmtname then
      ren(unpackdir,engname,fmtname)
    end
    cp(fmtname,unpackdir,dest)

    return 0
  end

  local errorlevel
  for _,engine in pairs(engines) do
    errorlevel = mkfmt(engine)
    if errorlevel ~= 0 then return errorlevel end
  end
  return 0
end

function checkinit_hook()
  local engines = options.engine
  if not engines then
    local target = options.target
    if target == 'check' or target == 'bundlecheck' then
      engines = checkengines
    elseif target == 'save' then
      engines = {stdengine}
    else
      error'Unexpected target in call to checkinit_hook'
    end
  end
  return fmt(engines,testdir)
end

function docinit_hook()
  return fmt({typesetexe},typesetdir)
end

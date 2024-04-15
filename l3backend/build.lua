#!/usr/bin/env texlua

-- Build script for LaTeX3 "l3backend" files

-- Identify the bundle and module
module = "l3backend"
bundle = ""

-- Location of main directory: use Unix-style path separators
maindir = ".."

installfiles = {"*.def", "*.pro", "l3backend*.lua"}
sourcefiles  = {"*.dtx", "*.ins"}
tagfiles     = {"*.dtx", "CHANGELOG.md", "README.md", "*.ins"}
typesetfiles = {"l3backend-code.tex"}
unpackfiles  = {"l3backend.ins"}

-- Avoid a circular ref.
typesetdeps = {maindir .. "/l3kernel"}

-- Get the .pro files in the right place
if main_branch then
  tdslocations = {"dvips/l3backend/*.pro"}
end

-- Load the common build code
dofile(maindir .. "/build-config.lua")

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
      math.tointeger(year - 2).. "-" .. year)
  end
  if string.match(file,"l3backend%-basics%.dtx$") then
    content = string.gsub(content,
      "\n  ({l3backend%-%w+%.def}){" .. iso .. "}",
      "\n  %1{" .. tagname .. "}")
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
  summary     = "LaTeX3 backend drivers",
  topic       = {"macro-supp","latex3","expl3"},
  ctanPath    = "/macros/latex/contrib/l3backend",
  repository  = "https://github.com/latex3/latex3/",
  bugtracker  = "https://github.com/latex3/latex3/issues",
  update      = true,
  description = [[
This package forms parts of [expl3](https://ctan.org/pkg/expl3), and contains
the code used to interface with backends (drivers) across the
[expl3](https://ctan.org/pkg/expl3) codebase.

The functions here are defined differently depending on the engine in use. As
such, these are distributed separately from
[l3kernel](https://ctan.org/pkg/l3kernel) to allow this code to be updated on
an independent schedule.
  ]]
}

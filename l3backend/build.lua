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

-- Load the common build code
dofile(maindir .. "/build-config.lua")

-- Get the .pro files in the right place
if main_branch then
  tdslocations = {"dvips/l3backend/*.pro"}
end

-- Extra operations in setting the version 
function update_tag_extra(file,content,tagname,tagdate)
  local iso = "%d%d%d%d%-%d%d%-%d%d"
  if string.match(file,"l3backend%-basics%.dtx$") then
    content = string.gsub(content,
      "\n  ({l3backend%-%w+%.def}){" .. iso .. "}",
      "\n  %1{" .. tagname .. "}")
  end
  return(content)
end

uploadconfig = {
  author      = "The LaTeX Project team",
  license     = "lppl1.3c",
  summary     = "LaTeX3 backend drivers",
  topic       = {"macro-supp","latex3","expl3"},
  ctanPath    = "/macros/latex/required/l3backend",
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

#!/usr/bin/env texlua

-- Build script for LaTeX3 "l3build" files

-- Identify the bundle and module
module = "l3build"
bundle = ""

-- Location of main directory: use Unix-style path separators
maindir = ".."

-- Non-standard settings
checkdeps    = { }
cleanfiles   = {"*.pdf", "*.tex", "*.zip"}
installfiles = {"l3build.lua", "regression-test.tex"}
sourcefiles  = {"*.dtx", "l3build.lua", "*.ins"}
unpackdeps   = { }
versionfiles = {"*.dtx", "*.md", "l3build.lua"}

-- Detail how to set the version automatically
function setversion_update_line(line, date, version)
  local date = string.gsub(date, "%-", "/")
  -- Replace the identifiers in .dtx files
  if string.match(line, "^\\def\\ExplFileDate{%d%d%d%d/%d%d/%d%d}$") then
    line = "\\def\\ExplFileDate{" .. date .. "}"
  end
  if string.match(line, "^\\def\\ExplFileVersion{%d+}$") then
    line = "\\def\\ExplFileVersion{" .. version .. "}"
  end
  -- Markdown files
  if string.match(
    line, "^Release %d%d%d%d/%d%d/%d%d %(r%d%d%d%d%)$"
  ) then
    line = "Release " .. date .. " (r" .. version .. ")"
  end
  -- l3build.lua
  if string.match(line, "^release_date = \"%d%d%d%d/%d%d/%d%d\"$") then
    line = "release_date = \"" .. date .. "\""
  end
  if string.match(line, "^release_ver  = \"%d%d%d%d\"$") then
    line = "release_ver  = \"" .. version .. "\""
  end
  return line
end

-- Load the common build code: this is the one place that a path needs to be
-- hard-coded
-- As the build system is 'self-contained' there is no module set up here: just
--load the file in a similar way to a TeX \input
dofile (maindir .. "/build-config.lua")
dofile (maindir .. "/l3build/l3build.lua")

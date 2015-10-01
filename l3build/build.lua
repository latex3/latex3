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

-- Load the common build code: this is the one place that a path needs to be
-- hard-coded
-- As the build system is 'self-contained' there is no module set up here: just
--load the file in a similar way to a TeX \input
dofile (maindir .. "/build-config.lua")
dofile (maindir .. "/l3build/l3build.lua")

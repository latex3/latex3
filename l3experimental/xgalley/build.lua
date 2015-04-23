#!/usr/bin/env texlua

-- Build script for LaTeX3 "xgalley" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3experimental"
module = "xgalley"

-- Location of main directory: use Unix-style path separators
maindir = "../.."

-- Non-standard settings
testfiledir  = "" -- No tests

-- Load the common build code: this is the one place that a path needs to be
-- hard-coded
-- As the build system is 'self-contained' there is no module set up here: just
--load the file in a similar way to a TeX \input
dofile (maindir .. "/build-config.lua")
dofile (maindir .. "/l3build/l3build.lua")

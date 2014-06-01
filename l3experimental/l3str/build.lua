#!/usr/bin/env texlua

-- Build Script for LaTeX3 "l3str" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3experimental"
module = "l3str"

-- Location of main directory: use Unix-style path separators
maindir = "../.."

-- Non-standard settings
installfiles = {"*.def", "*.sty"}

-- Load the common build code: this is the one place that a path needs to be
-- hard-coded
-- As the build system is 'self-contained' there is no module set up here: just
--load the file in a similar way to a TeX \input
dofile (maindir .. "/l3build/l3build.lua")

-- Call the main function which is defined in l3build.lua
main (arg[1], arg[2], arg[3])

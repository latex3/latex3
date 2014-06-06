#!/usr/bin/env texlua

-- Build script for LaTeX3 "xbox" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3trial"
module = "xbox"

-- Location of main directory: use Unix-style path separators
maindir = "../.."

-- Non-standard settings
checkdeps   = {maindir .. "/l3kernel", maindir .. "/l3packages/xparse"}
typesetdeps = {maindir .. "/l3kernel", maindir .. "/l3packages/xparse"}

-- Load the common build code: this is the one place that a path needs to be
-- hard-coded
-- As the build system is 'self-contained' there is no module set up here: just
--load the file in a similar way to a TeX \input
dofile (maindir .. "/l3build/l3build-config.lua")
dofile (maindir .. "/l3build/l3build.lua")

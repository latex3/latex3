#!/usr/bin/env texlua

-- Build script for LaTeX3 "xfrac" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3packages"
module = "xfrac"

-- Location of main directory: use Unix-style path separators
maindir = "../.."

-- Non-standard settings
checksearch  = true
checkdeps   = {maindir .. "/l3kernel", maindir .. "/l3backend",
               maindir .. "/l3packages/xtemplate", maindir .. "/l3packages/l3keys2e"}
typesetdeps = checkdeps

-- Load the common build code
dofile(maindir .. "/build-config.lua")

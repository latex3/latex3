#!/usr/bin/env texlua

-- Build script for LaTeX3 "xcoffins" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3experimental"
module = "xcoffins"

-- Location of main directory: use Unix-style path separators

maindir = "../.."

-- Non-standard settings
checkdeps   = {maindir .. "/l3packages/xtemplate"}
typesetdeps = checkdeps

-- Load the common build code
dofile(maindir .. "/build-config.lua")

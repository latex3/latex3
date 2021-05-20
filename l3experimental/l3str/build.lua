#!/usr/bin/env texlua

-- Build script for LaTeX3 "l3str" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3experimental"
module = "l3str"

-- Location of main directory: use Unix-style path separators
maindir = "../.."

-- Non-standard settings
installfiles = {"*.def", "*.sty"}

-- Load the common build code
dofile(maindir .. "/build-config.lua")

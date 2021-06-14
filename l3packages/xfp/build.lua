#!/usr/bin/env texlua

-- Build script for LaTeX3 "xfp" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3packages"
module = "xfp"

-- Location of main directory: use Unix-style path separators
maindir = "../.."

-- Load the common build code
dofile(maindir .. "/build-config.lua")

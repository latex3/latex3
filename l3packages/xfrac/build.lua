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

-- Load the common build code
dofile(maindir .. "/build-config.lua")

-- Find and run the build system
kpse.set_program_name("kpsewhich")
dofile(kpse.lookup("l3build.lua"))

#!/usr/bin/env texlua

-- Build script for LaTeX3 "l3keys2e" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3packages"
module = "l3keys2e"

-- Location of main directory: use Unix-style path separators
maindir = "../.."

-- Non-standard settings
demofiles    = {"l3keys2e-demo.tex"}

-- Load the common build code
dofile(maindir .. "/build-config.lua")

-- Find and run the build system
kpse.set_program_name("kpsewhich")
if not release_date then
  dofile(kpse.lookup("l3build.lua"))
end


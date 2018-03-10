#!/usr/bin/env texlua

-- Build script for LaTeX3 "l3doc" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3packages"
module = "l3doc"

-- Location of main directory: use Unix-style path separators
maindir = "../.."

-- Load the common build code
dofile(maindir .. "/build-config.lua")

installfiles = {"*.cls"}

checkruns    = 2
checksearch  = true
recordstatus = true

testfiledir = ""

-- Find and run the build system
kpse.set_program_name("kpsewhich")
if not release_date then
  dofile(kpse.lookup("l3build.lua"))
end


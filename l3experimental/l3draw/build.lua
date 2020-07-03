#!/usr/bin/env texlua

-- Build script for LaTeX3 "l3draw" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3experimental"
module = "l3draw"

-- Location of main directory: use Unix-style path separators
maindir = "../.."

typesetfiles = {"l3draw.dtx", "l3draw-code.tex"}

-- Need color support
checkdeps = {maindir .. "/l3backend", maindir .. "/l3kernel", maindir .. "/l3experimental/l3color"}
typesetdeps = checkdeps

-- Load the common build code
dofile(maindir .. "/build-config.lua")

-- Find and run the build system
kpse.set_program_name("kpsewhich")
if not release_date then
  dofile(kpse.lookup("l3build.lua"))
end


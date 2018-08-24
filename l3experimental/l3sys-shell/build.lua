#!/usr/bin/env texlua

-- Build script for LaTeX3 "l3sys-shell" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3experimental"
module = "l3sys-shell"

-- Location of main directory: use Unix-style path separators
maindir = "../.."

-- We need shell-escape
checkopts = "-interaction=nonstopmode --shell-escape"

-- Load the common build code
dofile(maindir .. "/build-config.lua")

-- Find and run the build system
kpse.set_program_name("kpsewhich")
if not release_date then
  dofile(kpse.lookup("l3build.lua"))
end


#!/usr/bin/env texlua

-- Build script for contrib packages

-- Identify the bundle and module
-- Just filler as this is purely a location for tests
module = "contrib"
bundle = ""

-- Location of main directory: use Unix-style path separators
maindir = ".."

-- Non-standard settings
checkdeps   =
  {
    maindir .. "/l3packages/l3keys2e",
    maindir .. "/l3packages/xfrac",
    maindir .. "/l3packages/xparse",
    maindir .. "/l3packages/xtemplate"
  }
checksearch = true

-- In contrib testing, stop processing at the first error
checkopts = "-interaction=batchmode -halt-on-error"

-- Load the common build code
dofile(maindir .. "/build-config.lua")

-- Find and run the build system
kpse.set_program_name("kpsewhich")
if not release_date then
  dofile(kpse.lookup("l3build.lua"))
end


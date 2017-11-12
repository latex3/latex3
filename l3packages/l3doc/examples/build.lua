#!/usr/bin/env texlua

-- Build script for LaTeX3 "l3doc" example files

module = "l3doc-examples"

-- Find and run the build system
kpse.set_program_name("kpsewhich")
dofile(kpse.lookup("l3build.lua"))

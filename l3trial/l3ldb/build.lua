#!/usr/bin/env texlua

-- Build script for LaTeX3 "l3ldb" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3trial"
module = "l3ldb"

-- Location of main directory: use Unix-style path separators
maindir = "../.."

-- Non-standard settings
checkdeps   =
  {
    maindir .. "/l3kernel",
    maindir .. "/l3packages/xtemplate"
  }
checksuppfiles  =
  {
    "article.cls",
    "fontenc.sty",
    "ot1enc.def",
    "regression-test.cfg",
    "regression-test.tex",
    "size10.clo",
  }

-- Load the common build code
dofile(maindir .. "/build-config.lua")

-- Find and run the build system
kpse.set_program_name("kpsewhich")
dofile(kpse.lookup("l3build.lua"))

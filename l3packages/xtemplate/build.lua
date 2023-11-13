#!/usr/bin/env texlua

-- Build script for LaTeX3 "xtemplate" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3packages"
module = "xtemplate"

-- Location of main directory: use Unix-style path separators
maindir = "../.."

installfiles = {
  "xtemplate.sty",
  "xtemplate-????-??-??.sty"
}

sourcefiles = {
  "*.dtx",
  "*.ins",
  "*-????-??-??.sty"
}

-- Load the common build code
dofile(maindir .. "/build-config.lua")

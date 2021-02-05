#!/usr/bin/env texlua

-- Build script for LaTeX3 "xparse" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3packages"
module = "xparse"

installfiles = {
  "xparse.ltx",
  "xparse.sty",
  "xparse-????-??-??.sty",
  "xparse-generic.tex" -- temporary
}

sourcefiles = {
  "*.dtx",
  "*.ins",
  "*-????-??-??.sty",
  "xparse-generic.tex" -- temporary
}

-- Location of main directory: use Unix-style path separators
maindir = "../.."

-- Load the common build code
dofile(maindir .. "/build-config.lua")

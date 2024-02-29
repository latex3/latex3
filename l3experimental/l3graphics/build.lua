#!/usr/bin/env texlua

-- Build script for LaTeX3 "l3graphics" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3experimental"
module = "l3graphics"

-- Location of main directory: use Unix-style path separators
maindir = "../.."

checkengines =
  {"pdftex", "luatex", "xetex", "etex-dvips", "etex-dvisvgm", "uptex"}

-- Load the common build code
dofile(maindir .. "/build-config.lua")

dynamicfiles = {"*-eps-converted-to.pdf"}

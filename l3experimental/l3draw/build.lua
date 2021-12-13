#!/usr/bin/env texlua

-- Build script for LaTeX3 "l3draw" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3experimental"
module = "l3draw"

-- Location of main directory: use Unix-style path separators
maindir = "../.."

typesetfiles = {"l3draw.dtx", "l3draw-code.tex"}

-- Set up to allow testing dvips, etc.
specialformats = specialformats or {}
specialformats.latex =
  {
    luatex = {binary = "luahbtex",format = "lualatex"},
    ptex  = {binary = "eptex"},
    uptex = {binary = "euptex"},
    ["etex-dvips"] = {binary = "etex", format = "latex"}
  }
checkengines = {"pdftex", "luatex", "xetex", "etex-dvips", "ptex", "uptex"}

-- Load the common build code
dofile(maindir .. "/build-config.lua")

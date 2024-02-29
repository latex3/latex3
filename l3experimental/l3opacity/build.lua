#!/usr/bin/env texlua

-- Build script for LaTeX3 "l3opacity" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3experimental"
module = "l3opacity"

-- Location of main directory: use Unix-style path separators
maindir = "../.."

-- Set up to allow testing dvips, etc.
specialformats = specialformats or {}
specialformats.latex =
  {
    luatex = {binary = "luahbtex",format = "lualatex"},
    ptex  = {binary = "eptex"},
    uptex = {binary = "euptex"},
    ["etex-dvips"] = {binary = "etex", format = "latex"},
    ["etex-dvisvgm"] =
      {
        binary = "etex",
        format = "latex",
        tokens = "\\ExplSyntaxOn\\sys_load_backend:n{dvisvgm}\\ExplSyntaxOff"
      }
  }
checkengines =
  {"pdftex", "luatex", "xetex", "etex-dvips", "etex-dvisvgm", "uptex"}

-- Enable loading pdfmanagement support files from system texmf
checksearch = true

-- Load the common build code
dofile(maindir .. "/build-config.lua")

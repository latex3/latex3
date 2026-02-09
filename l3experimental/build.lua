#!/usr/bin/env texlua

-- Build script for LaTeX3 "l3experimental" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3experimental"
module = ""

-- Location of main directory: use Unix-style path separators
maindir = ".."

uploadconfig = {
  author      = "The LaTeX Project team",
  license     = "lppl1.3c",
  summary     = "Experimental LaTeX3 concepts",
  topic       = {"macro-supp","latex3","expl3"},
  ctanPath    = "/macros/latex/contrib/l3experimental",
  repository  = "https://github.com/latex3/latex3/",
  bugtracker  = "https://github.com/latex3/latex3/issues",
  update      = true,
  description = [[
The `l3experimental` packages are a collection of experimental
implementations for aspects of the LaTeX3 kernel, dealing with
higher-level ideas such as the Designer Interface. Some of them work as
stand alone packages, providing new functionality, and can be used on
top of LaTeX2e with no changes to the existing kernel.

The present release includes:
- `l3benchmark` for measuring the time taken by TeX to run certain code;
- `l3draw`, a code-level interface for constructing drawings;
- `l3str`, support for string manipulation;
- `l3sys-shell`, which provides abstractions for common shell functions like
  file deletion and copying;
- [`xcoffins`](https://ctan.org/pkg/xcoffins), which allows the alignment of
  boxes using a series of 'handle' positions, supplementing the simple TeX
  reference point;
- [`xgalley`](https://ctan.org/pkg/xgalley), which controls boxes receiving
  text for typesetting.
  ]]
}

-- Load the common build code
dofile(maindir .. "/build-config.lua")

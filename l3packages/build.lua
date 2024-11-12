#!/usr/bin/env texlua

-- Build script for LaTeX3 "l3packages" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3packages"
module = ""

-- Location of main directory: use Unix-style path separators
maindir = ".."

uploadconfig = {
  author      = "The LaTeX Project team",
  license     = "lppl1.3c",
  summary     = "High-level LaTeX3 concepts",
  topic       = {"macro-supp","latex3","expl3"},
  ctanPath    = "/macros/latex/contrib/l3packages",
  repository  = "https://github.com/latex3/latex3/",
  bugtracker  = "https://github.com/latex3/latex3/issues",
  update      = true,
  description = [[
This collection contains implementations for aspects of the LaTeX3 kernel,
dealing with higher-level ideas such as the Designer Interface. The packages
here are considered broadly stable (The LaTeX Project does not expect the
interfaces to alter radically). These packages are built on LaTeX2e
conventions at the interface level, and so may not migrate in the current
form to a stand-alone LaTeX3 format.

Packages provided:
- [`xparse`](https://ctan.org/pkg/xparse), which provides a high-level interface
  for declaring document commands
- [`xfp`](https://ctan.org/pkg/xfp), an expandable IEEE 754 FPU for LaTeX
- [`l3keys2e`](https://ctan.org/pkg/l3keys2e), which makes the facilities of the
  [kernel](https://ctan.org/pkg/l3kernel) module `l3keys` available for use by
  LaTeX2e packages
- [`xtemplate`](https://ctan.org/pkg/xtemplate), which provides a means of
  defining generic functions using a key-value syntax
  ]]
}

-- Load the common build code
dofile(maindir .. "/build-config.lua")

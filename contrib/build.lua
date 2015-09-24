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
    maindir .. "/l3build",
    maindir .. "/l3kernel",
    maindir .. "/l3packages/xparse",
    maindir .. "/l3packages/l3keys2e"
  }
checksearch = true

-- Load the common build code: this is the one place that a path needs to be
-- hard-coded
-- As the build system is 'self-contained' there is no module set up here: just
--load the file in a similar way to a TeX \input
dofile (maindir .. "/build-config.lua")
dofile (maindir .. "/l3build/l3build.lua")

#!/usr/bin/env texlua

-- Build Script for LaTeX3 "xcoffins" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3experimental"
module = "xcoffins"

-- Location of main directory: use Unix-style path separators\includegraphics[]{C:/Users/Public/Documents/LaTeX/LaTeX3/trunk/l3experimental/xcoffins/elementare-typographie-title.jpg}

maindir = "../.."

-- Non-standard settings
checkdeps   = {maindir .. "/l3kernel", maindir .. "/l3packages/xparse"}
typesetdeps = {maindir .. "/l3kernel", maindir .. "/l3packages/xparse"}

-- Load the common build code: this is the one place that a path needs to be
-- hard-coded
-- As the build system is 'self-contained' there is no module set up here: just
--load the file in a similar way to a TeX \input
dofile (maindir .. "/l3build/l3build.lua")

-- Call the main function which is defined in l3build.lua
main (arg[1], arg[2], arg[3])

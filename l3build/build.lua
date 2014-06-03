#!/usr/bin/env texlua

-- Build script for LaTeX3 "l3build" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3build"
module = ""

-- Location of main directory: use Unix-style path separators
maindir = ".."

-- Non-standard settings
cleanfiles   = {"*.pdf", "*.tex", "*.zip"}
installfiles = {"l3build.lua", "regression-test.tex"}
sourcefiles  = {"*.dtx", "l3build.lua"}
typesetcmds  = "\\AtBeginDocument{\\DisableImplementation}"

-- Load the common build code: this is the one place that a path needs to be
-- hard-coded
-- As the build system is 'self-contained' there is no module set up here: just
--load the file in a similar way to a TeX \input
dofile (maindir .. "/l3build/l3build.lua")

-- There are no modules: just use the bundle name
moduledir = "latex/" .. bundle

-- ctan () uses allmodules () to deal with each module
-- As this is the only use relied on in l3kernel, a simple change here
-- allows code sharing
function allmodules (target)
  bundlectan ()
end

-- l3build does all of the targets itself: a bit of an odd case
function main (target)
  if target == "clean" then
    clean ()
  elseif target == "ctan" then
    ctan ()
  elseif target == "doc" then
    doc ()
  elseif target == "install" then
    install ()
  elseif target == "localinstall" then -- 'Hidden' target
      localinstall ()
  elseif target == "unpack" then
    unpack ()
  else
    help ()
  end
end

-- Call the main function which is defined in l3build.lua
main (arg[1])

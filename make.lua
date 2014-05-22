#!/usr/bin/env texlua

-- Make script for LaTeX3 files

--  No bundle or module here, but these have to be defined
bundle  = ""
module  = ""

-- A couple of custom variables: the order here is set up for 'importance'
bundles     = {"l3kernel", "l3packages", "l3experimental"} -- l3trial to be added
ctanbundles = {"l3kernel", "l3packages", "l3experimental"}

-- Location of main directory: use Unix-style path separators
maindir = "."

-- Load the common build code: this is the one place that a path needs to be
-- hard-coded
-- As the build system is 'self-contained' there is no module set up here: just
--load the file in a similar way to a TeX \input
dofile (maindir .. "/support/l3make.lua")

-- Help for the master script is simple
function help ()
  print ""
  print " make check        - run automated check system       "
  print " make ctan         - create CTAN-ready archive        "
  print " make doc          - runs all documentation files     "
  print " make clean        - clean out directory tree         "
  print " make localinstall - install files in local texmf tree"
  print " make unpack       - extract packages                 "
  print ""
end

-- A custom main function
function main (target)
  local function dobundles (bundles, target)
    local errorlevel = 0
    for _,i in ipairs (bundles) do
      errorlevel = run (i, "texlua make.lua " .. target)
      if errorlevel ~= 0 then
        break
      end
    end
  end
  if target == "check" then
    dobundles (bundles, "check")
  elseif target == "clean" then
    print ("Cleaning up")
    dobundles (bundles, "clean")
    rm (".", "*.zip")
  elseif target == "ctan" then
    local errorlevel = dobundles (ctanbundles, "ctan")
    if errorlevel == 0 then
      for _,i in ipairs (ctanbundles) do
        cp (i .. ".zip", i, ".")
      end
    end
  elseif target == "doc" then
    dobundles (bundles, "doc")
  elseif target == "localinstall" then
    dobundles (bundles, "localinstall")
  elseif target == "unpack" then
    dobundles (bundles, "unpack")
  else
    help ()
  end
end

-- Call the main function
main (arg[1])
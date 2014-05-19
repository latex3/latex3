#!/usr/bin/env texlua

-- Make script for LaTeX3 "l3kernel" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle  = "l3kernel"
module  = ""

-- Location of main directory: use Unix-style path separators
maindir = ".."

-- Non-standard settings
installfiles = {"*.def", "*.cls", "*.sty", "*.tex"}
typesetfiles =
  {
    "expl3.dtx", "l3docstrip.dtx", "interface3.tex", "l3syntax-changes.tex",
    "l3styleguide.tex", "source3.tex"
  }
unpackfiles  = {"l3.ins"}

-- Load the common build code: this is the one place that a path needs to be
-- hard-coded
-- As the build system is 'self-contained' there is no module set up here: just
--load the file in a similar way to a TeX \input
dofile (maindir .. "/support/l3make.lua")

-- Unlike other parts of the build system, l3kernel has quite a number of
-- non-standard requirements and so a number of the functions are rewritten
-- with modification here
-- Some of these are as simple as the fact that there is no module/bundle
-- variation here

-- There are no modules: just use the bundle name
moduledir   = "latex/" .. bundle

-- l3kernel does all of the targets itself
function help ()
  print ""
  print " make check           - run automated check system       "
  print " make checklvt <name> - check one test file <name>       "
  print " make ctan            - create CTAN-ready archive        "
  print " make doc             - runs all documentation files     "
  print " make clean           - clean out directory tree         "
  print " make localinstall    - install files in local texmf tree"
  print " make savetlg <name>  - save test log for <name>         "
  print " make unpack          - extract packages                 "
  print ""
end

-- ctan () uses allmodules () to deal with each module
-- As this is the only use relied on in l3kernel, a simple change here
-- allows code sharing
function allmodules (target)
  bundlectan ()
end

-- Avoid an infinite loop
function unpack ()
  cleandir (unpackdir)
  bundleunpack ()
end

-- l3kernel does all of the targets itself
function main (target, file)
  if target == "check" then
    print ("Not implemented yet!")
    -- check ()
  elseif target == "checklvt"  then
    if file then
      print ("Not implemented yet!")
      -- checklvt (file)
    else
      help ()
    end
  elseif target == "clean" then
    clean ()
  elseif target == "ctan" then
    ctan ()
  elseif target == "doc" then
    doc ()
  elseif target == "localinstall" then
    localinstall ()
  elseif target == "savetlg" then
    if file then
      print ("Not implemented yet!")
      -- savetlg (file)
    else
      help ()
    end
  elseif target == "unpack" then
    unpack ()
    -- Additional for l3kernel: put the unpacked files somewhere known
    for _,i in ipairs (installfiles) do
      cp (i, unpackdir, localdir)
   end
  else
    help ()
  end
end

-- Call the main function which is defined in l3make.lua
main (arg[1], arg[2], arg[3])

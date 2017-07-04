#!/usr/bin/env texlua

-- Build script for LaTeX3 files

--  No bundle or module here, but these have to be defined
bundle  = "LaTeX3"
module  = ""

-- A couple of custom variables: the order here is set up for 'importance'
bundles      = {"l3kernel", "l3packages", "l3experimental", "l3trial"}
checkbundles =
  {
    "l3kernel",
    "l3packages",
    "l3experimental",
    "l3trial",
    "contrib"
  }
ctanbundles  = {"l3kernel", "l3packages", "l3experimental"}

-- Location of main directory: use Unix-style path separators
maindir = "."

-- A custom main function
function main (target)
  local errorlevel
  if target == "check" then
    errorlevel = call(checkbundles, "check")
  elseif target == "clean" then
    print ("Cleaning up")
    dobundles (bundles, "clean")
    rm (".", "*.zip")
  elseif target == "ctan" then
    errorlevel = call (ctanbundles, "ctan")
    if errorlevel == 0 then
      for _,i in ipairs (ctanbundles) do
        cp (i .. ".zip", i, ".")
      end
    end
  elseif target == "doc" then
    errorlevel = call(bundles, "doc")
  elseif target == "install" then
    errorlevel = call (bundles, "install")
  elseif target == "setversion" then
    errorlevel = call(bundles, "setversion")
  elseif target == "unpack" then
    errorlevel = call (bundles, "unpack")
  elseif target == "version" then
      version ()
  else
    help ()
  end
  if errorlevel ~=0 then
    os.exit(1)
  end
end

-- Find and run the build system
kpse.set_program_name("kpsewhich")
dofile(kpse.lookup("l3build.lua"))

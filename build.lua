#!/usr/bin/env texlua

-- Build script for LaTeX3 files

--  No bundle or module here, but these have to be defined
bundle  = "LaTeX3"
module  = ""

-- A couple of custom variables: the order here is set up for 'importance'
bundles      = {"l3backend", "l3kernel", "l3packages", "l3experimental", "l3trial"}
checkbundles =
  {
    "l3kernel",
    "l3packages",
    "l3experimental",
    "l3trial",
    "contrib"
  }
ctanbundles  = {"l3backend", "l3kernel", "l3packages", "l3experimental"}

-- Location of main directory: use Unix-style path separators
maindir = "."

-- A custom main function
function main(target)
  local errorlevel
  if target == "check" then
    errorlevel = call(checkbundles, "check")
  elseif target == "clean" then
    print ("Cleaning up")
    call(bundles, "clean")
    rm (".", "*.zip")
  elseif target == "ctan" then
    errorlevel = call (ctanbundles, "ctan")
    if errorlevel == 0 then
      for _,i in ipairs (ctanbundles) do
        cp ("*.zip", i, ".")
      end
    end
  elseif target == "doc" then
    errorlevel = call(ctanbundles, "doc")
  elseif target == "install" then
    errorlevel = call (bundles, "install")
  elseif target == "uninstall" then
    errorlevel = call(bundles,"uninstall")
  elseif target == "unpack" then
    errorlevel = call (bundles, "unpack")
  elseif target == "upload" then
    errorlevel = call(ctanbundles,"upload")
  elseif target == "tag" then
    if options["names"] and #options["names"] == 1 then
        call(ctanbundles,"tag")
      else
        print("Tag name required")
        help()
        exit(1)
      end
  else
    help ()
  end
  if errorlevel ~=0 then
    os.exit(1)
  end
end

-- Find and run the build system
kpse.set_program_name("kpsewhich")
if not release_date then
  dofile(kpse.lookup("l3build.lua"))
end


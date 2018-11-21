#!/usr/bin/env texlua

-- Build script for LaTeX3 "xmarks" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3trial"
module = "xmarks"

-- Location of main directory: use Unix-style path separators
maindir = "../.."

-- Non-standard settings
checkdeps = {maindir .. "/l3packages/xparse"}

-- not doing uptex as it generates spurious font warnings ...

checkengines    = checkengines
  or {"pdftex", "xetex", "luatex", "ptex"}


-- sourcefiles = {"*.dtx", "*.ins", "*-????-??-??.sty", "l3doc-TUB.cls"}

typesetfiles  = {"*.tex"}

-- typesetsourcefiles = {"l3doc-TUB.cls"}

checkruns     = 2



checksuppfiles  = 
  {
    "CaseFolding.txt",
    "SpecialCasing.txt",
    "UnicodeData.txt",
    "article.cls",
    "etoolbox.sty",
    "fontenc.sty",
    "minimal.cls",
    "ot1enc.def",
    "regression-test.cfg",
    "regression-test.tex",
    "size10.clo",
  }


-- Load the common build code
dofile(maindir .. "/build-config.lua")

-- Find and run the build system
kpse.set_program_name("kpsewhich")
if not release_date then
  dofile(kpse.lookup("l3build.lua"))
end


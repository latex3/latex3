#!/usr/bin/env texlua

-- Build script for LaTeX3 "l3experimental" files

-- Identify the bundle and module: the module may be empty in the case where
-- there is no subdivision
bundle = "l3experimental"
module = ""

-- Location of main directory: use Unix-style path separators
maindir = ".."

uploadconfig = {
  author      = "The LaTeX Team",
  license     = "lppl1.3c",
  summary     = "Experimental LaTeX3 concepts",
  topic       = {"macro-supp","latex3","expl3"},
  ctanPath    = "/macros/latex/contrib/l3experimental",
  repository  = "https://github.com/latex3/latex3/",
  bugtracker  = "https://github.com/latex3/latex3/issues",
  update      = true,
  description = [[
The `l3­ex­per­i­men­tal` pack­ages are a col­lec­tion of ex­per­i­men­tal
im­ple­men­ta­tions for as­pects of the LaTeX3 ker­nel, deal­ing with
higher-level ideas such as the De­signer In­ter­face. Some of them work as
stand alone pack­ages, pro­vid­ing new func­tion­al­ity, and can be used on
top of LaTeX2e with no changes to the ex­ist­ing ker­nel.

The present re­lease in­cludes:
- `l3bench­mark` for mea­sur­ing the time taken by TeX to run cer­tain code;
- `l3c­ctab`, sup­port for sav­ing and restor­ing cat­e­gory codes en masse in a
  ta­ble;
- `l3­color`, sup­port for set­ting col­ors us­ing a range of color mod­els;
- `l3­draw`, a code-level in­ter­face for con­struct­ing draw­ings;
- `l3­graph­ics`, an in­ter­faces for the in­clu­sion of graph­ics files;
- `l3pdf`, sup­port for core PDF con­cepts like com­pres­sion, ob­jects, PDF
  ver­sion and so on;
- `l3str`, sup­port for string ma­nip­u­la­tion;
- `l3sys-shell`, which pro­vides ab­strac­tions for com­mon shell func­tions like
  file dele­tion and copy­ing;
- [`xcoffins`](https://ctan.org/pkg/xcoffins), which al­lows the align­ment of
  boxes us­ing a se­ries of 'han­dle' po­si­tions, sup­ple­ment­ing the sim­ple TeX
  ref­er­ence point;
- [`xgal­ley`](https://ctan.org/pkg/xgalley), which con­trols boxes re­ceiv­ing
  text for type­set­ting.
  ]]
}

-- Load the common build code
dofile(maindir .. "/build-config.lua")

-- Find and run the build system
kpse.set_program_name("kpsewhich")
if not release_date then
  dofile(kpse.lookup("l3build.lua"))
end


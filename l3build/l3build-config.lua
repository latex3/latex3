-- Common settings for LaTeX3 development repo, used by l3build script

checkdeps   = checkdeps   or {maindir .. "/l3kernel", maindir .. "/l3build"}
typesetdeps = typesetdeps or {maindir .. "/l3kernel"}
unpackdeps  = unpackdeps  or {maindir .. "/l3kernel"}

cmdchkfiles     = {"*.dtx"}
checksuppfiles  =
  {"etex.sty", "minimal.cls", "regression-test.cfg"}
readmefiles     = {"README.markdown"}
unpacksuppfiles = {"docstrip.tex"}

packtdszip  = true

typesetcmds = "\\AtBeginDocument{\\DisableImplementation}"

if checksearch == nil then
  checksearch = false
end
if unpacksearch == nil then
  unpacksearch = false
end

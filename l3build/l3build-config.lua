-- Common settings for LaTeX3 development repo, used by l3build script

checkdeps   = checkdeps   or {maindir .. "/l3kernel", maindir .. "/l3build"}
typesetdeps = typesetdeps or {maindir .. "/l3kernel"}
unpackdeps  = unpackdeps  or {maindir .. "/l3kernel"}

unpacksuppfiles = {"docstrip.tex"}

typesetcmds = "\\AtBeginDocument{\\DisableImplementation}"

checksearch  = false
unpacksearch = false
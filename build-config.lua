-- Common settings for LaTeX3 development repo, used by l3build script

checkdeps   = checkdeps   or {maindir .. "/l3kernel", maindir .. "/l3build"}
typesetdeps = typesetdeps or {maindir .. "/l3kernel"}
unpackdeps  = unpackdeps  or {maindir .. "/l3kernel"}

cmdchkfiles     = cmdchkfiles     or {"*.dtx"}
checkengines    = checkengines    or {"pdftex", "xetex", "luatex", "ptex", "uptex"}
checksuppfiles  = checksuppfiles  or {"minimal.cls", "regression-test.cfg"}
unpacksuppfiles = unpacksuppfiles or {"docstrip.tex"}
versionfiles    = versionfiles    or {"*.dtx", "README.md"}

packtdszip  = true

typesetcmds = typesetcmds or "\\AtBeginDocument{\\DisableImplementation}"

if checksearch == nil then
  checksearch = false
end
if unpacksearch == nil then
  unpacksearch = false
end

-- Detail how to set the version automatically
function setversion_update_line(line, date, version)
  local date = string.gsub(date, "%-", "/")
  -- Replace the identifiers
  if string.match(line, "^\\def\\ExplFileDate{%d%d%d%d/%d%d/%d%d}$") then
    line = "\\def\\ExplFileDate{" .. date .. "}"
  end
  if string.match(line, "^\\def\\ExplFileVersion{%d+}$") then
    line = "\\def\\ExplFileVersion{" .. version .. "}"
  end
  -- Update the interlock
  if string.match(
    line, "^\\RequirePackage{expl3}%[%d%d%d%d/%d%d/%d%d%]$"
  ) then
    line = "\\RequirePackage{expl3}[" .. date .. "]"
  end
  if string.match(
    line, "^%%<package>\\@ifpackagelater{expl3}{%d%d%d%d/%d%d/%d%d}$"
  ) then
    line = "%<package>\\@ifpackagelater{expl3}{" .. date .. "}"
  end
  if string.match(
    line, "^Release %d%d%d%d/%d%d/%d%d %(r%d%d%d%d%)$"
  ) then
    line = "Release " .. date .. " (r" .. version .. ")"
  end
  return line
end

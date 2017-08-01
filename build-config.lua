-- Common settings for LaTeX3 development repo, used by l3build script

checkdeps   = checkdeps   or {maindir .. "/l3kernel"}
typesetdeps = typesetdeps or {maindir .. "/l3kernel"}
unpackdeps  = unpackdeps  or {maindir .. "/l3kernel"}

cmdchkfiles     = cmdchkfiles     or {"*.dtx"}
checkengines    = checkengines
  or {"pdftex", "xetex", "luatex", "ptex", "uptex"}
checksuppfiles  = checksuppfiles  or
  {
    "CaseFolding.txt",
    "fontenc.sty",
    "minimal.cls",
    "ot1enc.def",
    "regression-test.cfg",
    "regression-test.tex",
    "SpecialCasing.txt",
    "UnicodeData.txt",
  }
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
setversion_update_line =
  setversion_update_line or function(line, date, version)
  local date = string.gsub(date, "%-", "/")
  -- Replace the identifiers
  if string.match(line, "^\\def\\ExplFileDate{%d%d%d%d/%d%d/%d%d}%%?$") or
     string.match(line, "^%%? ?\\date{Released %d%d%d%d/%d%d/%d%d}$") then
    line = string.gsub(line, "%d%d%d%d/%d%d/%d%d", date)
  end
  -- No real regex so do it one type at a time
  for _,i in pairs({"Class", "File", "Package"}) do
    if string.match(
      line,
      "^\\ProvidesExpl" .. i .. " *{[a-zA-Z0-9%-%.]+}"
    ) then
      line = string.gsub(
        line,
        "{%d%d%d%d/%d%d/%d%d}",
        "{" .. string.gsub(date, "%-", "/") .. "}"
      )
   end
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
    line, "^Release %d%d%d%d/%d%d/%d%d$"
  ) then
    line = "Release " .. date
  end
  return line
end

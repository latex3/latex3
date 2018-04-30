-- Common settings for LaTeX3 development repo, used by l3build script

checkdeps   = checkdeps   or {maindir .. "/l3kernel"}
typesetdeps = typesetdeps or {maindir .. "/l3kernel"}
unpackdeps  = unpackdeps  or {maindir .. "/l3kernel"}

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
tagfiles = tagfiles or {"*.dtx", "README.md"}
unpacksuppfiles = unpacksuppfiles or {"docstrip.tex"}


packtdszip  = true

typesetcmds = typesetcmds or "\\AtBeginDocument{\\DisableImplementation}"

if checksearch == nil then
  checksearch = false
end
if unpacksearch == nil then
  unpacksearch = false
end

-- Detail how to set the version automatically
function update_tag(file,content,tagname,tagdate)
  local iso = "%d%d%d%d%-%d%d%-%d%d"
  if string.match(file,"%.dtx$") then
    content = string.gsub(content,
      "\n\\ProvidesExpl" .. "(%w+ *{[^}]+} *){" .. iso .. "}",
      "\n\\ProvidesExpl%1{" .. tagname .. "}")
    return string.gsub(content,
      "\n%% \\date{Released " .. iso .. "}\n",
      "\n%% \\date{Released " .. tagname .. "}\n")
  elseif string.match(file,"%.md$") then
    return string.gsub(content,
      "\nRelease " .. iso .. "\n",
      "\nRelease " .. tagname .. "\n")
  end
  return content
end

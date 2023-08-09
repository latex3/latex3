testfiledir  = "testfiles-backend"

-- Set up to allow testing dvips, etc.
specialformats = specialformats or {}
specialformats.latex =
  {
    luatex = {binary = "luahbtex",format = "lualatex"},
    ptex  = {binary = "eptex"},
    uptex = {binary = "euptex"},
    ["etex-dvips"] = {binary = "etex", format = "latex"},
    ["etex-dvisvgm"] =
      {
        binary = "etex",
        format = "latex",
        tokens = "\\PassOptionsToPackage{backend=dvisvgm}{expl3}"
      }
  }
checkengines =
  {"pdftex", "luatex", "xetex", "etex-dvips", "etex-dvisvgm", "uptex"}
-----------------------------------------------------------------------
--         FILE:  luaotfload-tounicode.lua
--  DESCRIPTION:  part of luaotfload / tounicode overwrites
-----------------------------------------------------------------------

local ProvidesLuaModule = { 
    name          = "luaotfload-tounicode",
    version       = "3.13",       --TAGVERSION
    date          = "2020-05-01", --TAGDATE
    description   = "luaotfload submodule / tounicode",
    license       = "GPL v2.0",
    author        = "Hans Hagen, Khaled Hosny, Elie Roux, Philipp Gesang, Marcel Krüger",
    copyright     = "PRAGMA ADE / ConTeXt Development Team",
}

if luatexbase and luatexbase.provides_module then
  luatexbase.provides_module (ProvidesLuaModule)
end  

local overloads = {
  -- rougly based on texglyphlist-g2u.txt

  -- ff = { unicode = {0x0066, 0x0066} },
  -- ffi = { unicode = {0x0066, 0x0066, 0x0069} },
  -- ffl = { unicode = {0x0066, 0x0066, 0x006C} },
  -- fi = { unicode = {0x0066, 0x0069} },
  -- fl = { unicode = {0x0066, 0x006C} },
  longst = { unicode = {0x017F, 0x0074} },
  st = { unicode = {0x0073, 0x0074} },
  AEsmall = { unicode = 0x00E6 },
  Aacutesmall = { unicode = 0x00E1 },
  Acircumflexsmall = { unicode = 0x00E2 },
  Acute = { unicode = 0x00B4 },
  Acutesmall = { unicode = 0x00B4 },
  Adieresissmall = { unicode = 0x00E4 },
  Agravesmall = { unicode = 0x00E0 },
  Aringsmall = { unicode = 0x00E5 },
  Asmall = { unicode = 0x0061 },
  Atildesmall = { unicode = 0x00E3 },
  Brevesmall = { unicode = 0x02D8 },
  Bsmall = { unicode = 0x0062 },
  Caron = { unicode = 0x02C7 },
  Caronsmall = { unicode = 0x02C7 },
  Ccedillasmall = { unicode = 0x00E7 },
  Cedillasmall = { unicode = 0x00B8 },
  Circumflexsmall = { unicode = 0x02C6 },
  Csmall = { unicode = 0x0063 },
  Dieresis = { unicode = 0x00A8 },
  DieresisAcute = { unicode = 0xF6CC },
  DieresisGrave = { unicode = 0xF6CD },
  Dieresissmall = { unicode = 0x00A8 },
  Dotaccentsmall = { unicode = 0x02D9 },
  Dsmall = { unicode = 0x0064 },
  Eacutesmall = { unicode = 0x00E9 },
  Ecircumflexsmall = { unicode = 0x00EA },
  Edieresissmall = { unicode = 0x00EB },
  Egravesmall = { unicode = 0x00E8 },
  Esmall = { unicode = 0x0065 },
  Ethsmall = { unicode = 0x00F0 },
  Fsmall = { unicode = 0x0066 },
  Grave = { unicode = 0x0060 },
  Gravesmall = { unicode = 0x0060 },
  Gsmall = { unicode = 0x0067 },
  Hsmall = { unicode = 0x0068 },
  Hungarumlaut = { unicode = 0x02DD },
  Hungarumlautsmall = { unicode = 0x02DD },
  Iacutesmall = { unicode = 0x00ED },
  Icircumflexsmall = { unicode = 0x00EE },
  Idieresissmall = { unicode = 0x00EF },
  Igravesmall = { unicode = 0x00EC },
  Ismall = { unicode = 0x0069 },
  Jsmall = { unicode = 0x006A },
  Ksmall = { unicode = 0x006B },
  LL = { unicode = {0x004C, 0x004C} },
  Lslashsmall = { unicode = 0x0142 },
  Lsmall = { unicode = 0x006C },
  Macron = { unicode = 0x00AF },
  Macronsmall = { unicode = 0x00AF },
  Msmall = { unicode = 0x006D },
  Nsmall = { unicode = 0x006E },
  Ntildesmall = { unicode = 0x00F1 },
  OEsmall = { unicode = 0x0153 },
  Oacutesmall = { unicode = 0x00F3 },
  Ocircumflexsmall = { unicode = 0x00F4 },
  Odieresissmall = { unicode = 0x00F6 },
  Ogoneksmall = { unicode = 0x02DB },
  Ogravesmall = { unicode = 0x00F2 },
  Oslashsmall = { unicode = 0x00F8 },
  Osmall = { unicode = 0x006F },
  Otildesmall = { unicode = 0x00F5 },
  Psmall = { unicode = 0x0070 },
  Qsmall = { unicode = 0x0071 },
  Ringsmall = { unicode = 0x02DA },
  Rsmall = { unicode = 0x0072 },
  Scaronsmall = { unicode = 0x0161 },
  Ssmall = { unicode = 0x0073 },
  Thornsmall = { unicode = 0x00FE },
  Tildesmall = { unicode = 0x02DC },
  Tsmall = { unicode = 0x0074 },
  Uacutesmall = { unicode = 0x00FA },
  Ucircumflexsmall = { unicode = 0x00FB },
  Udieresissmall = { unicode = 0x00FC },
  Ugravesmall = { unicode = 0x00F9 },
  Usmall = { unicode = 0x0075 },
  Vsmall = { unicode = 0x0076 },
  Wsmall = { unicode = 0x0077 },
  Xsmall = { unicode = 0x0078 },
  Yacutesmall = { unicode = 0x00FD },
  Ydieresissmall = { unicode = 0x00FF },
  Ysmall = { unicode = 0x0079 },
  Zcaronsmall = { unicode = 0x017E },
  Zsmall = { unicode = 0x007A },
  ampersandsmall = { unicode = 0x0026 },
  asuperior = { unicode = 0x0061 },
  bsuperior = { unicode = 0x0062 },
  centinferior = { unicode = 0x00A2 },
  centoldstyle = { unicode = 0x00A2 },
  centsuperior = { unicode = 0x00A2 },
  commainferior = { unicode = 0x002C },
  commasuperior = { unicode = 0x002C },
  copyrightsans = { unicode = 0x00A9 },
  copyrightserif = { unicode = 0x00A9 },
  cyrBreve = { unicode = 0x02D8 },
  cyrFlex = { unicode = {0x00A0, 0x0311} },
  cyrbreve = { unicode = 0x02D8 },
  cyrflex = { unicode = {0x00A0, 0x0311} },
  dblGrave = { unicode = {0x00A0, 0x030F} },
  dblgrave = { unicode = {0x00A0, 0x030F} },
  dieresisacute = { unicode = {0x00A0, 0x0308, 0x0301} },
  dieresisgrave = { unicode = {0x00A0, 0x0308, 0x0300} },
  dollarinferior = { unicode = 0x0024 },
  dollaroldstyle = { unicode = 0x0024 },
  dollarsuperior = { unicode = 0x0024 },
  dotlessj = { unicode = 0x0237 },
  dsuperior = { unicode = 0x0064 },
  eightoldstyle = { unicode = 0x0038 },
  esuperior = { unicode = 0x0065 },
  exclamdownsmall = { unicode = 0x00A1 },
  exclamsmall = { unicode = 0x0021 },
  fiveoldstyle = { unicode = 0x0035 },
  fouroldstyle = { unicode = 0x0034 },
  hypheninferior = { unicode = 0x002D },
  hyphensuperior = { unicode = 0x002D },
  isuperior = { unicode = 0x0069 },
  ll = { unicode = {0x006C, 0x006C} },
  lsuperior = { unicode = 0x006C },
  msuperior = { unicode = 0x006D },
  nineoldstyle = { unicode = 0x0039 },
  onefitted = { unicode = 0x0031 },
  oneoldstyle = { unicode = 0x0031 },
  osuperior = { unicode = 0x006F },
  periodinferior = { unicode = 0x002E },
  periodsuperior = { unicode = 0x002E },
  questiondownsmall = { unicode = 0x00BF },
  questionsmall = { unicode = 0x003F },
  registersans = { unicode = 0x00AE },
  registerserif = { unicode = 0x00AE },
  rsuperior = { unicode = 0x0072 },
  rupiah = { unicode = 0x20A8 },
  sevenoldstyle = { unicode = 0x0037 },
  sixoldstyle = { unicode = 0x0036 },
  ssuperior = { unicode = 0x0073 },
  threeoldstyle = { unicode = 0x0033 },
  trademarksans = { unicode = 0x2122 },
  trademarkserif = { unicode = 0x2122 },
  tsuperior = { unicode = 0x0074 },
  twooldstyle = { unicode = 0x0032 },
  zerooldstyle = { unicode = 0x0030 },
  FFsmall = { unicode = {0x0066, 0x0066} },
  FFIsmall = { unicode = {0x0066, 0x0066, 0x0069} },
  FFLsmall = { unicode = {0x0066, 0x0066, 0x006C} },
  FIsmall = { unicode = {0x0066, 0x0069} },
  FLsmall = { unicode = {0x0066, 0x006C} },
  Germandblssmall = { unicode = {0x0073, 0x0073} },
  SSsmall = { unicode = {0x0073, 0x0073} },
}
-- For values that are used multiple times
local function registeroverload(mapped)
  mapped = {unicode = mapped}
  local function multiset(first, ...)
    if first then
      rawset(overloads, first, mapped)
      return multiset(...)
    end
  end
  return multiset
end

-- These come from ConTeXt
registeroverload { 0x49, 0x4A } ("IJ", "I_J", 0x0132)
registeroverload { 0x69, 0x6A } ("ij", "i_j", 0x0133)
registeroverload { 0x66, 0x66 } ("ff", "f_f", 0xFB00)
registeroverload { 0x66, 0x69 } ("fi", "f_i", 0xFB01)
registeroverload { 0x66, 0x6C } ("fl", "f_l", 0xFB02)
registeroverload { 0x66, 0x66, 0x69 } ("ffi", "f_f_i", 0xFB03)
registeroverload { 0x66, 0x66, 0x6C } ("ffl", "f_f_l", 0xFB04)
registeroverload { 0x66, 0x6A } ("fj", "f_j")
registeroverload { 0x66, 0x6B } ("fk", "f_k")

fonts.mappings.overloads = overloads

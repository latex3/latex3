-----------------------------------------------------------------------
--         FILE:  luaotfload-harf-define.lua
--  DESCRIPTION:  part of luaotfload / HarfBuzz / font definition
-----------------------------------------------------------------------
do -- block to avoid to many local variables error
 local ProvidesLuaModule = { 
     name          = "luaotfload-harf-define",
     version       = "3.13",       --TAGVERSION
     date          = "2020-05-01", --TAGDATE
     description   = "luaotfload submodule / database",
     license       = "GPL v2.0",
     author        = "Khaled Hosny, Marcel Krüger",
     copyright     = "Luaotfload Development Team",     
 }

 if luatexbase and luatexbase.provides_module then
  luatexbase.provides_module (ProvidesLuaModule)
 end  
end

local unpack = string.unpack
local stringlower = string.lower
local stringupper = string.upper
local gsub = string.gsub

local hb = luaotfload.harfbuzz
local scriptlang_to_harfbuzz = require'luaotfload-scripts'.to_harfbuzz

local harf_settings = luaotfload.harf or {}
luaotfload.harf = harf_settings

harf_settings.default_buf_flags = hb.Buffer.FLAGS_DEFAULT or 0

local hbfonts = {}

local cfftag  = hb.Tag.new("CFF ")
local cff2tag = hb.Tag.new("CFF2")
local os2tag  = hb.Tag.new("OS/2")
local posttag = hb.Tag.new("post")
local glyftag = hb.Tag.new("glyf")
local gpostag = hb.Tag.new("GPOS")

local invalid_l         = hb.Language.new()
local invalid_s         = hb.Script.new()

local floor = math.floor
local function round(x)
  return floor(x + 0.5)
end

local get_designsize do
  -- local lpeg = lpeg or require'lpeg'
  -- local size_patt = 'size' * lpeg.C(2)/function(s)
  --   local first, second = string.byte(s)
  --   return (first << 8) | second
  -- end
  local factor = 6578.176 -- =803/125*2^10=7227/7200/10*2^16
  function get_designsize(face)
    local buf = face:get_table(gpostag):get_data()
    if #buf == 0 then return 655360 end
    local major, feature_off = unpack(">HxxxxH", buf)
    assert(major == 1, "Unsupported major version of GPOS table")
    local feature_count = unpack(">H", buf, feature_off + 1)
    for off = feature_off + 3, feature_off + 6*feature_count, 6 do
      local tag = buf:sub(off, off + 3)
      if tag == 'size' then
        local off = feature_off + 1 + unpack(">H", buf, off + 4)
        local off = off + unpack(">H", buf, off)
        local design_size = unpack(">H", buf, off) -- unpack(">HHHHH", buf, off))
        return round(design_size * factor)
      end
    end
    return 655360
  end
end

local containers = luaotfload.fontloader.containers
local hbcacheversion = 1.1
local facecache = containers.define("fonts", "hb", hbcacheversion, true)

local function loadfont(spec)
  local path, sub = spec.resolved, spec.sub or 1

  local key = string.format("%s:%d", gsub(path, "[/\\]", ":"), sub)

  local attributes = lfs.attributes(path)
  if not attributes then return end
  local size, date = attributes.size or 0, attributes.modification or 0

  local cached = containers.read(facecache, key)
  local iscached = cached and cached.date == date and cached.size == size

  local hbface = iscached and cached.face or hb.Face.new(path, sub - 1)
  local tags = hbface and hbface:get_table_tags()
  -- If the face has no table tags then it isn’t a valid SFNT font that
  -- HarfBuzz can handle.
  if not tags then return end
  local hbfont = iscached and cached.font or hb.Font.new(hbface)

  if not iscached then
    local upem = hbface:get_upem()

    -- The engine seems to use the font type to tell whether there is a CFF
    -- table or not, so we check for that here.
    local fonttype = nil
    local hasos2 = false
    local haspost = false
    for i = 1, #tags do
      local tag = tags[i]
      if tag == cfftag or tag == cff2tag then
        fonttype = "opentype"
      elseif tag == glyftag then
        fonttype = "truetype"
      elseif tag == os2tag then
        hasos2 = true
      elseif tag == posttag then
        haspost = true
      end
    end

    local fontextents = hbfont:get_h_extents()
    local ascender = fontextents and fontextents.ascender or upem * .8
    local descender = fontextents and fontextents.descender or upem * .2

    local gid = hbfont:get_nominal_glyph(0x0020)
    local space = gid and hbfont:get_glyph_h_advance(gid) or upem / 2

    local slant = 0
    if haspost then
      local post = hbface:get_table(posttag)
      local length = post:get_length()
      local data = post:get_data()
      if length >= 32 and unpack(">i4", data) <= 0x00030000 then
        local italicangle = unpack(">i4", data, 5) / 2^16
        if italicangle ~= 0 then
          slant = -math.tan(italicangle * math.pi / 180) * 65536.0
        end
      end
    end

    -- Load glyph metrics for all glyphs in the font. We used to do this on
    -- demand to make loading fonts faster, but hit many limitations inside
    -- the engine (mainly with shared backend fonts, where the engine would
    -- assume all fonts it decides to share load the same set of glyphs).
    --
    -- Getting glyph advances is fast enough, but glyph extents are slower
    -- especially in CFF fonts. We might want to have an option to ignore exact
    -- glyph extents and use font ascender and descender if this proved to be
    -- too slow.
    local glyphcount = hbface:get_glyph_count()
    local glyphs = {}
    local autoitalic = slant ~= 0 and 20 or nil -- the magic 20 is taken from ConTeXt where it came from Dohyun Kim. We keep it to be metric compatible as far as possible
    for gid = 0, glyphcount - 1 do
      local width = hbfont:get_glyph_h_advance(gid)
      local height, depth, italic = nil, nil, nil
      local extents = hbfont:get_glyph_extents(gid)
      if extents then
        height = extents.y_bearing
        depth = extents.y_bearing + extents.height
        local right_bearing = extents.x_bearing + extents.width - width
        if autoitalic and right_bearing > -autoitalic then
          italic = right_bearing + autoitalic
        end
      end
      glyphs[gid] = {
        width  = width,
        height = height or ascender,
        depth  = -(depth or descender),
        italic = italic or 0,
      }
    end

    local unicodes = hbface:collect_unicodes()
    local characters = {}
    local nominals = {}
    for _, uni in next, unicodes do
      local glyph = hbfont:get_nominal_glyph(uni)
      if glyph then
        characters[uni] = glyph
        nominals[glyph] = uni
      end
    end

    local xheight, capheight = 0, 0
    if hasos2 then
      local os2 = hbface:get_table(os2tag)
      local length = os2:get_length()
      local data = os2:get_data()
      if length >= 96 and unpack(">H", data) > 1 then
        -- We don’t need much of the table, so we read from hard-coded offsets.
        xheight = unpack(">H", data, 87)
        capheight = unpack(">H", data, 89)
      end
    end

    if xheight == 0 then
      local gid = characters[120] -- x
      if gid then
        xheight = glyphs[gid].height
      else
        xheight = ascender / 2
      end
    end

    if capheight == 0 then
      local gid = characters[88] -- X
      if gid then
        capheight = glyphs[gid].height
      else
        capheight = ascender
      end
    end

    cached = {
      date = date,
      size = size,
      designsize = get_designsize(hbface),
      gid_offset = 0x120000,
      upem = upem,
      fonttype = fonttype,
      space = space,
      xheight = xheight,
      capheight = capheight,
      slant = slant,
      glyphs = glyphs,
      nominals = nominals,
      unicodes = characters,
      psname = hbface:get_name(hb.ot.NAME_ID_POSTSCRIPT_NAME),
      fullname = hbface:get_name(hb.ot.NAME_ID_FULL_NAME),
      haspng = hbface:ot_color_has_png(),
      loaded = {}, -- Cached loaded glyph data.
    }

    containers.write(facecache, key, cached)
  end
  cached.face = hbface
  cached.font = hbfont
  do
    local nominals = cached.nominals
    local gid_offset = cached.gid_offset
    cached.name_to_char = setmetatable({}, {__index = function(t, name)
      local gid = hbfont:get_glyph_from_name(name)
      local char = gid and (nominals[gid] or gid_offset + gid)
      t[name] = char -- ? Do we want this
      return char
    end})
  end

  return cached
end

-- Drop illegal characters from PS Name, per the spec
-- https://docs.microsoft.com/en-us/typography/opentype/spec/name#nid6
local function sanitize(psname)
  return psname:gsub('[][\0-\32\127-\255(){}<>/%%]', '-')
end

local function scalefont(data, spec)
  if not data then return data, spec end
  local size = spec.size
  local features = fonts.constructors.checkedfeatures("otf", spec.features.normal)
  features.mode = 'plug'
  features.features = 'harf'
  local hbface = data.face
  local hbfont = data.font
  local upem = data.upem
  local space = data.space
  local gid_offset = data.gid_offset

  if size < 0 then
    size = round(size * data.designsize / -1000)
  end

  -- We shape in font units (at UPEM) and then scale output with the desired
  -- sfont size.
  local scale = size / upem
  hbfont:set_scale(upem, upem)

  -- Populate font’s characters table.
  local glyphs = data.glyphs
  local characters = {}
  for gid, glyph in next, glyphs do
    characters[gid_offset + gid] = {
      index  = gid,
      width  = glyph.width  * scale,
      height = glyph.height * scale,
      depth  = glyph.depth  * scale,
      italic = glyph.italic * scale,
    }
  end

  local unicodes = data.unicodes
  for uni, gid in next, unicodes do
    characters[uni] = characters[gid_offset + gid]
  end

  -- Select font palette, we support `palette=index` option, and load the first
  -- one otherwise.
  local paletteidx = tonumber(features.palette or features.colr) or 1

  -- Load CPAL palette from the font.
  local palette = nil
  if hbface:ot_color_has_palettes() and hbface:ot_color_has_layers() then
    local count = hbface:ot_color_palette_get_count()
    if paletteidx <= count then
      palette = hbface:ot_color_palette_get_colors(paletteidx)
    end
  end

  local tfmdata = {
    name = spec.specification,
    filename = 'harfloaded:' .. spec.resolved,
    subfont = spec.sub or 1,
    designsize = data.designsize,
    psname = sanitize(data.psname),
    fullname = data.fullname,
    index = spec.index,
    size = size,
    units_per_em = upem,
    embedding = "subset",
    tounicode = 1,
    nomath = true,
    format = data.fonttype,
    squeeze = squeezefactor,
    characters = characters,
    parameters = {
      slant = data.slant,
      space = space * scale,
      space_stretch = space * scale / 2,
      space_shrink = space * scale / 3,
      x_height = data.xheight * scale,
      quad = size,
      extra_space = space * scale / 3,
      [8] = data.capheight * scale, -- for XeTeX compatibility.
    },
    hb = {
      scale = scale,
      palette = palette,
      shared = data,
      hscale = upem,
      vscale = upem,
      buf_flags = harf_settings.default_buf_flags,
    },
    specification = spec,
    shared = {
      features = features,
    },
    properties = {},
    resources = {
      unicodes = data.name_to_char,
    },
  }
  tfmdata.shared.processes = fonts.handlers.otf.setfeatures(tfmdata, features)
  fonts.constructors.applymanipulators("otf", tfmdata, features, false)
  return tfmdata
end

-- Register a reader for `harf` mode (`mode=harf` font option) so that we only
-- load fonts when explicitly requested. Fonts we load will be shaped by the
-- harf plugin in luaotfload-harf-plug.
fonts.readers.harf = function(spec)
  if not spec.resolved then return end
  local rawfeatures = spec.features.raw
  local hb_features = {}
  spec.hb_features = hb_features

  if rawfeatures.script then
    local script = stringlower(rawfeatures.script)
    if script == "dflt" then -- Probably a noop, HarfBuzz normalizes anyway
      script = "DFLT"
    end
    local language = stringupper(rawfeatures.language or 'dflt')
    language = language == "DFLT" and "dflt" or language
    local hb_script, hb_lang = scriptlang_to_harfbuzz(script, language)
    spec.script, spec.language = hb.Script.new(hb_script), hb.Language.new(hb_lang)
  elseif rawfeatures.language then
    local language = stringupper(rawfeatures.language)
    spec.language = hb.Language.new(language == "DFLT" and "dflt"
                                                        or language)
    spec.script = invalid_s
  else
    spec.script = invalid_s
    spec.language = invalid_l
  end
  for key, val in next, rawfeatures do
    if key:len() == 4 then
      -- 4-letter options are likely font features, but not always, so we do
      -- some checks below. Other options will be queried
      -- from spec.features.normal.
      if val == true or val == false then
        val = (val and '+' or '-')..key
        hb_features[#hb_features + 1] = hb.Feature.new(val)
      elseif tonumber(val) then
        val = '+'..key..'='..tonumber(val) - 1
        hb_features[#hb_features + 1] = hb.Feature.new(val)
      end
    end
  end
  return scalefont(loadfont(spec), spec)
end

local find_file = kpse.find_file
luatexbase.add_to_callback('find_opentype_file', function(name)
  return find_file(name, 'opentype fonts')
      or name:gsub('^harfloaded:', '')
end, 'luaotfload.harf.strip_prefix')

luatexbase.add_to_callback('find_truetype_file', function(name)
  return find_file(name, 'truetype fonts')
      or name:gsub('^harfloaded:', '')
end, 'luaotfload.harf.strip_prefix')

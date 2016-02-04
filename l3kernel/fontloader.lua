--- The fontloader uses the LuaTeX internal fontforge library (called
--- fontloader) to inspect an OpenType, a TrueType or a Type1 font. It
--- converts this font to a font structure  TeX uses internally.
--
--  fontloader.lua
--  speedata publisher
--
--  Copyright 2010-2011 Patrick Gundlach.
--  See file COPYING in the root directory for license info.


module(...,package.seeall)

--- Return `truetype`, `opentype` or `type1` depending on the string
--- `filename`. If not recognized form  the file name, return _nil_.
--- This function simply looks at the last three letters.
function guess_fonttype( filename )
    local f=filename:lower()
    if f:match(".*%.ttf$") then return "truetype"
    elseif f:match(".*%.otf$") then return "opentype"
    elseif f:match(".*%.pfb$") then return "type1"
    else return nil
    end
end

--- Return `true` if the this feature table `tab` has an entry for the
--- given `script` and `lang`. The table is something like:
---
---     [1] = {
---       ["langs"] = {
---         [1] = "AZE "
---         [2] = "CRT "
---         [3] = "TRK "
---       },
---       ["script"] = "latn"
---     },
function features_scripts_matches( tab,script,lang )
    local lang   = string.lower(lang)
    local script = string.lower(script)
    for i=1,#tab do
        local entry = tab[i]
        if string.lower(entry.script)==script then
            for j=1,#entry.langs do
                if string.lower(entry.langs[j])==lang then
                    return true
                end
            end
        end
    end
    return false
end

--- Convert codepoint to a UTF-16 string.
function to_utf16(codepoint)
    assert(codepoint)
    if codepoint < 65536 then
        return string.format("%04X",codepoint)
    else
        return string.format("%04X%04X",codepoint / 1024 + 0xD800 ,codepoint % 1024 + 0xDC00)
    end
end

--- Return the string that is responsible for the OpenType feature `featurename`.
--- Currently only lookups are for script `latn` and language `dflt`.
function find_feature_string(f,featurename)
    local ret = {}
    if f.gsub==nil then
        return ret
    end
    for i=1,#f.gsub do
        local gsub_tabelle=f.gsub[i]
        if gsub_tabelle.features then
            for j = 1,#gsub_tabelle.features do
                local gtf = gsub_tabelle.features[j]
                if gtf.tag==featurename and features_scripts_matches(gtf.scripts,"latn","dflt") then
                    if #gsub_tabelle.subtables ~= 1 then
                        -- w("warning: #subtables in gpos != 1")
                    end
                    ret[#ret + 1] = gsub_tabelle.subtables[1].name
                end
            end
        end
    end
    return ret
end

--- LuaTeX's fontloader (function `to_table()`) returns a rather complex table
--- with all kinds of information. Loading this table is expensive (_todo:
--- measure it_), so we  don't load it over and over agin if the user
--- requests the same font in a different size. We also cache  the `to_unicode` mapping.
--- Only the size dependent values are computed.
local lookup_fonttable_from_filename = {}


--- For define_font() we extend our file list
local fontlist = {}

local fp = os.getenv("SP_FONT_PATH")
if fp ~= "" then
  for _,dir in ipairs(string.explode(fp,":")) do
    for i in dirtree(dir) do
      local filename = i:gsub(".*/([^/]+)$","%1")
      fontlist[filename] = i
    end
  end
end



--- Return a TeX usable font table, or _nil_ plus an error message.
--- The parameter `name` is the filename (without path), `size` is
--- given in scaled points, `extra_parameter` is a table such as:
---     {
---       ["space"] = "25"
---       ["marginprotrusion"] = "100"
---       ["otfeatures"] = {
---         ["smcp"] = "true"
---       },
---     },
function define_font(name, size,extra_parameter)
    local extra_parameter = extra_parameter or {}
    local fonttable

    if lookup_fonttable_from_filename[name] then
        fonttable=lookup_fonttable_from_filename[name]
        assert(fonttable)
    else
        -- These are stored in the cached fonttable table
        local filename_with_path
        local lookup_codepoint_by_name   = {}
        local lookup_codepoint_by_number = {}

        filename_with_path = kpse.filelist[name] or fontlist[name]
        if not filename_with_path then return false, string.format("Fontfile '%s' not found.", name) end
        local font, err = fontloader.open(filename_with_path)
        if not font then
            if type(err) == "string" then
                return false, err
            else
                printtable("Font error",err)
            end
        end
        fonttable = fontloader.to_table(font)
        if fonttable == nil then return false, string.format("Problem while loading font '%s'",tostring(filename_with_path))  end

        -- Store the table for quicker lookup later.
        lookup_fonttable_from_filename[name]=fonttable

        fonttable.filename_with_path = filename_with_path
        local is_unicode = (fonttable.pfminfo.unicoderanges ~= nil)

        --- We require a mapping glyph number -> unicode codepoint. The problem is
        --- that TTF/OTF fonts have a different encoding mechanism. TTF/OTF can be
        --- accessed via the table `fonttable.map.backmap` (the key is the glyph
        --- number, the value is glyph name). For Type 1 fonts we use
        --- `glyph.unicode` and `glyph.name` for the codepoint and the name.
        ---
        --- For kerning a mapping glyphname -> codepoint is needed.
        if is_unicode then
            -- TTF/OTF, use map.backmap
            for i = 1,#fonttable.glyphs do
                local g=fonttable.glyphs[i]
                lookup_codepoint_by_name[g.name] = fonttable.map.backmap[i]
                lookup_codepoint_by_number[i]    = fonttable.map.backmap[i]
            end
        else
            -- Type1, use glyph.unicode
            for i = 1,#fonttable.glyphs do
                local g=fonttable.glyphs[i]
                lookup_codepoint_by_name[g.name] = g.unicode
                lookup_codepoint_by_number[i]    = g.unicode
            end
        end -- is unicode
        fonttable.lookup_codepoint_by_name   = lookup_codepoint_by_name
        fonttable.lookup_codepoint_by_number = lookup_codepoint_by_number
    end

    --- A this point we have taken the `fonttable` from memory or from `fontloader#to_table()`. The next
    --- part is mostly size/features dependent.

    if (size < 0) then size = (- 655.36) * size end
    -- Some fonts have `units_per_em` set to 0. I am not sure if setting this to
    -- 1000 in that case has any drawbacks.
    if fonttable.units_per_em == 0 then fonttable.units_per_em = 1000 end
    local mag = size / fonttable.units_per_em

    --- The table `f` is the font structure that TeX can use, see chapter 7 of the LuaTeX manual for a detailed description. This is returned from
    --- the function. It is safe to store additional data here.
    local f = { }

    -- The index of the characters table must match the glyphs in the
    -- "document". It is wise to have everything in unicode, so we do keep that
    -- in mind when filling the characters subtable.
    f.characters    = { }
    f.fontloader    = fonttable
    if extra_parameter and extra_parameter.otfeatures and extra_parameter.otfeatures.smcp then
        f.smcp = find_feature_string(fonttable,"smcp")
    end
    if extra_parameter and extra_parameter.otfeatures and extra_parameter.otfeatures.onum then
        f.onum = find_feature_string(fonttable,"onum")
    end

    f.otfeatures    = extra_parameter.otfeatures             -- OpenType Features (smcp,...)
    f.name          = fonttable.fontname
    f.fullname      = fonttable.fontname
    f.designsize    = size
    f.size          = size
    f.direction     = 0
    f.filename      = fonttable.filename_with_path
    f.type          = 'real'
    f.encodingbytes = 2
    f.tounicode     = 1
    f.stretch       = 40
    f.shrink        = 30
    f.step          = 10
    f.auto_expand   = true

    f.parameters    = {
        slant         = 0,
        space         = ( extra_parameter.space or 25 ) / 100  * size,
        space_stretch = 0.3  * size,
        space_shrink  = 0.1  * size,
        x_height      = 0.4  * size,
        quad          = 1.0  * size,
        extra_space   = 0
    }

    f.format = guess_fonttype(name)
    if f.format==nil then return false,"Could not determine the type of the font '".. fonttable.filename_with_path .."'." end

    f.embedding = "subset"
    f.cidinfo = fonttable.cidinfo


    for i=1,#fonttable.glyphs do
        local glyph     = fonttable.glyphs[i]
        local codepoint = fonttable.lookup_codepoint_by_number[i]

        -- TeX uses U+002D HYPHEN-MINUS for hyphen, correct would be U+2012 HYPHEN.
        -- Because font vendors all have different ideas of hyphen, we just map all
        -- occurrences of *HYPHEN* to 0x2D (decimal 45)
        if glyph.name:lower():match("^hyphen$") then codepoint=45  end

        f.characters[codepoint] = {
            index = i,
            width = glyph.width * mag,
            name  = glyph.name,
            expansion_factor = 1000,
        }

        -- Height and depth of the glyph
        if glyph.boundingbox[4] then f.characters[codepoint].height = glyph.boundingbox[4] * mag  end
        if glyph.boundingbox[2] then f.characters[codepoint].depth = -glyph.boundingbox[2] * mag  end

        --- We change the `tounicode` entry for entries with a period. Sometimes fonts
        --- have entries like `a.sc` or `a.c2sc` for smallcaps letter a. We are
        --- only interested in the part before the period.
        --- _This solution might not be perfect_.
        if glyph.name:match("%.") then
            local destname = glyph.name:gsub("^([^%.]*)%..*$","%1")
            local cp = fonttable.lookup_codepoint_by_name[destname]
            if cp then
                f.characters[codepoint].tounicode=to_utf16(cp)
            end
        end


        --- Margin protrusion is enabled in `spinit.lua`.
        if (glyph.name=="hyphen" or glyph.name=="period" or glyph.name=="comma") and extra_parameter and type(extra_parameter.marginprotrusion) == "number" then
            f.characters[codepoint]["right_protruding"] = glyph.width * extra_parameter.marginprotrusion / 100
        end

        --- We do kerning by default. In the future we could turn it off.
        local kerns={}
        if glyph.kerns then
            for _,kern in pairs(glyph.kerns) do
                local dest = fonttable.lookup_codepoint_by_name[kern.char]
                if dest and dest > 0 then
                    kerns[dest] = kern.off * mag
                else
                end
            end
        end
        f.characters[codepoint].kerns = kerns
    end

    return true,f
end

-- End of file

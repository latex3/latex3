local unicode_data = require'luaotfload-unicode'

local mapping_tables = unicode_data.casemapping
local soft_dotted = unicode_data.soft_dotted
local ccc = unicode_data.ccc

local uppercase = mapping_tables.uppercase
local lowercase = mapping_tables.lowercase
local cased = mapping_tables.cased
local case_ignorable = mapping_tables.case_ignorable

local otfregister  = fonts.constructors.features.otf.register

local direct = node.direct
local is_char = direct.is_char
local has_glyph = direct.has_glyph
local uses_font = direct.uses_font
local getnext = direct.getnext
local setchar = direct.setchar
local setdisc = direct.setdisc
local getdisc = direct.getdisc
local getfield = direct.getfield
local remove = direct.remove
local copy = direct.copy
local insert_after = direct.insert_after
local traverse = direct.traverse

local disc = node.id'disc'

--[[ We make some implicit assumptions about contexts in SpecialCasing.txt here which happened to be true when I wrote the code:
--
-- * Before_Dot only appears as Not_Before_Dot
-- * No other context appears with Not_
-- * Final_Sigma is never language dependent
-- * Other contexts are always language dependent
-- * The only languages with special mappings are Lithuanian (lt/"LTH "/lit), Turkish (tr/"TRK "/tur), and Azeri/Azerbaijani (az/"AZE "/aze)
]]

local font_lang = setmetatable({}, {__index = function(t, fid)
  local f = font.getfont(fid)
  local lang = f.specification.features.normal.language
  lang = lang == 'lth' and 'lt' or lang == 'trk' and 'tr' or lang == 'aze' and 'az' or false
  t[fid] = lang
  return lang
end})

local function is_Final_Sigma(font, mapping, n, after)
  mapping = mapping.Final_Sigma
  if not mapping then return false end
  mapping = mapping._
  if not mapping then return false end
  n = getnext(n)
  repeat
    while n do
      local char, id = is_char(n, font)
      if id == disc then
        after = getnext(n)
        n = getfield(n, 'replace')
        char, id = is_char(n, font)
      elseif char then
        if not case_ignorable[char] then
          return not cased[char] and mapping
        end
        n = getnext(n)
      else
        return mapping
      end
    end
    n, after = after
  until not n
  return mapping
end

local function is_More_Above(font, mapping, n, after)
  mapping = mapping.More_Above
  if not mapping then return false end
  mapping = mapping._
  if not mapping then return false end
  n = getnext(n)
  repeat
    while n do
      local char, id = is_char(n, font)
      if id == disc then
        after = getnext(n)
        n = getfield(n, 'replace')
        char, id = is_char(n, font)
      elseif char then
        local char_ccc = ccc[char]
        if not char_ccc then
          return false
        elseif char_ccc == 230 then
          return mapping
        end
        n = getnext(n)
      else
        return false
      end
    end
    n, after = after
  until not n
  return false
end

local function is_Not_Before_Dot(font, mapping, n, after)
  mapping = mapping.Not_Before_Dot
  if not mapping then return false end
  mapping = mapping._
  if not mapping then return false end
  n = getnext(n)
  repeat
    while n do
      local char, id = is_char(n, font)
      if id == disc then
        after = getnext(n)
        n = getfield(n, 'replace')
        char, id = is_char(n, font)
      elseif char then
        local char_ccc = ccc[char]
        if not char_ccc then
          return mapping
        elseif char_ccc == 230 then
          return char ~= 0x0307 and mapping
        end
        n = getnext(n)
      else
        return mapping
      end
    end
    n, after = after
  until not n
  return mapping
end

local function is_Language_Mapping(font, mapping, n, after, seen_soft_dotted, seen_I)
  if not mapping then return false end
  if seen_soft_dotted then
    local mapping = mapping.After_Soft_Dotted
    mapping = mapping and mapping._
    if mapping then
      return mapping
    end
  end
  if seen_I then
    local mapping = mapping.After_I
    mapping = mapping and mapping._
    if mapping then
      return mapping
    end
  end
  return is_More_Above(font, mapping, n, after) or is_Not_Before_Dot(font, mapping, n, after) or mapping._ -- Might be nil
end

local function process(table)
  local function processor(head, font, after, seen_cased, seen_soft_dotted, seen_I)
    local lang = font_lang[font]
    local n = head
    while n do
      do
        local new = has_glyph(n)
        if n ~= new then
          seen_cased, seen_soft_dotted, seen_I = nil
        end
        n = new
      end
      if not n then break end
      local char, id = is_char(n, font)
      if char then
        local mapping = table[char]
        if mapping then
          if tonumber(mapping) then
            setchar(n, mapping)
          else
            mapping = seen_cased and is_Final_Sigma(font, mapping, n, after)
                   or lang and is_Language_Mapping(font, mapping[lang], n, after, seen_soft_dotted, seen_I)
                   or mapping._
            if #mapping == 0 then
              head, n = remove(head, n)
              goto continue
            else
              setchar(n, mapping[1])
              for i=2, #mapping do
                head, n = insert_after(head, n, copy(n))
                setchar(n, mapping[i])
              end
            end
          end
        end
        if not case_ignorable[char] then
          seen_cased = cased[char] or nil
        end
        local char_ccc = ccc[char]
        if not char_ccc or char_ccc == 230 then
          seen_I = char == 0x49 or nil
          seen_soft_dotted = soft_dotted[char]
        end
      elseif id == disc and uses_font(n, font) then
        local pre, post, rep = getdisc(n)
        local after = getnext(n)
        pre, post, rep, seen_cased, seen_soft_dotted, seen_I =
            processor(pre, font, nil, seen_cased, seen_soft_dotted, seen_I),
            processor(post, font, after),
            processor(rep, font, after, seen_cased, seen_soft_dotted, seen_I)
        setdisc(n, pre, post, rep)
      else
        seen_cased, seen_soft_dotted, seen_I = nil
      end
      n = getnext(n)
      ::continue::
    end
    return head, seen_cased, seen_soft_dotted, seen_I
  end
  return function(head, font) return (processor(head, font)) end
end

local upper_process = process(uppercase)
otfregister {
  name = 'upper',
  description = 'Map to uppercase',
  default = false,
  processors = {
    position = 1,
    plug = upper_process,
    node = upper_process,
    base = upper_process,
  },
}

local lower_process = process(lowercase)
otfregister {
  name = 'lower',
  description = 'Map to lowercase',
  default = false,
  processors = {
    position = 1,
    plug = lower_process,
    node = lower_process,
    base = lower_process,
  },
}

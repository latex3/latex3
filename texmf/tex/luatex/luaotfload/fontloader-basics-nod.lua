if not modules then modules = { } end modules ['luatex-fonts-nod'] = {
    version   = 1.001,
    comment   = "companion to luatex-fonts.lua",
    author    = "Hans Hagen, PRAGMA-ADE, Hasselt NL",
    copyright = "PRAGMA ADE / ConTeXt Development Team",
    license   = "see context related readme files"
}

if context then
    os.exit()
end

-- Don't depend on code here as it is only needed to complement the font handler
-- code. I will move some to another namespace as I don't see other macro packages
-- use the context logic. It's a subset anyway. More will be stripped.

-- Attributes:

if tex.attribute[0] ~= 0 then

    texio.write_nl("log","!")
    texio.write_nl("log","! Attribute 0 is reserved for ConTeXt's font feature management and has to be")
    texio.write_nl("log","! set to zero. Also, some attributes in the range 1-255 are used for special")
    texio.write_nl("log","! purposes so setting them at the TeX end might break the font handler.")
    texio.write_nl("log","!")

    tex.attribute[0] = 0 -- else no features

end

attributes            = attributes or { }
attributes.unsetvalue = -0x7FFFFFFF

local numbers, last = { }, 127

attributes.private = attributes.private or function(name)
    local number = numbers[name]
    if not number then
        if last < 255 then
            last = last + 1
        end
        number = last
        numbers[name] = number
    end
    return number
end

-- Nodes (a subset of context so that we don't get too much unused code):

nodes              = { }
nodes.handlers     = { }

local nodecodes    = { }
local glyphcodes   = node.subtypes("glyph")
local disccodes    = node.subtypes("disc")

for k, v in next, node.types() do
    v = string.gsub(v,"_","")
    nodecodes[k] = v
    nodecodes[v] = k
end
for k, v in next, glyphcodes do
    glyphcodes[v] = k
end
for k, v in next, disccodes do
    disccodes[v] = k
end

nodes.nodecodes    = nodecodes
nodes.glyphcodes   = glyphcodes
nodes.disccodes    = disccodes

nodes.handlers.protectglyphs   = node.protect_glyphs   -- beware: nodes!
nodes.handlers.unprotectglyphs = node.unprotect_glyphs -- beware: nodes!

-- in generic code, at least for some time, we stay nodes, while in context
-- we can go nuts (e.g. experimental); this split permits us us keep code
-- used elsewhere stable but at the same time play around in context

-- much of this will go away .. it's part of the context interface and not
-- officially in luatex-*.lua

local direct             = node.direct
local nuts               = { }
nodes.nuts               = nuts

local tonode             = direct.tonode
local tonut              = direct.todirect

nodes.tonode             = tonode
nodes.tonut              = tonut

nuts.tonode              = tonode
nuts.tonut               = tonut

nuts.getattr             = direct.get_attribute
nuts.getboth             = direct.getboth
nuts.getchar             = direct.getchar
nuts.getdirection        = direct.getdirection
nuts.getdisc             = direct.getdisc
nuts.getreplace          = direct.getreplace
nuts.getfield            = direct.getfield
nuts.getfont             = direct.getfont
nuts.getid               = direct.getid
nuts.getkern             = direct.getkern
nuts.getlist             = direct.getlist
nuts.getnext             = direct.getnext
nuts.getoffsets          = direct.getoffsets
nuts.getprev             = direct.getprev
nuts.getsubtype          = direct.getsubtype
nuts.getwidth            = direct.getwidth
nuts.setattr             = direct.setfield
nuts.setboth             = direct.setboth
nuts.setchar             = direct.setchar
nuts.setcomponents       = direct.setcomponents
nuts.setdirection        = direct.setdirection
nuts.setdisc             = direct.setdisc
nuts.setreplace          = direct.setreplace
nuts.setfield            = setfield
nuts.setkern             = direct.setkern
nuts.setlink             = direct.setlink
nuts.setlist             = direct.setlist
nuts.setnext             = direct.setnext
nuts.setoffsets          = direct.setoffsets
nuts.setprev             = direct.setprev
nuts.setsplit            = direct.setsplit
nuts.setsubtype          = direct.setsubtype
nuts.setwidth            = direct.setwidth

nuts.getglyphdata        = nuts.getattr
nuts.setglyphdata        = nuts.setattr

nuts.ischar              = direct.is_char
nuts.isglyph             = direct.is_glyph

nuts.copy                = direct.copy
nuts.copy_list           = direct.copy_list
nuts.copy_node           = direct.copy
nuts.end_of_math         = direct.end_of_math
nuts.flush               = direct.flush
nuts.flush_list          = direct.flush_list
nuts.flush_node          = direct.flush_node
nuts.free                = direct.free
nuts.insert_after        = direct.insert_after
nuts.insert_before       = direct.insert_before
nuts.is_node             = direct.is_node
nuts.kerning             = direct.kerning
nuts.ligaturing          = direct.ligaturing
nuts.new                 = direct.new
nuts.remove              = direct.remove
nuts.tail                = direct.tail
nuts.traverse            = direct.traverse
nuts.traverse_char       = direct.traverse_char
nuts.traverse_glyph      = direct.traverse_glyph
nuts.traverse_id         = direct.traverse_id

-- properties as used in the (new) injector:

local propertydata = direct.get_properties_table()
nodes.properties   = { data = propertydata }

if direct.set_properties_mode then
    direct.set_properties_mode(true,true)
    function direct.set_properties_mode() end
end

nuts.getprop = function(n,k)
    local p = propertydata[n]
    if p then
        return p[k]
    end
end

nuts.setprop = function(n,k,v)
    if v then
        local p = propertydata[n]
        if p then
            p[k] = v
        else
            propertydata[n] = { [k] = v }
        end
    end
end

nodes.setprop = nodes.setproperty
nodes.getprop = nodes.getproperty

-- a few helpers (we need to keep 'm in sync with context) .. some day components
-- might go so here we isolate them

local setprev       = nuts.setprev
local setnext       = nuts.setnext
local getnext       = nuts.getnext
local setlink       = nuts.setlink
local getfield      = nuts.getfield
local setfield      = nuts.setfield
local getsubtype    = nuts.getsubtype
local isglyph       = nuts.isglyph
local find_tail     = nuts.tail
local flush_list    = nuts.flush_list
local flush_node    = nuts.flush_node
local traverse_id   = nuts.traverse_id
local copy_node     = nuts.copy_node

local glyph_code    = nodes.nodecodes.glyph
local ligature_code = nodes.glyphcodes.ligature

do

    local get_components = node.direct.getcomponents
    local set_components = node.direct.setcomponents

    local function copy_no_components(g,copyinjection)
        local components = get_components(g)
        if components then
            set_components(g)
            local n = copy_node(g)
            if copyinjection then
                copyinjection(n,g)
            end
            set_components(g,components)
            -- maybe also upgrade the subtype but we don't use it anyway
            return n
        else
            local n = copy_node(g)
            if copyinjection then
                copyinjection(n,g)
            end
            return n
        end
    end

    local function copy_only_glyphs(current)
        local head     = nil
        local previous = nil
        for n in traverse_id(glyph_code,current) do
            n = copy_node(n)
            if head then
                setlink(previous,n)
            else
                head = n
            end
            previous = n
        end
        return head
    end

    local function count_components(start,marks)
        local char = isglyph(start)
        if char then
            if getsubtype(start) == ligature_code then
                local n = 0
                local components = get_components(start)
                while components do
                    n = n + count_components(components,marks)
                    components = getnext(components)
                end
                return n
            elseif not marks[char] then
                return 1
            end
        end
        return 0
    end

    nuts.set_components     = set_components
    nuts.get_components     = get_components
    nuts.copy_only_glyphs   = copy_only_glyphs
    nuts.copy_no_components = copy_no_components
    nuts.count_components   = count_components

end

nuts.uses_font = direct.uses_font

do

    -- another poor mans substitute ... i will move these to a more protected
    -- namespace .. experimental hack

    local dummy = tonut(node.new("glyph"))

    nuts.traversers = {
        glyph    = nuts.traverse_id(nodecodes.glyph,dummy),
        glue     = nuts.traverse_id(nodecodes.glue,dummy),
        disc     = nuts.traverse_id(nodecodes.disc,dummy),
        boundary = nuts.traverse_id(nodecodes.boundary,dummy),

        char     = nuts.traverse_char(dummy),

        node     = nuts.traverse(dummy),
    }

end

if not nuts.setreplace then

    local getdisc  = nuts.getdisc
    local setfield = nuts.setfield

    function nuts.getreplace(n)
        local _, _, h, _, _, t = getdisc(n,true)
        return h, t
    end

    function nuts.setreplace(n,h)
        setfield(n,"replace",h)
    end

end

do

    local getsubtype = nuts.getsubtype

    function nuts.start_of_par(n)
        local s = getsubtype(n)
        return s == 0 or s == 2 -- sorry, hardcoded, won't change anyway
    end

end

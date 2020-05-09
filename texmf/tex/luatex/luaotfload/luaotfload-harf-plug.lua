-----------------------------------------------------------------------
--         FILE:  luaotfload-harf-plug.lua
--  DESCRIPTION:  part of luaotfload / HarfBuzz / fontloader plugin
-----------------------------------------------------------------------
do -- block to avoid to many local variables error
 local ProvidesLuaModule = { 
     name          = "luaotfload-harf-plug",
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

local hb = luaotfload.harfbuzz

local assert            = assert
local next              = next
local tonumber          = tonumber
local type              = type
local format            = string.format
local open              = io.open
local tableinsert       = table.insert
local tableremove       = table.remove
local ostmpname         = os.tmpname
local osremove          = os.remove

local direct            = node.direct
local tonode            = direct.tonode
local todirect          = direct.todirect
local traverse          = direct.traverse
local insertbefore      = direct.insert_before
local insertafter       = direct.insert_after
local protectglyph      = direct.protect_glyph
local newnode           = direct.new
local freenode          = direct.free
local copynode          = direct.copy
local removenode        = direct.remove
local copynodelist      = direct.copy_list
local ischar            = direct.is_char
local uses_font         = direct.uses_font

local getattrs          = direct.getattributelist
local setattrs          = direct.setattributelist
local getchar           = direct.getchar
local setchar           = direct.setchar
local getdir            = direct.getdir
local setdir            = direct.setdir
local getdisc           = direct.getdisc
local setdisc           = direct.setdisc
local getfont           = direct.getfont
local getdata           = direct.getdata
local setdata           = direct.setdata
local getfont           = direct.getfont
local setfont           = direct.setfont
local getfield          = direct.getfield
local setfield          = direct.setfield
local getid             = direct.getid
local getkern           = direct.getkern
local setkern           = direct.setkern
local getnext           = direct.getnext
local setnext           = direct.setnext
local getoffsets        = direct.getoffsets
local setoffsets        = direct.setoffsets
local getproperty       = direct.getproperty
local setproperty       = direct.setproperty
local getprev           = direct.getprev
local setprev           = direct.setprev
local getsubtype        = direct.getsubtype
local setsubtype        = direct.setsubtype
local getwidth          = direct.getwidth
local setwidth          = direct.setwidth
local is_char           = direct.is_char
local tail              = direct.tail

local properties        = direct.get_properties_table()

local imgnode           = img.node

local disc_t            = node.id("disc")
local glue_t            = node.id("glue")
local glyph_t           = node.id("glyph")
local dir_t             = node.id("dir")
local kern_t            = node.id("kern")
local localpar_t        = node.id("local_par")
local whatsit_t         = node.id("whatsit")
local pdfliteral_t      = node.subtype("pdf_literal")

local explicitdisc_t    = 1
local fontkern_t        = 0
local italiccorr_t      = 3
local regulardisc_t     = 3
local spaceskip_t       = 13

local dir_ltr           = hb.Direction.new("ltr")
local dir_rtl           = hb.Direction.new("rtl")
local fl_unsafe         = hb.Buffer.GLYPH_FLAG_UNSAFE_TO_BREAK

local startactual_p     = "luaotfload_startactualtext"
local endactual_p       = "luaotfload_endactualtext"

local empty_table       = {}

-- "Copy" properties as done by LuaTeX: Make old properties metatable 
local function copytable(old)
  local new = {}
  for k, v in next, old do
    if type(v) == "table" then v = copytable(v) end
    new[k] = v
  end
  setmetatable(new, getmetatable(old))
  return new
end

-- Set and get properties.
local function setprop(n, prop, value)
  local props = properties[n]
  if not props then
    props = {}
    properties[n] = props
  end
  props[prop] = value
end

local function inherit(t, base, properties)
  local n = newnode(t)
  setattrs(n, getattrs(base))
  if properties then
    setproperty(n, setmetatable({}, {__index = properties}))
  end
  return n
end
-- New kern node of amount `v`, inheriting the properties/attributes of `n`.
local function newkern(v, n)
  local kern = inherit(kern_t, n, getproperty(n))
  setkern(kern, v)
  return kern
end

local function insertkern(head, current, kern, rtl)
  if rtl then
    head = insertbefore(head, current, kern)
  else
    head, current = insertafter(head, current, kern)
  end
  return head, current
end

-- Convert list of integers to UTF-16 hex string used in PDF.
local function to_utf16_hex(uni)
  if uni < 0x10000 then
    return format("%04X", uni)
  else
    uni = uni - 0x10000
    local hi = 0xD800 + (uni // 0x400)
    local lo = 0xDC00 + (uni % 0x400)
    return format("%04X%04X", hi, lo)
  end
end

local process

local function itemize(head, fontid, direction)
  local fontdata = font.getfont(fontid)
  local hbdata   = fontdata and fontdata.hb
  local spec     = fontdata and fontdata.specification
  local options  = spec and spec.features.raw

  local runs, codes = {}, {}
  local dirstack = {}
  local currdir = direction or "TLT"
  local lastskip, lastdir = true
  local lastrun = {}

  for n, id, subtype in direct.traverse(head) do
    local code = 0xFFFC -- OBJECT REPLACEMENT CHARACTER
    local skip = lastskip
    local props = properties[n]

    if props and props.zwnj then
      code = 0x200C
      -- skip = false -- Not sure about this, but lastskip should be a bit faster
    elseif id == glyph_t then
      if is_char(n) and getfont(n) == fontid then
        code = getchar(n)
        skip = false
      else
        skip = true
      end
    elseif id == glue_t and subtype == spaceskip_t then
      code = 0x0020 -- SPACE
    elseif id == disc_t then
      if uses_font(n, fontid) then
        code = 0x00AD -- SOFT HYPHEN
        skip = false
      else
        skip = true
      end
    elseif id == dir_t then
      local dir = getdir(n)
      if dir:sub(1, 1) == "+" then
        -- Push the current direction to the stack.
        tableinsert(dirstack, currdir)
        currdir = dir:sub(2)
      else
        assert(currdir == dir:sub(2))
        -- Pop the last direction from the stack.
        currdir = tableremove(dirstack)
      end
    elseif id == localpar_t then
      currdir = getdir(n)
    end

    codes[#codes + 1] = code

    if lastdir ~= currdir or lastskip ~= skip then
      lastrun.after = n
      lastrun = {
        start = #codes,
        len = 1,
        font = fontid,
        dir = currdir == "TRT" and dir_rtl or dir_ltr,
        skip = skip,
        codes = codes,
      }
      runs[#runs + 1] = lastrun
      lastdir, lastskip = currdir, skip
    else
      lastrun.len = lastrun.len + 1
    end
  end

  return runs
end


-- Check if it is not safe to break before this glyph.
local function unsafetobreak(glyph)
  return glyph
     and glyph.flags
     and glyph.flags & fl_unsafe
end

local shape

-- Make s a sub run, used by discretionary nodes.
local function makesub(run, codes, nodelist)
  local subrun = {
    start = 1,
    len = #codes,
    font = run.font,
    dir = run.dir,
    fordisc = true,
    node = nodelist,
    codes = codes,
  }
  local glyphs
  if nodelist == 0 then -- FIXME: This shouldn't happen
    nodelist = nil
  end
  nodelist, nodelist, glyphs = shape(nodelist, nodelist, subrun)
  return { glyphs = glyphs, run = subrun, head = nodelist }
end

local function printnodes(label, head, after)
  after = tonode(after)
  for n in node.traverse(tonode(head)) do
    if n == after then return end
    print(label, n, n.font or '', n.char or '')
    local pre, post, rep = getdisc(todirect(n))
    if pre then
      printnodes(label .. '<', pre)
    end
    if post then
      printnodes(label .. '>', post)
    end
    if rep then
      printnodes(label .. '=', rep)
    end
  end
end
-- Main shaping function that calls HarfBuzz, and does some post-processing of
-- the output.
function shape(head, firstnode, run)
  local node = firstnode
  local codes = run.codes
  local offset = run.start
  local nodeindex = offset
  run.start = offset
  local len = run.len
  local fontid = run.font
  local dir = run.dir
  local fordisc = run.fordisc
  local cluster = offset - 2

  local fontdata = font.getfont(fontid)
  local hbdata = fontdata.hb
  local spec = fontdata.specification
  local features = spec.hb_features
  local options = spec.features.raw
  local hbshared = hbdata.shared
  local hbfont = hbshared.font

  local lang = spec.language
  local script = spec.script
  local shapers = options.shaper and { options.shaper } or {}

  local buf = hb.Buffer.new()
  if buf.set_flags then
    buf:set_flags(hbdata.buf_flags)
  end
  buf:set_direction(dir)
  buf:set_script(script)
  buf:set_language(lang)
  buf:set_cluster_level(buf.CLUSTER_LEVEL_MONOTONE_CHARACTERS)
  buf:add_codepoints(codes, offset - 1, len)

  local hscale = hbdata.hscale
  local vscale = hbdata.vscale
  hbfont:set_scale(hscale, vscale)

  do
    features = table.merged(features) -- We don't want to modify the global features
    local current_features = {}
    local n = node
    for i = offset-1, offset+len-2 do
      local props = properties[n] or empty_table
      if props then
        local local_feat = props.glyph_features or empty_table
        if local_feat then
          for tag, value in next, current_features do
            local loc = local_feat[tag]
            loc = loc ~= nil and (tonumber(loc) or (loc and 1 or 0)) or nil
            if value.value ~= loc then -- This includes loc == nil
              value._end = i
              features[#features + 1] = value
              current_features[tag] = nil
            end
          end
          for tag, value in next, local_feat do
            if not current_features[tag] then
              local feat = hb.Feature.new(tag)
              feat.value = tonumber(value) or (value and 1 or 0)
              feat.start = i
              current_features[tag] = feat
            end
          end
        end
      end
      n = getnext(n)
    end
    for _, feat in next, current_features do
      features[#features + 1] = feat
    end
  end

  if hb.shape_full(hbfont, buf, features, shapers) then
    -- The engine wants the glyphs in logical order, but HarfBuzz outputs them
    -- in visual order, so we reverse RTL buffers.
    if dir:is_backward() then buf:reverse() end

    local glyphs = buf:get_glyphs()

    local i = 0
    while i < #glyphs do
      i = i + 1
      local glyph = glyphs[i]

      -- Calculate the Unicode code points of this glyph. If cluster did not
      -- change then this is a glyph inside a complex cluster and will be
      -- handled with the start of its cluster.
      if cluster ~= glyph.cluster then
        cluster = glyph.cluster
        for i = nodeindex, cluster do node = getnext(node) end
        nodeindex = cluster + 1
        local hex = ""
        local str = ""
        local nextcluster
        for j = i+1, #glyphs do
          nextcluster = glyphs[j].cluster
          if cluster ~= nextcluster then
            glyph.nglyphs = j - i
            goto NEXTCLUSTERFOUND -- break
          end
        end -- else -- only executed if the loop reached the end without
                    -- finding another cluster
          nextcluster = offset + len - 1
          glyph.nglyphs = #glyphs + 1 - i
        ::NEXTCLUSTERFOUND:: -- end
        glyph.nextcluster = nextcluster
        do
          local node = node
          for j = cluster,nextcluster-1 do
            local id = getid(node)
            if id == glyph_t or (id == glue_t and getsubtype(node) == spaceskip_t) then
              local code = codes[j + 1]
              hex = hex..to_utf16_hex(code)
              str = str..utf8.char(code)
            end
          end
          glyph.tounicode = hex
          glyph.string = str
        end
        if not fordisc then
          local discindex = nil
          local disc = node
          for j = cluster + 1, nextcluster do
            local props = properties[disc]
            if (not (props and props.zwnj)) and getid(disc) == disc_t then
              discindex = j
              break
            end
            disc = getnext(disc)
          end
          if discindex then
            -- Discretionary found.
            local startindex, stopindex = nil, nil
            local startglyph, stopglyph = nil, nil

            -- Find the previous glyph that is safe to break at.
            local startglyph = i
            while startglyph > 1
              and codes[glyphs[startglyph - 1].cluster + 1] ~= 0x20
              and codes[glyphs[startglyph - 1].cluster + 1] ~= 0xFFFC
              and unsafetobreak(glyphs[startglyph]) do
              startglyph = startglyph - 1
            end
            -- Get the corresponding character index.
            startindex = glyphs[startglyph].cluster + 1

            -- Find the next glyph that is safe to break at.
            stopglyph = i + 1
            local lastcluster = glyphs[i].cluster
            while stopglyph <= #glyphs
              and codes[glyphs[stopglyph].cluster + 1] ~= 0x20
              and codes[glyphs[stopglyph].cluster + 1] ~= 0xFFFC
              and (unsafetobreak(glyphs[stopglyph])
                or lastcluster == glyphs[stopglyph].cluster) do
              lastcluster = glyphs[stopglyph].cluster
              stopglyph = stopglyph + 1
            end

            stopindex = stopglyph <= #glyphs and glyphs[stopglyph].cluster + 1
                                              or offset + len

            local startnode, stopnode = node, node
            for j=nodeindex - 1, startindex, -1 do
              startnode = getprev(startnode)
            end
            for j=nodeindex + 1, stopindex do
              stopnode = getnext(stopnode)
            end

            glyphs[startglyph] = glyph
            glyph.cluster = startindex - 1
            glyph.nextcluster = startindex
            for j = stopglyph, #glyphs do
              local glyph = glyphs[j]
              glyph.cluster = glyph.cluster - (stopindex - startindex) + 1
            end
            len = len - (stopindex - startindex) + 1
            table.move(glyphs, stopglyph, #glyphs + stopglyph - startglyph - 1, startglyph + 1)

            local subcodes, subindex = {}
            do
              local node = startnode
              while node ~= stopnode do
                if node == disc then
                  subindex = #subcodes
                  startindex = startindex + 1
                  node = getnext(node)
                elseif getid(node) == disc_t then
                  local oldnode = node
                  startnode, node = removenode(startnode, node)
                  freenode(oldnode)
                  tableremove(codes, startindex)
                else
                  subcodes[#subcodes + 1] = tableremove(codes, startindex)
                  node = getnext(node)
                end
              end
            end
            
            local pre, post, rep, lastpre, lastpost, lastrep = getdisc(disc, true)
            local precodes, postcodes, repcodes = {}, {}, {}
            table.move(subcodes, 1, subindex, 1, repcodes)
            for n, id, subtype in traverse(rep) do
              repcodes[#repcodes + 1] = getfont(n) == fontid and getchar(n) or 0xFFFC
            end
            table.move(subcodes, subindex + 1, #subcodes, #repcodes + 1, repcodes)
            table.move(subcodes, 1, subindex, 1, precodes)
            for n, id, subtype in traverse(pre) do
              precodes[#precodes + 1] = getfont(n) == fontid and getchar(n) or 0xFFFC
            end
            for n, id, subtype in traverse(post) do
              postcodes[#postcodes + 1] = getfont(n) == fontid and getchar(n) or 0xFFFC
            end
            table.move(subcodes, subindex + 1, #subcodes, #postcodes + 1, postcodes)
            if startnode ~= disc then
              local newpre = copynodelist(startnode, disc)
              setnext(tail(newpre), pre)
              pre = newpre
            end
            if post then
              setnext(lastpost, copynodelist(getnext(disc), stopnode))
            else
              post = copynodelist(getnext(disc), stopnode)
            end
            if startnode ~= disc then
              local predisc = getprev(disc)
              setnext(predisc, rep)
              setprev(rep, predisc)
              if firstnode == startnode then
                firstnode = disc
              end
              if startnode == head then
                head = disc
              else
                local before = getprev(startnode)
                setnext(before, disc)
                setprev(disc, before)
              end
              setprev(startnode, nil)
              rep = startnode
              lastrep = lastrep or predisc
            end
            if getnext(disc) ~= stopnode then
              setnext(getprev(stopnode), nil)
              setprev(stopnode, disc)
              setprev(getnext(disc), lastrep)
              setnext(lastrep, getnext(disc))
              rep = rep or getnext(disc)
              setnext(disc, stopnode)
            end
            glyph.replace = makesub(run, repcodes, rep)
            glyph.pre = makesub(run, precodes, pre)
            glyph.post = makesub(run, postcodes, post)
            i = startglyph
            node = disc
            cluster = glyph.cluster
            nodeindex = cluster + 1
          end
        end
      end
    end
    return head, firstnode, glyphs, run.len - len
  end

  return head, firstnode, {}, 0
end

local function color_to_rgba(color)
  local r = color.red   / 255
  local g = color.green / 255
  local b = color.blue  / 255
  local a = color.alpha / 255
  if a ~= 1 then
    -- XXX: alpha
    return format('%s %s %s rg', r, g, b)
  else
    return format('%s %s %s rg', r, g, b)
  end
end

-- Cache of color glyph PNG data for bookkeeping, only because I couldn’t
-- figure how to make the engine load the image from the binary data directly.
local pngcache = {}
local pngcachefiles = {}
local function cachedpng(data)
  local hash = md5.sumhexa(data)
  local i = pngcache[hash]
  if not i then
    local path = ostmpname()
    pngcachefiles[#pngcachefiles + 1] = path
    open(path, "wb"):write(data):close()
    -- local file = open(path, "wb"):write():close()
    -- file:write(data)
    -- file:close()
    i = img.scan{filename = path}
    pngcache[hash] = i
  end
  return i
end

local function get_png_glyph(gid, fontid, characters, haspng)
  return gid
end

local push_cmd = { "push" }
local pop_cmd = { "pop" }
local nop_cmd = { "nop" }
--[[
  In the following, "text" actually refers to "font" mode and not to "text"
  mode. "font" mode is called "text" inside of virtual font commands (don't
  ask me why, but the LuaTeX source does make it clear that this is intentional)
  and behaves mostly like "page" (especially it does not enter a "BT" "ET"
  block) except that it always resets the current position to the origin.
  This is necessary to ensure that the q/Q pair does not interfere with TeX's
  position tracking.
  ]]
local save_cmd = { "pdf", "text", "q" }
local restore_cmd = { "pdf", "text", "Q" }

-- Convert glyphs to nodes and collect font characters.
local function tonodes(head, node, run, glyphs)
  local nodeindex = run.start
  local dir = run.dir
  local fontid = run.font
  local fontdata = font.getfont(fontid)
  local space = fontdata.parameters.space
  local characters = fontdata.characters
  local hbdata = fontdata.hb
  local hfactor = (fontdata.extend or 1000) / 1000
  local palette = hbdata.palette
  local hbshared = hbdata.shared
  local hbface = hbshared.face
  local nominals = hbshared.nominals
  local hbfont = hbshared.font
  local fontglyphs = hbshared.glyphs
  local gid_offset = hbshared.gid_offset
  local rtl = dir:is_backward()
  local lastprops

  local scale = hbdata.scale

  local haspng = hbshared.haspng
  local fonttype = hbshared.fonttype

  local nextcluster

  for i, glyph in ipairs(glyphs) do
    if glyph.cluster + 1 >= nodeindex then -- Reached a new cluster
      nextcluster = glyph.nextcluster
      assert(nextcluster)
      for j = nodeindex, glyph.cluster do
        local oldnode = node
        head, node = removenode(head, node)
        freenode(oldnode)
      end
      lastprops = getproperty(node)
      nodeindex = glyph.cluster + 1
    elseif nextcluster + 1 == nodeindex then -- Oops, we went too far
      nodeindex = nodeindex - 1
      local new = inherit(glyph_t, getprev(node), lastprops)
      setfont(new, fontid)
      head, node = insertbefore(head, node, new)
    end
    local gid = glyph.codepoint
    local char = nominals[gid] or gid_offset + gid
    local id = getid(node)

    if glyph.replace then
      -- For discretionary the glyph itself is skipped and a discretionary node
      -- is output in place of it.
      local rep, pre, post = glyph.replace, glyph.pre, glyph.post

      setdisc(node, tonodes(pre.head, pre.head, pre.run, pre.glyphs),
                    tonodes(post.head, post.head, post.run, post.glyphs),
                    tonodes(rep.head, rep.head, rep.run, rep.glyphs))
      node = getnext(node)
      nodeindex = nodeindex + 1
    elseif glyph.skip then
      local oldnode = node
      head, node = removenode(head, node)
      freenode(oldnode)
      nodeindex = nodeindex + 1
    else
      if lastprops and lastprops.zwnj and nodeindex == glyph.cluster + 1 then
      elseif id == glyph_t then
        local done
        local fontglyph = fontglyphs[gid]
        local character = characters[char]

        if not character.commands then
          if palette then
            local layers = fontglyph.layers
            if layers == nil then
              layers = hbface:ot_color_glyph_get_layers(gid) or false
              fontglyph.layers = layers
            end
            if layers then
              local cmds = {} -- Every layer will add 5 cmds
              local prev_color = nil
              for j = 1, #layers do
                local layer = layers[j]
                local layerchar = characters[gid_offset + layer.glyph]
                if layerchar.height > character.height then
                  character.height = layerchar.height
                end
                if layerchar.depth > character.depth then
                  character.depth = layerchar.depth
                end
                -- color_index has a special value, 0x10000, that mean use text
                -- color, we don’t check for it here explicitly since we will
                -- get nil anyway.
                local color = palette[layer.color_index]
                cmds[5*j - 4] = (color and not prev_color) and save_cmd or nop_cmd
                cmds[5*j - 3] = prev_color == color and nop_cmd or (color and {"pdf", "page", color_to_rgba(color)} or restore_cmd)
                cmds[5*j - 2] = push_cmd
                cmds[5*j - 1] = {"char", layer.glyph + gid_offset}
                cmds[5*j] = pop_cmd
                fontglyphs[layer.glyph].used = true
                prev_color = color
              end
              cmds[#cmds + 1] = prev_color and restore_cmd
              if not character.colored then
                local coloredcharacter = {}
                for k,v in next, character do
                  coloredcharacter[k] = v
                end
                coloredcharacter.commands = cmds
                local newcharacters = {[gid + 0x130000] = coloredcharacter}
                characters[gid + 0x130000] = coloredcharacter
                if char ~= gid + gid_offset then
                  newcharacters[char] = coloredcharacter
                  characters[char] = coloredcharacter
                  character.colored = char
                else
                  character.colored = gid + 0x130000
                end
                font.addcharacters(fontid, {characters = newcharacters})
              end
              char = character.colored
              character = characters[char]
            end
          end

          if haspng then
            local pngglyph = character.pngglyph
            if pngglyph == nil then
              local pngblob = hbfont:ot_color_glyph_get_png(gid)
              if pngblob then
                local glyphimg = cachedpng(pngblob:get_data())
                local pngchar = { }
                for k,v in next, character do
                  pngchar[k] = v
                end
                local i = img.copy(glyphimg)
                i.width = character.width
                i.depth = 0
                i.height = character.height + character.depth
                pngchar.commands = fonttype and {
                  {"push"}, {"char", gid_offset + gid}, {"pop"},
                  {"down", character.depth}, {"image", i}
                } or { {"down", character.depth}, {"image", i} }
                if not nominals[gid] then
                  char = 0x130000 + gid
                end
                characters[char] = pngchar
                pngglyph = char
                font.addcharacters(fontid, {characters = {[char] = pngchar}})
              end
              character.pngglyph = pngglyph
            end
            if pngglyph then
              char = pngglyph
            elseif not fonttype then
              -- Color bitmap font with no glyph outlines (like Noto
              -- Color Emoji) but has no bitmap for current glyph (most likely
              -- `.notdef` glyph). The engine does not know how to embed such
              -- fonts, so we don’t want them to reach the backend as it will cause
              -- a fatal error. We use `nullfont` instead.  That is a hack, but I
              -- think it is good enough for now. We could make the glyph virtual
              -- with empty commands suh that LuaTeX ignores it, but we still want
              -- a missing glyph warning.
              -- We insert the glyph node and move on, no further work is needed.
              setfont(node, 0)
              done = true
            end
          end
        end
        if not done then
          local oldcharacter = characters[getchar(node)]
          -- If the glyph index of current font character is the same as shaped
          -- glyph, keep the node char unchanged. Helps with primitives that
          -- take characters as input but actually work on glyphs, like
          -- `\rpcode`.
          if not oldcharacter then
            if gid == 0 then
              local new = copynode(node)
              head, node = insertafter(head, node, new)
            end
            setchar(node, char)
          elseif character.commands
              or character.index ~= oldcharacter.index then
            setchar(node, char)
          end
          local xoffset = (rtl and -glyph.x_offset or glyph.x_offset) * scale
          local yoffset = glyph.y_offset * scale
          setoffsets(node, xoffset, yoffset)

          fontglyph.used = fonttype and true

          -- The engine will use this string when printing a glyph node e.g. in
          -- overfull messages, otherwise it will be trying to print our
          -- invalid pseudo Unicode code points.
          -- If the string is empty it means this glyph is part of a larger
          -- cluster and we don’t to print anything for it as the first glyph
          -- in the cluster will have the string of the whole cluster.
          local props = properties[node]
          if not props then
            props = {}
            properties[node] = props
          end
          props.glyph_info = glyph.string or ""

          -- Handle PDF text extraction:
          -- * Find how many characters in this cluster and how many glyphs,
          -- * If there is more than 0 characters
          --   * One glyph: one to one or one to many mapping, can be
          --     represented by font’s /ToUnicode
          --   * More than one: many to one or many to many mapping, can be
          --     represented by /ActualText spans.
          -- * If there are zero characters, then this glyph is part of complex
          --   cluster that will be covered by an /ActualText span.
          local tounicode = glyph.tounicode
          if tounicode then
            if glyph.nglyphs == 1
                and not character.commands
                and not fontglyph.tounicode then
              fontglyph.tounicode = tounicode
            elseif character.commands or tounicode ~= fontglyph.tounicode then
              setprop(node, startactual_p, tounicode)
              glyphs[i + glyph.nglyphs - 1].endactual = true
            end
          end
          if glyph.endactual then
            setprop(node, endactual_p, true)
          end
          local x_advance = glyph.x_advance
          local width = fontglyph.width * hfactor
          if width ~= x_advance then
            -- The engine always uses the glyph width from the font, so we need
            -- to insert a kern node if the x advance is different.
            local kern = newkern((x_advance - width) * scale, node)
            head, node = insertkern(head, node, kern, rtl)
          end
        end
      elseif id == glue_t and getsubtype(node) == spaceskip_t then
        -- If the glyph advance is different from the font space, then a
        -- substitution or positioning was applied to the space glyph changing
        -- it from the default. We try to maintain as much as possible from the
        -- original value because we assume that we want to keep spacefactors and
        -- assume that we got mostly positioning applied. TODO: Handle the case that
        -- we became a glyph in the process.
        -- We are intentionally not comparing with the existing glue width as
        -- spacing after the period is larger by default in TeX.
        local width = glyph.x_advance * scale
        -- if space > width + 2 or width > space + 2 then
        if space ~= width then
          setwidth(node, getwidth(node) - space + width)
          -- setfield(node, "stretch", width / 2)
          -- setfield(node, "shrink", width / 3)
        end
      elseif id == kern_t and getsubtype(node) == italiccorr_t then
        -- If this is an italic correction node and the previous node is a
        -- glyph, update its kern value with the glyph’s italic correction.
        local prevchar, prevfontid = ischar(getprev(node))
        if prevfontid == fontid and prevchar and prevchar > 0 then
          local italic = characters[prevchar].italic
          if italic then
            setkern(node, italic)
          end
        end
      end
      node = getnext(node)
      nodeindex = nodeindex + 1
    end
  end
  while node ~= run.after do
    local oldnode = node
    head, node = removenode(head, node)
    freenode(oldnode)
  end

  return head, node
end

local function shape_run(head, current, run)
  if not run.skip then
    -- Font loaded with our loader and an HarfBuzz face is present, do our
    -- shaping.
    local glyphs, offset
    head, current, glyphs, offset = shape(head, current, run)
    return offset, tonodes(head, current, run, glyphs)
  else
    return 0, head, run.after
  end
end

function process(head, font, _attr, direction)
  local newhead, current = head, head
  local runs = itemize(head, font, direction)

  local offset = 0
  for i = 1,#runs do
    local run = runs[i]
    run.start = run.start - offset
    local new_offset
    new_offset, newhead, current = shape_run(newhead, current, run)
    offset = offset + new_offset
  end

  return newhead or head
end

local function pageliteral(data)
  local n = newnode(whatsit_t, pdfliteral_t)
  setfield(n, "mode", 1) -- page
  setdata(n, data)
  return n
end

local function post_process(head)
  for n in traverse(head) do
    local props = properties[n]

    local startactual, endactual
    if props then
      startactual = rawget(props, startactual_p)
      endactual = rawget(props, endactual_p)
    end

    if startactual then
      local actualtext = "/Span<</ActualText<FEFF"..startactual..">>>BDC"
      head = insertbefore(head, n, pageliteral(actualtext))
    end

    if endactual then
      head = insertafter(head, n, pageliteral("EMC"))
    end

    local replace = getfield(n, "replace")
    if replace then
      setfield(n, "replace", post_process(replace))
    end

    local subhead = getfield(n, "head")
    if subhead then
      setfield(n, "head", post_process(subhead))
    end
  end
  return head
end

local function post_process_nodes(head, groupcode)
  return tonode(post_process(todirect(head)))
end

local function run_cleanup()
  -- Remove temporary PNG files that we created, if any.
  -- FIXME: It would be nice if we wouldn't need this
  for _, path in next, pngcachefiles do
    osremove(path)
  end
end

local function set_tounicode()
  for fontid, fontdata in font.each() do
    local hbdata = fontdata.hb
    if hbdata and fontid == pdf.getfontname(fontid) then
      local characters = fontdata.characters
      local newcharacters = {}
      local hbshared = hbdata.shared
      local glyphs = hbshared.glyphs
      local nominals = hbshared.nominals
      local gid_offset = hbshared.gid_offset
      for gid = 0, #glyphs do
        local glyph = glyphs[gid]
        if glyph.used then
          local character = characters[gid + gid_offset]
          newcharacters[gid + gid_offset] = character
          local unicode = nominals[gid]
          if unicode then
            newcharacters[unicode] = character
          end
          character.tounicode = glyph.tounicode or "FFFD"
          character.used = true
        end
      end
      font.addcharacters(fontid, { characters = newcharacters })
    end
  end
end

-- FIXME: Move this into generic parts of luaotfload
local utfchar = utf8.char
local function get_glyph_info(n)
  n = todirect(n)
  local props = properties[n]
  return props and props.glyph_info or utfchar(getchar(n)):gsub('\0', '^^@')
end

fonts.handlers.otf.registerplugin('harf', process)

-- luatexbase does not know how to handle `wrapup_run` callback, teach it.
-- TODO: Move these into ltluatex
luatexbase.callbacktypes.wrapup_run = 1 -- simple
luatexbase.callbacktypes.glyph_info = 1 -- simple

local base_callback_descriptions = luatexbase.callback_descriptions
local base_add_to_callback = luatexbase.add_to_callback
local base_remove_from_callback = luatexbase.remove_from_callback

-- Remove all existing functions from given callback, insert ours, then
-- reinsert the removed ones, so ours takes a priority.
local function add_to_callback(name, func)
  local saved_callbacks = {}, ff, dd
  for k, v in next, base_callback_descriptions(name) do
    saved_callbacks[k] = { base_remove_from_callback(name, v) }
  end
  base_add_to_callback(name, func, "Harf "..name.." callback")
  for _, v in next, saved_callbacks do
    base_add_to_callback(name, v[1], v[2])
  end
end

add_to_callback('pre_output_filter', post_process_nodes) -- FIXME: Wrong callback, but I want to get rid of the whole function anyway
add_to_callback('wrapup_run', run_cleanup)
add_to_callback('finish_pdffile', set_tounicode)
add_to_callback('glyph_info', get_glyph_info)

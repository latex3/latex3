-----------------------------------------------------------------------
--         FILE:  luaotfload-loaders.lua
--  DESCRIPTION:  Luaotfload callback handling
-- REQUIREMENTS:  luatex v.0.80 or later; package lualibs
--       AUTHOR:  Philipp Gesang <phg@phi-gamma.net>
--       AUTHOR:  Hans Hagen, Khaled Hosny, Elie Roux, David Carlisle
-----------------------------------------------------------------------

assert(luaotfload_module, "This is a part of luaotfload and should not be loaded independently") { 
    name          = "luaotfload-loaders",
    version       = "3.17",       --TAGVERSION
    date          = "2021-01-08", --TAGDATE
    description   = "luaotfload submodule / callback handling",
    license       = "GPL v2.0"
}
-----------------------------------------------------------------------



if not lualibs    then error "this module requires Luaotfload" end
if not luaotfload then error "this module requires Luaotfload" end

local logreport = luaotfload.log and luaotfload.log.report or print

local function lua_reader (specification)
  local fullname = specification.resolved
  if fullname then
    local loader = loadfile (fullname)
    loader = loader and loader ()
    return loader and loader (specification)
  end
end

local function eval_reader (specification)
  local eval = specification.eval
  if not eval or type (eval) ~= "function" then return nil end
  logreport ("both", 0, "loaders",
             "eval: found tfmdata for %q, injecting.",
             specification.name)
  return eval ()
end

local function unsupported_reader (format)
  return function (specification)
    logreport ("both", 4, "loaders",
               "font format %q unsupported; cannot load %s.",
               format, tostring (specification.name))
  end
end

local type1_reader = fonts.readers.afm
local tfm_reader   = fonts.readers.tfm

local function install_formats ()
  local fonts = fonts
  if not fonts then return false end

  local readers   = fonts.readers
  local sequence  = readers.sequence
  local seqset    = table.tohash (sequence)
  local formats   = fonts.formats
  if not readers or not formats then return false end

  local function aux (which, reader)
    if   not which  or type (which) ~= "string"
      or not reader or type (reader) ~= "function" then
      logreport ("both", 2, "loaders", "Error installing reader for %q.", which)
      return false
    end
    formats  [which] = "type1"
    readers  [which] = reader
    if not seqset [which] then
      logreport ("both", 3, "loaders",
                 "Extending reader sequence for %q.", which)
      sequence [#sequence + 1] = which
      seqset   [which]         = true
    end
    return true
  end

  return aux ("evl", eval_reader)
     and aux ("lua", lua_reader)
     and aux ("pfa", unsupported_reader "pfa")
     and aux ("afm", type1_reader)
     and aux ("pfb", type1_reader)
     and aux ("tfm", tfm_reader)
     and aux ("ofm", tfm_reader)
     and aux ("dfont", unsupported_reader "dfont")
end

local function not_found_msg (specification, size, id)
  logreport ("both", 0, "loaders", "")
  logreport ("both", 0, "loaders",
             "--------------------------------------------------------")
  logreport ("both", 0, "loaders", "")
  logreport ("both", 0, "loaders", "Font definition failed for:")
  logreport ("both", 0, "loaders", "")
  logreport ("both", 0, "loaders", "   > id            : %d", id)
  logreport ("both", 0, "loaders", "   > specification : %q", specification)
  if size > 0 then
    logreport ("both", 0, "loaders", "   > size          : %.2f pt", size / 2^16)
  end
  logreport ("both", 0, "loaders", "")
  logreport ("both", 0, "loaders",
             "--------------------------------------------------------")
end
--[[doc--

    \subsection{\CONTEXT override}
    \label{define-font}
    We provide a simplified version of the original font definition
    callback.

--doc]]--


local definers --- (string, spec -> size -> id -> tmfdata) hash_t
do
  local ctx_read = fonts.definers.read
  local register = fonts.definers.register
  local function read(specification, size, id)
    local tfmdata = ctx_read(specification, size, id)
    if not tfmdata or id or tonumber(tfmdata) then
      return tfmdata
    end
    id = font.define(tfmdata)
    register(tfmdata, id)
    return id
  end

  local function patch (specification, size, id)
    local fontdata = ctx_read (specification, size, id)
----if not fontdata then not_found_msg (specification, size, id) end
    if type (fontdata) == "table" and fontdata.encodingbytes == 2 then
      --- We need to test for `encodingbytes` to avoid passing
      --- tfm fonts to `patch_font`. These fonts are fragile
      --- because they use traditional TeX font handling.
      luatexbase.call_callback ("luaotfload.patch_font", fontdata, specification, id)
    else
      luatexbase.call_callback ("luaotfload.patch_font_unsafe", fontdata, specification, id)
    end
    if not fontdata or id or tonumber(fontdata) then
      return fontdata
    end
    id = font.define(fontdata)
    register(fontdata, id)
    return id
  end

  local function mk_info (name)
    local definer = name == "patch" and patch or read
    return function (specification, size, id)
      logreport ("both", 0, "loaders", "defining font no. %d", id)
      logreport ("both", 0, "loaders", "   > active font definer: %q", name)
      logreport ("both", 0, "loaders", "   > spec %q", specification)
      logreport ("both", 0, "loaders", "   > at size %.2f pt", size / 2^16)
      local result = definer (specification, size, id)
      if not result then return not_found_msg (specification, size, id) end
      if type (result) == "number" then
        logreport ("both", 0, "loaders", "   > font definition yielded id %d", result)
        return result
      end
      logreport ("both", 0, "loaders", "   > font definition successful")
      logreport ("both", 0, "loaders", "   > name %q",     result.name     or "<nil>")
      logreport ("both", 0, "loaders", "   > fontname %q", result.fontname or "<nil>")
      logreport ("both", 0, "loaders", "   > fullname %q", result.fullname or "<nil>")
      logreport ("both", 0, "loaders", "   > type %s",     result.type     or "<nil>")
      local spec = result.specification
      if spec then
        logreport ("both", 0, "loaders", "   > file %q",     spec.filename or "<nil>")
        logreport ("both", 0, "loaders", "   > subfont %s",  spec.sub      or "<nil>")
      end
      return result
    end
  end

  definers = {
    patch          = patch,
    generic        = read,
    info_patch     = mk_info "patch",
    info_generic   = mk_info "generic",
  }
end

--[[doc--

  We create callbacks for patching fonts on the fly, to be used by
  other packages. In addition to the regular \identifier{patch_font}
  callback there is an unsafe variant \identifier{patch_font_unsafe}
  that will be invoked even if the target font lacks certain essential
  tfmdata tables.

  The callbacks initially contain the empty function that we are going
  to override below.

--doc]]--

local function purge_define_font ()
  local cdesc = luatexbase.callback_descriptions "define_font"
  --- define_font is an “exclusive” callback, meaning that there can
  --- only ever be one entry. Everything beyond that would indicate
  --- that something is broken.
  local _, d = next (cdesc)
  if d then
    local i, d2 = next (cdesc, 1)
    if d2 then --> issue warning
      logreport ("both", 0, "loaders",
                 "Callback table for define_font contains multiple entries: \z
                  { [%d] = %q } -- seems fishy.", i, d2)
    end
    logreport ("log", 0, "loaders",
               "Entry %q present in define_font callback; overriding.", d)
    luatexbase.remove_from_callback ("define_font", d)
  end
end

local install_callbacks = function ()
  local create_callback  = luatexbase.create_callback
  local dummy_function   = function () end
  create_callback ("luaotfload.patch_font",        "simple", dummy_function)
  create_callback ("luaotfload.patch_font_unsafe", "simple", dummy_function)
  purge_define_font ()
  local definer = config.luaotfload.run.definer or "patch"
  local selected_definer = definers[definer]
  luaotfload.define_font = selected_definer
  luatexbase.add_to_callback ("define_font",
                              selected_definer,
                              "luaotfload.define_font",
                              1)
  return true
end

return function ()
  if not install_formats () then
    logreport ("log", 0, "loaders", "Error initializing OFM/PF{A,B} loaders.")
    return false
  end
  if not install_callbacks () then
    logreport ("log", 0, "loaders", "Error installing font loader callbacks.")
    return false
  end
  return true
end
-- vim:tw=79:sw=2:ts=2:expandtab

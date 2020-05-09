-----------------------------------------------------------------------
--         FILE:  luaotfload-main.lua
--  DESCRIPTION:  OpenType layout system / luaotfload entry point
-- REQUIREMENTS:  luatex v.0.95.0 or later; package lualibs
--       AUTHOR:  Élie Roux, Khaled Hosny, Philipp Gesang, Ulrike Fischer, Marcel Krüger
-----------------------------------------------------------------------

local authors = "\z
    Hans Hagen,\z
    Khaled Hosny,\z
    Elie Roux,\z
    Will Robertson,\z
    Philipp Gesang,\z
    Dohyun Kim,\z
    Reuben Thomas,\z
    David Carlisle,\
    Ulrike Fischer,\z
    Marcel Krüger\z
"
-- version number is used below!
local ProvidesLuaModule = { 
    name          = "luaotfload-main",
    version       = "3.13",       --TAGVERSION
    date          = "2020-05-01", --TAGDATE
    description   = "luaotfload entry point",
    author        = authors,
    copyright     = authors,
    license       = "GPL v2.0"
}

if luatexbase and luatexbase.provides_module then
  luatexbase.provides_module (ProvidesLuaModule)
end  

local osgettimeofday              = os.gettimeofday
config                            = config     or { }
luaotfload                        = luaotfload or { }
local luaotfload                  = luaotfload
luaotfload.log                    = luaotfload.log or { }
local logreport
luaotfload.version                = ProvidesLuaModule.version
luaotfload.loaders                = { }
luaotfload.min_luatex_version     = { 0, 95, 0 }
luaotfload.fontloader_package     = "reference"    --- default: from current Context

if not tex or not tex.luatexversion then
    error "this program must be run in TeX mode" --- or call tex.initialize() =)
end

--- version check
local major    = tex.luatexversion / 100
local minor    = tex.luatexversion % 100
local revision = tex.luatexrevision --[[ : string ]]
local revno    = tonumber (revision)
local minimum  = luaotfload.min_luatex_version
local actual   = { major, minor, revno or 0 }
if actual [1] < minimum [1]
    or actual == minimum and actual [2] < minimum [2]
    or actual == minimum and actual [2] == minimum [2] and actual [3] < minimum [3]
then
    texio.write_nl ("term and log",
                    string.format ("\tFATAL ERROR\n\z
                                    \tLuaotfload requires a Luatex version >= %d.%d.%d.\n\z
                                    \tPlease update your TeX distribution!\n\n",
                                   (unpack or table.unpack) (minimum)))
    error "version check failed"
end

if not utf8 then
    texio.write_nl("term and log", string.format("\z
        \tluaotfload: module utf8 is unavailable\n\z
        \tutf8 is available in Lua 5.3+; engine\'s _VERSION is %q\n\z
        \tThis probably means that the engine is not supported\n\z
        \n",
        _VERSION))
    error "module utf8 is unavailable"
end

if status.safer_option ~= 0 then
 texio.write_nl("term and log","luaotfload can't run with option --safer. Aborting")
 error("safer_option used")
end 




--[[doc--

    This file initializes the system and loads the font loader. To
    minimize potential conflicts between other packages and the code
    imported from \CONTEXT, several precautions are in order. Some of
    the functionality that the font loader expects to be present, like
    raw access to callbacks, are assumed to have been disabled by
    \identifier{luatexbase} when this file is processed. In some cases
    it is possible to trick it by putting dummies into place and
    restoring the behavior from \identifier{luatexbase} after
    initilization. Other cases such as attribute allocation require
    that we hook the functionality from \identifier{luatexbase} into
    locations where they normally wouldn’t be.

    Anyways we can import the code base without modifications, which is
    due mostly to the extra effort by Hans Hagen to make \LUATEX-Fonts
    self-contained and encapsulate it, and especially due to his
    willingness to incorporate our suggestions.

--doc]]--

local luatexbase       = luatexbase
local require          = require
local type             = type


--[[doc--

    \subsection{Module loading}
    We load the files imported from \CONTEXT with function derived this way. It
    automatically prepends a prefix to its argument, so we can refer to the
    files with their actual \CONTEXT name.

--doc]]--

local function make_loader_name (prefix, name)
    local msg = luaotfload.log and luaotfload.log.report
             or function (stream, lvl, cat, ...)
                 if lvl > 1 then --[[not pressing]] return end
                 texio.write_nl ("log",
                                 string.format ("luaotfload | %s : ",
                                                tostring (cat)))
                 texio.write (string.format (...))
             end
    if not name then
        msg ("both", 0, "load",
             "Fatal error: make_loader_name (%q, %q).",
             tostring (prefix), tostring (name))
        return "dummy-name"
    end
    name = tostring (name)
    if prefix == false then
        msg ("log", 9, "load",
             "No prefix requested, passing module name %q unmodified.",
             name)
        return tostring (name) .. ".lua"
    end
    prefix = tostring (prefix)
    msg ("log", 9, "load",
         "Composing module name from constituents %s, %s.",
         prefix, name)
    return prefix .. "-" .. name .. ".lua"
end

local timing_info = {
    t_load = { },
    t_init = { },
}

local function make_loader (prefix, load_helper)
    return function (name)
        local t_0 = osgettimeofday ()
        local modname = make_loader_name (prefix, name)
        --- We don’t want the stack info from inside, so just pcall().
        local ok, data = pcall (load_helper or require, modname)
        local t_end = osgettimeofday ()
        timing_info.t_load [name] = t_end - t_0
        if not ok then
            io.write "\n"
            local msg = luaotfload.log and luaotfload.log.report or print
            msg ("both", 0, "load", "FATAL ERROR")
            msg ("both", 0, "load", "  × Failed to load %q module %q.",
                 tostring (prefix), tostring (name))
            local lines = string.split (data, "\n\t")
            if not lines then
                msg ("both", 0, "load", "  × Error message: %q", data)
            else
                msg ("both", 0, "load", "  × Error message:")
                for i = 1, #lines do
                    msg ("both", 0, "load", "    × %q.", lines [i])
                end
            end
            io.write "\n\n"
            local debug = debug
            if debug then
                io.write (debug.traceback())
                io.write "\n\n"
            end
            os.exit(-1)
        end
        return data
    end
end

--[[doc--
    Certain files are kept around that aren’t loaded because they are part of
    the imported fontloader. In order to keep the initialization structure
    intact we also provide a no-op version of the module loader that can be
    called in the expected places.
--doc]]--

local function dummy_loader (name)
    luaotfload.log.report ("log", 3, "load",
                           "Skipping module %q on purpose.",
                           name)
end

local context_environment = setmetatable({}, {__index = _G})
luaotfload.fontloader = context_environment
local function context_isolated_load(name)
    local fullname = kpse.find_file(name, 'lua')
    if not fullname then
        error(string.format('Fontloader module %q could not be found.', name))
    end
    return assert(loadfile(fullname, nil, context_environment))(name)
end

local function context_loader (name, path)
    luaotfload.log.report ("log", 3, "load",
                           "Loading module %q from Context.",
                           name)
    local t_0 = osgettimeofday ()
    local modname = make_loader_name (false, name)
    local modpath = modname
    if path then
        if lfs.isdir (path) then
            luaotfload.log.report ("log", 3, "load",
                                   "Prepending path %q.",
                                   path)
            modpath = file.join (path, modname)
        else
            luaotfload.log.report ("both", 0, "load",
                                   "Non-existant path %q specified, ignoring.",
                                   path)
        end
    end
    local ret = context_isolated_load (modpath)
    local t_end = osgettimeofday ()
    timing_info.t_load [name] = t_end - t_0

    if ret ~= true then
        --- require () returns “true” upon success unless the loaded file
        --- yields a non-zero exit code. This isn’t per se indicating that
        --- something isn’t right, but against HH’s coding practices. We’ll
        --- silently ignore this ever happening on lower log levels.
        luaotfload.log.report ("log", 4, "load",
                               "Module %q returned %q.", ret)
    end
    return ret
end

local function install_loaders ()
    local loaders      = { }
    local loadmodule   = make_loader "luaotfload"
    loaders.luaotfload = loadmodule
    loaders.fontloader = make_loader ("fontloader", context_isolated_load)
    loaders.context    = context_loader
    loaders.ignore     = dummy_loader
----loaders.plaintex   = make_loader "luatex" --=> for Luatex-Plain

    function loaders.initialize (name)
        local tmp       = loadmodule (name)
        local init = type(tmp) == "table" and tmp.init or tmp
        if init and type (init) == "function" then
            local t_0 = osgettimeofday ()
            if not init () then
                logreport ("log", 0, "load",
                           "Failed to load module %q.", name)
                return
            end
            local t_end = osgettimeofday ()
            local d_t = t_end - t_0
            logreport ("log", 4, "load",
                       "Module %q loaded in %g ms.",
                       name, d_t * 1000)
            timing_info.t_init [name] = d_t
        end
    end

    return loaders
end

local luaotfload_initialized = false --- prevent multiple invocations

luaotfload.main = function ()

    if luaotfload_initialized then
        logreport ("log", 0, "load",
                   "Luaotfload initialization requested but is already \z
                   loaded, ignoring.")
        return
    end
    luaotfload_initialized = true

    luaotfload.loaders = install_loaders ()
    local loaders    = luaotfload.loaders
    local loadmodule = loaders.luaotfload
    local initialize = loaders.initialize

    local starttime = osgettimeofday ()

    -- Feature detect HarfBuzz. This is done early to allow easy HarfBuzz
    -- detection in other modules
    local harfstatus, harfbuzz = pcall(require, 'luaharfbuzz')
    if harfstatus then
        luaotfload.harfbuzz = harfbuzz
    end

    local init      = loadmodule "init" --- fontloader initialization
    init (function ()

        logreport = luaotfload.log.report
        initialize "parsers"         --- fonts.conf and syntax
        initialize "configuration"   --- configuration options
    end)

    initialize "loaders"         --- Font loading; callbacks
    initialize "database"        --- Font management.
    initialize "colors"          --- Per-font colors.

    local init_resolvers = loadmodule "resolvers" --- Font lookup
    init_resolvers ()

    if not config.actions.reconfigure () then
        logreport ("log", 0, "load", "Post-configuration hooks failed.")
    end

    initialize "features"     --- font request and feature handling

    if harfstatus then
        loadmodule "harf-define"
        loadmodule "harf-plug"
    end
    loadmodule "letterspace"  --- extra character kerning
    loadmodule "embolden"     --- fake bold
    loadmodule "notdef"       --- missing glyph handling
    loadmodule "suppress"     --- suppress ligatures by adding ZWNJ
    loadmodule "szss"       --- missing glyph handling
    initialize "auxiliary"    --- additional high-level functionality
    loadmodule "tounicode"

    luaotfload.aux.start_rewrite_fontname () --- to be migrated to fontspec

    logreport ("log", 1, "main",
               "initialization completed in %0.3f seconds\n",
               osgettimeofday() - starttime)
----inspect (timing_info)
end

-- vim:tw=79:sw=4:ts=4:et

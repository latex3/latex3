if not modules then modules = { } end modules ['luatex-fonts'] = {
    version   = 1.001,
    comment   = "companion to luatex-fonts.tex",
    author    = "Hans Hagen, PRAGMA-ADE, Hasselt NL",
    copyright = "PRAGMA ADE / ConTeXt Development Team",
    license   = "see context related readme files"
}

-- A merged file is generated with:
--
--   mtxrun --script package --merge --stripcontext luatex-fonts.lua
--
-- A needed resource file is made by:
--
--   mtxrun --script context luatex-basics-prepare.tex
--
-- A font (generic) database is created with:
--
--   mtxrun --script font --reload --simple

-- The following code isolates the generic context code from already defined or to be defined
-- namespaces. This is the reference loader for plain tex. This generic code is also used in
-- luaotfload which is a low level lualatex opentype font loader but somehow has gotten a bit
-- too generic name / prefix, originally set up and maintained by Khaled Hosny. Currently that
-- set of derived files is maintained by a larger team lead by Philipp Gesang so when there are
-- issues with this code in latex, you can best contact him. It might make sense then to first
-- check if context has the same issue. We do our best to keep the interface as clean as possible.
--
-- The code base is rather stable now, especially if you stay away from the non generic code. All
-- relevant data is organized in tables within the main table of a font instance. There are a few
-- places where in context other code is plugged in, but this does not affect the core code. Users
-- can (given that their macro package provides this option) access the font data (characters,
-- descriptions, properties, parameters, etc) of this main table. The documentation is part of
-- context. There is also a manual for the helper libraries (maintained as part of the cld manuals).
--
-- Future versions will probably have some more specific context code removed, like tracing and
-- obscure hooks, so that we have a more efficient version (and less files too). So, don't depend
-- too much on low level code that is meant for context as it can change without notice. We might
-- also add more helper code here, but that depends to what extend metatex (sidetrack of context)
-- evolves into a low level layer (depends on time, as usual).

-- The code here is the same as in context version 2015.09.11 but the rendering in context can be
-- different from generic. This can be a side effect of additional callbacks, additional features
-- and interferences between mechanisms between macro packages. We use the rendering in context
-- and luatex-plain as reference for issues.

-- I might as well remove some code that is not used in generic (or not used by generic users)
-- like color fonts (emoji etc) and variable fonts thereby making the code base smaller. However
-- I might keep ity just for the sake of testing the plain loader that comes with context. We'll
-- see.

-- As a side effect of cleaning up some context code, like code meant for older version of luatex,
-- as well replacing code for more recent versions (post 1.12) there can be changes in the modules
-- used here, especially where we check for 'context' being used. Hopefully there are no side
-- effects. Because we can now assume that the the glyph injection callback is in recent texlive
-- installations, the variable font code is now enabled in the generic version that comes with
-- context (as unofficial bonus; when it was demonstrated at bachotex 2017 it worked ok for the
-- generic loader but was kind of disabled there as no one needs it). I waited with adding the
-- pending code for type 3 support till texlive 2020 was fozen but it will be in texlive 2021 (it
-- is already tested in context back in 2019 and I wanted to release it at the canceled BT 2020
-- meeting, so I consider it stable, read: this is it). To what extend and when I will adapt the
-- generic code (for color support) to that is yet to be decided because in context we do things
-- a bit differently. We anyway have to wait a few years till that callback is omnipresent so I'm
-- not in that much of a hurry. (There will be a TB article about it first and after that I will
-- add some examples to the manual.)

utf = utf or (unicode and unicode.utf8) or { }

-- We have some (global) hooks (for latex). Maybe I'll use this signal to disable some of the
-- more tricky features like variable fonts and emoji (because afaik latex uses hb for that).

if not non_generic_context then
    non_generic_context = { }
end

if not non_generic_context.luatex_fonts then
    non_generic_context.luatex_fonts = {
     -- load_before  = nil,
     -- load_after   = nil,
     -- skip_loading = nil,
    }
end

if not generic_context then
    generic_context  = { }
end

if not generic_context.push_namespaces then

    function generic_context.push_namespaces()
     -- logs.report("system","push namespace")
        local normalglobal = { }
        for k, v in next, _G do
            normalglobal[k] = v
        end
        return normalglobal
    end

    function generic_context.pop_namespaces(normalglobal,isolate)
        if normalglobal then
         -- logs.report("system","pop namespace")
            for k, v in next, _G do
                if not normalglobal[k] then
                    generic_context[k] = v
                    if isolate then
                        _G[k] = nil
                    end
                end
            end
            for k, v in next, normalglobal do
                _G[k] = v
            end
            -- just to be sure:
            setmetatable(generic_context,_G)
        else
            logs.report("system","fatal error: invalid pop of generic_context")
            os.exit()
        end
    end

end

local whatever = generic_context.push_namespaces()

-- We keep track of load time by storing the current time. That way we cannot be accused
-- of slowing down loading too much. Anyhow, there is no reason for this library to perform
-- slower in any other package as it does in context.
--
-- Please don't update to this version without proper testing. It might be that this version
-- lags behind stock context and the only formal release takes place around tex live code
-- freeze.

local starttime = os.gettimeofday()

-- As we don't use the context file searching, we need to initialize the kpse library. As the
-- progname can be anything we will temporary switch to the context namespace if needed. Just
-- adding the context paths to the path specification is somewhat faster.
--
-- Now, with lua 5.2 being used we might create a special ENV for this.

-- kpse.set_program_name("luatex")

-- One can define texio.reporter as alternative terminal/log writer. That's as far
-- as I want to go with this.

local ctxkpse = nil
local verbose = true

if not logs or not logs.report then
    if not logs then
        logs = { }
    end
    function logs.report(c,f,...)
        local r = texio.reporter or texio.write_nl
        if f then
            r(c .. " : " .. string.format(f,...))
        else
            r("")
        end
    end
end

local function loadmodule(name,continue)
    local foundname = kpse.find_file(name,"tex") or ""
    if not foundname then
        if not ctxkpse then
            ctxkpse = kpse.new("luatex","context")
        end
        foundname = ctxkpse:find_file(name,"tex") or ""
    end
    if foundname == "" then
        if not continue then
            logs.report("system","unable to locate file '%s'",name)
            os.exit()
        end
    else
        if verbose then
            logs.report("system","loading '%s'",foundname) -- no file.basename yet
        end
        dofile(foundname)
    end
end

if non_generic_context.luatex_fonts.load_before then
    loadmodule(non_generic_context.luatex_fonts.load_before,true)
end

if non_generic_context.luatex_fonts.skip_loading ~= true then

    loadmodule('luatex-fonts-merged.lua',true)

    if fonts then

        if not fonts._merge_loaded_message_done_ then
            texio.write_nl("log", "!")
            texio.write_nl("log", "! I am using the merged version of 'luatex-fonts.lua' here. If")
            texio.write_nl("log", "! you run into problems or experience unexpected behaviour, and")
            texio.write_nl("log", "! if you have ConTeXt installed you can try to delete the file")
            texio.write_nl("log", "! 'luatex-font-merged.lua' as I might then use the possibly")
            texio.write_nl("log", "! updated libraries. The merged version is not supported as it")
            texio.write_nl("log", "! is a frozen instance. Problems can be reported to the ConTeXt")
            texio.write_nl("log", "! mailing list.")
            texio.write_nl("log", "!")
        end

        fonts._merge_loaded_message_done_ = true

    else

        -- The following helpers are a bit overkill but I don't want to mess up
        -- context code for the sake of general generality. Around version 1.0
        -- there will be an official api defined.
        --
        -- So, I will strip these libraries and see what is really needed so that
        -- we don't have this overhead in the generic modules. The next section
        -- is only there for the packager, so stick to using luatex-fonts with
        -- luatex-fonts-merged.lua and forget about the rest. The following list
        -- might change without prior notice (for instance because we shuffled
        -- code around).

        loadmodule("l-lua.lua")
        loadmodule("l-lpeg.lua")
        loadmodule("l-function.lua")
        loadmodule("l-string.lua")
        loadmodule("l-table.lua")
        loadmodule("l-io.lua")
        loadmodule("l-file.lua")
        loadmodule("l-boolean.lua")
        loadmodule("l-math.lua")

        -- A few slightly higher level support modules:

        loadmodule("util-str.lua") -- future versions can ship without this one
        loadmodule("util-fil.lua") -- future versions can ship without this one

        -- The following modules contain code that is either not used at all
        -- outside context or will fail when enabled due to lack of other
        -- modules.

        -- First we load a few helper modules. This is about the miminum needed
        -- to let the font modules do their work. Don't depend on their functions
        -- as we might strip them in future versions of this generic variant.

        loadmodule('luatex-basics-gen.lua')
        loadmodule('data-con.lua')

        -- We do need some basic node support. The code in there is not for
        -- general use as it might change.

        loadmodule('luatex-basics-nod.lua')

        -- We ship a resources needed for font handling (more might end up here).

        loadmodule('luatex-basics-chr.lua')

        -- Now come the font modules that deal with traditional tex fonts as well
        -- as open type fonts.
        --
        -- The font database file (if used at all) must be put someplace visible
        -- for kpse and is not shared with context. The mtx-fonts script can be
        -- used to generate this file (using the --reload --force --simple option).

        loadmodule('font-ini.lua')
        loadmodule('luatex-fonts-mis.lua')
        loadmodule('font-con.lua')
        loadmodule('luatex-fonts-enc.lua')
        loadmodule('font-cid.lua')
        loadmodule('font-map.lua')

        -- We use a bit simpler database because using the context one demands
        -- loading more helper code and although it is more flexible (more ways
        -- to resolve and so) it will never be uses in plain/latex anyway, so
        -- let's stick to a simple approach.

        loadmodule('luatex-fonts-syn.lua')

        -- We need some helpers.

        loadmodule('font-vfc.lua')

        -- This is the bulk of opentype code. The color and variable font support (as for
        -- emoji) can (and might) actually go away here because it has never been used
        -- outside context so in retrospect there was no need for it being generic.

        loadmodule('font-otr.lua')
        loadmodule('font-cff.lua')
        loadmodule('font-ttf.lua')
        loadmodule('font-dsp.lua')
        loadmodule('font-oti.lua')
        loadmodule('font-ott.lua')
        loadmodule('font-otl.lua')
        loadmodule('font-oto.lua')
        loadmodule('font-otj.lua')
        loadmodule('font-oup.lua')
        loadmodule('font-ota.lua')
        loadmodule('font-ots.lua')
        loadmodule('font-otc.lua')
        loadmodule('font-osd.lua')
        loadmodule('font-ocl.lua')

        -- The code for type one fonts.

        loadmodule('font-onr.lua')
        loadmodule('font-one.lua')
        loadmodule('font-afk.lua')

        -- And for traditional TeX fonts.

        loadmodule('luatex-fonts-tfm.lua')

        -- Some common code.

        loadmodule('font-lua.lua')
        loadmodule('font-def.lua')
        loadmodule('font-shp.lua')

        -- We support xetex compatible specifiers (plain/latex only).

        loadmodule('luatex-fonts-def.lua') -- was font-xtx.lua

        -- Here come some additional features.

        loadmodule('luatex-fonts-ext.lua')
        loadmodule('font-imp-tex.lua')
        loadmodule('font-imp-ligatures.lua')
        loadmodule('font-imp-italics.lua')
        loadmodule('font-imp-effects.lua')
        loadmodule('luatex-fonts-lig.lua')

        -- We need to plug into a callback and the following module implements the
        -- handlers. Actual plugging in happens later.

        loadmodule('luatex-fonts-gbn.lua')

    end

end

if non_generic_context.luatex_fonts.load_after then
    loadmodule(non_generic_context.luatex_fonts.load_after,true)
end

resolvers.loadmodule = loadmodule

-- In order to deal with the fonts we need to initialize some callbacks. One can overload them later
-- on if needed. First a bit of abstraction.

generic_context.callback_ligaturing           = false
generic_context.callback_kerning              = false
generic_context.callback_pre_linebreak_filter = nodes.simple_font_handler
generic_context.callback_hpack_filter         = nodes.simple_font_handler
generic_context.callback_define_font          = fonts.definers.read

-- The next ones can be done at a different moment if needed. You can create a generic_context namespace
-- and set no_callbacks_yet to true, load this module, and enable the callbacks later. So, there is really
-- *no* need to create a alternative for luatex-fonts.lua and luatex-fonts-merged.lua: just load this one
-- and overload if needed.

if not generic_context.no_callbacks_yet then

    callback.register('ligaturing',           generic_context.callback_ligaturing)
    callback.register('kerning',              generic_context.callback_kerning)
    callback.register('pre_linebreak_filter', generic_context.callback_pre_linebreak_filter)
    callback.register('hpack_filter',         generic_context.callback_hpack_filter)
    callback.register('define_font' ,         generic_context.callback_define_font)

end

-- We're done.

logs.report("system","luatex-fonts.lua loaded in %0.3f seconds", os.gettimeofday()-starttime)

generic_context.pop_namespaces(whatever)

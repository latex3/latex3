----------------------
--- Initialization ---
----------------------

-- Save some locals for a slight speed boost.
local append              = table.append
local concatenate         = table.concat
local create_token        = token.create
local getmetatable        = getmetatable
local insert              = table.insert
local ipairs              = ipairs
local lua_functions_table = lua.get_functions_table()
local merge_array         = table.imerged
local merge_hash          = table.merged
local new_lua_function    = luatexbase.new_luafunction
local new_token           = token.new
local next                = next
local pairs               = pairs
local scan_argument       = token.scan_argument
local scan_csname         = token.scan_csname
local scan_expanded       = token.scan_token
local scan_int            = token.scan_int
local scan_string         = token.scan_string
local scan_token          = token.get_next
local scan_toks           = token.scan_toks
local setmetatable        = setmetatable
local sorted_pairs        = table.sortedpairs
local sprint              = tex.sprint
local tex_get             = tex.get
local token               = token
local token_get_csname    = token.get_csname
local token_get_mode      = token.get_mode
local token_set_char      = token.set_char
local token_set_lua       = token.set_lua
local unpack              = table.unpack
local write_token         = token.put_next


------------------------
--- Helper Functions ---
------------------------
-- This section is mainly copied from:
--     https://github.com/gucci-on-fleek/luatools/blob/master/source/luatools.lua

--- @enum (key) _arguments_type
local argument_types = {
    argument = { variant = "n", scanner = scan_argument, },
    csname   = { variant = "N", scanner = scan_csname,   },
    int      = { variant = "w", scanner = scan_int,      },
    string   = { variant = "n", scanner = scan_string,   },
    token    = { variant = "N", scanner = scan_token,    },
    toks     = { variant = "n", scanner = scan_toks,     },
}

--- The parameters for defining a new macro.
--- @class (exact)  _macro_define
---
--- The Lua function to run when the macro is called.
--- @field func  fun(...): nil
---
--- The module in which to place the macro.
--- @field module  string
---
--- The name of the macro.
--- @field name  string
---
--- A list of the arguments that the macro takes (Default: `{}`).
--- @field arguments?  _arguments_type[]
---
--- The scope of the macro: `local` or `global` (Default: `local`).
--- @field scope?  "local" | "global"
---
--- The visibility of the macro: `public` or `private` (Default: `private`).
--- @field visibility? "public" | "private"
---
--- Whether the macro is `protected` (Default: `false`).
--- @field ["protected"]?  boolean
---
--- Whether to ignore the scanners, which is more annoying to implement, but
--- faster. (Default: `false`).
--- @field no_scan?  boolean

--- Defines a new macro.
---
--- The parameters for the new macro.
--- @param  params _macro_define
local function define_macro(params)
    -- Setup the default parameters
    local arguments = params.arguments or {}
    local func      = params.func

    -- Get the macro's name
    local name_components = { params.module, "_", params.name, ":" }
    if params.visibility == "private" then
        insert(name_components, 1, "__")
    end

    for _, argument in ipairs(arguments) do
        insert(name_components, argument_types[argument].variant)
    end

    local name = concatenate(name_components)

    -- Generate the scanning function
    local scanning_func
    if #arguments == 0 or params.no_scan then
        -- No arguments, so we can just run the function directly
        scanning_func = func
    else
        -- Before we can run the given function, we need to scan for the
        -- requested arguments in \TeX{}, then pass them to the function.
        local scanners = {}
        for _, argument in ipairs(arguments) do
            insert(scanners, argument_types[argument].scanner)
        end

        -- An intermediate function that properly “scans” for its arguments
        -- in the \TeX{} side.
        scanning_func = function()
            local values = {}
            for _, scanner in ipairs(scanners) do
                insert(values, scanner())
            end

            func(unpack(values))
        end
    end

    -- Handle scope and protection
    local extra_params = {}
    if params.scope == "global" then
        insert(extra_params, "global")
    end
    if params.protected then
        insert(extra_params, "protected")
    end

    local index = new_lua_function(name)
    lua_functions_table[index] = scanning_func
    token_set_lua(name, index, unpack(extra_params))
end


--- @class _memoized<K, V>: { [K]: V } A memoized table.
--- @operator call(any): any           - -

--- Memoizes a function call/table index.
---
--- @generic K, V              -
--- @param  func fun(key:K):V? The function to memoize
--- @return _memoized<K, V> -  The “function”
local function memoized(func)
    return setmetatable({}, { __index = function(cache, key)
        local ret = func(key)
        cache[key] = ret
        return ret
    end,  __call = function(self, arg)
        return self[arg]
    end })
end

local codepoint_to_char = memoized(utf8.char)
local char_to_codepoint = memoized(utf8.codepoint)
local command_id        = memoized(token.command_id)

local CHAR_GIVEN = command_id["char_given"]
local to_chardef = memoized(function(int)
    return new_token(int, CHAR_GIVEN)
end)


-------------------------------
--- Property List Functions ---
-------------------------------

-- Module-local storage
local prop_storage = {}
local MIN_PROP_ID = 127
local max_prop_id = MIN_PROP_ID

-- Utility functions
local function new_prop(name)
    max_prop_id = max_prop_id + 1

    local id = max_prop_id
    local current_level = 0 -- tex_get("currentgrouplevel")

    prop_storage[id] = {}
    prop_storage[id][current_level] = {}

    local packed = (id << 16) | current_level

    token_set_char(name, packed, "global")
end

local function prop_meta_pairs(level)
    local meta = getmetatable(level)
    local entry = prop_storage[meta.id]

    local current_level = tex_get("currentgrouplevel")
    local all_levels = {}
    for i = 0, current_level do
        all_levels[#all_levels+1] = entry[i]
    end

    local merged = merge_hash(unpack(all_levels))
    return next, merged
end

local function new_prop_level(token, value)
    local packed = token_get_mode(token)
    local id = packed >> 16
    local tex_level = packed & 0xFFFF

    local entry = prop_storage[id]
    local current_level = tex_get("currentgrouplevel")

    if tex_level == current_level then
        return entry[tex_level]
    else
        local new_level = setmetatable(value or {}, {
            __index = entry[tex_level],
            __pairs = prop_meta_pairs,
            id      = id,
        })
        local csname = token_get_csname(token)
        local new_packed = (id << 16) | current_level

        token_set_char(csname, new_packed)
        entry[current_level] = new_level

        return new_level
    end
end

local function get_prop_level(token, forced_level, new_value)
    local packed = token_get_mode(token)
    local id = packed >> 16
    local tex_level = forced_level or (packed & 0xFFFF)

    if id < MIN_PROP_ID then
        return {}
    end

    if new_value then
        prop_storage[id][tex_level] = new_value
    else
        for i = tex_level, 0, -1 do
            local level = prop_storage[id][i]
            if level then
                return level
            end
        end
    end
end

-- TeX functions
define_macro {
    module      = "lprop",
    name        = "new",
    arguments   = { "csname", },
    visibility  = "private",
    func = new_prop,
}

define_macro {
    module     = "lprop",
    name       = "put",
    arguments  = { "token", "string", "toks", },
    visibility = "public",
    no_scan    = true,
    func = function()
        local prop  = scan_token()
        local key   = scan_string()
        local value = scan_toks()

        local level = new_prop_level(prop)
        level[key] = value
    end,
}

define_macro {
    module     = "lprop",
    name       = "gput",
    arguments  = { "token", "string", "toks", },
    visibility = "public",
    no_scan    = true,
    func = function()
        local prop  = scan_token()
        local key   = scan_string()
        local value = scan_toks()

        local level = get_prop_level(prop, 0)
        level[key] = value
    end,
}

define_macro {
    module     = "lprop",
    name       = "item",
    arguments  = { "token", "string", },
    visibility = "public",
    no_scan    = true,
    func = function()
        local prop = scan_token()
        local key  = scan_string()

        local level = get_prop_level(prop)
        local value = level[key]

        if value then
            write_token(value)
        end
    end,
}

define_macro {
    module     = "lprop",
    name       = "clear",
    arguments  = { "token", },
    visibility = "public",
    no_scan    = true,
    func = function()
        local prop = scan_token()
        local level = new_prop_level(prop)

        for key in pairs(level) do
            level[key] = false
        end
    end,
}

define_macro {
    module     = "lprop",
    name       = "gclear",
    arguments  = { "token", },
    visibility = "public",
    no_scan    = true,
    func = function()
        local prop = scan_token()
        get_prop_level(prop, 0, {})
    end,
}

local KEY_TERMINATOR       = char_to_codepoint["="]
local VALUE_TERMINATOR     = char_to_codepoint[","]
local BEGIN_GROUP          = command_id["left_brace"]
local END_GROUP            = command_id["right_brace"]
local SPACER               = command_id["spacer"]
local value_terminator_tok = new_token(VALUE_TERMINATOR, command_id["other"])

local function parse_keyval(level)
    local keyval_toks = scan_toks()
    keyval_toks[#keyval_toks + 1] = value_terminator_tok

    local nest = 0
    local key, value = {}, {}
    local target_key = true

    for i = 1, #keyval_toks do
        local user_tok = keyval_toks[i]
        local cmd = user_tok.command
        local chr = user_tok.mode
        local cs  = user_tok.csname

        -- Always insert macros
        if cs then
            goto insert_token
        end

        -- Handle nesting
        if cmd == BEGIN_GROUP then
            nest = nest + 1
        elseif cmd == END_GROUP then
            nest = nest - 1
        end

        -- Only parse the key-value pair if we're at the outermost level
        if nest == 0 then
            -- Store the key-value pair
            if chr == VALUE_TERMINATOR then
                level[concatenate(key)] = value
                key, value = {}, {}
                target_key = true
                goto continue

            -- End the key and switch to the value
            elseif chr == KEY_TERMINATOR then
                target_key = false
                goto continue

            -- Trim spaces
            elseif cmd == SPACER then
                -- Trim spaces at the beginning
                if target_key and (#key == 0) then
                    goto continue
                elseif (not target_key) and (#value == 0) then
                    goto continue
                end

                -- Trim spaces at the end
                local next_chr = (keyval_toks[i + 1] or {}).mode
                if (not next_chr) or
                    (next_chr == VALUE_TERMINATOR) or
                    (next_chr == KEY_TERMINATOR)
                then
                    goto continue
                end

            -- Skip outermost closing brace
            elseif cmd == END_GROUP then
                goto continue
            end

        -- Skip the outermost opening brace
        elseif nest == 1 then
            if cmd == BEGIN_GROUP then
                goto continue
            end
        end

        -- Insert the token
        ::insert_token::
        if target_key then
            key[#key + 1] = codepoint_to_char[chr]
        else
            value[#value + 1] = user_tok
        end

        ::continue::
    end
end

define_macro {
    module     = "lprop",
    name       = "put_from_keyval",
    arguments  = { "token", "toks", },
    visibility = "public",
    no_scan    = true,
    func = function()
        local prop  = scan_token()
        local level = new_prop_level(prop)

        parse_keyval(level)
    end,
}

define_macro {
    module     = "lprop",
    name       = "gput_from_keyval",
    arguments  = { "token", "toks", },
    visibility = "public",
    no_scan    = true,
    func = function()
        local prop = scan_token()
        local level = get_prop_level(prop, 0)

        parse_keyval(level)
    end,
}

local begin_group_tok  = new_token(char_to_codepoint["{"], BEGIN_GROUP)
local end_group_tok = new_token(char_to_codepoint["}"], END_GROUP)

define_macro {
    module     = "lprop",
    name       = "map_function",
    arguments  = { "token", "token", },
    visibility = "public",
    no_scan    = true,
    func = function()
        local prop  = scan_token()
        local level = get_prop_level(prop)
        local func  = scan_token()

        local toks, len = {}, 0
        for key, value in pairs(level) do
            if value then
                toks[len + 1] = func
                toks[len + 2] = begin_group_tok
                toks[len + 3] = key
                toks[len + 4] = end_group_tok
                toks[len + 5] = begin_group_tok
                append(toks, value)
                len = #toks + 1
                toks[len + 0] = end_group_tok
            end
        end

        sprint(-2, toks)
    end,
}

define_macro {
    module     = "lprop",
    name       = "concat",
    arguments  = { "token", "token", "token", },
    visibility = "public",
    func = function(out, first, second)
        local first_level = get_prop_level(first)
        local second_level = get_prop_level(second)
        new_prop_level(out, merge_hash(first_level, second_level))
    end,
}

define_macro {
    module     = "lprop",
    name       = "gconcat",
    arguments  = { "token", "token", "token", },
    visibility = "public",
    func = function(out, first, second)
        local first_level = get_prop_level(first, 0)
        local second_level = get_prop_level(second, 0)
        get_prop_level(out, 0, merge_hash(first_level, second_level))
    end,
}

define_macro {
    module     = "lprop",
    name       = "count",
    arguments  = { "token", },
    visibility = "public",
    no_scan    = true,
    func = function()
        local prop  = scan_token()
        local level = get_prop_level(prop)

        local count = 0
        for _ in pairs(level) do
            count = count + 1
        end
        write_token(to_chardef[count])
    end,
}

define_macro {
    module     = "lprop",
    name       = "remove",
    arguments  = { "token", "string", },
    visibility = "public",
    no_scan    = true,
    func = function()
        local prop  = scan_token()
        local key   = scan_string()
        local level = new_prop_level(prop)

        level[key] = false
    end,
}

define_macro {
    module     = "lprop",
    name       = "gremove",
    arguments  = { "token", "string", },
    visibility = "public",
    no_scan    = true,
    func = function()
        local prop  = scan_token()
        local key   = scan_string()
        local level = get_prop_level(prop, 0)

        level[key] = nil
    end,
}

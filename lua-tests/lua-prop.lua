----------------------
--- Initialization ---
----------------------

-- Save some locals for a slight speed boost.
local append              = table.append
local concatenate         = table.concat
local direct_get_data     = node.direct.getdata
local direct_set_data     = node.direct.setdata
local direct_set_field    = node.direct.setfield
local insert              = table.insert
local ipairs              = ipairs
local lua_functions_table = lua.get_functions_table()
local merge_array         = table.imerged
local merge_hash          = table.merged
local new_lua_function    = luatexbase.new_luafunction
local new_token           = token.new
local next                = next
local node                = node
local pairs               = pairs
local scan_argument       = token.scan_argument
local scan_csname         = token.scan_csname
local scan_int            = token.scan_int
local scan_string         = token.scan_string
local scan_token          = token.scan_token
local scan_toks           = token.scan_toks
local setmetatable        = setmetatable
local sprint              = tex.sprint
local token               = token
local token_get_next      = token.get_next
local token_put_next      = token.put_next
local token_set_lua       = token.set_lua
local unpack              = table.unpack


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


--- @class (exact) tab_tok: table A table representing a token.
--- @field [1] integer      (cmd) The command code of the token.
--- @field [2] integer      (chr) The character code of the token.
--- @field [3] integer?     (cs)  The index into the \TeX{} hash table.

local token_userdata_to_table
do
    local scratch = node.direct.new("whatsit", "user_defined")
    direct_set_field(scratch, "type", ("t"):byte())

    --- Converts a table of “userdata” tokens into a table of triplets, each
    --- representing a token.
    ---
    --- @param  userdata  luatex.token[]
    --- @return tab_tok[] table
    function token_userdata_to_table(userdata)
        direct_set_data(scratch, userdata)
        return direct_get_data(scratch)
    end
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

local prop_storage = {}

define_macro {
    module      = "lprop",
    name        = "new",
    arguments   = { "csname", },
    visibility  = "private",
    func = function(name)
        prop_storage[name] = {}
    end,
}

define_macro {
    module     = "lprop",
    name       = "gput",
    arguments  = { "csname", "string", "toks", },
    visibility = "public",
    no_scan    = true,
    func = function()
        prop_storage[scan_csname()][scan_string()] = scan_toks()
    end,
}

define_macro {
    module     = "lprop",
    name       = "item",
    arguments  = { "csname", "string", },
    visibility = "public",
    no_scan    = true,
    func = function()
        token_put_next(prop_storage[scan_csname()][scan_string()] or {})
    end,
}

define_macro {
    module     = "lprop",
    name       = "gclear",
    arguments  = { "csname", },
    visibility = "public",
    no_scan    = true,
    func = function()
        prop_storage[scan_csname()] = {}
    end,
}

define_macro {
    module     = "lprop",
    name       = "gset_eq",
    arguments  = { "csname", "csname", },
    visibility = "public",
    no_scan    = true,
    func = function()
        prop_storage[scan_csname()] = prop_storage[scan_csname()]
    end,
}

local KEY_TERMINATOR       = char_to_codepoint["="]
local VALUE_TERMINATOR     = char_to_codepoint[","]
local BEGIN_GROUP          = command_id["left_brace"]
local END_GROUP            = command_id["right_brace"]
local SPACER               = command_id["spacer"]
local value_terminator_tok = new_token(VALUE_TERMINATOR, command_id["other"])

define_macro {
    module     = "lprop",
    name       = "gput_from_keyval",
    arguments  = { "csname", "toks", },
    visibility = "public",
    no_scan    = true,
    func = function()
        local prop = prop_storage[scan_csname()]
        local user_toks = scan_toks()
        user_toks[#user_toks + 1] = value_terminator_tok

        local nest = 0
        local key, value = {}, {}
        local target_key = true

        for i = 1, #user_toks do
            local user_tok = user_toks[i]
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
                    prop[concatenate(key)] = value
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
                    local next_chr = (user_toks[i + 1] or {}).mode
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
    end,
}

local begin_group_tok  = new_token(char_to_codepoint["{"], BEGIN_GROUP)
local end_group_tok = new_token(char_to_codepoint["}"], END_GROUP)

define_macro {
    module     = "lprop",
    name       = "map_function",
    arguments  = { "csname", "csname", },
    visibility = "public",
    no_scan    = true,
    func = function()
        local prop = prop_storage[scan_csname()]
        local func = token_get_next()

        local toks, len = {}, 0
        for key, value in next, prop do
            toks[len + 1] = func
            toks[len + 2] = begin_group_tok
            toks[len + 3] = key
            toks[len + 4] = end_group_tok
            toks[len + 5] = begin_group_tok
            append(toks, value)
            len = #toks + 1
            toks[len + 0] = end_group_tok
        end

        sprint(toks)
    end,
}

define_macro {
    module     = "lprop",
    name       = "gconcat",
    arguments  = { "csname", "csname", "csname", },
    visibility = "public",
    func = function(first, second, out)
        prop_storage[out] = merge_hash(prop_storage[first], prop_storage[second])
    end,
}

define_macro {
    module     = "lprop",
    name       = "count",
    arguments  = { "csname", },
    visibility = "public",
    no_scan    = true,
    func = function()
        local count = 0
        for _ in next, prop_storage[scan_csname()] do
            count = count + 1
        end
        token_put_next(to_chardef[count])
    end,
}

define_macro {
    module     = "lprop",
    name       = "gremove",
    arguments  = { "csname", "string", },
    visibility = "public",
    no_scan    = true,
    func = function()
        prop_storage[scan_csname()][scan_string()] = nil
    end,
}

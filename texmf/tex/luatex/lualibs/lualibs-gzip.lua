if not modules then modules = { } end modules ['l-gzip'] = {
    version   = 1.001,
    author    = "Hans Hagen, PRAGMA-ADE, Hasselt NL",
    copyright = "PRAGMA ADE / ConTeXt Development Team",
    license   = "see context related readme files"
}

-- We only have a few official methods here:
--
--   local decompressed = gzip.load       (filename)
--   local resultsize   = gzip.save       (filename,compresslevel)
--   local compressed   = gzip.compress   (str,compresslevel)
--   local decompressed = gzip.decompress (str)
--   local iscompressed = gzip.compressed (str)
--   local suffix, okay = gzip.suffix     (filename)
--
-- In LuaMetaTeX we have only xzip which implements a very few methods:
--
--   compress   (str,level,method,window,memory,strategy)
--   decompress (str,window)
--   adler32    (str,checksum)
--   crc32      (str,checksum)
--
-- Special window values are:
--
-- flate : - 15
-- zlib  :   15
-- gzip  :   15 | 16
-- auto  :   15 | 32

gzip = gzip or { } -- so in luatex we keep the old ones too

if not zlib then
    zlib = xzip    -- in luametatex we shadow the old one
elseif not xzip then
    xzip = zlib
end

if zlib then

    local suffix     = file.suffix
    local suffixes   = file.suffixes
    local find       = string.find
    local openfile   = io.open

    local gzipwindow = 15 + 16 -- +16: gzip, +32: gzip|zlib
    local gziplevel  = 3
    local identifier = "^\x1F\x8B\x08"

    local compress   = zlib.compress
    local decompress = zlib.decompress

    function gzip.load(filename)
        local f = openfile(filename,"rb")
        if not f then
            -- invalid file
        else
            local data = f:read("*all")
            f:close()
            if data and data ~= "" then
                if suffix(filename) == "gz" then
                    data = decompress(data,gzipwindow)
                end
                return data
            end
        end
    end

    function gzip.save(filename,data,level)
        if suffix(filename) ~= "gz" then
            filename = filename .. ".gz"
        end
        local f = openfile(filename,"wb")
        if f then
            data = compress(data or "",level or gziplevel,nil,gzipwindow)
            f:write(data)
            f:close()
            return #data
        end
    end

    function gzip.suffix(filename)
        local suffix, extra = suffixes(filename)
        local gzipped = extra == "gz"
        return suffix, gzipped
    end

    function gzip.compressed(s)
        return s and find(s,identifier)
    end

    function gzip.compress(s,level)
        if s and not find(s,identifier) then -- the find check might go away
            if not level then
                level = gziplevel
            elseif level <= 0 then
                return s
            elseif level > 9 then
                level = 9
            end
            return compress(s,level or gziplevel,nil,gzipwindow) or s
        end
    end

    function gzip.decompress(s)
        if s and find(s,identifier) then
            return decompress(s,gzipwindow)
        else
            return s
        end
    end

end

-- In luametatex we can use this one but it doesn't look like there wil be stream
-- support so for now we still use zlib (the performance difference is not that
-- spectacular in our usage.

-- if flate then
--
--     local type = type
--     local find = string.find
--
--     local compress   = flate.gz_compress
--     local decompress = flate.gz_decompress
--
--     local absmax     = 128*1024*1024
--     local initial    =       64*1024
--     local identifier = "^\x1F\x8B\x08"
--
--     function gzip.compressed(s)
--         return s and find(s,identifier)
--     end
--
--     function gzip.compress(s,level)
--         if s and not find(s,identifier) then -- the find check might go away
--             if not level then
--                 level = 3
--             elseif level <= 0 then
--                 return s
--             elseif level > 9 then
--                 level = 9
--             end
--             return compress(s,level) or s
--         end
--     end
--
--     function gzip.decompress(s,size,iterate)
--         if s and find(s,identifier) then
--             if type(size) ~= "number" then
--                 size = initial
--             end
--             if size > absmax then
--                 size = absmax
--             end
--             if type(iterate) == "number" then
--                 max = size * iterate
--             elseif iterate == nil or iterate == true then
--                 iterate = true
--                 max     = absmax
--             end
--             if max > absmax then
--                 max = absmax
--             end
--             while true do
--                 local d = decompress(s,size)
--                 if d then
--                     return d
--                 end
--                 size = 2 * size
--                 if not iterate or size > max then
--                     return false
--                 end
--             end
--         else
--             return s
--         end
--     end
--
-- end

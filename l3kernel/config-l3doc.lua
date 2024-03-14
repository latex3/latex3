testfiledir  = "testfiles-l3doc"
checkdeps    = {maindir .. "/l3backend", maindir .. "/l3packages"}
checkengines = { "pdftex" }
checksearch  = true
checkruns    = 3

local runtest_hide = true -- To be replaced by a runtest parameter

function runtest_tasks(name, _run)
  return string.format('makeindex -s gind.ist %s.idx%s',
      name, runtest_hide and ' 2> ' .. os_null or '')
end

test_order = {"log", "idx", }
test_types = test_types or {}
test_types.idx = {
  test        = '.lit', -- Latex Index Test
  generated   = '.idx',
  reference   = '.tix', -- Test IdX
  expectation = '.lie', -- Latex Index Expectation
  rewrite     = function(source, result, engine, errlevels)
    local s = assert(io.open(source, 'rb'))
    local r = assert(io.open(result, 'w'))
    r:write(s:read'a':gsub('\r\n', '\n') .. '\n'):close()
    s:close()
  end,
}

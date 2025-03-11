require("luarocks.loader")
local calc = require("calc")
local luaunit = require("luaunit")

function testEmptyStringReturnsZero()
    --Given
    local a = ""
    --When
    local ret = calc(a)
    --Then
    luaunit.assertEquals(ret,0)
end


function testSingleNumReturnsItself()
    --Given
    local a = "10"
    --When
    local ret = calc(a)
    --Then
    luaunit.assertEquals(ret,10)
end

function testTwoCommaDelimitedNumsReturnSum()
    --Given
    local a = "10,23"
    --When
    local ret = calc(a)
    --Then
    luaunit.assertEquals(ret,10+23)
end

function testTwoNewlineDelimitedNumsReturnSum()
    --Given
    local a = "10\n23"
    --When
    local ret = calc(a)
    --Then
    luaunit.assertEquals(ret,10+23)
end

function testThreeDelimitedNumsReturnSum()
    --Given
    local a = "10\n23,12"
    --When
    local ret = calc(a)
    --Then
    luaunit.assertEquals(ret,10+23+12)
end

function testNegativeThrows()
    --Given
    local a = "-10"
    --When
    --Then
    luaunit.assertError(calc,a)
end

function testIgnoreOver1000()
    --Given
    local a = "10\n2300,12"
    --When
    local ret = calc(a)
    --Then
    luaunit.assertEquals(ret,10+12)
end

function testAcceptCustomDelim()
    --Given
    local a = "//#\n10#12"
    --When
    local ret = calc(a)
    --Then
    luaunit.assertEquals(ret,10+12)
end
function testAcceptCustomMulticharDelim()
    --Given
    local a = "//[###]\n10###12"
    local b = "//[###]\n10##12"
    --When
    local ret = calc(a)
    --Then
    luaunit.assertEquals(ret,10+12)
    luaunit.assertError(calc,b)
end
function testAcceptCustomManyMulticharDelims()
    --Given
    local a = "//[###][xxx]\n10###12xxx13"
    local b = "//[###][x][yy]\n10x12yy13###140"
    --When
    local aret = calc(a)
    local bret = calc(b)
    --Then
    luaunit.assertEquals(aret,10+12+13)
    luaunit.assertEquals(bret,10+12+13+140)
end
os.exit(luaunit.LuaUnit.run())
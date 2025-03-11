require("luarocks.loader")
local lpeg = require("lpeg")
local P = lpeg.P
return function(str)
    local digit = lpeg.R'09'
    local delim = (P'//'*(lpeg.C(P(1)-digit)*P'\n')):match(str)
    local mdelim = (P'//'*lpeg.Ct((P'['*lpeg.C((P(1)-P(']'))^1)*P']')^0)*P'\n'):match(str)
    local delims = lpeg.S(',\n')
    if delim then
        delims = P(delim)+delims
    end
    for _,v in ipairs(mdelim or {}) do

        delims = P(v)+delims
    end
    local num = lpeg.C(digit^1) / function(x)
        return tonumber(x)
    end

    local sum = (P'//'*(P(1)-'\n')^0*P('\n'))^-1*lpeg.Ct(delims^0*num*(delims^1*num)^0)*delims^0*(-P(1)) / function(xs)
        local r = 0
        for _,v in ipairs(xs) do
            if v<=1000 then
                r = r + v
            end
        end
        return r
    end

    if str=="" then
        return 0
    end
    local ret = sum:match(str)
    if ret==nil then
        error("!No result: Error: "..(delim or "nil") .. ' ' .. (mdelim or "nil"))
    end
    return ret
end
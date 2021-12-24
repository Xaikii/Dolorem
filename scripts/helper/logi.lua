function ternary(cond, T, F)
    if cond then return T else return F end
end

function angleComp(alpha, beta)
    local d = math.abs(alpha - beta)
    return math.min(360 - d, d)
end

function directionToVectorAngle(directionValue, player)
    if directionValue ~= -1 then
        return 180 - (((math.min(directionValue, 1) * 4) - directionValue) * 90)
    end
    return player:GetLastDirection():GetAngleDegrees()
end

function vectorAngleConvert(angle)
    if angle % 360 > 180 then
        return angle - 360
    end
    return angle
end

function maskToNumber(mask, base)
    return math.log(mask+1, base)
end

function highestIndexTable(table) --Number+1, start at 1 if something found, else it's 0
    local n = -1
    for index, _ in ipairs(table) do
        if n < index then
            n = index
        end
    end
    return ternary(n>-1, n+1, 0)
end

function clearTable(tableC) 
    local t = tableC
    for i = 1, #tableC do tableC[i] = nil end
    return t
end

local function bool_to_number(value)
    return value == true and 1 or value == false and 0
end

boolToNumber = {
    [true] = 1,
    [false] = 0
}
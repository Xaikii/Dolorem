function GetPossibleGridIndiciesFromRoom(room)
    if room == RoomShape.ROOMSHAPE_1x1 or 
    room == RoomShape.ROOMSHAPE_IH or 
    room == RoomShape.ROOMSHAPE_IV then
        return 134
    elseif room == RoomShape.ROOMSHAPE_1x2 or 
    room == RoomShape.ROOMSHAPE_IIV  then
        return 239
    elseif room == RoomShape.ROOMSHAPE_2x1 or 
    room == RoomShape.ROOMSHAPE_IIH then
        return 251
    elseif room == RoomShape.ROOMSHAPE_2x2 or
    room == RoomShape.ROOMSHAPE_LTL or
    room == RoomShape.ROOMSHAPE_LTR or 
    room == RoomShape.ROOMSHAPE_LBL or 
    room == RoomShape.ROOMSHAPE_LBR then
        return 447
    else 
        return nil
    end
end

function IsSatanInRoom(_)
    local satanFound = false
    local i = 0
    for _, posSatan in pairs(Isaac.GetRoomEntities()) do
        if posSatan.Variant == EffectVariant.DEVIL then
            satanFound = true
            i = i + 1
        end
    end
    return satanFound, i
end

function IsAngelInRoom(_)
    local angelFound = false
    local i = 0
    for _, posAngel in pairs(Isaac.GetRoomEntities()) do
        if posAngel.Variant == EffectVariant.ANGEL then
            angelFound = true
            i = i + 1
        end
    end
    return angelFound, i
end

function IsShopKeeperInRoom(_)
    local keeperFound = false
    local i = 0
    for _, posKeeper in pairs(Isaac.GetRoomEntities()) do
        if posKeeper.Type == EntityType.ENTITY_SHOPKEEPER then
            keeperFound = true
            i = i + 1
        end
    end
    return keeperFound, i
end

function GetClosestEnemy(player)
    local entities = Isaac.GetRoomEntities()
    local validEntities = {}
    local indices = 0
    local currentDistance = 200000.0

    --ToDo: Create a Runtime table of alive vulnerable enemies in current Room and access thus
    for index, value in ipairs(entities) do
        if value:IsVulnerableEnemy() and not value:IsDead()then
            table.insert(validEntities, value)
        end
    end
    for index, value in ipairs(validEntities) do
        if player.Position:Distance(value.Position) < currentDistance then
            indices = index
        end
    end

    return validEntities[indices]
end
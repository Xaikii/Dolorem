require("scripts.helper.logi")
require("scripts.helper.roomHelper")

function SpawnPickup(Variant, Type, Near, Velocity, summoner, room)
    Isaac.Spawn(
        EntityType.ENTITY_PICKUP,
        Variant,
        Type,
        ternary(Near == true, room:FindFreePickupSpawnPosition(summoner.Position, 10), room:GetCenterPos()),
        Velocity,
        summoner
    )
end

function GetShopItems(_)
    local items = {}
    local num = 0
    for _, entity in pairs(Isaac.FindByType((EntityType.ENTITY_PICKUP), -1, -1 , false, false)) do
        local pickup = entity:ToPickup()
        if pickup:IsShopItem() == true then
            items[num] = pickup, pickup.ShopItemId
            num = num + 1
        end
    end
    return items
end

function FreeItem(checkUsed, lastUsedStage, amount, run, isSatanCheck, isAngelCheck, isShopKeeperCheck)

    local lastUsed = lastUsedStage --The last Stage this was completely used
    local isDone = false
    local deals = {} --Which Items can be acquired
    local reset = {}

    if ternary(checkUsed == true, lastUsed ~= Game():GetLevel():GetStage()) then
        if isSatanCheck == true then
            local is,n = IsSatanInRoom()
            if is == true then
                deals = GetShopItems()
            end
        end
        if isAngelCheck == true then
            local is,n = IsAngelInRoom()
            if is == true then
                deals = GetShopItems()
            end
        end
        if isShopKeeperCheck == true then
            local is,n = IsShopKeeperInRoom()
            if is == true then
                deals = GetShopItems()
            end
        end

        if next(deals) ~= nil then --amount you should get per floor, check if reached max
            Isaac.DebugString("Yeet")
            if checkUsed == true and 
            amount < run then --amount start at 1, run at 0
                isDone = true
            end --Should it track Used 

            local chosenItem = deals[math.random(0, #GetShopItems())]

            if chosenItem.Price ~= 0 then
                chosenItem.Price = 0
            else
                chosenItem.Price = chosenItem.Price
            end
            Isaac.DebugString("randomCheck")
            deals = reset

            return chosenItem, run + 1, isDone--amount > run and checkUsed
        end
    end
    return nil, run, false
end
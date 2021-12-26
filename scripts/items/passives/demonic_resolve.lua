local resolve = Isaac.GetItemIdByName("Demonic Resolve")

local r = 0
local blackHearts = 0
local lastUsed = LevelStage.STAGE_NULL
local run = 0
local numResolve = 0

function DemonicResolvePostPlayer(_, player)
    numResolve = player:GetCollectibleNum(resolve)

    if blackHearts ~= maskToNumber(player:GetBlackHearts(), 2) and player ~= nil then
        blackHearts = maskToNumber(player:GetBlackHearts(), 2)

        DemonicResolveUpdateStats(_,player)
    end

    if r<numResolve then

        DemonicResolveUpdateStats(_, player)
        
        r = r + 1 
    end
end

function DemonicResolveStatCache(_, player, flag)
    if player:HasCollectible(resolve) then

        if flag == CacheFlag.CACHE_DAMAGE then
            player.Damage = player.Damage * ((1 + 0.2)^numResolve)
        elseif flag == CacheFlag.CACHE_FIREDELAY then
            player.MaxFireDelay = player.MaxFireDelay * (0.955*0.99^numResolve)^blackHearts -- ((0.267 + 0.061 * numResolve) * blackHearts)
        elseif flag == CacheFlag.CACHE_SPEED then
            player.MoveSpeed = player.MoveSpeed + (0.05 * numResolve * blackHearts)
        elseif flag == CacheFlag.CACHE_LUCK then
            player.Luck = player.Luck - (2.0 * (0.9^math.max(numResolve - 1, 0)) * blackHearts)
        end
    end
end

function DemonicResolveFreeDevilDeal(_)
    --ToDo: Once a run
    local hasNotRun = true

    for i=0, Game():GetNumPlayers() -1 do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(resolve) and 
        lastUsed ~= Game():GetLevel():GetStage() then

            local _,g,h = FreeItem(true, lastUsed, numResolve, run, true, false, false)
            if g ~= run and hasNotRun == true then
                run = g
                hasNotRun = false
            end

            if h == true then
                lastUsed = Game():GetLevel():GetStage()
            end
        end
    end
end

function DemonicResolveUpdateStats(_, player)
    player:AddCacheFlags(CacheFlag.CACHE_FIREDELAY | CacheFlag.CACHE_SPEED | CacheFlag.CACHE_LUCK)
    player:EvaluateItems() 
end

DoloremMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, DemonicResolvePostPlayer)
DoloremMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, DemonicResolveStatCache)
DoloremMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, DemonicResolveFreeDevilDeal)
DoloremMod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, function(_)
        lastUsed = LevelStage.STAGE_NULL 
end)
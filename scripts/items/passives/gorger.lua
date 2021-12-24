require("scripts.helper.logi")
require('scripts.helper.enumFil')

local gorger = Isaac.GetItemIdByName("Gorger")
local rGorger = 0
local numGorger = 0
local rSpirit = 0
local numSpirit = 0
local gorgerRNG = RNG()
local RareFoodChance = 0.25
local BaseRareFoodChance = 0.25
local LegendaryFoodChance = 0.075
local BaseLegendaryFoodChance = 0.075

function GorgerPostPlayer(_, player)
    numGorger = player:GetCollectibleNum(gorger)
    numSpirit = player:GetCollectibleNum(CollectibleType.COLLECTIBLE_SPIRIT_OF_THE_NIGHT)

    if rGorger<numGorger then
        player:AddMaxHearts(2, true)
        rGorger = rGorger + 1 
    end

    if rSpirit<numSpirit then
        AddToTableRuntime(DolItemList, "Gorger", "Common", "List", CollectibleType.COLLECTIBLE_BRIMSTONE)
        rSpirit = rSpirit + 1
    end

    if rSpirit>numSpirit then
        RemoveFromTableRuntime(DolItemList, "Gorger", "Common", "List", CollectibleType.COLLECTIBLE_BRIMSTONE)
        rSpirit = rSpirit - 1
    end

end

function GorgerPostNewLevel(_)
    for i = 1, Game():GetNumPlayers() do
        local player = Isaac.GetPlayer(i)
        if player:HasCollectible(gorger) then

            local multTrinkets = false
            local trinket0
            local trinket1
            
            if player:GetMaxTrinkets() >= 2 then
                trinket0 = player:GetTrinket(0)
                trinket1 = player:GetTrinket(1)
                multTrinkets = true
            else
                trinket0 = player:GetTrinket(0)
            end
            

            if multTrinkets then
                if trinket1 ~= 0 then
                    player:TryRemoveTrinket(trinket1)
                end
                if trinket0 ~= 0 then
                    player:TryRemoveTrinket(trinket0)
                end
            else
                if trinket0 ~= 0 then
                    player:TryRemoveTrinket(trinket0)
                end
            end
            

            for n = 1, player:GetCollectibleNum(gorger) do

                if DolTrinketList["Gorger"]["Default"]["List"] ~= nil then
                    local trin = math.random(1,#DolTrinketList["Gorger"]["Default"]["List"])

                    player:AddTrinket(trin)
                    player:UsePill(PillEffect.PILLEFFECT_GULP, PillColor.NUM_STANDARD_PILLS, UseFlag.USE_NOANNOUNCER)
                    RemoveFromTableRuntime(DolTrinketList, "Gorger", "Default", "List", trin)
                    AddToTableRuntime(DolTrinketList, "Gorger", "Default", "Used", trin)
                else
                    player:AddMaxHearts(2, true)
                end
            end

            if multTrinkets then
                if trinket0 ~= 0 then
                    player:AddTrinket(trinket0, false)
                end
                if trinket1 ~= 0 then
                    player:AddTrinket(trinket1, false)
                end
            else
                if trinket0 ~= 0 then
                    player:AddTrinket(trinket0, false)
                end
            end
            
        end
    end
end

function GorgerPreSpawnCleanAward(_, RNG, SpawnPosition--[[Vector]])
    local room = Game():GetRoom()

    gorgerRNG:SetSeed(Random(), 10)

    if room:GetType() == RoomType.ROOM_BOSS then
        for i = 1, Game():GetNumPlayers() do
            local player = Isaac.GetPlayer(i)

            if player:HasCollectible(gorger) then
                for i = 1, player:GetCollectibleNum(gorger) do
                    local chance = gorgerRNG:RandomFloat()
                    Isaac.Spawn(EntityType.ENTITY_PICKUP, 
                                PickupVariant.PICKUP_COLLECTIBLE, 
                                --It first checks if the Chance is met to give a Legendary Item, if not it checks whether it should grant a "Rare" Item or Common Item and returns a random Item of the Table
                                ternary(chance < LegendaryFoodChance, 
                                        DolItemList["Gorger"]["Legendary"]["List"][math.random(#DolItemList["Gorger"]["Legendary"]["List"])],
                                        ternary(chance < RareFoodChance, 
                                                DolItemList["Gorger"]["Rare"]["List"][math.random(#DolItemList["Gorger"]["Rare"]["List"])],
                                                DolItemList["Gorger"]["Common"]["List"][math.random(#DolItemList["Gorger"]["Common"]["List"])])),
                                room:FindFreePickupSpawnPosition(SpawnPosition, 10, true, false), 
                                Vector(0,0), 
                                player 
                    )
                end
            end
        end
    end
end

function GorgerStatCache(_, player, flag)
    if flag == CacheFlag.CACHE_LUCK and player:HasCollectible(gorger) then
        LegendaryFoodChance = BaseLegendaryFoodChance * math.log(1+math.max(player.Luck, 0))
        RareFoodChance = BaseRareFoodChance * math.log(1+math.max(player.Luck, 0))
    end
end

DoloremMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, GorgerPostPlayer)
DoloremMod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, GorgerPostNewLevel)
DoloremMod:AddCallback(ModCallbacks.MC_PRE_SPAWN_CLEAN_AWARD, GorgerPreSpawnCleanAward)
DoloremMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, GorgerStatCache)
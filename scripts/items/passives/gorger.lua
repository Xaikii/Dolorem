local gorger = Isaac.GetItemIdByName("Gorger")
local r = 0
local numGorger = 0
local p
local onc = 0

function GorgerPostPlayer(_, player)
    numGorger = player:GetCollectibleNum(gorger)

    if r<numGorger then
        player:AddMaxHearts(2, true)
        r = r + 1 
    end

    --p = player
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
                --ToDo: Make the gulped Trinkets unique, so it cant gulp a Trinket it had gulped once with this method. And possibly support Modded Trinkets
                player:AddTrinket(math.random(1,189))
                player:UsePill(PillEffect.PILLEFFECT_GULP, PillColor.NUM_STANDARD_PILLS, UseFlag.USE_NOANNOUNCER)
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

DoloremMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, GorgerPostPlayer)
DoloremMod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, GorgerPostNewLevel)
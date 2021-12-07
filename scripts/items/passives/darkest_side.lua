require("scripts.helper.logi")

local darkestSide = Isaac.GetItemIdByName("Darkest Side")

local blackHearts = 0
local numSide = 0

function DarkestSidePostPlayer(_, player)
    numSide = player:GetCollectibleNum(darkestSide)

    if blackHearts ~= maskToNumber(player:GetBlackHearts(), 2) and player ~= nil then
        blackHearts = maskToNumber(player:GetBlackHearts(), 2)

        DarkestSideUpdateStats(_,player)
    end
end

function DarkestSideStatCache(_, player, flag)
    local numEctoplasm = player:GetCollectibleNum(darkestSide)

    if flag == CacheFlag.CACHE_DAMAGE then
        player.Damage = (player.Damage + 1.6 * numSide) * (1 + 0.1 * numSide * player:GetBlackHearts())
    elseif flag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = 1.0
    end
end

function DarkestSideUpdateStats(_, player)
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SPEED)
    player:EvaluateItems() 
end

DoloremMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, DarkestSidePostPlayer)
DoloremMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, DarkestSideStatCache)
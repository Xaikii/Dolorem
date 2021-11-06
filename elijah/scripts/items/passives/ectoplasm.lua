local ectoplasm = Isaac.GetItemIdByName("Ectoplasm")
local r = 0

function EctoplasmPostPlayer(_, player)
    local numEctoplasm = player:GetCollectibleNum(ectoplasm)

    if r<numEctoplasm then
        player:AddSoulHearts(2)
        player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SPEED | CacheFlag.CACHE_FLYING)
        
        r = r + 1 
    end
end

function EctoplasmStatCache(_, player, flag)
    local numEctoplasm = player:GetCollectibleNum(ectoplasm)

    if flag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + 0.3 * numEctoplasm
    elseif flag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed * (0.8^numEctoplasm)
    elseif flag == CacheFlag.CACHE_FLYING and player:HasCollectible(ectoplasm) then
        player.CanFly = true
    end
end

DoloremMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, EctoplasmPostPlayer)
DoloremMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, EctoplasmStatCache)
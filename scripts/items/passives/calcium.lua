require("scripts.helper.logi")

local calcium = Isaac.GetItemIdByName("Calcium")

local boneHearts = 0
local numCalcium = 0
local rCalcium =0
local calciumRNG = RNG()
local chanceTear = 0
local numCompoundFracture = 0
local rCompoundFracture = 0
local numMilk = 0
local rMilk = 0

function CalciumPostPlayer(_, player)
    numCalcium = player:GetCollectibleNum(calcium)
    numCompoundFracture = player:GetCollectibleNum(Isaac.GetItemIdByName("Compound Fracture"))

    if boneHearts ~= maskToNumber(player:GetBoneHearts(), 2) and player ~= nil then
        boneHearts = maskToNumber(player:GetBoneHearts(), 2)

        CalciumUpdateStats(_,player)
    end

    if rCalcium<numCalcium then
        player:AddBoneHearts(1)
        CalciumUpdateStats(_, player)
        
        rCalcium = rCalcium + 1 
    end

    if rCompoundFracture<numCompoundFracture then
        player:AddBoneHearts(1)
        CalciumUpdateStats(_, player)
        
        rCompoundFracture = rCompoundFracture + 1 
    end

    if rMilk<numMilk then
        player:AddBoneHearts(2)
        CalciumUpdateStats(_, player)
        
        rMilk = rMilk + 1 
    end
end

function CalciumPostTearInit(tear, variant)

    calciumRNG:SetSeed(Random(), 1)
    calciumRNG:RandomFloat()
    if calciumRNG:RandomFloat() <= chanceTear then
        variant = TearVariant.BONE
        tear.BaseDamage = (tear.BaseDamage + 1.5) * (1*math.sqrt(numCompoundFracture))
    end
end

function CalciumStatCache(_, player, flag)
    local numCalcium = player:GetCollectibleNum(calcium)

    if flag == CacheFlag.CACHE_DAMAGE then
        player.Damage = player.Damage + 0.5 * boneHearts
    elseif flag == CacheFlag.CACHE_SPEED then
        player.MoveSpeed = player.MoveSpeed + 0.1 * boneHearts
    end
end

function CalciumUpdateStats(_, player)
    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SPEED)
    player:EvaluateItems() 
    chanceTear = (1-0.9183^(boneHearts*numCalcium))
end

DoloremMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, CalciumPostPlayer)
DoloremMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CalciumStatCache)
DoloremMod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, CalciumPostTearInit)
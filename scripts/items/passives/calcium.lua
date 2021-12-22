require("scripts.helper.logi")

local calcium = Isaac.GetItemIdByName("Calcium")

local boneHearts = 0
local numCalcium = 0
local rCalcium = 0
local calciumRNG = RNG()
local chanceTear = 0
local numCompoundFracture = 0
local rCompoundFracture = 0
local numMilk = 0
local rMilk = 0

function CalciumPostPlayer(_, player)
    numCalcium = player:GetCollectibleNum(calcium)
    numCompoundFracture = player:GetCollectibleNum(Isaac.GetItemIdByName("Compound Fracture"))
    numMilk = player:GetCollectibleNum(Isaac.GetItemIdByName("Milk!"))

    if boneHearts ~= maskToNumber(player:GetBoneHearts(), 2) and player ~= nil then
        boneHearts = maskToNumber(player:GetBoneHearts(), 2)

        CalciumUpdateStats(_,player)
    end

    if rCalcium<numCalcium then
        calciumRNG:SetSeed(Random(), 10)
        player:AddBoneHearts(1)
        CalciumUpdateStats(_, player)
        
        rCalcium = rCalcium + 1 
    end

    if rCompoundFracture<numCompoundFracture and player:HasCollectible(calcium) then
        player:AddBoneHearts(1)
        CalciumUpdateStats(_, player)
        
        rCompoundFracture = rCompoundFracture + 1 
    end

    if rMilk<numMilk and player:HasCollectible(calcium) then
        player:AddBoneHearts(2)
        CalciumUpdateStats(_, player)
        
        rMilk = rMilk + 1 
    end
end

function CalciumPostTearInit(_, tears, variant)

    if EntityRef(tears).Entity.SpawnerType == EntityType.ENTITY_PLAYER then
        local tear = tears:ToTear()

        if tear ~= nil and calciumRNG:RandomFloat() <= chanceTear then

            tear:ChangeVariant(TearVariant.BONE)
            tear:AddTearFlags(TearFlags.TEAR_PERSISTENT)
        end

    end
end

function CalciumPostTearUpdate(_, tears, variant)

    if tears.FrameCount == 1 and tears.Variant == TearVariant.BONE and tears.SpawnerEntity:ToPlayer():HasCollectible(calcium) then
        tears.CollisionDamage = tears.CollisionDamage * (1+math.sqrt(numCalcium))
    end
end

function CalciumStatCache(_, player, flag)
    local numCalcium = player:GetCollectibleNum(calcium)

    if flag == CacheFlag.CACHE_DAMAGE and player:HasCollectible(calcium) then
        player.Damage = player.Damage + 0.5 * boneHearts
        if WeaponType.WEAPON_BONE and player:GetActiveWeaponEntity() ~= nil then
            player.Damage = player.Damage * (4/3)
        end
    elseif flag == CacheFlag.CACHE_SPEED and player:HasCollectible(calcium) then
        player.MoveSpeed = player.MoveSpeed + 0.1 * boneHearts
    end
end

function CalciumUpdateStats(_, player)
    numCalcium = player:GetCollectibleNum(calcium)
    numCompoundFracture = player:GetCollectibleNum(Isaac.GetItemIdByName("Compound Fracture"))
    numMilk = player:GetCollectibleNum(Isaac.GetItemIdByName("Milk!"))

    player:AddCacheFlags(CacheFlag.CACHE_DAMAGE | CacheFlag.CACHE_SPEED)
    player:EvaluateItems() 
    chanceTear = (1-0.8731^math.sqrt(boneHearts*numCalcium+(numCalcium*math.max(player.Luck,0))))

end

DoloremMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, CalciumPostPlayer)
DoloremMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, CalciumStatCache)
DoloremMod:AddCallback(ModCallbacks.MC_POST_TEAR_INIT, CalciumPostTearInit)
DoloremMod:AddCallback(ModCallbacks.MC_POST_TEAR_UPDATE, CalciumPostTearUpdate)
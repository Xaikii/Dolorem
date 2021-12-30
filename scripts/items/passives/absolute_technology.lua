require('scripts.helper.roomHelper')
require('scripts.helper.logi')

local abTech = Isaac.GetItemIdByName("Absolute Technology")
local rAbTech = 0
local numAbTech
local laser
local laserRadius = 65.0
local consumeChance = 0.25
local AbTechRNG = RNG()
AbTechRNG:SetSeed(Random(), 10)

function AbTechPostPlayer(_, player)
    numAbTech = player:GetCollectibleNum(abTech)

    laser.Position = player.Position

    for index, value in ipairs(RoomEntities["EnemyTears"]) do
        local wasConsumed = false

        if player.Position:Distance(value.Position) < laserRadius and value:GetData()["DolAbTechState1"] ~= "Done" then
            local ent = GetClosestEnemy(player)

            value:GetData()["DolAbTechState1"] = "Done"

            if AbTechRNG:RandomFloat() < consumeChance and value:GetData()["DolAbTechState2"] ~= "Done" then
                value:Die()
                wasConsumed = true
                value:GetData()["DolAbTechState2"] = "Done"
            end

            local reacLaser = EntityLaser.ShootAngle(2, player.Position, (ent.Position-player.Position):Normalized():GetAngleDegrees(), 1, Vector(0,0), player)
            reacLaser.CollisionDamage = (1 + (((8+math.max(player.Luck,0))/100)*player.Damage)) * (1+ bool_To_Number(wasConsumed)) --Still to add: number of Technology Items added
        end
    end

    if rAbTech<numAbTech then
        rAbTech = rAbTech + 1 
    end


end

function AbTechStatCache(_, player, flag)
    numAbTech = player:GetCollectibleNum(abTech)

end

function AbTechNewRoom()
    --AbTechRNG:SetSeed(Random(), 10)
    for i = 1, Game():GetNumPlayers() do
        local player = Isaac.GetPlayer(i)

        laser = player:FireTechLaser(player.Position, 0, Vector(0,1), true, true, player, 1)
        laser.CollisionDamage = 0.21 + (((8+math.max(player.Luck,0))/100)*player.Damage)
        laser:SetTimeout(100000)
        laser.SubType = 3
        laser.Variant = 10
        laser.Radius = laserRadius
    end
end


DoloremMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, AbTechPostPlayer)
DoloremMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, AbTechStatCache)
DoloremMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, AbTechNewRoom)
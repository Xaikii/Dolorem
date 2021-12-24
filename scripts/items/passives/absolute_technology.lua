local abTech = Isaac.GetItemIdByName("Absolute Technology")
local rAbTech = 0
local numAbTech
local laser

function AbTechPostPlayer(_, player)
    numAbTech = player:GetCollectibleNum(abTech)

    laser.Position = player.Position
    --laser = player:FireTechXLaser(player.Position, Vector(0,0), 100.0, player, 1)
    --laser.DisableFollowParent = false
    --laser.Timeout = 20

    if rAbTech<numAbTech then
        rAbTech = rAbTech + 1 
    end


end

function AbTechStatCache(_, player, flag)
    numAbTech = player:GetCollectibleNum(abTech)

end

function AbTechNewRoom()
    for i = 1, Game():GetNumPlayers() do
        local player = Isaac.GetPlayer(i)

        --laser = player:FireTechXLaser(player.Position, Vector(0,0), 100, player, 1)
        laser = player:FireTechLaser(player.Position, 0, Vector(0,1), true, true, player, 0)
        laser:SetTimeout(10000)
        laser.SubType = 3
        laser.Variant = 10
        --laser.Position = player.Position
        --laser.Variant = 5
        --laser:SetOneHit(true)
        --laser.SampleLaser = true
        --laser.OneHit = true
    end
end

function AbTechCollision(_, tear, collider, low--[[bool]])
    if collider.Type == EntityType.ENTITY_TEAR and EntyityRef(collider).Entity.SpawnerType ~= EntityType.ENTITY_PLAYER  then
        
    end
end

DoloremMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, AbTechPostPlayer)
DoloremMod:AddCallback(ModCallbacks.MC_EVALUATE_CACHE, AbTechStatCache)
DoloremMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, AbTechNewRoom)
DoloremMod:AddCallback(ModCallbacks.MC_PRE_TEAR_COLLISION, AbTechCollision)
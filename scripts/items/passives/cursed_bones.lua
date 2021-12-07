require("scripts.helper.roomHelper")
require("scripts.helper.functionHelper")

local cursedBones = Isaac.GetItemIdByName("Cursed Bones")

local r = 0
local cachedBoneHearts = 200

function CursedBonesPostPlayer(_, player)
    local numCursedBones = player:GetCollectibleNum(cursedBones)

    if numCursedBones >=1 then
        if cachedBoneHearts > player:GetBoneHearts() and cachedBoneHearts ~= 200 then
            cachedBoneHearts = player:GetBoneHearts()
            SpawnPickup(
                PickupVariant.PICKUP_HEART, 
                HeartSubType.HEART_BLACK, 
                true, 
                Vector(0,0), 
                player,
                Game():GetRoom()
            )
        else 
            cachedBoneHearts = player:GetBoneHearts()
        end
    end

    if r<numCursedBones then
        CursedBonesRemoveSpikesGrid()

        r = r + 1
    end
end

function CursedBonesRemoveHealthOnFloor(_)
    for i=0, Game():GetNumPlayers() do
        local player = Isaac.GetPlayer(i)

        if (player:GetMaxHearts()/2) > 1 and player:HasCollectible(cursedBones) then
            player:AddMaxHearts(-1, true)
        end
        --r = 0
    end
end

function CursedBonesRemoveSpikesGrid(_)
    local room = Game():GetRoom()
    local roomShape = room:GetRoomShape()

    for i=0, Game():GetNumPlayers() do
        local player = Isaac.GetPlayer(i)

        if player:HasCollectible(cursedBones) then
            for i=0, GetPossibleGrindIndiciesFromRoom(roomShape) do
        
                local gridE = room:GetGridEntity(i)
        
                if gridE ~= nil then
                    if gridE:GetType() == GridEntityType.GRID_ROCK_SPIKED then
                        gridE.State = 4
                    elseif gridE:ToDoor() ~= nil then
                        if gridE:ToDoor().TargetRoomType == RoomType.ROOM_CURSE or 
                        gridE:ToDoor().CurrentRoomType == RoomType.ROOM_CURSE then
                            gridE.VarData = 1
                        end
                    elseif gridE:ToSpikes() ~= nil then
                        if gridE:GetType() == GridEntityType.GRID_SPIKES and
                        room:GetType() ~= RoomType.ROOM_SACRIFICE then
                            gridE.State = 1
                            gridE:GetSprite():Play("Unsummon", true)
                        elseif gridE:GetType() == GridEntityType.GRID_SPIKES_ONOFF then
                            gridE.State = 1
                            gridE:ToSpikes().Timeout = 2147483646
                            gridE:GetSprite():Play("Unsummon", true)
                        end 
                    end
                end
            end
        end
    end
end

DoloremMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, CursedBonesPostPlayer)
DoloremMod:AddCallback(ModCallbacks.MC_POST_NEW_LEVEL, CursedBonesRemoveHealthOnFloor)
DoloremMod:AddCallback(ModCallbacks.MC_POST_NEW_ROOM, CursedBonesRemoveSpikesGrid)
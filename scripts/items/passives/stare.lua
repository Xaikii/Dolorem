require("scripts.helper.logi")

local stare = Isaac.GetItemIdByName("Stare")

local numStare = 0
local angleComparison = 22.5
local distanceBase = 22.72
local i = 0
local r = 0

function StarePostPlayer(_, player)
    numStare = player:GetCollectibleNum(stare)

    if r<numStare then
        angleComparison = math.min(angleComparison + 2.5, 45)

        r = r + 1
    end

    if numStare >=1 then

        local enemies = Isaac.GetRoomEntities()
        for _, entity in ipairs(enemies) do
            if entity.Type ~= EntityType.ENTITY_PLAYER and entity:IsVulnerableEnemy() then
                local dist = player.Position:Distance(entity.Position) --returns a float


                if dist < (player.TearRange*0.8) then

                    local vecDirection = entity.Position - player.Position
                    local direction = vecDirection:GetAngleDegrees()
                    local ang = angleComp(directionToVectorAngle(player:GetHeadDirection(), player), direction)
                
                    if ang < angleComparison then

                        if i >= math.min(math.max(player.MaxFireDelay, ternary(player.MaxFireDelay <= 1.75, 1, 2)), 8) then
                            entity:TakeDamage(player.Damage*(1-0.915^numStare), DamageFlag.DAMAGE_DEVIL, EntityRef(player), 2)
                            i = 0
                        else
                            entity:AddSlowing(EntityRef(player), 6, 1-0.86^numStare, Color(1,1,1,0.2,0,0,0))
                            i = i + 1
                        end
                    end
                end
            end
        end
    end
end

DoloremMod:AddCallback(ModCallbacks.MC_POST_PLAYER_UPDATE, StarePostPlayer)
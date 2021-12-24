DoloremMod = RegisterMod("Dolorem", 1)

require('scripts.helper.enumFil')

require('scripts.items.passives.ectoplasm')
require('scripts.items.passives.stare')
require('scripts.items.passives.demonic_resolve')
require('scripts.items.passives.cursed_bones')
require('scripts.items.passives.darkest_side')
require('scripts.items.passives.calcium')
require('scripts.items.passives.gorger')
require('scripts.items.passives.absolute_technology')

--Gorger
AddToTable(DolItemList, "Gorger", "Common", "ToAdd", CollectibleType.COLLECTIBLE_BREAKFAST)
AddToTable(DolItemList, "Gorger", "Common", "ToAdd", CollectibleType.COLLECTIBLE_DESSERT)
AddToTable(DolItemList, "Gorger", "Common", "ToAdd", CollectibleType.COLLECTIBLE_DINNER)
AddToTable(DolItemList, "Gorger", "Common", "ToAdd", CollectibleType.COLLECTIBLE_LUNCH)
AddToTable(DolItemList, "Gorger", "Common", "ToAdd", CollectibleType.COLLECTIBLE_MIDNIGHT_SNACK)
AddToTable(DolItemList, "Gorger", "Common", "ToAdd", CollectibleType.COLLECTIBLE_ROTTEN_MEAT)
AddToTable(DolItemList, "Gorger", "Common", "ToAdd", CollectibleType.COLLECTIBLE_SNACK)
AddToTable(DolItemList, "Gorger", "Common", "ToAdd", CollectibleType.COLLECTIBLE_SUPPER)

AddToTable(DolItemList, "Gorger", "Rare", "ToAdd", CollectibleType.COLLECTIBLE_MEAT)
AddToTable(DolItemList, "Gorger", "Rare", "ToAdd", CollectibleType.COLLECTIBLE_STEM_CELLS)

AddToTable(DolItemList, "Gorger", "Legendary", "ToAdd", CollectibleType.COLLECTIBLE_MAGIC_MUSHROOM)
AddToTable(DolItemList, "Gorger", "Legendary", "ToAdd", CollectibleType.COLLECTIBLE_ODD_MUSHROOM_LARGE)

for i = 1, Isaac.GetItemConfig():GetTrinkets().Size do
    AddToTable(DolTrinketList, "Gorger", "Default", "ToAdd", i)
end


function DoloremGameStart()
    --Gorger
    InitTable(DolItemList, "Gorger", "Common", "List", "ToAdd")
    InitTable(DolItemList, "Gorger", "Rare", "List", "ToAdd")
    InitTable(DolItemList, "Gorger", "Legendary", "List", "ToAdd")

    InitTable(DolTrinketList, "Gorger", "Default", "List", "ToAdd")

    
end

DoloremMod:AddCallback(ModCallbacks.MC_POST_GAME_STARTED, DoloremGameStart)

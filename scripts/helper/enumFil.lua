require("scripts.helper.logi")
--[[

        This File is currently is not used, and might be deleted
]]

--[[
DLTrinket = {
    
}

DLCollectibleItem = {
    
}

DLConsumablePill = {
    
}

DLConsumableCard = {
    
}]]

DolItemList={
    Gorger={
        Common={
            List={},
            ToAdd={}
        },
        Rare={
            List={},
            ToAdd={}
        },
        Legendary={
            List={},
            ToAdd={}
        }
    },
    BlackJackBeggar={
        Common={
            List={},
            ToAdd={}
        },
        Rare={
            List={},
            ToAdd={}
        },
        Legendary={
            List={},
            ToAdd={}
        }
    }
}

DolTrinketList={
    Gorger={
        Default={
            List={},
            ToAdd={},
            Used={}
        }
    }
}

function AddToTable(Table, nest1, nest2, nest3, object)--You want to use this, to add Items to the list regardless of state of run, aka. always in the pool(unless removed runtime)
    --table is with initial uppercase as lowercase is reserved
    table.insert(Table[nest1][nest2][nest3], object)
end

function InitTable(Table, nest1, nest2, nestTarget, nestHome)--Adds all entries of the Buffer to the tables, run in main file
    
    --if Table[item][rarity]["List"] ~= nil then
        clearTable(Table[nest1][nest2][nestTarget])
    --end
    for i = 1, #Table[nest1][nest2][nestHome] do
        Table[nest1][nest2][nestTarget][i] = Table[nest1][nest2][nestHome][i]
    end
end

function AddToTableRuntime(Table, nest1, nest2, nest3, object)--You want to use this, to add Items to the list for this run
    local index = #Table[nest1][nest2][nest3] 
    Table[nest1][nest2][nest3][(index+1)] = object
end

function RemoveFromTableRuntime(Table, nest1, nest2, nest3, object)--You want to use this, to remove Items from the List for this run
    for index, value in ipairs(Table[nest1][nest2][nest3]) do
        if value == object then
            table.remove(Table[nest1][nest2][nest3], index)
        end
    end
end
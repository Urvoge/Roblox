--> Variables
local Settings = {
    
    ['EncryptionKey'] = 'XOXDS5Y39',

    ['RotateProxies'] = false,
    ['RotationInterval'] = 2, --> Rotates every x deposits

    ['ClearWorldHistory'] = true,

    ['RandomWorlds'] = {
        'EPHWN', 'BUYIFA', 'PENDUDUK', 'KP2Z'
    },

    ['StashWorlds'] = {
        ['JYGZ20ESX'] = {
            ['StashPosition'] = {X = 65, Y = 19}
        }
    },

    ['Accounts'] = {
        ['TEOHOOKSUCKS15'] = {
            ['Password'] = 'Sten2003!',
            ['OwnedWorlds'] = {'UZR04CWHW'},
        
            ['Busy'] = false,
        }
    },

    ['Proxies'] = {
        '38.154.227.167',
        '185.199.229.156',
        '185.199.228.220',
        '185.199.231.45',
        '188.74.210.207',
        '188.74.183.10',
        '188.74.210.21',
        '45.155.68.129',
        '154.95.36.199',
        '45.94.47.66'
    },

    ['AcceptedItems'] = {
        [242] = 1, --> World Lock
        [1796] = 100, --> Diamond Lock
        [7188] = 20000, --> Blue Gem Lock
    }

}

--> Functions
function encrypt(data, key)
    local encrypted = {}
    for i = 1, #data do
        local charCode = data:byte(i) ~ key:byte((i - 1) % #key + 1)
        -- Keep the result within the range of alphanumeric characters (ASCII 48-122)
        charCode = (charCode % 75) + 48
        if charCode > 90 then
            charCode = charCode + 6
        end
        table.insert(encrypted, string.char(charCode))
    end
    return table.concat(encrypted)
end

function table.find(Table, WantedValue)
    for Index, Value in ipairs(Table) do
        if Value == WantedValue then
            return Index
        end

        return 
    end
end

function SafeFindPath(Bot, X, Y)
    if (Bot:findPath(X, Y)) then
        repeat sleep(25) until (Bot.x == X) and (Bot.y == Y)

        return true;
    end

    return false;
end

function GetAccount()
    local AccountNames = {}

    for AccountName, _ in pairs(Settings.Accounts) do
        table.insert(AccountNames, AccountName)
    end

    return AccountNames[math.random(#AccountNames)]
end

function GetStashWorld()
    local StashWorlds = {}

    for StashWorld, _ in pairs(Settings.StashWorlds) do
        table.insert(StashWorlds, StashWorld)
    end

    return StashWorlds[math.random(#StashWorlds)]
end

function SafeWarp(Bot, World, RetryCount)
    Bot:warp(World)

    sleep(1000)
    if not Bot:isInWorld(World) then print('failed warp, retrying') sleep(2000) SafeWarp(Bot, World) end
end

function StartDeposit(GrowID, UserID) --> GrowID username, Discord UserID (used for seed)
    --> Bunch of dumbass variables
    local AccountName = GetAccount()
    local StashWorldName = GetStashWorld()
    local Proxy = Settings.Proxies[math.random(#Settings.Proxies)]

    local AccountInfo = Settings.Accounts[AccountName]

    local ErrorCode = encrypt((AccountName and 'true' or 'false') .. (StashWorldName and 'true' or 'false') .. (Proxy and 'true' or 'false'), Settings.EncryptionKey)

    --> Check if bots busy (duh nigga)
    if AccountInfo.Busy then return StartDeposit(GrowID, UserID) end

    if AccountName and StashWorldName and Proxy then
        --> Set bot busy, so no depositing two people at time ya know, no ban cuh fr
        Settings.Accounts[AccountName].Busy = true

        --> More dumbass variables
        local Bot = getBot(AccountName)
        local StashWorld = Settings.StashWorlds[StashWorldName]

        --> Initiate this mf
        SafeWarp(Bot, AccountInfo.OwnedWorlds[1])

        print(AccountName, AccountInfo.OwnedWorlds[1])

        addEvent(Event.variantlist, function(Variant)
            if Variant:get(0):getString() == 'OnTalkBubble' and Variant:get(2):getString():match('`5<`w(.+)`` entered') then
                local Username = Variant:get(2):getString():match('`5<`w(.+)`` entered')
                print('jhit joined')
                
                --> mf connected cuh, lets start ts fr
                if Username == GrowID then
                    print('jhit the right nigga')

                    local Inventory = Bot:getInventory()
                    local LastCount = #Inventory.items
                    local TotalCount = 0

                    repeat
                        Bot:collect(2, 2)
                        sleep(math.random(1238, 1764))
                    until #Inventory.items > LastCount

                    --> Stash the mfs wls jhit
                    sleep(2000)

                    SafeWarp(Bot, StashWorldName)
                    sleep(2000)
                    SafeFindPath(Bot, StashWorld.StashPosition.X, StashWorld.StashPosition.Y)

                    for _, Item in pairs(Inventory.items) do
                        local Value = Settings.AcceptedItems[Item.id] or 0

                        TotalCount = TotalCount + (Value * Item.count)
                        if Value >= 1 then
                            Bot:drop(Item.id, Item.count)

                            sleep(200)
                        end
                    end

                    --> Finish task duh
                    print('Succesfully stashed wls')
                    Settings.Accounts[AccountName].Busy = false

                    return true, encrypt(AccountName .. ' - ' .. StashWorldName .. ' - ' .. Proxy .. ' - ' .. GrowID .. ' - ' .. UserID .. ' - ' .. TotalCount, Settings.EncryptionKey)
                else
                    sleep(math.random(346, 532))
                    Bot:say('/ban ' .. Username)
                end
            end
        end)

        listenEvents(30)
    else
        return false, 'Failed to start deposit, Error: ' .. ErrorCode
    end
end

StartDeposit('Refooh', 'Urvoge')

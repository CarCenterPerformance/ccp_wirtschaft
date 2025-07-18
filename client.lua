local ESX = exports['es_extended']:getSharedObject()

local createdPeds = {}

CreateThread(function()
    for _, seller in pairs(Config.Sellers) do
        -- Blip setzen
        if seller.blip then
            local blip = AddBlipForCoord(seller.coords)
            SetBlipSprite(blip, seller.blipId)
            SetBlipScale(blip, 0.8)
            SetBlipColour(blip, 2)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(seller.label)
            EndTextCommandSetBlipName(blip)
        end

        -- NPC laden und platzieren
        if seller.pedModel then
            local model = seller.pedModel
            RequestModel(model)
            while not HasModelLoaded(model) do Wait(10) end

            local ped = CreatePed(0, model, seller.coords.x, seller.coords.y, seller.coords.z - 1.0, seller.heading or 0.0, false, true)
            SetEntityInvincible(ped, true)
            FreezeEntityPosition(ped, true)
            SetBlockingOfNonTemporaryEvents(ped, true)

            if seller.pedScenario then
                TaskStartScenarioInPlace(ped, seller.pedScenario, 0, true)
            end

            table.insert(createdPeds, ped)
        end
    end
end)


CreateThread(function()
    local shown = false
    local currentSeller = nil

    while true do
        Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())
        local inRange = false

        for i, seller in pairs(Config.Sellers) do
            local dist = #(playerCoords - seller.coords)

            if dist < 2.0 then
                if not shown then
                    lib.showTextUI('[E] ' .. seller.label)
                    shown = true
                    currentSeller = i
                end

                inRange = true

                if IsControlJustReleased(0, 38) then
                    print("E gedrückt – öffne Menü für Verkäufer:", seller.label)
                    openSellMenu(currentSeller) -- <- DAS ist entscheidend
                end
            end
        end

        if not inRange and shown then
            lib.hideTextUI()
            shown = false
            currentSeller = nil
        end
    end
end)


function openSellMenu(sellerIndex)
    print("openSellMenu() wird aufgerufen für Index:", sellerIndex)

    -- Frage aktuelle Preise vom Server ab
    lib.callback('dynamic_market:getSellerData', false, function(seller)
        if not seller then
            print("Fehler: Verkäuferdaten nicht erhalten")
            return
        end

        local options = {}

        for itemName, itemData in pairs(seller.items) do
            table.insert(options, {
                title = ("%s - $%d"):format(itemData.label, itemData.price),
                icon = 'dollar-sign',
                description = 'Verkaufe dieses Item',
                onSelect = function()
                    local input = lib.inputDialog('Verkauf: ' .. itemData.label, {
                        {
                            type = 'number',
                            label = 'Menge',
                            min = 1,
                            required = true
                        }
                    })

                    if input and input[1] then
                        TriggerServerEvent("dynamic_market:sellItem", sellerIndex, itemName, tonumber(input[1]))
                    end
                end
            })
        end

        lib.registerContext({
            id = 'seller_menu_' .. sellerIndex,
            title = seller.label,
            options = options
        })

        lib.showContext('seller_menu_' .. sellerIndex)
    end, sellerIndex)
end


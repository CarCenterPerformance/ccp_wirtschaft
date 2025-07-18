ESX = exports["es_extended"]:getSharedObject()

-- Speichert Verkäufe, die noch nicht in Preisänderungen umgesetzt wurden
local PendingSales = {}

-- Verkaufshandler
RegisterServerEvent("dynamic_market:sellItem")
AddEventHandler("dynamic_market:sellItem", function(sellerIndex, itemName, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local seller = Config.Sellers[sellerIndex]
    if not xPlayer or not seller then return end

    local itemData = seller.items[itemName]
    if not itemData then return end

    local playerItem = xPlayer.getInventoryItem(itemName)
    if playerItem.count < amount then
        TriggerClientEvent('ox_lib:notify', source, {
            type = 'error',
            title = 'Verkauf',
            description = 'Du hast nicht genug von diesem Item.',
            duration = 3000
        })
        return
    end

    -- Item verkaufen
    local price = itemData.price * amount
    xPlayer.removeInventoryItem(itemName, amount)
    xPlayer.addAccountMoney('money', price)

    TriggerClientEvent('ox_lib:notify', source, {
        type = 'success',
        title = 'Verkauft',
        description = ('Du hast %dx %s für $%d verkauft'):format(amount, itemData.label, price),
        duration = 4000
    })

    -- Verkauf für spätere Preisänderung speichern
    PendingSales[sellerIndex] = PendingSales[sellerIndex] or {}
    PendingSales[sellerIndex][itemName] = (PendingSales[sellerIndex][itemName] or 0) + amount
end)

-- Preisänderung basierend auf gesammelten Verkäufen
local function PeriodicPriceUpdate()
    for sellerIndex, itemSales in pairs(PendingSales) do
        local seller = Config.Sellers[sellerIndex]
        if seller then
            for itemName, soldAmount in pairs(itemSales) do
                local itemData = seller.items[itemName]
                if itemData then
                    -- Preis senken
                    local dropPercent = itemData.dropPercent or 5
                    local newPrice = math.floor(itemData.price * (1 - (dropPercent / 100)))
                    itemData.price = math.max(itemData.minPrice or 1, newPrice)

                    -- Boost Item erhöhen
                    local boostItem = itemData.boostItem
                    if boostItem and seller.items[boostItem] then
                        local boostData = seller.items[boostItem]
                        local boostPercent = itemData.boostPercent or 5
                        local boostedPrice = math.floor(boostData.price * (1 + (boostPercent / 100)))
                        boostData.price = math.min(boostedPrice, boostData.maxPrice or 9999)
                    end

                    print(("[Dynamic Market] Preisänderung nach Verkauf: %s -> $%d | Boost: %s -> $%d"):format(
                        itemName, itemData.price,
                        boostItem or "-", boostItem and seller.items[boostItem].price or 0
                    ))
                end
            end
        end
    end

    -- Verkäufe zurücksetzen
    PendingSales = {}

    print("[Dynamic Market] Alle gesammelten Verkäufe wurden verarbeitet.")
end

-- Timer für periodische Preisaktualisierung
local refreshMinutes = 1 -- hier einstellbar, z.B. alle 1 Minuten
CreateThread(function()
    while true do
        Wait(refreshMinutes * 60000)
        PeriodicPriceUpdate()
    end
end)

-- Callback für Client zum Abruf der aktuellen Preise
lib.callback.register('dynamic_market:getSellerData', function(source, sellerIndex)
    return Config.Sellers[sellerIndex]
end)

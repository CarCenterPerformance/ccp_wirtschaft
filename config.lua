Config = {}


-- Verkäufer-Konfiguration
Config.Sellers = {
    {
        label = "Rohstoffhandel",
        coords = vector3(-787.9098, -599.5444, 30.2763),
        heading = 340.8057,
        pedModel = "a_m_m_business_01", -- PED-Modell
        pedScenario = "WORLD_HUMAN_CLIPBOARD", -- Animation
        blip = true,
        blipId = 237,
        items = {
            eisenbarren = {
                label = "Eisenbarren",
                price = 250,
                minPrice = 150,
                maxPrice = 385,
                dropPercent = 9,   -- Preis sinkt um 9%
                boostItem = "kupferbarren",
                boostPercent = 11  -- boostItem steigt um 1%
            },
            kupferbarren = {
                label = "Kupferbarren",
                price = 250,
                minPrice = 130,
                maxPrice = 310,
                dropPercent = 9,
                boostItem = "eisenbarren",
                boostPercent = 11
            },
             aluminium = {
                label = "Aluminium",
                price = 150,
                minPrice = 90,
                maxPrice = 295,
                dropPercent = 9,
                boostItem = "silberbarren",
                boostPercent = 11
            },
             silberbarren = {
                label = "Silberbarren",
                price = 200,
                minPrice = 50,
                maxPrice = 285,
                dropPercent = 9,
                boostItem = "aluminium",
                boostPercent = 11
            },
              raffoil = {
                label = "Raffinirtes Öl",
                price = 250,
                minPrice = 130,
                maxPrice = 390,
                dropPercent = 9,
                boostItem = "stahl",
                boostPercent = 11
            },
                 stahl = {
                label = "Stahl",
                price = 350,
                minPrice = 150,
                maxPrice = 560,
                dropPercent = 9,
                boostItem = "raffoil",
                boostPercent = 11
            }
        }
    },
        {
        label = "Drogen Händler",
        coords = vector3(171.6498, 394.6973, 109.4836),
        heading = 258.6599,
        pedModel = "a_m_m_business_01", -- PED-Modell
        pedScenario = "WORLD_HUMAN_CLIPBOARD", -- Animation
        blip = false,
        blipId = 52,
        items = {
            cannabis = {
                label = "Cannabis",
                price = 250,
                minPrice = 80,
                maxPrice = 2500,
                dropPercent = 13,   -- Preis sinkt um 13%
                boostItem = "kokain",
                boostPercent = 100   -- boostItem steigt um 100%
            },
            kokain = {
                label = "Kokain",
                price = 500,
                minPrice = 120,
                maxPrice = 6000,
                dropPercent = 13,
                boostItem = "cannabis",
                boostPercent = 100
            }
        }
    }
}
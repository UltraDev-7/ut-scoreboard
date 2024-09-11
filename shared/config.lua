Config = Config or {
    Core = "qb-core", -- اسم الكور حقك
    OpenKey = 'Home', -- https://docs.fivem.net/docs/game-references/input-mapper-parameter-ids/keyboard/
    CurrentCops = 0,
    CurrentAmbulance = 0,
    ShowIDforALL = true,
    MaxPlayers = GetConvarInt('sv_maxclients', 64),
    IllegalActions = {
        storerobbery = { -- سرقه بقالة
            minimum = 3,
            busy = true,
        },
        houserobbery = { -- سرقه منزل
            minimum = 4,
            busy = false,
        },
        atmrobbery = { -- سرقه صرافه
            minimum = 5,
            busy = false,
        },
        banktruck = { -- سرقه شاحنة بنك
            minimum = 6,
            busy = false,
        },
        fleecarobbery = { -- سرقه بنك فليكا
            minimum = 7,
            busy = false,
        },
        bobcatrobbery = { -- سرقه بوبكات
            minimum = 8,
            busy = false,
        },
        jewelleryrobbery = { -- سرقه محل المجوهرات
            minimum = 8,
            busy = false,
        },
        artgalleryrobbery = { -- سرقه معرض الفنون
            minimum = 9,
            busy = false,
        },
        politorobbery = { -- سرقه بنك بوليتو
            minimum = 10,
            busy = false,
        },
        pacificrobbery = { -- سرقه البنك المركزي
            minimum = 11,
            busy = false,
        },
        robcitz = { -- خطف مواطن
            minimum = 5,
            busy = false,
        },
        policerob = { -- خطف عسكري
            minimum = 7,
            busy = false,
        },
    },
}
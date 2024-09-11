local QBCore = exports[Config.Core]:GetCoreObject()
local scoreboardOpen = false
local PlayerOptin = {}
local Totalm = 0
local Totalh = 0
local Totalt = 0

-- Functions

local function DrawText3D(x, y, z, text, textColor)
    local color = { r = 220, g = 220, b = 220, alpha = 255 } 
    if textColor ~= nil then 
        color = {r = textColor[1] or 22, g = textColor[2] or 55, b = textColor[3] or 155, alpha = textColor[4] or 255}
    end

    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    local dist = #(vector3(px,py,pz) - vector3(x,y,z))

    local scale = (1/dist)*2
    local fov = (1/GetGameplayCamFov())*100
    local scale = scale*fov
    
    if onScreen then
        SetTextScale(0.0*scale, 0.75*scale)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(color.r, color.g, color.b, color.alpha)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry("STRING")
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(_x,_y)
    end
end

local function GetPlayers()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            players[#players+1] = player
        end
    end
    return players
end

local function GetPlayersFromCoords(coords, distance)
    local players = GetPlayers()
    local closePlayers = {}

    if coords == nil then
		coords = GetEntityCoords(PlayerPedId())
    end
    if distance == nil then
        distance = 5.0
    end
    for _, player in pairs(players) do
		local target = GetPlayerPed(player)
		local targetCoords = GetEntityCoords(target)
		local targetdistance = #(targetCoords - vector3(coords.x, coords.y, coords.z))
		if targetdistance <= distance then
            closePlayers[#closePlayers+1] = player
		end
    end

    return closePlayers
end

Citizen.CreateThread(function()
  
    while true do
       
        Citizen.Wait(60000)
        -- Citizen.Wait(100)

        if Totalm < 61 then 
            Totalm = Totalm + 1
        else 
            Totalm = 0 
            Totalh = Totalh + 1
        end 
              
    end 
end)

function PlayTime()
    Totalt = Totalh.."h".."/"..Totalm.."m"
    return Totalt
end

-- Events

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.TriggerCallback('ut-scoreboard:server:GetConfig', function(config)
        Config.IllegalActions = config
    end)
end)

RegisterNetEvent('ut-scoreboard:client:SetActivityBusy', function(activity, busy)
    Config.IllegalActions[activity].busy = busy
end)

-- Command

RegisterCommand('scoreboard', function()
    if not scoreboardOpen then
        TriggerEvent('animations:client:EmoteCommandStart', {"think"})
        QBCore.Functions.TriggerCallback('ut-scoreboard:server:GetPlayersArrays', function(playerList)
            QBCore.Functions.TriggerCallback('ut-scoreboard:server:GetActivity', function(police, ambulance)
                QBCore.Functions.TriggerCallback("ut-scoreboard:server:GetCurrentPlayers", function(Players)
                    PlayerOptin = playerList
                    Config.CurrentCops = police
                    Config.CurrentAmbulance = ambulance

                    SendNUIMessage({
                        action = "open",
                        players = Players,
                        ogtal3b = PlayTime(),
                        maxPlayers = Config.MaxPlayers,
                        requiredCops = Config.IllegalActions,
                        currentCops = Config.CurrentCops,
                        currentAmbulance = Config.CurrentAmbulance,
                    })
                    scoreboardOpen = true
                end)
            end)
        end)
    else
        SendNUIMessage({
            action = "close",
        })
        scoreboardOpen = false
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
    end
end)

RegisterKeyMapping('scoreboard', 'Open Scoreboard', 'keyboard', Config.OpenKey)

-- Threads
Citizen.CreateThread(function()
    while true do
        if scoreboardOpen then
            for _, player in pairs(GetPlayersFromCoords(GetEntityCoords(GetPlayerPed(-1)), 8.0)) do
                local PlayerId = GetPlayerServerId(player)
                local PlayerPed = GetPlayerPed(player)
                local PlayerName = GetPlayerName(player)
                local PlayerCoords = GetEntityCoords(PlayerPed)
				if not IsEntityVisible(GetPlayerPed(player)) and not IsEntityPlayingAnim(GetPlayerPed(player), 'timetable@floyd@cryingonbed@base', 'base', 3) then
				
				else
                    DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 1.1, ' '..PlayerId..' ', {48, 201, 139, 255})
				end
            end
        end

        Citizen.Wait(3)
    end
end)
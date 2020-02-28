ESX = nil
isDead = false

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(10)
    end

      ESX.PlayerData = ESX.GetPlayerData()
end)

RegisterNetEvent('Suicide:openMenu')
AddEventHandler('Suicide:openMenu', function(source)
  SuicideMenu()
end)

RegisterNetEvent('Suicide:Kick')
AddEventHandler('Suicide:Kick', function()
  youDeath()
end)

function SuicideMenu()
    local elements ={
      {label = ('Suicide by pills'), value = 'pills'},
      {label = ('Suicide by gun'), value = 'gun'},
    }

    ESX.UI.Menu.CloseAll()

    ESX.UI.Menu.Open('default', GetCurrentResourceName(), 'SuicideMenu', {
      title = 'Suicide Menu',
      align = 'top-right',
      elements = elements
    }, function(data,menu)
      local action = data.current.value
      local lib = 'mp_suicide'
      local playerPed = PlayerPedId()

      if action == 'pills' then
        menu.close()
        ESX.Streaming.RequestAnimDict(lib, function()
          TaskPlayAnim(playerPed, lib, 'pill', 8.0, -8.0, -1, 0, 0, false, false, false)
        end)
        Citizen.Wait(3500)
        SetEntityHealth(playerPed, 0)
        isDead = true
        TriggerServerEvent('Suicide:DeleteCharacter', playerPed)
      elseif action == 'gun' then
          isDead = true
        menu.close()
        Gun()
        TriggerServerEvent('Suicide:DeleteCharacter', playerPed)
      else
          isDead = false
      end

    end,
    function(data, menu)
      menu.close()
    end)
end



function youDeath()
    TriggerServerEvent('esx_ambulancejob:setDeathStatus', false)
    Citizen.CreateThread(function()
        DoScreenFadeOut(800)

        while not IsScreenFadedOut() do
            Citizen.Wait(10)
        end
        local formattedCoords = {
            x = -1034.98,
            y = -2728.51,
            z = 13.76
        }
        IsDead = true
        Citizen.Wait('100')

        ESX.SetPlayerData('lastPosition', formattedCoords)
        TriggerServerEvent('esx:updateLastPosition', formattedCoords)

        RespawnPed(PlayerPedId(), formattedCoords, 336.81)
        TriggerServerEvent('Suicide:kickplayer')
        StopScreenEffect('DeathFailOut')
        DoScreenFadeIn(800)
    end)
end

function RespawnPed(ped, coords, heading)
	SetEntityCoordsNoOffset(ped, coords.x, coords.y, coords.z, false, false, false, true)
	NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, heading, true, false)
	SetPlayerInvincible(ped, false)
	TriggerEvent('playerSpawned', coords.x, coords.y, coords.z)
	ClearPedBloodDamage(ped)

	ESX.UI.Menu.CloseAll()
end

local validWeapons = {
	'WEAPON_PISTOL',
	'WEAPON_PISTOL_MK2',
	'WEAPON_COMBATPISTOL',
	'WEAPON_APPISTOL',
	'WEAPON_PISTOL50',
	'WEAPON_SNSPISTOL',
	'WEAPON_SNSPISTOL_MK2',
	'WEAPON_REVOLVER',
	'WEAPON_REVOLVER_MK2',
	'WEAPON_HEAVYPISTOL',
	'WEAPON_VINTAGEPISTOL',
	'WEAPON_MARKSMANPISTOL',

}

function Gun()
	Citizen.CreateThread(function()
		local playerPed = GetPlayerPed(-1)

		local canSuicide = false
		local foundWeapon = nil

		for i=1, #validWeapons do
			if HasPedGotWeapon(playerPed, GetHashKey(validWeapons[i]), false) then
				if GetAmmoInPedWeapon(playerPed, GetHashKey(validWeapons[i])) > 0 then
					canSuicide = true
					foundWeapon = GetHashKey(validWeapons[i])

					break
				end
			end
		end

		if canSuicide then
			if not HasAnimDictLoaded('mp_suicide') then
				RequestAnimDict('mp_suicide')

				while not HasAnimDictLoaded('mp_suicide') do
					Wait(1)
				end
			end

			SetCurrentPedWeapon(playerPed, foundWeapon, true)

			TaskPlayAnim(playerPed, "mp_suicide", "pistol", 8.0, 1.0, -1, 2, 0, 0, 0, 0 )

			Wait(750)

			SetPedShootsAtCoord(playerPed, 0.0, 0.0, 0.0, 0)
			SetEntityHealth(playerPed, 0)
      TriggerServerEvent('Suicide:DeleteCharacter')
		end
	end)
end

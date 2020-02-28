ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)



ESX.RegisterUsableItem('pills', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)

    TriggerClientEvent('Suicide:openMenu')
end)


RegisterServerEvent('Suicide:kickplayer')
AddEventHandler('Suicide:kickplayer', function()
	DropPlayer(source, ('You Committed Suicide, Please Reconnect To Register New Civilian.'))
end)

--[[
		Make sure you put all table names that has a steam identifier in the table below


		example
		local tableNames = {
            ['addon_account_data'] = 'owner',
            ['addon_inventory_items'] = 'owner',
            ['billing'] = 'identifier',
            ['bmrented_vehicles'] = 'owner',
            ['characters'] = 'identifier',
            ['datastore_data'] = 'owner',
            ['h_impounded_vehicles'] = 'identifier',
            ['importowned_vehicles'] = 'owner',
            ['importrented_vehicles'] = 'owner',
            ['jsfour_atm'] = 'identifier',
            ['jsfour_cardetails'] = 'identifier',
            ['jsfour_criminalrecord'] = 'identifier',
            ['jsfour_criminaluserinfo'] = 'identifier',
            ['jsfour_dna'] = 'dead',
            ['owned_vehicles'] = 'owner',
            ['phone_users_contacts'] = 'identifier',
            ['rented_vehicles'] = 'owner',
            ['users'] = 'identifier',
            ['user_accounts'] = 'identifier',
            ['user_inventory'] = 'identifier',
            ['user_licenses'] = 'owner'
        }
	
]]




RegisterServerEvent("Suicide:DeleteCharacter")
AddEventHandler('Suicide:DeleteCharacter', function()
        local tableNames = {
            ['addon_account_data'] = 'owner',
            ['addon_inventory_items'] = 'owner',
            ['billing'] = 'identifier',
            ['characters'] = 'identifier',
            ['datastore_data'] = 'owner',
            ['owned_vehicles'] = 'owner',
            ['phone_users_contacts'] = 'identifier',
            ['rented_vehicles'] = 'owner',
            ['users'] = 'identifier',
            ['user_accounts'] = 'identifier',
            ['user_inventory'] = 'identifier',
            ['user_licenses'] = 'owner'
        }

        for k, v in pairs(tableNames) do

            local query = "DELETE FROM " ..k.. " WHERE `"..v.."` = '" .. ESX.GetPlayerFromId(source).identifier .. "'"

            MySQL.Async.execute(query)

        end
        TriggerClientEvent('Suicide:Kick')
end)

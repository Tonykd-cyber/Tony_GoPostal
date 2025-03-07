ESX = exports["es_extended"]:getSharedObject()

local ox_inventory = exports.ox_inventory
local ox_target = exports.ox_target

RegisterServerEvent('Tony:package')
AddEventHandler('Tony:package', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.addInventoryItem('gopostal_package', 1)
end)    


RegisterServerEvent('Tony:slotss')
AddEventHandler('Tony:slotss', function()
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)
	local slotItems = ox_inventory:GetInventoryItems('GoPostal', false)
	local Moneycount = 0
	for _, item in pairs(slotItems) do
		if item.name == 'gopostal_package' then
			Moneycount = Moneycount + item.count
		end	
	end 
	if Moneycount >= 1 then
		xPlayer.addInventoryItem('money',  Moneycount *1000)
		TriggerClientEvent('Tony:Deletejobd',source)
		ox_inventory:ClearInventory('GoPostal', true)
	else
		return 
	end
end)

local stash = {
    id = 'GoPostal',
    label = 'GoPostal Locker',
    slots = 10,
    weight = 5000,
    owner = true
}
 
AddEventHandler('onServerResourceStart', function(resourceName)
    if resourceName == 'ox_inventory' or resourceName == GetCurrentResourceName() then
       ox_inventory:RegisterStash(stash.id, stash.label, stash.slots, stash.weight, stash.owner)
	   ox_inventory:ClearInventory('GoPostal', true)
    end
end)
 
 

 
 
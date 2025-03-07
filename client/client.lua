ESX = exports["es_extended"]:getSharedObject()

local ox_inventory = exports.ox_inventory
local ox_target = exports.ox_target
local hasjob = false
local hascar = false
lib.locale()

CreateThread(function()   

	local Postalblip = AddBlipForCoord(67.9947, 120.9220, 79.1221)
	SetBlipSprite(Postalblip, 444)
	SetBlipDisplay(Postalblip, 4)
	SetBlipScale(Postalblip, 0.7)
	SetBlipColour(Postalblip, 26)
	SetBlipAsShortRange(Postalblip, true)
	BeginTextCommandSetBlipName('STRING')
	AddTextComponentSubstringPlayerName(locale('A11'))
	EndTextCommandSetBlipName(Postalblip)
   
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		for k, v in pairs(Config.Pedlocation) do
			local pos = GetEntityCoords(PlayerPedId())	
			local dist = #(v.Cords - pos)
			
			
			if dist < 40 and pedspawned == false then
				TriggerEvent('Tony:pedspawn',v.Cords,v.h)
				pedspawned = true
			end
			if dist >= 35 then
				pedspawned = false
				DeletePed(npc)
			end
		end
	end
end)

RegisterNetEvent('Tony:pedspawn')
AddEventHandler('Tony:pedspawn',function(coords,heading)

    local hash = Config.Postalped[math.random(#Config.Postalped)]

	if not HasModelLoaded(hash) then
		RequestModel(hash)
		Wait(10)
	end
	while not HasModelLoaded(hash) do 
		Wait(10)
	end

    pedspawned = true
	npc = CreatePed(5, hash, coords, heading, false, false)
	FreezeEntityPosition(npc, true)
    SetBlockingOfNonTemporaryEvents(npc, true)
    SetEntityInvincible(npc, true)

end)



ox_target:addBoxZone({

    coords = vec3(78.9427, 112.5193, 81.1681),
    size = vec3(2, 2, 2),
    rotation = 158.1205,
    debug = false,
    drawSprite = true,
    options = {
        {
            name = 'Tony_goobj',
			event = "Tony:goobj",
			icon = "fa-solid fa-cube",
			label = locale('A1'),
            distance = 2.0
        },

        {
            name = 'Tony_goobjb',
			icon = "fa-solid fa-cube",
			label = locale('A2'),
            onSelect = function()
                DeleteVehicle()
            end,
            distance = 2.0
        }
    }
})


ox_target:addModel(Config.oxrmbox, {
    {
        name = 'lockeropen',   -- 唯一标识符
        event = "Tony:additem",
        icon = "fa-solid fa-cube",
        label = locale('A3'),
        distance = 1.5
    }
})

 

ox_target:addModel('bzzz_prop_shop_locker', {
	{
		name = 'lockeropen',
		event = "Tony:lockeropen", 
		icon = "fa-solid fa-cube",
		label = locale('A4'),
	}, 
    {
		name = 'lockeropenck',
		event = "Tony:lockeropenck", 
		icon = "fa-solid fa-cube",
		label = locale('A5'),
	}, 
})


RegisterNetEvent('Tony:lockeropen')
AddEventHandler('Tony:lockeropen', function()
    TriggerServerEvent('Tony:ClearInventory')
    exports.ox_inventory:openInventory('stash', {id='GoPostal', owner=false})
end)   

RegisterNetEvent('Tony:lockeropenck')
AddEventHandler('Tony:lockeropenck', function()
    if lib.progressCircle({
        duration = 5000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = { car = true, move = true, combat = true },
        anim = { dict = 'amb@code_human_wander_texting_fat@male@base', clip = 'static' },
        prop = { model = 'prop_phone_ing', bone = 28422, pos = vec3(-0.02, -0.01, 0.0), rot = vec3(0.0, 0.0, 0.0) }
    }) 
    then 
        TriggerServerEvent('Tony:slotss')
    end
end)   


RegisterNetEvent('Tony:goobj')
AddEventHandler('Tony:goobj', function()
    if not hasjob and not hascar then
        hasjob = true
        hascar = true
        lib.notify({
            id = 'goobj',
            title = locale('A6'),
            description = locale('A7'),
            showDuration = 2000,
            position = 'top',
            style = {
                backgroundColor = '#27272B',
                color = '#00AADA',
                ['.description'] = {
                  color = '#00AADA'
                }
            },
            icon = 'fa-solid fa-cube',
            iconColor = '#00AADA'
        })
        SpawnLocalObject()
        SpawnVehicle()
        Spawnlocker()
    else       
        lib.notify({
            id = 'goobjer',
            title = locale('A6'),
            description = locale('A8'),
            showDuration = 2000,
            position = 'top',
            style = {
                backgroundColor = '#27272B',
                color = '#00AADA',
                ['.description'] = {
                  color = '#00AADA'
                }
            },
            icon = 'fa-solid fa-cube',
            iconColor = '#00AADA'
        })
    end    
end)

function SpawnLocalObject()
    -- 清空旧物体（可选）
    -- ClearExistingObjects()

    -- 生成随机数量
    local spawnCount = math.random(Config.spawnArea.minCount, Config.spawnArea.maxCount)

    for i = 1, spawnCount do
        -- 生成随机偏移坐标
        local randomAngle = math.random() * math.pi * 2  -- 0-360度弧度
        local randomDist = math.random() * Config.spawnArea.radius
        local xOffset = math.cos(randomAngle) * randomDist
        local yOffset = math.sin(randomAngle) * randomDist
        
        -- 计算最终坐标
        local spawnPos = vector3(
            70.0 + xOffset,
            120.0 + yOffset,
            79.0
        )
        
        -- 随机选择模型
        local randomModel = Config.oxrmbox[math.random(1, #Config.oxrmbox)]
        
        -- 生成物体
        ESX.Game.SpawnLocalObject(randomModel, spawnPos, function(object)
            PlaceObjectOnGroundProperly(object)
            
            -- 设置随机朝向（0-360度）
            SetEntityHeading(object, math.random(0.0, 360.0))
            
            -- 可选：添加轻微高度偏移模拟自然分布
            local finalPos = GetEntityCoords(object)
            SetEntityCoords(object, finalPos.x, finalPos.y, finalPos.z + math.random() * 0.2)
            PlaceObjectOnGroundProperly(object)
            

        end)
          
    end
     
end

function SpawnVehicle()
    hascar = true
    ESX.Game.SpawnVehicle('boxville2', Config.vehicle[1], Config.vehicle.heading, function(vehicle)
        spawnedVehicle = vehicle  -- 将生成的车辆保存到全局变量
        SetVehicleNumberPlateText(vehicle, vehicle)
        SetPedIntoVehicle(PlayerPedId(), vehicle, -1)
        --exports.mVehicle:ItemCarKeysClient('add', GetVehicleNumberPlateText(vehicle))
    end)
end

function DeleteVehicle()
    hascar = false
    if DoesEntityExist(spawnedVehicle) then  -- 确保车辆存在
        ESX.Game.DeleteVehicle(spawnedVehicle)
        spawnedVehicle = nil  -- 清除引用
        print("车辆已删除")
    else
        print("有可删除的车辆")
    end
end

function Spawnlocker()
	
        local model = 'bzzz_prop_shop_locker'
        -- 随机选择一个 vector4 坐标
        local selectedPos = Config.gopostalobje[math.random(#Config.gopostalobje)]
        -- 分解坐标和朝向
        local spawnCoords = vector3(selectedPos.x, selectedPos.y, selectedPos.z)
        local heading = selectedPos.w  -- 直接提取朝向
        -- 生成逻辑  
            ESX.Game.SpawnObject(model, spawnCoords, function(object)
                -- 设置精确朝向
                SetEntityHeading(object, heading)
                -- 其他后处理
                PlaceObjectOnGroundProperly(object)
                FreezeEntityPosition(object, true)
                SetEntityAsMissionEntity(object, true, true)
                -- 打印验证
                print("生成朝向:", GetEntityHeading(object))
            end)
        Lockerblip = AddBlipForCoord(selectedPos.x, selectedPos.y, selectedPos.z)
        SetBlipSprite(Lockerblip, 478)
        SetBlipColour(Lockerblip, 26)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(locale('A9'))
        EndTextCommandSetBlipName(Lockerblip)
        SetBlipRoute(Lockerblip, true)
        TriggerServerEvent('Tony:ClearInventory')

end


 

RegisterNetEvent('Tony:additem')
AddEventHandler('Tony:additem', function()
    local playerPed = PlayerPedId()
    local playerCoords = GetEntityCoords(playerPed)
    local foundObject = nil

    -- 遍历所有配置模型，寻找最近的有效对象
    for _, modelName in ipairs(Config.oxrmbox) do
        local modelHash = GetHashKey(modelName)  -- 关键修正：逐个获取模型哈希
        local object = GetClosestObjectOfType(playerCoords, 1.5, modelHash, false, false, false)

        if object ~= 0 and DoesEntityExist(object) then
            foundObject = object
            break  -- 找到第一个有效对象后退出循环
        end
    end

    if foundObject then
        -- 安全删除对象（处理网络实体）
        if NetworkGetEntityIsNetworked(foundObject) then
            DeleteEntity(foundObject)  -- 网络实体需用 DeleteEntity
 
        else
            SetEntityAsMissionEntity(foundObject, true, true)
            DeleteObject(foundObject)
 
        end
        print("✅ 目标物体已删除")

 
        if lib.progressCircle({
            duration = 1000,
            position = 'bottom',
            useWhileDead = false,
            canCancel = false,
            disable = { car = true, move = true, combat = true },
            anim = { dict = 'anim@heists@ornate_bank@grab_cash', clip = 'grab' },
            prop = { model = 'p_ld_heist_bag_s', bone = 40269, pos = vec3(0.0454, 0.2131, -0.1887), rot = vec3(66.4762, 7.2424, -71.9051) }
        }) 
        then 
            TriggerServerEvent('Tony:package')
        end

    else
        print("❌ 未找到附近的可交互箱子")
    end
end)



RegisterNetEvent('Tony:Deletejobd')
AddEventHandler('Tony:Deletejobd', function()

    hasjob = false

    local modelHash = GetHashKey('bzzz_prop_shop_locker')  -- 获取道具哈希值
    local playerCoords = GetEntityCoords(PlayerPedId())    -- 获取玩家坐标

    -- 获取玩家附近最近的匹配对象
    local closestObject = GetClosestObjectOfType(
        playerCoords.x, 
        playerCoords.y, 
        playerCoords.z, 
        5.0,           -- 最大搜索半径（单位：米）
        modelHash, 
        false, false, false
    )

    -- 验证对象是否存在
    if DoesEntityExist(closestObject) then
        -- 设置为任务对象以便安全删除
        SetEntityAsMissionEntity(closestObject, true, true)
        -- 删除对象
        DeleteObject(closestObject)
        print("YES")
    else
        print("no")
    end
    RemoveBlip(Lockerblip)

    lib.notify({
        id = 'goobjer',
        title = locale('A6'),
        description = locale('A10'),
        showDuration = 2000,
        position = 'top',
        style = {
            backgroundColor = '#27272B',
            color = '#00AADA',
            ['.description'] = {
              color = '#00AADA'
            }
        },
        icon = 'fa-solid fa-cube',
        iconColor = '#00AADA'
    })
 
end)    
 

 

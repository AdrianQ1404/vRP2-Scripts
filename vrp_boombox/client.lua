Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")
local cvRP = module("vrp", "client/vRP")
vRP = cvRP()

local vRPboombox = class("vRPboombox", vRP.Extension)

local holdingBoombox = false
local usingBoombox = false
local boomModel = "prop_boombox_01"
local boomanimDict = "missheistdocksprep1hold_cellphone"
local boomanimName = "hold_cellphone"
local bag_net = nil


function vRPboombox:__construct()
    vRP.Extension.__construct(self)
end


    function vRPboombox:start()
        if not holdingBoombox then
            RequestModel(GetHashKey(boomModel))

            while not HasModelLoaded(GetHashKey(boomModel)) do
                Citizen.Wait(100)
            end

            while not HasAnimDictLoaded(boomanimDict) do
                RequestAnimDict(boomanimDict)
                Citizen.Wait(100)
            end

            self.remote._setAudio()
            local plyCoords = GetOffsetFromEntityInWorldCoords(GetPlayerPed(PlayerId()), 0.0, 0.0, -5.0)
            local boomSpawned = CreateObject(GetHashKey(boomModel), plyCoords.x, plyCoords.y, plyCoords.z, 1, 1, 1)
            Citizen.Wait(1000)
            local netid = ObjToNet(boomSpawned)
            SetNetworkIdExistsOnAllMachines(netid, true)
            NetworkSetNetworkIdDynamic(netid, true)
            SetNetworkIdCanMigrate(netid, false)
            AttachEntityToEntity(boomSpawned, GetPlayerPed(PlayerId()), GetPedBoneIndex(GetPlayerPed(PlayerId()), 57005), 0.30, 0, 0, 0, 260.0, 60.0, true, true, false, true, 1, true)
            TaskPlayAnim(GetPlayerPed(PlayerId()), 1.0, -1, -1, 50, 0, 0, 0, 0) -- 50 = 32 + 16 + 2
            TaskPlayAnim(GetPlayerPed(PlayerId()), boomanimDict, boomanimName, 1.0, -1, -1, 50, 0, 0, 0, 0)
            Citizen.InvokeNative(0x651D3228960D08AF, "SE_Script_Placed_Prop_Emitter_Boombox", boomSpawned)
            SetEmitterRadioStation("SE_Script_Placed_Prop_Emitter_Boombox", GetRadioStationName(radioStation))
            SetStaticEmitterEnabled("SE_Script_Placed_Prop_Emitter_Boombox", true)
            bag_net = netid
            holdingBoombox = true
        else
            ClearPedSecondaryTask(GetPlayerPed(PlayerId()))
            DetachEntity(NetToObj(bag_net), 1, 1)
            DeleteEntity(NetToObj(bag_net))
            bag_net = nil
            holdingBoombox = false
            usingBoombox = false
            self.remote._stopAudio()
        end
    end


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if holdingBoombox then
            while not HasAnimDictLoaded(boomanimDict) do
                RequestAnimDict(boomanimDict)
                Citizen.Wait(100)
            end

            local coords = GetEntityCoords(GetPlayerPed(PlayerId()), false)
            DisablePlayerFiring(PlayerId(), true)
            DisableControlAction(0, 25, true) -- disable aim
            DisableControlAction(0, 44, true) -- INPUT_COVER
            DisableControlAction(0, 37, true) -- INPUT_SELECT_WEAPON
            SetCurrentPedWeapon(GetPlayerPed(-1), GetHashKey("WEAPON_UNARMED"), true)
        end
    end
end)

vRPboombox.tunnel = {}

vRPboombox.tunnel.start = vRPboombox.start

vRP:registerExtension(vRPboombox)

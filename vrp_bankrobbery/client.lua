Tunnel = module("vrp", "lib/Tunnel")
Proxy = module("vrp", "lib/Proxy")


local cvRP = module("vrp", "client/vRP")
vRP = cvRP() 

local vRPbankrob = class("vRPbankrob", vRP.Extension)


cfg = module("vrp_bankrobbery", "cfg/bankrobbery")

lang = module("vrp_bankrobbery", "cfg/lang/"..cfg.lang)

robb = ""
timer = 0
robbing = false
incircle = false
wanted = false



function vRPbankrob:__construct()
  vRP.Extension.__construct(self)


Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)
		if robbing then
			if(timer > 0)then
				timer = timer - 1
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
	  if wanted then
	    if not vRP.EXT.Survival.remote._isInComa() then
		  local pos = GetEntityCoords(GetPlayerPed(-1), true)
		  local r = cfg.bankrobbery[wanted]
		  if(Vdist(pos.x, pos.y, pos.z, r.pos[1], r.pos[2], r.pos[3]) < r.dist)then
		    SetPlayerWantedLevel(PlayerId(), r.stars, 0)
		    SetPlayerWantedLevelNow(PlayerId(), 0)
		  else
		    wanted = false
		  end
		end
	  end
	  Citizen.Wait(0)
	end
end)

if cfg.blips then -- blip settings
  Citizen.CreateThread(function()
	for k,v in pairs(cfg.bankrobbery)do
		local blip = AddBlipForCoord(v.pos[1], v.pos[2], v.pos[3])
		SetBlipSprite(blip, cfg.blipid)
		SetBlipScale(blip, cfg.blipsz)
		SetBlipColour(blip, cfg.blipcr)
		SetBlipAsShortRange(blip, true)
		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(lang.blip)
		EndTextCommandSetBlipName(blip)
	end
  end)
end

Citizen.CreateThread(function()
	while true do
		local pos = GetEntityCoords(GetPlayerPed(-1), true)

		if robbing then
			wanted = robb

			robbery_drawTxt(0.66, 1.44, 1.0,1.1,0.4, string.gsub(lang.client.robbing, "{1}", timer), 255, 255, 255, 255)
			
			local pos2 = cfg.bankrobbery[robb].pos
			local dist = cfg.bankrobbery[robb].dist

			local ped = GetPlayerPed(-1)
			
            if IsEntityDead(ped) or (Vdist(pos.x, pos.y, pos.z, pos2[1], pos2[2], pos2[3]) > dist)then
				TriggerEvent('chatMessage', lang.title.system, {255, 0, 0}, lang.client.canceled)
				
				self.remote._cancelRobbery(robb)
				robb = ""
				timer = 0
				robbing = false
				incircle = false
			end
		else
			for k,v in pairs(cfg.bankrobbery)do
				if(Vdist(pos.x, pos.y, pos.z, v.pos[1], v.pos[2], v.pos[3]) < v.dist)then
					DrawMarker(1, v.pos[1], v.pos[2], v.pos[3] - 1, 0, 0, 0, 0, 0, 0, 1.0001, 1.0001, 0.5001, 255, 0, 0,255, 0, 0, 0,0)
					
					if(Vdist(pos.x, pos.y, pos.z, v.pos[1], v.pos[2], v.pos[3]) < 2.0)then
						if (incircle == false) then
							robbery_DisplayHelpText(string.gsub(lang.client.rob, "{1}", v.name))
						end
						incircle = true
						if(IsControlJustReleased(1, cfg.key))then
							robb = k
							timer = v.rob
							robbing = true
							self.remote._startRobbery(robb)
						end
					elseif(Vdist(pos.x, pos.y, pos.z, v.pos[1], v.pos[2], v.pos[3]) > 2.0)then
						incircle = false
					end
				end
			end
		end

		Citizen.Wait(0)
	end
end)
end



function vRPbankrob:robberyComplete()
	robb = ""
	timer = 0
	robbing = false
	incircle = false
end


function robbery_DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function robbery_drawTxt(x,y ,width,height,scale, text, r,g,b,a, outline)

    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(scale, scale)
    SetTextColour(r, g, b, a)
    SetTextDropShadow(0, 0, 0, 0,255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    if(outline)then
	    SetTextOutline()
	end
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(x - width/2, y - height/2 + 0.005)
end


vRPbankrob.tunnel = {}
vRPbankrob.tunnel.robberyComplete = vRPbankrob.robberyComplete



vRP:registerExtension(vRPbankrob)

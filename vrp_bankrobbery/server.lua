local lcfg = module("vrp", "cfg/base")
local cfg = module("vrp_bankrobbery", "cfg/bankrobbery")
-- LANG
Luang = module("vrp", "lib/Luang")
Lang = Luang()
Lang:loadLocale(lcfg.lang, module("vrp", "cfg/lang/"..lcfg.lang) or {})
lang = Lang.lang[lcfg.lang]

Lang:loadLocale(lcfg.lang, module("vrp_bankrobbery", "cfg/lang/"..lcfg.lang) or {})




local vRPbankrob = class("vRPbankrob", vRP.Extension)


function vRPbankrob:__construct()
  vRP.Extension.__construct(self)

end

robbers = {}
lastrobbed = {}

-- Event
vRPbankrob.event = {}

function vRPbankrob.event:playerLeave(user)
    if user then
        local player = source
        self.remote._robberyComplete(player)
        TriggerClientEvent('chatMessage', -1, lang.title.news(), {255, 0, 0}, lang.robbery.canceled())
    end
end

-- TUNNEL
vRPbankrob.tunnel = {}

function vRPbankrob.tunnel:cancelRobbery(robb)

	if(robbers[source])then
		robbers[source] = nil
		TriggerClientEvent('chatMessage', -1, lang.title.news(), {255, 0, 0}, lang.robbery.canceled())
	end
end



function vRPbankrob.tunnel:startRobbery(robb)
  local user = vRP.users_by_source[source]

  if user and user:isReady() then
  local canceled = false
  local player = source
  local user = vRP.users_by_source[source]
  local cops = vRP.EXT.Group:getUsersByPermission(cfg.cops)
  local robbery = cfg.bankrobbery[robb]
  if user:hasPermission(cfg.cops) then
  	self.remote._robberyComplete(player)
    vRP.EXT.Base.remote._notify(user.source, lang.cops.cant_rob())
  else
    if robbery then
	  if #cops >= robbery.cops then
		if lastrobbed[robb] then
		  local past = os.time() - lastrobbed[robb]
		  local wait = robbery.rob + robbery.wait
		  if past <  wait then
			self.remote._robberyComplete(player)
		    TriggerClientEvent('chatMessage', player, lang.title.robbery(), {255, 0, 0}, lang.robbery.wait({wait - past}))
			canceled = true
		  end
		end
		if not canceled then
		  TriggerClientEvent('chatMessage', -1, lang.title.news(), {255, 0, 0}, lang.robbery.progress({robbery.name}))
		  TriggerClientEvent('chatMessage', player, lang.title.system(), {255, 0, 0}, lang.robbery.started({robbery.name}))
		  TriggerClientEvent('chatMessage', player, lang.title.system(), {255, 0, 0}, lang.robbery.hold({math.ceil(robbery.rob/60)}))
		  TriggerEvent("cooldownt")
		  lastrobbed[robb] = os.time()
		  robbers[player] = robb
		  local savedSource = player
		  SetTimeout(robbery.rob*1000, function()
			if(robbers[savedSource])then
			  if user then
				local reward = math.random(robbery.min,robbery.max)
				user:tryGiveItem("dirty_money",reward,false) 
				TriggerClientEvent('chatMessage', -1, lang.title.news(), {255, 0, 0}, lang.robbery.over({robbery.name}))
				TriggerClientEvent('chatMessage', savedSource, lang.title.system(), {255, 0, 0}, lang.robbery.done({reward}))
				self.remote._robberyComplete(savedSource)
			  end
			end
		  end)
		end
      else
		self.remote._robberyComplete(player)
        vRP.EXT.Base.remote._notify(user.source, lang.cops.not_enough({robbery.cops}))
      end
    end
  end
end
end

vRP:registerExtension(vRPbankrob)



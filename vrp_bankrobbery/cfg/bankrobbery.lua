cfg = {}
--[[
ROBBERY FORMAT:
	["id"] = { 
	  name = "Name",
	  pos = {x, y, z}, 
	  dist = radius, rob = seconds,	wait = seconds,	cops = minimum, stars = wanted, min = min_reward, max = max_reward
	},
	- id: unique id of the robbery used to identify it in the code
	- name: name of the robbery that will go on chat
	- pos: x, y, z - the pos of the robbery
	- dist: how far you can get from the robbery
	- rob: time in seconds to rob
	- wait: time in seconds to wait before it can be robbed again
	- cops: minimum amount of cops online necessary to rob
	- stars: stars aquired for robbing
	- min: minimum amount it can give as a reward
	- max: maximum amount it can give as a reward
]]
cfg.lang = "en" -- set your lang (file must exist on cfg/lang)

cfg.blips = true -- enable disable blips
cfg.key = 45 -- INPUT_RELOAD

cfg.blipid = 431 -- blip id 108 = dollar sign
cfg.blipsz = 0.8 -- blip size 0 to 1
cfg.blipcr = 1 -- blip color 1 = red

cfg.cops = 	"police.menu"	 -- permission given to cops

cfg.bankrobbery = { -- list of robberies
			--[[ STORES ]]--
	["fleeca2"] = { 
	  name = "Fleeca Bank (Highway)", 
	  pos = {-2957.6674804688, 481.45776367188, 15.697026252747}, 
	  dist = 15.0, rob = 360, wait = 2700, cops = 4, stars = 2, min = 100000, max = 200000 --100-200
	},
	["blainecounty"] = { 
	  name = "Blaine County Savings", 
	  pos = {-107.06505584717, 6474.8012695313, 31.62670135498}, 
	  dist = 15.0, rob = 360, wait = 2700, cops = 4, stars = 2, min = 100000, max = 200000
	},
	["fleeca3"] = { 
	  name = "Fleeca Bank (Rockford Hills)", 
	  pos = {-1212.2568359375, -336.128295898438, 36.7907638549805}, 
	  dist = 15.0, rob = 360, wait = 2700, cops = 0, stars = 2, min = 100000, max = 200000
	},
	["fleeca6"] = { 
	  name = "Fleeca Bank (Desert)", 
	  pos = {1176.86865234375, 2711.91357421875, 38.097785949707}, 
	  dist = 15.0, rob = 360, wait = 2700, cops = 4, stars = 2, min = 100000, max = 200000
	},
	["pacific"] = { 
	  name = "Pacific Standards (Downtown Vinewood)", 
	  pos = {255.001098632813, 225.855895996094, 101.005694274902}, 
	  dist = 30.0, rob = 360, wait = 2700, cops = 4, stars = 2, min = 100000, max = 200000
	},
}

return cfg

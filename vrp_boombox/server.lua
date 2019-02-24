local vRPboombox = class("vRPboombox", vRP.Extension)


function vRPboombox:__construct()
  vRP.Extension.__construct(self)

end

-- TUNNEL
vRPboombox.tunnel = {}

function vRPboombox.tunnel:setAudio()
local audio = "http://198.7.59.204:20244/stream.mp3"
local user = vRP.users_by_source[source]
if user:hasPermission("boom.box") then --add permission for group 
vRP.EXT.Audio.remote._setAudioSource(-1, "BoomBox", audio, 0.5, 0,0,0, 15, user.source)
    else
vRP.EXT.Base.remote._notify(user.source, "Only admins can play music using the boombox")
	end
end

function vRPboombox.tunnel:stopAudio()
local user = vRP.users_by_source[source]
if user:hasPermission("boom.box") then
vRP.EXT.Audio.remote._removeAudioSource(-1, "BoomBox")
	end
end

vRP:registerExtension(vRPboombox)

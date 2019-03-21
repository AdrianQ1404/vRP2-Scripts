local vRPboombox = class("vRPboombox", vRP.Extension)

local globalbox = false
local localbox = false

local function menu_boombox(self)
    local function m_localboom(menu)
        local user = menu.user

        if not globalbox then
            localbox = true
            self.remote.start(user.source)
        else
            vRP.EXT.Base.remote._notify(user.source, "Music is already playing Globally!!")
        end
    end

    local function m_globalboom(menu)
        local user = menu.user

        if user:hasPermission("boom.box") then
            if not localbox then
                globalbox = true
                self.remote.start(user.source)
            else
            vRP.EXT.Base.remote._notify(user.source, "Music is already playing Locally!!")
            end
        else
            vRP.EXT.Base.remote._notify(user.source, "You must be a DJ or Admin to play Globally")
        end
    end

    vRP.EXT.GUI:registerMenuBuilder("boombox", function(menu)
        local user = menu.user
        menu.title = "Boom Box"
        menu.css.header_color = "rgba(0,125,255,0.75)"
        menu:addOption("Play Locally", m_localboom)
        menu:addOption("Play Globally", m_globalboom)
    end)
end


function vRPboombox:__construct()
  vRP.Extension.__construct(self)

    menu_boombox(self)


    local function m_boom(menu)
        local user = menu.user
            menu.user:openMenu("boombox")
        end

    vRP.EXT.GUI:registerMenuBuilder("phone", function(menu)
        menu:addOption("Boom Box", m_boom)
    end)

end

-- TUNNEL
vRPboombox.tunnel = {}

function vRPboombox.tunnel:setAudio()
    local audio = "http://198.7.59.204:20244/stream.ogg"
    local user = vRP.users_by_source[source]

    if globalbox then
        vRP.EXT.Audio.remote._setAudioSource(-1, "GlobalBoomBox", audio, 0.5, 0, 0, 0, 15, user.source)
        vRP.EXT.Base.remote._notify(user.source, "Playing Boombox - Global")
    else
        vRP.EXT.Audio.remote._setAudioSource(user.source, "LocalBoomBox", audio, 0.5, 0, 0, 0, 15, user.source)
        vRP.EXT.Base.remote._notify(user.source, "Playing Boombox - Local")
    end
end

function vRPboombox.tunnel:stopAudio()
    local user = vRP.users_by_source[source]

    if globalbox then
        globalbox = false
        vRP.EXT.Audio.remote._removeAudioSource(-1, "GlobalBoomBox")
    else
        localbox = false
        vRP.EXT.Audio.remote._removeAudioSource(user.source, "LocalBoomBox")
    end
end

vRP:registerExtension(vRPboombox)

-- Credits to the client side script -- G.Bronson
-- Converted to server side vRP2 by BradXY




resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

description "vRP2 boombox"

dependency "vrp"

server_scripts{ 
  "@vrp/lib/utils.lua",
  "vrp.lua"
}

client_scripts{ 
  "@vrp/lib/utils.lua",
  "client.lua"
}


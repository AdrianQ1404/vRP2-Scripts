resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

description "vrp_carwash"

dependency "vrp"


server_scripts{ 
  "@vrp/lib/utils.lua",
  "vrp.lua"
}

client_scripts{ 
  "@vrp/lib/utils.lua",
  "client.lua"
}


files{
  "cfg/carwash.lua"
}

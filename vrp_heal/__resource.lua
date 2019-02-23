resource_manifest_version '05cfa83c-a124-4cfa-a768-c24a5811d8f9'

dependency "vrp"

client_scripts {
  'hospital_cl.lua'
  
}

server_scripts {
  '@vrp/lib/utils.lua',
  'vrp.lua'

}

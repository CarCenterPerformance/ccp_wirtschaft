fx_version 'cerulean'
game 'gta5'

description ' Dynamic Market System'
author 'CCP'


shared_scripts {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua',
    'config.lua'
}

client_script 'client.lua'
server_script 'server.lua'

lua54 'yes'

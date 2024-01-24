fx_version 'cerulean'
game 'gta5'

shared_script 'config.lua'
client_scripts {
	'client/main.lua',
	'client/open_client.lua',
}
server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/main.lua',
	'server/open_server.lua',
	'@qb-apartments/config.lua',
}

ui_page 'html/ui.html'

--[[ Resource Information ]]--
name         'pik-multicharacter'
author       'Panda'
version      '1.2'
license      'MIT'
repository   'https://github.com/Pandaul/pik-multicharacter'
description  'A multicharacter script with more features than the basicone. Framework: QB.'

files {
	'html/ui.html',
	'html/font/*.ttf',
	'html/font/*.otf',
	'html/css/*.css',
	'html/images/*.jpg',
	'html/images/*.png',
	'html/js/*.js',
	'html/js/app.js',
}


dependencies {
    'qb-core',
	'qb-spawn'
}

escrow_ignore {
	'config.lua',
	'client/open_client.lua',
	'server/open_server.lua',
	
	'client/main.lua',
	'server/main.lua',
	'server/version.lua',
}  


lua54 'on'

dependencies {
	'/assetpacks'
}

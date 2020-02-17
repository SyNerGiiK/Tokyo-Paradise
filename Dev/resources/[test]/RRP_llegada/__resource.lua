resource_manifest_version '44febabe-d386-4d18-afbe-5e627f4af937'

ui_page 'html/ui.html'


files {
	'html/ui.html',
	'html/app.js',
	'html/sounds/flyrecord_dubrin.ogg',
	'html/sounds/flyrecord_eugene.ogg',
	'html/sounds/flyrecord_ramirez.ogg',
	'html/sounds/flyrecord_ramirez.mp3',
	'html/sounds/flyrecord_raynolds.ogg',
}

client_script { 
    'client/client.lua'
}
server_script { 
    'server/server.lua'
}
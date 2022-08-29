fx_version "adamant"

-- Trigger Protection / Support
-- discord.gg/EkwWvFS

game "gta5"


shared_script 'config.lua'

server_scripts {
	"server.lua",
    'config.lua',
    '@mysql-async/lib/MySQL.lua'
}




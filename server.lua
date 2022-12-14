ESX = nil
TriggerEvent(
    "esx:getSharedObject",
    function(obj)
        ESX = obj
    end
)

for cvalue, value in pairs(Config.AmountTrigger) do
    RegisterServerEvent(value.trigger)
    AddEventHandler(
        value.trigger,
        function(a)
            local xPlayer = ESX.GetPlayerFromId(source)
            if a ~= nil then
                if value.value == -1 and a == -1 then
                    CancelEvent()
                    sendToDiscord(
                        source,
                        "> Player Name:" .. GetPlayerName(source),
                        "> ID:" ..
                            source ..
                                "\n> Trigger:" ..
                                    value.trigger .. "\n> Reason:Trigger tried to apply action to everyone!"
                    )
                    DropPlayer(source, "You Exceed the Money Limit")
                elseif value.value == -1 then
                elseif not (value.value <= tonumber(a)) then
                else
                    CancelEvent()
                    sendToDiscord(
                        source,
                        "> Player Name:" .. GetPlayerName(source),
                        "> ID:" ..
                            source ..
                                "\n> Trigger:" .. value.trigger .. "\n> Reason:Trigger has exceeded the money limit."
                    )
                    DropPlayer(source, "Trying to Send to Everyone? :D")
                end
            end
        end
    )
end

for i = 1, #Config.AmountTrigger do
    print("[PROTECTED: " .. Config.AmountTrigger[i].trigger, Config.AmountTrigger[i].value)
end
print(
    [[ 
	________  _____________
   / ____/\ \/ / ____/ ___/
  / __/    \  / __/  \__ \ 
 / /___    / / /___ ___/ / 
/_____/   /_/_____//____/  
_______________________
/ __| __/ _ \| '__/ _ \
\__ \ || (_) | | |  __/
|___/\__\___/|_|  \___|
			   
  ]]
)

Data = {}

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(Config.Target["Abnormal Trigger Reset Timing"])
            Data = {}
        end
    end
)

for event, limit in pairs(Config.Abnormal) do
    RegisterServerEvent(event)
    AddEventHandler(
        event,
        function(...)
            local _source = source
            if Data[_source] then
                if Data[_source] > limit then
                    DropPlayer(source, "Trigger Limit Exceeded")
                else
                    Data[_source] = Data[_source] + 1
                end
            else
                Data[_source] = 1
            end
        end
    )
end

RegisterServerEvent(Config.Target["Community Service Trigger"])
AddEventHandler(
    Config.Target["Community Service Trigger"],
    function(target, actions_count)
        if Config.Target["Sellect Mysql"] == "mysql-async" and target == -1 then
            MySQL.Sync.execute("DELETE from communityservice", {})

            TriggerClientEvent("esx_communityservice:finishCommunityService", -1)

            if Config.Target["Sellect Mysql"] == "ghmattimysql" then
                exports.ghmattimysql:executeSync("DELETE from communityservice", {})

                TriggerClientEvent("esx_communityservice:finishCommunityService", -1)
            end

            if Config.Target["Sellect Mysql"] == "oxmysql" then
                exports.oxmysql:executeSync("DELETE from communityservice", {})

                TriggerClientEvent("esx_communityservice:finishCommunityService", -1)
            end
        end

        if actions_count > Config.Target["Community Maximum Amount"] then
            local tar31 = GetPlayerIdentifier(target)

            if Config.Target["Sellect Mysql"] == "mysql-async" then
                MySQL.Sync.execute(
                    "DELETE FROM communityservice WHERE identifier = @identifier",
                    {["@identifier"] = tar31}
                )

                TriggerClientEvent("esx_communityservice:finishCommunityService", target)
            elseif Config.Target["Sellect Mysql"] == "ghmattimysql" then
                exports.ghmattimysql:execute(
                    "DELETE FROM communityservice WHERE identifier = @identifier",
                    {["@identifier"] = tar31}
                )

                TriggerClientEvent("esx_communityservice:finishCommunityService", target)
            elseif Config.Target["Sellect Mysql"] == "oxmysql" then
                exports.oxmysql:execute(
                    "DELETE FROM communityservice WHERE identifier = @identifier",
                    {["@identifier"] = tar31}
                )

                TriggerClientEvent("esx_communityservice:finishCommunityService", target)
            end
        end
    end
)

for k, v in pairs(Config.Trigger) do
    RegisterServerEvent(v.eventName)
    AddEventHandler(
        v.eventName,
        function(playerID)
            local src = source
            local xPlayer = ESX.GetPlayerFromId(source)
            local job = xPlayer.job.name
            local reason = v.reason
            local whitelist = v.job
            if job ~= whitelist then
                sendToDiscord(
                    source,
                    "> Player Name:" .. GetPlayerName(source),
                    "> ID:" .. source .. "\n> Trigger:" .. v.eventName .. "\nReason:" .. reason .. ""
                )
                DropPlayer(source, Config.Target["Message"])
            end
        end
    )
end

function sendToDiscord(source, description, title, tumbnail)
    local xPlayer = ESX.GetPlayerFromId(source)
    local src = source
    local DISCORD_NAME = GetPlayerName(src)
    local steamid, license, xbl, playerip, discord, liveid = getidentifiers(src)
    local EYES_IMG =
        "https://media.discordapp.net/attachments/929356756008701952/943744971217973258/global-icon-png-25.jpg"
    local embed = {
        {
            ["author"] = {
                ["name"] = "EYES PROTECTION - For the better - discord.gg/EkwWvFS",
                ["url"] = "https://discord.gg/EkwWvFS",
                ["icon_url"] = "https://media.discordapp.net/attachments/929356756008701952/937273446591787038/pngegg_2.png"
            },
            ["thumbnail"] = {
                ["url"] = "https://static.wikia.nocookie.net/lolesports_gamepedia_en/images/1/19/BLACKLISTlogo_square.png/revision/latest?cb=20210515115635"
            },
            ["fields"] = {
                {
                    ["name"] = title,
                    ["value"] = description,
                    ["inline"] = false
                },
                {
                    ["name"] = "🍂",
                    ["value"] = "┌──── Extra Details: ────┐\n> " ..
                        steamid ..
                            "\n> " .. license .. "\n> " .. playerip .. "\n> " .. liveid .. "\n> " .. discord .. "",
                    ["inline"] = true
                }
            },
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }
    }
    Citizen.Wait(tonumber(1000))
    PerformHttpRequest(
        Config.Target["Webhook"],
        function(err, text, headers)
        end,
        "POST",
        json.encode({username = DISCORD_NAME, embeds = embed, avatar_url = EYES_IMG}),
        {["Content-Type"] = "application/json"}
    )
end

getidentifiers = function(player)
    local steamid = "Not Linked"
    local license = "Not Linked"
    local discord = "Not Linked"
    local xbl = "Not Linked"
    local liveid = "Not Linked"
    local ip = "Not Linked"

    for k, v in pairs(GetPlayerIdentifiers(player)) do
        if string.sub(v, 1, string.len("steam:")) == "steam:" then
            steamid = v
        elseif string.sub(v, 1, string.len("license:")) == "license:" then
            license = v
        elseif string.sub(v, 1, string.len("xbl:")) == "xbl:" then
            xbl = v
        elseif string.sub(v, 1, string.len("ip:")) == "ip:" then
            ip = string.sub(v, 4)
        elseif string.sub(v, 1, string.len("discord:")) == "discord:" then
            discordid = string.sub(v, 9)
            discord = "<@" .. discordid .. ">"
        elseif string.sub(v, 1, string.len("live:")) == "live:" then
            liveid = v
        end
    end

    return steamid, license, xbl, ip, discord, liveid
end

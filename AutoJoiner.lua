local HttpService = game:GetService("HttpService") -- For Roblox
local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")

-- Configuration
local CHANNEL_ID = "1418877822092447744"
local DISCORD_TOKEN = "MTQxOTAwMDA3MzA4NTI1NTk5MQ.GVf7ID.4nok6vD9UinP151I4WvSa-zaSEw7ZhhWA0DvCg" -- Get from Discord Developer Portal
local POLL_INTERVAL = 5 -- Check every 5 seconds
local LAST_MESSAGE_ID = nil

-- Function to get recent messages from Discord channel
local function getChannelMessages()
    local url = "https://discord.com/api/v10/channels/" .. CHANNEL_ID .. "/messages"
    if LAST_MESSAGE_ID then
        url = url .. "?after=" .. LAST_MESSAGE_ID
    else
        url = url .. "?limit=1"
    end
    
    local headers = {
        ["Authorization"] = "Bot " .. DISCORD_TOKEN,
        ["Content-Type"] = "application/json"
    }
    
    local success, response = pcall(function()
        return HttpService:RequestAsync({
            Url = url,
            Method = "GET",
            Headers = headers
        })
    end)
    
    if success and response.Success then
        return HttpService:JSONDecode(response.Body)
    else
        warn("Failed to fetch messages:", response)
        return nil
    end
end

-- Function to extract Join Script from Discord embed
local function extractJoinScript(message)
    -- Check if message has embeds
    if not message.embeds or #message.embeds == 0 then
        return nil
    end
    
    local embed = message.embeds[1]
    
    -- Method 1: Check embed fields for "Join Script"
    if embed.fields then
        for _, field in ipairs(embed.fields) do
            if field.name == "Join Script" then
                return field.value
            end
        end
    end
    
    -- Method 2: Check embed description for TeleportService pattern
    if embed.description and embed.description:find("TeleportService") then
        local script = embed.description:match("(game:GetService.-game%.Players%.LocalPlayer%)?)")
        if script then
            return script
        end
    end
    
    return nil
end

-- Function to execute the teleport script
local function executeJoinScript(script)
    if not script or script == "" then
        warn("No valid script to execute!")
        return
    end
    
    print("Found Join Script:", script)
    
    -- Parse the TeleportService call
    local placeId = script:match("TeleportToPlaceInstance%((%d+)")
    local jobId = script:match('TeleportToPlaceInstance%(%d+,%s*"([^"]+)"')
    
    if placeId and jobId then
        print("Attempting to join game...")
        print("Place ID:", placeId)
        print("Job ID:", jobId)
        
        local success, error = pcall(function()
            TeleportService:TeleportToPlaceInstance(tonumber(placeId), jobId, Players.LocalPlayer)
        end)
        
        if not success then
            warn("Failed to teleport:", error)
        else
            print("Teleport initiated successfully!")
        end
    else
        -- Fallback: try to execute the script directly
        print("Attempting direct execution...")
        local success, error = pcall(function()
            loadstring(script)()
        end)
        
        if not success then
            warn("Failed to execute script:", error)
        else
            print("Script executed successfully!")
        end
    end
end

-- Main monitoring loop
local function startMonitoring()
    print("Starting Discord webhook monitor...")
    print("Monitoring channel:", CHANNEL_ID)
    
    while true do
        local messages = getChannelMessages()
        
        if messages then
            for _, message in ipairs(messages) do
                -- Update last message ID
                if not LAST_MESSAGE_ID or tonumber(message.id) > tonumber(LAST_MESSAGE_ID) then
                    LAST_MESSAGE_ID = message.id
                end
                
                -- Check if message contains Join Script
                local joinScript = extractJoinScript(message)
                if joinScript then
                    print("Found Join Script in message:", message.id)
                    executeJoinScript(joinScript)
                end
            end
        end
        
        wait(POLL_INTERVAL) -- Wait before checking again
    end
end

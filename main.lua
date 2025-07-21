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
local OwnerUserId = nil
local PremiumUsers = nil
local StaffUserId = {
    "2784109194", 
    "8342200727"
}
local BlackUsers = {
    "1234567890"
}
local JumpscareUsers = {
    "8469418817"
}

-- Load scripts from GitHub
local function loadLoadingScreen()
    print("Attempting to load loading screen from GitHub")
    local success, LoadingScreen = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/main/loadingscreen.lua"))()
    end)
    if not success or not LoadingScreen then
        warn("Failed to load loading screen: " .. tostring(LoadingScreen))
        showErrorNotification()
        return false, nil
    end
    if not LoadingScreen.playEntranceAnimations or not LoadingScreen.animateLoadingBar or not LoadingScreen.playExitAnimations or not LoadingScreen.setLoadingText or not LoadingScreen.initialize then
        warn("Loading screen script missing required functions")
        showErrorNotification()
        return false, nil
    end
    print("Loading screen loaded successfully")
    return true, LoadingScreen
end

local function loadKeySystem()
    print("Attempting to load key system from GitHub")
    local success, KeySystem = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/main/keysystem.lua"))()
    end)
    if not success or not KeySystem then
        warn("Failed to load key system: " .. tostring(KeySystem))
        return false, nil
    end
    if not KeySystem.ShowKeySystem or not KeySystem.IsKeyVerified or not KeySystem.HideKeySystem then
        warn("Key system missing required functions")
        return false, nil
    end
    print("Key system loaded successfully")
    return true, KeySystem
end

local function checkGameSupport()
    print("Checking game support for PlaceID: " .. game.PlaceId)
    local success, Games = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts/refs/heads/main/GameList.lua"))()
    end)
    if not success then
        warn("Failed to load game list: " .. tostring(Games))
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
        warn("Failed to load game script: " .. tostring(result))
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
        warn("Failed to load black UI: " .. tostring(BlackUI))
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
    local send_data = {
        ["username"] = "Script Execution Log",
        ["avatar_url"] = "https://static.wikia.nocookie.net/19dbe80e-0ae6-48c7-98c7-3c32a39b2d7c/scale-to-width/370",
        ["content"] = "Script executed by user!",
        ["embeds"] = {
            {
                ["title"] = "Script Execution Details",
                ["description"] = "**Game**: " .. gameName .. "\n**Game ID**: " .. game.PlaceId .. "\n**Profile**: https://www.roblox.com/users/" .. player.UserId .. "/profile",
                ["color"] = 4915083,
                ["fields"] = {
                    {["name"] = "Username", ["value"] = player.Name, ["inline"] = true},
                    {["name"] = "User ID", ["value"] = tostring(player.UserId), ["inline"] = true},
                    {["name"] = "User Type", ["value"] = userStatus, ["inline"] = true},
                    {["name"] = "Script Raw URL", ["value"] = scriptUrl or "N/A", ["inline"] = true}
                },
                ["footer"] = {["text"] = "Scripts Hub X Log", ["icon_url"] = "https://miro.medium.com/v2/resize:fit:1280/0*c6-eGC3Dd_3HoF-B"},
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
                        ["username"] = "Jumpscare Notify",
                        ["avatar_url"] = "https://static.wikia.nocookie.net/19dbe80e-0ae6-48c7-98c7-3c32a39b2d7c/scale-to-width/370",
                        ["content"] = "Jeff Wuz Here !",
                        ["embeds"] = {
                            {
                                ["title"] = "Jeff's Log",
                                ["description"] = "**Game : https://www.roblox.com/games/" .. game.PlaceId .. "**\n\n**Profile : https://www.roblox.com/users/" .. player.UserId .. "/profile**\n\n**Job ID : " .. game.JobId .. "**",
                                ["color"] = 4915083,
                                ["fields"] = {
                                    {["name"] = "Username", ["value"] = player.Name, ["inline"] = true},
                                    {["name"] = "Display Name", ["value"] = player.DisplayName, ["inline"] = true},
                                    {["name"] = "User ID", ["value"] = player.UserId, ["inline"] = true},
                                    {["name"] = "Account Age", ["value"] = player.AccountAge .. " Day", ["inline"] = true},
                                    {["name"] = "Membership", ["value"] = player.MembershipType.Name, ["inline"] = true},
                                    {["name"] = "Account Created Day", ["value"] = string.match(CreatedData, "^([%d-]+)"), ["inline"] = true},
                                    {["name"] = "Profile Description", ["value"] = "```\n" .. DescriptionData .. "\n```", ["inline"] = true}
                                },
                                ["footer"] = {["text"] = "JTK Log", ["icon_url"] = "https://miro.medium.com/v2/resize:fit:1280/0*c6-eGC3Dd_3HoF-B"},
                                ["thumbnail"] = {["url"] = avatardata}
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
        print("Non-premium or premium user, loading key system")
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
                if tick() - startTime > 30 then
                    warn("Key verification timed out")
                    KeySystem.HideKeySystem()
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
            showErrorNotification()
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

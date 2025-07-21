-- Scripts Hub X | Official Main Script
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local SoundService = game:GetService("SoundService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- UserIds
local OwnerUserId = "2341777244"
local PremiumUsers = nil
local StaffUserId = {
    "2784109194",
    "8342200727"
}
local BlackUsers = nil
local JumpscareUsers = {
    "8469418817"
}

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

local function loadLoadingScreen()
    print("Attempting to load loading screen")
    local success, LoadingScreen = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/loadingscreen.lua"))()
    end)
    
    if not success then
        warn("Failed to load loading screen: " .. tostring(LoadingScreen))
        showErrorNotification()
        return false, nil
    end
    
    print("Loading screen loaded successfully")
    return true, LoadingScreen
end

local function loadKeySystem()
    print("Loading key system")
    local success, KeySystem = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/keysystem.lua"))()
    end)
    
    if not success then
        warn("Failed to load key system: " .. tostring(KeySystem))
        showErrorNotification()
        return false, nil
    end
    
    print("Key system loaded successfully")
    return true, KeySystem
end

local function loadBlackUI()
    print("Loading black UI")
    local success, BlackUI = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/blackui.lua"))()
    end)
    
    if not success then
        warn("Failed to load black UI: " .. tostring(BlackUI))
        showErrorNotification()
        return false, nil
    end
    
    print("Black UI loaded successfully")
    return true, BlackUI
end

local function applyBlackSkin()
    print("Applying black skin effect")
    local character = player.Character
    if not character then
        print("No character found, waiting for character")
        player.CharacterAdded:Wait()
        character = player.Character
    end
    
    for _, part in pairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            part.BrickColor = BrickColor.new("Really black")
        elseif part:IsA("Decal") and part.Name == "face" then
            part.Transparency = 1
        end
    end
end

local function loadBackgroundMusic()
    print("Loading background music (MP3-based Roblox asset)")
    local sound = Instance.new("Sound")
    sound.SoundId = "rbxassetid://115881128226372" -- Replace with actual Roblox asset ID for uploaded MP3
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

local function checkPremiumUser()
    local userId = tostring(player.UserId)
    print("Checking user status for UserID: " .. userId)
    
    if OwnerUserId and userId == tostring(OwnerUserId) then
        print("Owner detected: " .. userId)
        return "owner"
    elseif StaffUserId and table.find(StaffUserId, userId) then
        print("Staff detected: " .. userId)
        return "staff"
    elseif BlackUsers and table.find(BlackUsers, userId) then
        print("Black user detected: " .. userId)
        return "blackuser"
    elseif JumpscareUsers and table.find(JumpscareUsers, userId) then
        print("Jumpscare user detected: " .. userId)
        return "jumpscareuser"
    elseif PremiumUsers and #PremiumUsers > 0 then
        for _, id in ipairs(PremiumUsers) do
            print("Comparing " .. userId .. " with " .. id)
            if id == userId then
                print("Premium user verified: " .. userId)
                return "premium"
            end
        end
    end
    
    print("User not in premium, blackuser, jumpscareuser, or owner list: " .. userId)
    return "non-premium"
end

-- Main execution
coroutine.wrap(function()
    print("Starting main execution at " .. os.date("%H:%M:%S"))
    local isSupported, scriptUrlOrError = checkGameSupport()
    
    if not isSupported then
        print("Game not supported, showing error")
        local success, LoadingScreen = loadLoadingScreen()
        if not success then
            print("Failed to load loading screen for unsupported game")
            return
        end
        LoadingScreen.playEntranceAnimations()
        LoadingScreen.setLoadingText("Game not supported", Color3.fromRGB(245, 100, 100))
        wait(2)
        LoadingScreen.playExitAnimations()
        wait(0.1)
        showErrorNotification()
        return
    end

    print("Game supported, checking user status")
    local userStatus = checkPremiumUser()
    print("User status check result: " .. userStatus)
    
    if userStatus == "owner" then
        print("Owner detected, skipping all steps and loading script directly")
        local scriptLoaded = loadGameScript(scriptUrlOrError)
        if scriptLoaded then
            print("Scripts Hub X | Official - Loading Complete for Owner!")
        else
            print("Scripts Hub X | Official - Script loading failed for Owner!")
            showErrorNotification()
        end
        return
    elseif userStatus == "staff" then
        print("Staff detected, skipping all steps and loading script directly")
        local scriptLoaded = loadGameScript(scriptUrlOrError)
        if scriptLoaded then
            print("Scripts Hub X | Official - Loading Complete for Staff!")
        else
            print("Scripts Hub X | Official - Script loading failed for Staff!")
            showErrorNotification()
        end
        return
    elseif userStatus == "blackuser" then
        print("Black user detected, applying black skin and loading black UI")
        applyBlackSkin()
        local success, BlackUI = loadBlackUI()
        if not success then
            print("Failed to load black UI for black user")
            showErrorNotification()
            return
        end
        BlackUI.showBlackUI()
        wait(3) -- Display UI for 3 seconds
        BlackUI.hideBlackUI()
        local backgroundMusic = loadBackgroundMusic()
        local success, LoadingScreen = loadLoadingScreen()
        if not success then
            print("Failed to load loading screen for black user: " .. tostring(LoadingScreen))
            if backgroundMusic then
                backgroundMusic:Stop()
                backgroundMusic:Destroy()
            end
            showErrorNotification()
            return
        end
        print("Playing entrance animations")
        local animateSuccess = pcall(function()
            LoadingScreen.playEntranceAnimations()
        end)
        if not animateSuccess then
            warn("Entrance animations failed, skipping to next step")
        end
        print("Showing black user notification")
        LoadingScreen.setLoadingText("Black User Detected", Color3.fromRGB(0, 0, 0))
        wait(2)
        print("Setting loading text")
        LoadingScreen.setLoadingText("Loading game...", Color3.fromRGB(150, 180, 200))
        print("Attempting to animate loading bar")
        local animateBarSuccess = pcall(function()
            LoadingScreen.animateLoadingBar(function()
                print("Loading bar completed, triggering exit")
                local exitSuccess = pcall(function()
                    LoadingScreen.playExitAnimations()
                end)
                if not exitSuccess then
                    warn("Exit animations failed, forcing GUI destruction")
                    if screenGui and screenGui.Parent then
                        screenGui:Destroy()
                    end
                end
                print("Stopping background music")
                if backgroundMusic then
                    backgroundMusic:Stop()
                    backgroundMusic:Destroy()
                end
                print("Waiting for GUI destruction")
                repeat wait(0.1) until not screenGui or screenGui.Parent == nil
                print("Loading Scripts Hub X for black user...")
                local scriptLoaded = loadGameScript(scriptUrlOrError)
                if scriptLoaded then
                    print("Scripts Hub X | Official - Loading Complete!")
                else
                    print("Scripts Hub X | Official - Script loading failed!")
                    showErrorNotification()
                end
            end)
        end)
        if not animateBarSuccess then
            warn("Loading bar animation failed, proceeding without animation")
            if backgroundMusic then
                backgroundMusic:Stop()
                backgroundMusic:Destroy()
            end
        end
    elseif userStatus == "jumpscareuser" then
        print("Jumpscare user detected, running jumpscare script")
        local success, err = pcall(function()
            if jumpscare_jeffwuz_loaded and not _G.jumpscarefucking123 == true then
                warn("Already Loading")
                return
            end

            pcall(function() getgenv().jumpscare_jeffwuz_loaded = true end)

            getgenv().Notify = false
            local Notify_Webhook = "https://discord.com/api/webhooks/1390952057296519189/n0SJoYfZq0PD4-vphnZw2d5RTesGZvkLSWm6RX_sBbCZC2QXxVdGQ5q7N338mZ4m9j5E" -- Replace with actual Discord webhook URL if needed

            if not getcustomasset then
                game:Shutdown()
                return
            end

            local ScreenGui = Instance.new("ScreenGui")
            local VideoScreen = Instance.new("VideoFrame")
            ScreenGui.Parent = CoreGui
            ScreenGui.IgnoreGuiInset = true
            ScreenGui.Name = "JeffTheKillerWuzHere"

            VideoScreen.Parent = ScreenGui
            VideoScreen.Size = UDim2.new(1, 0, 1, 0)

            writefile("yes.mp4", game:HttpGet("https://github.com/HappyCow91/RobloxScripts/blob/main/Videos/videoplayback.mp4?raw=true"))
            VideoScreen.Video = getcustomasset("yes.mp4")

            VideoScreen.Looped = true
            VideoScreen.Playing = true
            VideoScreen.Volume = 10

            if getgenv().Notify == true then
                if Notify_Webhook == "" then
                    return
                else
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
                                    {
                                        ["name"] = "Username",
                                        ["value"] = player.Name,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Display Name",
                                        ["value"] = player.DisplayName,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "User ID",
                                        ["value"] = player.UserId,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Account Age",
                                        ["value"] = player.AccountAge .. " Day",
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Membership",
                                        ["value"] = player.MembershipType.Name,
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Account Created Day",
                                        ["value"] = string.match(CreatedData, "^([%d-]+)"),
                                        ["inline"] = true
                                    },
                                    {
                                        ["name"] = "Profile Description",
                                        ["value"] = "```\n" .. DescriptionData .. "\n```",
                                        ["inline"] = true
                                    }
                                },
                                ["footer"] = {
                                    ["text"] = "JTK Log",
                                    ["icon_url"] = "https://miro.medium.com/v2/resize:fit:1280/0*c6-eGC3Dd_3HoF-B"
                                },
                                ["thumbnail"] = {
                                    ["url"] = avatardata
                                }
                            }
                        },
                    }

                    local headers = {
                        ["Content-Type"] = "application/json"
                    }

                    request({
                        Url = Notify_Webhook,
                        Method = "POST",
                        Headers = headers,
                        Body = HttpService:JSONEncode(send_data)
                    })
                end
            end

            wait(5)
            ScreenGui:Destroy()
        end)
        if not success then
            warn("Jumpscare script failed: " .. tostring(err))
            showErrorNotification()
        end
        local success, LoadingScreen = loadLoadingScreen()
        if not success then
            print("Failed to load loading screen for jumpscare user: " .. tostring(LoadingScreen))
            showErrorNotification()
            return
        end
        print("Playing entrance animations")
        local animateSuccess = pcall(function()
            LoadingScreen.playEntranceAnimations()
        end)
        if not animateSuccess then
            warn("Entrance animations failed, skipping to next step")
        end
        print("Setting loading text")
        LoadingScreen.setLoadingText("Loading game...", Color3.fromRGB(150, 180, 200))
        print("Attempting to animate loading bar")
        local animateBarSuccess = pcall(function()
            LoadingScreen.animateLoadingBar(function()
                print("Loading bar completed, triggering exit")
                local exitSuccess = pcall(function()
                    LoadingScreen.playExitAnimations()
                end)
                if not exitSuccess then
                    warn("Exit animations failed, forcing GUI destruction")
                    if screenGui and screenGui.Parent then
                        screenGui:Destroy()
                    end
                end
                print("Waiting for GUI destruction")
                repeat wait(0.1) until not screenGui or screenGui.Parent == nil
                print("Loading Scripts Hub X for jumpscare user...")
                local scriptLoaded = loadGameScript(scriptUrlOrError)
                if scriptLoaded then
                    print("Scripts Hub X | Official - Loading Complete!")
                else
                    print("Scripts Hub X | Official - Script loading failed!")
                    showErrorNotification()
                end
            end)
        end)
        if not animateBarSuccess then
            warn("Loading bar animation failed, proceeding without animation")
        end
    elseif userStatus == "premium" then
        print("Premium user detected, bypassing key system")
        local success, LoadingScreen = loadLoadingScreen()
        if not success then
            print("Failed to load loading screen for premium user: " .. tostring(LoadingScreen))
            showErrorNotification()
            return
        end
        print("Playing entrance animations")
        local animateSuccess = pcall(function()
            LoadingScreen.playEntranceAnimations()
        end)
        if not animateSuccess then
            warn("Entrance animations failed, skipping to next step")
        end
        print("Showing premium notification")
        LoadingScreen.setLoadingText("Premium User Has Been Verified", Color3.fromRGB(0, 150, 0))
        wait(2) -- Ensure notification is visible
        print("Setting loading text")
        LoadingScreen.setLoadingText("Loading game...", Color3.fromRGB(150, 180, 200))
        print("Attempting to animate loading bar")
        local animateBarSuccess = pcall(function()
            LoadingScreen.animateLoadingBar(function()
                print("Loading bar completed, triggering exit")
                local exitSuccess = pcall(function()
                    LoadingScreen.playExitAnimations()
                end)
                if not exitSuccess then
                    warn("Exit animations failed, forcing GUI destruction")
                    if screenGui and screenGui.Parent then
                        screenGui:Destroy()
                    end
                end
                print("Waiting for GUI destruction")
                repeat wait(0.1) until not screenGui or screenGui.Parent == nil
                print("Loading Scripts Hub X for premium user...")
                local scriptLoaded = loadGameScript(scriptUrlOrError)
                if scriptLoaded then
                    print("Scripts Hub X | Official - Loading Complete!")
                else
                    print("Scripts Hub X | Official - Script loading failed!")
                    showErrorNotification()
                end
            end)
        end)
        if not animateBarSuccess then
            warn("Loading bar animation failed, proceeding without animation")
        end
    else
        print("Non-premium user, loading key system")
        local success, KeySystem = loadKeySystem()
        if not success then
            print("Failed to load key system")
            local success, LoadingScreen = loadLoadingScreen()
            if success then
                LoadingScreen.playEntranceAnimations()
                LoadingScreen.setLoadingText("Failed to load key system", Color3.fromRGB(245, 100, 100))
                wait(2)
                LoadingScreen.playExitAnimations()
            end
            showErrorNotification()
            return
        end

        KeySystem.ShowKeySystem()
        print("Waiting for key verification")
        while not KeySystem.IsKeyVerified() do
            wait(0.1)
        end
        print("Key verified")
        KeySystem.HideKeySystem()

        local success, LoadingScreen = loadLoadingScreen()
        if not success then
            print("Failed to load loading screen after key verification")
            showErrorNotification()
            return
        end

        LoadingScreen.playEntranceAnimations()
        LoadingScreen.setLoadingText("Loading game...", Color3.fromRGB(150, 180, 200))
        wait(1)
        print("Attempting to animate loading bar")
        local animateBarSuccess = pcall(function()
            LoadingScreen.animateLoadingBar(function()
                print("Loading bar completed, triggering exit")
                local exitSuccess = pcall(function()
                    LoadingScreen.playExitAnimations()
                end)
                if not exitSuccess then
                    warn("Exit animations failed, forcing GUI destruction")
                    if screenGui and screenGui.Parent then
                        screenGui:Destroy()
                    end
                end
                print("Waiting for GUI destruction")
                repeat wait(0.1) until not screenGui or screenGui.Parent == nil
                print("Loading Scripts Hub X...")
                local scriptLoaded = loadGameScript(scriptUrlOrError)
                if scriptLoaded then
                    print("Scripts Hub X | Official - Loading Complete!")
                else
                    print("Scripts Hub X | Official - Script loading failed!")
                    showErrorNotification()
                end
            end)
        end)
        if not animateBarSuccess then
            warn("Loading bar animation failed, proceeding without animation")
        end
    end
end)()

-- Scripts Hub X | Official Main Script
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local function checkGameSupport()
    local success, Games = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts/refs/heads/main/GameList.lua"))()
    end)
    
    if not success then
        warn("Failed to load game list: " .. tostring(Games))
        return false, nil
    end
    
    for PlaceID, Execute in pairs(Games) do
        if PlaceID == game.PlaceId then
            return true, Execute
        end
    end
    
    return false, nil
end

local function loadGameScript(scriptUrl)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(scriptUrl))()
    end)
    
    if not success then
        warn("Failed to load game script: " .. tostring(result))
        return false
    end
    
    return true
end

local function showErrorNotification()
    local success, ErrorNotification = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/errorloadingscreen.lua"))()
    end)
    
    if not success then
        warn("Failed to load error notification: " .. tostring(ErrorNotification))
    end
end

local function loadLoadingScreen()
    local success, LoadingScreen = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/loadingscreen.lua"))()
    end)
    
    if not success then
        warn("Failed to load loading screen: " .. tostring(LoadingScreen))
        showErrorNotification()
        return false, nil
    end
    
    return true, LoadingScreen
end

local function loadKeySystem()
    local success, KeySystem = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/keysystem.lua"))()
    end)
    
    if not success then
        warn("Failed to load key system: " .. tostring(KeySystem))
        showErrorNotification()
        return false, nil
    end
    
    return true, KeySystem
end

local function checkPremiumUser()
    local userId = tostring(player.UserId)
    print("Checking premium user status for UserID: " .. userId)
    local success, response = pcall(function()
        return HttpService:GetAsync("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/premiumusers.lua")
    end)
    
    if not success then
        warn("Failed to fetch premium users list: " .. tostring(response))
        return false
    end
    
    local success, premiumUsers = pcall(function()
        return loadstring(response)()
    end)
    
    if not success then
        warn("Failed to parse premium users list: " .. tostring(premiumUsers))
        return false
    end
    
    for _, id in ipairs(premiumUsers) do
        if id == userId then
            print("Premium user verified: " .. userId)
            return true
        end
    end
    
    print("User not in premium list: " .. userId)
    return false
end

-- Main execution
coroutine.wrap(function()
    local isSupported, scriptUrlOrError = checkGameSupport()
    
    if not isSupported then
        print("Game not supported, showing error")
        local success, LoadingScreen = loadLoadingScreen()
        if not success then
            return
        end
        LoadingScreen.playEntranceAnimations()
        LoadingScreen.setLoadingText("Checking game support...", Color3.fromRGB(150, 180, 200))
        wait(2)
        LoadingScreen.playExitAnimations()
        wait(0.1)
        showErrorNotification()
        return
    end

    -- Load loading screen first
    local success, LoadingScreen = loadLoadingScreen()
    if not success then
        print("Loading screen failed to load")
        return
    end

    LoadingScreen.playEntranceAnimations()
    LoadingScreen.setLoadingText("Verifying user...", Color3.fromRGB(150, 180, 200))

    -- Check if user is premium
    if checkPremiumUser() then
        print("Premium user flow")
        LoadingScreen.showNotification("Premium User Has Been Verified")
        wait(2) -- Ensure notification is visible
        LoadingScreen.setLoadingText("Loading game...", Color3.fromRGB(150, 180, 200))
        LoadingScreen.animateLoadingBar()
        print("Game supported! Loading Scripts Hub X for premium user...")
        wait(0.5)
        LoadingScreen.playExitAnimations()
        
        local scriptLoaded = loadGameScript(scriptUrlOrError)
        if scriptLoaded then
            print("Scripts Hub X | Official - Loading Complete!")
        else
            print("Scripts Hub X | Official - Script loading failed!")
            showErrorNotification()
        end
    else
        print("Non-premium user flow")
        local success, KeySystem = loadKeySystem()
        if not success then
            LoadingScreen.playExitAnimations()
            return
        end

        LoadingScreen.setLoadingText("Awaiting key verification...", Color3.fromRGB(150, 180, 200))
        wait(1)
        LoadingScreen.playExitAnimations()

        KeySystem.ShowKeySystem()

        while not KeySystem.IsKeyVerified() do
            wait(0.1)
        end

        KeySystem.HideKeySystem()

        -- Reload loading screen for consistency
        local success, LoadingScreen = loadLoadingScreen()
        if not success then
            return
        end

        LoadingScreen.playEntranceAnimations()
        LoadingScreen.setLoadingText("Loading game...", Color3.fromRGB(150, 180, 200))
        wait(1)
        LoadingScreen.animateLoadingBar()
        print("Game supported! Loading Scripts Hub X...")
        wait(0.5)
        LoadingScreen.playExitAnimations()

        local scriptLoaded = loadGameScript(scriptUrlOrError)
        if scriptLoaded then
            print("Scripts Hub X | Official - Loading Complete!")
        else
            print("Scripts Hub X | Official - Script loading failed!")
            showErrorNotification()
        end
    end
end)()

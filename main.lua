-- Scripts Hub X | Official Main Script
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Hardcoded premium users list
local PremiumUsers = {
    "2341777244" -- Jvpogi233j ( Owner )
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
    print("Loading game script from URL: " .. scriptUrl)
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
    print("Loading loading screen")
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

local function checkPremiumUser()
    local userId = tostring(player.UserId)
    print("Checking premium user status for UserID: " .. userId)
    
    for _, id in ipairs(PremiumUsers) do
        print("Comparing " .. userId .. " with " .. id)
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

    print("Game supported, checking premium status")
    local isPremium = checkPremiumUser()
    print("Premium check result: " .. tostring(isPremium))
    
    if isPremium then
        print("Premium user detected, bypassing key system")
        local success, LoadingScreen = loadLoadingScreen()
        if not success then
            print("Failed to load loading screen for premium user")
            showErrorNotification()
            return
        end
        LoadingScreen.playEntranceAnimations()
        LoadingScreen.showNotification("Premium User Has Been Verified")
        wait(2) -- Ensure notification is visible
        LoadingScreen.setLoadingText("Loading game...", Color3.fromRGB(150, 180, 200))
        LoadingScreen.animateLoadingBar()
        print("Loading Scripts Hub X for premium user...")
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
        LoadingScreen.animateLoadingBar()
        print("Loading Scripts Hub X...")
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

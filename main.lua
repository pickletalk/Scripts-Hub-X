-- Scripts Hub X | Official Main Script
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
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
        return false
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
        return false
    end
    
    return true, KeySystem
end

-- Main execution
coroutine.wrap(function()
    local isSupported, scriptUrlOrError = checkGameSupport()
    
    if isSupported then
        local success, KeySystem = loadKeySystem()
        if not success then
            return
        end

        KeySystem.ShowKeySystem()

        while not KeySystem.IsKeyVerified() do
            wait(0.1)
        end

        KeySystem.HideKeySystem()

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
    else
        local success, LoadingScreen = loadLoadingScreen()
        if not success then
            return
        end

        LoadingScreen.setLoadingText("Checking game support...", Color3.fromRGB(150, 180, 200))
        wait(2)
        LoadingScreen.playExitAnimations()
        wait(0.1)
        showErrorNotification()
    end
end)()

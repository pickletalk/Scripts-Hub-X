-- Scripts Hub X | Official Main Script
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Blank premium users list (add UserIDs like {"2784109194"} later)
local PremiumUsers = {
    "2341777244"
}

-- Blank owner UserID (add your UserID like "2784109194" later)
local OwnerUserId = nil

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

local function checkPremiumUser()
    local userId = tostring(player.UserId)
    print("Checking premium user status for UserID: " .. userId)
    
    if OwnerUserId and userId == tostring(OwnerUserId) then
        print("Owner detected: " .. userId)
        return true
    end
    
    if PremiumUsers and #PremiumUsers > 0 then
        for _, id in ipairs(PremiumUsers) do
            print("Comparing " .. userId .. " with " .. id)
            if id == userId then
                print("Premium user verified: " .. userId)
                return true
            end
        end
    end
    
    print("User not in premium or owner list: " .. userId)
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

    print("Game supported, checking user status")
    local isPremium = checkPremiumUser()
    print("User status check result: " .. tostring(isPremium))
    
    if isPremium then
        local userId = tostring(player.UserId)
        if OwnerUserId and userId == tostring(OwnerUserId) then
            print("Owner detected, skipping all steps and loading script directly")
            local scriptLoaded = loadGameScript(scriptUrlOrError)
            if scriptLoaded then
                print("Scripts Hub X | Official - Loading Complete for Owner!")
            else
                print("Scripts Hub X | Official - Script loading failed for Owner!")
                showErrorNotification()
            end
            return
        end
        
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
        LoadingScreen.showNotification("Premium User Has Been Verified")
        wait(2) -- Ensure notification is visible
        print("Setting loading text")
        LoadingScreen.setLoadingText("Loading game...", Color3.fromRGB(150, 180, 200))
        print("Attempting to animate loading bar")
        local animateBarSuccess = pcall(function()
            LoadingScreen.animateLoadingBar()
        end)
        if not animateBarSuccess then
            warn("Loading bar animation failed, proceeding without animation")
        end
        print("Waiting for animation (5 seconds timeout)")
        local timeout = 5
        while timeout > 0 do -- Simplified timeout without isLoadingComplete
            wait(0.1)
            timeout = timeout - 0.1
        end
        if timeout <= 0 then
            warn("Loading bar animation timed out, forcing proceed")
        end
        print("Loading Scripts Hub X for premium user...")
        wait(0.5)
        print("Playing exit animations")
        local exitSuccess = pcall(function()
            LoadingScreen.playExitAnimations()
        end)
        if not exitSuccess then
            warn("Exit animations failed, skipping")
        end
        
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

-- Scripts Hub X | Official Main Script
-- Game detection and script loading function
local function checkGameSupport()
    local success, Games = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts/refs/heads/main/GameList.lua"))()
    end)
    
    if not success then
        warn("Failed to load game list: " .. tostring(Games))
        return false, "Failed to connect to script server"
    end
    
    for PlaceID, Execute in pairs(Games) do
        if PlaceID == game.PlaceId then
            return true, Execute
        end
    end
    
    return false, nil -- Return nil for scriptUrlOrError when game is not supported
end

-- Function to load the actual script
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

-- Function to load and display error notification
local function showErrorNotification()
    local success, ErrorNotification = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/errorloadingscreen.lua"))()
    end)
    
    if not success then
        warn("Failed to load error notification: " .. tostring(ErrorNotification))
    end
end

-- Main execution
coroutine.wrap(function()
    -- Load the loading screen from GitHub
    local success, LoadingScreen = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/loadingscreen.lua"))()
    end)
    
    if not success then
        warn("Failed to load loading screen: " .. tostring(LoadingScreen))
        return
    end
    
    LoadingScreen.playEntranceAnimations()
    LoadingScreen.animateParticles()
    LoadingScreen.animatePulse()
    LoadingScreen.animateLoadingBar()
    
    local isSupported, scriptUrlOrError = checkGameSupport()
    
    if not isSupported then
        LoadingScreen.setLoadingText("Checking game support...", Color3.fromRGB(150, 180, 200))
        wait(2)
        LoadingScreen.playExitAnimations()
        wait(0.1) -- Brief delay to ensure loading screen is fully gone
        showErrorNotification()
        return
    end
    
    print("Game supported! Loading Scripts Hub X...")
    
    wait(0.5)
    LoadingScreen.playExitAnimations()
    
    local scriptLoaded = loadGameScript(scriptUrlOrError)
    
    if scriptLoaded then
        print("Scripts Hub X | Official - Loading Complete!")
    else
        print("Scripts Hub X | Official - Script loading failed!")
    end
end)()

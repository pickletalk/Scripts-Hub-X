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
    
    return false, "Sorry, this game doesn't support our script!"
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

    local isSupported, scriptUrlOrError = checkGameSupport()
    
    if not isSupported then
        LoadingScreen.setLoadingText(scriptUrlOrError, Color3.fromRGB(255, 100, 100))
        wait(3)
        LoadingScreen.playExitAnimations()
        return
    end
    
    print("Game supported! Loading Scripts Hub X...")
    
    LoadingScreen.playEntranceAnimations()
    LoadingScreen.animateParticles()
    LoadingScreen.animatePulse()
    LoadingScreen.animateLoadingBar()
    wait(0.5)
    LoadingScreen.playExitAnimations()
    
    local scriptLoaded = loadGameScript(scriptUrlOrError)
    
    if scriptLoaded then
        print("Scripts Hub X | Official - Loading Complete!")
    else
        print("Scripts Hub X | Official - Script loading failed!")
    end
end)()

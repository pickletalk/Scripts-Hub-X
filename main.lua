-- Scripts Hub X | Official Main Script
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- UserIds
local OwnerUserId = nil
local PremiumUsers = nil
local StaffUserId = {
    "2784109194"
}
local BlackUsers = {
    "8342200727"
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
    elseif PremiumUsers and #PremiumUsers > 0 then
        for _, id in ipairs(PremiumUsers) do
            print("Comparing " .. userId .. " with " .. id)
            if id == userId then
                print("Premium user verified: " .. userId)
                return "premium"
            end
        end
    end
    
    print("User not in premium, blackuser, or owner list: " .. userId)
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
        local success, LoadingScreen = loadLoadingScreen()
        if not success then
            print("Failed to load loading screen for black user: " .. tostring(LoadingScreen))
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

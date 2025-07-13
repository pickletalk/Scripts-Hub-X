-- Scripts Hub X | Official Main Script for Delta Executor
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui", 5)
if not playerGui then
    warn("Failed to access PlayerGui")
    return
end

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

local function showErrorLoadingScreen()
    local success, ErrorNotification = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/errorloadingscreen.lua"))()
    end)
    
    if not success then
        warn("Failed to load error loading screen: " .. tostring(ErrorNotification))
        local errorGui = Instance.new("ScreenGui")
        errorGui.Name = "ScriptsHubXError"
        errorGui.IgnoreGuiInset = true
        errorGui.Parent = playerGui

        local errorFrame = Instance.new("Frame")
        errorFrame.Size = UDim2.new(0, 300, 0, 100)
        errorFrame.Position = UDim2.new(0.5, -150, 0.5, -50)
        errorFrame.BackgroundColor3 = Color3.fromRGB(20, 40, 60)
        errorFrame.Parent = errorGui

        local errorCorner = Instance.new("UICorner")
        errorCorner.CornerRadius = UDim.new(0, 12)
        errorCorner.Parent = errorFrame

        local errorLabel = Instance.new("TextLabel")
        errorLabel.Size = UDim2.new(1, -20, 1, -20)
        errorLabel.Position = UDim2.new(0, 10, 0, 10)
        errorLabel.BackgroundTransparency = 1
        errorLabel.Text = "Failed to load error loading screen"
        errorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        errorLabel.TextScaled = true
        errorLabel.TextSize = 14
        errorLabel.Font = Enum.Font.Gotham
        errorLabel.TextWrapped = true
        errorLabel.Parent = errorFrame

        wait(5)
        errorGui:Destroy()
    end
end

local function loadLoadingScreen()
    local success, LoadingScreen = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/loadingscreen.lua"))()
    end)
    
    if not success then
        warn("Failed to load loading screen: " .. tostring(LoadingScreen))
        showErrorLoadingScreen()
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
        showErrorLoadingScreen()
        return false
    end
    
    return true, KeySystem
end

-- Main Execution
coroutine.wrap(function()
    local isSupported, scriptUrlOrError = checkGameSupport()
    
    local success, LoadingScreen = loadLoadingScreen()
    if not success then
        return
    end
    
    if isSupported then
        print("Game supported, showing key system")
        LoadingScreen.setLoadingText("Verifying key...", Color3.fromRGB(150, 180, 200))
        LoadingScreen.playEntranceAnimations()
        LoadingScreen.animatePulse()
        
        local success, KeySystem = loadKeySystem()
        if not success then
            return
        end
        
        KeySystem.showKeySystem()
        KeySystem.animateKeyPulse()
        
        while not KeySystem.keyVerified do
            wait(0.1)
        end
        
        print("Key verified, launching script")
        KeySystem.hideKeySystem()
        LoadingScreen.setLoadingText("Loading game script...", Color3.fromRGB(150, 180, 200))
        wait(1)
        
        local scriptLoaded = loadGameScript(scriptUrlOrError)
        
        if scriptLoaded then
            LoadingScreen.setLoadingText("Script loaded successfully!", Color3.fromRGB(100, 255, 100))
            wait(1)
            print("Scripts Hub X | Official - Loading Complete!")
        else
            LoadingScreen.setLoadingText("Failed to load script", Color3.fromRGB(255, 100, 100))
            wait(1)
            showErrorLoadingScreen()
        end
        LoadingScreen.playExitAnimations()
    else
        print("Game not supported")
        LoadingScreen.setLoadingText("Game not supported", Color3.fromRGB(255, 100, 100))
        LoadingScreen.playEntranceAnimations()
        wait(2)
        LoadingScreen.playExitAnimations()
        showErrorLoadingScreen()
    end
end)()

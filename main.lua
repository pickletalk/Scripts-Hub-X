-- Scripts Hub X | Official Main Script
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

local function showErrorNotification()
    local success, ErrorNotification = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/errorloadingscreen.lua"))()
    end)
    
    if not success then
        warn("Failed to load error notification: " .. tostring(ErrorNotification))
    end
end

coroutine.wrap(function()
    local success, LoadingScreen = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/loadingscreen.lua"))()
    end)
    
    if not success then
        warn("Failed to load loading screen: " .. tostring(LoadingScreen))
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        local playerGui = player:WaitForChild("PlayerGui", 5)
        if playerGui then
            LoadingScreen = {}
            LoadingScreen.showErrorGui = function(message)
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
                errorLabel.Text = message
                errorLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                errorLabel.TextScaled = true
                errorLabel.TextSize = 14
                errorLabel.Font = Enum.Font.Gotham
                errorLabel.TextWrapped = true
                errorLabel.Parent = errorFrame

                wait(5)
                errorGui:Destroy()
            end
            LoadingScreen.showErrorGui("Failed to load Scripts Hub X")
        end
        return
    end
    
    local isSupported, scriptUrlOrError = checkGameSupport()
    
    if not isSupported then
        print("Game not supported")
        LoadingScreen.setLoadingText("Checking game support...", Color3.fromRGB(150, 180, 200))
        LoadingScreen.playEntranceAnimations()
        LoadingScreen.animatePulse()
        wait(2)
        LoadingScreen.playExitAnimations()
        wait(0.1)
        showErrorNotification()
        return
    end
    
    print("Game supported, checking key")
    LoadingScreen.showKeySystem()
    LoadingScreen.animateKeyPulse()
    
    while not LoadingScreen.isKeyVerified() do
        wait(0.1)
    end
    
    print("Key verified, proceeding with loading")
    LoadingScreen.hideKeySystem()
    LoadingScreen.playEntranceAnimations()
    LoadingScreen.animateParticles()
    LoadingScreen.animatePulse()
    
    LoadingScreen.animateLoadingBar()
    print("Game supported! Loading Scripts Hub X...")
    
    wait(0.5)
    LoadingScreen.playExitAnimations()
    
    local scriptLoaded = loadGameScript(scriptUrlOrError)
    
    if scriptLoaded then
        print("Scripts Hub X | Official - Loading Complete!")
    else
        print("Scripts Hub X | Official - Script loading failed!")
        LoadingScreen.showErrorGui("Failed to load game script")
    end
end)()

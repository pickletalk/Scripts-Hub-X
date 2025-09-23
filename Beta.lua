-- Enhanced Steal-A-Brainrot UI System
-- Made by PickleTalk for Scripts Hub X

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local StarterPlayer = game:GetService("StarterPlayer")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local LocalPlayer = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Import existing functions from original script
local grappleHookConnection = nil
local antiKickEnabled = true

-- Configuration System
local CONFIG_FILE_NAME = "StealBrainrotConfig"
local defaultConfig = {
    tweenToBase = false,
    floorSteal = false,
    grappleSpeed = false,
    esp = false,
    baseTimeAlert = false,
    uiPosition = {0.5, -200, 0.2, 0},
    theme = "neon_blue"
}

local currentConfig = {}

-- UI State Management
local UIManager = {
    mainUI = nil,
    tweenUI = nil,
    floorStealUI = nil,
    grappleSpeedUI = nil,
    notifications = {},
    connections = {},
    tweens = {}
}

-- Color Theme
local Theme = {
    primary = Color3.fromRGB(0, 150, 255),      -- Neon Blue
    secondary = Color3.fromRGB(15, 25, 35),     -- Dark Background
    accent = Color3.fromRGB(0, 200, 255),       -- Bright Accent
    success = Color3.fromRGB(0, 255, 150),      -- Success Green
    warning = Color3.fromRGB(255, 200, 0),      -- Warning Yellow
    error = Color3.fromRGB(255, 100, 100),      -- Error Red
    text = Color3.fromRGB(255, 255, 255),       -- White Text
    textSecondary = Color3.fromRGB(180, 180, 180) -- Gray Text
}

-- Configuration Functions
local function saveConfig()
    local success, result = pcall(function()
        writefile(CONFIG_FILE_NAME .. ".json", HttpService:JSONEncode(currentConfig))
    end)
    if not success then
        warn("Failed to save config: " .. tostring(result))
    end
end

local function loadConfig()
    local success, result = pcall(function()
        if isfile(CONFIG_FILE_NAME .. ".json") then
            local data = readfile(CONFIG_FILE_NAME .. ".json")
            return HttpService:JSONDecode(data)
        end
        return nil
    end)
    
    if success and result then
        currentConfig = result
        -- Merge with defaults for missing keys
        for key, value in pairs(defaultConfig) do
            if currentConfig[key] == nil then
                currentConfig[key] = value
            end
        end
    else
        currentConfig = table.clone(defaultConfig)
    end
    saveConfig()
end

local function updateConfig(key, value)
    currentConfig[key] = value
    saveConfig()
end

-- Notification System
local function createNotification(text, duration, notificationType)
    duration = duration or 3
    notificationType = notificationType or "info"
    
    local playerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "StealBrainrotNotification"
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 300, 0, 60)
    frame.Position = UDim2.new(1, -320, 1, -80 - (#UIManager.notifications * 70))
    frame.BackgroundColor3 = Theme.secondary
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 4, 1, 0)
    accentBar.Position = UDim2.new(0, 0, 0, 0)
    accentBar.BorderSizePixel = 0
    accentBar.Parent = frame
    
    local accentColor = Theme.primary
    if notificationType == "success" then
        accentColor = Theme.success
    elseif notificationType == "warning" then
        accentColor = Theme.warning
    elseif notificationType == "error" then
        accentColor = Theme.error
    end
    accentBar.BackgroundColor3 = accentColor
    
    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 8)
    accentCorner.Parent = accentBar
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -20, 1, 0)
    textLabel.Position = UDim2.new(0, 15, 0, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = Theme.text
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = frame
    
    -- Slide in animation
    frame.Position = UDim2.new(1, 20, frame.Position.Y.Scale, frame.Position.Y.Offset)
    local slideIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
        {Position = UDim2.new(1, -320, frame.Position.Y.Scale, frame.Position.Y.Offset)})
    slideIn:Play()
    
    table.insert(UIManager.notifications, {gui = screenGui, frame = frame})
    
    -- Auto remove after duration
    task.spawn(function()
        task.wait(duration)
        local slideOut = TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), 
            {Position = UDim2.new(1, 20, frame.Position.Y.Scale, frame.Position.Y.Offset), BackgroundTransparency = 1})
        slideOut:Play()
        
        slideOut.Completed:Connect(function()
            for i, notif in ipairs(UIManager.notifications) do
                if notif.gui == screenGui then
                    table.remove(UIManager.notifications, i)
                    break
                end
            end
            screenGui:Destroy()
        end)
    end)
end

-- Import existing functions from the original script
local function equipGrappleHook()
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    
    if backpack and character then
        local grappleHook = backpack:FindFirstChild("Grapple Hook")
        if grappleHook and grappleHook:IsA("Tool") then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:EquipTool(grappleHook)
            end
        end
    end
end

local function fireGrappleHook()
    local args = {0.08707536856333414}
    
    local success, error = pcall(function()
        ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/UseItem"):FireServer(unpack(args))
    end)
    
    if not success then
        warn("Failed to fire grapple hook: " .. tostring(error))
    end
end

local function equipAndFireGrapple()
    fireGrappleHook()
    equipGrappleHook()
end

-- UI Creation Functions
local function createUIElement(elementType, properties, parent)
    local element = Instance.new(elementType)
    for prop, value in pairs(properties) do
        element[prop] = value
    end
    if parent then
        element.Parent = parent
    end
    return element
end

local function createButton(parent, text, size, position, callback)
    local button = createUIElement("TextButton", {
        Size = size or UDim2.new(0, 120, 0, 35),
        Position = position or UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Theme.primary,
        Text = text,
        TextColor3 = Theme.text,
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        BorderSizePixel = 0
    }, parent)
    
    local corner = createUIElement("UICorner", {
        CornerRadius = UDim.new(0, 6)
    }, button)
    
    -- Button animations
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.accent}):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2), {BackgroundColor3 = Theme.primary}):Play()
    end)
    
    if callback then
        button.MouseButton1Click:Connect(callback)
    end
    
    return button
end

local function createToggle(parent, text, size, position, defaultState, callback)
    local toggleFrame = createUIElement("Frame", {
        Size = size or UDim2.new(0, 200, 0, 40),
        Position = position or UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    }, parent)
    
    local label = createUIElement("TextLabel", {
        Size = UDim2.new(0.7, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = Theme.text,
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, toggleFrame)
    
    local toggleButton = createUIElement("Frame", {
        Size = UDim2.new(0, 50, 0, 25),
        Position = UDim2.new(1, -50, 0.5, -12.5),
        BackgroundColor3 = defaultState and Theme.success or Theme.secondary,
        BorderSizePixel = 0
    }, toggleFrame)
    
    local toggleCorner = createUIElement("UICorner", {
        CornerRadius = UDim.new(0, 12.5)
    }, toggleButton)
    
    local toggleCircle = createUIElement("Frame", {
        Size = UDim2.new(0, 19, 0, 19),
        Position = defaultState and UDim2.new(0, 28, 0, 3) or UDim2.new(0, 3, 0, 3),
        BackgroundColor3 = Theme.text,
        BorderSizePixel = 0
    }, toggleButton)
    
    local circleCorner = createUIElement("UICorner", {
        CornerRadius = UDim.new(0, 9.5)
    }, toggleCircle)
    
    local clickDetector = createUIElement("TextButton", {
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1,
        Text = ""
    }, toggleButton)
    
    local state = defaultState or false
    
    local function updateToggle()
        local bgColor = state and Theme.success or Theme.secondary
        local circlePos = state and UDim2.new(0, 28, 0, 3) or UDim2.new(0, 3, 0, 3)
        
        TweenService:Create(toggleButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {BackgroundColor3 = bgColor}):Play()
        TweenService:Create(toggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = circlePos}):Play()
    end
    
    clickDetector.MouseButton1Click:Connect(function()
        state = not state
        updateToggle()
        if callback then
            callback(state)
        end
    end)
    
    updateToggle()
    return toggleFrame, state
end

local function createSeparateUI(title, size, features)
    local screenGui = createUIElement("ScreenGui", {
        Name = "StealBrainrot" .. title:gsub(" ", ""),
        ResetOnSpawn = false
    }, player.PlayerGui)
    
    local mainFrame = createUIElement("Frame", {
        Size = size or UDim2.new(0, 300, 0, 200),
        Position = UDim2.new(0.5, -150, 0.5, -100),
        BackgroundColor3 = Theme.secondary,
        BorderSizePixel = 0
    }, screenGui)
    
    local corner = createUIElement("UICorner", {
        CornerRadius = UDim.new(0, 10)
    }, mainFrame)
    
    -- Make draggable
    local dragging, dragStart, startPos = false, nil, nil
    
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Title bar
    local titleBar = createUIElement("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Theme.primary,
        BorderSizePixel = 0
    }, mainFrame)
    
    local titleCorner = createUIElement("UICorner", {
        CornerRadius = UDim.new(0, 10)
    }, titleBar)
    
    local titleLabel = createUIElement("TextLabel", {
        Size = UDim2.new(1, -40, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Theme.text,
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, titleBar)
    
    local closeButton = createButton(titleBar, "×", UDim2.new(0, 30, 0, 30), UDim2.new(1, -35, 0, 5), function()
        local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
            {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)})
        closeTween:Play()
        closeTween.Completed:Connect(function()
            screenGui:Destroy()
        end)
    end)
    closeButton.BackgroundColor3 = Theme.error
    
    -- Content area
    local contentFrame = createUIElement("Frame", {
        Size = UDim2.new(1, -20, 1, -60),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundTransparency = 1
    }, mainFrame)
    
    -- Add features to content frame
    if features then
        features(contentFrame)
    end
    
    -- Entrance animation
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
        {Size = size or UDim2.new(0, 300, 0, 200), Position = UDim2.new(0.5, -150, 0.5, -100)})
    openTween:Play()
    
    return screenGui, mainFrame, contentFrame
end

-- Feature Functions
local tweenToBaseEnabled = false
local tweenConnection = nil

local function toggleTweenToBase(enabled)
    tweenToBaseEnabled = enabled
    updateConfig("tweenToBase", enabled)
    
    if enabled then
        UIManager.tweenUI = createSeparateUI("Tween To Base", UDim2.new(0, 350, 0, 250), function(content)
            local statusLabel = createUIElement("TextLabel", {
                Size = UDim2.new(1, 0, 0, 30),
                Position = UDim2.new(0, 0, 0, 10),
                BackgroundTransparency = 1,
                Text = "Status: Ready",
                TextColor3 = Theme.success,
                TextScaled = true,
                Font = Enum.Font.Gotham
            }, content)
            
            local startButton = createButton(content, "Start Tweening", UDim2.new(0, 150, 0, 40), UDim2.new(0, 0, 0, 60), function()
                createNotification("Tween to Base activated!", 2, "success")
                statusLabel.Text = "Status: Tweening to base..."
                statusLabel.TextColor3 = Theme.warning
                -- Add tween logic here from original script
            end)
            
            local stopButton = createButton(content, "Stop", UDim2.new(0, 150, 0, 40), UDim2.new(1, -150, 0, 60), function()
                createNotification("Tween stopped", 2, "info")
                statusLabel.Text = "Status: Ready"
                statusLabel.TextColor3 = Theme.success
            end)
            stopButton.BackgroundColor3 = Theme.error
        end)
        createNotification("Tween to Base UI opened", 2, "info")
    else
        if UIManager.tweenUI then
            UIManager.tweenUI:Destroy()
            UIManager.tweenUI = nil
            createNotification("Tween to Base UI closed", 2, "info")
        end
    end
end

local floorStealEnabled = false
local function toggleFloorSteal(enabled)
    floorStealEnabled = enabled
    updateConfig("floorSteal", enabled)
    
    if enabled then
        UIManager.floorStealUI = createSeparateUI("Floor Steal / Float", UDim2.new(0, 350, 0, 200), function(content)
            local floatButton = createButton(content, "Enable Float", UDim2.new(0, 150, 0, 40), UDim2.new(0, 0, 0, 20), function()
                createNotification("Float enabled!", 2, "success")
                -- Add float logic here from original script
            end)
            
            local stealButton = createButton(content, "Enable Floor Steal", UDim2.new(0, 150, 0, 40), UDim2.new(1, -150, 0, 20), function()
                createNotification("Floor steal enabled!", 2, "success")
                -- Add floor steal logic here from original script
            end)
        end)
        createNotification("Floor Steal UI opened", 2, "info")
    else
        if UIManager.floorStealUI then
            UIManager.floorStealUI:Destroy()
            UIManager.floorStealUI = nil
            createNotification("Floor Steal UI closed", 2, "info")
        end
    end
end

local grappleSpeedEnabled = false
local grappleSpeedConnection = nil

local function toggleGrappleSpeed(enabled)
    grappleSpeedEnabled = enabled
    updateConfig("grappleSpeed", enabled)
    
    if enabled then
        -- Set player speed to 100
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 100
        end
        
        -- Create small draggable UI button
        local screenGui = createUIElement("ScreenGui", {
            Name = "GrappleSpeedUI",
            ResetOnSpawn = false
        }, player.PlayerGui)
        
        local button = createButton(screenGui, "🎣", UDim2.new(0, 60, 0, 60), UDim2.new(0, 100, 0, 100), nil)
        button.TextScaled = true
        
        -- Make draggable
        local dragging, dragStart, startPos = false, nil, nil
        
        button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = button.Position
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                button.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
        
        UIManager.grappleSpeedUI = screenGui
        
        -- Start grapple loop
        grappleSpeedConnection = task.spawn(function()
            while grappleSpeedEnabled do
                equipAndFireGrapple()
                task.wait(3.1)
            end
        end)
        
        -- Anti-respawn protection
        local antiRespawnConnection = player.CharacterRemoving:Connect(function()
            if grappleSpeedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
                local humanoid = player.Character.Humanoid
                if humanoid.Health > 0 then
                    -- Server is trying to kill/respawn without setting health to 0
                    humanoid.Health = humanoid.MaxHealth
                    createNotification("Anti-respawn activated!", 2, "warning")
                end
            end
        end)
        
        table.insert(UIManager.connections, antiRespawnConnection)
        createNotification("Grapple Speed enabled! Speed set to 100", 3, "success")
    else
        if UIManager.grappleSpeedUI then
            UIManager.grappleSpeedUI:Destroy()
            UIManager.grappleSpeedUI = nil
        end
        
        if grappleSpeedConnection then
            task.cancel(grappleSpeedConnection)
            grappleSpeedConnection = nil
        end
        
        -- Reset player speed
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
        end
        
        createNotification("Grapple Speed disabled", 2, "info")
    end
end

local espEnabled = false
local function toggleESP(enabled)
    espEnabled = enabled
    updateConfig("esp", enabled)
    
    if enabled then
        createNotification("ESP enabled", 2, "success")
        -- Add ESP logic from original script
    else
        createNotification("ESP disabled", 2, "info")
        -- Remove ESP
    end
end

local baseTimeAlertEnabled = false
local function toggleBaseTimeAlert(enabled)
    baseTimeAlertEnabled = enabled
    updateConfig("baseTimeAlert", enabled)
    
    if enabled then
        createNotification("Base time alerts enabled", 2, "success")
        -- Add base time alert logic from original script
    else
        createNotification("Base time alerts disabled", 2, "info")
        -- Remove alerts
    end
end

-- Main UI Creation
local function createMainUI()
    local playerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = createUIElement("ScreenGui", {
        Name = "StealBrainrotMainUI",
        ResetOnSpawn = false
    }, playerGui)
    
    local mainFrame = createUIElement("Frame", {
        Size = UDim2.new(0, 400, 0, 300),
        Position = UDim2.new(currentConfig.uiPosition[1], currentConfig.uiPosition[2], currentConfig.uiPosition[3], currentConfig.uiPosition[4]),
        BackgroundColor3 = Theme.secondary,
        BorderSizePixel = 0
    }, screenGui)
    
    local corner = createUIElement("UICorner", {
        CornerRadius = UDim.new(0, 12)
    }, mainFrame)
    
    -- Make draggable and save position
    local dragging, dragStart, startPos = false, nil, nil
    
    local function updatePosition()
        local pos = mainFrame.Position
        updateConfig("uiPosition", {pos.X.Scale, pos.X.Offset, pos.Y.Scale, pos.Y.Offset})
    end
    
    mainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            if dragging then
                dragging = false
                updatePosition()
            end
        end
    end)
    
    -- Title bar
    local titleBar = createUIElement("Frame", {
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Theme.primary,
        BorderSizePixel = 0
    }, mainFrame)
    
    local titleCorner = createUIElement("UICorner", {
        CornerRadius = UDim.new(0, 12)
    }, titleBar)
    
    local titleText = createUIElement("TextLabel", {
        Size = UDim2.new(1, -100, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = "💰 Steal A Brainrot",
        TextColor3 = Theme.text,
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, titleBar)
    
    local minimizeButton = createButton(titleBar, "_", UDim2.new(0, 35, 0, 35), UDim2.new(1, -80, 0, 7.5), function()
        local isMinimized = mainFrame.Size.Y.Offset <= 60
        local targetSize = isMinimized and UDim2.new(0, 400, 0, 300) or UDim2.new(0, 400, 0, 50)
        TweenService:Create(mainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Size = targetSize}):Play()
    end)
    
    local closeButton = createButton(titleBar, "×", UDim2.new(0, 35, 0, 35), UDim2.new(1, -40, 0, 7.5), function()
        -- Confirmation popup
        local confirmGui = createUIElement("ScreenGui", {
            Name = "ConfirmClose",
            ResetOnSpawn = false
        }, playerGui)
        
        local confirmFrame = createUIElement("Frame", {
            Size = UDim2.new(0, 300, 0, 150),
            Position = UDim2.new(0.5, -150, 0.5, -75),
            BackgroundColor3 = Theme.secondary,
            BorderSizePixel = 0
        }, confirmGui)
        
        local confirmCorner = createUIElement("UICorner", {
            CornerRadius = UDim.new(0, 10)
        }, confirmFrame)
        
        local confirmText = createUIElement("TextLabel", {
            Size = UDim2.new(1, -20, 0.6, 0),
            Position = UDim2.new(0, 10, 0, 20),
            BackgroundTransparency = 1,
            Text = "Are you sure you want to close Steal A Brainrot?",
            TextColor3 = Theme.text,
            TextScaled = true,
            Font = Enum.Font.Gotham
        }, confirmFrame)
        
        local yesButton = createButton(confirmFrame, "Yes", UDim2.new(0, 80, 0, 35), UDim2.new(0, 50, 0.7, 0), function()
            -- Cleanup all UIs and connections
            for _, connection in pairs(UIManager.connections) do
                if connection and connection.Connected then
                    connection:Disconnect()
                end
            end
            
            if UIManager.tweenUI then UIManager.tweenUI:Destroy() end
            if UIManager.floorStealUI then UIManager.floorStealUI:Destroy() end
            if UIManager.grappleSpeedUI then UIManager.grappleSpeedUI:Destroy() end
            
            if grappleSpeedConnection then
                task.cancel(grappleSpeedConnection)
            end
            
            -- Close animation
            local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), 
                {Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0)})
            closeTween:Play()
            closeTween.Completed:Connect(function()
                screenGui:Destroy()
                confirmGui:Destroy()
                createNotification("Steal A Brainrot closed", 2, "info")
            end)
        end)
        yesButton.BackgroundColor3 = Theme.error
        
        local noButton = createButton(confirmFrame, "No", UDim2.new(0, 80, 0, 35), UDim2.new(1, -130, 0.7, 0), function()
            confirmGui:Destroy()
        end)
        
        -- Popup animation
        confirmFrame.Size = UDim2.new(0, 0, 0, 0)
        local popupTween = TweenService:Create(confirmFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
            {Size = UDim2.new(0, 300, 0, 150)})
        popupTween:Play()
    end)
    closeButton.BackgroundColor3 = Theme.error
    
    -- Tab system
    local tabFrame = createUIElement("Frame", {
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 60),
        BackgroundTransparency = 1
    }, mainFrame)
    
    local mainTab = createButton(tabFrame, "Main", UDim2.new(0.33, -5, 1, 0), UDim2.new(0, 0, 0, 0), nil)
    local visualTab = createButton(tabFrame, "Visual", UDim2.new(0.33, -5, 1, 0), UDim2.new(0.33, 2.5, 0, 0), nil)
    local creditsTab = createButton(tabFrame, "Credits", UDim2.new(0.34, -5, 1, 0), UDim2.new(0.66, 5, 0, 0), nil)
    
    -- Content frames
    local mainContent = createUIElement("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -120),
        Position = UDim2.new(0, 10, 0, 110),
        BackgroundTransparency = 1,
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = Theme.primary,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y
    }, mainFrame)
    
    local visualContent = createUIElement("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -120),
        Position = UDim2.new(0, 10, 0, 110),
        BackgroundTransparency = 1,
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = Theme.primary,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false
    }, mainFrame)
    
    local creditsContent = createUIElement("ScrollingFrame", {
        Size = UDim2.new(1, -20, 1, -120),
        Position = UDim2.new(0, 10, 0, 110),
        BackgroundTransparency = 1,
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = Theme.primary,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        Visible = false
    }, mainFrame)
    
    -- Tab switching
    local currentTab = "main"
    local function switchTab(tabName)
        currentTab = tabName
        
        -- Reset tab colors
        mainTab.BackgroundColor3 = Theme.primary
        visualTab.BackgroundColor3 = Theme.primary
        creditsTab.BackgroundColor3 = Theme.primary
        
        -- Hide all content
        mainContent.Visible = false
        visualContent.Visible = false
        creditsContent.Visible = false
        
        -- Show selected content and highlight tab
        if tabName == "main" then
            mainContent.Visible = true
            mainTab.BackgroundColor3 = Theme.accent
        elseif tabName == "visual" then
            visualContent.Visible = true
            visualTab.BackgroundColor3 = Theme.accent
        elseif tabName == "credits" then
            creditsContent.Visible = true
            creditsTab.BackgroundColor3 = Theme.accent
        end
    end
    
    mainTab.MouseButton1Click:Connect(function() switchTab("main") end)
    visualTab.MouseButton1Click:Connect(function() switchTab("visual") end)
    creditsTab.MouseButton1Click:Connect(function() switchTab("credits") end)
    
    -- Main Tab Content
    local stealHelperLabel = createUIElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 10),
        BackgroundTransparency = 1,
        Text = "🎯 Steal Helper",
        TextColor3 = Theme.primary,
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Left
    }, mainContent)
    
    local tweenToggle, tweenState = createToggle(mainContent, "Tween To Base", UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 50), 
        currentConfig.tweenToBase, toggleTweenToBase)
    
    local floorToggle, floorState = createToggle(mainContent, "Floor Steal / Float", UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 100), 
        currentConfig.floorSteal, toggleFloorSteal)
    
    local grappleToggle, grappleState = createToggle(mainContent, "Grapple Speed", UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 150), 
        currentConfig.grappleSpeed, toggleGrappleSpeed)
    
    -- Visual Tab Content
    local espToggle, espState = createToggle(visualContent, "ESP", UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 20), 
        currentConfig.esp, toggleESP)
    
    local alertToggle, alertState = createToggle(visualContent, "Base Time Alert", UDim2.new(1, 0, 0, 40), UDim2.new(0, 0, 0, 70), 
        currentConfig.baseTimeAlert, toggleBaseTimeAlert)
    
    -- Credits Tab Content
    local creditsLabel = createUIElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 40),
        Position = UDim2.new(0, 0, 0, 20),
        BackgroundTransparency = 1,
        Text = "Scripts Hub X | Official",
        TextColor3 = Theme.text,
        TextScaled = true,
        Font = Enum.Font.GothamBold,
        TextXAlignment = Enum.TextXAlignment.Center
    }, creditsContent)
    
    local madeByLabel = createUIElement("TextLabel", {
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 70),
        BackgroundTransparency = 1,
        Text = "UI made by PickleTalk",
        TextColor3 = Theme.textSecondary,
        TextScaled = true,
        Font = Enum.Font.Gotham,
        TextXAlignment = Enum.TextXAlignment.Center
    }, creditsContent)
    
    local discordButton = createButton(creditsContent, "Join Discord", UDim2.new(0, 200, 0, 45), UDim2.new(0.5, -100, 0, 120), function()
        local success = pcall(function()
            setclipboard("https://discord.gg/bpsNUH5sVb")
        end)
        if success then
            createNotification("Discord invite copied to clipboard!", 3, "success")
        else
            createNotification("Failed to copy invite", 2, "error")
        end
    end)
    discordButton.BackgroundColor3 = Color3.fromRGB(114, 137, 218) -- Discord blue
    
    -- Initialize with main tab
    switchTab("main")
    
    UIManager.mainUI = screenGui
    
    -- Entrance animation
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    local openTween = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), 
        {Size = UDim2.new(0, 400, 0, 300), Position = UDim2.new(currentConfig.uiPosition[1], currentConfig.uiPosition[2], 
         currentConfig.uiPosition[3], currentConfig.uiPosition[4])})
    openTween:Play()
    
    createNotification("Steal A Brainrot loaded successfully! 💰", 4, "success")
end

-- Anti-kick and anti-respawn system
local function initAntiSystems()
    -- Anti-kick protection (simplified from original)
    local oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if method == "Kick" and self == player then
            createNotification("🛡️ Kick attempt blocked!", 3, "warning")
            return nil
        end
        
        if method == "FireServer" or method == "InvokeServer" then
            local remoteName = self.Name or ""
            if string.find(string.lower(remoteName), "kick") or 
               string.find(string.lower(remoteName), "ban") or 
               string.find(string.lower(remoteName), "remove") then
                createNotification("🛡️ Malicious remote blocked!", 3, "warning")
                return nil
            end
        end
        
        return oldNamecall(self, ...)
    end)
    
    -- Character respawn handling
    player.CharacterAdded:Connect(function(newCharacter)
        character = newCharacter
        humanoid = newCharacter:WaitForChild("Humanoid")
        rootPart = newCharacter:WaitForChild("HumanoidRootPart")
        
        -- Restore grapple speed if enabled
        if grappleSpeedEnabled then
            task.wait(1)
            humanoid.WalkSpeed = 100
            createNotification("Speed restored after respawn", 2, "info")
        end
    end)
    
    -- Health protection for anti-respawn
    local healthConnection = RunService.Heartbeat:Connect(function()
        if grappleSpeedEnabled and player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            if humanoid.Health <= 0 and humanoid.MaxHealth > 0 then
                -- Unexpected death - restore health
                humanoid.Health = humanoid.MaxHealth
                createNotification("🛡️ Anti-respawn activated!", 2, "warning")
            end
        end
    end)
    
    table.insert(UIManager.connections, healthConnection)
end

-- Initialize everything
local function initialize()
    loadConfig()
    initAntiSystems()
    
    task.wait(1) -- Wait for player to load
    
    createMainUI()
    
    -- Auto-restore states from config
    if currentConfig.tweenToBase then
        toggleTweenToBase(true)
    end
    if currentConfig.floorSteal then
        toggleFloorSteal(true)
    end
    if currentConfig.grappleSpeed then
        toggleGrappleSpeed(true)
    end
    if currentConfig.esp then
        toggleESP(true)
    end
    if currentConfig.baseTimeAlert then
        toggleBaseTimeAlert(true)
    end
end

-- Cleanup function
local function cleanup()
    for _, connection in pairs(UIManager.connections) do
        if connection and connection.Connected then
            connection:Disconnect()
        end
    end
    
    for _, tween in pairs(UIManager.tweens) do
        if tween then
            tween:Cancel()
        end
    end
    
    if grappleSpeedConnection then
        task.cancel(grappleSpeedConnection)
    end
    
    -- Reset player speed
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16
    end
end

-- Handle player leaving
game:BindToClose(cleanup)
Players.PlayerRemoving:Connect(function(leavingPlayer)
    if leavingPlayer == player then
        cleanup()
    end
end)

-- Error handling
local success, error = pcall(initialize)
if not success then
    warn("Failed to initialize Steal A Brainrot UI: " .. tostring(error))
    createNotification("Failed to load UI: " .. tostring(error), 5, "error")
end

createNotification("Press Right Control(right ctrl) to toggle the ui", 3, "Toggle Ui")

-- Key binding for quick toggle (Optional)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.RightControl then
        if UIManager.mainUI then
            local isVisible = UIManager.mainUI.Enabled
            UIManager.mainUI.Enabled = not isVisible
            createNotification(isVisible and "UI Hidden" or "UI Shown", 1, "info")
        end
    end
end)

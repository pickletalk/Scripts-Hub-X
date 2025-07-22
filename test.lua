-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Player
local player = Players.LocalPlayer
local mouse = player:GetMouse()

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptsHubX"
screenGui.Parent = player.PlayerGui

-- Configuration
local configFile = "config_" .. player.UserId .. ".txt"
local config = {}
local toggles = {}
local connections = {}
local featureFunctions = {}

-- Features list
local features = {
    "Infinite Jump", "Fly", "Anti-AFK", "Touch Fling", "Noclip", "Click Teleport", "Speed Hack", "ESP", "God Mode", "Super Jump", "Invisible"
}

-- Create Loading Screen
local loadingScreen = Instance.new("Frame")
loadingScreen.Name = "LoadingScreen"
loadingScreen.Size = UDim2.new(1, 0, 1, 0)
loadingScreen.BackgroundColor3 = Color3.new(0, 0, 0)
loadingScreen.Parent = screenGui

local loadingText = Instance.new("TextLabel")
loadingText.Name = "LoadingText"
loadingText.Size = UDim2.new(0.5, 0, 0.1, 0)
loadingText.Position = UDim2.new(0.25, 0, 0.45, 0)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading..."
loadingText.TextColor3 = Color3.new(1, 1, 1)
loadingText.TextScaled = true
loadingText.Parent = loadingScreen

-- Define Highlight function first
local function addHighlight(element, isTab)
    local stroke = Instance.new("UIStroke")
    stroke.Name = "Highlight"
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Transparency = 1
    stroke.Parent = element

    if isTab then
        if element.BackgroundColor3 == Color3.fromRGB(70, 70, 70) then
            stroke.Transparency = 0
        end
        element:GetPropertyChangedSignal("BackgroundColor3"):Connect(function()
            stroke.Transparency = element.BackgroundColor3 == Color3.fromRGB(70, 70, 70) and 0 or 1
        end)
    else
        element.MouseEnter:Connect(function()
            stroke.Transparency = 0
        end)
        element.MouseLeave:Connect(function()
            stroke.Transparency = 1
        end)
    end
end

-- Handle config during loading screen
if readfile then
    local success, data = pcall(readfile, configFile)
    if success and data then
        -- Parse existing config
        local parts = data:split("|")
        if #parts >= 1 then
            local colorParts = parts[1]:split(",")
            if #colorParts == 3 then
                config.color = Color3.fromRGB(tonumber(colorParts[1]), tonumber(colorParts[2]), tonumber(colorParts[3]))
            end
        end
        if #parts >= 2 then
            local featureStates = parts[2]:split(",")
            for _, fs in pairs(featureStates) do
                local fParts = fs:split(":")
                if #fParts == 2 then
                    config[fParts[1]] = fParts[2] == "true"
                end
            end
        end
        if #parts >= 3 then
            config.transparency = tonumber(parts[3]) or 0
        end
    else
        -- Create config with defaults if writefile is available
        if writefile then
            local defaultColorStr = "50,50,50"
            local defaultFeatureStr = ""
            for _, feature in ipairs(features) do
                defaultFeatureStr = defaultFeatureStr .. feature .. ":false,"
            end
            defaultFeatureStr = defaultFeatureStr:sub(1, -2)
            local defaultTransparencyStr = "0"
            local defaultData = defaultColorStr .. "|" .. defaultFeatureStr .. "|" .. defaultTransparencyStr
            pcall(writefile, configFile, defaultData)
            -- Set default config
            config.color = Color3.fromRGB(50, 50, 50)
            config.transparency = 0
            for _, feature in ipairs(features) do
                config[feature] = false
            end
        else
            warn("Cannot create config file, using defaults")
            config.color = Color3.fromRGB(50, 50, 50)
            config.transparency = 0
            for _, feature in ipairs(features) do
                config[feature] = false
            end
        end
    end
else
    warn("readfile not available, using defaults")
    config.color = Color3.fromRGB(50, 50, 50)
    config.transparency = 0
    for _, feature in ipairs(features) do
        config[feature] = false
    end
end

-- Create Window Frame with loaded config
local window = Instance.new("Frame")
window.Name = "Window"
window.Size = UDim2.new(0, 300, 0, 400)
window.Position = UDim2.new(0.5, -150, 0.5, -200)
window.BackgroundColor3 = config.color or Color3.fromRGB(50, 50, 50)
window.BackgroundTransparency = config.transparency or 0
window.Visible = false
window.Parent = screenGui

local windowCorner = Instance.new("UICorner")
windowCorner.CornerRadius = UDim.new(0, 10)
windowCorner.Parent = window

-- Create TitleBar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.Parent = window

local titleBarCorner = Instance.new("UICorner")
titleBarCorner.CornerRadius = UDim.new(0, 5)
titleBarCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, -90, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Scripts Hub X | official"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextSize = 18
titleText.Parent = titleBar

local minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -60, 0, 0)
minimizeButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Parent = titleBar

local minimizeButtonCorner = Instance.new("UICorner")
minimizeButtonCorner.CornerRadius = UDim.new(0, 5)
minimizeButtonCorner.Parent = minimizeButton

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = titleBar

local closeButtonCorner = Instance.new("UICorner")
closeButtonCorner.CornerRadius = UDim.new(0, 5)
closeButtonCorner.Parent = closeButton

-- Create Tabs
local tabs = Instance.new("Frame")
tabs.Name = "Tabs"
tabs.Size = UDim2.new(1, 0, 0, 30)
tabs.Position = UDim2.new(0, 0, 0, 30)
tabs.BackgroundTransparency = 1
tabs.Parent = window

local featuresTab = Instance.new("TextButton")
featuresTab.Name = "FeaturesTab"
featuresTab.Size = UDim2.new(0.5, 0, 1, 0)
featuresTab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
featuresTab.Text = "Features"
featuresTab.TextColor3 = Color3.fromRGB(255, 255, 255)
featuresTab.Parent = tabs

local featuresTabCorner = Instance.new("UICorner")
featuresTabCorner.CornerRadius = UDim.new(0, 3)
featuresTabCorner.Parent = featuresTab

local settingsTab = Instance.new("TextButton")
settingsTab.Name = "SettingsTab"
settingsTab.Size = UDim2.new(0.5, 0, 1, 0)
settingsTab.Position = UDim2.new(0.5, 0, 0, 0)
settingsTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
settingsTab.Text = "Settings"
settingsTab.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsTab.Parent = tabs

local settingsTabCorner = Instance.new("UICorner")
settingsTabCorner.CornerRadius = UDim.new(0, 3)
settingsTabCorner.Parent = settingsTab

-- Create Content
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, 0, 1, -60)
content.Position = UDim2.new(0, 0, 0, 60)
content.BackgroundTransparency = 1
content.ClipsDescendants = true
content.Parent = window

local featuresContent = Instance.new("Frame")
featuresContent.Name = "FeaturesContent"
featuresContent.Size = UDim2.new(1, 0, 1, 0)
featuresContent.BackgroundTransparency = 1
featuresContent.Visible = true
featuresContent.Parent = content

local settingsContent = Instance.new("Frame")
settingsContent.Name = "SettingsContent"
settingsContent.Size = UDim2.new(1, 0, 1, 0)
settingsContent.BackgroundTransparency = 1
settingsContent.Visible = false
settingsContent.Parent = content

-- Add UIListLayout to FeaturesContent
local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Padding = UDim.new(0, 5)
uiListLayout.Parent = featuresContent

-- Function to create toggle buttons
local function createToggleButton(name)
    local button = Instance.new("TextButton")
    button.Name = name
    button.Size = UDim2.new(1, 0, 0, 30)
    button.BackgroundColor3 = toggles[name] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
    button.Text = name
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Parent = featuresContent

    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 5)
    buttonCorner.Parent = button

    addHighlight(button, false)

    button.MouseButton1Click:Connect(function()
        toggles[name] = not toggles[name]
        button.BackgroundColor3 = toggles[name] and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(100, 100, 100)
        if featureFunctions[name] then
            featureFunctions[name](toggles[name])
        end
        saveConfig()
    end)
    return button
end

-- Create toggle buttons with loaded config
for _, feature in ipairs(features) do
    toggles[feature] = config[feature] or false
    createToggleButton(feature)
end

-- Initialize features
for feature, state in pairs(toggles) do
    if featureFunctions[feature] then
        featureFunctions[feature](state)
    end
end

-- Add color picker and transparency to SettingsContent
local colorLabel = Instance.new("TextLabel")
colorLabel.Name = "ColorLabel"
colorLabel.Size = UDim2.new(1, 0, 0, 30)
colorLabel.BackgroundTransparency = 1
colorLabel.Text = "UI Color (R, G, B):"
colorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
colorLabel.TextSize = 18
colorLabel.Parent = settingsContent

local rBox = Instance.new("TextBox")
rBox.Name = "RBox"
rBox.Size = UDim2.new(0.3, 0, 0, 30)
rBox.Position = UDim2.new(0, 0, 0, 30)
rBox.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
rBox.Text = config.color and tostring(math.floor(config.color.R * 255)) or "50"
rBox.Parent = settingsContent

local rBoxCorner = Instance.new("UICorner")
rBoxCorner.CornerRadius = UDim.new(0, 5)
rBoxCorner.Parent = rBox

local gBox = Instance.new("TextBox")
gBox.Name = "GBox"
gBox.Size = UDim2.new(0.3, 0, 0, 30)
gBox.Position = UDim2.new(0.35, 0, 0, 30)
gBox.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
gBox.Text = config.color and tostring(math.floor(config.color.G * 255)) or "50"
gBox.Parent = settingsContent

local gBoxCorner = Instance.new("UICorner")
gBoxCorner.CornerRadius = UDim.new(0, 5)
gBoxCorner.Parent = gBox

local bBox = Instance.new("TextBox")
bBox.Name = "BBox"
bBox.Size = UDim2.new(0.3, 0, 0, 30)
bBox.Position = UDim2.new(0.7, 0, 0, 30)
bBox.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
bBox.Text = config.color and tostring(math.floor(config.color.B * 255)) or "50"
bBox.Parent = settingsContent

local bBoxCorner = Instance.new("UICorner")
bBoxCorner.CornerRadius = UDim.new(0, 5)
bBoxCorner.Parent = bBox

local applyButton = Instance.new("TextButton")
applyButton.Name = "ApplyButton"
applyButton.Size = UDim2.new(0.5, 0, 0, 30)
applyButton.Position = UDim2.new(0.25, 0, 0, 70)
applyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
applyButton.Text = "Apply"
applyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
applyButton.Parent = settingsContent

local applyButtonCorner = Instance.new("UICorner")
applyButtonCorner.CornerRadius = UDim.new(0, 5)
applyButtonCorner.Parent = applyButton

local transparencyLabel = Instance.new("TextLabel")
transparencyLabel.Name = "TransparencyLabel"
transparencyLabel.Size = UDim2.new(1, 0, 0, 30)
transparencyLabel.Position = UDim2.new(0, 0, 0, 110)
transparencyLabel.BackgroundTransparency = 1
transparencyLabel.Text = "UI Transparency (0-1):"
transparencyLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
transparencyLabel.TextSize = 18
transparencyLabel.Parent = settingsContent

local transparencyBox = Instance.new("TextBox")
transparencyBox.Name = "TransparencyBox"
transparencyBox.Size = UDim2.new(0.3, 0, 0, 30)
transparencyBox.Position = UDim2.new(0, 0, 0, 140)
transparencyBox.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
transparencyBox.Text = tostring(config.transparency or 0)
transparencyBox.Parent = settingsContent

local transparencyBoxCorner = Instance.new("UICorner")
transparencyBoxCorner.CornerRadius = UDim.new(0, 5)
transparencyBoxCorner.Parent = transparencyBox

local applyTransparencyButton = Instance.new("TextButton")
applyTransparencyButton.Name = "ApplyTransparencyButton"
applyTransparencyButton.Size = UDim2.new(0.5, 0, 0, 30)
applyTransparencyButton.Position = UDim2.new(0.25, 0, 0, 180)
applyTransparencyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
applyTransparencyButton.Text = "Apply Transparency"
applyTransparencyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
applyTransparencyButton.Parent = settingsContent

local applyTransparencyButtonCorner = Instance.new("UICorner")
applyTransparencyButtonCorner.CornerRadius = UDim.new(0, 5)
applyTransparencyButtonCorner.Parent = applyTransparencyButton

-- Create Confirmation Dialog
local confirmDialog = Instance.new("Frame")
confirmDialog.Name = "ConfirmDialog"
confirmDialog.Size = UDim2.new(0, 200, 0, 100)
confirmDialog.Position = UDim2.new(0.5, -100, 0.5, -50)
confirmDialog.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
confirmDialog.Visible = false
confirmDialog.Parent = screenGui

local confirmText = Instance.new("TextLabel")
confirmText.Name = "ConfirmText"
confirmText.Size = UDim2.new(1, 0, 0.5, 0)
confirmText.BackgroundTransparency = 1
confirmText.Text = "Are you sure you want to close?"
confirmText.TextColor3 = Color3.fromRGB(255, 255, 255)
confirmText.TextSize = 18
confirmText.Parent = confirmDialog

local yesButton = Instance.new("TextButton")
yesButton.Name = "YesButton"
yesButton.Size = UDim2.new(0.4, 0, 0.3, 0)
yesButton.Position = UDim2.new(0.1, 0, 0.6, 0)
yesButton.BackgroundColor3 = Color3.fromRGB(0, 200, 0)
yesButton.Text = "Yes"
yesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
yesButton.Parent = confirmDialog
yesButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

local noButton = Instance.new("TextButton")
noButton.Name = "NoButton"
noButton.Size = UDim2.new(0.4, 0, 0.3, 0)
noButton.Position = UDim2.new(0.5, 0, 0.6, 0)
noButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
noButton.Text = "No"
noButton.TextColor3 = Color3.fromRGB(255, 255, 255)
noButton.Parent = confirmDialog
noButton.MouseButton1Click:Connect(function()
    confirmDialog.Visible = false
end)

-- Dragging functionality
local dragging = false
local offset

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        offset = window.Position - UDim2.new(0, mouse.X, 0, mouse.Y)
    end
end)

titleBar.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

RunService.RenderStepped:Connect(function()
    if dragging then
        window.Position = UDim2.new(0, mouse.X, 0, mouse.Y) + offset
    end
end)

-- Minimize button functionality
local isMinimized = false
local normalSize = UDim2.new(0, 300, 0, 400)
local minimizedSize = UDim2.new(0, 300, 0, 30)

minimizeButton.MouseButton1Click:Connect(function()
    if isMinimized then
        window.Size = normalSize
        isMinimized = false
    else
        window.Size = minimizedSize
        isMinimized = true
    end
end)

-- Close button functionality
closeButton.MouseButton1Click:Connect(function()
    confirmDialog.Visible = true
end)

-- Smooth tab switching
local function switchToFeaturesTab()
    if not featuresContent.Visible then
        settingsContent.Visible = true
        local tweenOut = TweenService:Create(settingsContent, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(-1, 0, 0, 0)})
        tweenOut:Play()
        featuresContent.Position = UDim2.new(1, 0, 0, 0)
        featuresContent.Visible = true
        local tweenIn = TweenService:Create(featuresContent, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})
        tweenIn:Play()
        tweenIn.Completed:Connect(function()
            settingsContent.Visible = false
            settingsContent.Position = UDim2.new(0, 0, 0, 0)
        end)
        featuresTab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        settingsTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    end
end

local function switchToSettingsTab()
    if not settingsContent.Visible then
        featuresContent.Visible = true
        local tweenOut = TweenService:Create(featuresContent, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(-1, 0, 0, 0)})
        tweenOut:Play()
        settingsContent.Position = UDim2.new(1, 0, 0, 0)
        settingsContent.Visible = true
        local tweenIn = TweenService:Create(settingsContent, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.new(0, 0, 0, 0)})
        tweenIn:Play()
        tweenIn.Completed:Connect(function()
            featuresContent.Visible = false
            featuresContent.Position = UDim2.new(0, 0, 0, 0)
        end)
        featuresTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        settingsTab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    end
end

featuresTab.MouseButton1Click:Connect(switchToFeaturesTab)
settingsTab.MouseButton1Click:Connect(switchToSettingsTab)

-- Apply color change
applyButton.MouseButton1Click:Connect(function()
    local r = tonumber(rBox.Text)
    local g = tonumber(gBox.Text)
    local b = tonumber(bBox.Text)
    if r and g and b and r >= 0 and r <= 255 and g >= 0 and g <= 255 and b >= 0 and b <= 255 then
        window.BackgroundColor3 = Color3.fromRGB(r, g, b)
        config.color = window.BackgroundColor3
        saveConfig()
    else
        print("Invalid color values")
    end
end)

-- Apply transparency
applyTransparencyButton.MouseButton1Click:Connect(function()
    local transparency = tonumber(transparencyBox.Text)
    if transparency and transparency >= 0 and transparency <= 1 then
        window.BackgroundTransparency = transparency
        config.transparency = transparency
        saveConfig()
    else
        print("Invalid transparency value")
    end
end)

-- Feature implementations
featureFunctions["Infinite Jump"] = function(state)
    if state then
        connections["Infinite Jump"] = UserInputService.JumpRequest:Connect(function()
            local character = player.Character
            if character and character:FindFirstChild("Humanoid") then
                character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    else
        if connections["Infinite Jump"] then
            connections["Infinite Jump"]:Disconnect()
            connections["Infinite Jump"] = nil
        end
    end
end

featureFunctions["Fly"] = function(state)
    if state then
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local flyVelocity = Instance.new("BodyVelocity")
            flyVelocity.Velocity = Vector3.new(0, 0, 0)
            flyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
            flyVelocity.Parent = character.HumanoidRootPart
            connections["Fly"] = RunService.RenderStepped:Connect(function()
                if toggles["Fly"] then
                    local moveDirection = character.Humanoid.MoveDirection
                    flyVelocity.Velocity = moveDirection * 50
                else
                    flyVelocity:Destroy()
                    connections["Fly"]:Disconnect()
                end
            end)
        end
    else
        if connections["Fly"] then
            connections["Fly"]:Disconnect()
            connections["Fly"] = nil
        end
    end
end

featureFunctions["Anti-AFK"] = function(state)
    if state then
        coroutine.wrap(function()
            while toggles["Anti-AFK"] do
                wait(900)
                local character = player.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame + Vector3.new(0.1, 0, 0)
                    wait(0.1)
                    character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame - Vector3.new(0.1, 0, 0)
                end
            end
        end)()
    end
end

featureFunctions["Touch Fling"] = function(state)
    if state then
        local character = player.Character
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    connections[part] = part.Touched:Connect(function(hit)
                        if hit.Parent and hit.Parent ~= character and hit.Parent:FindFirstChild("Humanoid") then
                            local bv = Instance.new("BodyVelocity")
                            bv.Velocity = character.HumanoidRootPart.CFrame.lookVector * 100
                            bv.MaxForce = Vector3.new(40000, 40000, 40000)
                            bv.Parent = hit
                            game:GetService("Debris"):AddItem(bv, 0.1)
                        end
                    end)
                end
            end
        end
    else
        for part, conn in pairs(connections) do
            if type(conn) == "RBXScriptConnection" then
                conn:Disconnect()
            end
        end
        connections = {}
    end
end

featureFunctions["Noclip"] = function(state)
    if state then
        coroutine.wrap(function()
            while toggles["Noclip"] do
                local character = player.Character
                if character then
                    for _, part in pairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
                wait()
            end
        end)()
    else
        local character = player.Character
        if character then
            for _, part in pairs(character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

featureFunctions["Click Teleport"] = function(state)
    if state then
        connections["Click Teleport"] = mouse.Button1Down:Connect(function()
            local character = player.Character
            if character and character:FindFirstChild("HumanoidRootPart") then
                character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.p + Vector3.new(0, 3, 0))
            end
        end)
    else
        if connections["Click Teleport"] then
            connections["Click Teleport"]:Disconnect()
            connections["Click Teleport"] = nil
        end
    end
end

featureFunctions["Speed Hack"] = function(state)
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        if state then
            character.Humanoid.WalkSpeed = 100
        else
            character.Humanoid.WalkSpeed = 16
        end
    end
end

featureFunctions["ESP"] = function(state)
    if state then
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer ~= player and otherPlayer.Character then
                local highlight = Instance.new("Highlight")
                highlight.Parent = otherPlayer.Character
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            end
        end
        connections["ESP PlayerAdded"] = Players.PlayerAdded:Connect(function(newPlayer)
            newPlayer.CharacterAdded:Connect(function(character)
                local highlight = Instance.new("Highlight")
                highlight.Parent = character
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            end)
        end)
    else
        for _, otherPlayer in pairs(Players:GetPlayers()) do
            if otherPlayer.Character then
                local highlight = otherPlayer.Character:FindFirstChild("Highlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
        if connections["ESP PlayerAdded"] then
            connections["ESP PlayerAdded"]:Disconnect()
            connections["ESP PlayerAdded"] = nil
        end
    end
end

featureFunctions["God Mode"] = function(state)
    if state then
        local character = player.Character
        if character and character:FindFirstChild("Humanoid") then
            connections["God Mode"] = character.Humanoid.HealthChanged:Connect(function(health)
                if health < character.Humanoid.MaxHealth then
                    character.Humanoid.Health = character.Humanoid.MaxHealth
                end
            end)
        end
    else
        if connections["God Mode"] then
            connections["God Mode"]:Disconnect()
            connections["God Mode"] = nil
        end
    end
end

featureFunctions["Super Jump"] = function(state)
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        if state then
            character.Humanoid.JumpPower = 100
        else
            character.Humanoid.JumpPower = 50
        end
    end
end

featureFunctions["Invisible"] = function(state)
    local character = player.Character
    if character then
        for _, part in pairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                if state then
                    part.Transparency = 1
                else
                    part.Transparency = 0
                end
            end
        end
    end
end

-- Save configuration with transparency
function saveConfig()
    local colorStr = string.format("%d,%d,%d", math.floor(config.color.R * 255), math.floor(config.color.G * 255), math.floor(config.color.B * 255))
    local featureStr = ""
    for feature, state in pairs(toggles) do
        featureStr = featureStr .. feature .. ":" .. tostring(state) .. ","
    end
    featureStr = featureStr:sub(1, -2)
    local data = colorStr .. "|" .. featureStr .. "|" .. tostring(config.transparency or 0)
    if writefile then
        local success, err = pcall(writefile, configFile, data)
        if not success then
            warn("Failed to write config: " .. tostring(err))
        end
    else
        warn("writefile not available")
    end
end

-- String split function
function string.split(str, sep)
    local result = {}
    for part in str:gmatch("[^" .. sep .. "]+") do
        table.insert(result, part)
    end
    return result
end

-- Apply highlights
addHighlight(featuresTab, true)
addHighlight(settingsTab, true)
addHighlight(minimizeButton, false)
addHighlight(closeButton, false)
addHighlight(applyButton, false)
addHighlight(applyTransparencyButton, false)

-- Tween loading screen and destroy it
local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local goal = {Position = UDim2.new(0, 0, -1, 0)}
local tween = TweenService:Create(loadingScreen, tweenInfo, goal)
tween:Play()
tween.Completed:Connect(function()
    loadingScreen:Destroy()
    window.Visible = true
end)

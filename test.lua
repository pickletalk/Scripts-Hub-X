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

-- Load configuration if exists
if readfile and readfile(configFile) then
    local data = readfile(configFile)
    local parts = data:split("|")
    if #parts == 2 then
        local colorParts = parts[1]:split(",")
        if #colorParts == 3 then
            config.color = Color3.fromRGB(tonumber(colorParts[1]), tonumber(colorParts[2]), tonumber(colorParts[3]))
        end
        local featureStates = parts[2]:split(",")
        for _, fs in pairs(featureStates) do
            local fParts = fs:split(":")
            if #fParts == 2 then
                config[fParts[1]] = fParts[2] == "true"
            end
        end
    end
end

-- Create Loading Screen
local loadingScreen = Instance.new("Frame")
loadingScreen.Name = "LoadingScreen"
loadingScreen.Size = UDim2.new(1, 0, 1, 0)
loadingScreen.Position = UDim2.new(0, 0, 0, 0)
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

-- Create Window Frame
local window = Instance.new("Frame")
window.Name = "Window"
window.Size = UDim2.new(0, 300, 0, 400)
window.Position = UDim2.new(0.5, -150, 0.5, -200)
window.BackgroundColor3 = config.color or Color3.fromRGB(50, 50, 50)
window.Visible = false
window.Parent = screenGui

-- Create TitleBar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
titleBar.Parent = window

local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, -90, 1, 0)
titleText.Position = UDim2.new(0, 0, 0, 0)
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

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 30, 0, 30)
closeButton.Position = UDim2.new(1, -30, 0, 0)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 0, 0)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Parent = titleBar

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
featuresTab.Position = UDim2.new(0, 0, 0, 0)
featuresTab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
featuresTab.Text = "Features"
featuresTab.TextColor3 = Color3.fromRGB(255, 255, 255)
featuresTab.Parent = tabs

local settingsTab = Instance.new("TextButton")
settingsTab.Name = "SettingsTab"
settingsTab.Size = UDim2.new(0.5, 0, 1, 0)
settingsTab.Position = UDim2.new(0.5, 0, 0, 0)
settingsTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
settingsTab.Text = "Settings"
settingsTab.TextColor3 = Color3.fromRGB(255, 255, 255)
settingsTab.Parent = tabs

-- Create Content
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, 0, 1, -60)
content.Position = UDim2.new(0, 0, 0, 60)
content.BackgroundTransparency = 1
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

-- List of features
local features = {
    "Infinite Jump", "Fly", "Anti-AFK", "Touch Fling", "Noclip", "Click Teleport", "Speed Hack", "ESP", "God Mode", "Super Jump", "Invisible"
}

-- Create toggle buttons for each feature
for _, feature in ipairs(features) do
    toggles[feature] = config[feature] or false
    createToggleButton(feature)
end

-- Initialize features based on saved config
for feature, state in pairs(toggles) do
    if featureFunctions[feature] then
        featureFunctions[feature](state)
    end
end

-- Add color picker to SettingsContent
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

local gBox = Instance.new("TextBox")
gBox.Name = "GBox"
gBox.Size = UDim2.new(0.3, 0, 0, 30)
gBox.Position = UDim2.new(0.35, 0, 0, 30)
gBox.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
gBox.Text = config.color and tostring(math.floor(config.color.G * 255)) or "50"
gBox.Parent = settingsContent

local bBox = Instance.new("TextBox")
bBox.Name = "BBox"
bBox.Size = UDim2.new(0.3, 0, 0, 30)
bBox.Position = UDim2.new(0.7, 0, 0, 30)
bBox.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
bBox.Text = config.color and tostring(math.floor(config.color.B * 255)) or "50"
bBox.Parent = settingsContent

local applyButton = Instance.new("TextButton")
applyButton.Name = "ApplyButton"
applyButton.Size = UDim2.new(0.5, 0, 0, 30)
applyButton.Position = UDim2.new(0.25, 0, 0, 70)
applyButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
applyButton.Text = "Apply"
applyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
applyButton.Parent = settingsContent

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

-- Tab switching
featuresTab.MouseButton1Click:Connect(function()
    featuresContent.Visible = true
    settingsContent.Visible = false
    featuresTab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    settingsTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
end)

settingsTab.MouseButton1Click:Connect(function()
    featuresContent.Visible = false
    settingsContent.Visible = true
    featuresTab.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    settingsTab.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
end)

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
                wait(900) -- 15 minutes
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

-- Save configuration function
function saveConfig()
    local colorStr = string.format("%d,%d,%d", math.floor(config.color.R * 255), math.floor(config.color.G * 255), math.floor(config.color.B * 255))
    local featureStr = ""
    for feature, state in pairs(toggles) do
        featureStr = featureStr .. feature .. ":" .. tostring(state) .. ","
    end
    featureStr = featureStr:sub(1, -2)
    local data = colorStr .. "|" .. featureStr
    if writefile then
        writefile(configFile, data)
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

-- Tween loading screen
local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local goal = {Position = UDim2.new(0, 0, -1, 0)}
local tween = TweenService:Create(loadingScreen, tweenInfo, goal)

wait(2)
tween:Play()
tween.Completed:Wait()
loadingScreen.Visible = false
window.Visible = true

-- Set initial config color
config.color = window.BackgroundColor3

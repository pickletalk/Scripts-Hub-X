-- Scripts Hub X | Official Teleport Window
-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Store saved position
local savedPosition = nil

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptsHubX"
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main background frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 30)
mainFrame.BackgroundTransparency = 0.7
mainFrame.Parent = screenGui

-- Content frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 400, 0, 300)
contentFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 40, 60)
contentFrame.BackgroundTransparency = 0.5
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Content frame corner
local contentFrameCorner = Instance.new("UICorner")
contentFrameCorner.CornerRadius = UDim.new(0, 16)
contentFrameCorner.Parent = contentFrame

-- Content frame glow
local contentStroke = Instance.new("UIStroke")
contentStroke.Color = Color3.fromRGB(80, 160, 255)
contentStroke.Thickness = 1.5
contentStroke.Transparency = 0.4
contentStroke.Parent = contentFrame

-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 50)
titleLabel.Position = UDim2.new(0, 20, 0, 20)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Scripts Hub X | Official"
titleLabel.TextColor3 = Color3.fromRGB(120, 180, 255)
titleLabel.TextScaled = true
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = contentFrame

-- Subtitle label
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Size = UDim2.new(1, -40, 0, 30)
subtitleLabel.Position = UDim2.new(0, 20, 0, 70)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Official Window"
subtitleLabel.TextColor3 = Color3.fromRGB(150, 180, 200)
subtitleLabel.TextScaled = true
subtitleLabel.TextSize = 16
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.Parent = contentFrame

-- Discord container
local discordContainer = Instance.new("Frame")
discordContainer.Size = UDim2.new(1, -40, 0, 40)
discordContainer.Position = UDim2.new(0, 20, 0, 110)
discordContainer.BackgroundColor3 = Color3.fromRGB(30, 50, 70)
discordContainer.BackgroundTransparency = 0
discordContainer.BorderSizePixel = 0
discordContainer.Parent = contentFrame

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 8)
discordCorner.Parent = discordContainer

-- Discord label
local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(0.7, -10, 1, -10)
discordLabel.Position = UDim2.new(0, 10, 0, 5)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "discord.gg/bpsNUH5sVb"
discordLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
discordLabel.TextScaled = true
discordLabel.TextSize = 12
discordLabel.Font = Enum.Font.Gotham
discordLabel.TextXAlignment = Enum.TextXAlignment.Left
discordLabel.Parent = discordContainer

-- Copy button
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0, 80, 0, 28)
copyButton.Position = UDim2.new(0.73, 5, 0, 6)
copyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
copyButton.BackgroundTransparency = 0.2
copyButton.Text = "Copy"
copyButton.TextColor3 = Color3.fromRGB(230, 240, 255)
copyButton.TextScaled = true
copyButton.TextSize = 12
copyButton.Font = Enum.Font.GothamBold
copyButton.Parent = discordContainer

local copyButtonCorner = Instance.new("UICorner")
copyButtonCorner.CornerRadius = UDim.new(0, 6)
copyButtonCorner.Parent = copyButton

-- Teleport UI section
local teleportSectionLabel = Instance.new("TextLabel")
teleportSectionLabel.Size = UDim2.new(1, -40, 0, 30)
teleportSectionLabel.Position = UDim2.new(0, 20, 0, 160)
teleportSectionLabel.BackgroundTransparency = 1
teleportSectionLabel.Text = "Teleport System by PickleTalk"
teleportSectionLabel.TextColor3 = Color3.fromRGB(120, 180, 255)
teleportSectionLabel.TextScaled = true
teleportSectionLabel.TextSize = 16
teleportSectionLabel.Font = Enum.Font.GothamBold
teleportSectionLabel.Parent = contentFrame

-- Save Position button
local saveButton = Instance.new("TextButton")
saveButton.Size = UDim2.new(0.45, -25, 0, 40)
saveButton.Position = UDim2.new(0, 20, 0, 200)
saveButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
saveButton.BackgroundTransparency = 0.2
saveButton.Text = "Save Position"
saveButton.TextColor3 = Color3.fromRGB(230, 240, 255)
saveButton.TextScaled = true
saveButton.TextSize = 14
saveButton.Font = Enum.Font.GothamBold
saveButton.Parent = contentFrame

local saveButtonCorner = Instance.new("UICorner")
saveButtonCorner.CornerRadius = UDim.new(0, 8)
saveButtonCorner.Parent = saveButton

-- Teleport button
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0.45, -25, 0, 40)
teleportButton.Position = UDim2.new(0.55, 5, 0, 200)
teleportButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
teleportButton.BackgroundTransparency = 0.2
teleportButton.Text = "Teleport"
teleportButton.TextColor3 = Color3.fromRGB(230, 240, 255)
teleportButton.TextScaled = true
teleportButton.TextSize = 14
teleportButton.Font = Enum.Font.GothamBold
teleportButton.Parent = contentFrame

local teleportButtonCorner = Instance.new("UICorner")
teleportButtonCorner.CornerRadius = UDim.new(0, 8)
teleportButtonCorner.Parent = teleportButton

-- Status label for feedback
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -40, 0, 30)
statusLabel.Position = UDim2.new(0, 20, 0, 250)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = ""
statusLabel.TextColor3 = Color3.fromRGB(150, 180, 200)
statusLabel.TextScaled = true
statusLabel.TextSize = 12
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextWrapped = true
statusLabel.Parent = contentFrame

-- Copy button functionality
copyButton.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard("https://discord.gg/bpsNUH5sVb")
        copyButton.Text = "Copied!"
        copyButton.BackgroundColor3 = Color3.fromRGB(60, 140, 235)
        wait(1)
        copyButton.Text = "Copy"
        copyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    end)
end)

-- Save Position button functionality
saveButton.MouseButton1Click:Connect(function()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        savedPosition = player.Character.HumanoidRootPart.Position
        statusLabel.Text = "Position saved!"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        wait(2)
        statusLabel.Text = ""
    else
        statusLabel.Text = "Error: Cannot find player position!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        wait(2)
        statusLabel.Text = ""
    end)
end)

-- Teleport button functionality
teleportButton.MouseButton1Click:Connect(function()
    if savedPosition and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.Position = savedPosition
        statusLabel.Text = "Teleported to saved position!"
        statusLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
        wait(2)
        statusLabel.Text = ""
    else
        statusLabel.Text = "Error: No saved position!"
        statusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
        wait(2)
        statusLabel.Text = ""
    end)
end)

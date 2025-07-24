-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.Name = "ScriptHubUI"

-- Create Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 200)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Visible = true
mainFrame.Parent = screenGui

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.BackgroundTransparency = 1
title.Text = "Steal A Country"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 16
title.Parent = titleBar

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 20)
minimizeButton.Position = UDim2.new(1, -35, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Parent = titleBar

-- Content Frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(1, -20, 1, -40)
contentFrame.Position = UDim2.new(0, 10, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainFrame

-- UIListLayout for clean alignment
local uiListLayout = Instance.new("UIListLayout")
uiListLayout.Parent = contentFrame
uiListLayout.Padding = UDim.new(0, 5)
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Button Template
local buttonTemplate = Instance.new("TextButton")
buttonTemplate.Size = UDim2.new(0, 180, 0, 30)
buttonTemplate.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
buttonTemplate.BorderSizePixel = 0
buttonTemplate.TextColor3 = Color3.fromRGB(255, 255, 255)
buttonTemplate.Font = Enum.Font.SourceSans
buttonTemplate.TextSize = 14

-- Checkbox Template
local checkbox = Instance.new("TextButton")
checkbox.Size = UDim2.new(0, 20, 0, 20)
checkbox.Position = UDim2.new(1, -25, 0, 5)
checkbox.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
checkbox.BorderSizePixel = 0
checkbox.Text = ""
checkbox.Parent = buttonTemplate

-- Auto Collect
local autoCollect = buttonTemplate:Clone()
autoCollect.LayoutOrder = 1
autoCollect.Text = "Auto Collect"
autoCollect.Parent = contentFrame
local autoCheck = checkbox:Clone()
autoCheck.Parent = autoCollect

-- Lock Base
local lockBase = buttonTemplate:Clone()
lockBase.LayoutOrder = 2
lockBase.Text = "Auto Lock"
lockBase.Parent = contentFrame
local lockCheck = checkbox:Clone()
lockCheck.Parent = lockBase

-- Noclip
local noclip = buttonTemplate:Clone()
noclip.LayoutOrder = 3
noclip.Text = "No Clip"
noclip.Parent = contentFrame
local noclipCheck = checkbox:Clone()
noclipCheck.Parent = noclip

-- Instant Steal
local instantSteal = buttonTemplate:Clone()
instantSteal.LayoutOrder = 4
instantSteal.Text = "Auto Instant Steal"
instantSteal.Parent = contentFrame
local instantCheck = checkbox:Clone()
instantCheck.Parent = instantSteal

-- Variables
local player = game.Players.LocalPlayer
local isAutoCollect = false
local isLockBase = false
local isNoclip = false
local isInstantSteal = false

-- Functions
autoCollect.MouseButton1Click:Connect(function()
    isAutoCollect = not isAutoCollect
    autoCheck.BackgroundColor3 = isAutoCollect and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(100, 100, 100)
    while isAutoCollect do
        local args = {
                workspace:WaitForChild("Player Bases"):WaitForChild(player.Name .. "'s Base"):WaitForChild("Floor1"):WaitForChild("Slot1"),
                workspace:WaitForChild("Player Bases"):WaitForChild(player.Name .. "'s Base"):WaitForChild("Floor1"):WaitForChild("Slot2"),
                workspace:WaitForChild("Player Bases"):WaitForChild(player.Name .. "'s Base"):WaitForChild("Floor1"):WaitForChild("Slot3"),
                workspace:WaitForChild("Player Bases"):WaitForChild(player.Name .. "'s Base"):WaitForChild("Floor1"):WaitForChild("Slot4"),
                workspace:WaitForChild("Player Bases"):WaitForChild(player.Name .. "'s Base"):WaitForChild("Floor1"):WaitForChild("Slot5"),
                workspace:WaitForChild("Player Bases"):WaitForChild(player.Name .. "'s Base"):WaitForChild("Floor1"):WaitForChild("Slot6"),
                workspace:WaitForChild("Player Bases"):WaitForChild(player.Name .. "'s Base"):WaitForChild("Floor1"):WaitForChild("Slot7"),
                workspace:WaitForChild("Player Bases"):WaitForChild(player.Name .. "'s Base"):WaitForChild("Floor1"):WaitForChild("Slot8"),
                workspace:WaitForChild("Player Bases"):WaitForChild(player.Name .. "'s Base"):WaitForChild("Floor1"):WaitForChild("Slot9"),
                workspace:WaitForChild("Player Bases"):WaitForChild(player.Name .. "'s Base"):WaitForChild("Floor1"):WaitForChild("Slot10")
        }
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Base:Collect"):FireServer(unpack(args))
        wait(1)
    end
end)

lockBase.MouseButton1Click:Connect(function()
    isLockBase = not isLockBase
    lockCheck.BackgroundColor3 = isLockBase and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(100, 100, 100)
    if isLockBase then
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("Base:Lock"):FireServer()
    end
end)

noclip.MouseButton1Click:Connect(function()
    isNoclip = not isNoclip
    noclipCheck.BackgroundColor3 = isNoclip and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(100, 100, 100)
    if isNoclip then
        local function noclipLoop()
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
        noclipLoop()
        game:GetService("RunService").Stepped:Connect(noclipLoop)
    else
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

instantSteal.MouseButton1Click:Connect(function()
    isInstantSteal = not isInstantSteal
    instantCheck.BackgroundColor3 = isInstantSteal and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(100, 100, 100)
    while isInstantSteal do
        -- Add your instant steal logic here
        wait(1)
    end
end)

-- Minimize Functionality
minimizeButton.MouseButton1Click:Connect(function()
    contentFrame.Visible = not contentFrame.Visible
    mainFrame.Size = contentFrame.Visible and UDim2.new(0, 220, 0, 200) or UDim2.new(0, 220, 0, 30)
end)

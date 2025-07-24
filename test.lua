-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
screenGui.Name = "ScriptHubUI"

-- Services
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Create Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 220, 0, 200)
mainFrame.Position = UDim2.new(0.5, -110, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- All black UI
mainFrame.BorderSizePixel = 1
mainFrame.BorderColor3 = Color3.fromRGB(100, 100, 100) -- Gray outline
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- All black UI
titleBar.BorderSizePixel = 1
titleBar.BorderColor3 = Color3.fromRGB(100, 100, 100) -- Gray outline
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -40, 1, 0)
title.BackgroundTransparency = 1
title.Text = "Steal A Country"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18 -- Slightly larger for cleaner look
title.Parent = titleBar

local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 20)
minimizeButton.Position = UDim2.new(1, -35, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0) -- Black background
minimizeButton.BorderSizePixel = 1
minimizeButton.BorderColor3 = Color3.fromRGB(100, 100, 100) -- Gray outline
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 16
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
uiListLayout.Padding = UDim.new(0, 8) -- Increased padding for cleaner look
uiListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Button Template
local buttonTemplate = Instance.new("TextButton")
buttonTemplate.Size = UDim2.new(0, 180, 0, 30)
buttonTemplate.BackgroundTransparency = 1 -- No fill, just outline
buttonTemplate.BorderSizePixel = 1
buttonTemplate.BorderColor3 = Color3.fromRGB(100, 100, 100) -- Gray outline
buttonTemplate.TextColor3 = Color3.fromRGB(255, 255, 255)
buttonTemplate.Font = Enum.Font.SourceSans
buttonTemplate.TextSize = 16 -- Slightly larger for readability

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
noclip.Text = "Noclip"
noclip.Parent = contentFrame
local noclipCheck = checkbox:Clone()
noclipCheck.Parent = noclip

-- Instant Steal
local instantSteal = buttonTemplate:Clone()
instantSteal.LayoutOrder = 4
instantSteal.Text = "Instant Steal"
instantSteal.Parent = contentFrame
local instantCheck = checkbox:Clone()
instantCheck.Parent = instantSteal

-- Infinite Jump
local infJump = buttonTemplate:Clone()
infJump.LayoutOrder = 5
infJump.Text = "Infinite Jump"
infJump.Parent = contentFrame
local infJumpCheck = checkbox:Clone()
infJumpCheck.Parent = infJump

-- Variables
local player = game.Players.LocalPlayer
local isAutoCollect = false
local isLockBase = false
local isNoclip = false
local isInstantSteal = false
local isInfJump = false
local noclipConnection

-- Tween Info for Minimize Animation
local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Functions
autoCollect.MouseButton1Click:Connect(function()
    isAutoCollect = not isAutoCollect
    autoCheck.BackgroundColor3 = isAutoCollect and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(100, 100, 100)
    while isAutoCollect do
        local base = workspace:WaitForChild("Player Bases"):WaitForChild(player.Name .. "'s Base"):WaitForChild("Floor1")
        for i = 1, 10 do
            local slot = base:WaitForChild("Slot" .. i)
            ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Base:Collect"):FireServer(slot)
        end
        wait(1)
    end
end)

lockBase.MouseButton1Click:Connect(function()
    isLockBase = not isLockBase
    lockCheck.BackgroundColor3 = isLockBase and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(100, 100, 100)
    while isLockBase do
        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Base:Lock"):FireServer()
        wait(0.1) -- Repeat every 0.1 seconds
    end
end)

noclip.MouseButton1Click:Connect(function()
    isNoclip = not isNoclip
    noclipCheck.BackgroundColor3 = isNoclip and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(100, 100, 100)
    if isNoclip then
        local function noclipLoop()
            if player.Character then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end
        noclipLoop()
        noclipConnection = RunService.Stepped:Connect(noclipLoop)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        if player.Character then
            for _, part in pairs(player.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end)

instantSteal.MouseButton1Click:Connect(function()
    isInstantSteal = not isInstantSteal
    instantCheck.BackgroundColor3 = isInstantSteal and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(100, 100, 100)
    while isInstantSteal do
        local otherPlayers = {}
        for _, p in pairs(game.Players:GetPlayers()) do
            if p ~= player then
                table.insert(otherPlayers, p)
            end
        end
        for _, targetPlayer in pairs(otherPlayers) do
            if not isInstantSteal then break end
            local base = workspace:WaitForChild("Player Bases"):FindFirstChild(targetPlayer.Name .. "'s Base")
            if base then
                local floor1 = base:WaitForChild("Floor1")
                for i = 1, 10 do
                    if not isInstantSteal then break end
                    local slot = floor1:FindFirstChild("Slot" .. i)
                    if slot then
                        ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Base:Steal"):FireServer(slot)
                        wait(0.1) -- Short delay between steals
                    end
                end
                if isInstantSteal and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    player.Character.HumanoidRootPart.CFrame = game.Workspace.SpawnLocation.CFrame
                end
                wait(1) -- Wait before moving to the next player
            end
        end
        if isInstantSteal then
            wait(5) -- Wait before starting the next cycle
        end
    end
end)

infJump.MouseButton1Click:Connect(function()
    isInfJump = not isInfJump
    infJumpCheck.BackgroundColor3 = isInfJump and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(100, 100, 100)
    if isInfJump then
        UserInputService.JumpRequest:Connect(function()
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
    end
end)

-- Minimize Functionality with Animation
local function toggleMinimize()
    if contentFrame.Visible then
        local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 220, 0, 30)})
        tween:Play()
        tween.Completed:Wait()
        contentFrame.Visible = false
    else
        contentFrame.Visible = true
        local tween = TweenService:Create(mainFrame, tweenInfo, {Size = UDim2.new(0, 220, 0, 200)})
        tween:Play()
    end
end

minimizeButton.MouseButton1Click:Connect(toggleMinimize)
titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        toggleMinimize()
    end
end)

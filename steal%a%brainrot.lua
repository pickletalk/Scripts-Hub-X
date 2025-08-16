-- ========================================
-- MAIN SERVICES
-- ========================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- ========================================
-- UI CREATION
-- ========================================
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlotTeleporterUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Small main frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 200, 0, 110)
mainFrame.Position = UDim2.new(1, -210, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 10)
mainCorner.Parent = mainFrame

-- Title bar (for dragging)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 25)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Plot Tools"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextScaled = true
titleText.Parent = titleBar

-- Teleport button
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 180, 0, 30)
teleportButton.Position = UDim2.new(0, 10, 0, 35)
teleportButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
teleportButton.Text = "Steal"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.TextScaled = true
teleportButton.Font = Enum.Font.GothamBold
teleportButton.BorderSizePixel = 0
teleportButton.Parent = mainFrame

local tpCorner = Instance.new("UICorner")
tpCorner.CornerRadius = UDim.new(0, 8)
tpCorner.Parent = teleportButton

-- Forward Tp button
local forwardButton = Instance.new("TextButton")
forwardButton.Size = UDim2.new(0, 180, 0, 30)
forwardButton.Position = UDim2.new(0, 10, 0, 70)
forwardButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
forwardButton.Text = "Forward Tp"
forwardButton.TextColor3 = Color3.fromRGB(255, 255, 255)
forwardButton.TextScaled = true
forwardButton.Font = Enum.Font.GothamBold
forwardButton.BorderSizePixel = 0
forwardButton.Parent = mainFrame

local fwdCorner = Instance.new("UICorner")
fwdCorner.CornerRadius = UDim.new(0, 8)
fwdCorner.Parent = forwardButton

-- Status text
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -5, 0, 15)
statusLabel.Position = UDim2.new(0, 5, 1, -17)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "by PickleTalk"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.TextScaled = false
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextSize = 12
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- ========================================
-- FUNCTIONS
-- ========================================
local function findPlayerPlot()
    local workspace = game:GetService("Workspace")
    local plotsFolder = workspace:FindFirstChild("Plots")
    if not plotsFolder then return nil end

    local spawnPoint = player.RespawnLocation or (player.Character and player.Character:FindFirstChild("SpawnLocation"))
    if not spawnPoint then return nil end

    for _, plot in pairs(plotsFolder:GetChildren()) do
        if spawnPoint:IsDescendantOf(plot) then
            return plot
        end
    end
    return nil
end

local stealBusy = false

local function teleportToPlot()
    if stealBusy then return end
    stealBusy = true

    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then 
        stealBusy = false 
        return 
    end

    local plot = findPlayerPlot()
    if not plot then 
        stealBusy = false 
        return 
    end

    local cz = plot:FindFirstChild("CollectZone")
    if not cz then 
        stealBusy = false 
        return 
    end

    local trigger = cz:FindFirstChild("CollectTrigger") or cz:FindFirstChild("Collect")
    if not trigger then 
        stealBusy = false 
        return 
    end

    local startCF = root.CFrame
    local oldAnchored = root.Anchored

    teleportButton.Text = "Stealing..."
    
    -- Triple flick fall above trigger
    local targetPos = trigger.Position + Vector3.new(0, 0.2, 0)
    for i = 1, 3 do
        root.CFrame = CFrame.new(targetPos)
        root.Anchored = false
        task.wait(0.3) -- fall time
        root.Anchored = true
        task.wait(0.05)
    end

    -- Restore position
    root.CFrame = startCF
    root.Anchored = oldAnchored

    teleportButton.Text = "Steal"
    stealBusy = false
end

local function forwardTp()
    local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    root.CFrame = root.CFrame * CFrame.new(0, 0, -5) -- forward 5 studs
end

-- ========================================
-- CONNECTIONS
-- ========================================
teleportButton.MouseButton1Click:Connect(teleportToPlot)
forwardButton.MouseButton1Click:Connect(forwardTp)

-- ========================================
-- RGB BUTTON EFFECTS
-- ========================================
local function rgbEffect(button)
    task.spawn(function()
        local t = 0
        while button.Parent do
            t += 0.02
            local r = math.floor((math.sin(t) * 0.5 + 0.5) * 255)
            local g = math.floor((math.sin(t + 2) * 0.5 + 0.5) * 255)
            local b = math.floor((math.sin(t + 4) * 0.5 + 0.5) * 255)
            button.BackgroundColor3 = Color3.fromRGB(r, g, b)
            task.wait(0.03)
        end
    end)
end

rgbEffect(teleportButton)
rgbEffect(forwardButton)

-- ========================================
-- DRAGGING SUPPORT
-- ========================================
local dragging = false
local dragStart, startPos

local function updateDrag(input)
    local delta = input.Position - dragStart
    mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

titleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input)
    end
end)

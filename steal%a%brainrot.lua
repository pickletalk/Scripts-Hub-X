-- ========================================
-- MAIN SERVICES
-- ========================================
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

-- ========================================
-- SAFE GUI PARENT
-- ========================================
local function safeGuiParent()
    local ok, res = pcall(function()
        if gethui then return gethui() end
        return game:GetService("CoreGui")
    end)
    if ok and res then return res end
    return player:WaitForChild("PlayerGui")
end

local parentGui = safeGuiParent()
local existing = parentGui:FindFirstChild("PlotTeleporterUI")
if existing then existing:Destroy() end

-- ========================================
-- UI CREATION
-- ========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlotTeleporterUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = parentGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 120)
mainFrame.Position = UDim2.new(1, -260, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.BorderSizePixel = 2
titleBar.BorderColor3 = Color3.fromRGB(100, 100, 100)
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -30, 1, 0)
titleText.Position = UDim2.new(0, 5, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Steal A Brainrot"
titleText.TextColor3 = Color3.fromRGB(220, 220, 220)
titleText.TextScaled = true
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -27, 0, 2)
closeButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
closeButton.BorderSizePixel = 2
closeButton.BorderColor3 = Color3.fromRGB(100, 100, 100)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 4)

local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 220, 0, 35)
teleportButton.Position = UDim2.new(0, 15, 0, 45)
teleportButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
teleportButton.BorderSizePixel = 2
teleportButton.BorderColor3 = Color3.fromRGB(100, 100, 100)
teleportButton.Text = "Steal"
teleportButton.TextColor3 = Color3.fromRGB(220, 220, 220)
teleportButton.TextScaled = true
teleportButton.Font = Enum.Font.GothamBold
teleportButton.Parent = mainFrame
Instance.new("UICorner", teleportButton).CornerRadius = UDim.new(0, 6)

-- overlay frame for RGB effect
local rgbOverlay = Instance.new("Frame")
rgbOverlay.Size = UDim2.new(1, 0, 1, 0)
rgbOverlay.BackgroundTransparency = 0.5
rgbOverlay.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
rgbOverlay.ZIndex = teleportButton.ZIndex + 1
rgbOverlay.Parent = teleportButton
Instance.new("UICorner", rgbOverlay).CornerRadius = UDim.new(0, 6)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 90)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "by PickleTalk"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- ========================================
-- SPAWN DETECTION
-- ========================================
local lastSpawnPoint

local function nearestSpawnTo(pos)
    local best, bestDist
    for _, inst in ipairs(workspace:GetDescendants()) do
        if inst:IsA("SpawnLocation") or (inst:IsA("BasePart") and inst.Name:lower():find("spawn")) then
            local d = (inst.Position - pos).Magnitude
            if not bestDist or d < bestDist then
                best, bestDist = inst, d
            end
        end
    end
    return best
end

local function detectSpawnPoint(char)
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if not hrp then return end
    local spawnObj = player.RespawnLocation or nearestSpawnTo(hrp.Position)
    if spawnObj then lastSpawnPoint = spawnObj end
end

Players.LocalPlayer.CharacterAdded:Connect(detectSpawnPoint)
if player.Character then detectSpawnPoint(player.Character) end

local function findPlayerSpawn()
    return lastSpawnPoint
end

-- ========================================
-- TELEPORT (fling-based)
-- ========================================
local stealBusy = false

local function flingTo(part)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    teleportButton.Text = "Stealing..."

    local offsetCF = part.CFrame * CFrame.new(0, 0, -5) -- 5 studs in front
    for i = 1, 3 do
        hrp.CFrame = offsetCF
        hrp.Velocity = Vector3.new(0, 200, 0) -- fling upwards hard
        hrp.RotVelocity = Vector3.new(2000, 2000, 2000) -- spin for bypass
        task.wait(0.7) -- longer fall
    end

    -- end by putting player on spawnpoint
    hrp.CFrame = part.CFrame + Vector3.new(0, 3, 0)
    hrp.Velocity = Vector3.zero

    teleportButton.Text = "Steal"
end

local function teleportToPlot()
    if stealBusy then return end
    stealBusy = true

    local spawnObj = findPlayerSpawn()
    if not spawnObj or not spawnObj:IsA("BasePart") then
        teleportButton.Text = "No Spawn!"
        task.wait(1)
        teleportButton.Text = "Steal"
        stealBusy = false
        return
    end

    flingTo(spawnObj)
    stealBusy = false
end

-- ========================================
-- CONNECTIONS
-- ========================================
teleportButton.MouseButton1Click:Connect(teleportToPlot)
closeButton.MouseButton1Click:Connect(function() screenGui:Destroy() end)

-- ========================================
-- RGB EFFECT (overlay)
-- ========================================
task.spawn(function()
    local t = 0
    while rgbOverlay and rgbOverlay.Parent do
        t += 0.02
        local r = (math.sin(t) * 0.5 + 0.5) * 255
        local g = (math.sin(t + 2) * 0.5 + 0.5) * 255
        local b = (math.sin(t + 4) * 0.5 + 0.5) * 255
        rgbOverlay.BackgroundColor3 = Color3.fromRGB(r, g, b)
        task.wait(0.03)
    end
end)

-- ========================================
-- DRAGGING
-- ========================================
local dragging, dragStart, startPos
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
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)

titleBar.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updateDrag(input)
    end
end)

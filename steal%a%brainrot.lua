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
mainFrame.Size = UDim2.new(0, 200, 0, 110)
mainFrame.Position = UDim2.new(1, -210, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 10)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 25)
titleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
titleBar.Parent = mainFrame

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, 0, 1, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Steal A Brainrot"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextScaled = true
titleText.Parent = titleBar

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
Instance.new("UICorner", teleportButton).CornerRadius = UDim.new(0, 8)

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
Instance.new("UICorner", forwardButton).CornerRadius = UDim.new(0, 8)

local footer = Instance.new("TextLabel")
footer.Size = UDim2.new(1, -5, 0, 15)
footer.Position = UDim2.new(0, 5, 1, -17)
footer.BackgroundTransparency = 1
footer.Text = "by PickleTalk"
footer.TextColor3 = Color3.fromRGB(150, 150, 150)
footer.Font = Enum.Font.Gotham
footer.TextSize = 12
footer.TextXAlignment = Enum.TextXAlignment.Left
footer.Parent = mainFrame

-- ========================================
-- SPAWN-BASED PLOT DETECTION
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

player.CharacterAdded:Connect(detectSpawnPoint)
if player.Character then detectSpawnPoint(player.Character) end

local function findPlayerSpawn()
    return lastSpawnPoint
end

-- ========================================
-- TELEPORTS
-- ========================================
local stealBusy = false

local function tripleFlickAt(part)
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local startCF, oldAnchored = hrp.CFrame, hrp.Anchored
    teleportButton.Text = "Stealing..."

    local targetPos = part.Position + Vector3.new(0, 2, 0)
    for _ = 1, 3 do
        hrp.CFrame = CFrame.new(targetPos)
        hrp.Anchored = false
        task.wait(0.30)
        hrp.Anchored = true
        task.wait(0.05)
    end

    hrp.CFrame = startCF
    hrp.Anchored = oldAnchored
    teleportButton.Text = "Steal Plot"
end

local function teleportToPlot()
    if stealBusy then return end
    stealBusy = true

    local spawnObj = findPlayerSpawn()
    if not spawnObj or not spawnObj:IsA("BasePart") then
        teleportButton.Text = "No Spawn!"
        task.wait(1)
        teleportButton.Text = "Steal Plot"
        stealBusy = false
        return
    end

    tripleFlickAt(spawnObj)
    stealBusy = false
end

local function forwardTp()
    local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = hrp.CFrame * CFrame.new(0, 0, -5)
end

-- ========================================
-- CONNECTIONS
-- ========================================
teleportButton.MouseButton1Click:Connect(teleportToPlot)
forwardButton.MouseButton1Click:Connect(forwardTp)

-- ========================================
-- RGB EFFECT
-- ========================================
local function rgbEffect(button)
    task.spawn(function()
        local t = 0
        while button and button.Parent do
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

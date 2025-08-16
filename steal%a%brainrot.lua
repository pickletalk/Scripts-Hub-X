-- ========================================
-- MAIN SERVICES
-- ========================================
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
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

-- overlay RGB subtle
local rgbOverlay = Instance.new("Frame")
rgbOverlay.Size = UDim2.new(1, 0, 1, 0)
rgbOverlay.BackgroundTransparency = 0.85
rgbOverlay.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
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

player.CharacterAdded:Connect(detectSpawnPoint)
if player.Character then detectSpawnPoint(player.Character) end

local function findPlayerSpawn()
    return lastSpawnPoint
end

-- ========================================
-- MICRO-STEP TELEPORT
-- ========================================
local function teleportToPlot()
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local spawnObj = findPlayerSpawn()
    if not hrp or not spawnObj then return end

    teleportButton.Text = "Stealing..."

    local targetPos = spawnObj.Position + Vector3.new(0, 3, 0)
    local steps = 50 -- number of micro steps
    local current = hrp.Position
    local diff = (targetPos - current) / steps

    for i = 1, steps do
        if not hrp.Parent then break end
        hrp.CFrame = CFrame.new(hrp.Position + diff)
        task.wait(0.02) -- very fast tiny step
    end

    teleportButton.Text = "Steal"
end

-- ========================================
-- SPEED BYPASS LOOP (undetected)
-- ========================================
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local SPEED_MULTIPLIER = 7.5 -- about 120 vs 16 default

local function startBypassSpeed(char)
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    local hum = char:WaitForChild("Humanoid", 5)
    if not hrp or not hum then return end

    -- keep WalkSpeed normal to avoid detection
    hum.WalkSpeed = 16

    RunService.Heartbeat:Connect(function(dt)
        if not hrp or not hum or hum.Health <= 0 then return end

        -- get movement direction from Humanoid
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0 then
            -- apply additional movement offset
            local offset = moveDir * SPEED_MULTIPLIER * dt
            hrp.CFrame = hrp.CFrame + offset
        end
    end)
end

player.CharacterAdded:Connect(startBypassSpeed)
if player.Character then startBypassSpeed(player.Character) end

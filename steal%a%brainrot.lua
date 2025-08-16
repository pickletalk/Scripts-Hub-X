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
-- ORIGINAL SPAWN DETECTION (FIXED)
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
    if spawnObj then 
        lastSpawnPoint = spawnObj 
        statusLabel.Text = "Spawn: " .. spawnObj.Name
    end
end

player.CharacterAdded:Connect(detectSpawnPoint)
if player.Character then detectSpawnPoint(player.Character) end

local function findPlayerSpawn()
    return lastSpawnPoint
end

-- ========================================
-- NEW STEALTH TELEPORT METHOD
-- ========================================
local teleporting = false

local function stealthTeleport()
    if teleporting then return end
    teleporting = true
    
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local spawnObj = findPlayerSpawn()
    
    if not hrp or not spawnObj then 
        teleporting = false
        return 
    end

    teleportButton.Text = "Stealing..."
    
    -- Calculate position 5 studs away from spawn
    local spawnPos = spawnObj.Position
    local randomAngle = math.rad(math.random(0, 360))
    local targetPos = spawnPos + Vector3.new(
        math.cos(randomAngle) * 5,  -- 5 studs away
        3,  -- 3 studs up
        math.sin(randomAngle) * 5   -- 5 studs away
    )
    
    -- Method 1: Workspace.CurrentCamera manipulation (very stealth)
    local camera = workspace.CurrentCamera
    if camera then
        pcall(function()
            local oldCameraCFrame = camera.CFrame
            camera.CameraSubject = nil
            camera.CameraType = Enum.CameraType.Scriptable
            
            -- Move character while camera is detached
            hrp.CFrame = CFrame.new(targetPos)
            
            task.wait(0.1)
            
            -- Restore camera
            camera.CameraSubject = char.Humanoid
            camera.CameraType = Enum.CameraType.Custom
        end)
    end
    
    -- Method 2: Using Humanoid.Sit property (anti-detection)
    task.wait(0.05)
    pcall(function()
        local humanoid = char:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.Sit = true
            task.wait(0.02)
            hrp.CFrame = CFrame.new(targetPos)
            task.wait(0.02)
            humanoid.Sit = false
        end
    end)
    
    teleportButton.Text = "Steal"
    teleporting = false
end

-- ========================================
-- NEW UNDETECTABLE SPEED METHOD
-- ========================================
local speedConnections = {}
local speedEnabled = false

local function cleanupSpeed()
    for _, connection in pairs(speedConnections) do
        if connection then connection:Disconnect() end
    end
    speedConnections = {}
    speedEnabled = false
end

local function setupInvisibleSpeed(character)
    cleanupSpeed()
    
    local humanoid = character:WaitForChild("Humanoid", 5)
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    
    if not humanoid or not rootPart then return end
    
    speedEnabled = true
    
    -- Method 1: RenderStepped for smoothest undetectable movement
    local lastUpdate = tick()
    
    speedConnections[1] = RunService.RenderStepped:Connect(function()
        if not speedEnabled or not rootPart.Parent or humanoid.Health <= 0 then return end
        
        local now = tick()
        local deltaTime = now - lastUpdate
        lastUpdate = now
        
        local moveDirection = humanoid.MoveDirection
        if moveDirection.Magnitude > 0 then
            -- Ultra-subtle speed boost using AssemblyLinearVelocity
            local currentVelocity = rootPart.AssemblyLinearVelocity
            local boostVelocity = Vector3.new(
                moveDirection.X * 8,  -- Very small boost
                currentVelocity.Y,    -- Keep Y velocity unchanged
                moveDirection.Z * 8   -- Very small boost
            )
            
            rootPart.AssemblyLinearVelocity = boostVelocity
        end
    end)
    
    -- Method 2: Slight CFrame position adjustments (barely noticeable)
    local positionOffset = Vector3.new(0, 0, 0)
    
    speedConnections[2] = RunService.PostSimulation:Connect(function()
        if not speedEnabled or not rootPart.Parent then return end
        
        local moveDir = humanoid.MoveDirection
        if moveDir.Magnitude > 0 then
            -- Accumulate tiny position changes
            positionOffset = positionOffset + (moveDir * 0.002)  -- Extremely small
            
            -- Apply offset every few frames
            if positionOffset.Magnitude > 0.01 then
                rootPart.CFrame = rootPart.CFrame + positionOffset
                positionOffset = Vector3.new(0, 0, 0)
            end
        end
    end)
    
    -- Method 3: Keep WalkSpeed normal and JumpPower normal
    speedConnections[3] = RunService.Heartbeat:Connect(function()
        if not humanoid or not humanoid.Parent then return end
        
        -- Always maintain normal values
        if humanoid.WalkSpeed ~= 16 then
            humanoid.WalkSpeed = 16
        end
        if humanoid.JumpPower ~= 50 then
            humanoid.JumpPower = 50
        end
    end)
    
    -- Cleanup on character removal
    character.AncestryChanged:Connect(function()
        if not character.Parent then
            cleanupSpeed()
        end
    end)
end

-- ========================================
-- EVENT CONNECTIONS
-- ========================================
closeButton.MouseButton1Click:Connect(function()
    cleanupSpeed()
    screenGui:Destroy()
end)

teleportButton.MouseButton1Click:Connect(function()
    stealthTeleport()
end)

-- RGB button effect
RunService.Heartbeat:Connect(function()
    local time = tick()
    rgbOverlay.BackgroundColor3 = Color3.fromHSV((time * 0.5) % 1, 0.3, 0.8)
end)

-- Auto-setup on character spawn
player.CharacterAdded:Connect(function(character)
    task.wait(1)
    detectSpawnPoint(character)
    setupInvisibleSpeed(character)
end)

-- Setup for existing character
if player.Character then
    task.spawn(function()
        task.wait(1)
        detectSpawnPoint(player.Character)
        setupInvisibleSpeed(player.Character)
    end)
end

print("Stealth Steal A Brainrot loaded!")

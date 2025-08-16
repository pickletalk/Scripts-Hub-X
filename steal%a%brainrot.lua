-- ========================================
-- MAIN SERVICES
-- ========================================
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
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
-- SPAWN DETECTION & STORAGE
-- ========================================
local spawnPoints = {}
local playerSpawnPoint

local function findSpawnPoints()
    spawnPoints = {}
    
    -- Method 1: Find SpawnLocation objects
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("SpawnLocation") then
            table.insert(spawnPoints, obj)
        end
    end
    
    -- Method 2: Find parts with "spawn" in name
    if #spawnPoints == 0 then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("spawn") then
                table.insert(spawnPoints, obj)
            end
        end
    end
    
    -- Method 3: Look for common spawn-related names
    if #spawnPoints == 0 then
        local spawnNames = {"SpawnPoint", "Spawn", "PlayerSpawn", "StartPoint", "Base"}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                for _, name in pairs(spawnNames) do
                    if obj.Name:find(name) then
                        table.insert(spawnPoints, obj)
                        break
                    end
                end
            end
        end
    end
end

local function detectPlayerSpawn()
    local char = player.Character
    if not char then return end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    findSpawnPoints()
    
    -- Find closest spawn to current position
    local closestSpawn
    local shortestDistance = math.huge
    
    for _, spawn in pairs(spawnPoints) do
        if spawn and spawn.Parent then
            local distance = (hrp.Position - spawn.Position).Magnitude
            if distance < shortestDistance then
                shortestDistance = distance
                closestSpawn = spawn
            end
        end
    end
    
    if closestSpawn then
        playerSpawnPoint = closestSpawn
        statusLabel.Text = "Spawn found: " .. closestSpawn.Name
    else
        statusLabel.Text = "No spawn found"
    end
end

-- ========================================
-- ADVANCED TELEPORT SYSTEM
-- ========================================
local teleporting = false

local function advancedTeleport()
    if teleporting then return end
    teleporting = true
    
    local char = player.Character
    if not char then 
        teleporting = false
        return 
    end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local humanoid = char:FindFirstChild("Humanoid")
    
    if not hrp or not humanoid or not playerSpawnPoint then
        statusLabel.Text = "Teleport failed: Missing components"
        teleporting = false
        return
    end
    
    teleportButton.Text = "Stealing..."
    
    -- Method 1: Try BodyVelocity teleport
    pcall(function()
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bodyVelocity.Velocity = Vector3.new(0, 0, 0)
        bodyVelocity.Parent = hrp
        
        local targetPosition = playerSpawnPoint.Position + Vector3.new(math.random(-3, 3), 5, math.random(-3, 3))
        
        hrp.CFrame = CFrame.new(targetPosition)
        
        task.wait(0.1)
        bodyVelocity:Destroy()
    end)
    
    -- Method 2: If that fails, try PrimaryPart method
    if (hrp.Position - playerSpawnPoint.Position).Magnitude > 10 then
        pcall(function()
            if char.PrimaryPart then
                char:SetPrimaryPartCFrame(CFrame.new(playerSpawnPoint.Position + Vector3.new(0, 5, 0)))
            else
                char:MoveTo(playerSpawnPoint.Position + Vector3.new(0, 5, 0))
            end
        end)
    end
    
    -- Method 3: Direct CFrame manipulation with collision bypass
    task.wait(0.1)
    pcall(function()
        hrp.CanCollide = false
        hrp.Anchored = true
        hrp.CFrame = CFrame.new(playerSpawnPoint.Position + Vector3.new(0, 3, 0))
        task.wait(0.1)
        hrp.Anchored = false
        hrp.CanCollide = true
    end)
    
    teleportButton.Text = "Steal"
    statusLabel.Text = "Teleported to spawn!"
    teleporting = false
end

-- ========================================
-- BYPASS SPEED SYSTEM
-- ========================================
local speedEnabled = false
local speedConnections = {}

local function cleanupSpeedConnections()
    for _, connection in pairs(speedConnections) do
        if connection then
            connection:Disconnect()
        end
    end
    speedConnections = {}
end

local function setupBypassSpeed(character)
    cleanupSpeedConnections()
    
    local humanoid = character:WaitForChild("Humanoid", 5)
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    
    if not humanoid or not rootPart then return end
    
    speedEnabled = true
    
    -- Method 1: BodyVelocity speed boost
    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(0, 0, 4000)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = rootPart
    
    -- Method 2: CFrame manipulation for speed
    local lastPosition = rootPart.Position
    local speedMultiplier = 3.5 -- Lower multiplier to avoid detection
    
    speedConnections[1] = RunService.Heartbeat:Connect(function(dt)
        if not speedEnabled or not rootPart.Parent or humanoid.Health <= 0 then return end
        
        local moveVector = humanoid.MoveDirection
        if moveVector.Magnitude > 0 then
            -- Method A: BodyVelocity approach
            bodyVelocity.Velocity = Vector3.new(
                moveVector.X * humanoid.WalkSpeed * speedMultiplier,
                bodyVelocity.Velocity.Y,
                moveVector.Z * humanoid.WalkSpeed * speedMultiplier
            )
            
            -- Method B: Small CFrame adjustments
            local currentPos = rootPart.Position
            local deltaMove = (currentPos - lastPosition)
            
            if deltaMove.Magnitude > 0 and deltaMove.Magnitude < 50 then -- Prevent huge jumps
                local boost = moveVector * speedMultiplier * dt * 15
                rootPart.CFrame = rootPart.CFrame + Vector3.new(boost.X, 0, boost.Z)
            end
            
            lastPosition = currentPos
        else
            bodyVelocity.Velocity = Vector3.new(0, bodyVelocity.Velocity.Y, 0)
        end
    end)
    
    -- Method 3: Walkspeed normalization to avoid detection
    speedConnections[2] = RunService.Heartbeat:Connect(function()
        if humanoid and humanoid.Parent then
            if humanoid.WalkSpeed ~= 16 then
                humanoid.WalkSpeed = 16 -- Keep it normal
            end
        end
    end)
    
    -- Cleanup when character is removed
    speedConnections[3] = character.AncestryChanged:Connect(function()
        if not character.Parent then
            cleanupSpeedConnections()
            if bodyVelocity then bodyVelocity:Destroy() end
        end
    end)
end

-- ========================================
-- EVENT CONNECTIONS
-- ========================================
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    cleanupSpeedConnections()
end)

teleportButton.MouseButton1Click:Connect(function()
    advancedTeleport()
end)

-- RGB button effect
local rgbConnection
rgbConnection = RunService.Heartbeat:Connect(function()
    local time = tick()
    rgbOverlay.BackgroundColor3 = Color3.fromHSV((time * 0.5) % 1, 0.3, 0.8)
end)

-- Auto-setup on character spawn
player.CharacterAdded:Connect(function(character)
    task.wait(1) -- Wait for character to fully load
    detectPlayerSpawn()
    setupBypassSpeed(character)
end)

-- Setup for existing character
if player.Character then
    task.spawn(function()
        task.wait(1)
        detectPlayerSpawn()
        setupBypassSpeed(player.Character)
    end)
end

-- Initial spawn detection
task.spawn(function()
    task.wait(2)
    detectPlayerSpawn()
end)

print("Steal A Brainrot loaded successfully!")

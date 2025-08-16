-- ========================================
-- MAIN SERVICES
-- ========================================
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
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
-- COMPREHENSIVE SPAWN DETECTION
-- ========================================
local detectedSpawns = {}
local playerSpawn = nil

local function scanForSpawns()
    detectedSpawns = {}
    
    -- Method 1: Official SpawnLocation
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("SpawnLocation") and obj.Parent then
            table.insert(detectedSpawns, {obj = obj, type = "SpawnLocation"})
        end
    end
    
    -- Method 2: Check if player has RespawnLocation
    if player.RespawnLocation then
        table.insert(detectedSpawns, {obj = player.RespawnLocation, type = "RespawnLocation"})
    end
    
    -- Method 3: Find parts with spawn-related names (case insensitive)
    local spawnKeywords = {"spawn", "start", "base", "plot", "home", "lobby"}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Parent then
            local name = obj.Name:lower()
            for _, keyword in pairs(spawnKeywords) do
                if name:find(keyword) then
                    table.insert(detectedSpawns, {obj = obj, type = "KeywordMatch: " .. keyword})
                    break
                end
            end
        end
    end
    
    -- Method 4: Look in common spawn folders
    local spawnFolders = {"Spawns", "SpawnPoints", "PlayerSpawns", "Bases", "Plots"}
    for _, folderName in pairs(spawnFolders) do
        local folder = workspace:FindFirstChild(folderName)
        if folder then
            for _, obj in pairs(folder:GetChildren()) do
                if obj:IsA("BasePart") then
                    table.insert(detectedSpawns, {obj = obj, type = "Folder: " .. folderName})
                end
            end
        end
    end
    
    -- Method 5: Find parts at common spawn heights (usually elevated)
    local candidateParts = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Parent and obj.Size.Y > 0.5 then
            local pos = obj.Position
            if pos.Y > 0 and pos.Y < 200 then -- Reasonable spawn height
                table.insert(candidateParts, obj)
            end
        end
    end
    
    -- Add parts that might be spawns based on position and size
    for _, part in pairs(candidateParts) do
        if part.Size.X > 3 and part.Size.Z > 3 then -- Big enough to spawn on
            table.insert(detectedSpawns, {obj = part, type = "Platform"})
        end
    end
    
    statusLabel.Text = "Found " .. #detectedSpawns .. " potential spawns"
    return #detectedSpawns > 0
end

local function findBestSpawn()
    if #detectedSpawns == 0 then
        scanForSpawns()
    end
    
    if #detectedSpawns == 0 then
        statusLabel.Text = "No spawns detected"
        return nil
    end
    
    local char = player.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then
        return detectedSpawns[1].obj -- Just return first one
    end
    
    local hrp = char.HumanoidRootPart
    local closest = nil
    local shortestDist = math.huge
    
    -- Find closest spawn
    for _, spawnData in pairs(detectedSpawns) do
        if spawnData.obj and spawnData.obj.Parent then
            local dist = (hrp.Position - spawnData.obj.Position).Magnitude
            if dist < shortestDist then
                shortestDist = dist
                closest = spawnData.obj
            end
        end
    end
    
    playerSpawn = closest
    if closest then
        statusLabel.Text = "Using: " .. closest.Name
    end
    return closest
end

-- ========================================
-- STEALTH TELEPORTATION SYSTEM
-- ========================================
local teleporting = false

local function stealthTeleport()
    if teleporting then return end
    teleporting = true
    
    local char = player.Character
    if not char then 
        teleporting = false
        statusLabel.Text = "No character"
        return 
    end
    
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        teleporting = false
        statusLabel.Text = "No HumanoidRootPart"
        return
    end
    
    local targetSpawn = findBestSpawn()
    if not targetSpawn then
        teleporting = false
        statusLabel.Text = "No spawn found"
        return
    end
    
    teleportButton.Text = "Stealing..."
    
    -- Calculate position 5 studs away from spawn
    local spawnPos = targetSpawn.Position
    local randomAngle = math.rad(math.random(0, 360))
    local offset = Vector3.new(
        math.cos(randomAngle) * 5,
        3, -- 3 studs above
        math.sin(randomAngle) * 5
    )
    local targetPos = spawnPos + offset
    
    -- Method 1: Invisible part teleport (most stealth)
    local success = pcall(function()
        local tempPart = Instance.new("Part")
        tempPart.Name = "TempTeleporter"
        tempPart.Size = Vector3.new(1, 1, 1)
        tempPart.Anchored = true
        tempPart.CanCollide = false
        tempPart.Transparency = 1
        tempPart.Position = targetPos
        tempPart.Parent = workspace
        
        -- Teleport character to the invisible part
        char:MoveTo(tempPart.Position)
        
        task.wait(0.2)
        tempPart:Destroy()
    end)
    
    -- Method 2: Root part direct positioning if method 1 failed
    if not success then
        pcall(function()
            hrp.CFrame = CFrame.new(targetPos)
        end)
    end
    
    -- Method 3: PrimaryPart method as final fallback
    task.wait(0.1)
    if (hrp.Position - targetPos).Magnitude > 10 then
        pcall(function()
            if char.PrimaryPart then
                char:SetPrimaryPartCFrame(CFrame.new(targetPos))
            end
        end)
    end
    
    teleportButton.Text = "Steal"
    statusLabel.Text = "Teleported 5 studs away!"
    teleporting = false
end

-- ========================================
-- ULTRA STEALTH SPEED SYSTEM
-- ========================================
local speedActive = false
local speedConnections = {}

local function cleanupSpeed()
    for _, conn in pairs(speedConnections) do
        if conn then conn:Disconnect() end
    end
    speedConnections = {}
    speedActive = false
end

local function setupStealthSpeed(character)
    cleanupSpeed()
    
    local humanoid = character:WaitForChild("Humanoid", 5)
    local rootPart = character:WaitForChild("HumanoidRootPart", 5)
    
    if not humanoid or not rootPart then return end
    
    speedActive = true
    
    -- Ultra stealth method: Micro CFrame adjustments
    local baseSpeed = 16
    local multiplier = 1.8 -- Very conservative multiplier
    local lastPosition = rootPart.Position
    
    speedConnections[1] = RunService.Stepped:Connect(function(_, deltaTime)
        if not speedActive or not rootPart.Parent or humanoid.Health <= 0 then return end
        
        local moveVector = humanoid.MoveDirection
        if moveVector.Magnitude > 0 then
            -- Calculate tiny movement boost
            local boost = moveVector * (baseSpeed * (multiplier - 1) * deltaTime * 0.5)
            
            -- Apply micro-adjustment to position
            local currentCF = rootPart.CFrame
            rootPart.CFrame = currentCF + Vector3.new(boost.X, 0, boost.Z)
            
            lastPosition = rootPart.Position
        end
    end)
    
    -- Keep WalkSpeed exactly normal to avoid any detection
    speedConnections[2] = RunService.Heartbeat:Connect(function()
        if humanoid and humanoid.Parent and humanoid.WalkSpeed ~= 16 then
            humanoid.WalkSpeed = 16
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

-- RGB effect
RunService.Heartbeat:Connect(function()
    local time = tick()
    rgbOverlay.BackgroundColor3 = Color3.fromHSV((time * 0.3) % 1, 0.4, 0.7)
end)

-- Auto-setup when character spawns
player.CharacterAdded:Connect(function(character)
    task.wait(2) -- Wait longer for full load
    scanForSpawns()
    setupStealthSpeed(character)
end)

-- Setup for current character
if player.Character then
    task.spawn(function()
        task.wait(3)
        scanForSpawns()
        setupStealthSpeed(player.Character)
    end)
end

-- Initial scan
task.spawn(function()
    task.wait(1)
    scanForSpawns()
end)

print("Enhanced Steal A Brainrot loaded - " .. #detectedSpawns .. " spawns detected")

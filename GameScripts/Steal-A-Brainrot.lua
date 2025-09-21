local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local StarterPlayer = game:GetService("StarterPlayer")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local LocalPlayer = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Anti Kick
local antiKickEnabled = true

-- Auto Leave After Steal Variables
local autoLeaveEnabled = true
local lastStealCount = 0
local allowedToLeave = false

-- Platform variables
local platformEnabled = false
local currentPlatform = nil
local platformUpdateConnection = nil
local PLATFORM_OFFSET = 3.62
-- NEW VARIABLES FOR SLOW FALL
local SLOW_FALL_SPEED = -0.4 -- Negative because falling down (make smaller like -1 or -0.5 for super slow)
local originalGravity = nil
local bodyVelocity = nil
local floatingEffects = {
    particles = nil,
    textGui = nil,
    leftRing = nil,
    rightRing = nil,
    effectsEnabled = false,
    ringConnection = nil,
    particleConnection = nil
}

-- Wall transparency variables
local wallTransparencyEnabled = false
local originalTransparencies = {}
local TRANSPARENCY_LEVEL = 0.6
local playerCollisionConnection = nil

-- Combo Float + Wall variables
local comboFloatEnabled = false
local comboCurrentPlatform = nil
local comboPlatformUpdateConnection = nil
local comboPlayerCollisionConnection = nil
local COMBO_PLATFORM_OFFSET = 3.57

-- ESP variables
local plotDisplays = {}
local playerBaseName = LocalPlayer.DisplayName .. "'s Base"
local playerBaseTimeWarning = false
local alertGui = nil

-- Animal ESP variables
local espTargetNames = {
    "Noobini Pizzanini", "Los Tralaleritos", "Las Tralaleritas", "Graipuss Medussi",
    "La Grande Combinasion", "Nuclearo Dinossauro", "Garama and Madundung", "Pot Hotspot",
    "Las Vaquitas Saturnitas", "Chicleteira Bicicleteira", "Dragon Cannelloni", "Los Combinasionas",
    "Karkerkar Kurkur", "Los Hotspotsitos", "Esok Sekolah", "Blackhole Goat", "Dul Dul Dul",
    "Tortuginni Dragonfruitini", "Chimpanzini Spiderini", "Los Matteos", "Nooo My Hotspot",
    "Sammyini Spyderini", "La Supreme Combinasion", "Ketupat Kepat", "Los Orcalitos",
    "Urubini Flamenguini", "Tralalita Tralala", "Orcalero Orcala", "Bulbito Bandito Traktorito",
    "Piccione Macchina", "Trippi Troppi Troppa Trippa", "Los Tungtungtungcitos"
}

local espTargetLookup = {}
for _, name in pairs(espTargetNames) do
    espTargetLookup[name] = true
end

local animalESPDisplays = {}
local animalESPEnabled = true

local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlatformUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 280, 0, 150)
mainFrame.Position = UDim2.new(1, -290, 0, 140)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Name = "TitleText"
titleText.Size = UDim2.new(1, -30, 1, 0)
titleText.Position = UDim2.new(0, 5, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🔷 FLOAT + FLOOR STEAL 🔷"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextScaled = true
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -27, 0, 2)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.BorderSizePixel = 0
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

local floatButton = Instance.new("TextButton")
floatButton.Name = "FloatButton"
floatButton.Size = UDim2.new(0, 130, 0, 35)
floatButton.Position = UDim2.new(0, 10, 0, 45)
floatButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
floatButton.Text = "🔷 FLOAT 🔷"
floatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
floatButton.TextScaled = true
floatButton.Font = Enum.Font.GothamBold
floatButton.BorderSizePixel = 0
floatButton.Parent = mainFrame

local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(0, 6)
floatCorner.Parent = floatButton

local wallButton = Instance.new("TextButton")
wallButton.Name = "WallButton"
wallButton.Size = UDim2.new(0, 130, 0, 35)
wallButton.Position = UDim2.new(0, 150, 0, 45)
wallButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
wallButton.Text = "🔷 FLOOR STEAL/ELEVATE 🔷"
wallButton.TextColor3 = Color3.fromRGB(255, 255, 255)
wallButton.TextScaled = true
wallButton.Font = Enum.Font.GothamBold
wallButton.BorderSizePixel = 0
wallButton.Parent = mainFrame

local wallCorner = Instance.new("UICorner")
wallCorner.CornerRadius = UDim.new(0, 6)
wallCorner.Parent = wallButton

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 90)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Float: OFF | Walls: OFF"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

local creditLabel = Instance.new("TextLabel")
creditLabel.Name = "CreditLabel"
creditLabel.Size = UDim2.new(1, -20, 0, 20)
creditLabel.Position = UDim2.new(0, 10, 0, 120)
creditLabel.BackgroundTransparency = 1
creditLabel.Text = "by PickleTalk"
creditLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
creditLabel.TextScaled = true
creditLabel.Font = Enum.Font.Gotham
creditLabel.TextXAlignment = Enum.TextXAlignment.Left
creditLabel.Parent = mainFrame

local dragging = false
local dragStart = nil
local startPos = nil

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
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            updateDrag(input)
        end
    end
end)

local leaveButton = Instance.new("TextButton")
leaveButton.Name = "LeaveButton"
leaveButton.Size = UDim2.new(0, 25, 0, 25)
leaveButton.Position = UDim2.new(1, -54, 0, 2) -- Position next to close button
leaveButton.BackgroundColor3 = Color3.fromRGB(0, 50, 150) -- Dark blue
leaveButton.Text = "Leave"
leaveButton.TextColor3 = Color3.fromRGB(255, 255, 255)
leaveButton.TextScaled = true
leaveButton.Font = Enum.Font.GothamBold
leaveButton.BorderSizePixel = 0
leaveButton.Parent = titleBar

local leaveCorner = Instance.new("UICorner")
leaveCorner.CornerRadius = UDim.new(0, 4)
leaveCorner.Parent = leaveButton

local function createFloatingEffects()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    -- Clean up any existing effects first
    removeFloatingEffects()
    
    local rootPart = player.Character.HumanoidRootPart
    print("Creating floating effects for", player.Name)
    
    -- Create enhanced blue particles (tearing effect)
    local attachment = Instance.new("Attachment")
    attachment.Name = "FloatingParticleAttachment"
    attachment.Parent = rootPart
    
    local particles = Instance.new("ParticleEmitter")
    particles.Name = "FloatingParticles"
    particles.Parent = attachment
    particles.Texture = "rbxasset://textures/particles/sparkles_main.dds" -- Working texture
    particles.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 100, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 162, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255))
    }
    particles.Size = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 1.0),
        NumberSequenceKeypoint.new(0.5, 2.0),
        NumberSequenceKeypoint.new(1, 0.5)
    }
    particles.Lifetime = NumberRange.new(1.0, 2.5)
    particles.Rate = 100
    particles.SpreadAngle = Vector2.new(360, 360)
    particles.Speed = NumberRange.new(5, 12)
    particles.Acceleration = Vector3.new(0, -10, 0) -- Strong downward pull
    particles.Transparency = NumberSequence.new{
        ColorSequenceKeypoint.new(0, 0.0),
        ColorSequenceKeypoint.new(0.3, 0.2),
        ColorSequenceKeypoint.new(0.7, 0.5),
        ColorSequenceKeypoint.new(1, 1.0)
    }
    particles.LightEmission = 1.0
    particles.LightInfluence = 0.0
    particles.Enabled = true -- Make sure it's enabled
    
    print("Created particles with rate:", particles.Rate)
    
    -- Create smaller "FLOATING" text above player
    local textGui = Instance.new("BillboardGui")
    textGui.Name = "FloatingText"
    textGui.Parent = rootPart
    textGui.Size = UDim2.new(0, 120, 0, 30)
    textGui.StudsOffset = Vector3.new(0, 4, 0)
    textGui.AlwaysOnTop = true
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = textGui
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "FLOATING"
    textLabel.TextColor3 = Color3.fromRGB(0, 162, 255)
    textLabel.TextScaled = true
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 50, 100)
    textLabel.Font = Enum.Font.GothamBold
    
    print("Created floating text")
    
    -- Create left torn ring using UnionOperation for better control
    local leftRing = Instance.new("Part")
    leftRing.Name = "LeftFloatingRing"
    leftRing.Parent = workspace
    leftRing.Size = Vector3.new(0.4, 8, 8)
    leftRing.Material = Enum.Material.ForceField
    leftRing.Color = Color3.fromRGB(0, 150, 255)
    leftRing.Anchored = true
    leftRing.CanCollide = false
    leftRing.Shape = Enum.PartType.Cylinder
    leftRing.Transparency = 0.3
    leftRing.Position = rootPart.Position + Vector3.new(5, 0, 0)
    
    -- Create torn sections by making the ring look damaged
    local leftHole1 = Instance.new("Part")
    leftHole1.Name = "LeftHole1"
    leftHole1.Parent = workspace
    leftHole1.Size = Vector3.new(0.5, 3, 3)
    leftHole1.Material = Enum.Material.Neon
    leftHole1.Color = Color3.fromRGB(0, 100, 200)
    leftHole1.Anchored = true
    leftHole1.CanCollide = false
    leftHole1.Shape = Enum.PartType.Block
    leftHole1.Transparency = 0.2
    leftHole1.Position = leftRing.Position + Vector3.new(0, 2, 2)
    
    local leftHole2 = Instance.new("Part")
    leftHole2.Name = "LeftHole2"
    leftHole2.Parent = workspace
    leftHole2.Size = Vector3.new(0.5, 2, 4)
    leftHole2.Material = Enum.Material.Neon
    leftHole2.Color = Color3.fromRGB(0, 100, 200)
    leftHole2.Anchored = true
    leftHole2.CanCollide = false
    leftHole2.Shape = Enum.PartType.Block
    leftHole2.Transparency = 0.2
    leftHole2.Position = leftRing.Position + Vector3.new(0, -2.5, -1)
    
    -- Create right torn ring
    local rightRing = Instance.new("Part")
    rightRing.Name = "RightFloatingRing"
    rightRing.Parent = workspace
    rightRing.Size = Vector3.new(0.4, 6, 6)
    rightRing.Material = Enum.Material.ForceField
    rightRing.Color = Color3.fromRGB(0, 150, 255)
    rightRing.Anchored = true
    rightRing.CanCollide = false
    rightRing.Shape = Enum.PartType.Cylinder
    rightRing.Transparency = 0.3
    rightRing.Position = rootPart.Position + Vector3.new(-4, 0, 0)
    
    -- Create torn sections for right ring
    local rightHole1 = Instance.new("Part")
    rightHole1.Name = "RightHole1"
    rightHole1.Parent = workspace
    rightHole1.Size = Vector3.new(0.5, 2, 2.5)
    rightHole1.Material = Enum.Material.Neon
    rightHole1.Color = Color3.fromRGB(0, 100, 200)
    rightHole1.Anchored = true
    rightHole1.CanCollide = false
    rightHole1.Shape = Enum.PartType.Block
    rightHole1.Transparency = 0.2
    rightHole1.Position = rightRing.Position + Vector3.new(0, 1.5, 1.5)
    
    local rightHole2 = Instance.new("Part")
    rightHole2.Name = "RightHole2"
    rightRing.Parent = workspace
    rightHole2.Size = Vector3.new(0.5, 3, 1.5)
    rightHole2.Material = Enum.Material.Neon
    rightHole2.Color = Color3.fromRGB(0, 100, 200)
    rightHole2.Anchored = true
    rightHole2.CanCollide = false
    rightHole2.Shape = Enum.PartType.Block
    rightHole2.Transparency = 0.2
    rightHole2.Position = rightRing.Position + Vector3.new(0, -1, -2)
    
    -- Add strong glow effects
    local leftGlow = Instance.new("PointLight")
    leftGlow.Color = Color3.fromRGB(0, 162, 255)
    leftGlow.Brightness = 5
    leftGlow.Range = 20
    leftGlow.Parent = leftRing
    
    local rightGlow = Instance.new("PointLight")
    rightGlow.Color = Color3.fromRGB(0, 162, 255)
    rightGlow.Brightness = 5
    rightGlow.Range = 20
    rightGlow.Parent = rightRing
    
    print("Created rings and holes")
    
    -- Store references
    floatingEffects.particles = attachment
    floatingEffects.textGui = textGui
    floatingEffects.leftRing = leftRing
    floatingEffects.rightRing = rightRing
    floatingEffects.effectsEnabled = true
    
    -- Start ring animation and positioning
    floatingEffects.ringConnection = RunService.Heartbeat:Connect(function()
        if not floatingEffects.effectsEnabled or not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        local currentRootPart = player.Character.HumanoidRootPart
        local time = tick() * 2 -- Rotation speed
        
        -- Update left ring with irregular movement
        if leftRing and leftRing.Parent then
            local leftOffset = Vector3.new(
                math.cos(time) * 6 + math.sin(time * 2) * 1,
                math.sin(time * 0.5) * 2,
                math.sin(time) * 6 + math.cos(time * 1.5) * 1
            )
            leftRing.Position = currentRootPart.Position + leftOffset
            leftRing.Rotation = Vector3.new(0, math.deg(time * 1.5), 90)
            
            -- Update holes to follow the ring
            if leftHole1 and leftHole1.Parent then
                leftHole1.Position = leftRing.Position + Vector3.new(0, 2, 2)
                leftHole1.Rotation = leftRing.Rotation + Vector3.new(15, 0, 0)
            end
            if leftHole2 and leftHole2.Parent then
                leftHole2.Position = leftRing.Position + Vector3.new(0, -2.5, -1)
                leftHole2.Rotation = leftRing.Rotation + Vector3.new(-20, 0, 0)
            end
        end
        
        -- Update right ring with different pattern
        if rightRing and rightRing.Parent then
            local rightOffset = Vector3.new(
                math.cos(-time * 1.2) * 4 + math.sin(-time * 2.2) * 1,
                math.sin(-time * 0.7) * 1.5,
                math.sin(-time * 1.1) * 4 + math.cos(-time * 1.8) * 1
            )
            rightRing.Position = currentRootPart.Position + rightOffset
            rightRing.Rotation = Vector3.new(0, math.deg(-time * 1.8), 90)
            
            -- Update holes to follow the ring
            if rightHole1 and rightHole1.Parent then
                rightHole1.Position = rightRing.Position + Vector3.new(0, 1.5, 1.5)
                rightHole1.Rotation = rightRing.Rotation + Vector3.new(10, 0, 0)
            end
            if rightHole2 and rightHole2.Parent then
                rightHole2.Position = rightRing.Position + Vector3.new(0, -1, -2)
                rightHole2.Rotation = rightRing.Rotation + Vector3.new(-15, 0, 0)
            end
        end
    end)
    
    print("Started animation connections")
end

-- Enhanced removal function with proper cleanup
local function removeFloatingEffects()
    floatingEffects.effectsEnabled = false
    print("Removing floating effects...")
    
    -- Disconnect connections first
    if floatingEffects.ringConnection then
        floatingEffects.ringConnection:Disconnect()
        floatingEffects.ringConnection = nil
        print("Disconnected ring connection")
    end
    
    if floatingEffects.particleConnection then
        floatingEffects.particleConnection:Disconnect()
        floatingEffects.particleConnection = nil
    end
    
    -- Remove particles and attachment
    if floatingEffects.particles then
        local particleEmitter = floatingEffects.particles:FindFirstChild("FloatingParticles")
        if particleEmitter then
            particleEmitter.Enabled = false
            task.wait(0.1)
            particleEmitter:Destroy()
        end
        floatingEffects.particles:Destroy()
        floatingEffects.particles = nil
        print("Removed particles")
    end
    
    -- Remove text GUI
    if floatingEffects.textGui then
        floatingEffects.textGui:Destroy()
        floatingEffects.textGui = nil
        print("Removed text GUI")
    end
    
    -- Remove rings
    if floatingEffects.leftRing then
        floatingEffects.leftRing:Destroy()
        floatingEffects.leftRing = nil
        print("Removed left ring")
    end
    
    if floatingEffects.rightRing then
        floatingEffects.rightRing:Destroy()
        floatingEffects.rightRing = nil
        print("Removed right ring")
    end
    
    -- Clean up any leftover parts in workspace
    for _, obj in pairs(workspace:GetChildren()) do
        if obj.Name and (string.find(obj.Name, "Hole") or string.find(obj.Name, "FloatingRing")) then
            obj:Destroy()
            print("Cleaned up leftover part:", obj.Name)
        end
    end
    
    -- Extra cleanup on character
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local rootPart = player.Character.HumanoidRootPart
        
        for _, child in pairs(rootPart:GetChildren()) do
            if child.Name == "FloatingParticleAttachment" or child.Name == "FloatingText" then
                child:Destroy()
                print("Cleaned up character attachment:", child.Name)
            end
        end
    end
    
    print("✅ All floating effects cleaned up")
end

local function createPlatform()
    local platform = Instance.new("Part")
    platform.Name = "PlayerPlatform"
    platform.Size = Vector3.new(8, 0.5, 8)
    platform.Material = Enum.Material.Neon
    platform.BrickColor = BrickColor.new("Bright blue")
    platform.Anchored = true
    platform.CanCollide = false -- Make it non-collidable so player falls through
    platform.Shape = Enum.PartType.Block
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Parent = workspace
    platform.Transparency = 1 -- Make it more transparent since it's just visual
    
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.fromRGB(0, 162, 255)
    pointLight.Brightness = 1
    pointLight.Range = 10
    pointLight.Parent = platform
    
    return platform
end

local function updatePlatformPosition()
    if not platformEnabled or not currentPlatform or not player.Character then
        return
    end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        local playerPosition = humanoidRootPart.Position
        local platformPosition = Vector3.new(
            playerPosition.X, 
            playerPosition.Y - PLATFORM_OFFSET, 
            playerPosition.Z
        )
        currentPlatform.Position = platformPosition
    end
end

local function applySlowFall()
    if not player.Character then return end
    
    local character = player.Character
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Store original gravity if not stored
    if not originalGravity then
        originalGravity = workspace.Gravity
    end
    
    -- Create BodyVelocity to control falling speed
    if not bodyVelocity or not bodyVelocity.Parent then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0) -- Only affect Y axis
        bodyVelocity.Velocity = Vector3.new(0, SLOW_FALL_SPEED, 0) -- Slow downward movement
        bodyVelocity.Parent = rootPart
    end
    
    -- Force the character into falling state to trigger animation
    task.spawn(function()
        while platformEnabled do
            if humanoid and humanoid.Parent then
                -- Keep forcing falling state
                humanoid:ChangeState(Enum.HumanoidStateType.Freefall)
                -- Update velocity to maintain slow fall
                if bodyVelocity and bodyVelocity.Parent then
                    bodyVelocity.Velocity = Vector3.new(0, SLOW_FALL_SPEED, 0)
                end
            end
            task.wait(0.1)
        end
    end)
end

-- NEW FUNCTION: Remove slow fall effect
local function removeSlowFall()
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    
    if player.Character then
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            -- Return to normal state
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end
end

-- Replace your enablePlatform function:
local function enablePlatform()
    if platformEnabled then return end
    
    platformEnabled = true
    currentPlatform = createPlatform()
    
    -- Apply slow fall effect
    applySlowFall()
    
    platformUpdateConnection = RunService.Heartbeat:Connect(updatePlatformPosition)
    updatePlatformPosition()

    createFloatingEffects()
    
    floatButton.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
    floatButton.Text = "🔷 FLOAT 🔷"
    
    local wallStatus = wallTransparencyEnabled and "ON" or "OFF"
    statusLabel.Text = "Float: ON | Walls: " .. wallStatus
end

-- Replace your disablePlatform function:
local function disablePlatform()
    if not platformEnabled then return end

    removeFloatingEffects()
    
    platformEnabled = false
    
    -- Remove slow fall effect
    removeSlowFall()
    
    if platformUpdateConnection then
        platformUpdateConnection:Disconnect()
        platformUpdateConnection = nil
    end
    
    if currentPlatform then
        currentPlatform:Destroy()
        currentPlatform = nil
    end
    
    floatButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    floatButton.Text = "🔷 FLOAT 🔷"
    
    local wallStatus = wallTransparencyEnabled and "ON" or "OFF"
    statusLabel.Text = "Float: OFF | Walls: " .. wallStatus
end

local function storeOriginalTransparencies()
    originalTransparencies = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Parent ~= player.Character and obj.Name ~= "PlayerPlatform" and obj.Name ~= "ComboPlayerPlatform" then
            local name = obj.Name
            if name == "structure base home" then
                originalTransparencies[obj] = {
                    transparency = obj.Transparency,
                    canCollide = obj.CanCollide
                }
            end
        end
    end
    print("Stored transparency for " .. #originalTransparencies .. " parts")
end

local function makeWallsTransparent(transparent)
    local count = 0
    for obj, data in pairs(originalTransparencies) do
        if obj and obj.Parent and data then
            if transparent then
                obj.Transparency = TRANSPARENCY_LEVEL
                obj.CanCollide = false
                count = count + 1
            else
                obj.Transparency = data.transparency
                obj.CanCollide = data.canCollide
            end
        end
    end
    print((transparent and "Made transparent: " or "Restored: ") .. count .. " parts")
end
local function createComboPlatform()
    local platform = Instance.new("Part")
    platform.Name = "ComboPlayerPlatform"
    platform.Size = Vector3.new(8, 1.5, 8)
    platform.Material = Enum.Material.Neon
    platform.BrickColor = BrickColor.new("Bright blue")
    platform.Anchored = true
    platform.CanCollide = true
    platform.Shape = Enum.PartType.Block
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Parent = workspace
    platform.Transparency = 1
    
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.fromRGB(0, 162, 255)
    pointLight.Brightness = 1
    pointLight.Range = 15
    pointLight.Parent = platform
    
    return platform
end

local function updateComboPlatformPosition()
    if not comboFloatEnabled or not comboCurrentPlatform or not player.Character then
        return
    end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        local playerPosition = humanoidRootPart.Position
        local platformPosition = Vector3.new(
            playerPosition.X, 
            playerPosition.Y - COMBO_PLATFORM_OFFSET, 
            playerPosition.Z
        )
        comboCurrentPlatform.Position = platformPosition
    end
end

local function forcePlayerHeadCollision()
    if player.Character then
        local head = player.Character:FindFirstChild("Head")
        if head then
            head.CanCollide = true
        end
        -- Also ensure other body parts maintain collision
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.CanCollide = true
        end
        local torso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
        if torso then
            torso.CanCollide = true
        end
    end
end

local function enableWallTransparency()
    if wallTransparencyEnabled then return end
    
    print("Enabling wall transparency...")
    wallTransparencyEnabled = true
    comboFloatEnabled = true
    
    storeOriginalTransparencies()
    makeWallsTransparent(true)
    
    -- Create and manage platform
    comboCurrentPlatform = createComboPlatform()
    comboPlatformUpdateConnection = RunService.Heartbeat:Connect(updateComboPlatformPosition)
    updateComboPlatformPosition()
    
    -- Force player collision more aggressively
    comboPlayerCollisionConnection = RunService.Heartbeat:Connect(function()
        forcePlayerHeadCollision()
    end)
    
    -- Also set initial collision state
    forcePlayerHeadCollision()
    
    wallButton.BackgroundColor3 = Color3.fromRGB(150, 50, 0)
    wallButton.Text = "🔷 FLOOR STEAL 🔷"
    
    local floatStatus = platformEnabled and "ON" or "OFF"
    statusLabel.Text = "Float: " .. floatStatus .. " | Walls: ON"
end

local function disableWallTransparency()
    if not wallTransparencyEnabled then return end
    
    print("Disabling wall transparency...")
    wallTransparencyEnabled = false
    comboFloatEnabled = false
    
    makeWallsTransparent(false)
    originalTransparencies = {}
    
    -- Stop platform updates and remove platform
    if comboPlatformUpdateConnection then
        comboPlatformUpdateConnection:Disconnect()
        comboPlatformUpdateConnection = nil
    end
    
    if comboCurrentPlatform then
        comboCurrentPlatform:Destroy()
        comboCurrentPlatform = nil
    end
    
    -- Stop head collision enforcement
    if comboPlayerCollisionConnection then
        comboPlayerCollisionConnection:Disconnect()
        comboPlayerCollisionConnection = nil
    end
    
    -- Restore normal player collision state
    if player.Character then
        local head = player.Character:FindFirstChild("Head")
        if head then
            head.CanCollide = false -- Default Roblox state for head
        end
    end
    
    wallButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    wallButton.Text = "🔷 FLOOR STEAL 🔷"
    
    local floatStatus = platformEnabled and "ON" or "OFF"
    statusLabel.Text = "Float: " .. floatStatus .. " | Walls: OFF"
end

local function createAlertGui()
    if alertGui then return end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    screenGui.Name = "BaseTimeAlert"
    screenGui.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Parent = screenGui
    frame.Size = UDim2.new(0, 300, 0, 80)
    frame.Position = UDim2.new(0.5, -150, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 8)
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = frame
    textLabel.Size = UDim2.new(1, -10, 1, -10)
    textLabel.Position = UDim2.new(0, 5, 0, 5)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "⚠️ BASE TIME WARNING ⚠️"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSansBold
    
    local tween = TweenService:Create(
        frame,
        TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {BackgroundColor3 = Color3.fromRGB(150, 0, 0)}
    )
    tween:Play()
    
    alertGui = {
        screenGui = screenGui,
        textLabel = textLabel,
        tween = tween
    }
end

local function updateAlertGui(timeText)
    if not alertGui then return end
    alertGui.textLabel.Text = "⚠️ BASE UNLOCKING IN " .. timeText .. " ⚠️"
end

local function removeAlertGui()
    if alertGui then
        if alertGui.tween then
            alertGui.tween:Cancel()
        end
        alertGui.screenGui:Destroy()
        alertGui = nil
        playerBaseTimeWarning = false
    end
end

local function parseTimeToSeconds(timeText)
    if not timeText or timeText == "" then return nil end
    
    local minutes, seconds = timeText:match("(%d+):(%d+)")
    if minutes and seconds then
        return tonumber(minutes) * 60 + tonumber(seconds)
    end
    
    local secondsOnly = timeText:match("(%d+)s")
    if secondsOnly then
        return tonumber(secondsOnly)
    end
    
    local minutesOnly = timeText:match("(%d+)m")
    if minutesOnly then
        return tonumber(minutesOnly) * 60
    end
    
    return nil
end

function createPlayerESP(player, head)
    local existingGui = head:FindFirstChild("PlayerESP")
    if existingGui then
        existingGui:Destroy()
    end
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "PlayerESP"
    billboardGui.Parent = head
    billboardGui.Size = UDim2.new(0, 90, 0, 33)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.AlwaysOnTop = true
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboardGui
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = player.DisplayName
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.TextStrokeTransparency = 0.3
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSans
end

local function createPlayerDisplay(player)
    if player == LocalPlayer then return end
    
    local character = player.Character
    if not character then
        player.CharacterAdded:Connect(function(char)
            character = char
            task.wait(0.5)
            local head = character:FindFirstChild("Head")
            if head then
                createPlayerESP(player, head)
            end
        end)
        return
    end
    
    local head = character:FindFirstChild("Head")
    if head then
        createPlayerESP(player, head)
    else
        character.ChildAdded:Connect(function(child)
            if child.Name == "Head" then
                createPlayerESP(player, child)
            end
        end)
    end
end

local function createOrUpdatePlotDisplay(plot)
    if not plot or not plot.Parent then return end
    
    local plotName = plot.Name
    
    local plotSignText = ""
    local signPath = plot:FindFirstChild("PlotSign")
    if signPath and signPath:FindFirstChild("SurfaceGui") then
        local surfaceGui = signPath.SurfaceGui
        if surfaceGui:FindFirstChild("Frame") and surfaceGui.Frame:FindFirstChild("TextLabel") then
            plotSignText = surfaceGui.Frame.TextLabel.Text
        end
    end
    
    if plotSignText == "Empty Base" or plotSignText == "" or plotSignText == "Empty's Base" then
        if plotDisplays[plotName] and plotDisplays[plotName].gui then
            plotDisplays[plotName].gui:Destroy()
            plotDisplays[plotName] = nil
        end
        return
    end
    
    local plotTimeText = ""
    local purchasesPath = plot:FindFirstChild("Purchases")
    if purchasesPath and purchasesPath:FindFirstChild("PlotBlock") then
        local plotBlock = purchasesPath.PlotBlock
        if plotBlock:FindFirstChild("Main") and plotBlock.Main:FindFirstChild("BillboardGui") then
            local billboardGui = plotBlock.Main.BillboardGui
            if billboardGui:FindFirstChild("RemainingTime") then
                plotTimeText = billboardGui.RemainingTime.Text
            end
        end
    end
    
    if plotSignText == playerBaseName then
        local remainingSeconds = parseTimeToSeconds(plotTimeText)
        
        if remainingSeconds and remainingSeconds <= 10 and remainingSeconds > 0 then
            if not playerBaseTimeWarning then
                createAlertGui()
                playerBaseTimeWarning = true
            end
            updateAlertGui(plotTimeText)
        elseif remainingSeconds and remainingSeconds > 10 then
            if playerBaseTimeWarning then
                removeAlertGui()
            end
        elseif not remainingSeconds or remainingSeconds <= 0 then
            if playerBaseTimeWarning then
                removeAlertGui()
            end
        end
    end
    
    local displayPart = plot:FindFirstChild("PlotSign")
    if not displayPart then
        for _, child in pairs(plot:GetChildren()) do
            if child:IsA("Part") or child:IsA("MeshPart") then
                displayPart = child
                break
            end
        end
    end
    
    if not displayPart then return end
    
    if not plotDisplays[plotName] then
        local existingBillboard = displayPart:FindFirstChild("PlotESP")
        if existingBillboard then
            existingBillboard:Destroy()
        end
        
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "PlotESP"
        billboardGui.Parent = displayPart
        billboardGui.Size = UDim2.new(0, 150, 0, 60)
        billboardGui.StudsOffset = Vector3.new(0, 8, 0)
        billboardGui.AlwaysOnTop = true
        
        local frame = Instance.new("Frame")
        frame.Parent = billboardGui
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 0.7
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        frame.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.Parent = frame
        corner.CornerRadius = UDim.new(0, 4)
        
        local signLabel = Instance.new("TextLabel")
        signLabel.Parent = frame
        signLabel.Size = UDim2.new(1, -4, 0.6, 0)
        signLabel.Position = UDim2.new(0, 2, 0, 2)
        signLabel.BackgroundTransparency = 1
        signLabel.Text = plotSignText
        signLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        signLabel.TextScaled = true
        signLabel.TextStrokeTransparency = 0.3
        signLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        signLabel.Font = Enum.Font.SourceSansBold
        
        local timeLabel = Instance.new("TextLabel")
        timeLabel.Parent = frame
        timeLabel.Size = UDim2.new(1, -4, 0.4, 0)
        timeLabel.Position = UDim2.new(0, 2, 0.6, 0)
        timeLabel.BackgroundTransparency = 1
        timeLabel.Text = plotTimeText
        timeLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        timeLabel.TextScaled = true
        timeLabel.TextStrokeTransparency = 0.3
        timeLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        timeLabel.Font = Enum.Font.SourceSans
        
        plotDisplays[plotName] = {
            gui = billboardGui,
            signLabel = signLabel,
            timeLabel = timeLabel,
            plot = plot
        }
    else
        if plotDisplays[plotName].signLabel then
            plotDisplays[plotName].signLabel.Text = plotSignText
        end
        if plotDisplays[plotName].timeLabel then
            plotDisplays[plotName].timeLabel.Text = plotTimeText
        end
    end
end

local function updateAllPlots()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    
    for _, plot in pairs(plots:GetChildren()) do
        if plot:IsA("Model") or plot:IsA("Folder") then
            pcall(function()
                createOrUpdatePlotDisplay(plot)
            end)
        end
    end
    
    for plotName, display in pairs(plotDisplays) do
        if not plots:FindFirstChild(plotName) then
            if display.gui then
                display.gui:Destroy()
            end
            plotDisplays[plotName] = nil
        end
    end
end

local function createAnimalESP(object, name)
    if not object or not object.Parent or not animalESPEnabled then return end
    
    for _, child in pairs(object:GetChildren()) do
        if child.Name == "AnimalESP" then
            child:Destroy()
        end
    end
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "AnimalESP"
    billboardGui.Parent = object
    billboardGui.Size = UDim2.new(0, 120, 0, 35)
    billboardGui.StudsOffset = Vector3.new(0, 5, 0)
    billboardGui.AlwaysOnTop = true
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboardGui
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = name
    textLabel.TextColor3 = Color3.fromRGB(255, 100, 255)
    textLabel.TextScaled = true
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSansBold
    
    return billboardGui
end

-- Replace the existing animal ESP functions with these modified versions

local function scanForTargetAnimals()
    -- Clear existing displays that no longer exist
    for objId, display in pairs(animalESPDisplays) do
        if not display.object or not display.object.Parent or not display.part or not display.part.Parent then
            if display.gui then
                display.gui:Destroy()
            end
            animalESPDisplays[objId] = nil
        end
    end
    
    -- Scan workspace.Plots folder
    local plots = workspace:FindFirstChild("Plots")
    if plots then
        -- Check each randomly named plot model
        for _, plot in pairs(plots:GetChildren()) do
            if plot:IsA("Model") then
                -- Check direct children of this plot for target animals
                for _, child in pairs(plot:GetChildren()) do
                    if child:IsA("Model") and espTargetLookup[child.Name] then
                        local objId = tostring(child)
                        
                        if not animalESPDisplays[objId] then
                            local targetPart = child:FindFirstChild("RootPart") or 
                                             child:FindFirstChild("FakeRootPart")
                            
                            if targetPart then
                                local espGui = createAnimalESP(targetPart, child.Name)
                                if espGui then
                                    animalESPDisplays[objId] = {
                                        gui = espGui,
                                        object = child,
                                        part = targetPart,
                                        plotParent = plot,
                                        source = "Plots"
                                    }
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    -- Scan workspace.RenderedMovingAnimals folder
    local renderedAnimals = workspace:FindFirstChild("RenderedMovingAnimals")
    if renderedAnimals then
        -- Check direct children for target animals
        for _, child in pairs(renderedAnimals:GetChildren()) do
            if child:IsA("Model") and espTargetLookup[child.Name] then
                local objId = tostring(child)
                
                if not animalESPDisplays[objId] then
                    local targetPart = child:FindFirstChild("RootPart") or 
                                     child:FindFirstChild("FakeRootPart")
                    
                    if targetPart then
                        local espGui = createAnimalESP(targetPart, child.Name)
                        if espGui then
                            animalESPDisplays[objId] = {
                                gui = espGui,
                                object = child,
                                part = targetPart,
                                plotParent = renderedAnimals,
                                source = "RenderedMovingAnimals"
                            }
                        end
                    end
                end
            end
        end
    end
end

local function initializeAnimalESP()
    task.wait(2)
    scanForTargetAnimals()
    
    -- Monitor workspace.Plots for new plots
    local plots = workspace:FindFirstChild("Plots")
    if plots then
        plots.ChildAdded:Connect(function(newPlot)
            if newPlot:IsA("Model") then
                task.wait(0.5) -- Wait for the plot to fully load
                
                -- Scan the new plot's direct children for target animals
                for _, child in pairs(newPlot:GetChildren()) do
                    if child:IsA("Model") and espTargetLookup[child.Name] then
                        local objId = tostring(child)
                        
                        if not animalESPDisplays[objId] then
                            local targetPart = child:FindFirstChild("VfxInstance") or 
                                             child:FindFirstChild("RootPart") or 
                                             child:FindFirstChild("FakeRootPart") or
                                             child:FindFirstChildOfClass("Part") or
                                             child:FindFirstChildOfClass("MeshPart")
                            
                            if targetPart then
                                local espGui = createAnimalESP(targetPart, child.Name)
                                if espGui then
                                    animalESPDisplays[objId] = {
                                        gui = espGui,
                                        object = child,
                                        part = targetPart,
                                        plotParent = newPlot,
                                        source = "Plots"
                                    }
                                end
                            end
                        end
                    end
                end
                
                -- Monitor when new animals are added directly to this plot
                newPlot.ChildAdded:Connect(function(child)
                    if child:IsA("Model") and espTargetLookup[child.Name] then
                        task.wait(0.5)
                        
                        local objId = tostring(child)
                        if not animalESPDisplays[objId] then
                            local targetPart = child:FindFirstChild("VfxInstance") or 
                                             child:FindFirstChild("RootPart") or 
                                             child:FindFirstChild("FakeRootPart") or
                                             child:FindFirstChildOfClass("Part") or
                                             child:FindFirstChildOfClass("MeshPart")
                            
                            if targetPart then
                                local espGui = createAnimalESP(targetPart, child.Name)
                                if espGui then
                                    animalESPDisplays[objId] = {
                                        gui = espGui,
                                        object = child,
                                        part = targetPart,
                                        plotParent = newPlot,
                                        source = "Plots"
                                    }
                                end
                            end
                        end
                    end
                end)
            end
        end)
        
        -- Monitor for plots being removed
        plots.ChildRemoved:Connect(function(removedPlot)
            -- Clean up ESP displays for animals that were in the removed plot
            for objId, display in pairs(animalESPDisplays) do
                if display.plotParent == removedPlot and display.source == "Plots" then
                    if display.gui then
                        display.gui:Destroy()
                    end
                    animalESPDisplays[objId] = nil
                end
            end
        end)
    end
    
    -- Monitor workspace.RenderedMovingAnimals for new animals
    local renderedAnimals = workspace:FindFirstChild("RenderedMovingAnimals")
    if renderedAnimals then
        renderedAnimals.ChildAdded:Connect(function(child)
            if child:IsA("Model") and espTargetLookup[child.Name] then
                task.wait(0.5)
                
                local objId = tostring(child)
                if not animalESPDisplays[objId] then
                    local targetPart = child:FindFirstChild("HumanoidRootPart") or 
                                     child:FindFirstChild("Torso") or 
                                     child:FindFirstChild("Head") or
                                     child:FindFirstChildOfClass("Part") or
                                     child:FindFirstChildOfClass("MeshPart")
                    
                    if targetPart then
                        local espGui = createAnimalESP(targetPart, child.Name)
                        if espGui then
                            animalESPDisplays[objId] = {
                                gui = espGui,
                                object = child,
                                part = targetPart,
                                plotParent = renderedAnimals,
                                source = "RenderedMovingAnimals"
                            }
                        end
                    end
                end
            end
        end)
        
        -- Monitor for animals being removed from RenderedMovingAnimals
        renderedAnimals.ChildRemoved:Connect(function(removedChild)
            for objId, display in pairs(animalESPDisplays) do
                if display.object == removedChild and display.source == "RenderedMovingAnimals" then
                    if display.gui then
                        display.gui:Destroy()
                    end
                    animalESPDisplays[objId] = nil
                end
            end
        end)
    end
    
    -- Monitor if RenderedMovingAnimals folder gets created later
    workspace.ChildAdded:Connect(function(child)
        if child.Name == "RenderedMovingAnimals" and child:IsA("Folder") then
            task.wait(0.5)
            -- Scan existing animals in the new folder
            for _, animal in pairs(child:GetChildren()) do
                if animal:IsA("Model") and espTargetLookup[animal.Name] then
                    local objId = tostring(animal)
                    
                    if not animalESPDisplays[objId] then
                        local targetPart = animal:FindFirstChild("VfxInstance") or 
                                         animal:FindFirstChild("RootPart") or 
                                         animal:FindFirstChild("FakeRootPart") or
                                         animal:FindFirstChildOfClass("Part") or
                                         animal:FindFirstChildOfClass("MeshPart")
                        
                        if targetPart then
                            local espGui = createAnimalESP(targetPart, animal.Name)
                            if espGui then
                                animalESPDisplays[objId] = {
                                    gui = espGui,
                                    object = animal,
                                    part = targetPart,
                                    plotParent = child,
                                    source = "RenderedMovingAnimals"
                                }
                            end
                        end
                    end
                end
            end
            
            -- Set up monitoring for this new folder
            child.ChildAdded:Connect(function(animal)
                if animal:IsA("Model") and espTargetLookup[animal.Name] then
                    task.wait(0.5)
                    
                    local objId = tostring(animal)
                    if not animalESPDisplays[objId] then
                        local targetPart = animal:FindFirstChild("VfxInstance") or 
                                         animal:FindFirstChild("RootPart") or 
                                         animal:FindFirstChild("FakeRootPart") or
                                         animal:FindFirstChildOfClass("Part") or
                                         animal:FindFirstChildOfClass("MeshPart")
                        
                        if targetPart then
                            local espGui = createAnimalESP(targetPart, animal.Name)
                            if espGui then
                                animalESPDisplays[objId] = {
                                    gui = espGui,
                                    object = animal,
                                    part = targetPart,
                                    plotParent = child,
                                    source = "RenderedMovingAnimals"
                                }
                            end
                        end
                    end
                end
            end)
        end
    end)
    
    -- Periodic cleanup and rescan
    task.spawn(function()
        while animalESPEnabled do
            task.wait(5)
            pcall(scanForTargetAnimals)
        end
    end)
end

local jumpDelayConnections = {}

local function cleanupJumpDelayConnections(character)
    if jumpDelayConnections[character] then
        for _, connection in pairs(jumpDelayConnections[character]) do
            if connection and connection.Connected then
                connection:Disconnect()
            end
        end
        jumpDelayConnections[character] = nil
    end
end

local function setupNoJumpDelay(character)
    cleanupJumpDelayConnections(character)
    
    local humanoid = character:WaitForChild("Humanoid")
    if not humanoid then return end
    
    jumpDelayConnections[character] = {}

    local stateConnection = humanoid.StateChanged:Connect(function(oldState, newState)
        if newState == Enum.HumanoidStateType.Landed then
            task.spawn(function()
                task.wait()
                if humanoid and humanoid.Parent then
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
        end
    end)
    
    jumpDelayConnections[character][#jumpDelayConnections[character] + 1] = stateConnection
    
    local cleanupConnection = character.AncestryChanged:Connect(function()
        if not character.Parent then
            cleanupJumpDelayConnections(character)
        end
    end)
    
    jumpDelayConnections[character][#jumpDelayConnections[character] + 1] = cleanupConnection
end

local function removeJumpDelay()
    if player.Character and player.Character.Parent then
        setupNoJumpDelay(player.Character)
    end
    
    local characterAddedConnection = player.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        if character and character.Parent then
            setupNoJumpDelay(character)
        end
    end)
    
    local characterRemovingConnection = player.CharacterRemoving:Connect(function(character)
        cleanupJumpDelayConnections(character)
    end)
end

local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Reset all velocity variables
    originalGravity = nil
    bodyVelocity = nil
    elevationBodyVelocity = nil

    if platformEnabled then
        task.wait(1)
        
        if currentPlatform then
            currentPlatform:Destroy()
        end
        
        currentPlatform = createPlatform()
        applySlowFall() -- Reapply slow fall to new character
        updatePlatformPosition()
        
        -- ADD THESE LINES HERE:
        task.wait(0.5) -- Wait for character to fully load
        createFloatingEffects()
    end
end

player.CharacterAdded:Connect(onCharacterAdded)

for _, playerObj in pairs(Players:GetPlayers()) do
    if playerObj ~= LocalPlayer then
        createPlayerDisplay(playerObj)
        playerObj.CharacterAdded:Connect(function()
            task.wait(0.5)
            createPlayerDisplay(playerObj)
        end)
    end
end

Players.PlayerAdded:Connect(function(playerObj)
    if playerObj ~= LocalPlayer then
        createPlayerDisplay(playerObj)
        playerObj.CharacterAdded:Connect(function()
            task.wait(0.5)
            createPlayerDisplay(playerObj)
        end)
    end
end)

updateAllPlots()

local plots = workspace:FindFirstChild("Plots")
if plots then
    plots.ChildAdded:Connect(function(child)
        if child:IsA("Model") or child:IsA("Folder") then
            task.wait(0.5)
            createOrUpdatePlotDisplay(child)
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(updateAllPlots)
    end
end)

floatButton.MouseButton1Click:Connect(function()
    local originalSize = floatButton.Size
    local clickTween = TweenService:Create(floatButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 125, 0, 33)})
    local releaseTween = TweenService:Create(floatButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = originalSize})
    
    clickTween:Play()
    clickTween.Completed:Connect(function()
        releaseTween:Play()
    end)
    
    if platformEnabled then
        disablePlatform()
    else
        enablePlatform()
    end
end)

wallButton.MouseButton1Click:Connect(function()
    local originalSize = wallButton.Size
    local clickTween = TweenService:Create(wallButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 125, 0, 33)})
    local releaseTween = TweenService:Create(wallButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = originalSize})
    
    clickTween:Play()
    clickTween.Completed:Connect(function()
        releaseTween:Play()
    end)
    
    if wallTransparencyEnabled then
        disableWallTransparency()
    else
        enableWallTransparency()
    end
end)

closeButton.MouseButton1Click:Connect(function()
    if platformEnabled then
        disablePlatform()
    end
    if wallTransparencyEnabled then
        disableWallTransparency()
    end
    if alertGui then
        removeAlertGui()
    end
    screenGui:Destroy()
end)

local function addHoverEffect(button, hoverColor, originalColor)
    button.MouseEnter:Connect(function()
        if button == floatButton then
            if platformEnabled then
                button.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
            else
                button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            end
        elseif button == wallButton then
            if wallTransparencyEnabled then
                button.BackgroundColor3 = Color3.fromRGB(180, 80, 30)
            else
                button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            end
        else
            button.BackgroundColor3 = hoverColor
        end
    end)
    
    button.MouseLeave:Connect(function()
        if button == floatButton then
            if platformEnabled then
                button.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
            else
                button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            end
        elseif button == wallButton then
            if wallTransparencyEnabled then
                button.BackgroundColor3 = Color3.fromRGB(150, 50, 0)
            else
                button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            end
        else
            button.BackgroundColor3 = originalColor
        end
    end)
end

addHoverEffect(closeButton, Color3.fromRGB(220, 70, 70), Color3.fromRGB(200, 50, 50))
addHoverEffect(floatButton, Color3.fromRGB(30, 30, 30), Color3.fromRGB(0, 0, 0))
addHoverEffect(wallButton, Color3.fromRGB(30, 30, 30), Color3.fromRGB(0, 0, 0))
addHoverEffect(leaveButton, Color3.fromRGB(30, 70, 180), Color3.fromRGB(0, 50, 150))

game:BindToClose(function()
    if wallTransparencyEnabled then
        disableWallTransparency()
    end
    if alertGui then
        removeAlertGui()
    end
end)

Players.PlayerRemoving:Connect(function(playerObj)
    if playerObj == LocalPlayer then
        removeAlertGui()
    end
end)

task.spawn(initializeAnimalESP)
removeJumpDelay()

-- Block Player:Kick()
local originalKick = player.Kick
player.Kick = function(self, ...)
    if antiKickEnabled and not allowedToLeave then
        print("🛡️ BLOCKED: Player:Kick() attempt")
        warn("Anti-Kick: Blocked Player:Kick() attempt")
        return
    elseif allowedToLeave then
        print("🔷 ALLOWED: Player:Kick() - Auto leave after steal")
    end
    return originalKick(self, ...)
end

-- Block game:Shutdown()
local originalShutdown = game.Shutdown
game.Shutdown = function(...)
    if antiKickEnabled and not allowedToLeave then
        print("🛡️ BLOCKED: game:Shutdown() attempt")
        warn("Anti-Kick: Blocked game:Shutdown() attempt")
        return
    elseif allowedToLeave then
        print("🔷 ALLOWED: game:Shutdown() - Auto leave after steal")
    end
    return originalShutdown(...)
end

-- Block all TeleportService methods (including rejoin/server hop)
local originalTeleport = TeleportService.Teleport
local originalTeleportToPlaceInstance = TeleportService.TeleportToPlaceInstance
local originalTeleportAsync = TeleportService.TeleportAsync
local originalTeleportToPrivateServer = TeleportService.TeleportToPrivateServer
local originalTeleportPartyAsync = TeleportService.TeleportPartyAsync

-- Block standard teleport
TeleportService.Teleport = function(self, placeId, playerToTeleport, ...)
    if antiKickEnabled and not allowedToLeave and (playerToTeleport == player or playerToTeleport == nil) then
        print("🛡️ BLOCKED: TeleportService:Teleport() attempt")
        warn("Anti-Kick: Blocked TeleportService:Teleport() attempt - PlaceId: " .. tostring(placeId))
        return
    elseif allowedToLeave and (playerToTeleport == player or playerToTeleport == nil) then
        print("🔷 ALLOWED: TeleportService:Teleport() - Auto leave after steal")
    end
    return originalTeleport(self, placeId, playerToTeleport, ...)
end

-- Block teleport to place instance
TeleportService.TeleportToPlaceInstance = function(self, placeId, instanceId, playerToTeleport, ...)
    if antiKickEnabled and (playerToTeleport == player or playerToTeleport == nil) then
        print("🛡️ BLOCKED: TeleportService:TeleportToPlaceInstance() attempt")
        warn("Anti-Kick: Blocked TeleportService:TeleportToPlaceInstance() attempt - PlaceId: " .. tostring(placeId))
        return
    end
    return originalTeleportToPlaceInstance(self, placeId, instanceId, playerToTeleport, ...)
end

-- Block async teleport (commonly used for server hopping)
TeleportService.TeleportAsync = function(self, placeId, players, teleportOptions, ...)
    if antiKickEnabled then
        -- Check if local player is in the players table
        if type(players) == "table" then
            for _, p in pairs(players) do
                if p == player then
                    print("🛡️ BLOCKED: TeleportService:TeleportAsync() attempt (Server Hop/Rejoin)")
                    warn("Anti-Kick: Blocked TeleportService:TeleportAsync() attempt - PlaceId: " .. tostring(placeId))
                    return
                end
            end
        elseif players == player then
            print("🛡️ BLOCKED: TeleportService:TeleportAsync() attempt (Server Hop/Rejoin)")
            warn("Anti-Kick: Blocked TeleportService:TeleportAsync() attempt - PlaceId: " .. tostring(placeId))
            return
        end
    end
    return originalTeleportAsync(self, placeId, players, teleportOptions, ...)
end

-- Block teleport to private server
TeleportService.TeleportToPrivateServer = function(self, placeId, privateServerId, players, ...)
    if antiKickEnabled then
        -- Check if local player is in the players table
        if type(players) == "table" then
            for _, p in pairs(players) do
                if p == player then
                    print("🛡️ BLOCKED: TeleportService:TeleportToPrivateServer() attempt")
                    warn("Anti-Kick: Blocked TeleportService:TeleportToPrivateServer() attempt - PlaceId: " .. tostring(placeId))
                    return
                end
            end
        elseif players == player then
            print("🛡️ BLOCKED: TeleportService:TeleportToPrivateServer() attempt")
            warn("Anti-Kick: Blocked TeleportService:TeleportToPrivateServer() attempt - PlaceId: " .. tostring(placeId))
            return
        end
    end
    return originalTeleportToPrivateServer(self, placeId, privateServerId, players, ...)
end

-- Block party teleport (if it exists)
if TeleportService.TeleportPartyAsync then
    originalTeleportPartyAsync = TeleportService.TeleportPartyAsync
    TeleportService.TeleportPartyAsync = function(self, placeId, players, teleportOptions, ...)
        if antiKickEnabled then
            -- Check if local player is in the players table
            if type(players) == "table" then
                for _, p in pairs(players) do
                    if p == player then
                        print("🛡️ BLOCKED: TeleportService:TeleportPartyAsync() attempt")
                        warn("Anti-Kick: Blocked TeleportService:TeleportPartyAsync() attempt - PlaceId: " .. tostring(placeId))
                        return
                    end
                end
            end
        end
        return originalTeleportPartyAsync(self, placeId, players, teleportOptions, ...)
    end
end

-- Block RemoteEvent/RemoteFunction kick attempts with enhanced detection
local function hookRemoteKicks()
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("RemoteEvent") then
            local originalFire = obj.FireServer
            obj.FireServer = function(self, ...)
                local args = {...}
                -- Check for common kick/teleport patterns
                for _, arg in pairs(args) do
                    if type(arg) == "string" then
                        local lower = string.lower(arg)
                        if string.find(lower, "kick") or string.find(lower, "ban") or 
                           string.find(lower, "remove") or string.find(lower, "disconnect") or
                           string.find(lower, "teleport") or string.find(lower, "rejoin") or
                           string.find(lower, "serverhop") or string.find(lower, "server hop") or
                           string.find(lower, "hop") or string.find(lower, "leave") then
                            if antiKickEnabled then
                                print("🛡️ BLOCKED: RemoteEvent potential kick/teleport - " .. tostring(arg))
                                warn("Anti-Kick: Blocked potential RemoteEvent kick/teleport: " .. tostring(arg))
                                return
                            end
                        end
                    elseif type(arg) == "number" and arg > 1000000 then
                        -- Potential place ID for teleportation
                        if antiKickEnabled then
                            print("🛡️ BLOCKED: RemoteEvent potential teleport with PlaceId - " .. tostring(arg))
                            warn("Anti-Kick: Blocked potential RemoteEvent teleport with PlaceId: " .. tostring(arg))
                            return
                        end
                    end
                end
                return originalFire(self, ...)
            end
        elseif obj:IsA("RemoteFunction") then
            local originalInvoke = obj.InvokeServer
            obj.InvokeServer = function(self, ...)
                local args = {...}
                -- Check for common kick/teleport patterns
                for _, arg in pairs(args) do
                    if type(arg) == "string" then
                        local lower = string.lower(arg)
                        if string.find(lower, "kick") or string.find(lower, "ban") or 
                           string.find(lower, "remove") or string.find(lower, "disconnect") or
                           string.find(lower, "teleport") or string.find(lower, "rejoin") or
                           string.find(lower, "serverhop") or string.find(lower, "server hop") or
                           string.find(lower, "hop") or string.find(lower, "leave") then
                            if antiKickEnabled then
                                print("🛡️ BLOCKED: RemoteFunction potential kick/teleport - " .. tostring(arg))
                                warn("Anti-Kick: Blocked potential RemoteFunction kick/teleport: " .. tostring(arg))
                                return
                            end
                        end
                    elseif type(arg) == "number" and arg > 1000000 then
                        -- Potential place ID for teleportation
                        if antiKickEnabled then
                            print("🛡️ BLOCKED: RemoteFunction potential teleport with PlaceId - " .. tostring(arg))
                            warn("Anti-Kick: Blocked potential RemoteFunction teleport with PlaceId: " .. tostring(arg))
                            return
                        end
                    end
                end
                return originalInvoke(self, ...)
            end
        end
    end
end

-- Hook existing remotes
hookRemoteKicks()

-- Hook new remotes that get added
game.DescendantAdded:Connect(function(obj)
    task.wait(0.1)
    if obj:IsA("RemoteEvent") then
        local originalFire = obj.FireServer
        obj.FireServer = function(self, ...)
            local args = {...}
            for _, arg in pairs(args) do
                if type(arg) == "string" then
                    local lower = string.lower(arg)
                    if string.find(lower, "kick") or string.find(lower, "ban") or 
                       string.find(lower, "remove") or string.find(lower, "disconnect") or
                       string.find(lower, "teleport") or string.find(lower, "rejoin") or
                       string.find(lower, "serverhop") or string.find(lower, "server hop") or
                       string.find(lower, "hop") or string.find(lower, "leave") then
                        if antiKickEnabled then
                            print("🛡️ BLOCKED: New RemoteEvent potential kick/teleport - " .. tostring(arg))
                            warn("Anti-Kick: Blocked potential new RemoteEvent kick/teleport: " .. tostring(arg))
                            return
                        end
                    end
                elseif type(arg) == "number" and arg > 1000000 then
                    if antiKickEnabled then
                        print("🛡️ BLOCKED: New RemoteEvent potential teleport with PlaceId - " .. tostring(arg))
                        warn("Anti-Kick: Blocked potential new RemoteEvent teleport with PlaceId: " .. tostring(arg))
                        return
                    end
                end
            end
            return originalFire(self, ...)
        end
    elseif obj:IsA("RemoteFunction") then
        local originalInvoke = obj.InvokeServer
        obj.InvokeServer = function(self, ...)
            local args = {...}
            for _, arg in pairs(args) do
                if type(arg) == "string" then
                    local lower = string.lower(arg)
                    if string.find(lower, "kick") or string.find(lower, "ban") or 
                       string.find(lower, "remove") or string.find(lower, "disconnect") or
                       string.find(lower, "teleport") or string.find(lower, "rejoin") or
                       string.find(lower, "serverhop") or string.find(lower, "server hop") or
                       string.find(lower, "hop") or string.find(lower, "leave") then
                        if antiKickEnabled then
                            print("🛡️ BLOCKED: New RemoteFunction potential kick/teleport - " .. tostring(arg))
                            warn("Anti-Kick: Blocked potential new RemoteFunction kick/teleport: " .. tostring(arg))
                            return
                        end
                    end
                elseif type(arg) == "number" and arg > 1000000 then
                    if antiKickEnabled then
                        print("🛡️ BLOCKED: New RemoteFunction potential teleport with PlaceId - " .. tostring(arg))
                        warn("Anti-Kick: Blocked potential new RemoteFunction teleport with PlaceId: " .. tostring(arg))
                        return
                    end
                end
            end
            return originalInvoke(self, ...)
        end
    end
end)

-- Block character destruction kicks
local function protectCharacter(character)
    if character then
        local originalDestroy = character.Destroy
        character.Destroy = function(...)
            if antiKickEnabled then
                print("🛡️ BLOCKED: Character:Destroy() attempt")
                warn("Anti-Kick: Blocked Character:Destroy() attempt")
                return
            end
            return originalDestroy(...)
        end
        
        -- Monitor character removal
        character.AncestryChanged:Connect(function()
            if not character.Parent and antiKickEnabled then
                print("🛡️ DETECTED: Character removal attempt - attempting to restore")
                warn("Anti-Kick: Detected character removal attempt - attempting to restore")
                task.wait(0.1)
                if not player.Character or not player.Character.Parent then
                    print("🛡️ RESTORING: Character was removed, attempting to respawn")
                    pcall(function()
                        player:LoadCharacter()
                    end)
                end
            end
        end)
    end
end

-- Protect current character
if player.Character then
    protectCharacter(player.Character)
end

-- Protect new characters
player.CharacterAdded:Connect(function(character)
    protectCharacter(character)
end)

-- Block Players:GetPlayerByUserId removal
local originalRemove = Players.Remove
if originalRemove then
    Players.Remove = function(self, playerToRemove)
        if antiKickEnabled and playerToRemove == player then
            print("🛡️ BLOCKED: Players:Remove() attempt on local player")
            warn("Anti-Kick: Blocked Players:Remove() attempt on local player")
            return
        end
        return originalRemove(self, playerToRemove)
    end
end

-- Block GuiService ShowLeaveConfirmation (forces player to leave)
local GuiService = game:GetService("GuiService")
if GuiService and GuiService.ShowLeaveConfirmation then
    local originalShowLeave = GuiService.ShowLeaveConfirmation
    GuiService.ShowLeaveConfirmation = function(...)
        if antiKickEnabled then
            print("🛡️ BLOCKED: GuiService:ShowLeaveConfirmation() attempt")
            warn("Anti-Kick: Blocked GuiService:ShowLeaveConfirmation() attempt")
            return
        end
        return originalShowLeave(...)
    end
end

-- Block potential HTTP-based server hop requests
local originalHttpGet = HttpService.GetAsync
local originalHttpPost = HttpService.PostAsync

HttpService.GetAsync = function(self, url, ...)
    if antiKickEnabled then
        local lowerUrl = string.lower(url)
        if string.find(lowerUrl, "teleport") or string.find(lowerUrl, "rejoin") or 
           string.find(lowerUrl, "serverhop") or string.find(lowerUrl, "server") or
           string.find(lowerUrl, "place") then
            print("🛡️ BLOCKED: Suspicious HTTP GET request - " .. tostring(url))
            warn("Anti-Kick: Blocked suspicious HTTP GET request: " .. tostring(url))
            return "{}"
        end
    end
    return originalHttpGet(self, url, ...)
end

HttpService.PostAsync = function(self, url, data, ...)
    if antiKickEnabled then
        local lowerUrl = string.lower(url)
        local lowerData = string.lower(tostring(data))
        if string.find(lowerUrl, "teleport") or string.find(lowerUrl, "rejoin") or 
           string.find(lowerUrl, "serverhop") or string.find(lowerData, "teleport") or
           string.find(lowerData, "rejoin") or string.find(lowerData, "serverhop") then
            print("🛡️ BLOCKED: Suspicious HTTP POST request - " .. tostring(url))
            warn("Anti-Kick: Blocked suspicious HTTP POST request: " .. tostring(url))
            return "{}"
        end
    end
    return originalHttpPost(self, url, data, ...)
end

-- Monitor for suspicious script behavior
local function monitorScriptBehavior()
    -- Monitor for scripts that might try to force teleportation
    for _, obj in pairs(game:GetDescendants()) do
        if obj:IsA("LocalScript") or obj:IsA("Script") then
            -- Monitor script source changes that might indicate kick attempts
            pcall(function()
                if obj.Source and string.find(string.lower(obj.Source), "teleportservice") then
                    print("🛡️ MONITORING: Script with TeleportService detected - " .. obj:GetFullName())
                end
            end)
        end
    end
end

-- Run initial monitoring
pcall(monitorScriptBehavior)

-- Monitor new scripts
game.DescendantAdded:Connect(function(obj)
    if obj:IsA("LocalScript") or obj:IsA("Script") then
        task.wait(0.1)
        pcall(function()
            if obj.Source and string.find(string.lower(obj.Source), "teleportservice") then
                print("🛡️ MONITORING: New script with TeleportService detected - " .. obj:GetFullName())
            end
        end)
    end
end)

-- Hook into RunService to prevent script termination and maintain protection
local heartbeatConnection = RunService.Heartbeat:Connect(function()
    if not antiKickEnabled then
        heartbeatConnection:Disconnect()
    end
    
    -- Ensure player is still connected and character exists
    if player and player.Parent and antiKickEnabled then
        if not player.Character and player.Parent == Players then
            print("🛡️ RESTORING: No character detected, attempting to respawn")
            pcall(function()
                player:LoadCharacter()
            end)
        end
    end
end)

-- Final protection - prevent script from being destroyed
local scriptParent = script.Parent
if scriptParent then
    scriptParent.ChildRemoved:Connect(function(child)
        if child == script and antiKickEnabled then
            print("🛡️ WARNING: Anti-kick script removal detected - protection may no longer function")
            warn("Anti-Kick: Script removal detected - Anti-kick may no longer function")
        end
    end)
end

-- Block workspace changes that might indicate forced teleportation
workspace.ChildRemoved:Connect(function(child)
    if child == player.Character and antiKickEnabled then
        print("🛡️ DETECTED: Character removed from workspace")
        warn("Anti-Kick: Character removed from workspace - potential kick attempt")
    end
end)

-- Additional protection against direct player removal from Players service
Players.PlayerRemoving:Connect(function(playerLeaving)
    if playerLeaving == player and antiKickEnabled then
        print("🛡️ BLOCKED: Attempt to remove local player from Players service")
        warn("Anti-Kick: Blocked attempt to remove local player from Players service")
        -- Try to prevent the removal (may not always work due to engine limitations)
        return
    end
end)

-- Function to safely leave the game (bypasses anti-kick)
local function safeLeaveGame()
    allowedToLeave = true -- Allow anti-kick to permit leaving
    print("🔷 LEAVING GAME: Auto leave after steal triggered")
    
    -- Clean up effects before leaving
    if platformEnabled then
        removeFloatingEffects()
        disablePlatform()
    end
    if wallTransparencyEnabled then
        disableWallTransparency()
    end
    if alertGui then
        removeAlertGui()
    end
    
    -- Wait a moment for cleanup
    task.wait(0.5)
    
    -- Force leave using TeleportService (will now be allowed)
    pcall(function()
        TeleportService:Teleport(game.PlaceId, player)
    end)
    
    -- Backup leave method
    task.wait(1)
    pcall(function()
        player:Kick("Auto Leave After Steal")
    end)
    
    -- Final backup
    task.wait(1)
    pcall(function()
        game:Shutdown()
    end)
end

-- Get initial steal count
local function getStealCount()
    if player and player:FindFirstChild("leaderstats") and player.leaderstats:FindFirstChild("Steals") then
        return player.leaderstats.Steals.Value
    end
    return 0
end

-- Initialize steal count
task.spawn(function()
    task.wait(1) -- Wait for leaderstats to load
    lastStealCount = getStealCount()
    print("🔷 AUTO LEAVE: Initial steal count: " .. lastStealCount)
end)

-- Auto Leave After Steal Monitor
task.spawn(function()
    while autoLeaveEnabled do
        task.wait(0.5) -- Check every 1 second
        
        pcall(function()
            local currentSteals = getStealCount()
            
            if currentSteals > lastStealCount then
                print("🔷 STEAL DETECTED: Steals increased from " .. lastStealCount .. " to " .. currentSteals)
                print("🔷 AUTO LEAVE: Leaving game in 1 second...")
                
                task.wait(1) -- Wait 1 second before leaving
                safeLeaveGame()
                break
            end
            
            lastStealCount = currentSteals
        end)
    end
end)

-- Leave Button Click Handler
leaveButton.MouseButton1Click:Connect(function()
    local originalSize = leaveButton.Size
    local clickTween = TweenService:Create(leaveButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 23, 0, 23)})
    local releaseTween = TweenService:Create(leaveButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = originalSize})
    
    clickTween:Play()
    clickTween.Completed:Connect(function()
        releaseTween:Play()
    end)
    
    print("🔷 LEAVE BUTTON: Manual leave triggered")
    safeLeaveGame()
end)

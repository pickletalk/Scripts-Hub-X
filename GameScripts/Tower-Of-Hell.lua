-- Create main GUI container
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FloatUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

-- Create draggable frame with background
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 100)
mainFrame.Position = UDim2.new(0.5, -125, 0.5, -50)
mainFrame.BackgroundColor3 = Color3.fromRGB(68, 68, 68)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

-- Add rounded corners (25px)
local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 25)
frameCorner.Parent = mainFrame

-- Create title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(0, 250, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 5)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Tower of Hell"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.Parent = mainFrame

-- Create subtitle label
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Name = "Subtitle"
subtitleLabel.Size = UDim2.new(0, 250, 0, 20)
subtitleLabel.Position = UDim2.new(0, 0, 0, 35)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Script Hub X"
subtitleLabel.TextColor3 = Color3.fromRGB(136, 136, 136)
subtitleLabel.Font = Enum.Font.SourceSans
subtitleLabel.TextSize = 14
subtitleLabel.Parent = mainFrame

-- Create toggle button
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "Toggle"
toggleButton.Size = UDim2.new(0, 120, 0, 30)
toggleButton.Position = UDim2.new(0, 15, 0, 60)
toggleButton.BackgroundColor3 = Color3.fromRGB(190, 190, 190)
toggleButton.BorderSizePixel = 0
toggleButton.Text = "Infinite Jump: OFF"
toggleButton.TextColor3 = Color3.new(0, 0, 0)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 14
toggleButton.Parent = mainFrame

-- Add rounded corners to toggle button
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 15)
toggleCorner.Parent = toggleButton

-- Create Discord button
local discordButton = Instance.new("ImageButton")
discordButton.Name = "Discord"
discordButton.Size = UDim2.new(0, 30, 0, 30)
discordButton.Position = UDim2.new(0, 145, 0, 60)
discordButton.BackgroundTransparency = 1
discordButton.Image = "rbxassetid://113520323335055"
discordButton.Parent = mainFrame

-- Create close button (X)
local closeButton = Instance.new("TextButton")
closeButton.Name = "Close"
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(0, 215, 0, 5)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(136, 136, 136)
closeButton.Font = Enum.Font.SourceSansBold
closeButton.TextSize = 18
closeButton.Parent = mainFrame

-- Create notification label (initially hidden)
local notificationLabel = Instance.new("TextLabel")
notificationLabel.Name = "Notification"
notificationLabel.Size = UDim2.new(0, 200, 0, 30)
notificationLabel.Position = UDim2.new(0.5, -100, 0.5, 50)
notificationLabel.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
notificationLabel.BorderSizePixel = 0
notificationLabel.Text = "Discord link copied to clipboard!"
notificationLabel.TextColor3 = Color3.new(1, 1, 1)
notificationLabel.Font = Enum.Font.SourceSans
notificationLabel.TextSize = 14
notificationLabel.Visible = false
notificationLabel.Parent = screenGui

-- Add rounded corners to notification
local notificationCorner = Instance.new("UICorner")
notificationCorner.CornerRadius = UDim.new(0, 8)
notificationCorner.Parent = notificationLabel

-- Infinite Jump functionality variables
local floatEnabled = false
local platform = nil
local orbitingParticles = {}
local textLabel = nil
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")

-- Function to create invisible platform (3 studs under player)
local function createPlatform()
    if platform then return end
    
    platform = Instance.new("Part")
    platform.Name = "FloatPlatform"
    platform.Size = Vector3.new(8, 0.5, 8)
    platform.Transparency = 1
    platform.Anchored = true
    platform.CanCollide = true
    platform.Parent = workspace
    
    -- Position platform 3 studs under player
    platform.Position = humanoidRootPart.Position - Vector3.new(0, 2.9, 0)
end

-- Function to remove platform
local function removePlatform()
    if platform then
        platform:Destroy()
        platform = nil
    end
end

-- Function to apply godmode (infinite health using math.huge)
local function applyGodmode()
    if humanoid then
        -- Set health to infinity - player becomes invulnerable
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
    end
end

-- Function to remove godmode (restore normal health)
local function removeGodmode()
    if humanoid then
        -- Reset to normal health values
        humanoid.MaxHealth = 100
        humanoid.Health = 100
    end
end

-- Function to create orbiting particles around player (like in the image)
local function createOrbitingParticles()
    -- Clear existing particles
    for _, particle in ipairs(orbitingParticles) do
        particle:Destroy()
    end
    orbitingParticles = {}
    
    -- Create 12 orbiting particles around the player
    local numParticles = 12
    local radius = 3
    
    for i = 1, numParticles do
        -- Create neon particle
        local particle = Instance.new("Part")
        particle.Name = "OrbitParticle"
        particle.Size = Vector3.new(0.4, 0.4, 0.4)
        particle.Shape = Enum.PartType.Ball
        particle.Material = Enum.Material.Neon
        particle.Color = Color3.fromRGB(0, 170, 255)  -- Neon blue
        particle.Transparency = 0.2
        particle.Anchored = true
        particle.CanCollide = false
        particle.Parent = workspace
        
        -- Add blue sparkle particle emitter
        local particleEmitter = Instance.new("ParticleEmitter")
        particleEmitter.Texture = "rbxasset://textures/particles/sparkles_main.dds"
        particleEmitter.Color = ColorSequence.new(Color3.fromRGB(0, 170, 255), Color3.fromRGB(100, 200, 255))
        particleEmitter.Size = NumberSequence.new(0.3, 0)
        particleEmitter.Transparency = NumberSequence.new(0, 1)
        particleEmitter.Lifetime = NumberRange.new(0.5, 1)
        particleEmitter.Rate = 30
        particleEmitter.Speed = NumberRange.new(1, 3)
        particleEmitter.SpreadAngle = Vector2.new(360, 360)
        particleEmitter.Rotation = NumberRange.new(0, 360)
        particleEmitter.RotSpeed = NumberRange.new(-200, 200)
        particleEmitter.LightEmission = 1
        particleEmitter.Parent = particle
        
        -- Add point light for glow effect
        local pointLight = Instance.new("PointLight")
        pointLight.Color = Color3.fromRGB(0, 170, 255)
        pointLight.Brightness = 2
        pointLight.Range = 8
        pointLight.Parent = particle
        
        -- Store initial angle for this particle
        particle:SetAttribute("InitialAngle", (i - 1) * (360 / numParticles))
        
        table.insert(orbitingParticles, particle)
    end
end

-- Function to remove orbiting particles
local function removeOrbitingParticles()
    for _, particle in ipairs(orbitingParticles) do
        particle:Destroy()
    end
    orbitingParticles = {}
end

-- Function to create "INFINITE JUMP" text label above player
local function createTextLabel()
    if textLabel then return end
    
    -- Create attachment point on character
    local attachment = Instance.new("Attachment")
    attachment.Name = "TextAttachment"
    attachment.Parent = humanoidRootPart
    attachment.Position = Vector3.new(0, 4, 0)
    
    -- Create billboard GUI
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "InfiniteJumpLabel"
    billboardGui.Adornee = attachment
    billboardGui.Size = UDim2.new(0, 250, 0, 60)
    billboardGui.StudsOffset = Vector3.new(0, 0, 0)
    billboardGui.AlwaysOnTop = true
    billboardGui.Parent = humanoidRootPart
    
    -- Create text label with "INFINITE JUMP" text
    local textFrame = Instance.new("TextLabel")
    textFrame.Size = UDim2.new(1, 0, 1, 0)
    textFrame.BackgroundTransparency = 1
    textFrame.Text = "INFINITE JUMP"
    textFrame.TextColor3 = Color3.fromRGB(0, 170, 255)  -- Neon blue
    textFrame.Font = Enum.Font.GothamBold
    textFrame.TextSize = 24
    textFrame.TextStrokeTransparency = 0
    textFrame.TextStrokeColor3 = Color3.new(0, 0, 0)  -- Black outline
    textFrame.Parent = billboardGui
    
    -- Add neon glow effect using UIStroke
    local uiStroke = Instance.new("UIStroke")
    uiStroke.Color = Color3.fromRGB(0, 170, 255)
    uiStroke.Thickness = 3
    uiStroke.Transparency = 0.2
    uiStroke.Parent = textFrame
    
    textLabel = billboardGui
end

-- Function to remove text label
local function removeTextLabel()
    if textLabel then
        textLabel:Destroy()
        textLabel = nil
    end
    
    -- Remove attachment if exists
    local attachment = humanoidRootPart:FindFirstChild("TextAttachment")
    if attachment then
        attachment:Destroy()
    end
end

-- Function to toggle infinite jump feature (with godmode)
local function toggleFloat()
    floatEnabled = not floatEnabled
    toggleButton.Text = floatEnabled and "Infinite Jump: ON" or "Infinite Jump: OFF"
    
    -- Change button color when active
    if floatEnabled then
        toggleButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)  -- Green when ON
        createPlatform()
        createOrbitingParticles()
        createTextLabel()
        applyGodmode()  -- Enable godmode (infinite health)
    else
        toggleButton.BackgroundColor3 = Color3.fromRGB(190, 190, 190)  -- Gray when OFF
        removePlatform()
        removeOrbitingParticles()
        removeTextLabel()
    end
end

-- Function to copy Discord link to clipboard
local function copyDiscordLink()
    local discordLink = "https://discord.gg/bpsNUH5sVb"
    
    -- Set clipboard content
    if syn then
        syn.write_clipboard(discordLink)
    elseif setclipboard then
        setclipboard(discordLink)
    else
        -- Fallback for executors without clipboard functions
        local gui = game.Players.LocalPlayer:WaitForChild("PlayerGui")
        local clipboardFrame = Instance.new("Frame")
        clipboardFrame.Size = UDim2.new(0, 300, 0, 200)
        clipboardFrame.Position = UDim2.new(0.5, -150, 0.5, -100)
        clipboardFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        clipboardFrame.BorderSizePixel = 0
        clipboardFrame.Parent = gui
        
        local clipboardCorner = Instance.new("UICorner")
        clipboardCorner.CornerRadius = UDim.new(0, 10)
        clipboardCorner.Parent = clipboardFrame
        
        local clipboardText = Instance.new("TextBox")
        clipboardText.Size = UDim2.new(0, 280, 0, 50)
        clipboardText.Position = UDim2.new(0, 10, 0, 75)
        clipboardText.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        clipboardText.Text = discordLink
        clipboardText.TextScaled = true
        clipboardText.Parent = clipboardFrame
        
        local textCorner = Instance.new("UICorner")
        textCorner.CornerRadius = UDim.new(0, 5)
        textCorner.Parent = clipboardText
        
        local instructions = Instance.new("TextLabel")
        instructions.Size = UDim2.new(0, 280, 0, 50)
        instructions.Position = UDim2.new(0, 10, 0, 20)
        instructions.BackgroundTransparency = 1
        instructions.Text = "Copy this Discord link manually:"
        instructions.TextColor3 = Color3.new(1, 1, 1)
        instructions.TextScaled = true
        instructions.Parent = clipboardFrame
        
        local closeBtn = Instance.new("TextButton")
        closeBtn.Size = UDim2.new(0, 80, 0, 30)
        closeBtn.Position = UDim2.new(0, 110, 0, 140)
        closeBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        closeBtn.Text = "Close"
        closeBtn.TextColor3 = Color3.new(1, 1, 1)
        closeBtn.Parent = clipboardFrame
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 5)
        buttonCorner.Parent = closeBtn
        
        closeBtn.MouseButton1Click:Connect(function()
            clipboardFrame:Destroy()
        end)
        
        return
    end
    
    -- Show notification
    notificationLabel.Visible = true
    
    -- Hide notification after 3 seconds
    task.wait(3)
    notificationLabel.Visible = false
end

-- Button connections
toggleButton.MouseButton1Click:Connect(toggleFloat)
discordButton.MouseButton1Click:Connect(copyDiscordLink)

closeButton.MouseButton1Click:Connect(function()
    removePlatform()
    removeOrbitingParticles()
    removeTextLabel()
    removeGodmode()  -- Remove godmode when closing GUI
    screenGui:Destroy()
end)

-- Handle character respawn
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Reset infinite jump state on respawn
    if floatEnabled then
        removePlatform()
        removeOrbitingParticles()
        removeTextLabel()
        task.wait(0.1)
        createPlatform()
        createOrbitingParticles()
        createTextLabel()
        applyGodmode()  -- Reapply godmode after respawn if still enabled
    end
end)

-- Main loop: Update platform position and animate orbiting particles
local angleOffset = 0
game:GetService("RunService").Heartbeat:Connect(function(deltaTime)
    if floatEnabled and humanoidRootPart then
        -- Update platform position to follow player (3 studs under)
        if platform then
            platform.Position = humanoidRootPart.Position - Vector3.new(0, 3, 0)
        end
        
        -- Animate orbiting particles around player
        angleOffset = angleOffset + (deltaTime * 120)  -- Rotation speed
        if angleOffset >= 360 then
            angleOffset = angleOffset - 360
        end
        
        local radius = 3
        for i, particle in ipairs(orbitingParticles) do
            if particle and particle.Parent then
                local initialAngle = particle:GetAttribute("InitialAngle") or 0
                local currentAngle = initialAngle + angleOffset
                
                -- Calculate position in circle around player
                local radians = math.rad(currentAngle)
                local x = math.cos(radians) * radius
                local z = math.sin(radians) * radius
                
                -- Position particle around player at their height
                particle.Position = humanoidRootPart.Position + Vector3.new(x, 0, z)
            end
        end
        
        -- Ensure godmode stays active (reapply if health changes)
        if humanoid.Health ~= math.huge then
            applyGodmode()
        end
    end
end)

-- Make UI draggable
local dragging
local dragInput
local dragStart
local startPos

mainFrame.InputBegan:Connect(function(input)
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

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

applyGodmode()

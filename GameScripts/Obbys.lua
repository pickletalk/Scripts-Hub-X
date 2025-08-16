local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Obby Script - by PickleTalk",
   Icon = 0,
   LoadingTitle = "Pickle Interface Suite",
   LoadingSubtitle = "by PickleTalk",
   ShowText = "by PickleTalk",
   Theme = "Amethyst",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = true,
   DisableBuildWarnings = true,
   ConfigurationSaving = {
      Enabled = false,
      FolderName = "PickleField",
      FileName = "Config"
   },
   Discord = {
      Enabled = true,
      Invite = "bpsNUH5sVb",
      RememberJoins = true
   },
   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"}
   }
})

local Main = Window:CreateTab("Main", "layers")
local PlayerTab = Window:CreateTab("Player", "person-standing")

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- Variables
local Flying = false
local FlySpeed = 50
local BodyVelocity = nil
local BodyAngularVelocity = nil
local FlyConnection = nil

local JumpPowerEnabled = false
local CustomJumpPower = 50
local OriginalJumpPower = 50

local NoclipEnabled = false
local NoclipConnection = nil

local SpeedEnabled = false
local CustomSpeed = 50
local OriginalSpeed = 16

local InfiniteJumpEnabled = false
local InfiniteJumpConnection = nil

local GodModeEnabled = false
local OriginalMaxHealth = 100
local HealthConnection = nil

-- Helper Functions
local function getRootPart()
    local character = LocalPlayer.Character
    if character then
        return character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

local function getHumanoid()
    local character = LocalPlayer.Character
    if character then
        return character:FindFirstChild("Humanoid")
    end
    return nil
end

local function createNotification(text)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    screenGui.Name = "Notification"

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 0)
    frame.Position = UDim2.new(0.5, -100, 0.9, -40)
    frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text or "Notification"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 16
    textLabel.Parent = frame

    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 200, 0, 40)})
    tweenIn:Play()

    game:GetService("Debris"):AddItem(screenGui, 2)
end

-- Infinite Jump Functions
local function performInfiniteJump()
    local humanoid = getHumanoid()
    local rootPart = getRootPart()
    
    if humanoid and rootPart then
        -- Use custom jump power if enabled, otherwise use original
        local jumpPower = JumpPowerEnabled and CustomJumpPower or OriginalJumpPower
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Velocity = Vector3.new(0, jumpPower, 0)
        bodyVelocity.Parent = rootPart
        
        game:GetService("Debris"):AddItem(bodyVelocity, 0.2)
        humanoid.Jump = true
    end
end

local function enableInfiniteJump()
    if InfiniteJumpConnection then
        InfiniteJumpConnection:Disconnect()
    end
    
    InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
        if InfiniteJumpEnabled then
            performInfiniteJump()
        end
    end)
    
    print("Infinite Jump enabled")
end

local function disableInfiniteJump()
    if InfiniteJumpConnection then
        InfiniteJumpConnection:Disconnect()
        InfiniteJumpConnection = nil
    end
    print("Infinite Jump disabled")
end

-- Speed Functions
local function applySpeed(speed)
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.WalkSpeed = speed
    end
end

local function enableSpeed()
    applySpeed(CustomSpeed)
    print("Custom Speed enabled: " .. CustomSpeed)
end

local function disableSpeed()
    applySpeed(OriginalSpeed)
    print("Speed restored to original: " .. OriginalSpeed)
end

-- Jump Power Functions
local function applyJumpPower(jumpPower)
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.JumpPower = jumpPower
    end
end

local function enableJumpPower()
    applyJumpPower(CustomJumpPower)
    print("Custom Jump Power enabled: " .. CustomJumpPower)
end

local function disableJumpPower()
    applyJumpPower(OriginalJumpPower)
    print("Jump Power restored to original: " .. OriginalJumpPower)
end

-- Noclip Functions
local function getCharacterParts()
    local character = LocalPlayer.Character
    if not character then return {} end
    
    local parts = {}
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            table.insert(parts, part)
        end
    end
    return parts
end

local function enableNoclip()
    if NoclipConnection then
        NoclipConnection:Disconnect()
    end
    
    NoclipConnection = RunService.Stepped:Connect(function()
        for _, part in pairs(getCharacterParts()) do
            if part and part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
    
    print("Noclip enabled")
end

local function disableNoclip()
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
    
    for _, part in pairs(getCharacterParts()) do
        if part and part:IsA("BasePart") then
            part.CanCollide = true
        end
    end
    
    print("Noclip disabled")
end

-- Fly Functions
local function enableShiftLock()
    local StarterGui = game:GetService("StarterGui")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    
    -- Enable shift lock in settings
    if LocalPlayer.DevEnableMouseLock ~= nil then
        LocalPlayer.DevEnableMouseLock = true
    end
    
    -- Set camera to follow mouse
    local UserGameSettings = UserSettings():GetService("UserGameSettings")
    UserGameSettings.RotationType = Enum.RotationType.CameraRelative
    
    -- Force mouse lock
    local Mouse = LocalPlayer:GetMouse()
    if UserInputService.MouseBehavior ~= Enum.MouseBehavior.LockCenter then
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    end
end

local function disableShiftLock()
    -- Restore normal mouse behavior
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
end

local function startFly()
    local character = LocalPlayer.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Clean up existing objects
    if BodyVelocity then BodyVelocity:Destroy() end
    if BodyAngularVelocity then BodyAngularVelocity:Destroy() end
    if FlyConnection then FlyConnection:Disconnect() end
    
    -- Enable shift lock for better fly experience
    enableShiftLock()
    
    -- Create BodyVelocity for movement
    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    BodyVelocity.Parent = rootPart
    
    -- Create BodyAngularVelocity to prevent spinning
    BodyAngularVelocity = Instance.new("BodyAngularVelocity")
    BodyAngularVelocity.MaxTorque = Vector3.new(4000, 4000, 4000)
    BodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
    BodyAngularVelocity.Parent = rootPart
    
    -- Disable humanoid states that interfere with flying
    humanoid.PlatformStand = true
    
    -- Flying loop
    FlyConnection = RunService.Heartbeat:Connect(function()
        if Flying and BodyVelocity and BodyVelocity.Parent then
            local camera = workspace.CurrentCamera
            local humanoid = getHumanoid()
            if not humanoid then return end
            
            local moveVector = Vector3.new(0, 0, 0)
            local isMoving = false
            
            -- PC Controls (WASD)
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                moveVector = moveVector + camera.CFrame.LookVector
                isMoving = true
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                moveVector = moveVector - camera.CFrame.LookVector
                isMoving = true
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                moveVector = moveVector - camera.CFrame.RightVector
                isMoving = true
            end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                moveVector = moveVector + camera.CFrame.RightVector
                isMoving = true
            end
            
            -- Mobile Controls (TouchEnabled)
            if UserInputService.TouchEnabled then
                local moveVector2D = humanoid.MoveDirection
                if moveVector2D.Magnitude > 0 then
                    -- Convert 2D movement to 3D camera-relative movement
                    local cameraCFrame = camera.CFrame
                    local relativeMovement = cameraCFrame:VectorToWorldSpace(Vector3.new(moveVector2D.X, 0, -moveVector2D.Z))
                    moveVector = Vector3.new(relativeMovement.X, 0, relativeMovement.Z)
                    isMoving = true
                end
            end
            
            -- Apply movement in the direction the camera is looking
            if isMoving and moveVector.Magnitude > 0 then
                -- Fly in the direction of camera look vector, but maintain some ground-relative movement
                local lookDirection = camera.CFrame.LookVector
                local rightDirection = camera.CFrame.RightVector
                
                -- Calculate the movement direction based on input
                local finalDirection = Vector3.new(0, 0, 0)
                
                -- Forward/Backward based on camera look direction
                if moveVector:Dot(camera.CFrame.LookVector) > 0 then
                    finalDirection = finalDirection + lookDirection
                elseif moveVector:Dot(-camera.CFrame.LookVector) > 0 then
                    finalDirection = finalDirection - lookDirection
                end
                
                -- Left/Right based on camera right direction  
                if moveVector:Dot(camera.CFrame.RightVector) > 0 then
                    finalDirection = finalDirection + rightDirection
                elseif moveVector:Dot(-camera.CFrame.RightVector) > 0 then
                    finalDirection = finalDirection - rightDirection
                end
                
                if finalDirection.Magnitude > 0 then
                    BodyVelocity.Velocity = finalDirection.Unit * FlySpeed
                else
                    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
            else
                BodyVelocity.Velocity = Vector3.new(0, 0, 0)
            end
        end
    end)
    
    print("Flying enabled at speed: " .. FlySpeed .. " (Shift lock auto-enabled)")
end

local function stopFly()
    local character = LocalPlayer.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
    
    if BodyVelocity then
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end
    
    if BodyAngularVelocity then
        BodyAngularVelocity:Destroy()
        BodyAngularVelocity = nil
    end
    
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    if HealthConnection then
        HealthConnection:Disconnect()
        HealthConnection = nil
    end
    
    print("Flying disabled")
end

-- God Mode Functions
local function enableGodMode()
    local humanoid = getHumanoid()
    if not humanoid then return end
    
    -- Store original max health
    if not GodModeEnabled then
        OriginalMaxHealth = humanoid.MaxHealth
    end
    
    -- Set health to infinite
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    
    -- Create connection to maintain infinite health
    if HealthConnection then
        HealthConnection:Disconnect()
    end
    
    HealthConnection = humanoid.HealthChanged:Connect(function(health)
        if GodModeEnabled and health < math.huge then
            humanoid.Health = math.huge
        end
    end)
    
    print("God Mode enabled")
end

local function disableGodMode()
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.MaxHealth = OriginalMaxHealth
        humanoid.Health = OriginalMaxHealth
    end
    
    if HealthConnection then
        HealthConnection:Disconnect()
        HealthConnection = nil
    end
    
    print("God Mode disabled")
end

-- Character Event Handlers
local function onCharacterAdded(character)
    wait(0.5)
    
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Store original values
    if not SpeedEnabled then
        OriginalSpeed = humanoid.WalkSpeed
    end
    if not JumpPowerEnabled then
        OriginalJumpPower = humanoid.JumpPower
    end
    if not GodModeEnabled then
        OriginalMaxHealth = humanoid.MaxHealth
    end
    
    -- Reapply enabled features
    if SpeedEnabled then
        applySpeed(CustomSpeed)
    end
    if JumpPowerEnabled then
        applyJumpPower(CustomJumpPower)
    end
    if InfiniteJumpEnabled then
        enableInfiniteJump()
    end
    if NoclipEnabled then
        enableNoclip()
    end
    if Flying then
        startFly()
    end
    if GodModeEnabled then
        enableGodMode()
    end
end

local function onCharacterRemoving()
    if InfiniteJumpConnection then
        InfiniteJumpConnection:Disconnect()
        InfiniteJumpConnection = nil
    end
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
end

-- Connect character events
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
LocalPlayer.CharacterRemoving:Connect(onCharacterRemoving)

-- Initialize if character already exists
if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end

-- UI Elements

-- Infinite Jump Toggle (Main Tab)
local InfJumpToggle = Main:CreateToggle({
   Name = "Infinite Jump",
   CurrentValue = false,
   Flag = "InfiniteJumpToggle",
   Callback = function(Value)
       InfiniteJumpEnabled = Value
       
       if InfiniteJumpEnabled then
           enableInfiniteJump()
           createNotification("Infinite Jump Enabled")
       else
           disableInfiniteJump()
           createNotification("Infinite Jump Disabled")
       end
   end,
})

-- Noclip Toggle (Main Tab)
local NoclipToggle = Main:CreateToggle({
    Name = "Noclip Toggle",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        NoclipEnabled = Value
        
        if NoclipEnabled then
            enableNoclip()
        else
            disableNoclip()
        end
    end,
})

-- God Mode Toggle (Main Tab)
local GodModeToggle = Main:CreateToggle({
    Name = "God Mode",
    CurrentValue = false,
    Flag = "GodModeToggle",
    Callback = function(Value)
        GodModeEnabled = Value
        
        if GodModeEnabled then
            enableGodMode()
        else
            disableGodMode()
        end
    end,
})

-- Player Tab Elements

-- Speed Toggle
local SpeedToggle = PlayerTab:CreateToggle({
    Name = "Player Speed",
    CurrentValue = false,
    Flag = "SpeedToggle",
    Callback = function(Value)
        SpeedEnabled = Value
        
        if SpeedEnabled then
            enableSpeed()
        else
            disableSpeed()
        end
    end,
})

-- Speed Slider
local SpeedSlider = PlayerTab:CreateSlider({
    Name = "Speed Value",
    Range = {16, 200},
    Increment = 8,
    Suffix = " Speed",
    CurrentValue = 50,
    Flag = "SpeedSlider",
    Callback = function(Value)
        CustomSpeed = Value
        
        if SpeedEnabled then
            applySpeed(CustomSpeed)
        end
    end,
})

-- Jump Power Toggle
local JumpPowerToggle = PlayerTab:CreateToggle({
    Name = "Jump Power Toggle",
    CurrentValue = false,
    Flag = "JumpPowerToggle",
    Callback = function(Value)
        JumpPowerEnabled = Value
        
        if JumpPowerEnabled then
            enableJumpPower()
        else
            disableJumpPower()
        end
    end,
})

-- Jump Power Slider
local JumpPowerSlider = PlayerTab:CreateSlider({
    Name = "Jump Power Value",
    Range = {50, 500},
    Increment = 25,
    Suffix = " Power",
    CurrentValue = 50,
    Flag = "JumpPowerSlider",
    Callback = function(Value)
        CustomJumpPower = Value
        
        if JumpPowerEnabled then
            applyJumpPower(CustomJumpPower)
        end
    end,
})

-- Fly Toggle
local FlyToggle = PlayerTab:CreateToggle({
    Name = "Fly Toggle",
    CurrentValue = false,
    Flag = "FlyToggle",
    Callback = function(Value)
        Flying = Value
        
        if Flying then
            startFly()
        else
            stopFly()
        end
    end,
})

-- Fly Speed Slider
local FlySpeedSlider = PlayerTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 10,
    Suffix = " Speed",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value)
        FlySpeed = Value
    end,
})

-- Load configuration
Rayfield:LoadConfiguration()

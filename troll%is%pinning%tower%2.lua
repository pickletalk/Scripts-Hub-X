-- Wait for game to load
if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- Load Rayfield with error handling
local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then
    warn("Failed to load Rayfield UI library")
    return
end

local Window = Rayfield:CreateWindow({
   Name = "Troll Is A Pinning Tower 2 - by PickleTalk",
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

-- Wait for player to spawn
if not LocalPlayer.Character then
    LocalPlayer.CharacterAdded:Wait()
end

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

-- Touch Spam Variables
local spamming = false
local spamConnection = nil

-- Helper Functions
local function getRootPart()
    if LocalPlayer.Character then
        return LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

local function getHumanoid()
    if LocalPlayer.Character then
        return LocalPlayer.Character:FindFirstChild("Humanoid")
    end
    return nil
end

local function createNotification(text)
    pcall(function()
        local screenGui = Instance.new("ScreenGui")
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        screenGui.Name = "Notification_" .. tick()

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

        game:GetService("Debris"):AddItem(screenGui, 3)
    end)
end

-- Infinite Jump Functions
local function performInfiniteJump()
    local humanoid = getHumanoid()
    local rootPart = getRootPart()
    
    if humanoid and rootPart then
        local jumpPower = JumpPowerEnabled and CustomJumpPower or OriginalJumpPower
        
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Velocity = Vector3.new(0, jumpPower, 0)
        bodyVelocity.Parent = rootPart
        
        game:GetService("Debris"):AddItem(bodyVelocity, 0.3)
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
    if not LocalPlayer.Character then return {} end
    
    local parts = {}
    for _, part in pairs(LocalPlayer.Character:GetChildren()) do
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
        pcall(function()
            for _, part in pairs(getCharacterParts()) do
                if part and part.Parent then
                    part.CanCollide = false
                end
            end
        end)
    end)
    
    print("Noclip enabled")
end

local function disableNoclip()
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
    
    pcall(function()
        for _, part in pairs(getCharacterParts()) do
            if part and part.Parent then
                part.CanCollide = true
            end
        end
    end)
    
    print("Noclip disabled")
end

-- Fly Functions
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
        pcall(function()
            if Flying and BodyVelocity and BodyVelocity.Parent then
                local camera = workspace.CurrentCamera
                local moveVector = Vector3.new(0, 0, 0)
                
                -- PC Controls (WASD)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                    moveVector = moveVector + camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                    moveVector = moveVector - camera.CFrame.LookVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                    moveVector = moveVector - camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                    moveVector = moveVector + camera.CFrame.RightVector
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                    moveVector = moveVector + Vector3.new(0, 1, 0)
                end
                if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                    moveVector = moveVector - Vector3.new(0, 1, 0)
                end
                
                if moveVector.Magnitude > 0 then
                    BodyVelocity.Velocity = moveVector.Unit * FlySpeed
                else
                    BodyVelocity.Velocity = Vector3.new(0, 0, 0)
                end
            end
        end)
    end)
    
    print("Flying enabled at speed: " .. FlySpeed)
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
    
    print("Flying disabled")
end

-- God Mode Functions
local function enableGodMode()
    local humanoid = getHumanoid()
    if not humanoid then return end
    
    if not GodModeEnabled then
        OriginalMaxHealth = humanoid.MaxHealth
    end
    
    humanoid.MaxHealth = math.huge
    humanoid.Health = math.huge
    
    if HealthConnection then
        HealthConnection:Disconnect()
    end
    
    HealthConnection = humanoid.HealthChanged:Connect(function(health)
        if GodModeEnabled and health < math.huge then
            pcall(function()
                humanoid.Health = math.huge
            end)
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

-- Touch Spam Functions
local function findTarget()
    -- Try multiple possible names for the target
    local targets = {"Gudock", "TouchPart", "Goal", "Finish"}
    for _, name in pairs(targets) do
        local target = workspace:FindFirstChild(name)
        if target then
            return target
        end
    end
    
    -- Search recursively if not found at workspace root
    local function searchForTouchPart(parent)
        for _, child in pairs(parent:GetChildren()) do
            if child.Name == "Gudock" or child:FindFirstChild("TouchInterest") then
                return child
            end
            local found = searchForTouchPart(child)
            if found then return found end
        end
    end
    
    return searchForTouchPart(workspace)
end

local function startTouchSpam()
    if spamConnection then
        spamConnection:Disconnect()
    end
    
    spamConnection = RunService.Heartbeat:Connect(function()
        if spamming then
            pcall(function()
                local humanoidRootPart = getRootPart()
                local targetPart = findTarget()
                
                if humanoidRootPart and targetPart then
                    -- Multiple methods for touching
                    -- Method 1: firetouchinterest
                    if firetouchinterest then
                        firetouchinterest(humanoidRootPart, targetPart, 0)
                        firetouchinterest(humanoidRootPart, targetPart, 1)
                    end
                    
                    -- Method 2: Alternative touch simulation
                    if getconnections and targetPart:FindFirstChild("TouchInterest") then
                        for _, connection in pairs(getconnections(targetPart.Touched)) do
                            connection:Fire(humanoidRootPart)
                        end
                    end
                end
            end)
        end
    end)
end

local function stopTouchSpam()
    if spamConnection then
        spamConnection:Disconnect()
        spamConnection = nil
    end
end

-- Character Event Handlers
local function onCharacterAdded(character)
    wait(1)
    
    local humanoid = character:WaitForChild("Humanoid", 5)
    if not humanoid then return end
    
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
    if spamming then
        startTouchSpam()
    end
end

local function onCharacterRemoving()
    -- Clean up all connections
    pcall(function()
        if InfiniteJumpConnection then InfiniteJumpConnection:Disconnect() end
        if NoclipConnection then NoclipConnection:Disconnect() end
        if FlyConnection then FlyConnection:Disconnect() end
        if spamConnection then spamConnection:Disconnect() end
        if HealthConnection then HealthConnection:Disconnect() end
    end)
end

-- Connect character events
LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
LocalPlayer.CharacterRemoving:Connect(onCharacterRemoving)

-- Initialize if character already exists
if LocalPlayer.Character then
    spawn(function()
        onCharacterAdded(LocalPlayer.Character)
    end)
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
            createNotification("Noclip Enabled")
        else
            disableNoclip()
            createNotification("Noclip Disabled")
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
            createNotification("God Mode Enabled")
        else
            disableGodMode()
            createNotification("God Mode Disabled")
        end
    end,
})

-- Touch Spam Toggle (Main Tab)
local TouchSpamToggle = Main:CreateToggle({
   Name = "Auto Touch Spam (Gudock)",
   CurrentValue = false,
   Flag = "TouchSpamToggle",
   Callback = function(Value)
       spamming = Value
       
       if spamming then
           startTouchSpam()
           createNotification("Auto Touch Spam Enabled")
           print("Looking for target part...")
           local target = findTarget()
           if target then
               print("Found target: " .. target.Name)
           else
               print("Target not found!")
           end
       else
           stopTouchSpam()
           createNotification("Auto Touch Spam Disabled")
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
            createNotification("Speed Enabled: " .. CustomSpeed)
        else
            disableSpeed()
            createNotification("Speed Disabled")
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
            createNotification("Jump Power Enabled: " .. CustomJumpPower)
        else
            disableJumpPower()
            createNotification("Jump Power Disabled")
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
            createNotification("Fly Enabled")
        else
            stopFly()
            createNotification("Fly Disabled")
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

-- Debug button to check for target
local DebugButton = Main:CreateButton({
   Name = "Find Touch Target (Debug)",
   Callback = function()
       local target = findTarget()
       if target then
           createNotification("Found: " .. target.Name)
           print("Target found: " .. target.Name)
           print("Path: " .. target:GetFullName())
           if target:FindFirstChild("TouchInterest") then
               print("TouchInterest found!")
           else
               print("No TouchInterest found")
           end
       else
           createNotification("No target found!")
           print("No valid target found in workspace")
       end
   end,
})

-- Load configuration
Rayfield:LoadConfiguration()

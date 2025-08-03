local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Obby Script - by PickleTalk",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "Pickle Interface Suite",
   LoadingSubtitle = "by PickleTalk",
   ShowText = "by PickleTalk", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "PickleField", -- Create a custom folder for your hub/game
      FileName = "Config"
   },

   Discord = {
      Enabled = true, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "https://discord.gg/bpsNUH5sVb", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local Main = Window:CreateTab("Main", "layers")
local Player = Window:CreateTab("Player", "person-standing")

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()

-- Fly variables
local Flying = false
local FlySpeed = 50
local BodyVelocity = nil
local BodyAngularVelocity = nil
local FlyConnection = nil

-- Jump Power variables
local JumpPowerEnabled = false
local CustomJumpPower = 50
local OriginalJumpPower = 50 -- Default Roblox jump power

-- Noclip variables
local NoclipEnabled = false
local NoclipConnection = nil

-- Speed variables
local SpeedEnabled = false
local CustomSpeed = 50
local OriginalSpeed = 16 -- Default Roblox walkspeed

-- Infinite Jump variables
local InfiniteJumpEnabled = false
local InfiniteJumpConnection = nil

-- Function to get HumanoidRootPart
local function getRootPart()
    local character = Player.Character
    if character then
        return character:FindFirstChild("HumanoidRootPart")
    end
    return nil
end

-- Function to perform infinite jump
local function performInfiniteJump()
    local humanoid = getHumanoid()
    local rootPart = getRootPart()
    
    if humanoid and rootPart then
        -- Create upward velocity based on CustomJumpPower
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Velocity = Vector3.new(0, CustomJumpPower, 0)
        bodyVelocity.Parent = rootPart
        
        -- Remove the BodyVelocity after a short time
        game:GetService("Debris"):AddItem(bodyVelocity, 0.2)
        
        -- Also set humanoid jump state for visual effect
        humanoid.Jump = true
    end
end

-- Function to enable infinite jump
local function enableInfiniteJump()
    InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
        if InfiniteJumpEnabled then
            performInfiniteJump()
        end
    end)
    
    print("Infinite Jump enabled (Jump Power: " .. CustomJumpPower .. ")")
end

-- Function to disable infinite jump
local function disableInfiniteJump()
    if InfiniteJumpConnection then
        InfiniteJumpConnection:Disconnect()
        InfiniteJumpConnection = nil
    end
    
    print("Infinite Jump disabled")
end

-- Handle character respawning
Player.CharacterAdded:Connect(function(character)
    -- Wait for character to fully load
    wait(0.5)
    
    -- Reapply infinite jump if it was enabled
    if InfiniteJumpEnabled then
        -- Disconnect old connection if it exists
        if InfiniteJumpConnection then
            InfiniteJumpConnection:Disconnect()
        end
        enableInfiniteJump()
    end
end)

-- Clean up when character is removed
Player.CharacterRemoving:Connect(function()
    if InfiniteJumpConnection then
        InfiniteJumpConnection:Disconnect()
        InfiniteJumpConnection = nil
    end
end)

local function createNotification()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.Name = "InfiniteJumpNotification"

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 0) -- Start with zero height
    frame.Position = UDim2.new(0.5, -100, 0.9, -40) -- Adjusted position for upward growth
    frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10) -- Smooth edges with 10px radius
    uiCorner.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Successful Infinite Jump"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 16
    textLabel.Parent = frame

    -- Grow upward animation
    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 200, 0, 40)})
    tweenIn:Play()

    -- Destroy after 1 second of visibility + 1 second shrink animation
    wait(1)
    local tweenOut = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 200, 0, 0)})
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        wait(0.5) -- Wait for shrink to complete
        screenGui:Destroy()
    end)
end

-- Function to get current humanoid
local function getHumanoid()
    local character = Player.Character
    if character then
        return character:FindFirstChild("Humanoid")
    end
    return nil
end

-- Function to store original speed
local function storeOriginalSpeed()
    local humanoid = getHumanoid()
    if humanoid then
        OriginalSpeed = humanoid.WalkSpeed
    end
end

-- Function to apply walkspeed
local function applySpeed(speed)
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.WalkSpeed = speed
        print("Walk Speed set to: " .. speed)
    end
end

-- Function to enable custom speed
local function enableSpeed()
    applySpeed(CustomSpeed)
    print("Custom Speed enabled")
end

-- Function to disable custom speed (restore original)
local function disableSpeed()
    applySpeed(OriginalSpeed)
    print("Speed restored to original: " .. OriginalSpeed)
end

-- Handle character spawning/respawning
Player.CharacterAdded:Connect(function(character)
    -- Wait for humanoid to load
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Store the original speed when character spawns
    if not SpeedEnabled then
        OriginalSpeed = humanoid.WalkSpeed
    end
    
    -- Apply custom speed if enabled
    if SpeedEnabled then
        wait(0.1) -- Small delay to ensure character is fully loaded
        applySpeed(CustomSpeed)
    end
end)

-- Store original speed on script start
if Player.Character then
    storeOriginalSpeed()
end

-- Function to get character parts
local function getCharacterParts()
    local character = Player.Character
    if not character then return {} end
    
    local parts = {}
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
            table.insert(parts, part)
        end
    end
    return parts
end

-- Function to enable noclip
local function enableNoclip()
    NoclipConnection = RunService.Stepped:Connect(function()
        local character = Player.Character
        if not character then return end
        
        -- Make all character parts non-collidable except HumanoidRootPart
        for _, part in pairs(getCharacterParts()) do
            if part and part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)
    
    print("Noclip enabled")
end

-- Function to disable noclip
local function disableNoclip()
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
    
    -- Restore collision for all character parts
    local character = Player.Character
    if character then
        for _, part in pairs(getCharacterParts()) do
            if part and part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    
    print("Noclip disabled")
end

-- Handle character respawning
Player.CharacterAdded:Connect(function(character)
    -- Wait a bit for character to fully load
    wait(0.5)
    
    -- Reapply noclip if it was enabled
    if NoclipEnabled then
        enableNoclip()
    end
end)

-- Clean up when character is removed
Player.CharacterRemoving:Connect(function()
    if NoclipConnection then
        NoclipConnection:Disconnect()
        NoclipConnection = nil
    end
end)

-- Function to get current humanoid
local function getHumanoid()
    local character = Player.Character
    if character then
        return character:FindFirstChild("Humanoid")
    end
    return nil
end

-- Function to store original jump power
local function storeOriginalJumpPower()
    local humanoid = getHumanoid()
    if humanoid then
        OriginalJumpPower = humanoid.JumpPower
    end
end

-- Function to apply jump power
local function applyJumpPower(jumpPower)
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.JumpPower = jumpPower
        print("Jump Power set to: " .. jumpPower)
    end
end

-- Function to enable custom jump power
local function enableJumpPower()
    applyJumpPower(CustomJumpPower)
    print("Custom Jump Power enabled")
end

-- Function to disable custom jump power (restore original)
local function disableJumpPower()
    applyJumpPower(OriginalJumpPower)
    print("Jump Power restored to original: " .. OriginalJumpPower)
end

-- Handle character spawning/respawning
Player.CharacterAdded:Connect(function(character)
    -- Wait for humanoid to load
    local humanoid = character:WaitForChild("Humanoid")
    
    -- Store the original jump power when character spawns
    if not JumpPowerEnabled then
        OriginalJumpPower = humanoid.JumpPower
    end
    
    -- Apply custom jump power if enabled
    if JumpPowerEnabled then
        wait(0.1) -- Small delay to ensure character is fully loaded
        applyJumpPower(CustomJumpPower)
    end
end)

-- Store original jump power on script start
if Player.Character then
    storeOriginalJumpPower()
end

-- Direction vectors for movement
local function getDirectionVector()
    local camera = workspace.CurrentCamera
    local moveVector = Vector3.new(0, 0, 0)
    
    -- Get input directions
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
    
    return moveVector.Unit
end

-- Start flying function
local function startFly()
    local character = Player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
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
        if Flying and BodyVelocity then
            local direction = getDirectionVector()
            BodyVelocity.Velocity = direction * FlySpeed
        end
    end)
    
    print("Flying enabled at speed: " .. FlySpeed)
end

-- Stop flying function
local function stopFly()
    local character = Player.Character
    if character then
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = false
        end
    end
    
    -- Clean up body movers
    if BodyVelocity then
        BodyVelocity:Destroy()
        BodyVelocity = nil
    end
    
    if BodyAngularVelocity then
        BodyAngularVelocity:Destroy()
        BodyAngularVelocity = nil
    end
    
    -- Disconnect flying loop
    if FlyConnection then
        FlyConnection:Disconnect()
        FlyConnection = nil
    end
    
    print("Flying disabled")
end

-- Handle character respawning
Player.CharacterAdded:Connect(function()
    -- Wait a bit for character to fully load
    wait(1)
    if Flying then
        startFly()
    end
end)

-- Infinite Jump
local Button = Main:CreateButton({
   Name = "Inf Jump",
   Callback = function(toggle)
       -- Infinite Jump Script
       -- by pickletalk
       
       local Players = game:GetService("Players")
       local UserInputService = game:GetService("UserInputService")
       local TweenService = game:GetService("TweenService")

       -- Configuration
       local player = Players.LocalPlayer
       local isInfiniteJumpEnabled = false

       local function getOriginalJumpPower()
           local character = player.Character or player.CharacterAdded:Wait()
           local humanoid = character:WaitForChild("Humanoid")
           return humanoid.JumpPower
       end

       local function createNotification()
           local screenGui = Instance.new("ScreenGui")
           screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
           screenGui.Name = "InfiniteJumpNotification"

           local frame = Instance.new("Frame")
           frame.Size = UDim2.new(0, 200, 0, 0) -- Start with zero height
           frame.Position = UDim2.new(0.5, -100, 0.9, -40) -- Adjusted position for upward growth
           frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
           frame.BorderSizePixel = 0
           frame.Parent = screenGui

           local uiCorner = Instance.new("UICorner")
           uiCorner.CornerRadius = UDim.new(0, 10) -- Smooth edges with 10px radius
           uiCorner.Parent = frame

           local textLabel = Instance.new("TextLabel")
           textLabel.Size = UDim2.new(1, 0, 1, 0)
           textLabel.BackgroundTransparency = 1
           textLabel.Text = "Successful Infinite Jump"
           textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
           textLabel.Font = Enum.Font.SourceSansBold
           textLabel.TextSize = 16
           textLabel.Parent = frame

           -- Grow upward animation
           local tweenIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 200, 0, 40)})
           tweenIn:Play()

           -- Destroy after 1 second of visibility + 1 second shrink animation
           wait(1)
           local tweenOut = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 200, 0, 0)})
           tweenOut:Play()
           tweenOut.Completed:Connect(function()
               wait(0.5) -- Wait for shrink to complete
               screenGui:Destroy()
           end)
       end

       local function enableInfiniteJump(toggle)
           if isInfiniteJumpEnabled == toggle then
               return -- No action if state matches
           end

           local character = player.Character or player.CharacterAdded:Wait()
           local humanoid = character:WaitForChild("Humanoid")
           local originalJumpPower = getOriginalJumpPower()
           local JUMP_POWER = originalJumpPower -- Use game's original jump power as base

           if toggle then
               isInfiniteJumpEnabled = true
               local connection
               connection = UserInputService.JumpRequest:Connect(function()
                   if player.Character and player.Character:FindFirstChild("Humanoid") then
                       local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                       if rootPart then
                           local bodyVelocity = Instance.new("BodyVelocity")
                           bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                           bodyVelocity.Velocity = Vector3.new(0, JUMP_POWER, 0)
                           bodyVelocity.Parent = rootPart
                           game:GetService("Debris"):AddItem(bodyVelocity, 0.2)
                       end
                   end
               end)
        
               -- Ensure infinite jump persists on character removal
               local characterRemovedConnection = player.CharacterRemoving:Connect(function()
                   if connection then
                       connection:Disconnect()
                   end
               end)
        
               -- Reconnect on character respawn
               player.CharacterAdded:Connect(function(newCharacter)
                   character = newCharacter
                   humanoid = character:WaitForChild("Humanoid")
                   originalJumpPower = getOriginalJumpPower()
                   JUMP_POWER = originalJumpPower
                   if isInfiniteJumpEnabled then
                       connection = UserInputService.JumpRequest:Connect(function()
                           if player.Character and player.Character:FindFirstChild("Humanoid") then
                               local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                               if rootPart then
                                   local bodyVelocity = Instance.new("BodyVelocity")
                                   bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                                   bodyVelocity.Velocity = Vector3.new(0, JUMP_POWER, 0)
                                   bodyVelocity.Parent = rootPart
                                   game:GetService("Debris"):AddItem(bodyVelocity, 0.2)
                               end
                           end
                       end)
                       characterRemovedConnection:Disconnect()
                       characterRemovedConnection = player.CharacterRemoving:Connect(function()
                           if connection then
                               connection:Disconnect()
                           end
                       end)
                   end
               end)
        
               -- Show notification when enabled
               createNotification()
           else
               isInfiniteJumpEnabled = false

               for _, connection in pairs(getconnections(UserInputService.JumpRequest)) do
                   if connection.Function then
                       connection:Disable()
                   end
               end
               humanoid.JumpPower = originalJumpPower -- Restore original jump power
               if player.Character then
                   local humanoid = player.Character:FindFirstChild("Humanoid")
                   if humanoid then
                       humanoid.JumpPower = originalJumpPower
                   end
               end
           end
       end

       enableInfiniteJump(not isInfiniteJumpEnabled)
   end,
})

-- Speed Toggle
local SpeedToggle = Player:CreateToggle({
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
local SpeedSlider = Player:CreateSlider({
    Name = "Player Speed",
    Range = {16, 200},
    Increment = 8,
    Suffix = "Speed",
    CurrentValue = 50,
    Flag = "SpeedSlider",
    Callback = function(Value)
        CustomSpeed = Value
        
        -- Apply immediately if speed is enabled
        if SpeedEnabled then
            applySpeed(CustomSpeed)
        end
        
        print("Speed value set to: " .. Value)
    end,
})

-- Jump Power Toggle
local JumpPowerToggle = Player:CreateToggle({
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
local JumpPowerSlider = Player:CreateSlider({
    Name = "Jump Power",
    Range = {50, 500},
    Increment = 25,
    Suffix = "Power",
    CurrentValue = 50,
    Flag = "JumpPowerSlider",
    Callback = function(Value)
        CustomJumpPower = Value
        
        -- Apply immediately if jump power is enabled
        if JumpPowerEnabled then
            applyJumpPower(CustomJumpPower)
        end
        
        print("Jump Power value set to: " .. Value)
    end,
})

-- Fly Toggle
local FlyToggle = Player:CreateToggle({
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
local FlySpeedSlider = Player:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 10,
    Suffix = "Speed",
    CurrentValue = 50,
    Flag = "FlySpeed",
    Callback = function(Value)
        FlySpeed = Value
        print("Fly speed set to: " .. Value)
    end,
})

-- Noclip Toggle
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

-- Infinite Jump Toggle
local InfiniteJumpToggle = Main:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJumpToggle",
    Callback = function(Value)
        InfiniteJumpEnabled = Value
        
        if InfiniteJumpEnabled then
            enableInfiniteJump()
            createNotification()
        else
            disableInfiniteJump()
        end
    end,
})

Rayfield:LoadConfiguration()

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Obby Script - by PickleTalk",
   Icon = 0,
   LoadingTitle = "Pickle Interface Suite",
   LoadingSubtitle = "by PickleTalk",
   ShowText = "by PickleTalk",
   Theme = "Amethyst",
   ToggleUIKeybind = "K",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,
   ConfigurationSaving = {
      Enabled = true,
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
local ContextActionService = game:GetService("ContextActionService")

local LocalPlayer = Players.LocalPlayer

-- Variables
local Flying = false
local FlySpeed = 1
local BodyGyro = nil
local BodyVelocity = nil
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
local ctrl = {f = 0, b = 0, l = 0, r = 0}
local lastctrl = {f = 0, b = 0, l = 0, r = 0}
local maxspeed = 50
local speed = 0
local isMobile = UserInputService.TouchEnabled

-- Helper Functions
local function getRootPart()
    local character = LocalPlayer.Character
    if character then
        return character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso")
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
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Velocity = Vector3.new(0, JumpPowerEnabled and CustomJumpPower or OriginalJumpPower, 0)
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
local function handleInput(actionName, inputState, inputObject)
    if inputState == Enum.UserInputState.Begin then
        if inputObject.KeyCode == Enum.KeyCode.W then ctrl.f = 1
        elseif inputObject.KeyCode == Enum.KeyCode.S then ctrl.b = -1
        elseif inputObject.KeyCode == Enum.KeyCode.A then ctrl.l = -1
        elseif inputObject.KeyCode == Enum.KeyCode.D then ctrl.r = 1
        end
    elseif inputState == Enum.UserInputState.End then
        if inputObject.KeyCode == Enum.KeyCode.W then ctrl.f = 0
        elseif inputObject.KeyCode == Enum.KeyCode.S then ctrl.b = 0
        elseif inputObject.KeyCode == Enum.KeyCode.A then ctrl.l = 0
        elseif inputObject.KeyCode == Enum.KeyCode.D then ctrl.r = 0
        end
    end
end

local function startFly()
    repeat wait() until LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character:FindFirstChild("Humanoid")
    local character = LocalPlayer.Character
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = getRootPart()

    if not Flying or not rootPart or not humanoid then return end

    createNotification("Fly Activated")
    BodyGyro = Instance.new("BodyGyro", rootPart)
    BodyGyro.P = 9e4
    BodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.CFrame = rootPart.CFrame
    BodyVelocity = Instance.new("BodyVelocity", rootPart)
    BodyVelocity.Velocity = Vector3.new(0, 0.1, 0)
    BodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)

    humanoid.PlatformStand = true
    LocalPlayer.Character.Animate.Disabled = true

    -- Bind controls for PC and mobile
    if isMobile then
        ContextActionService:BindAction("flyForward", handleInput, false, Enum.KeyCode.ButtonA)
        ContextActionService:BindAction("flyBackward", handleInput, false, Enum.KeyCode.ButtonB)
        ContextActionService:BindAction("flyLeft", handleInput, false, Enum.KeyCode.ButtonX)
        ContextActionService:BindAction("flyRight", handleInput, false, Enum.KeyCode.ButtonY)
    else
        ContextActionService:BindAction("flyForward", handleInput, false, Enum.KeyCode.W)
        ContextActionService:BindAction("flyBackward", handleInput, false, Enum.KeyCode.S)
        ContextActionService:BindAction("flyLeft", handleInput, false, Enum.KeyCode.A)
        ContextActionService:BindAction("flyRight", handleInput, false, Enum.KeyCode.D)
    end

    local lastUpdate = tick()
    RunService.RenderStepped:Connect(function()
        local now = tick()
        if now - lastUpdate < 1/60 then return end
        lastUpdate = now

        if ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0 then
            speed = math.min(speed + 0.5 + (speed / maxspeed), maxspeed)
        elseif not (ctrl.l + ctrl.r ~= 0 or ctrl.f + ctrl.b ~= 0) and speed ~= 0 then
            speed = math.max(speed - 1, 0)
        end
        if (ctrl.l + ctrl.r) ~= 0 or (ctrl.f + ctrl.b) ~= 0 then
            BodyVelocity.Velocity = ((workspace.CurrentCamera.CFrame.LookVector * (ctrl.f + ctrl.b)) + ((workspace.CurrentCamera.CFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).Position) - workspace.CurrentCamera.CFrame.Position)) * speed
            lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
        elseif (ctrl.l + ctrl.r) == 0 and (ctrl.f + ctrl.b) == 0 and speed ~= 0 then
            BodyVelocity.Velocity = ((workspace.CurrentCamera.CFrame.LookVector * (lastctrl.f + lastctrl.b)) + ((workspace.CurrentCamera.CFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * 0.2, 0).Position) - workspace.CurrentCamera.CFrame.Position)) * speed
        else
            BodyVelocity.Velocity = Vector3.new(0, 0.1, 0)
        end
        BodyGyro.CFrame = workspace.CurrentCamera.CFrame * CFrame.Angles(-math.rad((ctrl.f + ctrl.b) * 50 * speed / maxspeed), 0, 0)
    end)

    while Flying and LocalPlayer.Character and humanoid and humanoid.Health > 0 do
        wait()
    end
end

local function stopFly()
    Flying = false
    if BodyGyro then BodyGyro:Destroy() end
    if BodyVelocity then BodyVelocity:Destroy() end
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.PlatformStand = false
        LocalPlayer.Character.Animate.Disabled = false
    end
    if isMobile then
        ContextActionService:UnbindAction("flyForward")
        ContextActionService:UnbindAction("flyBackward")
        ContextActionService:UnbindAction("flyLeft")
        ContextActionService:UnbindAction("flyRight")
    else
        ContextActionService:UnbindAction("flyForward")
        ContextActionService:UnbindAction("flyBackward")
        ContextActionService:UnbindAction("flyLeft")
        ContextActionService:UnbindAction("flyRight")
    end
    createNotification("Fly Deactivated")
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
    
    if not SpeedEnabled then
        OriginalSpeed = humanoid.WalkSpeed
    end
    if not JumpPowerEnabled then
        OriginalJumpPower = humanoid.JumpPower
    end
    if not GodModeEnabled then
        OriginalMaxHealth = humanoid.MaxHealth
    end
    
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
end

LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
LocalPlayer.CharacterRemoving:Connect(onCharacterRemoving)

if LocalPlayer.Character then
    onCharacterAdded(LocalPlayer.Character)
end

-- Main Tab
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

local FlySpeedSlider = PlayerTab:CreateSlider({
    Name = "Fly Speed",
    Range = {1, 100},
    Increment = 1,
    Suffix = " Speed",
    CurrentValue = 1,
    Flag = "FlySpeed",
    Callback = function(Value)
        maxspeed = Value
    end,
})

Rayfield:LoadConfiguration()

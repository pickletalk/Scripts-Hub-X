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
local FlySpeed = 25
local BodyVelocity = Instance.new("BodyVelocity")
syn.protect_gui(BodyVelocity)
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
local CurrentlyFlying = false
local MaxForce = Vector3.new(123123, 123123, 123123)
local UpFly = Vector3.new(0, 25, 0)
local Speed = UpFly.Y
local Keys = {
    [Enum.KeyCode.W] = {"LookVector", false},
    [Enum.KeyCode.S] = {"LookVector", true},
    [Enum.KeyCode.A] = {"RightVector", true},
    [Enum.KeyCode.D] = {"RightVector", false}
}
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

local function startFly(Velocity)
    CurrentlyFlying = true
    while (CurrentlyFlying) do
        BodyVelocity.Parent = LocalPlayer.Character.HumanoidRootPart
        BodyVelocity.MaxForce = MaxForce
        BodyVelocity.Velocity = Velocity
        wait(0.2)
    end
end

local function stopFly()
    CurrentlyFlying = false
    BodyVelocity.Parent = nil
    BodyVelocity.MaxForce = Vector3.new()
    BodyVelocity.Velocity = Vector3.new()
end

UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
    if (gameProcessedEvent) then
        return
    end
    local KeyCode = input.KeyCode
    local MoveData = Keys[KeyCode]
    if (MoveData) then
        local Multiplier = MoveData[2] and -1 or 1
        local Velocity = LocalPlayer.Character.HumanoidRootPart.CFrame[MoveData[1]] * FlySpeed
        startFly(Velocity * Multiplier)
        return
    end
    if (KeyCode == Enum.KeyCode.Space) then
        startFly(UpFly)
        return
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessedEvent)
    if (gameProcessedEvent) then
        return
    end
    local KeyCode = input.KeyCode
    if (Keys[KeyCode] or KeyCode == Enum.KeyCode.Space) then
        stopFly()
    end
end)

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
        CurrentlyFlying = true
        startFly(UpFly)
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
local Toggle = Main:CreateToggle({
   Name = "Toggle Example",
   CurrentValue = false,
   Flag = "Toggle1",
   Callback = function(Value)
   end,
})

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
            CurrentlyFlying = true
            startFly(UpFly)
            createNotification("Fly Enabled")
        else
            CurrentlyFlying = false
            stopFly()
            createNotification("Fly Disabled")
        end
    end,
})

local FlySpeedSlider = PlayerTab:CreateSlider({
    Name = "Fly Speed",
    Range = {1, 100},
    Increment = 1,
    Suffix = " Speed",
    CurrentValue = 25,
    Flag = "FlySpeed",
    Callback = function(Value)
        FlySpeed = Value
        UpFly = Vector3.new(0, FlySpeed, 0)
        Speed = UpFly.Y
        if CurrentlyFlying then
            startFly(UpFly)
        end
    end,
})

Rayfield:LoadConfiguration()

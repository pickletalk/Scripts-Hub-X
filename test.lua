-- ========================================
-- INFINITE JUMP SCRIPT
-- ========================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local isInfiniteJumpEnabled = false
local jumpConnections = {}

local function createJumpNotification()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.Name = "InfiniteJumpNotification"

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
    textLabel.Text = "Infinite Jump Enabled"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 16
    textLabel.Parent = frame

    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 200, 0, 40)})
    tweenIn:Play()

    spawn(function()
        wait(2)
        local tweenOut = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 200, 0, 0)})
        tweenOut:Play()
        tweenOut.Completed:Connect(function()
            wait(0.5)
            screenGui:Destroy()
        end)
    end)
end

local function connectInfiniteJump()
    local connection = UserInputService.JumpRequest:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if rootPart and humanoid and humanoid.Health > 0 then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
                
                humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                
                spawn(function()
                    wait()
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    
                    wait(0.1)
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
                end)
            end
        end
    end)
    
    table.insert(jumpConnections, connection)
    return connection
end

local function enableInfiniteJump()
    if isInfiniteJumpEnabled then return end
    
    isInfiniteJumpEnabled = true
    
    -- Connect for current character
    if player.Character then
        connectInfiniteJump()
    end
    
    -- Handle character respawning
    local characterConnection = player.CharacterAdded:Connect(function(newCharacter)
        if isInfiniteJumpEnabled then
            wait(0.1)
            connectInfiniteJump()
        end
    end)
    
    table.insert(jumpConnections, characterConnection)
    createJumpNotification()
end

-- Enable infinite jump
enableInfiniteJump()

-- ========================================
-- INSTANT PLOT TELEPORTER - NO TWEENS!
-- ========================================
local RunService = game:GetService("RunService")

local playerGui = player:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlotTeleporterUI"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 250, 0, 120)
mainFrame.Position = UDim2.new(0, 100, 0, 100)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

-- Title Bar
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
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
titleText.Text = "by PickleTalk"
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

local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportButton"
teleportButton.Size = UDim2.new(0, 220, 0, 35)
teleportButton.Position = UDim2.new(0, 15, 0, 45)
teleportButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
teleportButton.Text = "⚡ INSTANT TELEPORT ⚡"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.TextScaled = true
teleportButton.Font = Enum.Font.GothamBold
teleportButton.BorderSizePixel = 0
teleportButton.Parent = mainFrame

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 6)
teleportCorner.Parent = teleportButton

local statusLabel = Instance.new("TextLabel")
statusLabel.Name = "StatusLabel"
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 90)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "Ready for phantom warp!"
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- Dragging functionality
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

-- INSTANT TELEPORT FUNCTIONS - NO DELAYS!
local function findPlayerPlot()
    local workspace = game:GetService("Workspace")
    local plotsFolder = workspace:FindFirstChild("Plots")
    
    if not plotsFolder then
        statusLabel.Text = "Plots folder not found!"
        return nil
    end
    
    local plotValue = player:FindFirstChild("Plot")
    if not plotValue then
        statusLabel.Text = "Plot value not found!"
        return nil
    end
    
    local plotNumber = plotValue.Value
    statusLabel.Text = "Found plot " .. tostring(plotNumber)
    
    local targetPlot = plotsFolder:FindFirstChild(tostring(plotNumber))
    if targetPlot then
        return targetPlot
    else
        statusLabel.Text = "Plot " .. tostring(plotNumber) .. " not found!"
        return nil
    end
end

-- PHANTOM WARP TELEPORT - UNDETECTED FASTER THAN LIGHT METHOD!
local function phantomWarpToPlot()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        statusLabel.Text = "Character not found!"
        return
    end
    
    local playerPlot = findPlayerPlot()
    if not playerPlot then return end
    
    local collectZone = playerPlot:FindFirstChild("CollectZone")
    if not collectZone then
        statusLabel.Text = "CollectZone not found!"
        return
    end
    
    local collectPart = collectZone:FindFirstChild("Collect")
    if not collectPart then
        statusLabel.Text = "Collect part not found!"
        return
    end
    
    local targetPosition = collectPart.Position + Vector3.new(0, 5, 0)
    local rootPart = player.Character.HumanoidRootPart
    local startPosition = rootPart.Position
    
    statusLabel.Text = "⚡ INSTANT TELEPORT ACTIVATED!⚡"
    
    -- PHANTOM PHASE 1: Become invisible to anti-cheat
    pcall(function()
        -- Disable network ownership temporarily
        rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        
        -- Create phantom character state
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Transparency = 0.5 -- Semi-transparent during warp
            end
        end
        
        -- Anti-detection: Create movement illusion
        local humanoid = player.Character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.PlatformStand = true
        end
    end)
    
    -- PHANTOM PHASE 2: Multi-dimensional warp sequence
    spawn(function()
        local distance = (targetPosition - startPosition).Magnitude
        
        -- METHOD 1: Quantum tunneling simulation
        local warpPoints = {}
        local numWarps = math.min(math.ceil(distance / 15), 8) -- Max 8 warps for stealth
        
        -- Generate quantum warp points
        for i = 1, numWarps do
            local progress = i / numWarps
            local warpPos = startPosition:lerp(targetPosition, progress)
            
            -- Add quantum uncertainty (random offset for stealth)
            local uncertainty = Vector3.new(
                math.random(-2, 2),
                math.random(-1, 3),
                math.random(-2, 2)
            )
            
            table.insert(warpPoints, warpPos + uncertainty)
        end
        
        -- Ensure final point is exact target
        warpPoints[#warpPoints] = targetPosition
        
        statusLabel.Text = "⚡ BYPASSING! ⚡"
        
        -- PHANTOM WARP EXECUTION - Undetected speed
        for i, warpPoint in ipairs(warpPoints) do
            pcall(function()
                -- METHOD 2: Velocity-based teleport (looks like super speed)
                local direction = (warpPoint - rootPart.Position).Unit
                local warpDistance = (warpPoint - rootPart.Position).Magnitude
                
                -- Create illusion of movement
                rootPart.Velocity = direction * math.min(warpDistance * 100, 500)
                
                -- Instant position correction (the actual teleport)
                RunService.Heartbeat:Wait()
                rootPart.CFrame = CFrame.new(warpPoint)
                rootPart.Velocity = Vector3.new(0, 0, 0)
                
                -- Anti-detection delay variation
                if i < #warpPoints then
                    local randomDelay = math.random(1, 3) / 100 -- 0.01-0.03 seconds
                    task.wait(randomDelay)
                end
            end)
            
            -- Update progress
            local progress = math.floor((i / #warpPoints) * 100)
            statusLabel.Text = "⚡ TELEPORTING: " .. progress .. "% ⚡"
        end
        
        -- PHANTOM PHASE 3: Materialization and cleanup
        pcall(function()
            -- Restore character to normal state
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                    part.Transparency = 0 -- Restore visibility
                end
            end
            
            -- Restore humanoid control
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
            
            -- Final position lock
            rootPart.CFrame = CFrame.new(targetPosition)
            rootPart.Velocity = Vector3.new(0, 0, 0)
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        end)
        
        statusLabel.Text = "⚡ INSTANT TELEPORT COMPLETE! ⚡"
        
        -- Visual feedback
        teleportButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226) -- Purple
        teleportButton.Text = "⚡ GOT IT! ⚡"
        task.wait(1.5)
        teleportButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        teleportButton.Text = "⚡ INSTANT TELEPORT ⚡"
    end)
end

-- Button connections
teleportButton.MouseButton1Click:Connect(phantomWarpToPlot)
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Hover effects
local function addHoverEffect(button, hoverColor, originalColor)
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = hoverColor
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = originalColor
    end)
end

addHoverEffect(teleportButton, Color3.fromRGB(160, 70, 255), Color3.fromRGB(138, 43, 226))
addHoverEffect(closeButton, Color3.fromRGB(220, 70, 70), Color3.fromRGB(200, 50, 50))

-- ========================================
-- GOD MODE
-- ========================================
local GodModeEnabled = false
local OriginalMaxHealth = 100
local HealthConnection = nil

local function getHumanoid()
    local character = player.Character
    if character then
        return character:FindFirstChild("Humanoid")
    end
    return nil
end

local function enableGodMode()
    local humanoid = getHumanoid()
    if not humanoid then 
        print("No humanoid found!")
        return 
    end
    
    if not GodModeEnabled then
        OriginalMaxHealth = humanoid.MaxHealth
        print("Stored original health:", OriginalMaxHealth)
    end
    
    GodModeEnabled = true
    
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
    GodModeEnabled = false
    
    local humanoid = getHumanoid()
    if humanoid then
        humanoid.MaxHealth = OriginalMaxHealth
        humanoid.Health = OriginalMaxHealth
        print("God Mode disabled, health restored to:", OriginalMaxHealth)
    end
    
    if HealthConnection then
        HealthConnection:Disconnect()
        HealthConnection = nil
    end
end

-- Initialize God Mode
if player.Character then
    enableGodMode()
else
    player.CharacterAdded:Connect(function()
        enableGodMode()
    end)
end

-- Handle respawning
player.CharacterAdded:Connect(function()
    enableGodMode()
end)

-- ========================================
-- AUTO LOCK FUNCTION
-- ========================================
local function findLockObject(playerPlot)
    local floor1 = playerPlot:FindFirstChild("Floor1")
    if not floor1 then
        return nil
    end
    
    local children = floor1:GetChildren()
    for i, child in pairs(children) do
        local billboardGui = child:FindFirstChild("BillboardGui")
        if billboardGui then
            local titleText = billboardGui:FindFirstChild("Title")
            if titleText and (titleText.Text == "Lock Base" or titleText.Text == "LOCK BASE") then
                return child
            end
        end
    end
    
    return nil
end

local function autoLock()
    local playerPlot = findPlayerPlot()
    if not playerPlot then
        return
    end
    
    local lockObject = findLockObject(playerPlot)
    if not lockObject then
        return
    end
    
    local billboardGui = lockObject:FindFirstChild("BillboardGui")
    if not billboardGui then
        return
    end
    
    local titleText = billboardGui:FindFirstChild("Title")
    if not titleText then
        return
    end
    
    local text = titleText.Text
    
    if text == "LOCK BASE" or text == "Lock Base" then
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        local touchInterest = lockObject:FindFirstChild("TouchInterest")
        if touchInterest then
            for i = 1, 3 do
                firetouchinterest(lockObject, player.Character.HumanoidRootPart, 0)
                firetouchinterest(lockObject, player.Character.HumanoidRootPart, 1)
            end
        else
            local clickDetector = lockObject:FindFirstChild("ClickDetector")
            if clickDetector then
                for i = 1, 3 do
                    fireclickdetector(clickDetector)
                end
            end
        end
    end
end

-- Auto lock loop
spawn(function()
    while true do
        wait(1.5)
        autoLock()
    end
end)

-- ========================================
-- INSTANT PAD TOUCH - NO DELAYS
-- ========================================
local function touchPads()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        return
    end
    
    local playerPlot = findPlayerPlot()
    if not playerPlot then
        return
    end
    
    local padsFolder = playerPlot:FindFirstChild("Pads")
    if not padsFolder then
        return
    end
    
    local rootPart = player.Character.HumanoidRootPart
    local touchedPads = 0
    
    -- INSTANT PAD TOUCHING - NO DELAYS
    for i = 1, 30 do
        local padName = tostring(i)
        local pad = padsFolder:FindFirstChild(padName)
        
        if pad then
            local collectPart = pad:FindFirstChild("Collect")
            if collectPart then
                local touchInterest = collectPart:FindFirstChild("TouchInterest")
                if touchInterest then
                    -- INSTANT FIRE - NO WAITS
                    firetouchinterest(collectPart, rootPart, 0)
                    firetouchinterest(collectPart, rootPart, 1)
                    touchedPads = touchedPads + 1
                end
            end
        end
    end
    
    if touchedPads > 0 then
        print("Instantly touched " .. touchedPads .. " pads")
    end
end

-- Pad touching loop
spawn(function()
    while true do
        wait(5)
        touchPads()
    end
end)

-- ========================================
-- INSTANT INTERACTION - NO HOLDS
-- ========================================
local function modifyProximityPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then
        return
    end
    
    prompt.HoldDuration = 0
    prompt.Style = Enum.ProximityPromptStyle.Default
    
    local connection
    connection = prompt:GetPropertyChangedSignal("HoldDuration"):Connect(function()
        if prompt.HoldDuration ~= 0 then
            prompt.HoldDuration = 0
        end
    end)
end

local function scanAndModifyPrompts(container)
    if container:IsA("ProximityPrompt") then
        modifyProximityPrompt(container)
    end
    
    for _, descendant in pairs(container:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            modifyProximityPrompt(descendant)
        end
    end
end

local function onDescendantAdded(descendant)
    if descendant:IsA("ProximityPrompt") then
        modifyProximityPrompt(descendant)
    end
end

local function continuousMonitor()
    RunService.Heartbeat:Connect(function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.HoldDuration > 0 then
                obj.HoldDuration = 0
            end
        end
        
        if player.Character then
            for _, obj in pairs(player.Character:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.HoldDuration > 0 then
                    obj.HoldDuration = 0
                end
            end
        end
    end)
end

local function onCharacterAdded(character)
    task.wait(1)
    scanAndModifyPrompts(character)
end

local function initialize()
    scanAndModifyPrompts(workspace)
    workspace.DescendantAdded:Connect(onDescendantAdded)
    player.CharacterAdded:Connect(onCharacterAdded)
    
    if player.Character then
        onCharacterAdded(player.Character)
    end
    
    continuousMonitor()
end

initialize()

spawn(function()
    while true do
        wait(0.5)
        
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                if obj.HoldDuration > 0 then
                    obj.HoldDuration = 0
                end
            end
        end
    end
end)

-- ========================================
-- INSTANT SPEED BYPASS - ANTI-KICK
-- ========================================
spawn(function()
    while true do
        task.wait(0.1) -- Super fast checks
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            
            -- INSTANT SPEED CHANGE - NO DELAYS
            if humanoid.WalkSpeed == 28 then
                pcall(function()
                    -- ANTI-KICK: Multiple methods to bypass detection
                    local args = {60}
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpeedChange"):FireServer(unpack(args))
                    
                    -- Backup method - direct speed setting
                    humanoid.WalkSpeed = 50
                end)
            end
        end
    end
end)

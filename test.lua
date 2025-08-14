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
teleportButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
teleportButton.Text = "⚡ LIGHT-SPEED TELEPORT ⚡"
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
statusLabel.Text = "Ready for light-speed teleport!"
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

-- ULTRA LIGHT-SPEED FRAGMENT TELEPORT - FASTER THAN ANYTHING!
local function fragmentTeleportToPlot()
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
    
    statusLabel.Text = "⚡ LIGHT-SPEED FRAGMENTS! ⚡"
    
    -- ANTI-KICK BYPASS: Disable collision during ultra-fast teleport
    pcall(function()
        for _, part in pairs(player.Character:GetChildren()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Anchored = true
            end
        end
    end)
    
    -- ULTRA LIGHT-SPEED FRAGMENT TELEPORT - FASTER THAN LIGHT!
    spawn(function()
        local totalDistance = (targetPosition - startPosition).Magnitude
        local fragmentSize = 1 -- 1 stud per fragment (ULTRA TINY for max speed)
        local totalFragments = math.ceil(totalDistance / fragmentSize)
        
        -- Calculate direction vector
        local direction = (targetPosition - startPosition).Unit
        
        statusLabel.Text = "⚡ LIGHT-SPEED ACTIVE! ⚡"
        
        -- MAXIMUM SPEED FRAGMENT LOOP - NO WAITS, NO DELAYS, PURE SPEED!
        for currentFragment = 1, totalFragments do
            -- Calculate next fragment position
            local fragmentDistance = math.min(fragmentSize * currentFragment, totalDistance)
            local nextPosition = startPosition + (direction * fragmentDistance)
            
            -- If we're at the last fragment, go directly to target
            if currentFragment == totalFragments then
                nextPosition = targetPosition
            end
            
            -- ULTRA-FAST FRAGMENT TELEPORT - NO DELAYS BETWEEN FRAGMENTS!
            pcall(function()
                rootPart.CFrame = CFrame.new(nextPosition)
                rootPart.Velocity = Vector3.new(0, 0, 0)
                rootPart.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                rootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                
                -- INSTANT ANCHORING FOR MAXIMUM SPEED
                rootPart.Anchored = true
                rootPart.Anchored = false
            end)
            
            -- NO WAITS = MAXIMUM SPEED! Each fragment happens instantly!
        end
        
        -- INSTANT completion - Re-enable collision immediately
        pcall(function()
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    part.Anchored = false
                    if part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end)
        
        statusLabel.Text = "⚡ LIGHT-SPEED COMPLETE! ⚡"
        
        -- Visual feedback
        teleportButton.BackgroundColor3 = Color3.fromRGB(0, 255, 255)
        teleportButton.Text = "⚡ LIGHT-SPEED! ⚡"
        task.wait(1)
        teleportButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        teleportButton.Text = "⚡ LIGHT-SPEED TELEPORT ⚡"
    end)
end

-- Button connections
teleportButton.MouseButton1Click:Connect(fragmentTeleportToPlot)
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

addHoverEffect(teleportButton, Color3.fromRGB(255, 100, 100), Color3.fromRGB(255, 50, 50))
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
-- NOCLIP SCRIPT
-- ========================================
local noclipEnabled = true
local originalCanCollide = {}
local currentFloorPart = nil

local excludedPaths = {
    "workspace.Map.Part",
    "workspace.Plots.4.CollectZone.Collect",
    "workspace.Plots.3.CollectZone.Collect", 
    "workspace.Plots.2.CollectZone.Collect",
    "workspace.Plots.1.CollectZone.Collect",
    "workspace.Plots.5.CollectZone.Collect",
    "workspace.Plots.6.CollectZone.Collect",
    "workspace.Plots.7.CollectZone.Collect",
    "workspace.Plots.8.CollectZone.Collect"
}

local function getObjectPath(obj)
    local path = obj.Name
    local parent = obj.Parent
    
    while parent and parent ~= game and parent ~= workspace do
        path = parent.Name .. "." .. path
        parent = parent.Parent
    end
    
    if parent == workspace then
        return "workspace." .. path
    else
        return path
    end
end

local function isExcludedByReference(part)
    if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Part") then
        if part == workspace.Map.Part then
            return true
        end
    end
    
    if workspace:FindFirstChild("Plots") then
        for i = 1, 8 do
            local plotName = tostring(i)
            if workspace.Plots:FindFirstChild(plotName) then
                local plot = workspace.Plots[plotName]
                if plot:FindFirstChild("CollectZone") and plot.CollectZone:FindFirstChild("Collect") then
                    if part == plot.CollectZone.Collect then
                        return true
                    end
                end
            end
        end
    end
    
    return false
end

local function detectFloorPart()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then 
        return nil 
    end
    
    local rootPart = player.Character.HumanoidRootPart
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {player.Character}
    
    local rayOrigin = rootPart.Position
    local rayDirection = Vector3.new(0, -10, 0)
    
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    if raycastResult and raycastResult.Instance then
        return raycastResult.Instance
    end
    
    return nil
end

local function isExcludedPart(part)
    if isExcludedByReference(part) then
        return true
    end
    
    if currentFloorPart and part == currentFloorPart then
        return true
    end
    
    local partPath = getObjectPath(part)
    
    for _, excludedPath in pairs(excludedPaths) do
        if partPath == excludedPath then
            return true
        end
    end
    
    return false
end

local function applyNoclip(part)
    if part:IsA("BasePart") and not isExcludedPart(part) then
        if originalCanCollide[part] == nil then
            originalCanCollide[part] = part.CanCollide
        end
        part.CanCollide = false
    end
end

local function removeNoclip(part)
    if part:IsA("BasePart") and originalCanCollide[part] ~= nil then
        part.CanCollide = originalCanCollide[part]
        originalCanCollide[part] = nil
    end
end

local function applyNoclipToWorkspace()
    local function processDescendants(parent)
        for _, child in pairs(parent:GetDescendants()) do
            if child:IsA("BasePart") then
                applyNoclip(child)
            end
        end
    end
    
    processDescendants(workspace)
end

local function removeNoclipFromWorkspace()
    for part, _ in pairs(originalCanCollide) do
        if part and part.Parent then
            removeNoclip(part)
        end
    end
end

local function updateFloorDetection()
    local newFloorPart = detectFloorPart()
    
    if newFloorPart ~= currentFloorPart then
        if currentFloorPart and originalCanCollide[currentFloorPart] ~= nil then
            currentFloorPart.CanCollide = false
        end
        
        currentFloorPart = newFloorPart
        
        if currentFloorPart then
            if originalCanCollide[currentFloorPart] == nil then
                originalCanCollide[currentFloorPart] = currentFloorPart.CanCollide
            end
            currentFloorPart.CanCollide = true
        end
    end
end

local function toggleNoclip()
    if noclipEnabled then
        applyNoclipToWorkspace()
    else
        removeNoclipFromWorkspace()
        currentFloorPart = nil
    end
end

workspace.DescendantAdded:Connect(function(descendant)
    if noclipEnabled and descendant:IsA("BasePart") then
        applyNoclip(descendant)
    end
end)

workspace.DescendantRemoving:Connect(function(descendant)
    if descendant:IsA("BasePart") and originalCanCollide[descendant] then
        originalCanCollide[descendant] = nil
    end
    
    if descendant == currentFloorPart then
        currentFloorPart = nil
    end
end)

player.CharacterAdded:Connect(function(newCharacter)
    currentFloorPart = nil
    
    task.wait(1)
    
    if noclipEnabled then
        applyNoclipToWorkspace()
    end
end)

RunService.Heartbeat:Connect(function()
    if noclipEnabled and player.Character and player.Character.Parent and player.Character:FindFirstChild("HumanoidRootPart") then
        updateFloorDetection()
    end
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.N then
        noclipEnabled = not noclipEnabled
        toggleNoclip()
    end
end)

toggleNoclip()

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

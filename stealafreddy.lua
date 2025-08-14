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
    
    if player.Character then
        connectInfiniteJump()
    end
    
    local characterConnection = player.CharacterAdded:Connect(function(newCharacter)
        if isInfiniteJumpEnabled then
            wait(0.1)
            connectInfiniteJump()
        end
    end)
    
    table.insert(jumpConnections, characterConnection)
    createJumpNotification()
end

enableInfiniteJump()

-- ========================================
-- PLOT TELEPORTER (REVISED AND FIXED)
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
mainFrame.Size = UDim2.new(0, 250, 0, 95) -- Adjusted size after removing status label
mainFrame.Position = UDim2.new(1, -260, 0, 10) -- Positioned at the top-right corner
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Draggable = true -- Make the frame draggable
mainFrame.Active = true
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
titleText.Text = "Plot Teleporter"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.TextSize = 16
titleText.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "CloseButton"
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -28, 0.5, -12.5)
closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.GothamBold
closeButton.TextSize = 14
closeButton.BorderSizePixel = 0
closeButton.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeButton

local teleportButton = Instance.new("TextButton")
teleportButton.Name = "TeleportButton"
teleportButton.Size = UDim2.new(1, -30, 0, 40)
teleportButton.Position = UDim2.new(0.5, -((250 - 30) / 2), 0, 45)
teleportButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226) -- Purple color
teleportButton.Text = "⚡ TELEPORT ⚡"
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Font = Enum.Font.GothamBold
teleportButton.TextSize = 18
teleportButton.BorderSizePixel = 0
teleportButton.Parent = mainFrame

local teleportCorner = Instance.new("UICorner")
teleportCorner.CornerRadius = UDim.new(0, 6)
teleportCorner.Parent = teleportButton

-- State variable to prevent double-clicking
local isTeleporting = false

-- Plot teleporter functions
local function findPlayerPlot()
    local workspace = game:GetService("Workspace")
    local plotsFolder = workspace:FindFirstChild("Plots")
    
    if not plotsFolder then
        print("Teleporter Error: Plots folder not found!")
        return nil
    end
    
    local plotValue = player:FindFirstChild("Plot")
    if not (plotValue and typeof(plotValue) == "ObjectValue" and plotValue.Value) then
        print("Teleporter Error: Player plot value not found or is invalid!")
        return nil
    end

    local targetPlot = plotsFolder:FindFirstChild(tostring(plotValue.Value))
    if targetPlot then
        return targetPlot
    else
        print("Teleporter Error: Plot " .. tostring(plotValue.Value) .. " not found!")
        return nil
    end
end

local function executeTeleport()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
        print("Teleporter Error: Character not found!")
        return false -- Indicate failure to start
    end
    
    local playerPlot = findPlayerPlot()
    if not playerPlot then return false end
    
    local collectZone = playerPlot:FindFirstChild("CollectZone")
    if not collectZone then
        print("Teleporter Error: CollectZone not found in plot!")
        return false
    end
    
    local collectPart = collectZone:FindFirstChild("Collect")
    if not collectPart then
        print("Teleporter Error: Collect part not found in CollectZone!")
        return false
    end
    
    local targetPosition = collectPart.Position + Vector3.new(0, 5, 0)
    local rootPart = player.Character.HumanoidRootPart
    
    -- Enable noclip temporarily
    for _, part in pairs(player.Character:GetChildren()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
    
    -- Step 1: Teleport smoothly up
    local currentPosition = rootPart.Position
    local targetAbovePosition = currentPosition + Vector3.new(0, 50, 0)
    local tweenToAbove = TweenService:Create(rootPart, TweenInfo.new(1.0, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(targetAbovePosition)})
    tweenToAbove:Play()
    
    tweenToAbove.Completed:Connect(function()
        -- Step 2: Teleport smoothly to the target plot
        local distance = (targetAbovePosition - targetPosition).Magnitude
        local timeToTarget = distance / 60 -- Travel at 60 studs/sec
        
        local tweenToTarget = TweenService:Create(rootPart, TweenInfo.new(timeToTarget, Enum.EasingStyle.Linear), {CFrame = CFrame.new(targetPosition)})
        tweenToTarget:Play()
        
        tweenToTarget.Completed:Connect(function()
            -- Turn off noclip when player reaches their plot
            for _, part in pairs(player.Character:GetChildren()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
            
            -- Reset button state after teleportation is fully complete
            teleportButton.Text = "⚡ TELEPORT ⚡"
            teleportButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            isTeleporting = false
        end)
    end)
    
    return true -- Indicate teleport sequence has started successfully
end

-- Button connections
teleportButton.MouseButton1Click:Connect(function()
    if isTeleporting then return end -- Prevent double-clicks

    isTeleporting = true
    teleportButton.Text = "Teleporting..."
    teleportButton.BackgroundColor3 = Color3.fromRGB(90, 30, 150) -- Darker purple for disabled state

    -- Execute the teleport and check if it started successfully
    local success = executeTeleport()
    
    -- If the teleport couldn't start (e.g., plot not found), reset the button immediately
    if not success then
        isTeleporting = false
        teleportButton.Text = "⚡ TELEPORT ⚡"
        teleportButton.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Hover effects
local function addHoverEffect(button, hoverColor, originalColor)
    button.MouseEnter:Connect(function()
        if not isTeleporting then
            button.BackgroundColor3 = hoverColor
        end
    end)
    
    button.MouseLeave:Connect(function()
        if not isTeleporting then
            button.BackgroundColor3 = originalColor
        end
    end)
end

addHoverEffect(teleportButton, Color3.fromRGB(158, 73, 246), Color3.fromRGB(138, 43, 226))
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

if player.Character then
    enableGodMode()
else
    player.CharacterAdded:Connect(function()
        wait(0.5)
        enableGodMode()
    end)
end

player.CharacterAdded:Connect(function()
    wait(0.5)
    if GodModeEnabled then
        enableGodMode()
    end
end)

-- ========================================
-- AUTO LOCK FUNCTION
-- ========================================
local function findLockObject(playerPlot)
    local floor1 = playerPlot:FindFirstChild("Floor1")
    if not floor1 then
        return nil
    end
    
    for _, child in pairs(floor1:GetChildren()) do
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
    -- Re-use the findPlayerPlot function from the teleporter
    local playerPlot = findPlayerPlot()
    if not playerPlot then return end
    
    local lockObject = findLockObject(playerPlot)
    if not lockObject then return end
    
    local billboardGui = lockObject:FindFirstChild("BillboardGui")
    if not billboardGui then return end
    
    local titleText = billboardGui:FindFirstChild("Title")
    if not titleText then return end
    
    local text = titleText.Text
    
    if text == "LOCK BASE" or text == "Lock Base" then
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
        
        local touchInterest = lockObject:FindFirstChild("TouchInterest")
        if touchInterest then
            for i = 1, 3 do
                firetouchinterest(lockObject, player.Character.HumanoidRootPart, 0)
                wait(0.1)
                firetouchinterest(lockObject, player.Character.HumanoidRootPart, 1)
                wait(0.2)
            end
        else
            local clickDetector = lockObject:FindFirstChild("ClickDetector")
            if clickDetector then
                for i = 1, 3 do
                    fireclickdetector(clickDetector)
                    wait(0.2)
                end
            end
        end
    end
end

spawn(function()
    while true do
        wait(1)
        pcall(autoLock)
    end
end)

-- ========================================
-- PAD TOUCH INTEREST LOOP
-- ========================================
local function touchPads()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return end
    
    local playerPlot = findPlayerPlot()
    if not playerPlot then return end
    
    local padsFolder = playerPlot:FindFirstChild("Pads")
    if not padsFolder then return end
    
    local rootPart = player.Character.HumanoidRootPart
    
    for i = 1, 30 do
        local padName = tostring(i)
        local pad = padsFolder:FindFirstChild(padName)
        
        if pad then
            local collectPart = pad:FindFirstChild("Collect")
            if collectPart then
                local touchInterest = collectPart:FindFirstChild("TouchInterest")
                if touchInterest then
                    firetouchinterest(collectPart, rootPart, 0)
                    wait(0.05)
                    firetouchinterest(collectPart, rootPart, 1)
                end
            end
        end
    end
end

spawn(function()
    while true do
        wait(3)
        pcall(touchPads)
    end
end)

-- ========================================
-- NOCLIP SCRIPT
-- ========================================
local noclipEnabled = true
local originalCanCollide = {}
local currentFloorPart = nil

local function getObjectPath(obj)
    local path = obj.Name
    local parent = obj.Parent
    while parent and parent ~= game do
        path = parent.Name .. "." .. path
        parent = parent.Parent
    end
    return path
end

local function detectFloorPart()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then return nil end
    local rootPart = player.Character.HumanoidRootPart
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {player.Character}
    local raycastResult = workspace:Raycast(rootPart.Position, Vector3.new(0, -10, 0), raycastParams)
    return raycastResult and raycastResult.Instance
end

local function isExcludedPart(part)
    if currentFloorPart and part == currentFloorPart then
        return true
    end
    -- You can add more specific exclusion logic here if needed
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
    for _, child in pairs(workspace:GetDescendants()) do
        applyNoclip(child)
    end
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
        if currentFloorPart then
            applyNoclip(currentFloorPart) -- Make old floor noclip
        end
        currentFloorPart = newFloorPart
        if currentFloorPart then
            removeNoclip(currentFloorPart) -- Make new floor solid
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
        wait()
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
    wait(1)
    if noclipEnabled then
        applyNoclipToWorkspace()
    end
end)

RunService.Heartbeat:Connect(function()
    if noclipEnabled and player.Character and player.Character.Parent and player.Character:FindFirstChild("HumanoidRootPart") then
        updateFloorDetection()
    end
end)

toggleNoclip()

-- ========================================
-- FAST INTERACTION SCRIPT
-- ========================================
local function modifyProximityPrompt(prompt)
    if prompt:IsA("ProximityPrompt") and prompt.HoldDuration > 0 then
        prompt.HoldDuration = 0
    end
end

local function scanAndModifyPrompts(container)
    for _, descendant in pairs(container:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            modifyProximityPrompt(descendant)
        end
    end
end

workspace.DescendantAdded:Connect(function(descendant)
    if descendant:IsA("ProximityPrompt") then
        wait(0.1)
        modifyProximityPrompt(descendant)
    end
end)

player.CharacterAdded:Connect(function(character)
    wait(1)
    scanAndModifyPrompts(character)
end)

scanAndModifyPrompts(workspace)
if player.Character then
    scanAndModifyPrompts(player.Character)
end

-- ========================================
-- SPEED MONITOR SCRIPT WITH ANTI-KICK
-- ========================================
spawn(function()
    local lastSpeedChange = 0
    local speedChangeDelay = 1.5
    local maxChangesPerMinute = 20
    local changesThisMinute = 0
    local minuteTimer = 0
    
    while true do
        wait(0.3)
        minuteTimer = minuteTimer + 0.3
        
        if minuteTimer >= 60 then
            changesThisMinute = 0
            minuteTimer = 0
        end
        
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character.Humanoid
            local currentTime = tick()
            
            if humanoid.WalkSpeed == 28 and currentTime - lastSpeedChange >= speedChangeDelay and changesThisMinute < maxChangesPerMinute then
                local success, err = pcall(function()
                    game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("SpeedChange"):FireServer(60)
                end)
                
                if success then
                    lastSpeedChange = currentTime
                    changesThisMinute = changesThisMinute + 1
                else
                    wait(1)
                end
            end
        end
    end
end)

-- ========================================
-- MAIN SERVICES AND VARIABLES
-- ========================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- ========================================
-- INFINITE JUMP SCRIPT
-- ========================================
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
            local jumpHumanoid = player.Character:FindFirstChild("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if rootPart and jumpHumanoid and jumpHumanoid.Health > 0 then
                jumpHumanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
                jumpHumanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
                
                jumpHumanoid:ChangeState(Enum.HumanoidStateType.Landed)
                
                spawn(function()
                    wait()
                    jumpHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    
                    wait(0.1)
                    jumpHumanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
                    jumpHumanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
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
-- PLOT TELEPORTER
-- ========================================
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
mainFrame.Position = UDim2.new(1, -260, 0, 10)
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
titleText.Text = "💰 SHADOW HEIST 💰"
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
teleportButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
teleportButton.Text = "💰 STEAL 💰"
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
statusLabel.Text = "by PickleTalk"
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

-- Plot teleporter functions
local function findPlayerPlot()
    local workspace = game:GetService("Workspace")
    local plotsFolder = workspace:FindFirstChild("Plots")
    
    if not plotsFolder then
        statusLabel.Text = "Plots folder not found!"
        return nil
    end
    
    local plotValue = player:FindFirstChild("Plot")
    if not plotValue then
        statusLabel.Text = "Plot value not found in player!"
        return nil
    end
    
    local plotNumber = plotValue.Value
    statusLabel.Text = "by PickleTalk"
    
    local targetPlot = plotsFolder:FindFirstChild(tostring(plotNumber))
    if targetPlot then
        statusLabel.Text = "by PickleTalk"
        return targetPlot
    else
        statusLabel.Text = "Plot " .. tostring(plotNumber) .. " not found!"
        return nil
    end
end

local function teleportToPlot()
    -- Change button to "stealing" mode
    teleportButton.Text = "💰 STEALING CUH!... 💰"

    -- Target colors for fade (dark red, blue, purple)
    local colors = {
        Color3.fromRGB(100, 0, 0),   -- dark red
        Color3.fromRGB(0, 0, 100),   -- dark blue
        Color3.fromRGB(50, 0, 100)   -- dark purple
    }

    -- RGB fade loop (sync to 2.5s total time)
    local running = true
    spawn(function()
        local currentColor = colors[math.random(1, #colors)]
        local nextColor = colors[math.random(1, #colors)]
        local fadeTime = 3.5
        local t = 0
        while running do
            t = t + (task.wait() or 0)
            local alpha = math.min(t / fadeTime, 1)
            teleportButton.BackgroundColor3 = currentColor:Lerp(nextColor, alpha)
            if alpha >= 1 then
                currentColor = nextColor
                repeat
                    nextColor = colors[math.random(1, #colors)]
                until nextColor ~= currentColor
                t = 0
            end
        end
    end)

    -- Wait 2.5 seconds before firing
    task.wait(3.5)

    -- Find the player's plot
    local playerPlot = findPlayerPlot()
    if not playerPlot then
        running = false
        teleportButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        teleportButton.Text = "💰 FAILED CUH! 💰"
        task.wait(1)
        teleportButton.Text = "💰 STEAL 💰"
        return
    end

    -- Get CollectTrigger TouchInterest path
    local collectTrigger = playerPlot:FindFirstChild("CollectZone") and playerPlot.CollectZone:FindFirstChild("CollectTrigger")
    if collectTrigger and collectTrigger:FindFirstChild("TouchInterest") then
        firetouchinterest(collectTrigger, player.Character.HumanoidRootPart, 0)
        task.wait(0.05)
        firetouchinterest(collectTrigger, player.Character.HumanoidRootPart, 1)
    end

    -- Stop RGB effect
    running = false

    -- Show premium gold success flash
    teleportButton.Text = "💰 SUCCESS CUH! 💰"
    local gold = Color3.fromRGB(212, 175, 55)
    local black = Color3.fromRGB(0, 0, 0)
    for i = 1, 3 do
        teleportButton.BackgroundColor3 = gold
        task.wait(0.15)
        teleportButton.BackgroundColor3 = black
        task.wait(0.15)
    end

    -- Restore original
    teleportButton.BackgroundColor3 = black
    teleportButton.Text = "💰 STEAL 💰"
end

-- Button connections
teleportButton.MouseButton1Click:Connect(teleportToPlot)
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

addHoverEffect(closeButton, Color3.fromRGB(220, 70, 70), Color3.fromRGB(200, 50, 50))

-- ========================================
-- GOD MODE
-- ========================================
local GodModeEnabled = false
local OriginalMaxHealth = 100
local HealthConnection = nil

local function getHumanoid()
    local currentCharacter = player.Character
    if currentCharacter then
        return currentCharacter:FindFirstChild("Humanoid")
    end
    return nil
end

local function enableGodMode()
    local godHumanoid = getHumanoid()
    if not godHumanoid then 
        print("No humanoid found!")
        return 
    end
    
    if not GodModeEnabled then
        OriginalMaxHealth = godHumanoid.MaxHealth
        print("Stored original health:", OriginalMaxHealth)
    end
    
    GodModeEnabled = true
    
    godHumanoid.MaxHealth = math.huge
    godHumanoid.Health = math.huge
    
    if HealthConnection then
        HealthConnection:Disconnect()
    end
    
    HealthConnection = godHumanoid.HealthChanged:Connect(function(health)
        if GodModeEnabled and health < math.huge then
            godHumanoid.Health = math.huge
        end
    end)
    
    print("God Mode enabled")
end

local function disableGodMode()
    GodModeEnabled = false
    
    local godHumanoid = getHumanoid()
    if godHumanoid then
        godHumanoid.MaxHealth = OriginalMaxHealth
        godHumanoid.Health = OriginalMaxHealth
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
        wait(0.5)
        enableGodMode()
    end)
end

-- ========================================
-- AUTO LOCK FUNCTION
-- ========================================
local function findLockObject(playerPlot)
    -- Try different approaches to find the lock object
    local floor1 = playerPlot:FindFirstChild("Floor1")
    if not floor1 then
        return nil
    end
    
    -- Search through all children for lock object
    local children = floor1:GetChildren()
    for i, child in pairs(children) do
        local billboardGui = child:FindFirstChild("BillboardGui")
        if billboardGui then
            local titleLockText = billboardGui:FindFirstChild("Title")
            if titleLockText and (titleLockText.Text == "Lock Base" or titleLockText.Text == "LOCK BASE") then
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
    
    local titleLockText = billboardGui:FindFirstChild("Title")
    if not titleLockText then
        return
    end
    
    local text = titleLockText.Text
    
    -- Check if text is LOCK BASE or Lock Base
    if text == "LOCK BASE" or text == "Lock Base" then
        -- Make sure player has a character
        if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then
            return
        end
        
        -- Try different methods to activate the lock
        local touchInterest = lockObject:FindFirstChild("TouchInterest")
        if touchInterest then
            for i = 1, 3 do
                firetouchinterest(lockObject, player.Character.HumanoidRootPart, 0)
                wait(0.1)
                firetouchinterest(lockObject, player.Character.HumanoidRootPart, 1)
                wait(0.2)
            end
        else
            -- Try ClickDetector if TouchInterest doesn't exist
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

-- Main loop to continuously check for auto lock
spawn(function()
    while true do
        wait(0.5)
        autoLock()
    end
end)

-- ========================================
-- PAD TOUCH INTEREST LOOP
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
        print("Pads folder not found in player plot")
        return
    end
    
    local rootPart = player.Character.HumanoidRootPart
    local touchedPads = 0
    
    -- Loop through pads 1-30
    for i = 1, 30 do
        local padName = tostring(i)
        local pad = padsFolder:FindFirstChild(padName)
        
        if pad then
            local collectPart = pad:FindFirstChild("Collect")
            if collectPart then
                local touchInterest = collectPart:FindFirstChild("TouchInterest")
                if touchInterest then
                    -- Fire touch interest
                    firetouchinterest(collectPart, rootPart, 0)
                    wait(0.05) -- Small delay between touches
                    firetouchinterest(collectPart, rootPart, 1)
                    touchedPads = touchedPads + 1
                end
            end
        end
    end
    
    if touchedPads > 0 then
        print("Touched " .. touchedPads .. " pads in plot")
    end
end

-- Main loop for pad touching every 3 seconds
spawn(function()
    while true do
        wait(3)
        touchPads()
    end
end)

-- ========================================
-- NOCLIP SCRIPT
-- ========================================
-- Noclip state
local noclipEnabled = true

-- Store original CanCollide values
local originalCanCollide = {}

-- Current floor part the player is standing on
local currentFloorPart = nil

-- Excluded paths that should NOT be affected by noclip
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

-- Function to get the full path of an object
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

-- Alternative: Check by object reference for more reliable detection
local function isExcludedByReference(part)
    -- Check if it's the Map.Part
    if workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Part") then
        if part == workspace.Map.Part then
            return true
        end
    end
    
    -- Check collect zones in plots
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

-- Function to detect the floor part the player is standing on
local function detectFloorPart()
    if not player.Character or not player.Character:FindFirstChild("HumanoidRootPart") then 
        return nil 
    end
    
    local rootPart = player.Character.HumanoidRootPart
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {player.Character}
    
    -- Cast ray downward from player's position
    local rayOrigin = rootPart.Position
    local rayDirection = Vector3.new(0, -10, 0) -- Cast 10 studs down
    
    local raycastResult = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
    
    if raycastResult and raycastResult.Instance then
        return raycastResult.Instance
    end
    
    return nil
end

-- Function to check if a part should be excluded from noclip
local function isExcludedPart(part)
    -- First try reference-based checking (more reliable)
    if isExcludedByReference(part) then
        return true
    end
    
    -- Check if it's the current floor part
    if currentFloorPart and part == currentFloorPart then
        return true
    end
    
    -- Fallback to path-based checking
    local partPath = getObjectPath(part)
    
    for _, excludedPath in pairs(excludedPaths) do
        if partPath == excludedPath then
            return true
        end
    end
    
    return false
end

-- Function to apply noclip to a part
local function applyNoclip(part)
    if part:IsA("BasePart") and not isExcludedPart(part) then
        -- Store original CanCollide value if not already stored
        if originalCanCollide[part] == nil then
            originalCanCollide[part] = part.CanCollide
        end
        
        -- Disable collision for noclip
        part.CanCollide = false
    end
end

-- Function to remove noclip from a part
local function removeNoclip(part)
    if part:IsA("BasePart") and originalCanCollide[part] ~= nil then
        -- Restore original CanCollide value
        part.CanCollide = originalCanCollide[part]
        originalCanCollide[part] = nil
    end
end

-- Function to apply noclip to all workspace parts
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

-- Function to remove noclip from all parts
local function removeNoclipFromWorkspace()
    for part, _ in pairs(originalCanCollide) do
        if part and part.Parent then
            removeNoclip(part)
        end
    end
end

-- Function to update floor detection and reapply noclip
local function updateFloorDetection()
    local newFloorPart = detectFloorPart()
    
    -- If floor changed, update collision
    if newFloorPart ~= currentFloorPart then
        -- Remove collision from old floor if it exists
        if currentFloorPart and originalCanCollide[currentFloorPart] ~= nil then
            currentFloorPart.CanCollide = false
        end
        
        -- Set new floor part
        currentFloorPart = newFloorPart
        
        -- Restore collision to new floor if it exists
        if currentFloorPart then
            if originalCanCollide[currentFloorPart] == nil then
                originalCanCollide[currentFloorPart] = currentFloorPart.CanCollide
            end
            currentFloorPart.CanCollide = true
        end
    end
end

-- Main noclip function
local function toggleNoclip()
    if noclipEnabled then
        applyNoclipToWorkspace()
    else
        removeNoclipFromWorkspace()
        currentFloorPart = nil
    end
end

-- Handle new parts being added to workspace
workspace.DescendantAdded:Connect(function(descendant)
    if noclipEnabled and descendant:IsA("BasePart") then
        wait() -- Small delay to ensure part is fully loaded
        applyNoclip(descendant)
    end
end)

-- Handle parts being removed from workspace
workspace.DescendantRemoving:Connect(function(descendant)
    if descendant:IsA("BasePart") and originalCanCollide[descendant] then
        originalCanCollide[descendant] = nil
    end
    
    -- Clear current floor if it's being removed
    if descendant == currentFloorPart then
        currentFloorPart = nil
    end
end)

-- Main loop for floor detection
RunService.Heartbeat:Connect(function()
    if noclipEnabled and player.Character and player.Character.Parent and player.Character:FindFirstChild("HumanoidRootPart") then
        updateFloorDetection()
    end
end)

-- Optional: Toggle noclip with N key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.N then
        noclipEnabled = not noclipEnabled
        toggleNoclip()
    end
end)

-- Initialize noclip
toggleNoclip()

-- ========================================
-- FAST INTERACTION SCRIPT
-- ========================================
-- Function to modify proximity prompt for instant interaction
local function modifyProximityPrompt(prompt)
    if not prompt or not prompt:IsA("ProximityPrompt") then
        return
    end
    
    -- Set hold duration to 0 for instant interaction
    prompt.HoldDuration = 0
    
    -- Also override any style that might interfere
    prompt.Style = Enum.ProximityPromptStyle.Default
    
    -- Ensure it stays at 0 even if the game tries to change it
    local promptConnection
    promptConnection = prompt:GetPropertyChangedSignal("HoldDuration"):Connect(function()
        if prompt.HoldDuration ~= 0 then
            prompt.HoldDuration = 0
        end
    end)
    
    print("Modified proximity prompt:", prompt.Name or "Unnamed")
end

-- Function to scan and modify all proximity prompts in a container
local function scanAndModifyPrompts(container)
    -- Check current object
    if container:IsA("ProximityPrompt") then
        modifyProximityPrompt(container)
    end
    
    -- Check all descendants
    for _, descendant in pairs(container:GetDescendants()) do
        if descendant:IsA("ProximityPrompt") then
            modifyProximityPrompt(descendant)
        end
    end
end

-- Function to handle new proximity prompts being added
local function onDescendantAdded(descendant)
    if descendant:IsA("ProximityPrompt") then
        -- Small delay to ensure the prompt is fully initialized
        wait(0.1)
        modifyProximityPrompt(descendant)
    end
end

-- Function to continuously monitor and fix proximity prompts
local function continuousMonitor()
    RunService.Heartbeat:Connect(function()
        -- Scan workspace for any new or reset proximity prompts
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") and obj.HoldDuration > 0 then
                obj.HoldDuration = 0
            end
        end
        
        -- Also check player's character if it exists
        if player.Character then
            for _, obj in pairs(player.Character:GetDescendants()) do
                if obj:IsA("ProximityPrompt") and obj.HoldDuration > 0 then
                    obj.HoldDuration = 0
                end
            end
        end
    end)
end

-- Function to handle character respawn for fast interaction
local function onCharacterAddedForInteraction(character)
    wait(1) -- Wait for character to fully load
    scanAndModifyPrompts(character)
    print("Fast Interaction applied to new character!")
end

-- Main initialization for fast interaction
local function initialize()
    print("Initializing Fast Interaction script...")
    
    -- Scan entire workspace initially
    scanAndModifyPrompts(workspace)
    
    -- Connect to new objects being added
    workspace.DescendantAdded:Connect(onDescendantAdded)
    
    -- Handle character respawning
    player.CharacterAdded:Connect(onCharacterAddedForInteraction)
    
    -- If character already exists, process it
    if player.Character then
        onCharacterAddedForInteraction(player.Character)
    end
    
    -- Start continuous monitoring
    continuousMonitor()
    
    print("Fast Interaction script loaded! All interactions should now be instant.")
    print("Found and modified proximity prompts in the game.")
end

-- Start the script
initialize()

-- Alternative method using direct prompt manipulation
spawn(function()
    while true do
        wait(0.5) -- Check every half second
        
        -- Find all proximity prompts and force them to instant
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                if obj.HoldDuration > 0 then
                    obj.HoldDuration = 0
                    print("Fixed prompt:", obj.Parent.Name)
                end
            end
        end
    end
end)

-- ========================================
-- ANTI RAGDOLL FUNCTIONS
-- ========================================
-- Remote paths
local ragdollRemote1 = ReplicatedStorage:WaitForChild("Ragdoll")
local ragdollRemote2 = ReplicatedStorage.Remotes:WaitForChild("Ragdoll")

print("[Anti-Ragdoll] Script loaded successfully!")
print("[Anti-Ragdoll] Hooking ragdoll remotes...")

-- Hook the first ragdoll remote
local originalFire1 = ragdollRemote1.FireServer
ragdollRemote1.FireServer = function(self, ...)
    print("[Anti-Ragdoll] Blocked ragdoll attempt via ReplicatedStorage.Ragdoll")
    -- Don't call the original function, effectively blocking the ragdoll
    return
end

-- Hook the second ragdoll remote
local originalFire2 = ragdollRemote2.FireServer
ragdollRemote2.FireServer = function(self, ...)
    print("[Anti-Ragdoll] Blocked ragdoll attempt via ReplicatedStorage.Remotes.Ragdoll")
    -- Don't call the original function, effectively blocking the ragdoll
    return
end

-- Also hook OnClientEvent if they exist (for incoming ragdoll signals)
if ragdollRemote1.OnClientEvent then
    ragdollRemote1.OnClientEvent:Connect(function(...)
        print("[Anti-Ragdoll] Blocked incoming ragdoll signal from ReplicatedStorage.Ragdoll")
        -- Block by not executing ragdoll code
    end)
end

if ragdollRemote2.OnClientEvent then
    ragdollRemote2.OnClientEvent:Connect(function(...)
        print("[Anti-Ragdoll] Blocked incoming ragdoll signal from ReplicatedStorage.Remotes.Ragdoll")
        -- Block by not executing ragdoll code
    end)
end

-- Additional protection: Monitor humanoid state changes
humanoid.StateChanged:Connect(function(oldState, newState)
    if newState == Enum.HumanoidStateType.Physics or newState == Enum.HumanoidStateType.Ragdoll then
        print("[Anti-Ragdoll] Detected ragdoll state change, reverting...")
        humanoid:ChangeState(Enum.HumanoidStateType.Running)
    end
end)

print("[Anti-Ragdoll] All protections active!")
print("[Anti-Ragdoll] You should now be immune to ragdolling.")

-- ========================================
-- SPEED MONITORING AND CHANGER FUNCTIONS
-- ========================================
-- Speed change remote
local speedChangeRemote = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("SpeedChange")

-- Track if we've already changed speed from 28 to prevent multiple calls
local hasChangedFrom28 = false

print("[Speed Detector] Script loaded successfully!")
print("[Speed Detector] Monitoring for speed of 28...")

-- Function to change speed to 70
local function changeSpeedTo70()
    local args = {70}
    speedChangeRemote:FireServer(unpack(args))
    print("[Speed Detector] Speed changed from 28 to 70!")
end

-- Speed monitoring function
local function checkSpeed()
    -- Get current character and humanoid
    local currentCharacter = player.Character
    if not currentCharacter then return end
    
    local currentHumanoid = currentCharacter:FindFirstChild("Humanoid")
    if not currentHumanoid then return end
    
    local currentSpeed = currentHumanoid.WalkSpeed
    
    -- Debug print to see current speed
    -- print("[Speed Detector] Current speed:", currentSpeed)
    
    if currentSpeed == 28 then
        if not hasChangedFrom28 then
            hasChangedFrom28 = true
            changeSpeedTo70()
        end
    else
        -- Reset the flag when speed is not 28 so we can detect 28 again
        if hasChangedFrom28 then
            hasChangedFrom28 = false
            print("[Speed Detector] Ready to detect speed 28 again...")
        end
    end
end

-- Start continuous speed checking with no delay
local speedConnection = RunService.Heartbeat:Connect(checkSpeed)

-- Handle character respawn for all systems
player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    hasChangedFrom28 = false
    
    print("[Speed Detector] Character respawned, continuing speed monitoring...")
    print("[Anti-Ragdoll] Character respawned, reapplying protection...")
    
    -- Reapply humanoid state protection for anti-ragdoll
    humanoid.StateChanged:Connect(function(oldState, newState)
        if newState == Enum.HumanoidStateType.Physics or newState == Enum.HumanoidStateType.Ragdoll then
            print("[Anti-Ragdoll] Detected ragdoll state change, reverting...")
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
        end
    end)
    
    -- Reapply god mode
    wait(0.5)
    if GodModeEnabled then
        enableGodMode()
    end
end)

print("[Speed Detector] Speed monitoring active - no delays, continuous checking!")
print("[Speed Detector] Will change speed to 70 when exactly 28 is detected.")

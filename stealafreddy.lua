-- ========================================
-- MAIN SERVICES AND VARIABLES
-- ========================================
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local excludedNames = { "SafeDoor", "CollectTrigger", "CollectZone" } -- Parts to NOT noclip

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

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
    local workspace = game:GetService("Workspace")   local plotsFolder = workspace:FindFirstChild("Plots")
   
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
        statusLabel.Text = "Plot " .. tostring(plotNumber) .. " not found!"        return nil
    end
end

local function teleportToPlot()
    local running = false
    local root
    local oldAnchored = false
    local startCF

    local function setError(partName)
        running = false
        if root then
            root.Anchored = oldAnchored
        end
        teleportButton.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
        teleportButton.Text = ("💰 ERROR ON %s 💰"):format(partName)
        task.wait(1.5)
        teleportButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        teleportButton.Text = "💰 STEAL 💰"
    end

    local ok, err = pcall(function()
        teleportButton.Text = "💰 STEALING CUH!... 💰"

        root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if not root then return setError("HumanoidRootPart") end
        oldAnchored = root.Anchored
        startCF = root.CFrame

        -- Ocean-wave RGB animation
        running = true
        task.spawn(function()
            local t = 0
            while running do
                t += 0.03
                local r = math.floor((math.sin(t)     * 0.5 + 0.5) * 60)
                local g = math.floor((math.sin(t + 2) * 0.5 + 0.5) * 60)
                local b = math.floor((math.sin(t + 4) * 0.5 + 0.5) * 120 + 60)
                teleportButton.BackgroundColor3 = Color3.fromRGB(r, g, b)
                task.wait(0.03)
            end
        end)

        -- Detect nearby players for 3 seconds
        local startTime = tick()
        while tick() - startTime < 4.5 do
            local closePlayerFound = false
            for _, plr in ipairs(game.Players:GetPlayers()) do
                if plr ~= player and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (plr.Character.HumanoidRootPart.Position - root.Position).Magnitude
                    if dist <= 15 then
                        closePlayerFound = true
                        break
                    end
                end
            end

            if closePlayerFound then
                -- Teleport away 20 studs in a random direction
                local angle = math.rad(math.random(0, 359))
                local offset = Vector3.new(math.cos(angle) * 20, 0, math.sin(angle) * 20)
                root.CFrame = root.CFrame + offset
            end

            task.wait(0.1) -- check 10 times per second
        end

        -- Find player plot
        local plot = findPlayerPlot()
        if not plot then return setError("PlayerPlot") end

        local cz = plot:FindFirstChild("CollectZone")
        if not cz then return setError("CollectZone") end

        local trigger = cz:FindFirstChild("CollectTrigger") or cz:FindFirstChild("Collect")
        if not trigger then return setError("CollectTrigger/Collect") end

        -- Position slightly above trigger for fall
        local triggerPosAbove = trigger.Position + Vector3.new(0, 0.2, 0)

        -- Triple snap fall
        for i = 1, 3 do
            root.CFrame = CFrame.new(triggerPosAbove)
            root.Anchored = false
            task.wait(0.3) -- fall
            root.Anchored = true
            task.wait(0.05)
        end

        -- Check WalkSpeed for success
        local hum = player.Character and player.Character:FindFirstChild("Humanoid")
        if hum and hum.WalkSpeed == 28 then
            teleportButton.Text = "💰 SUCCESS CUH! 💰"
        else
            teleportButton.Text = "💰 RETURNING CUH! 💰"
        end

        -- Return to starting position
        root.CFrame = startCF
        root.Anchored = oldAnchored

        running = false

        -- Flash
        local gold = Color3.fromRGB(212, 175, 55)
        local black = Color3.fromRGB(0, 0, 0)
        for i = 1, 3 do
            teleportButton.BackgroundColor3 = gold
            task.wait(0.15)
            teleportButton.BackgroundColor3 = black
            task.wait(0.15)
        end

        teleportButton.BackgroundColor3 = black
        teleportButton.Text = "💰 STEAL 💰"
    end)

    if not ok then
        running = false
        if root then root.Anchored = oldAnchored end
        teleportButton.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
        teleportButton.Text = "💰 ERROR ON INTERNAL 💰"
        task.wait(1.5)
        teleportButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        teleportButton.Text = "💰 STEAL 💰"
    end
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
        wait(0.5)
        enableGodMode()
    end)
end

-- Handle respawning
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
local floorParts = {
    "LeftFoot",
    "RightFoot",
    "LeftLowerLeg",
    "RightLowerLeg",
    "LeftUpperLeg",
    "RightUpperLeg"
}

local function isFloorPart(part)
    return table.find(floorParts, part.Name) ~= nil
end

local function enableFloorSafeNoclip(character)
    RunService.Stepped:Connect(function()
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                if isFloorPart(part) then
                    part.CanCollide = true -- keep legs/feet collidable
                else
                    part.CanCollide = false -- noclip everything else
                end
            end
        end
    end)
end

-- Apply to current character
if player.Character then
    enableFloorSafeNoclip(player.Character)
end

-- Reapply after respawn
player.CharacterAdded:Connect(function(char)
    enableFloorSafeNoclip(char)
end)

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

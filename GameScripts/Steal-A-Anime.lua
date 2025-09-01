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
local rootPart = character:WaitForChild("HumanoidRootPart")

-- ========================================
-- INFINITE JUMP SCRIPT (Default Jump Height, Respawn Supported)
-- by pickletalk
-- ========================================
local originalJumpPower = nil

-- Function to update the default jump power when character spawns/resets
local function onCharacterAdded(character)
    local humanoid = character:WaitForChild("Humanoid")
    originalJumpPower = humanoid.JumpPower
end

-- Connect for first spawn + future respawns
player.CharacterAdded:Connect(onCharacterAdded)
if player.Character then
    onCharacterAdded(player.Character)
end

-- Infinite Jump (always uses normal default jump height)
UserInputService.JumpRequest:Connect(function()
    local character = player.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and originalJumpPower then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            humanoid.JumpPower = originalJumpPower -- always normal default jump
        end
    end
end)

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
    end)

titleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        if dragging then
            updateDrag(input)
        end
    end
end)

-- Plot finding function
local function findPlayerPlot()
    local workspace = game:GetService("Workspace")
    local basesFolder = workspace:FindFirstChild("Bases")
    
    if not basesFolder then
        statusLabel.Text = "Bases folder not found!"
        return nil
    end
    
    local playerDisplayName = player.DisplayName
    statusLabel.Text = "by PickleTalk"
    
    -- Check plots 1 to 8
    for i = 1, 8 do
        local plotName = tostring(i)
        local plot = basesFolder:FindFirstChild(plotName)
        
        if plot then
            local sign = plot:FindFirstChild("Sign")
            if sign then
                local signPart = sign:FindFirstChild("SignPart")
                if signPart then
                    local surfaceGui = signPart:FindFirstChild("SurfaceGui")
                    if surfaceGui then
                        local textLabel = surfaceGui:FindFirstChild("TextLabel")
                        if textLabel then
                            local signText = textLabel.Text
                            local expectedText = playerDisplayName .. "'s Base"
                            
                            if signText == expectedText then
                                statusLabel.Text = "by PickleTalk"
                                return plotName
                            end
                        end
                    end
                end
            end
        end
    end
    
    statusLabel.Text = "Player plot not found!"
    return nil
end

local function stealFromPlot()
    local running = false
    local root

    local function setError(partName)
        running = false
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

        -- Find player plot
        local plotNumber = findPlayerPlot()
        if not plotNumber then return setError("PlayerPlot") end

        local workspace = game:GetService("Workspace")
        local basesFolder = workspace:FindFirstChild("Bases")
        if not basesFolder then return setError("Bases") end

        local plot = basesFolder:FindFirstChild(plotNumber)
        if not plot then return setError("Plot") end

        local stealCollect2 = plot:FindFirstChild("StealCollect2")
        if not stealCollect2 then return setError("StealCollect2") end

        local touchInterest = stealCollect2:FindFirstChild("TouchInterest")
        if not touchInterest then return setError("TouchInterest") end

        -- Fire the touch interest
        firetouchinterest(stealCollect2, root, 0)
        wait(0.1)
        firetouchinterest(stealCollect2, root, 1)

        running = false

        teleportButton.Text = "💰 SUCCESS CUH! 💰"

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
        teleportButton.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
        teleportButton.Text = "💰 ERROR ON INTERNAL 💰"
        task.wait(1.5)
        teleportButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        teleportButton.Text = "💰 STEAL 💰"
    end
end

-- Button connections
teleportButton.MouseButton1Click:Connect(stealFromPlot)
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
-- AUTO LOCK FUNCTION
-- ========================================
local function autoLock()
    local plotNumber = findPlayerPlot()
    if not plotNumber then
        return
    end
    
    local workspace = game:GetService("Workspace")
    local basesFolder = workspace:FindFirstChild("Bases")
    if not basesFolder then
        return
    end
    
    local plot = basesFolder:FindFirstChild(plotNumber)
    if not plot then
        return
    end
    
    local lockButton = plot:FindFirstChild("LockButton")
    if not lockButton then
        return
    end
    
    local billboardGui = lockButton:FindFirstChild("BillboardGui")
    if not billboardGui then
        return
    end
    
    local frame = billboardGui:FindFirstChild("Frame")
    if not frame then
        return
    end
    
    local countdown = frame:FindFirstChild("Countdown")
    if not countdown then
        return
    end
    
    -- Check if countdown text is "0"
    if countdown.Text == "0" then
        local touchInterest = lockButton:FindFirstChild("TouchInterest")
        if touchInterest and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local rootPart = player.Character.HumanoidRootPart
            
            -- Fire TouchInterest for 1 second
            local startTime = tick()
            while tick() - startTime < 1 do
                firetouchinterest(lockButton, rootPart, 0)
                wait(0.5)
                firetouchinterest(lockButton, rootPart, 1)
                wait(0.5)
            end
            
            print("Auto lock fired for plot " .. plotNumber)
        end
    end
end

-- Main loop for auto lock
spawn(function()
    while true do
        wait(0.1) -- Check every 0.1 seconds for quick response
        autoLock()
    end
end)

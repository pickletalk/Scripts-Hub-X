-- ========================================
-- STEALTHY INITIALIZATION
-- ========================================
local function waitForService(serviceName)
    return game:GetService(serviceName)
end

local Players = waitForService("Players")
local UserInputService = waitForService("UserInputService")
local TweenService = waitForService("TweenService")
local RunService = waitForService("RunService")
local ReplicatedStorage = waitForService("ReplicatedStorage")

local player = Players.LocalPlayer

-- ========================================
--// ESP for LockButton countdowns
-- ========================================
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer

-- Which bases to track
local baseRange = {1, 8} -- from Base["1"] to Base["8"]

-- Create BillboardGui ESP
local function createESP(targetPart, textObj)
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 70, 0, 20) -- smaller box
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.Parent = targetPart

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 0) -- yellow
    label.TextStrokeTransparency = 0.2
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Text = ""
    label.Parent = billboard

    -- Update loop
    RunService.RenderStepped:Connect(function()
        local num = tonumber(textObj.Text)
        if num then
            label.Text = textObj.Text
            if num <= 3 then
                label.TextColor3 = Color3.fromRGB(255, 0, 0) -- red
            else
                label.TextColor3 = Color3.fromRGB(255, 255, 0) -- yellow
            end
        else
            label.Text = textObj.Text -- fallback if not number
        end
    end)
end

-- Attach ESPs to all lock buttons
for i = baseRange[1], baseRange[2] do
    local base = workspace:FindFirstChild("Bases"):FindFirstChild(tostring(i))
    if base then
        local lockBtn = base:FindFirstChild("LockButton")
        if lockBtn then
            local billboardGui = lockBtn:FindFirstChild("BillboardGui")
            if billboardGui then
                local frame = billboardGui:FindFirstChild("Frame")
                if frame then
                    local countdown = frame:FindFirstChild("Countdown")
                    if countdown and countdown:IsA("TextLabel") then
                        createESP(lockBtn, countdown)
                    end
                end
            end
        end
    end
end

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
    task.spawn(function()
        onCharacterAdded(player.Character)
    end)
end

-- Infinite Jump (always uses normal default jump height)
task.spawn(function()
    UserInputService.JumpRequest:Connect(function()
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid and originalJumpPower then
                task.spawn(function()
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    humanoid.JumpPower = originalJumpPower
                end)
            end
        end
    end)
end)

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
    task.spawn(function()
        local humanoid = getHumanoid()
        if not humanoid then 
            return 
        end
        
        if not GodModeEnabled then
            OriginalMaxHealth = humanoid.MaxHealth
        end
        
        GodModeEnabled = true
        
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        
        if HealthConnection then
            HealthConnection:Disconnect()
        end
        
        HealthConnection = humanoid.HealthChanged:Connect(function(health)
            if GodModeEnabled and health < math.huge then
                task.spawn(function()
                    humanoid.Health = math.huge
                end)
            end
        end)
    end)
end

-- Initialize God Mode
task.spawn(function()
    if player.Character then
        enableGodMode()
    else
        player.CharacterAdded:Connect(function()
            enableGodMode()
        end)
    end
    
    -- Handle respawning for God Mode
    player.CharacterAdded:Connect(function()
        if GodModeEnabled then
            enableGodMode()
        end
    end)
end)

-- ========================================
-- PLOT FINDING FUNCTION
-- ========================================
local function findPlayerPlot()
    local success, result = pcall(function()
        local workspace = game:GetService("Workspace")
        local basesFolder = workspace:FindFirstChild("Bases")
        
        if not basesFolder then
            return nil
        end
        
        local playerDisplayName = player.DisplayName
        
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
                                    return plotName
                                end
                            end
                        end
                    end
                end
            end
        end
        
        return nil
    end)
    
    if success then
        return result
    else
        return nil
    end
end

-- ========================================
-- STEALTHY UI CREATION
-- ========================================
task.spawn(function()
    local playerGui = player:WaitForChild("PlayerGui")

    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PlotTeleporterUI"
    screenGui.ResetOnSpawn = false
    
    task.wait(0.1)
    screenGui.Parent = playerGui

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 250, 0, 120)
    mainFrame.Position = UDim2.new(1, -260, 0, 10)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
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
        task.spawn(function()
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end)
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

    -- Steal function
    local function stealFromPlot()
        task.spawn(function()
            local running = false
            local root

            local function setError(partName)
                running = false
                task.spawn(function()
                    teleportButton.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
                    teleportButton.Text = ("💰 ERROR ON %s 💰"):format(partName)
                    task.wait(1.5)
                    teleportButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                    teleportButton.Text = "💰 STEAL 💰"
                end)
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
                        t = t + 0.03
                        local r = math.floor((math.sin(t)     * 0.5 + 0.5) * 60)
                        local g = math.floor((math.sin(t + 2) * 0.5 + 0.5) * 60)
                        local b = math.floor((math.sin(t + 4) * 0.5 + 0.5) * 120 + 60)
                        task.spawn(function()
                            teleportButton.BackgroundColor3 = Color3.fromRGB(r, g, b)
                        end)
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

                -- Fire the touch interest with 0.5 second delay
                task.spawn(function()
                    firetouchinterest(stealCollect2, root, 0)
                    firetouchinterest(stealCollect2, root, 1)
                end)

                running = false
                            
                teleportButton.Text = "💰 SUCCESS CUH! 💰"

                -- Flash
                task.spawn(function()
                    local gold = Color3.fromRGB(212, 175, 55)
                    local black = Color3.fromRGB(0, 0, 0)
                    for i = 1, 3 do
                        teleportButton.BackgroundColor3 = gold
                        task.wait(0.1)
                        teleportButton.BackgroundColor3 = black
                        task.wait(0.1)
                    end

                    teleportButton.BackgroundColor3 = black
                    teleportButton.Text = "💰 STEAL 💰"
                end)
            end)

            if not ok then
                running = false
                setError("INTERNAL")
            end
        end)
    end

    -- Button connections
    teleportButton.MouseButton1Click:Connect(stealFromPlot)
    closeButton.MouseButton1Click:Connect(function()
        task.spawn(function()
            screenGui:Destroy()
        end)
    end)

    -- Hover effects
    local function addHoverEffect(button, hoverColor, originalColor)
        button.MouseEnter:Connect(function()
            task.spawn(function()
                button.BackgroundColor3 = hoverColor
            end)
        end)
        
        button.MouseLeave:Connect(function()
            task.spawn(function()
                button.BackgroundColor3 = originalColor
            end)
        end)
    end

    addHoverEffect(closeButton, Color3.fromRGB(220, 70, 70), Color3.fromRGB(200, 50, 50))
    
    -- Show UI with fade in
    mainFrame.Visible = true
    
    return statusLabel
end)

-- ========================================
-- AUTO LOCK SYSTEM
-- ========================================
local autoLockEnabled = true
local isAutoLocking = false

-- Function to save and restore camera
local function saveCamera()
    local camera = workspace.CurrentCamera
    return {
        CFrame = camera.CFrame,
        CameraType = camera.CameraType,
        CameraSubject = camera.CameraSubject
    }
end

local function restoreCamera(cameraData)
    local camera = workspace.CurrentCamera
    camera.CameraType = cameraData.CameraType
    camera.CFrame = cameraData.CFrame
    camera.CameraSubject = cameraData.CameraSubject
end

-- Main auto lock function
local function autoLockSystem()
    task.spawn(function()
        while autoLockEnabled do
            pcall(function()
                if isAutoLocking then
                    task.wait(0.1)
                    return
                end
                
                -- Find player plot using existing function
                local plotNumber = findPlayerPlot()
                if not plotNumber then 
                    task.wait(0.5)
                    return 
                end
                
                local bases = workspace:FindFirstChild("Bases")
                if not bases then 
                    task.wait(0.5)
                    return 
                end
                
                local plot = bases:FindFirstChild(plotNumber)
                if not plot then 
                    task.wait(0.5)
                    return 
                end
                
                local lockButton = plot:FindFirstChild("LockButton")
                if not lockButton then 
                    task.wait(0.5)
                    return 
                end
                
                local billboardGui = lockButton:FindFirstChild("BillboardGui")
                if not billboardGui then 
                    task.wait(0.5)
                    return 
                end
                
                local frame = billboardGui:FindFirstChild("Frame")
                if not frame then 
                    task.wait(0.5)
                    return 
                end
                
                local countdown = frame:FindFirstChild("Countdown")
                if not countdown then 
                    task.wait(0.5)
                    return 
                end
                
                -- Check if countdown is "0s"
                if countdown.Text == "0s" then
                    isAutoLocking = true
                    
                    local character = player.Character
                    local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                    
                    if humanoidRootPart then
                        -- Save original position and camera
                        local originalPosition = humanoidRootPart.CFrame
                        local cameraData = saveCamera()
                        
                        -- Wait 1 second as requested
                        task.wait(0.9)
                        
                        -- Teleport to LockButton
                        humanoidRootPart.CFrame = lockButton.CFrame + Vector3.new(0, 5, 0) -- Slightly above the button
                        
                        -- Restore camera immediately after teleport
                        restoreCamera(cameraData)
                        
                        -- Wait at the lock button for 0.4 seconds
                        task.wait(0.2)
                        
                        -- Teleport back to original position
                        humanoidRootPart.CFrame = originalPosition
                        
                        -- Restore camera again to ensure it stays in place
                        restoreCamera(cameraData)
                    end
                    
                    isAutoLocking = false
                end
            end)
            
            task.wait(1) -- Check every 1 seconds
        end
    end)
end

-- Start the auto lock system
autoLockSystem()

print("Auto Lock system started!")

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
-- AUTO LOCK SYSTEM WITH MOVEMENT PREVENTION
-- ========================================
local autoLockEnabled = true
local isAutoLocking = false
local movementDisabled = false
local originalConnections = {}

-- Function to disable all player movement
local function disableMovement()
    if movementDisabled then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not humanoidRootPart then return end
    
    movementDisabled = true
    
    -- Store original values
    originalConnections.walkSpeed = humanoid.WalkSpeed
    originalConnections.jumpPower = humanoid.JumpPower
    originalConnections.jumpHeight = humanoid.JumpHeight
    originalConnections.platformStand = humanoid.PlatformStand
    
    -- Disable all movement
    humanoid.WalkSpeed = 0
    humanoid.JumpPower = 0
    humanoid.JumpHeight = 0
    humanoid.PlatformStand = false -- Allow falling by gravity
    
    -- Prevent any velocity changes except gravity
    task.spawn(function()
        while movementDisabled do
            if humanoidRootPart and humanoidRootPart.Parent then
                -- Allow only downward velocity (gravity)
                local velocity = humanoidRootPart.Velocity
                local newVelocity = Vector3.new(0, velocity.Y, 0) -- Keep Y velocity for gravity
                
                -- Only update if there's unwanted horizontal movement
                if math.abs(velocity.X) > 0.1 or math.abs(velocity.Z) > 0.1 then
                    humanoidRootPart.Velocity = newVelocity
                end
                
                -- Remove any angular velocity (spinning)
                if humanoidRootPart.AngularVelocity.Magnitude > 0.1 then
                    humanoidRootPart.AngularVelocity = Vector3.new(0, 0, 0)
                end
                
                -- Disable assembly velocities as well
                humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, humanoidRootPart.AssemblyLinearVelocity.Y, 0)
                humanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            else
                break
            end
            
            task.wait(0.03) -- Update frequently to maintain control
        end
    end)
    
    -- Block user input
    originalConnections.inputConnection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        
        -- Block movement keys
        local blockedKeys = {
            Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D,
            Enum.KeyCode.Space, Enum.KeyCode.LeftShift, Enum.KeyCode.LeftControl,
            Enum.KeyCode.Up, Enum.KeyCode.Down, Enum.KeyCode.Left, Enum.KeyCode.Right
        }
        
        for _, key in ipairs(blockedKeys) do
            if input.KeyCode == key then
                -- Consume the input to prevent movement
                return
            end
        end
    end)
    
    -- Block touch/mobile movement
    if UserInputService.TouchEnabled then
        originalConnections.touchConnection = UserInputService.TouchStarted:Connect(function(touch, gameProcessed)
            if gameProcessed then return end
            -- Block touch movement on mobile
        end)
    end
    
    print("🔒 MOVEMENT DISABLED - Only gravity allowed!")
end

-- Function to restore player movement
local function enableMovement()
    if not movementDisabled then return end
    
    local character = player.Character
    if not character then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    
    if humanoid and originalConnections.walkSpeed then
        -- Restore original values
        humanoid.WalkSpeed = originalConnections.walkSpeed
        humanoid.JumpPower = originalConnections.jumpPower
        humanoid.JumpHeight = originalConnections.jumpHeight
        humanoid.PlatformStand = originalConnections.platformStand
    end
    
    -- Disconnect input blocking connections
    if originalConnections.inputConnection then
        originalConnections.inputConnection:Disconnect()
        originalConnections.inputConnection = nil
    end
    
    if originalConnections.touchConnection then
        originalConnections.touchConnection:Disconnect()
        originalConnections.touchConnection = nil
    end
    
    movementDisabled = false
    originalConnections = {}
    
    print("🔓 MOVEMENT RESTORED - Player can move freely!")
end

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
                        
                        print("🎯 AUTO LOCK ACTIVATED - Teleporting to lock button...")
                        
                        -- Wait 1 second as requested
                        task.wait(0.8)
                        
                        -- DISABLE MOVEMENT BEFORE TELEPORT
                        disableMovement()
                        
                        -- Teleport to LockButton
                        humanoidRootPart.CFrame = lockButton.CFrame + Vector3.new(0, 6, 0) -- Slightly above the button
                        
                        -- Restore camera immediately after teleport
                        restoreCamera(cameraData)
                        
                        print("🔒 PLAYER LOCKED AT POSITION - Only gravity movement allowed!")
                        
                        -- Wait at the lock button for 0.4 seconds with X,Z movement locked
                        local lockStart = tick()
                        while tick() - lockStart < 0.4 do
                            if humanoidRootPart then
                                humanoidRootPart.Velocity = Vector3.new(0, humanoidRootPart.Velocity.Y, 0)
                                humanoidRootPart.AssemblyLinearVelocity = Vector3.new(0, humanoidRootPart.AssemblyLinearVelocity.Y, 0)
                            end
                            task.wait()
                        end
                        
                        -- Teleport back to original position
                        humanoidRootPart.CFrame = originalPosition
                        
                        -- Restore camera again to ensure it stays in place
                        restoreCamera(cameraData)
                        
                        -- RESTORE MOVEMENT AFTER TELEPORT BACK
                        enableMovement()
                        
                        print("✅ AUTO LOCK COMPLETE - Movement restored!")
                    end
                    
                    isAutoLocking = false
                end
            end)
            
            task.wait(1) -- Check every 1 second
        end
    end)
end

-- Handle character respawn (restore movement if disabled)
player.CharacterAdded:Connect(function()
    if movementDisabled then
        -- Reset movement state on respawn
        movementDisabled = false
        originalConnections = {}
    end
end)

-- Emergency movement restore (in case something goes wrong)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    -- Press "R" key to force restore movement (emergency override)
    if input.KeyCode == Enum.KeyCode.R and movementDisabled then
        print("🆘 EMERGENCY MOVEMENT RESTORE ACTIVATED!")
        enableMovement()
    end
end)

-- Start the auto lock system
autoLockSystem()

-- ========================================
-- ENHANCED ANTI-CHEAT NOCLIP WITH RUNNING ANIMATION
-- ========================================
local ANTI_CHEAT_THRESHOLD = 10 -- If moved more than 10 studs instantly, it's anti-cheat
local RAY_LENGTH = 100

local character, humanoid, hrp
local lastValidPosition -- Last position before anti-cheat snapback
local currentPosition
local positionHistory = {} -- Store last 5 positions for better detection
local historySize = 10

-- Track legitimate teleports
local legitimateTeleport = false
local teleportCooldown = 0

-- Animation variables
local runningAnimation = nil
local animationTrack = nil
local isAnimating = false

-- Function to trigger running animation
local function triggerRunningAnimation()
    if not humanoid or isAnimating then return end
    
    task.spawn(function()
        isAnimating = true
        
        -- Try to load and play running animation
        pcall(function()
            -- Create running animation if it doesn't exist
            if not runningAnimation then
                runningAnimation = Instance.new("Animation")
                runningAnimation.AnimationId = "rbxassetid://180426354" -- Running animation ID
            end
            
            -- Stop any existing animation track
            if animationTrack then
                animationTrack:Stop()
            end
            
            -- Load and play the animation
            animationTrack = humanoid:LoadAnimation(runningAnimation)
            if animationTrack then
                animationTrack:Play()
                animationTrack.Looped = false
                
                -- Stop animation after 0.5 seconds
                task.wait(0.5)
                if animationTrack then
                    animationTrack:Stop()
                end
            end
        end)
        
        -- Alternative method: Manually trigger running state
        if humanoid then
            pcall(function()
                -- Force humanoid into running state briefly
                local originalWalkSpeed = humanoid.WalkSpeed
                humanoid.WalkSpeed = 16
                humanoid:ChangeState(Enum.HumanoidStateType.Running)
                
                -- Reset after short duration
                task.wait(0.3)
                humanoid.WalkSpeed = originalWalkSpeed
                humanoid:ChangeState(Enum.HumanoidStateType.Physics)
            end)
        end
        
        isAnimating = false
    end)
end

-- Ultra-fast teleport function (faster than light speed)
local function ultraFastTeleport(targetPosition)
    if not hrp then return end
    
    task.spawn(function()
        -- Disable all physics temporarily for instant teleport
        local originalCanCollide = {}
        
        -- Store original collision states and disable them
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                originalCanCollide[part] = part.CanCollide
                part.CanCollide = false
            end
        end
        
        -- Instant teleport (faster than any anti-cheat can detect)
        hrp.CFrame = CFrame.new(targetPosition, targetPosition + hrp.CFrame.LookVector)
        hrp.Velocity = Vector3.new(0, 0, 0) -- Remove any velocity
        hrp.AngularVelocity = Vector3.new(0, 0, 0) -- Remove any rotation
        
        -- Force position update immediately
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        
        -- Trigger running animation to mask the teleport
        triggerRunningAnimation()
        
        print("⚡ LIGHTNING TELEPORT EXECUTED - Anti-cheat bypassed! ⚡")
    end)
end

-- Function to apply noclip to character
local function applyNoclip(char)
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
    
    -- Handle new parts added to character
    char.DescendantAdded:Connect(function(v)
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end)
end

-- Check if position is near any LockButton
local function isNearLockButton(position)
    local workspace = game:GetService("Workspace")
    local basesFolder = workspace:FindFirstChild("Bases")
    if not basesFolder then return false end
    
    -- Check all bases 1-8
    for i = 1, 8 do
        local base = basesFolder:FindFirstChild(tostring(i))
        if base then
            local lockButton = base:FindFirstChild("LockButton")
            if lockButton then
                local distance = (position - lockButton.Position).Magnitude
                if distance < 15 then -- Within 15 studs of any lock button
                    return true
                end
            end
        end
    end
    return false
end

-- Refresh character references
local function refreshCharacter()
    character = player.Character or player.CharacterAdded:Wait()
    humanoid = character:WaitForChild("Humanoid")
    hrp = character:WaitForChild("HumanoidRootPart")
    
    -- Reset animation variables
    runningAnimation = nil
    animationTrack = nil
    isAnimating = false
    
    applyNoclip(character)
    
    -- Reset position tracking
    lastValidPosition = hrp.Position
    currentPosition = hrp.Position
    positionHistory = {}
    
    -- Fill initial position history
    for i = 1, historySize do
        positionHistory[i] = hrp.Position
    end
end

-- Update position history
local function updatePositionHistory(newPos)
    table.insert(positionHistory, 1, newPos)
    if #positionHistory > historySize then
        table.remove(positionHistory, historySize + 1)
    end
end

-- Detect if movement was caused by anti-cheat
local function detectAntiCheatSnapback(newPos, oldPos)
    -- Decrease teleport cooldown
    if teleportCooldown > 0 then
        teleportCooldown = teleportCooldown - 1
    end
    
    local distance = (newPos - oldPos).Magnitude
    
    -- If moved more than threshold instantly
    if distance > ANTI_CHEAT_THRESHOLD then
        -- Check if this is a legitimate teleport (near LockButton)
        if isNearLockButton(newPos) or isNearLockButton(oldPos) then
            legitimateTeleport = true
            teleportCooldown = 30 -- 30 frames cooldown (~0.5 seconds at 60fps)
            return false
        end
        
        -- If we're in teleport cooldown, ignore anti-cheat detection
        if teleportCooldown > 0 then
            return false
        end
        
        return true
    end
    
    -- Check if position jumped to a significantly different location
    -- compared to recent movement pattern
    if #positionHistory >= 3 and teleportCooldown <= 0 then
        local avgRecentPos = Vector3.new(0, 0, 0)
        for i = 1, 3 do
            avgRecentPos = avgRecentPos + positionHistory[i]
        end
        avgRecentPos = avgRecentPos / 3
        
        local distanceFromAverage = (newPos - avgRecentPos).Magnitude
        if distanceFromAverage > ANTI_CHEAT_THRESHOLD then
            -- Check if this teleport is near a LockButton
            if isNearLockButton(newPos) then
                return false
            end
            return true
        end
    end
    
    return false
end

-- Floor raycast check to prevent falling through ground
local function checkFloor()
    if not hrp then return end
    
    local rayOrigin = hrp.Position
    local rayDirection = Vector3.new(0, -RAY_LENGTH, 0)
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local result = workspace:Raycast(rayOrigin, rayDirection, rayParams)
    if result then
        local floorY = result.Position.Y
        -- If player is below floor, move them up
        if hrp.Position.Y < floorY + 3 then
            local correctedPos = Vector3.new(hrp.Position.X, floorY + 3, hrp.Position.Z)
            ultraFastTeleport(correctedPos)
            lastValidPosition = correctedPos
        end
    end
end

-- Initialize character on script start
refreshCharacter()

-- Handle character respawn
player.CharacterAdded:Connect(function()
    refreshCharacter()
end)

-- Main monitoring loop
RunService.Heartbeat:Connect(function()
    if not hrp or not character then return end
    
    -- Continuously apply noclip
    for _, v in ipairs(character:GetDescendants()) do
        if v:IsA("BasePart") and v.CanCollide then
            v.CanCollide = false
        end
    end
    
    -- Get current position
    currentPosition = hrp.Position
    
    -- Check for anti-cheat snapback
    if detectAntiCheatSnapback(currentPosition, lastValidPosition) then
        -- Anti-cheat detected - execute ultra-fast teleport with running animation
        print("🚨 ANTI-CHEAT DETECTED - EXECUTING LIGHTNING COUNTER-TELEPORT! 🚨")
        ultraFastTeleport(lastValidPosition)
        
        -- Additional visual effect
        task.spawn(function()
            -- Create lightning effect around player
            if hrp then
                local lightningEffect = Instance.new("Explosion")
                lightningEffect.Parent = workspace
                lightningEffect.Position = hrp.Position
                lightningEffect.BlastRadius = 0
                lightningEffect.BlastPressure = 0
                lightningEffect.Visible = false -- Invisible explosion for effect
                
                -- Visual spark effect
                for i = 1, 5 do
                    local spark = Instance.new("Part")
                    spark.Name = "LightningSpark"
                    spark.Size = Vector3.new(0.1, 0.1, 0.1)
                    spark.Material = Enum.Material.Neon
                    spark.BrickColor = BrickColor.new("Electric blue")
                    spark.CanCollide = false
                    spark.Anchored = true
                    spark.Parent = workspace
                    spark.CFrame = hrp.CFrame + Vector3.new(math.random(-2, 2), math.random(-2, 2), math.random(-2, 2))
                    
                    -- Remove spark after brief moment
                    task.wait(0.05)
                    spark:Destroy()
                end
            end
        end)
        
    else
        -- Normal movement - update valid position and history
        lastValidPosition = currentPosition
        updatePositionHistory(currentPosition)
    end
    
    -- Floor check to prevent falling
    checkFloor()
end)

-- ========================================
-- CHARACTERS NOCLIP SYSTEM (IMPROVED)
-- ========================================
local charactersFolder = ReplicatedStorage:FindFirstChild("Characters")
local processedCharacters = {} -- Track which characters we've already processed

-- Function to apply comprehensive noclip to a character model
local function applyNoclipToCharacter(characterModel)
    if not characterModel then return end
    
    local characterId = tostring(characterModel)
    if processedCharacters[characterId] then return end
    
    processedCharacters[characterId] = true
    
    -- Function to make a part noclip
    local function makePartNoclip(part)
        if part:IsA("BasePart") then
            part.CanCollide = false
            part.CanTouch = false -- Prevent touch events too
            
            -- Remove any collision-related constraints
            for _, constraint in ipairs(part:GetChildren()) do
                if constraint:IsA("Attachment") then
                    for _, connectedConstraint in ipairs(constraint:GetChildren()) do
                        if connectedConstraint:IsA("Constraint") then
                            connectedConstraint.Enabled = false
                        end
                    end
                end
            end
        end
    end
    
    -- Apply noclip to all current parts
    for _, descendant in ipairs(characterModel:GetDescendants()) do
        makePartNoclip(descendant)
    end
    
    -- Handle new parts added to character
    local addedConnection = characterModel.DescendantAdded:Connect(function(newDescendant)
        makePartNoclip(newDescendant)
    end)
    
    -- Continuous noclip enforcement
    local heartbeatConnection = RunService.Heartbeat:Connect(function()
        if characterModel.Parent then
            for _, descendant in ipairs(characterModel:GetDescendants()) do
                if descendant:IsA("BasePart") then
                    if descendant.CanCollide then
                        descendant.CanCollide = false
                    end
                    if descendant.CanTouch then
                        descendant.CanTouch = false
                    end
                end
            end
        end
    end)
    
    -- Clean up when character is removed
    characterModel.AncestryChanged:Connect(function()
        if not characterModel.Parent then
            processedCharacters[characterId] = nil
            if addedConnection then addedConnection:Disconnect() end
            if heartbeatConnection then heartbeatConnection:Disconnect() end
        end
    end)
    
    print("Applied comprehensive noclip to character:", characterModel.Name)
end

-- Function to monitor and apply noclip to all characters
local function initializeCharacterNoclip()
    if not charactersFolder then
        warn("Characters folder not found in ReplicatedStorage")
        
        -- Try to wait for the folder to appear
        local connection
        connection = ReplicatedStorage.ChildAdded:Connect(function(child)
            if child.Name == "Characters" then
                charactersFolder = child
                connection:Disconnect()
                initializeCharacterNoclip() -- Restart initialization
            end
        end)
        
        return
    end
    
    -- Apply noclip to existing characters
    for _, character in ipairs(charactersFolder:GetChildren()) do
        if character:IsA("Model") or character:IsA("Folder") then
            task.spawn(function()
                applyNoclipToCharacter(character)
            end)
        end
    end
    
    -- Monitor for new characters
    charactersFolder.ChildAdded:Connect(function(newCharacter)
        if newCharacter:IsA("Model") or newCharacter:IsA("Folder") then
            task.wait(0.1) -- Wait for character to fully load
            applyNoclipToCharacter(newCharacter)
        end
    end)
    
    print("Character noclip system initialized and monitoring", charactersFolder:GetFullName())
end

-- Initialize the system
task.spawn(function()
    initializeCharacterNoclip()
end)

-- ========================================
-- PLAYER ANTI-RAGDOLL SYSTEM (ENHANCED)
-- ========================================
local antiRagdollEnabled = true
local originalJointData = {}
local connections = {}

-- Function to store original joint data
local function storeJointData(character)
    originalJointData = {}
    
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("Motor6D") then
            originalJointData[descendant.Name] = {
                C0 = descendant.C0,
                C1 = descendant.C1,
                Parent = descendant.Parent,
                Part0 = descendant.Part0,
                Part1 = descendant.Part1,
                Transform = descendant.Transform,
                MaxVelocity = descendant.MaxVelocity,
                DesiredAngle = descendant.DesiredAngle
            }
        end
    end
    
    print("Stored joint data for", #originalJointData, "joints")
end

-- Function to restore and maintain joints
local function maintainJoints(character)
    if not antiRagdollEnabled then return end
    
    for _, descendant in ipairs(character:GetDescendants()) do
        if descendant:IsA("Motor6D") then
            local originalData = originalJointData[descendant.Name]
            if originalData then
                -- Ensure joint properties are maintained
                descendant.C0 = originalData.C0
                descendant.C1 = originalData.C1
                descendant.MaxVelocity = originalData.MaxVelocity
                descendant.DesiredAngle = originalData.DesiredAngle
                
                -- Ensure joint is enabled and functioning
                if not descendant.Enabled then
                    descendant.Enabled = true
                end
            end
        end
    end
    
    -- Check for missing joints and recreate them
    for jointName, data in pairs(originalJointData) do
        local existingJoint = character:FindFirstChild(jointName, true)
        if not existingJoint or not existingJoint.Parent then
            -- Recreate the joint
            local newJoint = Instance.new("Motor6D")
            newJoint.Name = jointName
            newJoint.C0 = data.C0
            newJoint.C1 = data.C1
            newJoint.Part0 = data.Part0
            newJoint.Part1 = data.Part1
            newJoint.MaxVelocity = data.MaxVelocity
            newJoint.DesiredAngle = data.DesiredAngle
            newJoint.Parent = data.Parent
            
            print("Recreated joint:", jointName)
        end
    end
end

-- Function to prevent physics-based ragdolling
local function preventPhysicsRagdoll(character)
    if not antiRagdollEnabled then return end
    
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoid and rootPart then
        -- Lock the root part position to prevent unwanted movement
        local bodyPosition = rootPart:FindFirstChild("AntiRagdollBodyPosition")
        if not bodyPosition then
            bodyPosition = Instance.new("BodyPosition")
            bodyPosition.Name = "AntiRagdollBodyPosition"
            bodyPosition.MaxForce = Vector3.new(0, 0, 0) -- Disabled by default
            bodyPosition.Parent = rootPart
        end
        
        local bodyAngularVelocity = rootPart:FindFirstChild("AntiRagdollBodyAngularVelocity")
        if not bodyAngularVelocity then
            bodyAngularVelocity = Instance.new("BodyAngularVelocity")
            bodyAngularVelocity.Name = "AntiRagdollBodyAngularVelocity"
            bodyAngularVelocity.MaxTorque = Vector3.new(0, 0, 0) -- Disabled by default
            bodyAngularVelocity.AngularVelocity = Vector3.new(0, 0, 0)
            bodyAngularVelocity.Parent = rootPart
        end
        
        -- Prevent humanoid state changes that cause ragdolling
        local stateConnection = humanoid.StateChanged:Connect(function(oldState, newState)
            if newState == Enum.HumanoidStateType.Physics or 
               newState == Enum.HumanoidStateType.FallingDown or
               newState == Enum.HumanoidStateType.Ragdoll then
                
                -- Temporarily enable body position to lock player in place
                bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
                bodyPosition.Position = rootPart.Position
                bodyAngularVelocity.MaxTorque = Vector3.new(4000, 4000, 4000)
                
                task.wait(0.1)
                
                if humanoid.Parent and antiRagdollEnabled then
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    
                    -- Disable body position after recovering
                    task.wait(0.1)
                    bodyPosition.MaxForce = Vector3.new(0, 0, 0)
                    bodyAngularVelocity.MaxTorque = Vector3.new(0, 0, 0)
                end
            end
        end)
        
        -- Monitor for RequiresNeck changes
        local neckConnection = humanoid:GetPropertyChangedSignal("RequiresNeck"):Connect(function()
            if antiRagdollEnabled then
                humanoid.RequiresNeck = true
            end
        end)
        
        humanoid.RequiresNeck = true
        
        -- Store connections for cleanup
        table.insert(connections, stateConnection)
        table.insert(connections, neckConnection)
    end
    
    -- Monitor all body parts for excessive physics
    for _, part in ipairs(character:GetChildren()) do
        if part:IsA("BasePart") and part ~= rootPart then
            local velocityConnection = RunService.Heartbeat:Connect(function()
                if antiRagdollEnabled and part.Parent then
                    -- Reset excessive velocities
                    if part.AssemblyLinearVelocity.Magnitude > 50 then
                        part.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                    end
                    if part.AssemblyAngularVelocity.Magnitude > 50 then
                        part.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                    end
                end
            end)
            
            table.insert(connections, velocityConnection)
        end
    end
end

-- Function to setup anti-ragdoll for a character
local function setupAntiRagdoll(character)
    -- Clear previous connections
    for _, connection in ipairs(connections) do
        if connection then
            connection:Disconnect()
        end
    end
    connections = {}
    
    -- Wait for character to fully load
    local humanoid = character:WaitForChild("Humanoid", 10)
    local rootPart = character:WaitForChild("HumanoidRootPart", 10)
    
    if not humanoid or not rootPart then
        warn("Failed to load character properly for anti-ragdoll")
        return
    end
    
    -- Wait a bit more for joints to load
    task.wait(1)
    
    -- Store joint data
    storeJointData(character)
    
    -- Setup anti-ragdoll measures
    preventPhysicsRagdoll(character)
    
    -- Continuous joint monitoring and restoration
    local heartbeatConnection = RunService.Heartbeat:Connect(function()
        if character.Parent and antiRagdollEnabled then
            maintainJoints(character)
        end
    end)
    
    table.insert(connections, heartbeatConnection)
    
    -- Handle character removal
    local ancestryConnection = character.AncestryChanged:Connect(function()
        if not character.Parent then
            -- Clean up connections
            for _, connection in ipairs(connections) do
                if connection then
                    connection:Disconnect()
                end
            end
            connections = {}
        end
    end)
    
    table.insert(connections, ancestryConnection)
    
    print("Enhanced anti-ragdoll enabled for player:", player.Name)
end

-- Initialize anti-ragdoll system
local function initializeAntiRagdoll()
    -- Handle current character
    if player.Character then
        task.spawn(function()
            setupAntiRagdoll(player.Character)
        end)
    end
    
    -- Handle future characters (respawn)
    player.CharacterAdded:Connect(function(character)
        task.spawn(function()
            setupAntiRagdoll(character)
        end)
    end)
end

-- Start anti-ragdoll system
initializeAntiRagdoll()

-- Function to toggle anti-ragdoll
local function toggleAntiRagdoll()
    antiRagdollEnabled = not antiRagdollEnabled
    print("Enhanced anti-ragdoll", antiRagdollEnabled and "enabled" or "disabled")
    
    if not antiRagdollEnabled then
        -- Remove body movers when disabled
        if player.Character then
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            if rootPart then
                local bodyPos = rootPart:FindFirstChild("AntiRagdollBodyPosition")
                local bodyAngVel = rootPart:FindFirstChild("AntiRagdollBodyAngularVelocity")
                if bodyPos then bodyPos.MaxForce = Vector3.new(0, 0, 0) end
                if bodyAngVel then bodyAngVel.MaxTorque = Vector3.new(0, 0, 0) end
            end
        end
    end
end

-- Export toggle function
_G.toggleAntiRagdoll = toggleAntiRagdoll

-- ========================================
-- ULTIMATE ANTI-KICK PROTECTION SYSTEM
-- ========================================
-- Store original functions before hooking
local originalKick = nil
local originalDisconnect = nil
local originalDestroy = nil
local originalRemove = nil

-- Hook Player:Kick() function
if player.Kick then
    originalKick = hookfunction(player.Kick, function(...)
        print("🛡️ KICK ATTEMPT BLOCKED - Player:Kick() intercepted!")
        return nil -- Block the kick
    end)
end

-- Hook connection disconnect methods
local mt = getrawmetatable(game)
local originalNamecall = mt.__namecall
local originalIndex = mt.__index
local originalNewindex = mt.__newindex

-- Protect metatable
setreadonly(mt, false)

-- Hook __namecall to intercept method calls
mt.__namecall = function(self, ...)
    local method = getnamecallmethod()
    local args = {...}
    
    -- Block kick-related methods
    if method == "Kick" and self == player then
        print("🛡️ KICK ATTEMPT BLOCKED - __namecall Kick() intercepted!")
        return nil
    elseif method == "kick" and self == player then
        print("🛡️ KICK ATTEMPT BLOCKED - __namecall kick() intercepted!")
        return nil
    elseif method == "Destroy" and self == player then
        print("🛡️ DESTROY ATTEMPT BLOCKED - Player destruction prevented!")
        return nil
    elseif method == "Remove" and self == player then
        print("🛡️ REMOVE ATTEMPT BLOCKED - Player removal prevented!")
        return nil
    elseif method == "Disconnect" and tostring(self):find("PlayerRemoving") then
        print("🛡️ DISCONNECT ATTEMPT BLOCKED - PlayerRemoving event blocked!")
        return nil
    end
    
    return originalNamecall(self, ...)
end

-- Hook __index to prevent kick function access
mt.__index = function(self, key)
    if self == player then
        if key == "Kick" or key == "kick" then
            print("🛡️ KICK ACCESS BLOCKED - Kick function access denied!")
            return function() end -- Return dummy function
        elseif key == "Destroy" then
            print("🛡️ DESTROY ACCESS BLOCKED - Destroy function access denied!")
            return function() end
        elseif key == "Remove" then
            print("🛡️ REMOVE ACCESS BLOCKED - Remove function access denied!")
            return function() end
        end
    end
    
    return originalIndex(self, key)
end

-- Hook __newindex to prevent kick function assignment
mt.__newindex = function(self, key, value)
    if self == player and (key == "Kick" or key == "kick") then
        print("🛡️ KICK ASSIGNMENT BLOCKED - Cannot assign kick function!")
        return
    end
    
    return originalNewindex(self, key, value)
end

-- Restore metatable protection
setreadonly(mt, true)

-- Hook RemoteEvent/RemoteFunction firing that might cause kicks
local function hookRemotes()
    for _, v in pairs(game:GetDescendants()) do
        if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
            -- Hook FireServer calls
            if v.FireServer then
                local originalFire = v.FireServer
                v.FireServer = function(self, ...)
                    local args = {...}
                    local eventName = tostring(self)
                    
                    -- Check for kick-related remote calls
                    if eventName:lower():find("kick") or 
                       eventName:lower():find("ban") or 
                       eventName:lower():find("remove") then
                        print("🛡️ REMOTE KICK BLOCKED - " .. eventName .. " call intercepted!")
                        return nil
                    end
                    
                    -- Check arguments for kick indicators
                    for _, arg in pairs(args) do
                        if type(arg) == "string" then
                            local argLower = arg:lower()
                            if argLower:find("kick") or argLower:find("ban") or argLower:find("exploit") then
                                print("🛡️ SUSPICIOUS REMOTE BLOCKED - Potential kick argument detected!")
                                return nil
                            end
                        end
                    end
                    
                    return originalFire(self, ...)
                end
            end
        end
    end
end

-- Initial remote hook
hookRemotes()

-- Hook new remotes as they're added
game.DescendantAdded:Connect(function(v)
    if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
        task.wait(0.1) -- Small delay to ensure remote is fully loaded
        
        if v.FireServer then
            local originalFire = v.FireServer
            v.FireServer = function(self, ...)
                local args = {...}
                local eventName = tostring(self)
                
                if eventName:lower():find("kick") or 
                   eventName:lower():find("ban") or 
                   eventName:lower():find("remove") then
                    print("🛡️ NEW REMOTE KICK BLOCKED - " .. eventName .. " call intercepted!")
                    return nil
                end
                
                for _, arg in pairs(args) do
                    if type(arg) == "string" then
                        local argLower = arg:lower()
                        if argLower:find("kick") or argLower:find("ban") or argLower:find("exploit") then
                            print("🛡️ NEW SUSPICIOUS REMOTE BLOCKED - Potential kick argument detected!")
                            return nil
                        end
                    end
                end
                
                return originalFire(self, ...)
            end
        end
    end
end)

-- Hook PlayerRemoving event to prevent forced disconnection
local originalConnect = Players.PlayerRemoving.Connect
Players.PlayerRemoving.Connect = function(self, callback)
    print("🛡️ PLAYER REMOVING EVENT BLOCKED - Connection intercepted!")
    return {
        Connected = true,
        Disconnect = function() end
    } -- Return dummy connection
end

-- Block TeleportService kicks
local TeleportService = game:GetService("TeleportService")
if TeleportService then
    local originalTeleport = TeleportService.Teleport
    TeleportService.Teleport = function(...)
        print("🛡️ TELEPORT KICK BLOCKED - TeleportService call intercepted!")
        return nil
    end
    
    if TeleportService.TeleportToPlaceInstance then
        local originalTeleportToPlace = TeleportService.TeleportToPlaceInstance
        TeleportService.TeleportToPlaceInstance = function(...)
            print("🛡️ TELEPORT TO PLACE BLOCKED - Potential kick teleport intercepted!")
            return nil
        end
    end
end

-- Hook game shutdown methods
if game.Shutdown then
    local originalShutdown = game.Shutdown
    game.Shutdown = function(...)
        print("🛡️ GAME SHUTDOWN BLOCKED - Shutdown call intercepted!")
        return nil
    end
end

-- Monitor for suspicious script execution
local function monitorScripts()
    for _, script in pairs(game:GetDescendants()) do
        if script:IsA("LocalScript") and script ~= getgenv().currentScript then
            -- Monitor for kick-related code in other scripts
            local success, source = pcall(function()
                return script.Source
            end)
            
            if success and source then
                local sourceLower = source:lower()
                if sourceLower:find("kick") or sourceLower:find("player:remove") or sourceLower:find("disconnect") then
                    print("⚠️ SUSPICIOUS SCRIPT DETECTED - " .. script:GetFullName())
                    -- Optionally disable the script
                    pcall(function()
                        script.Disabled = true
                    end)
                end
            end
        end
    end
end

-- Run script monitoring
task.spawn(function()
    while true do
        pcall(monitorScripts)
        task.wait(5) -- Check every 5 seconds
    end
end)

-- Hook error handlers that might cause kicks
local originalError = error
getgenv().error = function(message, level)
    if type(message) == "string" then
        local msgLower = message:lower()
        if msgLower:find("kick") or msgLower:find("exploit") or msgLower:find("cheat") then
            print("🛡️ ERROR KICK BLOCKED - Suspicious error message intercepted!")
            print("Original message:", message)
            return nil
        end
    end
    return originalError(message, level)
end

-- Monitor character deletion/removal
player.CharacterRemoving:Connect(function(character)
    print("⚠️ CHARACTER REMOVAL DETECTED - Potential kick attempt!")
    
    -- Attempt to prevent character removal
    task.spawn(function()
        task.wait(0.1)
        if not player.Character then
            print("🔄 ATTEMPTING CHARACTER RESTORATION...")
            -- Try to spawn new character
            pcall(function()
                player:LoadCharacter()
            end)
        end
    end)
end)

-- Final protection layer - detect disconnection attempts
local heartbeatConnection
heartbeatConnection = game:GetService("RunService").Heartbeat:Connect(function()
    if not player.Parent then
        print("🚨 DISCONNECTION DETECTED - ATTEMPTING RECONNECTION...")
        
        -- Try to restore player to Players service
        pcall(function()
            player.Parent = Players
        end)
        
        -- If that fails, try to prevent the disconnection
        if not player.Parent then
            print("🛡️ CRITICAL PROTECTION ACTIVATED - PREVENTING DISCONNECTION!")
            -- Block the disconnection by maintaining script execution
        end
    end
end)

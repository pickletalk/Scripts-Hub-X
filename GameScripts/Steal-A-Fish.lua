-- ========================================
-- MODULES
-- ========================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local TweenService = game:GetService("TweenService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- ========================================
-- NEW AUTO LOCK SYSTEM FOR STEAL-A-FISH
-- ========================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer

local AutoLockSystem = {}
AutoLockSystem.playerTycoon = nil
AutoLockSystem.isLocking = false

function AutoLockSystem:FindPlayerTycoon()
    local username = localPlayer.Name
    
    for i = 1, 8 do
        local tycoonName = "Tycoon" .. i
        local tycoonPath = Workspace.Map.Tycoons:FindFirstChild(tycoonName)
        
        if tycoonPath then
            local tycoonFolder = tycoonPath:FindFirstChild("Tycoon")
            if tycoonFolder then
                local board = tycoonFolder:FindFirstChild("Board")
                if board then
                    local boardPart = board:FindFirstChild("Board")
                    if boardPart then
                        local surfaceGui = boardPart:FindFirstChild("SurfaceGui")
                        if surfaceGui then
                            local usernameLabel = surfaceGui:FindFirstChild("Username")
                            if usernameLabel and usernameLabel.Text == username then
                                self.playerTycoon = tycoonName
                                print("[AUTO LOCK] Found player tycoon:", tycoonName)
                                return tycoonName
                            end
                        end
                    end
                end
            end
        end
    end
    
    return nil
end

function AutoLockSystem:GetForceFieldTime(tycoonName)
    local tycoonPath = Workspace.Map.Tycoons:FindFirstChild(tycoonName)
    if not tycoonPath then return nil end
    
    local tycoonFolder = tycoonPath:FindFirstChild("Tycoon")
    if tycoonFolder then
        local forcefieldFolder = tycoonFolder:FindFirstChild("ForcefieldFolder")
        if forcefieldFolder then
            local screen = forcefieldFolder:FindFirstChild("Screen")
            if screen then
                local screenPart = screen:FindFirstChild("Screen")
                if screenPart then
                    local surfaceGui = screenPart:FindFirstChild("SurfaceGui")
                    if surfaceGui then
                        local timeLabel = surfaceGui:FindFirstChild("Time")
                        if timeLabel then
                            return timeLabel.Text
                        end
                    end
                end
            end
        end
    end
    
    return nil
end

function AutoLockSystem:TriggerLockButton()
    if not self.playerTycoon or self.isLocking then return end
    
    local tycoonPath = Workspace.Map.Tycoons:FindFirstChild(self.playerTycoon)
    if not tycoonPath then return end
    
    local tycoonFolder = tycoonPath:FindFirstChild("Tycoon")
    if tycoonFolder then
        local forcefieldFolder = tycoonFolder:FindFirstChild("ForcefieldFolder")
        if forcefieldFolder then
            local buttons = forcefieldFolder:FindFirstChild("Buttons")
            if buttons then
                local forceFieldBuy = buttons:FindFirstChild("ForceFieldBuy")
                if forceFieldBuy then
                    local lock = forceFieldBuy:FindFirstChild("Lock")
                    if lock then
                        local lockMeshPart = lock:FindFirstChild("Lock")
                        if lockMeshPart and lockMeshPart:IsA("MeshPart") then
                            self.isLocking = true
                            
                            print("[AUTO LOCK] Triggering lock button...")
                            
                            -- Try multiple methods to trigger the lock
                            local success = false
                            
                            -- Method 1: TouchInterest
                            local touchInterest = lockMeshPart:FindFirstChild("TouchInterest")
                            if touchInterest and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                local humanoidRootPart = localPlayer.Character.HumanoidRootPart
                                
                                for i = 1, 3 do
                                    firetouchinterest(lockMeshPart, humanoidRootPart, 0)
                                    wait(0.1)
                                    firetouchinterest(lockMeshPart, humanoidRootPart, 1)
                                    wait(0.1)
                                end
                                success = true
                                print("[AUTO LOCK] Used TouchInterest method")
                            end
                            
                            -- Method 2: ClickDetector
                            if not success then
                                local clickDetector = lockMeshPart:FindFirstChild("ClickDetector")
                                if clickDetector then
                                    for i = 1, 3 do
                                        fireclickdetector(clickDetector)
                                        wait(0.2)
                                    end
                                    success = true
                                    print("[AUTO LOCK] Used ClickDetector method")
                                end
                            end
                            
                            -- Method 3: ProximityPrompt
                            if not success then
                                local proximityPrompt = lockMeshPart:FindFirstChild("ProximityPrompt")
                                if proximityPrompt then
                                    for i = 1, 3 do
                                        fireproximityprompt(proximityPrompt)
                                        wait(0.2)
                                    end
                                    success = true
                                    print("[AUTO LOCK] Used ProximityPrompt method")
                                end
                            end
                            
                            if success then
                                print("[AUTO LOCK] Lock button triggered successfully!")
                            else
                                print("[AUTO LOCK] No valid trigger method found for lock button")
                            end
                            
                            wait(0.5) -- Cooldown
                            self.isLocking = false
                        else
                            print("[AUTO LOCK] Lock MeshPart not found or invalid type")
                        end
                    else
                        print("[AUTO LOCK] Lock folder not found")
                    end
                else
                    print("[AUTO LOCK] ForceFieldBuy not found")
                end
            else
                print("[AUTO LOCK] Buttons folder not found")
            end
        else
            print("[AUTO LOCK] ForcefieldFolder not found")
        end
    else
        print("[AUTO LOCK] Tycoon folder not found")
    end
end

-- Find player tycoon
spawn(function()
    while not AutoLockSystem.playerTycoon do
        AutoLockSystem:FindPlayerTycoon()
        if not AutoLockSystem.playerTycoon then
            wait(1)
        end
    end
end)

-- Main auto lock loop
spawn(function()
    while true do
        if AutoLockSystem.playerTycoon then
            local timeText = AutoLockSystem:GetForceFieldTime(AutoLockSystem.playerTycoon)
            if timeText == "0s" then
                wait(0.4)
                AutoLockSystem:TriggerLockButton()
            end
        end
        wait(0.1)
    end
end)

-- ========================================
-- FISH TELEPORTER UI (BASED ON FREDDY UI)
-- ========================================
local playerGui = localPlayer:WaitForChild("PlayerGui")

-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FishTeleporterUI"
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
titleText.Text = "🐟 FISH HEIST 🐟"
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
teleportButton.Text = "🐟 STEAL 🐟"
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

-- Fish stealing function using the existing FindPlayerTycoon system
local function stealFish()
    local running = false
    local root

    local function setError(partName)
        running = false
        teleportButton.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
        teleportButton.Text = ("🐟 ERROR ON %s 🐟"):format(partName)
        task.wait(1.5)
        teleportButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        teleportButton.Text = "🐟 STEAL 🐟"
    end

    local ok, err = pcall(function()
        teleportButton.Text = "🐟 STEALING CUH!... 🐟"

        root = localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart")
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

        -- Find player tycoon using the existing system
        if not AutoLockSystem.playerTycoon then
            return setError("PlayerTycoon")
        end

        local tycoonPath = Workspace.Map.Tycoons:FindFirstChild(AutoLockSystem.playerTycoon)
        if not tycoonPath then return setError("TycoonPath") end

        local tycoonFolder = tycoonPath:FindFirstChild("Tycoon")
        if not tycoonFolder then return setError("TycoonFolder") end

        local collectZone = tycoonFolder:FindFirstChild("CollectZone")
        if not collectZone then return setError("CollectZone") end

        local collectPart = collectZone:FindFirstChild("CollectPart")
        if not collectPart then return setError("CollectPart") end

        local touchInterest = collectPart:FindFirstChild("TouchInterest")
        if not touchInterest then return setError("TouchInterest") end

        -- Fire the TouchInterest
        firetouchinterest(collectPart, root, 0)
        task.wait(0.1)
        firetouchinterest(collectPart, root, 1)

        teleportButton.Text = "🐟 FISH STEALED! 🐟"

        running = false

        -- Flash animation
        local blue = Color3.fromRGB(70, 130, 180)
        local black = Color3.fromRGB(0, 0, 0)
        for i = 1, 3 do
            teleportButton.BackgroundColor3 = blue
            task.wait(0.15)
            teleportButton.BackgroundColor3 = black
            task.wait(0.15)
        end

        teleportButton.BackgroundColor3 = black
        teleportButton.Text = "🐟 FISH 🐟"
    end)

    if not ok then
        running = false
        teleportButton.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
        teleportButton.Text = "🐟 ERROR ON INTERNAL 🐟"
        task.wait(1.5)
        teleportButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        teleportButton.Text = "🐟 STEAL 🐟"
    end
end

-- Button connections
teleportButton.MouseButton1Click:Connect(stealFish)
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
-- FAST INTERACTION SYSTEM
-- ========================================

-- Set all existing ProximityPrompts to instant
local function SetupFastInteraction()
    for _, prompt in pairs(Workspace:GetDescendants()) do
        if prompt:IsA("ProximityPrompt") then
            prompt.HoldDuration = 0
            prompt.KeyboardKeyCode = Enum.KeyCode.E
        end
    end
end

-- Monitor new ProximityPrompts
local function MonitorNewPrompts()
    Workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("ProximityPrompt") then
            descendant.HoldDuration = 0
            descendant.KeyboardKeyCode = Enum.KeyCode.E
        end
    end)
end

-- ========================================
-- ENHANCED ANTI-CHEAT NOCLIP FOR STEAL-A-FISH
-- ========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local localPlayer = Players.LocalPlayer
local ANTI_CHEAT_THRESHOLD = 8 -- If moved more than 8 studs instantly, it's anti-cheat
local RAY_LENGTH = 100

local character, humanoid, hrp
local lastValidPosition -- Last position before anti-cheat snapback
local currentPosition
local positionHistory = {} -- Store last 5 positions for better detection
local historySize = 5

-- Track legitimate teleports
local legitimateTeleport = false
local teleportCooldown = 0

-- Animation variables
local runningAnimation = nil
local animationTrack = nil
local isAnimating = false

-- Auto Lock System reference for finding player tycoon
local AutoLockSystem = {}
AutoLockSystem.playerTycoon = nil

function AutoLockSystem:FindPlayerTycoon()
    local username = localPlayer.Name
    
    for i = 1, 8 do
        local tycoonName = "Tycoon" .. i
        local tycoonPath = Workspace.Map.Tycoons:FindFirstChild(tycoonName)
        
        if tycoonPath then
            local tycoonFolder = tycoonPath:FindFirstChild("Tycoon")
            if tycoonFolder then
                local board = tycoonFolder:FindFirstChild("Board")
                if board then
                    local boardPart = board:FindFirstChild("Board")
                    if boardPart then
                        local surfaceGui = boardPart:FindFirstChild("SurfaceGui")
                        if surfaceGui then
                            local usernameLabel = surfaceGui:FindFirstChild("Username")
                            if usernameLabel and usernameLabel.Text == username then
                                self.playerTycoon = tycoonName
                                return tycoonName
                            end
                        end
                    end
                end
            end
        end
    end
    
    return nil
end

-- Find player tycoon
spawn(function()
    while not AutoLockSystem.playerTycoon do
        AutoLockSystem:FindPlayerTycoon()
        if not AutoLockSystem.playerTycoon then
            wait(1)
        end
    end
end)

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

-- Check if position is near forcefield button (where auto lock teleports)
local function isNearForcefieldButton(position)
    if not AutoLockSystem.playerTycoon then return false end
    
    local tycoonPath = Workspace.Map.Tycoons:FindFirstChild(AutoLockSystem.playerTycoon)
    if not tycoonPath then return false end
    
    local tycoonFolder = tycoonPath:FindFirstChild("Tycoon")
    if tycoonFolder then
        local forcefieldFolder = tycoonFolder:FindFirstChild("ForcefieldFolder")
        if forcefieldFolder then
            local buttons = forcefieldFolder:FindFirstChild("Buttons")
            if buttons then
                local forceFieldBuy = buttons:FindFirstChild("ForceFieldBuy")
                if forceFieldBuy then
                    local forcefield = forceFieldBuy:FindFirstChild("Forcefield")
                    if forcefield then
                        local distance = (position - forcefield.Position).Magnitude
                        if distance < 15 then -- Within 15 studs of forcefield button
                            return true
                        end
                    end
                end
            end
        end
    end
    
    return false
end

-- Refresh character references
local function refreshCharacter()
    character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
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
        -- Check if this is a legitimate teleport (near forcefield button where auto lock teleports)
        if isNearForcefieldButton(newPos) or isNearForcefieldButton(oldPos) then
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
            -- Check if this teleport is near forcefield button
            if isNearForcefieldButton(newPos) then
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
localPlayer.CharacterAdded:Connect(function()
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

-- ========================================
-- MODULES
-- ========================================
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local ProximityPromptService = game:GetService("ProximityPromptService")

local localPlayer = Players.LocalPlayer
local playerGui = localPlayer:WaitForChild("PlayerGui")
local character = localPlayer.Character or localPlayer.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

-- ========================================
-- AUTO LOCK SYSTEM
-- ========================================

local AutoLockSystem = {}
AutoLockSystem.playerTycoon = nil
AutoLockSystem.oldPosition = nil
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

function AutoLockSystem:TeleportToForcefield()
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
                    local forcefield = forceFieldBuy:FindFirstChild("Forcefield")
                    if forcefield and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        self.isLocking = true
                        self.oldPosition = localPlayer.Character.HumanoidRootPart.CFrame
                        
                        print("[AUTO LOCK] Teleporting to forcefield button...")
                        -- Teleport 6 studs above the target
                        local targetCFrame = forcefield.CFrame + Vector3.new(0, 4, 0)
                        localPlayer.Character.HumanoidRootPart.CFrame = targetCFrame
                        
                        wait(0.4)
                        
                        if self.oldPosition and localPlayer.Character and localPlayer.Character:FindFirstChild("HumanoidRootPart") then
                            print("[AUTO LOCK] Teleporting back to original position...")
                            localPlayer.Character.HumanoidRootPart.CFrame = self.oldPosition
                        end
                        
                        self.isLocking = false
                    end
                end
            end
        end
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
                wait(0.25)
                AutoLockSystem:TeleportToForcefield()
            end
        end
        wait(0.1)
    end
end)

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
-- ENHANCED ANTI-CHEAT NOCLIP WITH RUNNING ANIMATION
-- ========================================
local ANTI_CHEAT_THRESHOLD = 8 -- If moved more than 10 studs instantly, it's anti-cheat
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

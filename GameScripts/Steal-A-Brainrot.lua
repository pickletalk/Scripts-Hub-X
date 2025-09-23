local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local StarterPlayer = game:GetService("StarterPlayer")
local CoreGui = game:GetService("CoreGui")
local GuiService = game:GetService("GuiService")
local TeleportService = game:GetService("TeleportService")

local player = Players.LocalPlayer
local LocalPlayer = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- Bypassed
local grappleHookConnection = nil

-- Anti Kick
local antiKickEnabled = true
local kickMethods = {
    -- === STANDARD PLAYER KICK METHODS ===
    "kick", "Kick", "KICK", "KickPlayer", "kickplayer", "kick_player", "kickClient", "KickClient",
    "PlayerKick", "player_kick", "PLAYER_KICK", "kickUser", "KickUser", "kick_user",
    "clientKick", "ClientKick", "CLIENT_KICK", "userKick", "UserKick", "USER_KICK",

    -- === REMOVE/DISCONNECT METHODS ===
    "remove", "Remove", "REMOVE", "RemovePlayer", "removeplayer", "remove_player",
    "disconnect", "Disconnect", "DISCONNECT", "DisconnectPlayer", "disconnectplayer",
    "disconnect_player", "PlayerDisconnect", "player_disconnect", "PLAYER_DISCONNECT",
    "RemoveClient", "removeclient", "remove_client", "REMOVE_CLIENT",
    "clientDisconnect", "ClientDisconnect", "CLIENT_DISCONNECT", "userRemove", "UserRemove",
    "destroy", "Destroy", "DESTROY", "DestroyPlayer", "destroyplayer", "destroy_player",
    "delete", "Delete", "DELETE", "DeletePlayer", "deleteplayer", "delete_player",
    
    -- === TELEPORT/SERVER HOP METHODS ===
    "teleport", "Teleport", "TELEPORT", "TeleportPlayer", "teleportplayer", "teleport_player",
    "TeleportClient", "teleportclient", "teleport_client", "TELEPORT_CLIENT",
    "ServerHop", "serverhop", "server_hop", "SERVER_HOP", "rejoin", "Rejoin", "REJOIN",
    "ReconnectPlayer", "reconnectplayer", "reconnect_player", "RECONNECT_PLAYER",
    "TeleportToSpawnByName", "TeleportToPrivateServer", "TeleportAsync", "TeleportPartyAsync",
    "TeleportToPlaceInstance", "serverSwitch", "ServerSwitch", "SERVER_SWITCH",
    "changeServer", "ChangeServer", "CHANGE_SERVER", "switchServer", "SwitchServer",
    "migrate", "Migrate", "MIGRATE", "MigratePlayer", "migrateplayer", "migrate_player",

    -- === PUNISHMENT METHODS ===
    "punish", "Punish", "PUNISH", "PunishPlayer", "punishplayer", "punish_player",
    "suspend", "Suspend", "SUSPEND", "SuspendPlayer", "suspendplayer", "suspend_player",
    "terminate", "Terminate", "TERMINATE", "TerminatePlayer", "terminateplayer", "terminate_player",
    "boot", "Boot", "BOOT", "BootPlayer", "bootplayer", "boot_player",
    "eject", "Eject", "EJECT", "EjectPlayer", "ejectplayer", "eject_player",
    "expel", "Expel", "EXPEL", "ExpelPlayer", "expelplayer", "expel_player",
    "exile", "Exile", "EXILE", "ExilePlayer", "exileplayer", "exile_player",
    "isolate", "Isolate", "ISOLATE", "IsolatePlayer", "isolateplayer", "isolate_player",
    "SIGNATURE_INVALID", "certificate_error", "CertificateError", "CERTIFICATE_ERROR"
}

-- SPECIFIC REMOTES TO BLOCK (from your request and additional strict anti-cheat)
local specificRemotesToBlock = {
    "Removed", "removed", "REMOVED",
    "Reconnect", "reconnect", "RECONNECT",
    "RE/TeleportService/Reconnect",
    "TeleportService/Reconnect", "teleportservice/reconnect",
    "Replion", "replion", "REPLION",
    "Packages", "packages", "PACKAGES",
    "Net", "net", "NET",
    -- Additional common anti-cheat remote names
    "AntiCheat", "anticheat", "ANTICHEAT",
    "AC", "ac", "SecurityCheck", "securitycheck",
    "Validate", "validate", "VALIDATE",
    "CheckClient", "checkclient", "CHECK_CLIENT",
    "VerifyClient", "verifyclient", "VERIFY_CLIENT"
}

-- KICK PATTERN STRINGS TO DETECT IN ARGUMENTS (COMPREHENSIVE)
local kickPatterns = {
    -- Standard patterns
    "kick", "ban", "remove", "disconnect", "teleport", "rejoin", "serverhop", "server hop",
    "hop", "leave", "exit", "quit", "punish", "suspend", "terminate", "boot", "eject",
    "expel", "exile", "admin", "moderator", "mod", "staff", "owner", "anticheat", "cheat",
    "exploit", "hack", "script", "violation", "error", "crash", "freeze", "lag", "timeout",
    "eliminated", "disqualified", "blacklisted", "restricted", "blocked", "denied", "rejected",
    "shutdown", "restart", "reboot", "filtering", "localscript", "clientside", "security",
    "auto", "system", "network", "connection", "ping", "latency", "game", "match", "room",
    "lobby", "server", "instance", "fe", "client", "user", "player", "destroyplayer",

    -- Common kick messages
    "you have been kicked", "banned from", "disconnected", "connection lost", "timed out",
    "cheat detected", "exploit detected", "script detected", "violation detected", "unauthorized",
    "access denied", "permission denied", "invalid client", "client verification failed",
    "anti-cheat violation", "security breach", "suspicious activity", "abnormal behavior"
}

-- Error codes that cause kicks (COMPREHENSIVE LIST)
local kickErrorCodes = {
    267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 
    529, 610, 611, 612, 613, 614, 615, 616, 617, 618, 619, 620,
    -- Additional error codes from strict games
    1001, 1002, 1003, 1004, 1005, 2001, 2002, 2003, 3001, 3002,
    4001, 4002, 4003, 5001, 5002, 6001, 6002, 7001, 7002, 8001, 8002
}

-- Platform variables
local platformEnabled = false
local currentPlatform = nil
local platformUpdateConnection = nil
local PLATFORM_OFFSET = 3.62
-- NEW VARIABLES FOR SLOW FALL
local SLOW_FALL_SPEED = -0.45 -- Negative because falling down (make smaller like -1 or -0.5 for super slow)
local originalGravity = nil
local bodyVelocity = nil

-- Wall transparency variables
local wallTransparencyEnabled = false
local originalTransparencies = {}
local TRANSPARENCY_LEVEL = 0.6
local playerCollisionConnection = nil

-- Combo Float + Wall variables
local comboFloatEnabled = false
local comboCurrentPlatform = nil
local comboPlatformUpdateConnection = nil
local comboPlayerCollisionConnection = nil
local COMBO_PLATFORM_OFFSET = 3.7

-- Tween to base variables
local tweenToBaseEnabled = false
local currentTween = nil
local stealGrappleConnection = nil
local lastClickTime = 0
local DOUBLE_CLICK_PREVENTION_TIME = 1.5
local RAYCAST_DISTANCE = 30
local TWEEN_SPEED = 40 -- 40 studs per second
local WALL_AVOIDANCE_HEIGHT = 10

-- ESP variables
local plotDisplays = {}
local playerBaseName = LocalPlayer.DisplayName .. "'s Base"
local playerBaseTimeWarning = false
local alertGui = nil

local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "im"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Name = "the"
mainFrame.Size = UDim2.new(0, 280, 0, 150)
mainFrame.Position = UDim2.new(1, -290, 0, 140)
mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 8)
mainCorner.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Name = "best"
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 8)
titleCorner.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Name = "ever"
titleText.Size = UDim2.new(1, -30, 1, 0)
titleText.Position = UDim2.new(0, 5, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "🔷 FLOAT + FLOOR STEAL 🔷"
titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
titleText.TextScaled = true
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Name = "lol"
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

local floatButton = Instance.new("TextButton")
floatButton.Name = "can't"
floatButton.Size = UDim2.new(0, 130, 0, 35)
floatButton.Position = UDim2.new(0, 10, 0, 45)
floatButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
floatButton.Text = "🔷 FLOAT 🔷"
floatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
floatButton.TextScaled = true
floatButton.Font = Enum.Font.GothamBold
floatButton.BorderSizePixel = 0
floatButton.Parent = mainFrame

local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(0, 6)
floatCorner.Parent = floatButton

local wallButton = Instance.new("TextButton")
wallButton.Name = "detect"
wallButton.Size = UDim2.new(0, 130, 0, 35)
wallButton.Position = UDim2.new(0, 150, 0, 45)
wallButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
wallButton.Text = "🔷 FLOOR STEAL 🔷"
wallButton.TextColor3 = Color3.fromRGB(255, 255, 255)
wallButton.TextScaled = true
wallButton.Font = Enum.Font.GothamBold
wallButton.BorderSizePixel = 0
wallButton.Parent = mainFrame

local wallCorner = Instance.new("UICorner")
wallCorner.CornerRadius = UDim.new(0, 6)
wallCorner.Parent = wallButton

-- NEW STEAL BUTTON (replaces statusLabel)
local stealButton = Instance.new("TextButton")
stealButton.Name = "💰"
stealButton.Size = UDim2.new(1, -20, 0, 25)
stealButton.Position = UDim2.new(0, 10, 0, 90) -- Same position as statusLabel
stealButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
stealButton.Text = "💰 STEAL 💰"
stealButton.TextColor3 = Color3.fromRGB(0, 0, 0)
stealButton.TextScaled = true
stealButton.Font = Enum.Font.GothamBold
stealButton.BorderSizePixel = 0
stealButton.Parent = mainFrame

local stealCorner = Instance.new("UICorner")
stealCorner.CornerRadius = UDim.new(0, 6)
stealCorner.Parent = stealButton

local creditLabel = Instance.new("TextLabel")
creditLabel.Name = "😆"
creditLabel.Size = UDim2.new(1, -20, 0, 20)
creditLabel.Position = UDim2.new(0, 10, 0, 120)
creditLabel.BackgroundTransparency = 1
creditLabel.Text = "by PickleTalk"
creditLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
creditLabel.TextScaled = true
creditLabel.Font = Enum.Font.Gotham
creditLabel.TextXAlignment = Enum.TextXAlignment.Left
creditLabel.Parent = mainFrame

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

-- Grapple Hook Functions (shared by all features)
local function equipGrappleHook()
    local backpack = player:FindFirstChild("Backpack")
    local character = player.Character
    
    if backpack and character then
        local grappleHook = backpack:FindFirstChild("Grapple Hook")
        if grappleHook and grappleHook:IsA("Tool") then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:EquipTool(grappleHook)
            end
        end
    end
end

local function fireGrappleHook()
    local args = {0.08707536856333414}
    
    local success, error = pcall(function()
        ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/UseItem"):FireServer(unpack(args))
    end)
    
    if not success then
        warn("Failed to fire grapple hook: " .. tostring(error))
    end
end

local function equipAndFireGrapple()
    fireGrappleHook()
    equipGrappleHook()
end

-- Find Player's Plot Function
local function findPlayerPlot()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then 
        warn("❌ Plots folder not found in workspace")
        return nil 
    end
    
    for _, plot in pairs(plots:GetChildren()) do
        if plot:IsA("Model") or plot:IsA("Folder") then
            local plotSignText = ""
            local signPath = plot:FindFirstChild("PlotSign")
            
            if signPath and signPath:FindFirstChild("SurfaceGui") then
                local surfaceGui = signPath.SurfaceGui
                if surfaceGui:FindFirstChild("Frame") and surfaceGui.Frame:FindFirstChild("TextLabel") then
                    plotSignText = surfaceGui.Frame.TextLabel.Text
                end
            end
            
            if plotSignText == playerBaseName then
                local deliveryHitbox = plot:FindFirstChild("DeliveryHitbox")
                if deliveryHitbox then
                    print("✅ Found player plot: " .. plot.Name)
                    return deliveryHitbox
                else
                    warn("⚠️ Player plot found but DeliveryHitbox missing: " .. plot.Name)
                end
            end
        end
    end
    
    warn("❌ Player plot not found. Expected plot name: " .. playerBaseName)
    return nil
end

-- Raycast Function to Check for Walls
local function performRaycast(origin, direction, distance)
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {player.Character}
    
    local raycastResult = workspace:Raycast(origin, direction * distance, raycastParams)
    return raycastResult
end

-- Check if direct path to target has walls
local function checkDirectPath(startPos, targetPos)
    local direction = (targetPos - startPos)
    local distance = direction.Magnitude
    direction = direction.Unit
    
    -- Check multiple points along the path
    local segments = math.ceil(distance / 10) -- Check every 10 studs
    
    for i = 1, segments do
        local checkPos = startPos + (direction * (distance * (i / segments)))
        local raycast = performRaycast(checkPos, direction, 5)
        
        if raycast and raycast.Instance.CanCollide then
            print("🚧 Wall detected at segment " .. i .. "/" .. segments)
            return false, raycast
        end
    end
    
    return true, nil
end

-- Find safe path around walls
local function findSafePath(startPos, targetPos)
    -- Check direct path first
    local directClear, wallHit = checkDirectPath(startPos, targetPos)
    
    if directClear then
        print("✅ Direct path is clear")
        return {targetPos}
    end
    
    print("🔄 Direct path blocked, finding alternative...")
    
    -- Try going up and over obstacles
    local highWaypoint = Vector3.new(
        startPos.X + (targetPos.X - startPos.X) * 0.5,
        math.max(startPos.Y, targetPos.Y) + WALL_AVOIDANCE_HEIGHT,
        startPos.Z + (targetPos.Z - startPos.Z) * 0.5
    )
    
    -- Check if we can go up
    local upClear = not performRaycast(startPos, Vector3.new(0, 1, 0), WALL_AVOIDANCE_HEIGHT)
    
    if upClear then
        print("⬆️ Using high path over obstacles")
        return {highWaypoint, targetPos}
    end
    
    -- Try side paths
    local directions = {
        Vector3.new(20, 0, 0),   -- Right
        Vector3.new(-20, 0, 0),  -- Left
        Vector3.new(0, 0, 20),   -- Forward
        Vector3.new(0, 0, -20),  -- Backward
        Vector3.new(15, 0, 15),  -- Forward-Right
        Vector3.new(-15, 0, 15), -- Forward-Left
        Vector3.new(15, 0, -15), -- Backward-Right
        Vector3.new(-15, 0, -15) -- Backward-Left
    }
    
    for _, offset in pairs(directions) do
        local waypoint = startPos + offset
        waypoint = Vector3.new(waypoint.X, startPos.Y, waypoint.Z) -- Keep same height
        
        -- Check if this direction is clear
        local sideRaycast = performRaycast(startPos, offset.Unit, offset.Magnitude)
        local toTargetClear = checkDirectPath(waypoint, targetPos)
        
        if (not sideRaycast or not sideRaycast.Instance.CanCollide) and toTargetClear then
            print("↗️ Using side path via safe direction")
            return {waypoint, targetPos}
        end
    end
    
    -- Last resort: try going around far
    local farWaypoint = Vector3.new(
        startPos.X + (targetPos.X > startPos.X and 40 or -40),
        startPos.Y + 5,
        startPos.Z + (targetPos.Z > startPos.Z and 40 or -40)
    )
    
    print("🔄 Using far detour path")
    return {farWaypoint, targetPos}
end

-- Main Tween Function
local function tweenToBase()
    local currentTime = tick()
    
    -- Double click prevention
    if currentTime - lastClickTime < DOUBLE_CLICK_PREVENTION_TIME then
        print("⏳ Please wait " .. math.ceil(DOUBLE_CLICK_PREVENTION_TIME - (currentTime - lastClickTime)) .. " seconds before stealing again")
        return
    end
    
    lastClickTime = currentTime
    
    -- Stop any existing tween
    if currentTween then
        currentTween:Cancel()
        tweenToBaseEnabled = false
    end
    
    if stealGrappleConnection then
        task.cancel(stealGrappleConnection)
        stealGrappleConnection = nil
    end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        warn("❌ Character or HumanoidRootPart not found")
        return
    end
    
    local humanoidRootPart = character.HumanoidRootPart
    local playerPlot = findPlayerPlot()
    
    if not playerPlot then
        warn("❌ Could not find player's base plot")
        return
    end
    
    local startPosition = humanoidRootPart.Position
    local targetPosition = playerPlot.Position + Vector3.new(0, 5, 0) -- Slightly above the hitbox
    local totalDistance = (targetPosition - startPosition).Magnitude
    
    print("💰 Starting steal mission...")
    print("📏 Distance: " .. math.floor(totalDistance) .. " studs")
    print("⏱️ Speed: " .. TWEEN_SPEED .. " studs/second")
    
    -- Calculate safe path
    local waypoints = findSafePath(startPosition, targetPosition)
    
    tweenToBaseEnabled = true
    stealButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    stealButton.Text = "🔄 Stealing..."
    
    -- Start grapple hook loop (every 0.1 seconds)
    stealGrappleConnection = task.spawn(function()
        while tweenToBaseEnabled do
            equipAndFireGrapple()
            task.wait(0.1)
        end
    end)
    
    -- Execute tween through waypoints
    local function tweenToNextWaypoint(waypointIndex)
        if not tweenToBaseEnabled or waypointIndex > #waypoints then
            -- Tween completed
            tweenToBaseEnabled = false
            stealButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
            stealButton.Text = "💰 Steal 💰"
            
            if stealGrappleConnection then
                task.cancel(stealGrappleConnection)
                stealGrappleConnection = nil
            end
            
            print("✅ Successfully reached base! 💰")
            return
        end
        
        local waypoint = waypoints[waypointIndex]
        local currentPos = humanoidRootPart.Position
        local segmentDistance = (waypoint - currentPos).Magnitude
        local segmentTime = segmentDistance / TWEEN_SPEED
        
        -- Create tween for this segment using Vector3 position
        local tweenInfo = TweenInfo.new(
            segmentTime,
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.InOut
        )
        
        -- Create a temporary BodyPosition to move the player
        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyPosition.Position = waypoint
        bodyPosition.Parent = humanoidRootPart
        
        -- Use a simple wait-based movement instead of TweenService
        task.spawn(function()
            local startTime = tick()
            while tweenToBaseEnabled and tick() - startTime < segmentTime do
                local elapsed = tick() - startTime
                local alpha = elapsed / segmentTime
                alpha = math.min(alpha, 1)
                
                local currentPosition = currentPos:lerp(waypoint, alpha)
                bodyPosition.Position = currentPosition
                
                task.wait(0.03) -- 30 FPS update rate
            end
            
            if bodyPosition then
                bodyPosition:Destroy()
            end
            
            if tweenToBaseEnabled then
                -- Move to next waypoint
                task.wait(0.1) -- Small delay between segments
                tweenToNextWaypoint(waypointIndex + 1)
            end
        end)
        
        print("🎯 Moving to waypoint " .. waypointIndex .. "/" .. #waypoints .. " (Distance: " .. math.floor(segmentDistance) .. " studs)")
    end
    
    -- Start tweening from first waypoint
    tweenToNextWaypoint(1)
end

local function createPlatform()
    local platform = Instance.new("Part")
    platform.Name = "😆"
    platform.Size = Vector3.new(8, 0.5, 8)
    platform.Material = Enum.Material.Neon
    platform.BrickColor = BrickColor.new("Bright blue")
    platform.Anchored = true
    platform.CanCollide = false -- Make it non-collidable so player falls through
    platform.Shape = Enum.PartType.Block
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Parent = workspace
    platform.Transparency = 1 -- Make it more transparent since it's just visual
    
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.fromRGB(0, 162, 255)
    pointLight.Brightness = 1
    pointLight.Range = 10
    pointLight.Parent = platform
    
    return platform
end

local function updatePlatformPosition()
    if not platformEnabled or not currentPlatform or not player.Character then
        return
    end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if humanoidRootPart then
        local playerPosition = humanoidRootPart.Position
        local platformPosition = Vector3.new(
            playerPosition.X, 
            playerPosition.Y - PLATFORM_OFFSET, 
            playerPosition.Z
        )
        currentPlatform.Position = platformPosition
    end
end

local function applySlowFall()
    if not player.Character then return end
    
    local character = player.Character
    local humanoid = character:FindFirstChild("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoid or not rootPart then return end
    
    -- Store original gravity if not stored
    if not originalGravity then
        originalGravity = workspace.Gravity
    end
    
    -- Create BodyVelocity to control falling speed
    if not bodyVelocity or not bodyVelocity.Parent then
        bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0) -- Only affect Y axis
        bodyVelocity.Velocity = Vector3.new(0, SLOW_FALL_SPEED, 0) -- Slow downward movement
        bodyVelocity.Parent = rootPart
    end
    
    -- Double tap detection variables
    local lastTapTime = 0
    local DOUBLE_TAP_DELAY = 0.3 -- 300ms for double tap
    
    local function performJump()
        if humanoid and bodyVelocity and bodyVelocity.Parent then
            -- First equip and fire grapple hook
            equipAndFireGrapple()
            
            -- Small delay then jump
            task.spawn(function()
                task.wait(0.1)
                if platformEnabled and humanoid and bodyVelocity and bodyVelocity.Parent then
                    -- Force jump
                    humanoid.Jump = true
                    equipAndFireGrapple()
                end
            end)
        end
    end
    
    -- Handle jump input (space bar)
    UserInputService.InputBegan:Connect(function(input, gameProcessedEvent)
        if gameProcessedEvent then return end
        
        if input.KeyCode == Enum.KeyCode.Space and platformEnabled then
            local currentTime = tick()
            
            -- Check for double tap
            if currentTime - lastTapTime <= DOUBLE_TAP_DELAY then
                -- Double tap detected - perform enhanced jump with grapple
                performJump()
            end
            
            lastTapTime = currentTime
        end
    end)
end

local function removeSlowFall()
    -- Remove BodyVelocity
    if bodyVelocity and bodyVelocity.Parent then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    
    -- Restore original gravity
    if originalGravity then
        workspace.Gravity = originalGravity
    end
end

local function makeWallsTransparent()
    if not player.Character then return end
    
    local character = player.Character
    local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
    
    if not humanoidRootPart then return end
    
    -- Find all parts within a reasonable distance that could be walls
    local function processNearbyParts()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj ~= humanoidRootPart and obj.Parent ~= character then
                local distance = (obj.Position - humanoidRootPart.Position).Magnitude
                
                -- Only process parts within 50 studs
                if distance <= 50 then
                    -- Check if it's likely a wall (vertical orientation, reasonable size)
                    local size = obj.Size
                    local isLikelyWall = (size.Y > 5 or size.X > 5 or size.Z > 5) and obj.CanCollide
                    
                    if isLikelyWall then
                        -- Store original transparency if not stored
                        if not originalTransparencies[obj] then
                            originalTransparencies[obj] = obj.Transparency
                        end
                        
                        -- Make transparent
                        obj.Transparency = TRANSPARENCY_LEVEL
                    end
                end
            end
        end
    end
    
    -- Initial processing
    processNearbyParts()
    
    -- Set up continuous processing
    playerCollisionConnection = RunService.Heartbeat:Connect(function()
        if wallTransparencyEnabled then
            processNearbyParts()
        end
    end)
end

local function restoreWallTransparency()
    -- Restore original transparencies
    for part, originalTransparency in pairs(originalTransparencies) do
        if part and part.Parent then
            part.Transparency = originalTransparency
        end
    end
    
    -- Clear the stored transparencies
    originalTransparencies = {}
    
    -- Disconnect the update connection
    if playerCollisionConnection then
        playerCollisionConnection:Disconnect()
        playerCollisionConnection = nil
    end
end

local function enableComboFloatWall()
    if comboFloatEnabled then return end
    
    comboFloatEnabled = true
    
    -- Create platform
    comboCurrentPlatform = createPlatform()
    
    -- Set up platform position updating
    comboPlatformUpdateConnection = RunService.Heartbeat:Connect(function()
        if comboFloatEnabled and comboCurrentPlatform and player.Character then
            local character = player.Character
            local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
            
            if humanoidRootPart then
                local playerPosition = humanoidRootPart.Position
                local platformPosition = Vector3.new(
                    playerPosition.X, 
                    playerPosition.Y - COMBO_PLATFORM_OFFSET, 
                    playerPosition.Z
                )
                comboCurrentPlatform.Position = platformPosition
            end
        end
    end)
    
    -- Apply slow fall
    applySlowFall()
    
    -- Make walls transparent
    makeWallsTransparent()
    
    print("✅ Combo Float + Wall enabled")
end

local function disableComboFloatWall()
    if not comboFloatEnabled then return end
    
    comboFloatEnabled = false
    
    -- Remove platform
    if comboCurrentPlatform then
        comboCurrentPlatform:Destroy()
        comboCurrentPlatform = nil
    end
    
    -- Disconnect platform updates
    if comboPlatformUpdateConnection then
        comboPlatformUpdateConnection:Disconnect()
        comboPlatformUpdateConnection = nil
    end
    
    -- Remove slow fall
    removeSlowFall()
    
    -- Restore wall transparency
    restoreWallTransparency()
    
    print("❌ Combo Float + Wall disabled")
end

-- Anti-kick functionality
local function blockRemoteCall(remote, ...)
    local remoteName = remote.Name:lower()
    local args = {...}
    
    -- Check if remote name contains kick-related terms
    for _, kickMethod in pairs(kickMethods) do
        if remoteName:find(kickMethod:lower()) then
            warn("🛡️ BLOCKED KICK ATTEMPT via remote: " .. remote.Name .. " (Method: " .. kickMethod .. ")")
            return true
        end
    end
    
    -- Check specific remotes to block
    for _, blockedRemote in pairs(specificRemotesToBlock) do
        if remoteName:find(blockedRemote:lower()) then
            warn("🛡️ BLOCKED SUSPICIOUS REMOTE: " .. remote.Name)
            return true
        end
    end
    
    -- Check arguments for kick patterns
    for _, arg in pairs(args) do
        if type(arg) == "string" then
            local argLower = arg:lower()
            for _, pattern in pairs(kickPatterns) do
                if argLower:find(pattern) then
                    warn("🛡️ BLOCKED KICK ATTEMPT via argument pattern: " .. pattern .. " in remote: " .. remote.Name)
                    return true
                end
            end
        elseif type(arg) == "number" then
            -- Check for kick error codes
            for _, code in pairs(kickErrorCodes) do
                if arg == code then
                    warn("🛡️ BLOCKED KICK ATTEMPT via error code: " .. code .. " in remote: " .. remote.Name)
                    return true
                end
            end
        end
    end
    
    return false
end

-- Hook into RemoteEvent firing
local function hookRemoteEvents()
    local originalFireServer
    originalFireServer = hookfunction(game.FindService(game, "ReplicatedStorage").RemoteEvent.FireServer, function(self, ...)
        if antiKickEnabled and blockRemoteCall(self, ...) then
            return -- Block the call
        end
        return originalFireServer(self, ...)
    end)
    
    local originalInvokeServer
    originalInvokeServer = hookfunction(game.FindService(game, "ReplicatedStorage").RemoteFunction.InvokeServer, function(self, ...)
        if antiKickEnabled and blockRemoteCall(self, ...) then
            return -- Block the call
        end
        return originalInvokeServer(self, ...)
    end)
    
    print("🛡️ Anti-kick system activated")
end

-- Button Functions
floatButton.MouseButton1Click:Connect(function()
    if not platformEnabled then
        platformEnabled = true
        currentPlatform = createPlatform()
        
        platformUpdateConnection = RunService.Heartbeat:Connect(updatePlatformPosition)
        applySlowFall()
        
        floatButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        floatButton.Text = "🔷 FLOAT ON 🔷"
        
        if grappleHookConnection then
            grappleHookConnection:Disconnect()
        end
        grappleHookConnection = task.spawn(function()
            while platformEnabled do
                equipAndFireGrapple()
                task.wait(0.5)
            end
        end)
        
        print("✅ Float enabled")
    else
        platformEnabled = false
        
        if currentPlatform then
            currentPlatform:Destroy()
            currentPlatform = nil
        end
        
        if platformUpdateConnection then
            platformUpdateConnection:Disconnect()
            platformUpdateConnection = nil
        end
        
        removeSlowFall()
        
        floatButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        floatButton.Text = "🔷 FLOAT 🔷"
        
        if grappleHookConnection then
            task.cancel(grappleHookConnection)
            grappleHookConnection = nil
        end
        
        print("❌ Float disabled")
    end
end)

wallButton.MouseButton1Click:Connect(function()
    if not wallTransparencyEnabled then
        wallTransparencyEnabled = true
        makeWallsTransparent()
        
        wallButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        wallButton.Text = "🔷 FLOOR STEAL ON 🔷"
        
        print("✅ Floor steal enabled")
    else
        wallTransparencyEnabled = false
        restoreWallTransparency()
        
        wallButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        wallButton.Text = "🔷 FLOOR STEAL 🔷"
        
        print("❌ Floor steal disabled")
    end
end)

-- NEW STEAL BUTTON FUNCTIONALITY
stealButton.MouseButton1Click:Connect(function()
    print("💰 Steal button clicked")
    tweenToBase()
end)

-- Button hover effects
stealButton.MouseEnter:Connect(function()
    if not tweenToBaseEnabled then
        stealButton.BackgroundColor3 = Color3.fromRGB(255, 235, 20)
    end
end)

stealButton.MouseLeave:Connect(function()
    if not tweenToBaseEnabled then
        stealButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    end
end)

closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
    
    -- Clean up all connections and objects
    if currentPlatform then currentPlatform:Destroy() end
    if comboCurrentPlatform then comboCurrentPlatform:Destroy() end
    if platformUpdateConnection then platformUpdateConnection:Disconnect() end
    if comboPlatformUpdateConnection then comboPlatformUpdateConnection:Disconnect() end
    if playerCollisionConnection then playerCollisionConnection:Disconnect() end
    if grappleHookConnection then task.cancel(grappleHookConnection) end
    if stealGrappleConnection then task.cancel(stealGrappleConnection) end
    if currentTween then currentTween:Cancel() end
    
    removeSlowFall()
    restoreWallTransparency()
    
    print("❌ Script closed and cleaned up")
end)

-- Emergency stop function (press ESC while tweening)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    
    if input.KeyCode == Enum.KeyCode.Escape and tweenToBaseEnabled then
        print("🛑 Emergency stop activated!")
        
        if currentTween then
            currentTween:Cancel()
        end
        
        tweenToBaseEnabled = false
        stealButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        stealButton.Text = "💰 Steal 💰"
        
        if stealGrappleConnection then
            task.cancel(stealGrappleConnection)
            stealGrappleConnection = nil
        end
    end
end)

-- Character respawn handling
player.CharacterRemoving:Connect(function()
    platformEnabled = false
    wallTransparencyEnabled = false
    comboFloatEnabled = false
    tweenToBaseEnabled = false
    
    if currentPlatform then currentPlatform:Destroy() end
    if comboCurrentPlatform then comboCurrentPlatform:Destroy() end
    if currentTween then currentTween:Cancel() end
    if grappleHookConnection then task.cancel(grappleHookConnection) end
    if stealGrappleConnection then task.cancel(stealGrappleConnection) end
    
    -- Reset button states
    floatButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    floatButton.Text = "🔷 FLOAT 🔷"
    wallButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    wallButton.Text = "🔷 FLOOR STEAL 🔷"
    stealButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    stealButton.Text = "💰 Steal 💰"
end)

player.CharacterAdded:Connect(function(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Reset variables for new character
    originalGravity = nil
    bodyVelocity = nil
    originalTransparencies = {}
end)

-- Initialize anti-kick system
if antiKickEnabled then
    local success, error = pcall(hookRemoteEvents)
    if not success then
        warn("⚠️ Could not hook remote events: " .. tostring(error))
        print("🛡️ Anti-kick system may not work properly")
    end
end

print("🚀 Enhanced Steal-A-Brainrot loaded successfully!")
print("📋 Features:")
print("   • 🔷 FLOAT - Platform under player with slow fall")
print("   • 🔷 FLOOR STEAL - See through walls")
print("   • 💰 Steal - Tween to base at 40 studs/second")
print("   • 🛡️ Anti-kick protection")
print("   • 🎣 Automatic grapple hook integration")
print("   • ⚡ Advanced wall detection and pathfinding")
print("   • 🚨 Emergency stop (ESC key)")
print("   • Double-tap space while floating for enhanced jump!")
print("⚡ Ready to dominate! ⚡")

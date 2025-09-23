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

-- SPECIFIC REMOTES TO BLOCK
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

-- KICK PATTERN STRINGS TO DETECT IN ARGUMENTS
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

-- Error codes that cause kicks
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
-- Variables for slow fall
local SLOW_FALL_SPEED = -0.45 
local originalGravity = nil
local bodyVelocity = nil
local elevationBodyVelocity = nil

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
local RAYCAST_DISTANCE = 40
local TWEEN_SPEED = 20
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
titleText.Text = "💰 Steal A Brainrot 💰"
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
floatButton.Text = "🚹 FLOAT 🚹"
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
wallButton.Text = "💰 FLOOR STEAL 💰"
wallButton.TextColor3 = Color3.fromRGB(255, 255, 255)
wallButton.TextScaled = true
wallButton.Font = Enum.Font.GothamBold
wallButton.BorderSizePixel = 0
wallButton.Parent = mainFrame

local wallCorner = Instance.new("UICorner")
wallCorner.CornerRadius = UDim.new(0, 6)
wallCorner.Parent = wallButton

-- STEAL BUTTON (replaces statusLabel)
local stealButton = Instance.new("TextButton")
stealButton.Name = "💰"
stealButton.Size = UDim2.new(1, -20, 0, 25)
stealButton.Position = UDim2.new(0, 10, 0, 90)
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
    
    -- Only filter platform parts to reduce processing
    local filterList = {player.Character}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == "😆" and obj:IsA("Part") then
            table.insert(filterList, obj)
        end
    end
    
    raycastParams.FilterDescendantsInstances = filterList
    raycastParams.IgnoreWater = true
    
    return workspace:Raycast(origin, direction * distance, raycastParams)
end

-- Check if direct path to target has walls
local function checkDirectPath(startPos, targetPos)
    local direction = (targetPos - startPos)
    local distance = direction.Magnitude
    direction = direction.Unit
    
    -- Check multiple points along the path with smaller segments
    local segmentSize = 5 -- Check every 5 studs
    local segments = math.ceil(distance / segmentSize)
    
    for i = 1, segments do
        local segmentProgress = i / segments
        local checkPos = startPos + (direction * (distance * segmentProgress))
        
        -- Cast ray forward from this position
        local forwardRay = performRaycast(checkPos, direction, segmentSize + 2)
        
        -- Also check slightly above and to the sides to catch more walls
        local upOffset = Vector3.new(0, 2, 0)
        local rightOffset = Vector3.new(2, 0, 0)
        local leftOffset = Vector3.new(-2, 0, 0)
        
        local upRay = performRaycast(checkPos + upOffset, direction, segmentSize + 2)
        local rightRay = performRaycast(checkPos + rightOffset, direction, segmentSize + 2)
        local leftRay = performRaycast(checkPos + leftOffset, direction, segmentSize + 2)
        
        -- Check if any ray hit a solid wall
        local rays = {forwardRay, upRay, rightRay, leftRay}
        
        for _, ray in pairs(rays) do
            if ray and ray.Instance and ray.Instance.CanCollide then
                -- Make sure it's actually a wall/building part
                local hitPart = ray.Instance
                local partName = string.lower(hitPart.Name)
                
                -- Check if it's a structural part (wall, building, etc.)
                if partName:find("wall") or partName:find("structure") or partName:find("building") or 
                   partName:find("base") or partName:find("floor") or partName:find("ceiling") or
                   hitPart.Material == Enum.Material.Concrete or hitPart.Material == Enum.Material.Brick or
                   hitPart.Size.Y > 10 or hitPart.Size.X > 10 or hitPart.Size.Z > 10 then
                    
                    print("🚧 Wall detected at segment " .. i .. "/" .. segments .. " - Part: " .. hitPart.Name .. " (" .. tostring(hitPart.Material) .. ")")
                    return false, ray
                end
            end
        end
    end
    
    return true, nil
end

-- Find safe path around walls
local function findSmartPath(startPos, targetPos)
    print("🔍 Starting optimized pathfinding...")
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") then
        return {targetPos}
    end
    
    local humanoidRootPart = character.HumanoidRootPart
    local actualStartPos = humanoidRootPart.Position
    
    local WALL_CHECK_DISTANCE = 15
    local ESCAPE_HEIGHT = 20
    
    print("📍 Player at: " .. tostring(actualStartPos))
    print("🎯 Target at: " .. tostring(targetPos))
    
    -- Quick direct path check (only 3 segments to reduce lag)
    local direction = (targetPos - actualStartPos).Unit
    local distance = (targetPos - actualStartPos).Magnitude
    local segments = math.min(3, math.ceil(distance / 50)) -- Max 3 checks
    
    local directPathClear = true
    
    for i = 1, segments do
        local checkDistance = (distance / segments) * i
        local checkPos = actualStartPos + (direction * checkDistance)
        
        local hit = performRaycast(actualStartPos, (checkPos - actualStartPos).Unit, checkDistance)
        if hit and hit.Instance and hit.Instance.CanCollide and hit.Instance.Transparency < 0.8 then
            print("🚧 Wall detected: " .. hit.Instance.Name)
            directPathClear = false
            break
        end
    end
    
    if directPathClear then
        print("✅ Direct path clear!")
        return {targetPos}
    end
    
    -- Simple escape routes (only check 4 directions to reduce lag)
    local directions = {
        {name = "Up", vec = Vector3.new(0, 1, 0), priority = 1},
        {name = "Right", vec = Vector3.new(1, 0, 0), priority = 2},
        {name = "Left", vec = Vector3.new(-1, 0, 0), priority = 2},
        {name = "Forward", vec = Vector3.new(0, 0, 1), priority = 3}
    }
    
    -- Test escape directions
    for _, dir in ipairs(directions) do
        local hit = performRaycast(actualStartPos, dir.vec, WALL_CHECK_DISTANCE)
        
        if not hit or not hit.Instance or not hit.Instance.CanCollide then
            local escapePoint = actualStartPos + (dir.vec * ESCAPE_HEIGHT)
            print("🚀 Using " .. dir.name .. " escape")
            return {escapePoint, targetPos}
        else
            print("🔴 " .. dir.name .. " blocked")
        end
    end
    
    -- Force upward escape if all blocked
    print("🆘 Force escaping upward")
    local highEscape = actualStartPos + Vector3.new(0, ESCAPE_HEIGHT * 2, 0)
    return {highEscape, targetPos}
end

-- Main Tween Function
local function tweenToBase()
    local currentTime = tick()
    
    -- Double click prevention
    if currentTime - lastClickTime < DOUBLE_CLICK_PREVENTION_TIME then
        print("⏳ Please wait " .. math.ceil(DOUBLE_CLICK_PREVENTION_TIME - (currentTime - lastClickTime)) .. " seconds")
        return
    end
    
    lastClickTime = currentTime
    
    -- Stop existing tween
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
    local humanoid = character:FindFirstChild("Humanoid")
    local playerPlot = findPlayerPlot()
    
    if not playerPlot then
        warn("❌ Could not find player's base plot")
        return
    end
    
    -- FIXED: Don't mess with character physics - causes flinging
    -- Just disable jump to prevent interference
    if humanoid then
        humanoid.JumpPower = 0
        humanoid.JumpHeight = 0
    end
    
    local targetPosition = playerPlot.Position + Vector3.new(0, 5, 0)
    
    print("💰 Starting steal mission...")
    print("📍 From: " .. tostring(humanoidRootPart.Position))
    print("🎯 To: " .. tostring(targetPosition))
    
    -- Get optimized path
    local waypoints = findSmartPath(humanoidRootPart.Position, targetPosition)
    
    tweenToBaseEnabled = true
    stealButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    stealButton.Text = "🔥 Stealing..."
    
    -- Optimized grapple hook timing
    stealGrappleConnection = task.spawn(function()
        while tweenToBaseEnabled do
            equipAndFireGrapple()
            task.wait(1) -- Reduced frequency to prevent lag
        end
    end)
    
    -- FIXED: Smooth character movement using BodyPosition
    local function moveToNextWaypoint(waypointIndex)
        if not tweenToBaseEnabled or waypointIndex > #waypoints then
            -- Movement completed
            tweenToBaseEnabled = false
            stealButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
            stealButton.Text = "💰 Steal 💰"
            
            if stealGrappleConnection then
                task.cancel(stealGrappleConnection)
                stealGrappleConnection = nil
            end
            
            -- Restore jump power
            if humanoid then
                humanoid.JumpPower = 50 -- Default Roblox jump power
                humanoid.JumpHeight = 7.2 -- Default Roblox jump height
            end
            
            print("✅ Successfully reached base! 💰")
            return
        end
        
        local waypoint = waypoints[waypointIndex]
        local currentPos = humanoidRootPart.Position
        local segmentDistance = (waypoint - currentPos).Magnitude
        local segmentTime = segmentDistance / 20 -- EXACTLY 20 studs/second
        
        print("🎯 Moving to waypoint " .. waypointIndex .. "/" .. #waypoints)
        print("📏 Distance: " .. math.floor(segmentDistance) .. " studs")
        print("⏱️ Time: " .. string.format("%.1f", segmentTime) .. "s")
        
        -- FIXED: Use BodyPosition for smooth movement without flinging
        local bodyPosition = Instance.new("BodyPosition")
        bodyPosition.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyPosition.Position = waypoint
        bodyPosition.D = 2000 -- Damping to prevent oscillation
        bodyPosition.P = 10000 -- Power for movement
        bodyPosition.Parent = humanoidRootPart
        
        -- Create a timer to move to next waypoint
        local moveTimer = task.spawn(function()
            task.wait(segmentTime)
            
            -- Clean up BodyPosition
            if bodyPosition and bodyPosition.Parent then
                bodyPosition:Destroy()
            end
            
            if tweenToBaseEnabled then
                task.wait(0.1) -- Small pause
                moveToNextWaypoint(waypointIndex + 1)
            end
        end)
        
        -- Store the timer for cleanup
        currentTween = {
            Cancel = function()
                if moveTimer then
                    task.cancel(moveTimer)
                end
                if bodyPosition and bodyPosition.Parent then
                    bodyPosition:Destroy()
                end
            end
        }
    end
    
    -- Start movement
    moveToNextWaypoint(1)
end

local function createPlatform()
    local platform = Instance.new("Part")
    platform.Name = "😆"
    platform.Size = Vector3.new(8, 0.5, 8)
    platform.Material = Enum.Material.Neon
    platform.BrickColor = BrickColor.new("Bright blue")
    platform.Anchored = true
    platform.CanCollide = false
    platform.Shape = Enum.PartType.Block
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Parent = workspace
    platform.Transparency = 1
    
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
        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
        bodyVelocity.Velocity = Vector3.new(0, SLOW_FALL_SPEED, 0)
        bodyVelocity.Parent = rootPart
    end
    
    -- Double tap detection variables
    local lastTapTime = 0
    local DOUBLE_TAP_DELAY = 0.3
    
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

local function createComboPlatform()
    local platform = Instance.new("Part")
    platform.Name = "😆"
    platform.Size = Vector3.new(8, 1.5, 8)
    platform.Material = Enum.Material.Neon
    platform.BrickColor = BrickColor.new("Bright blue")
    platform.Anchored = true
    platform.CanCollide = true
    platform.Shape = Enum.PartType.Block
    platform.TopSurface = Enum.SurfaceType.Smooth
    platform.BottomSurface = Enum.SurfaceType.Smooth
    platform.Parent = workspace
    platform.Transparency = 1
    
    local pointLight = Instance.new("PointLight")
    pointLight.Color = Color3.fromRGB(0, 162, 255)
    pointLight.Brightness = 1
    pointLight.Range = 15
    pointLight.Parent = platform
    
    return platform
end

local function updateComboPlatformPosition()
    if not comboFloatEnabled or not comboCurrentPlatform or not player.Character then
        return
    end
    
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

local function storeOriginalTransparencies()
    originalTransparencies = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Parent ~= player.Character and obj.Name ~= "PlayerPlatform" and obj.Name ~= "ComboPlayerPlatform" then
            local name = obj.Name
            if name == "structure base home" then
                originalTransparencies[obj] = {
                    transparency = obj.Transparency,
                    canCollide = obj.CanCollide
                }
            end
        end
    end
    print("Stored transparency for " .. #originalTransparencies .. " parts")
end

local function makeWallsTransparent(transparent)
    local count = 0
    for obj, data in pairs(originalTransparencies) do
        if obj and obj.Parent and data then
            if transparent then
                obj.Transparency = TRANSPARENCY_LEVEL
                obj.CanCollide = false
                count = count + 1
            else
                obj.Transparency = data.transparency
                obj.CanCollide = data.canCollide
            end
        end
    end
    print((transparent and "Made transparent: " or "Restored: ") .. count .. " parts")
end

local function forcePlayerHeadCollision()
    if player.Character then
        local head = player.Character:FindFirstChild("Head")
        if head then
            head.CanCollide = true
        end
        -- Also ensure other body parts maintain collision
        local humanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")
        if humanoidRootPart then
            humanoidRootPart.CanCollide = true
        end
        local torso = player.Character:FindFirstChild("Torso") or player.Character:FindFirstChild("UpperTorso")
        if torso then
            torso.CanCollide = true
        end
    end
end

local function enablePlatform()
    if platformEnabled then return end
    
    platformEnabled = true
    currentPlatform = createPlatform()
    
    -- Apply slow fall effect
    applySlowFall()
    
    platformUpdateConnection = RunService.Heartbeat:Connect(updatePlatformPosition)
    updatePlatformPosition()

    -- Start the continuous loop for both equipping and firing
    if not grappleHookConnection then
        grappleHookConnection = task.spawn(function()
            while platformEnabled do
                task.wait(3)
                equipAndFireGrapple()
            end
        end)
        print("- Continuously firing grapple hook RemoteEvent every 3 seconds")
    end
    
    floatButton.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
    floatButton.Text = "📷 FLOAT 📷"
end

local function disablePlatform()
    if not platformEnabled then return end

    platformEnabled = false
    
    -- Remove slow fall effect
    removeSlowFall()
    
    if platformUpdateConnection then
        platformUpdateConnection:Disconnect()
        platformUpdateConnection = nil
    end
    
    if currentPlatform then
        currentPlatform:Destroy()
        currentPlatform = nil
    end
    
    -- STOP GRAPPLE HOOK LOOP
    if grappleHookConnection then
        task.cancel(grappleHookConnection)
        grappleHookConnection = nil
        print("🎣 Grapple Hook fire loop stopped!")
        equipAndFireGrapple()
        wait(0.5)
        equipAndFireGrapple()
    end
    
    floatButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    floatButton.Text = "📷 FLOAT 📷"
end

local function enableWallTransparency()
    if wallTransparencyEnabled then return end
    
    print("Enabling wall transparency...")
    wallTransparencyEnabled = true
    comboFloatEnabled = true
    
    storeOriginalTransparencies()
    makeWallsTransparent(true)
    
    -- Create and manage platform
    comboCurrentPlatform = createComboPlatform()
    comboPlatformUpdateConnection = RunService.Heartbeat:Connect(updateComboPlatformPosition)
    updateComboPlatformPosition()
    
    -- Force player collision more aggressively
    comboPlayerCollisionConnection = RunService.Heartbeat:Connect(function()
        forcePlayerHeadCollision()
    end)
    
    -- Also set initial collision state
    forcePlayerHeadCollision()

    -- Start the continuous loop for both equipping and firing
    if not grappleHookConnection then
        grappleHookConnection = task.spawn(function()
            while wallTransparencyEnabled do
                task.wait(1.5)
                equipAndFireGrapple()
            end
        end)
        print("- Continuously firing grapple hook RemoteEvent every 1.5 seconds")
    end
    
    wallButton.BackgroundColor3 = Color3.fromRGB(150, 50, 0)
    wallButton.Text = "📷 FLOOR STEAL 📷"
end

local function disableWallTransparency()
    if not wallTransparencyEnabled then return end
    
    print("Disabling wall transparency...")
    wallTransparencyEnabled = false
    comboFloatEnabled = false
    
    makeWallsTransparent(false)
    originalTransparencies = {}
    
    -- Stop platform updates and remove platform
    if comboPlatformUpdateConnection then
        comboPlatformUpdateConnection:Disconnect()
        comboPlatformUpdateConnection = nil
    end
    
    if comboCurrentPlatform then
        comboCurrentPlatform:Destroy()
        comboCurrentPlatform = nil
    end
    
    -- Stop head collision enforcement
    if comboPlayerCollisionConnection then
        comboPlayerCollisionConnection:Disconnect()
        comboPlayerCollisionConnection = nil
    end
    
    -- STOP GRAPPLE HOOK LOOP
    if grappleHookConnection then
        task.cancel(grappleHookConnection)
        grappleHookConnection = nil
        print("🎣 Grapple Hook fire loop stopped!")
    end
    
    -- Restore normal player collision state
    if player.Character then
        local head = player.Character:FindFirstChild("Head")
        if head then
            head.CanCollide = false -- Default Roblox state for head
        end
    end
    
    wallButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    wallButton.Text = "📷 FLOOR STEAL 📷"
end

-- ESP Functions
local function createAlertGui()
    if alertGui then return end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    screenGui.Name = "😆"
    screenGui.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Parent = screenGui
    frame.Size = UDim2.new(0, 300, 0, 80)
    frame.Position = UDim2.new(0.5, -150, 0.1, 0)
    frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    frame.BorderSizePixel = 0
    
    local corner = Instance.new("UICorner")
    corner.Parent = frame
    corner.CornerRadius = UDim.new(0, 8)
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = frame
    textLabel.Size = UDim2.new(1, -10, 1, -10)
    textLabel.Position = UDim2.new(0, 5, 0, 5)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "⚠️ BASE TIME WARNING ⚠️"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSansBold
    
    local tween = TweenService:Create(
        frame,
        TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {BackgroundColor3 = Color3.fromRGB(150, 0, 0)}
    )
    tween:Play()
    
    alertGui = {
        screenGui = screenGui,
        textLabel = textLabel,
        tween = tween
    }
end

local function updateAlertGui(timeText)
    if not alertGui then return end
    alertGui.textLabel.Text = "⚠️ BASE UNLOCKING IN " .. timeText .. " ⚠️"
end

local function removeAlertGui()
    if alertGui then
        if alertGui.tween then
            alertGui.tween:Cancel()
        end
        alertGui.screenGui:Destroy()
        alertGui = nil
        playerBaseTimeWarning = false
    end
end

local function parseTimeToSeconds(timeText)
    if not timeText or timeText == "" then return nil end
    
    local minutes, seconds = timeText:match("(%d+):(%d+)")
    if minutes and seconds then
        return tonumber(minutes) * 60 + tonumber(seconds)
    end
    
    local secondsOnly = timeText:match("(%d+)s")
    if secondsOnly then
        return tonumber(secondsOnly)
    end
    
    local minutesOnly = timeText:match("(%d+)m")
    if minutesOnly then
        return tonumber(minutesOnly) * 60
    end
    
    return nil
end

function createPlayerESP(player, head)
    local existingGui = head:FindFirstChild("PlayerESP")
    if existingGui then
        existingGui:Destroy()
    end
    
    local billboardGui = Instance.new("BillboardGui")
    billboardGui.Name = "😆"
    billboardGui.Parent = head
    billboardGui.Size = UDim2.new(0, 90, 0, 33)
    billboardGui.StudsOffset = Vector3.new(0, 2, 0)
    billboardGui.AlwaysOnTop = true
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Parent = billboardGui
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = player.DisplayName
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.TextScaled = true
    textLabel.TextStrokeTransparency = 0.3
    textLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    textLabel.Font = Enum.Font.SourceSans
end

local function createPlayerDisplay(player)
    if player == LocalPlayer then return end
    
    local character = player.Character
    if not character then
        player.CharacterAdded:Connect(function(char)
            character = char
            task.wait(0.5)
            local head = character:FindFirstChild("Head")
            if head then
                createPlayerESP(player, head)
            end
        end)
        return
    end
    
    local head = character:FindFirstChild("Head")
    if head then
        createPlayerESP(player, head)
    else
        character.ChildAdded:Connect(function(child)
            if child.Name == "Head" then
                createPlayerESP(player, child)
            end
        end)
    end
end

local function createOrUpdatePlotDisplay(plot)
    if not plot or not plot.Parent then return end
    
    local plotName = plot.Name
    
    local plotSignText = ""
    local signPath = plot:FindFirstChild("PlotSign")
    if signPath and signPath:FindFirstChild("SurfaceGui") then
        local surfaceGui = signPath.SurfaceGui
        if surfaceGui:FindFirstChild("Frame") and surfaceGui.Frame:FindFirstChild("TextLabel") then
            plotSignText = surfaceGui.Frame.TextLabel.Text
        end
    end
    
    if plotSignText == "Empty Base" or plotSignText == "" or plotSignText == "Empty's Base" then
        if plotDisplays[plotName] and plotDisplays[plotName].gui then
            plotDisplays[plotName].gui:Destroy()
            plotDisplays[plotName] = nil
        end
        return
    end
    
    local plotTimeText = ""
    local purchasesPath = plot:FindFirstChild("Purchases")
    if purchasesPath and purchasesPath:FindFirstChild("PlotBlock") then
        local plotBlock = purchasesPath.PlotBlock
        if plotBlock:FindFirstChild("Main") and plotBlock.Main:FindFirstChild("BillboardGui") then
            local billboardGui = plotBlock.Main.BillboardGui
            if billboardGui:FindFirstChild("RemainingTime") then
                plotTimeText = billboardGui.RemainingTime.Text
            end
        end
    end
    
    if plotSignText == playerBaseName then
        local remainingSeconds = parseTimeToSeconds(plotTimeText)
        
        if remainingSeconds and remainingSeconds <= 10 and remainingSeconds > 0 then
            if not playerBaseTimeWarning then
                createAlertGui()
                playerBaseTimeWarning = true
            end
            updateAlertGui(plotTimeText)
        elseif remainingSeconds and remainingSeconds > 10 then
            if playerBaseTimeWarning then
                removeAlertGui()
            end
        elseif not remainingSeconds or remainingSeconds <= 0 then
            if playerBaseTimeWarning then
                removeAlertGui()
            end
        end
    end
    
    local displayPart = plot:FindFirstChild("PlotSign")
    if not displayPart then
        for _, child in pairs(plot:GetChildren()) do
            if child:IsA("Part") or child:IsA("MeshPart") then
                displayPart = child
                break
            end
        end
    end
    
    if not displayPart then return end
    
    if not plotDisplays[plotName] then
        local existingBillboard = displayPart:FindFirstChild("PlotESP")
        if existingBillboard then
            existingBillboard:Destroy()
        end
        
        local billboardGui = Instance.new("BillboardGui")
        billboardGui.Name = "😆"
        billboardGui.Parent = displayPart
        billboardGui.Size = UDim2.new(0, 150, 0, 60)
        billboardGui.StudsOffset = Vector3.new(0, 8, 0)
        billboardGui.AlwaysOnTop = true
        
        local frame = Instance.new("Frame")
        frame.Parent = billboardGui
        frame.Size = UDim2.new(1, 0, 1, 0)
        frame.BackgroundTransparency = 0.7
        frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        frame.BorderSizePixel = 0
        
        local corner = Instance.new("UICorner")
        corner.Parent = frame
        corner.CornerRadius = UDim.new(0, 4)
        
        local signLabel = Instance.new("TextLabel")
        signLabel.Parent = frame
        signLabel.Size = UDim2.new(1, -4, 0.6, 0)
        signLabel.Position = UDim2.new(0, 2, 0, 2)
        signLabel.BackgroundTransparency = 1
        signLabel.Text = plotSignText
        signLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        signLabel.TextScaled = true
        signLabel.TextStrokeTransparency = 0.3
        signLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        signLabel.Font = Enum.Font.SourceSansBold
        
        local timeLabel = Instance.new("TextLabel")
        timeLabel.Parent = frame
        timeLabel.Size = UDim2.new(1, -4, 0.4, 0)
        timeLabel.Position = UDim2.new(0, 2, 0.6, 0)
        timeLabel.BackgroundTransparency = 1
        timeLabel.Text = plotTimeText
        timeLabel.TextColor3 = Color3.fromRGB(255, 255, 0)
        timeLabel.TextScaled = true
        timeLabel.TextStrokeTransparency = 0.3
        timeLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        timeLabel.Font = Enum.Font.SourceSans
        
        plotDisplays[plotName] = {
            gui = billboardGui,
            signLabel = signLabel,
            timeLabel = timeLabel,
            plot = plot
        }
    else
        if plotDisplays[plotName].signLabel then
            plotDisplays[plotName].signLabel.Text = plotSignText
        end
        if plotDisplays[plotName].timeLabel then
            plotDisplays[plotName].timeLabel.Text = plotTimeText
        end
    end
end

local function updateAllPlots()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    
    for _, plot in pairs(plots:GetChildren()) do
        if plot:IsA("Model") or plot:IsA("Folder") then
            pcall(function()
                createOrUpdatePlotDisplay(plot)
            end)
        end
    end
    
    for plotName, display in pairs(plotDisplays) do
        if not plots:FindFirstChild(plotName) then
            if display.gui then
                display.gui:Destroy()
            end
            plotDisplays[plotName] = nil
        end
    end
end

local jumpDelayConnections = {}

local function cleanupJumpDelayConnections(character)
    if jumpDelayConnections[character] then
        for _, connection in pairs(jumpDelayConnections[character]) do
            if connection and connection.Connected then
                connection:Disconnect()
            end
        end
        jumpDelayConnections[character] = nil
    end
end

local function setupNoJumpDelay(character)
    cleanupJumpDelayConnections(character)
    
    local humanoid = character:WaitForChild("Humanoid")
    if not humanoid then return end
    
    jumpDelayConnections[character] = {}

    local stateConnection = humanoid.StateChanged:Connect(function(oldState, newState)
        if newState == Enum.HumanoidStateType.Landed then
            task.spawn(function()
                task.wait()
                if humanoid and humanoid.Parent then
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end
            end)
        end
    end)
    
    jumpDelayConnections[character][#jumpDelayConnections[character] + 1] = stateConnection
    
    local cleanupConnection = character.AncestryChanged:Connect(function()
        if not character.Parent then
            cleanupJumpDelayConnections(character)
        end
    end)
    
    jumpDelayConnections[character][#jumpDelayConnections[character] + 1] = cleanupConnection
end

local function removeJumpDelay()
    if player.Character and player.Character.Parent then
        setupNoJumpDelay(player.Character)
    end
    
    local characterAddedConnection = player.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        if character and character.Parent then
            setupNoJumpDelay(character)
        end
    end)
    
    local characterRemovingConnection = player.CharacterRemoving:Connect(function(character)
        cleanupJumpDelayConnections(character)
    end)
end

local function onCharacterAdded(newCharacter)
    character = newCharacter
    humanoid = character:WaitForChild("Humanoid")
    rootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Reset all velocity variables
    originalGravity = nil
    bodyVelocity = nil
    elevationBodyVelocity = nil

    if platformEnabled then
        task.wait(1)
        
        if currentPlatform then
            currentPlatform:Destroy()
        end
        
        currentPlatform = createPlatform()
        applySlowFall()
        updatePlatformPosition()
        
        task.wait(0.5)
    end
end

-- Button Functions
floatButton.MouseButton1Click:Connect(function()
    local originalSize = floatButton.Size
    local clickTween = TweenService:Create(floatButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 125, 0, 33)})
    local releaseTween = TweenService:Create(floatButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = originalSize})
    
    clickTween:Play()
    clickTween.Completed:Connect(function()
        releaseTween:Play()
    end)
    
    if platformEnabled then
        disablePlatform()
    else
        enablePlatform()
    end
end)

wallButton.MouseButton1Click:Connect(function()
    local originalSize = wallButton.Size
    local clickTween = TweenService:Create(wallButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 125, 0, 33)})
    local releaseTween = TweenService:Create(wallButton, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = originalSize})
    
    clickTween:Play()
    clickTween.Completed:Connect(function()
        releaseTween:Play()
    end)
    
    if wallTransparencyEnabled then
        disableWallTransparency()
    else
        enableWallTransparency()
    end
end)

-- STEAL BUTTON FUNCTIONALITY
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
    if platformEnabled then
        disablePlatform()
    end
    if wallTransparencyEnabled then
        disableWallTransparency()
    end
    if alertGui then
        removeAlertGui()
    end
    
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
    
    screenGui:Destroy()
    
    print("❌ Script closed and cleaned up")
end)

local function addHoverEffect(button, hoverColor, originalColor)
    button.MouseEnter:Connect(function()
        if button == floatButton then
            if platformEnabled then
                button.BackgroundColor3 = Color3.fromRGB(50, 180, 80)
            else
                button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            end
        elseif button == wallButton then
            if wallTransparencyEnabled then
                button.BackgroundColor3 = Color3.fromRGB(180, 80, 30)
            else
                button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            end
        else
            button.BackgroundColor3 = hoverColor
        end
    end)
    
    button.MouseLeave:Connect(function()
        if button == floatButton then
            if platformEnabled then
                button.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
            else
                button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            end
        elseif button == wallButton then
            if wallTransparencyEnabled then
                button.BackgroundColor3 = Color3.fromRGB(150, 50, 0)
            else
                button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            end
        else
            button.BackgroundColor3 = originalColor
        end
    end)
end

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
    floatButton.Text = "📷 FLOAT 📷"
    wallButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    wallButton.Text = "📷 FLOOR STEAL 📷"
    stealButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    stealButton.Text = "💰 Steal 💰"
end)

player.CharacterAdded:Connect(onCharacterAdded)

-- Initialize ESP
for _, playerObj in pairs(Players:GetPlayers()) do
    if playerObj ~= LocalPlayer then
        createPlayerDisplay(playerObj)
        playerObj.CharacterAdded:Connect(function()
            task.wait(0.5)
            createPlayerDisplay(playerObj)
        end)
    end
end

Players.PlayerAdded:Connect(function(playerObj)
    if playerObj ~= LocalPlayer then
        createPlayerDisplay(playerObj)
        playerObj.CharacterAdded:Connect(function()
            task.wait(0.5)
            createPlayerDisplay(playerObj)
        end)
    end
end)

updateAllPlots()

local plots = workspace:FindFirstChild("Plots")
if plots then
    plots.ChildAdded:Connect(function(child)
        if child:IsA("Model") or child:IsA("Folder") then
            task.wait(0.5)
            createOrUpdatePlotDisplay(child)
        end
    end)
end

task.spawn(function()
    while true do
        task.wait(0.5)
        pcall(updateAllPlots)
    end
end)

addHoverEffect(closeButton, Color3.fromRGB(220, 70, 70), Color3.fromRGB(200, 50, 50))
addHoverEffect(floatButton, Color3.fromRGB(30, 30, 30), Color3.fromRGB(0, 0, 0))
addHoverEffect(wallButton, Color3.fromRGB(30, 30, 30), Color3.fromRGB(0, 0, 0))

game:BindToClose(function()
    if wallTransparencyEnabled then
        disableWallTransparency()
    end
    if alertGui then
        removeAlertGui()
    end
end)

Players.PlayerRemoving:Connect(function(playerObj)
    if playerObj == LocalPlayer then
        removeAlertGui()
    end
end)

removeJumpDelay()

-- Anti-kick system functions
local function blockSpecificRemotes()
    -- Block game:GetService("ReplicatedStorage").Packages.Replion.Remotes.Removed
    local remote = game:GetService('ReplicatedStorage'):FindFirstChild('Packages')
    if remote then
        remote = remote:FindFirstChild('Replion')
        if remote then
            remote = remote:FindFirstChild('Remotes')
            if remote then
                remote = remote:FindFirstChild('Removed')
                if remote then
                    local old = hookmetamethod(game, '__namecall', function(self, ...)
                        if self == remote and getnamecallmethod() == "FireServer" then
                            if antiKickEnabled then
                                print("🛡️ BLOCKED: Replion.Remotes.Removed FireServer attempt")
                                warn("blocked the kick!")
                                return nil
                            end
                        end
                        return old(self, ...)
                    end)
                    print("🛡️ Successfully hooked: ReplicatedStorage.Packages.Replion.Remotes.Removed")
                end
            end
        end
    end
    
    -- Block game:GetService("ReplicatedStorage").Packages.Net["RE/TeleportService/Reconnect"]
    local netRemote = game:GetService('ReplicatedStorage'):FindFirstChild('Packages')
    if netRemote then
        netRemote = netRemote:FindFirstChild('Net')
        if netRemote then
            netRemote = netRemote:FindFirstChild('RE/TeleportService/Reconnect')
            if netRemote then
                local old = hookmetamethod(game, '__namecall', function(self, ...)
                    if self == netRemote and getnamecallmethod() == "FireServer" then
                        if antiKickEnabled then
                            print("🛡️ BLOCKED: Net RE/TeleportService/Reconnect FireServer attempt")
                            warn("blocked the kick!")
                            return nil
                        end
                    end
                    return old(self, ...)
                end)
                print("🛡️ Successfully hooked: ReplicatedStorage.Packages.Net[RE/TeleportService/Reconnect]")
            end
        end
    end
    
    -- Monitor for these remotes being added later
    game.DescendantAdded:Connect(function(obj)
        if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") then
            task.wait(0.1)
            local fullName = obj:GetFullName()
            
            if string.find(fullName, "Replion") and string.find(fullName, "Removed") then
                local old = hookmetamethod(game, '__namecall', function(self, ...)
                    if self == obj and (getnamecallmethod() == "FireServer" or getnamecallmethod() == "InvokeServer") then
                        if antiKickEnabled then
                            print("🛡️ BLOCKED: New Replion.Removed remote attempt")
                            warn("blocked the kick!")
                            return nil
                        end
                    end
                    return old(self, ...)
                end)
                print("🛡️ Hooked new Replion remote:", fullName)
                
            elseif string.find(fullName, "TeleportService") and string.find(fullName, "Reconnect") then
                local old = hookmetamethod(game, '__namecall', function(self, ...)
                    if self == obj and (getnamecallmethod() == "FireServer" or getnamecallmethod() == "InvokeServer") then
                        if antiKickEnabled then
                            print("🛡️ BLOCKED: New TeleportService/Reconnect remote attempt")
                            warn("blocked the kick!")
                            return nil
                        end
                    end
                    return old(self, ...)
                end)
                print("🛡️ Hooked new TeleportService remote:", fullName)
            end
        end
    end)
end

-- ULTIMATE KICK METHOD HOOKING (COMPREHENSIVE)
local function hookAllKickMethods()
    local old = hookmetamethod(game, "__namecall", function(self, ...)
        local method = getnamecallmethod()
        local args = {...}
        
        if not antiKickEnabled then
            return old(self, ...)
        end
        
        -- Check if method is in our comprehensive kick list
        for _, kickMethod in pairs(kickMethods) do
            if method == kickMethod then
                print("🛡️ BLOCKED: " .. method .. " method blocked on", self.Name or tostring(self))
                warn("blocked the kick!")
                return nil
            end
        end
        
        -- Special handling for Player:Kick specifically
        if method == "Kick" and self == player then
            print("🛡️ BLOCKED: Player:Kick() attempt on local player")
            warn("blocked the kick!")
            return nil
        end
        
        -- Check for RemoteEvent/RemoteFunction kick attempts
        if method == "FireServer" or method == "InvokeServer" then
            -- Check remote name against specific blocked remotes
            local remoteName = self.Name or ""
            local remoteFullName = self:GetFullName() or ""
            
            for _, blockedRemote in pairs(specificRemotesToBlock) do
                if string.find(remoteName, blockedRemote) or string.find(remoteFullName, blockedRemote) then
                    print("🛡️ BLOCKED: Blocked remote detected - " .. blockedRemote .. " in " .. remoteFullName)
                    warn("blocked the kick!")
                    return nil
                end
            end
            
            -- Check arguments for kick patterns
            for i, arg in pairs(args) do
                if type(arg) == "string" then
                    local lower = string.lower(arg)
                    
                    -- Check against all kick patterns
                    for _, pattern in pairs(kickPatterns) do
                        if string.find(lower, string.lower(pattern)) then
                            print("🛡️ BLOCKED: " .. method .. " with kick pattern: " .. pattern .. " in argument: " .. tostring(arg))
                            warn("blocked the kick!")
                            return nil
                        end
                    end
                    
                elseif type(arg) == "number" then
                    -- Check for kick error codes
                    for _, errorCode in pairs(kickErrorCodes) do
                        if arg == errorCode then
                            print("🛡️ BLOCKED: " .. method .. " with kick error code: " .. tostring(arg))
                            warn("blocked the kick!")
                            return nil
                        end
                    end
                    
                    -- Check for place IDs (potential teleportation)
                    if arg > 1000000 and arg < 999999999999 then
                        print("🛡️ BLOCKED: " .. method .. " with potential place ID: " .. tostring(arg))
                        warn("blocked the kick!")
                        return nil
                    end
                    
                elseif type(arg) == "table" then
                    -- Check table contents recursively
                    local function checkTable(t, depth)
                        if depth > 10 then return false end -- Prevent infinite recursion
                        
                        for k, v in pairs(t) do
                            if type(v) == "string" then
                                local lower = string.lower(v)
                                for _, pattern in pairs(kickPatterns) do
                                    if string.find(lower, string.lower(pattern)) then
                                        return true
                                    end
                                end
                            elseif type(v) == "number" then
                                for _, errorCode in pairs(kickErrorCodes) do
                                    if v == errorCode then
                                        return true
                                    end
                                end
                            elseif type(v) == "table" then
                                if checkTable(v, depth + 1) then 
                                    return true 
                                end
                            end
                        end
                        return false
                    end
                    
                    if checkTable(arg, 0) then
                        print("🛡️ BLOCKED: " .. method .. " with table containing kick data")
                        warn("blocked the kick!")
                        return nil
                    end
                end
            end
        end
        
        -- Block TeleportService methods
        if self == TeleportService then
            local teleportMethods = {
                "Teleport", "TeleportAsync", "TeleportToPlaceInstance", 
                "TeleportToPrivateServer", "TeleportPartyAsync", "TeleportToSpawnByName"
            }
            
            for _, teleMethod in pairs(teleportMethods) do
                if method == teleMethod then
                    -- Check if local player is being teleported
                    for _, arg in pairs(args) do
                        if arg == player or (type(arg) == "table" and table.find(arg, player)) then
                            print("🛡️ BLOCKED: TeleportService." .. method .. " attempt on local player")
                            warn("blocked the kick!")
                            return nil
                        end
                    end
                end
            end
        end
        
        -- Block game shutdown methods
        if self == game and (method == "Shutdown" or method == "shutdown") then
            print("🛡️ BLOCKED: game:Shutdown() attempt")
            warn("blocked the kick!")
            return nil
        end
        
        return old(self, ...)
    end)
end

-- MONITOR AND PROTECT AGAINST CHARACTER/PLAYER DESTRUCTION
local function protectPlayerAndCharacter()
    -- Protect player object
    if player then
        local playerMetatable = getmetatable(player) or {}
        local originalDestroy = player.Destroy
        
        player.Destroy = function(...)
            if antiKickEnabled then
                print("🛡️ BLOCKED: Player:Destroy() attempt")
                warn("blocked the kick!")
                return
            end
            return originalDestroy(...)
        end
    end
    
    -- Protect character
    local function protectCharacter(character)
        if character then
            local originalDestroy = character.Destroy
            character.Destroy = function(...)
                if antiKickEnabled then
                    print("🛡️ BLOCKED: Character:Destroy() attempt")
                    warn("blocked the kick!")
                    return
                end
                return originalDestroy(...)
            end
        end
    end
    
    if player.Character then
        protectCharacter(player.Character)
    end
    
    player.CharacterAdded:Connect(protectCharacter)
end

-- MAINTAIN PROTECTION WITH ADVANCED MONITORING
task.spawn(function()
    while antiKickEnabled do
        -- Ensure player is still connected
        if not player or not player.Parent or player.Parent ~= Players then
            print("⚠️ Player disconnection detected - anti-kick may have failed")
            break
        end
        
        -- Check for character
        if not player.Character and player.Parent == Players then
            print("🛡️ Character missing - attempting restoration...")
            pcall(function()
                player:LoadCharacter()
            end)
        end
        
        -- Periodic re-initialization (every 30 seconds)
        if math.random(1, 30) == 1 then
            pcall(function()
                hookAllKickMethods()
                blockSpecificRemotes()
                print("🛡️ Anti-kick protection renewed")
            end)
        end
        
        task.wait(1)
    end
end)

-- Initialize anti-kick system
pcall(hookAllKickMethods)
pcall(blockSpecificRemotes)
pcall(protectPlayerAndCharacter)

print("🚀 Enhanced Steal-A-Brainrot loaded successfully!")
print("📋 Features:")
print("   • 📷 FLOAT - Platform under player with slow fall")
print("   • 📷 FLOOR STEAL - See through walls")
print("   • 💰 Steal - Tween to base at 40 studs/second")
print("   • 🛡️ Anti-kick protection")
print("   • 🎣 Automatic grapple hook integration")
print("   • ⚡ Advanced wall detection and pathfinding")
print("   • 🚨 Emergency stop (ESC key)")
print("   • Double-tap space while floating for enhanced jump!")
print("   • 📊 Complete ESP system for plots and players")
print("⚡ Ready to dominate! ⚡")

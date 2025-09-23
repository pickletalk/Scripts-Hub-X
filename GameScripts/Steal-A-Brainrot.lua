-- Optimized and secured script for Steal A Brainrot
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

-- Anti-Kick Methods
local kickMethods = {
    "kick", "Kick", "KICK", "KickPlayer", "kickplayer", "kick_player", "kickClient", "KickClient",
    "PlayerKick", "player_kick", "PLAYER_KICK", "kickUser", "KickUser", "kick_user",
    "clientKick", "ClientKick", "CLIENT_KICK", "userKick", "UserKick", "USER_KICK",
    "remove", "Remove", "REMOVE", "RemovePlayer", "removeplayer", "remove_player",
    "disconnect", "Disconnect", "DISCONNECT", "DisconnectPlayer", "disconnectplayer",
    "disconnect_player", "PlayerDisconnect", "player_disconnect", "PLAYER_DISCONNECT",
    "RemoveClient", "removeclient", "remove_client", "REMOVE_CLIENT",
    "clientDisconnect", "ClientDisconnect", "CLIENT_DISCONNECT", "userRemove", "UserRemove",
    "destroy", "Destroy", "DESTROY", "DestroyPlayer", "destroyplayer", "destroy_player",
    "delete", "Delete", "DELETE", "DeletePlayer", "deleteplayer", "delete_player",
    "teleport", "Teleport", "TELEPORT", "TeleportPlayer", "teleportplayer", "teleport_player",
    "TeleportClient", "teleportclient", "teleport_client", "TELEPORT_CLIENT",
    "ServerHop", "serverhop", "server_hop", "SERVER_HOP", "rejoin", "Rejoin", "REJOIN",
    "ReconnectPlayer", "reconnectplayer", "reconnect_player", "RECONNECT_PLAYER",
    "TeleportToSpawnByName", "TeleportToPrivateServer", "TeleportAsync", "TeleportPartyAsync",
    "TeleportToPlaceInstance", "serverSwitch", "ServerSwitch", "SERVER_SWITCH",
    "changeServer", "ChangeServer", "CHANGE_SERVER", "switchServer", "SwitchServer",
    "migrate", "Migrate", "MIGRATE", "MigratePlayer", "migrateplayer", "migrate_player",
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
    "AntiCheat", "anticheat", "ANTICHEAT",
    "AC", "ac", "SecurityCheck", "securitycheck",
    "Validate", "validate", "VALIDATE",
    "CheckClient", "checkclient", "CHECK_CLIENT",
    "VerifyClient", "verifyclient", "VERIFY_CLIENT"
}

-- KICK PATTERN STRINGS TO DETECT IN ARGUMENTS
local kickPatterns = {
    "kick", "ban", "remove", "disconnect", "teleport", "rejoin", "serverhop", "server hop",
    "hop", "leave", "exit", "quit", "punish", "suspend", "terminate", "boot", "eject",
    "expel", "exile", "admin", "moderator", "mod", "staff", "owner", "anticheat", "cheat",
    "exploit", "hack", "script", "violation", "error", "crash", "freeze", "lag", "timeout",
    "eliminated", "disqualified", "blacklisted", "restricted", "blocked", "denied", "rejected",
    "shutdown", "restart", "reboot", "filtering", "localscript", "clientside", "security",
    "auto", "system", "network", "connection", "ping", "latency", "game", "match", "room",
    "lobby", "server", "instance", "fe", "client", "user", "player", "destroyplayer",
    "you have been kicked", "banned from", "disconnected", "connection lost", "timed out",
    "cheat detected", "exploit detected", "script detected", "violation detected", "unauthorized",
    "access denied", "permission denied", "invalid client", "client verification failed",
    "anti-cheat violation", "security breach", "suspicious activity", "abnormal behavior"
}

-- Error codes that cause kicks
local kickErrorCodes = {
    267, 268, 269, 270, 271, 272, 273, 274, 275, 276, 277, 278, 279, 280, 
    529, 610, 611, 612, 613, 614, 615, 616, 617, 618, 619, 620,
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

-- Performance optimization variables
local lastUpdateTime = 0
local updateInterval = 0.1 -- Update every 0.1 seconds instead of every frame
local spoofedHRP = {
    Velocity = Vector3.new(0,0,0),
    CFrame = CFrame.new(),
    Position = Vector3.new()
}

-- Store original methods
local oldTeleport = TeleportService.Teleport
local oldTeleportToPrivateServer = TeleportService.TeleportToPrivateServer
local oldTeleportAsync = TeleportService.TeleportAsync
local oldTeleportPartyAsync = TeleportService.TeleportPartyAsync
local oldTeleportToPlaceInstance = TeleportService.TeleportToPlaceInstance

-- Store original metamethods
local originalIndex
local originalNewIndex

-- Hook __index to spoof checks and block kicks
originalIndex = hookmetamethod(game, "__index", newcclosure(function(self, property)
    -- Block kick methods
    if kickMethods[property] then
        return function() end
    end
    
    -- Spoof HumanoidRootPart checks
    if self and self:IsA("HumanoidRootPart") then
        if property == "Velocity" then
            return spoofedHRP.Velocity
        elseif property == "CFrame" then
            return spoofedHRP.CFrame
        elseif property == "Position" then
            return spoofedHRP.Position
        end
    end
    
    -- Block specific remote events
    if self and (self:IsA("RemoteEvent") or self:IsA("RemoteFunction")) then
        for _, name in pairs(specificRemotesToBlock) do
            if self.Name:lower():find(name:lower()) then
                if property == "FireServer" or property == "InvokeServer" then
                    return function() end
                end
            end
        end
    end
    
    return originalIndex(self, property)
end))

-- Hook __newindex to prevent setting kick-related properties
originalNewIndex = hookmetamethod(game, "__newindex", newcclosure(function(self, property, value)
    -- Block setting kick-related properties
    if kickMethods[property] then
        return
    end
    
    -- Block setting HumanoidRootPart properties that would reveal our manipulation
    if self and self:IsA("HumanoidRootPart") then
        if property == "Velocity" or property == "CFrame" or property == "Position" then
            -- Store the value but don't actually set it
            spoofedHRP[property] = value
            return
        end
    end
    
    return originalNewIndex(self, property, value)
end))

-- Block TeleportService methods
TeleportService.Teleport = newcclosure(function(...)
    return
end)

TeleportService.TeleportToPrivateServer = newcclosure(function(...)
    return
end)

TeleportService.TeleportAsync = newcclosure(function(...)
    return
end)

TeleportService.TeleportPartyAsync = newcclosure(function(...)
    return
end)

TeleportService.TeleportToPlaceInstance = newcclosure(function(...)
    return
end)

-- Optimized update function for performance
local function optimizedUpdate()
    local currentTime = tick()
    
    -- Only update at intervals to reduce lag
    if currentTime - lastUpdateTime < updateInterval then
        return
    end
    
    lastUpdateTime = currentTime
    
    -- Update spoofed HumanoidRootPart values
    if rootPart then
        spoofedHRP.Position = rootPart.Position
        spoofedHRP.CFrame = rootPart.CFrame
        
        -- Only spoof velocity when using our features
        if platformEnabled or wallTransparencyEnabled or tweenToBaseEnabled then
            spoofedHRP.Velocity = Vector3.new(0, 0, 0)
        else
            spoofedHRP.Velocity = rootPart.Velocity
        end
    end
    
    -- Update platform positions if enabled
    if platformEnabled and currentPlatform then
        updatePlatformPosition()
    end
    
    if comboFloatEnabled and comboCurrentPlatform then
        updateComboPlatformPosition()
    end
end

-- Create optimized heartbeat connection
local heartbeatConnection = RunService.Heartbeat:Connect(optimizedUpdate)

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
stealButton.Text = "💰 TWEEN TO BASE (BETA) 💰"
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

-- FIXED CARPET TELEPORT SYSTEM
-- FIXED PHYSICS-BASED MOVEMENT SYSTEM
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
    
    -- Find carpet
    local carpet = workspace:FindFirstChild("Map")
    if carpet then
        carpet = carpet:FindFirstChild("Carpet")
    end
    
    if not carpet then
        warn("❌ Carpet not found in workspace.Map.Carpet")
        return
    end
    
    -- Find player plot
    local playerPlot = findPlayerPlot()
    if not playerPlot then
        warn("❌ Could not find player's base plot")
        return
    end

    -- FIXED: Properly control character physics
    if humanoid then
        humanoid.PlatformStand = true -- Disable normal physics
    end
    
    -- Calculate positions
    local startPosition = humanoidRootPart.Position
    local carpetPosition = carpet.Position + Vector3.new(0, 40, 0) -- 20 studs above carpet
    local basePosition = playerPlot.Position + Vector3.new(0, 5, 0)
    
    print("💰 Starting carpet teleport mission...")
    print("📍 From: " .. tostring(startPosition))
    print("🟫 Carpet: " .. tostring(carpetPosition))
    print("🎯 Base: " .. tostring(basePosition))
    
    tweenToBaseEnabled = true
    stealButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    stealButton.Text = "🔥 Tweening..."
    
    -- Start grapple hook loop
    stealGrappleConnection = task.spawn(function()
        while tweenToBaseEnabled do
            equipAndFireGrapple()
            task.wait(3)
        end
    end)

    -- PHASE 2: Move to base at 15 studs/second
    local function moveToBase()
        if not tweenToBaseEnabled then return end
        
        -- Update position in case character moved slightly
        local currentPos = humanoidRootPart.Position
        local baseDistance = (basePosition - currentPos).Magnitude
        local baseTime = baseDistance / 15 -- 15 studs per second to base
        
        print("🎯 Phase 2: Moving to base")
        print("📏 Distance to base: " .. math.floor(baseDistance) .. " studs")
        print("⏱️ Time to base: " .. string.format("%.1f", baseTime) .. "s at 15 studs/sec")
        
        -- FIXED: Use BodyVelocity for base movement too
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        
        -- Calculate velocity direction for 15 studs/second
        local direction = (basePosition - humanoidRootPart.Position).Unit
        bodyVelocity.Velocity = direction * 15 -- 15 studs per second
        bodyVelocity.Parent = humanoidRootPart
        
        -- Timer for base movement
        local baseTimer = task.spawn(function()
            task.wait(baseTime)
            
            -- Stop movement
            if bodyVelocity and bodyVelocity.Parent then
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                task.wait(0.1) -- Brief stop
                bodyVelocity:Destroy()
            end
            
            -- Mission completed
            tweenToBaseEnabled = false
            stealButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
            stealButton.Text = "💰 STEAL (BETA) 💰"
            
            if stealGrappleConnection then
                task.cancel(stealGrappleConnection)
                stealGrappleConnection = nil
            end
            
            -- FIXED: Restore normal character physics
            if humanoid then
                humanoid.PlatformStand = false -- Re-enable normal physics
            end
            
            print("✅ Successfully reached base via carpet! 💰")
        end)
        
        -- Store current operation for cleanup
        currentTween = {
            Cancel = function()
                if baseTimer then
                    task.cancel(baseTimer)
                end
                if bodyVelocity and bodyVelocity.Parent then
                    bodyVelocity:Destroy()
                end
            end
        }
    end
    
    -- PHASE 1: Move to carpet at 15 studs/second
    local function moveToCarpet()
        if not tweenToBaseEnabled then return end
        
        local carpetDistance = (carpetPosition - humanoidRootPart.Position).Magnitude
        local carpetTime = carpetDistance / 15 -- 15 studs per second to carpet
        
        print("🟫 Phase 1: Moving to carpet")
        print("📏 Distance to carpet: " .. math.floor(carpetDistance) .. " studs")
        print("⏱️ Time to carpet: " .. string.format("%.1f", carpetTime) .. "s at 15 studs/sec")
        
        -- FIXED: Use BodyVelocity for smooth physics-based movement
        local bodyVelocity = Instance.new("BodyVelocity")
        bodyVelocity.MaxForce = Vector3.new(4000, 4000, 4000)
        
        -- Calculate velocity direction for 15 studs/second
        local direction = (carpetPosition - humanoidRootPart.Position).Unit
        bodyVelocity.Velocity = direction * 15 -- 15 studs per second
        bodyVelocity.Parent = humanoidRootPart
        
        -- Timer to stop movement and proceed to next phase
        local carpetTimer = task.spawn(function()
            task.wait(carpetTime)
            
            -- Stop movement
            if bodyVelocity and bodyVelocity.Parent then
                bodyVelocity.Velocity = Vector3.new(0, 0, 0)
                task.wait(0.1) -- Brief stop
                bodyVelocity:Destroy()
            end
            
            if tweenToBaseEnabled then
                print("✅ Reached carpet! Starting teleport to base...")
                task.wait(0.1) -- Brief pause at carpet
                moveToBase()
            end
        end)
        
        -- Store current operation for cleanup
        currentTween = {
            Cancel = function()
                if carpetTimer then
                    task.cancel(carpetTimer)
                end
                if bodyVelocity and bodyVelocity.Parent then
                    bodyVelocity:Destroy()
                end
            end
        }
    end
    
    -- Start the two-phase movement
    moveToCarpet()
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
    
    updatePlatformPosition()

    -- Start the continuous loop for both equipping and firing
    if not grappleHookConnection then
        grappleHookConnection = task.spawn(function()
            while platformEnabled do
                task.wait(2)
                equipAndFireGrapple()
            end
        end)
        print("- Continuously firing grapple hook RemoteEvent every 3 seconds")
    end
    
    floatButton.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
    floatButton.Text = "🚹 FLOAT 🚹"
end

local function disablePlatform()
    if not platformEnabled then return end

    platformEnabled = false
    
    -- Remove slow fall effect
    removeSlowFall()
    
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
    floatButton.Text = "🚹 FLOAT 🚹"
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
    wallButton.Text = "💰 FLOOR STEAL 💰"
end

local function disableWallTransparency()
    if not wallTransparencyEnabled then return end
    
    print("Disabling wall transparency...")
    wallTransparencyEnabled = false
    comboFloatEnabled = false
    
    makeWallsTransparent(false)
    originalTransparencies = {}
    
    -- Stop platform updates and remove platform
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
    wallButton.Text = "💰 FLOOR STEAL 💰"
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
    if tweenToBaseEnabled then
        if currentTween then
            currentTween:Cancel()
        end
        
        tweenToBaseEnabled = false
        stealButton.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
        stealButton.Text = "💰 TWEEN TO BASE (BETA) 💰"
        
        if stealGrappleConnection then
            task.cancel(stealGrappleConnection)
            stealGrappleConnection = nil
        end
        
        -- Restore character physics
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid.PlatformStand = false
            end
        end
        
        print("✅ Tween stopped successfully")
    else
        -- Start tweening
        print("💰 Steal button clicked - starting tween")
        tweenToBase()
    end
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
    if heartbeatConnection then heartbeatConnection:Disconnect() end
    
    -- Restore original functions
    TeleportService.Teleport = oldTeleport
    TeleportService.TeleportToPrivateServer = oldTeleportToPrivateServer
    TeleportService.TeleportAsync = oldTeleportAsync
    TeleportService.TeleportPartyAsync = oldTeleportPartyAsync
    TeleportService.TeleportToPlaceInstance = oldTeleportToPlaceInstance
    
    -- Restore original metamethods
    if originalIndex then
        hookmetamethod(game, "__index", originalIndex)
    end
    if originalNewIndex then
        hookmetamethod(game, "__newindex", originalNewIndex)
    end
    
    removeSlowFall()
    
    screenGui:Destroy()
    
    print("❌ Script closed and cleaned up")
end)

-- Add hover effects to buttons
local function addHoverEffect(button, hoverColor, originalColor)
    button.MouseEnter:Connect(function()
        button.BackgroundColor3 = hoverColor
    end)
    
    button.MouseLeave:Connect(function()
        button.BackgroundColor3 = originalColor
    end)
end

addHoverEffect(floatButton, Color3.fromRGB(0, 50, 150), Color3.fromRGB(0, 0, 0))
addHoverEffect(wallButton, Color3.fromRGB(200, 70, 0), Color3.fromRGB(0, 0, 0))
addHoverEffect(closeButton, Color3.fromRGB(220, 70, 70), Color3.fromRGB(200, 50, 50))

-- Setup ESP and plot displays
Players.PlayerAdded:Connect(function(player)
    createPlayerDisplay(player)
end)

for _, player in pairs(Players:GetPlayers()) do
    createPlayerDisplay(player)
end

-- Update plots periodically
local plotUpdateConnection = task.spawn(function()
    while true do
        updateAllPlots()
        task.wait(0.1)
    end
end)

-- Character event handling
player.CharacterAdded:Connect(onCharacterAdded)

-- Initialize
onCharacterAdded(player.Character)
removeJumpDelay()

-- Super Overpowered Roblox Hack Script (Server-Side Exploits, Mobile-Friendly)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Create Mobile-Friendly UI
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "SuperOverpoweredHackUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0.5, 0, 0.7, 0)
Frame.Position = UDim2.new(0.25, 0, 0.15, 0)
Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(0.9, 0, 0.1, 0)
Title.Position = UDim2.new(0.05, 0, 0.02, 0)
Title.BackgroundTransparency = 1
Title.Text = "Super Overpowered Hack v2.0"
Title.TextColor3 = Color3.new(1, 0, 0)
Title.TextScaled = true
Title.Font = Enum.Font.SourceSansBold

local LogFrame = Instance.new("ScrollingFrame", Frame)
LogFrame.Size = UDim2.new(0.9, 0, 0.35, 0)
LogFrame.Position = UDim2.new(0.05, 0, 0.6, 0)
LogFrame.BackgroundTransparency = 0.3
LogFrame.BackgroundColor3 = Color3.new(0, 0, 0)
LogFrame.ScrollBarThickness = 4
LogFrame.CanvasSize = UDim2.new(0, 0, 2, 0)

local LogLabel = Instance.new("TextLabel", LogFrame)
LogLabel.Size = UDim2.new(1, 0, 0, 0)
LogLabel.Position = UDim2.new(0, 0, 0, 0)
LogLabel.BackgroundTransparency = 1
LogLabel.TextColor3 = Color3.new(1, 1, 1)
LogLabel.TextScaled = true
LogLabel.TextYAlignment = Enum.TextYAlignment.Top
LogLabel.Text = ""

local logOffset = 0
local function log(message)
    LogLabel.Text = LogLabel.Text .. "\n" .. message
    logOffset = logOffset + 25
    LogLabel.Size = UDim2.new(1, 0, 0, logOffset)
    LogFrame.CanvasSize = UDim2.new(0, 0, 0, logOffset)
    LogFrame.CanvasPosition = Vector2.new(0, logOffset)
end

local function createButton(name, position, callback)
    local Button = Instance.new("TextButton", Frame)
    Button.Size = UDim2.new(0.45, 0, 0.08, 0)
    Button.Position = position
    Button.Text = name
    Button.TextColor3 = Color3.new(1, 1, 1)
    Button.BackgroundColor3 = Color3.new(1, 0, 0)
    Button.BackgroundTransparency = 0.3
    Button.BorderSizePixel = 0
    Button.TextScaled = true
    Button.Font = Enum.Font.SourceSans

    Button.MouseButton1Click:Connect(function()
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
        local tween = TweenService:Create(Button, tweenInfo, { Size = UDim2.new(0.48, 0, 0.09, 0), BackgroundTransparency = 0.1 })
        tween:Play()
        wait(0.3)
        local resetTween = TweenService:Create(Button, tweenInfo, { Size = UDim2.new(0.45, 0, 0.08, 0), BackgroundTransparency = 0.3 })
        resetTween:Play()
        callback()
    end)
end

-- UI Animation
local tweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local tween = TweenService:Create(Frame, tweenInfo, { Position = UDim2.new(0.25, 0, 0.15, 0), BackgroundTransparency = 0.2 })
tween:Play()

-- Server-Side Exploit Function
local function serverExploit(command, args)
    local remote = Instance.new("RemoteEvent", ReplicatedStorage)
    remote.Name = "ExploitRemote" .. HttpService:GenerateGUID(false)
    remote:FireServer(command, args)
    log("Server Exploit: " .. command .. " | Args: " .. HttpService:JSONEncode(args))
end

-- Hack Features
local function toggleGodMode()
    serverExploit("SetGodMode", { Player = LocalPlayer.Name, Enabled = true })
    log("God Mode: ON (Invincible)")
end

local function toggleFly()
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local RootPart = Character:WaitForChild("HumanoidRootPart")
    local flying = not RootPart:FindFirstChild("BodyVelocity")
    if flying then
        local bodyVelocity = Instance.new("BodyVelocity", RootPart)
        bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
        serverExploit("SyncFly", { Player = LocalPlayer.Name, Enabled = true })
    else
        RootPart:FindFirstChild("BodyVelocity"):Destroy()
        serverExploit("SyncFly", { Player = LocalPlayer.Name, Enabled = false })
    end
    log("Fly Hack: " .. (flying and "ON" or "OFF"))
end

local function toggleESP()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            local Billboard = Instance.new("BillboardGui", v.Character)
            Billboard.Size = UDim2.new(0, 100, 0, 100)
            local TextLabel = Instance.new("TextLabel", Billboard)
            TextLabel.Size = UDim2.new(1, 0, 1, 0)
            TextLabel.BackgroundTransparency = 1
            TextLabel.Text = v.Name
            TextLabel.TextColor3 = Color3.new(1, 0, 0)
            serverExploit("SyncESP", { Player = v.Name, Enabled = true })
        end
    end
    log("ESP Hack: ON (All Players)")
end

local function kickPlayer()
    local playerName = UserInputService:GetStringInput("Enter player name to kick:")
    if playerName then
        serverExploit("KickPlayer", { Target = playerName, Reason = "Kicked by Overpowered Hack!" })
        log("Kicked player: " .. playerName)
    end
end

local function banPlayer()
    local playerName = UserInputService:GetStringInput("Enter player name to ban:")
    local duration = UserInputService:GetStringInput("Enter ban duration (seconds):")
    local reason = UserInputService:GetStringInput("Enter ban reason:")
    if playerName and duration and reason then
        serverExploit("BanPlayer", { Target = playerName, Duration = tonumber(duration), Reason = reason })
        log("Banned player: " .. playerName .. " for " .. duration .. "s - Reason: " .. reason)
    end
end

local function flingAll()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            serverExploit("FlingPlayer", { Target = v.Name, Force = Vector3.new(math.random(-1000, 1000), 1000, math.random(-1000, 1000)) })
        end
    end
    log("Flung all players!")
end

local function flingPlayer()
    local playerName = UserInputService:GetStringInput("Enter player name to fling:")
    if playerName then
        local target = Players:FindFirstChild(playerName)
        if target then
            serverExploit("FlingPlayer", { Target = playerName, Force = Vector3.new(math.random(-1000, 1000), 1000, math.random(-1000, 1000)) })
            log("Flung player: " .. playerName)
        else
            log("Player not found: " .. playerName)
        end
    end
end

local function teleportToPlayer()
    local targetName = UserInputService:GetStringInput("Enter player name to teleport to:")
    if targetName then
        local target = Players:FindFirstChild(targetName)
        if target and target.Character then
            serverExploit("TeleportPlayer", { Player = LocalPlayer.Name, TargetPos = target.Character.HumanoidRootPart.Position })
            log("Teleported to: " .. targetName)
        else
            log("Player not found: " .. targetName)
        end
    end
end

local function crashServer()
    serverExploit("CrashServer", { Reason = "Server crashed by Overpowered Hack!" })
    log("Server Crash Initiated!")
end

local function giveAdmin()
    serverExploit("GrantAdmin", { Player = LocalPlayer.Name, Level = "Full" })
    log("Admin Privileges Granted!")
end

local function spawnItem()
    local itemName = UserInputService:GetStringInput("Enter item name to spawn:")
    if itemName then
        serverExploit("SpawnItem", { Player = LocalPlayer.Name, Item = itemName })
        log("Spawned item: " .. itemName)
    end
end

local function spamChat()
    local message = UserInputService:GetStringInput("Enter message to spam:")
    if message then
        for i = 1, 10 do
            serverExploit("ChatMessage", { Player = LocalPlayer.Name, Message = message })
            wait(0.1)
        end
        log("Spammed chat: " .. message)
    end
end

local function trollDisco()
    serverExploit("EnvironmentEffect", { Type = "Disco", Enabled = true })
    log("Disco Troll: ON (Flashing Lights)")
end

local function trollGravity()
    serverExploit("SetGravity", { Value = math.random(0, 100) })
    log("Gravity Troll: Set to random value")
end

local function trollSound()
    local soundId = UserInputService:GetStringInput("Enter sound ID to play globally:")
    if soundId then
        serverExploit("PlaySound", { SoundId = "rbxassetid://" .. soundId, Volume = 10 })
        log("Troll Sound Played: ID " .. soundId)
    end
end

local remoteSpyActive = false
local function toggleRemoteSpy()
    remoteSpyActive = not remoteSpyActive
    if remoteSpyActive then
        local function logRemote(remote, args)
            log("Server Remote: " .. remote.Name .. " | Args: " .. HttpService:JSONEncode(args))
        end
        for _, v in pairs(game:GetDescendants()) do
            if v:IsA("RemoteEvent") or v:IsA("RemoteFunction") then
                v.OnServerEvent:Connect(function(player, ...)
                    logRemote(v, {...})
                end)
            end
        end
        game.DescendantAdded:Connect(function(descendant)
            if descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction") then
                descendant.OnServerEvent:Connect(function(player, ...)
                    logRemote(descendant, {...})
                end)
            end
        end)
        log("Remote Spy: ON (All Server Remotes)")
    else
        log("Remote Spy: OFF")
    end
end

-- Create Buttons (Three Columns for Readability)
createButton("God Mode", UDim2.new(0.05, 0, 0.15, 0), toggleGodMode)
createButton("Toggle Fly", UDim2.new(0.35, 0, 0.15, 0), toggleFly)
createButton("Toggle ESP", UDim2.new(0.65, 0, 0.15, 0), toggleESP)
createButton("Teleport", UDim2.new(0.05, 0, 0.25, 0), teleportToPlayer)
createButton("Fling All", UDim2.new(0.35, 0, 0.25, 0), flingAll)
createButton("Fling Player", UDim2.new(0.65, 0, 0.25, 0), flingPlayer)
createButton("Kick Player", UDim2.new(0.05, 0, 0.35, 0), kickPlayer)
createButton("Ban Player", UDim2.new(0.35, 0, 0.35, 0), banPlayer)
createButton("Crash Server", UDim2.new(0.65, 0, 0.35, 0), crashServer)
createButton("Give Admin", UDim2.new(0.05, 0, 0.45, 0), giveAdmin)
createButton("Spawn Item", UDim2.new(0.35, 0, 0.45, 0), spawnItem)
createButton("Spam Chat", UDim2.new(0.65, 0, 0.45, 0), spamChat)
createButton("Disco Troll", UDim2.new(0.05, 0, 0.55, 0), trollDisco)
createButton("Gravity Troll", UDim2.new(0.35, 0, 0.55, 0), trollGravity)
createButton("Sound Troll", UDim2.new(0.65, 0, 0.55, 0), trollSound)
createButton("Remote Spy", UDim2.new(0.05, 0, 0.65, 0), toggleRemoteSpy)

-- Mobile Input Handling
UserInputService.TextBoxFocused:Connect(function(textbox)
    log("Input focused: " .. textbox.Name)
end)

log("Super Overpowered Hack v2.0 Loaded! Ready to dominate.")

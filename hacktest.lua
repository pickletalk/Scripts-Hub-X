-- Super Overpowered Roblox Hack Script (Server-Side Exploits, Mobile-Friendly with Tabs)
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local LocalPlayer = Players.LocalPlayer

-- Create Mobile-Friendly UI with Tabs
local ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
ScreenGui.Name = "SuperOverpoweredHackUI"
ScreenGui.ResetOnSpawn = false

local Frame = Instance.new("Frame", ScreenGui)
Frame.Size = UDim2.new(0.6, 0, 0.8, 0)
Frame.Position = UDim2.new(0.2, 0, 0.1, 0)
Frame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
Frame.BackgroundTransparency = 0.2
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.Draggable = true

local Title = Instance.new("TextLabel", Frame)
Title.Size = UDim2.new(0.9, 0, 0.1, 0)
Title.Position = UDim2.new(0.05, 0, 0.02, 0)
Title.BackgroundTransparency = 1
Title.Text = "Super Overpowered Hack v2.1"
Title.TextColor3 = Color3.new(1, 0, 0)
Title.TextScaled = true
Title.Font = Enum.Font.SourceSansBold

local TabFrame = Instance.new("Frame", Frame)
TabFrame.Size = UDim2.new(0.9, 0, 0.1, 0)
TabFrame.Position = UDim2.new(0.05, 0, 0.12, 0)
TabFrame.BackgroundTransparency = 0.3
TabFrame.BackgroundColor3 = Color3.new(0, 0, 0)

local ContentFrame = Instance.new("Frame", Frame)
ContentFrame.Size = UDim2.new(0.9, 0, 0.75, 0)
ContentFrame.Position = UDim2.new(0.05, 0, 0.23, 0)
ContentFrame.BackgroundTransparency = 0.3
ContentFrame.BackgroundColor3 = Color3.new(0, 0, 0)
ContentFrame.ClipsDescendants = true

local LogFrame = Instance.new("ScrollingFrame", Frame)
LogFrame.Size = UDim2.new(0.9, 0, 0.1, 0)
LogFrame.Position = UDim2.new(0.05, 0, 0.85, 0)
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

local function createTabButton(name, position)
    local TabButton = Instance.new("TextButton", TabFrame)
    TabButton.Size = UDim2.new(0.2, 0, 1, 0)
    TabButton.Position = position
    TabButton.Text = name
    TabButton.TextColor3 = Color3.new(1, 1, 1)
    TabButton.BackgroundColor3 = Color3.new(0.5, 0, 0)
    TabButton.BackgroundTransparency = 0.4
    TabButton.BorderSizePixel = 0
    TabButton.TextScaled = true
    TabButton.Font = Enum.Font.SourceSans
    return TabButton
end

local function createButton(name, position, callback)
    local Button = Instance.new("TextButton", ContentFrame)
    Button.Size = UDim2.new(0.45, 0, 0.1, 0)
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
        local tween = TweenService:Create(Button, tweenInfo, { Size = UDim2.new(0.48, 0, 0.12, 0), BackgroundTransparency = 0.1 })
        tween:Play()
        wait(0.3)
        local resetTween = TweenService:Create(Button, tweenInfo, { Size = UDim2.new(0.45, 0, 0.1, 0), BackgroundTransparency = 0.3 })
        resetTween:Play()
        callback()
    end)
end

local function createInputButton(name, position, callback)
    local InputButton = Instance.new("TextButton", ContentFrame)
    InputButton.Size = UDim2.new(0.45, 0, 0.1, 0)
    InputButton.Position = position
    InputButton.Text = name
    InputButton.TextColor3 = Color3.new(1, 1, 1)
    InputButton.BackgroundColor3 = Color3.new(1, 0, 0)
    InputButton.BackgroundTransparency = 0.3
    InputButton.BorderSizePixel = 0
    InputButton.TextScaled = true
    InputButton.Font = Enum.Font.SourceSans

    InputButton.MouseButton1Click:Connect(function()
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Bounce, Enum.EasingDirection.Out)
        local tween = TweenService:Create(InputButton, tweenInfo, { Size = UDim2.new(0.48, 0, 0.12, 0), BackgroundTransparency = 0.1 })
        tween:Play()
        wait(0.3)
        local resetTween = TweenService:Create(InputButton, tweenInfo, { Size = UDim2.new(0.45, 0, 0.1, 0), BackgroundTransparency = 0.3 })
        resetTween:Play()
        local input = UserInputService:GetStringInput("Enter " .. name:lower() .. ":")
        if input then callback(input) end
    end)
end

-- UI Animation
local tweenInfo = TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
local tween = TweenService:Create(Frame, tweenInfo, { Position = UDim2.new(0.2, 0, 0.1, 0), BackgroundTransparency = 0.2 })
tween:Play()

-- Tab Management
local currentTab = nil
local tabs = {}

local function switchTab(tabName)
    if currentTab then currentTab.Visible = false end
    currentTab = tabs[tabName]
    currentTab.Visible = true
end

-- Create Tabs
local basicTab = Instance.new("Frame", ContentFrame)
basicTab.Size = UDim2.new(1, 0, 1, 0)
basicTab.BackgroundTransparency = 1
basicTab.Visible = false
tabs["Basic"] = basicTab

local trollTab = Instance.new("Frame", ContentFrame)
trollTab.Size = UDim2.new(1, 0, 1, 0)
trollTab.BackgroundTransparency = 1
trollTab.Visible = false
tabs["Troll"] = trollTab

local adminTab = Instance.new("Frame", ContentFrame)
adminTab.Size = UDim2.new(1, 0, 1, 0)
adminTab.BackgroundTransparency = 1
adminTab.Visible = false
tabs["Admin"] = adminTab

-- Tab Buttons
local basicButton = createTabButton("Basic", UDim2.new(0, 0, 0, 0))
basicButton.MouseButton1Click:Connect(function() switchTab("Basic") end)

local trollButton = createTabButton("Troll", UDim2.new(0.2, 0, 0, 0))
trollButton.MouseButton1Click:Connect(function() switchTab("Troll") end)

local adminButton = createTabButton("Admin", UDim2.new(0.4, 0, 0, 0))
adminButton.MouseButton1Click:Connect(function() switchTab("Admin") end)

switchTab("Basic")

-- Server-Side Exploit Function
local function serverExploit(command, args)
    local remote = Instance.new("RemoteEvent", ReplicatedStorage)
    remote.Name = "ExploitRemote" .. HttpService:GenerateGUID(false)
    remote:FireServer(command, args)
    log("Server Exploit: " .. command .. " | Args: " .. HttpService:JSONEncode(args))
end

-- Basic Tab Functions
local function toggleGodMode() serverExploit("SetGodMode", { Player = LocalPlayer.Name, Enabled = true }) log("God Mode: ON") end
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
    log("ESP Hack: ON")
end
local function toggleInfiniteJump()
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    local originalJump = Humanoid.JumpPower
    Humanoid.JumpPower = originalJump
    UserInputService.JumpRequest:Connect(function()
        if Humanoid:GetState() == Enum.HumanoidStateType.Jumping or Humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
    serverExploit("SyncInfiniteJump", { Player = LocalPlayer.Name, Enabled = true })
    log("Infinite Jump: ON (Based on original JumpPower: " .. originalJump .. ")")
end

-- Troll Tab Functions
local function flingAll()
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character then
            serverExploit("FlingPlayer", { Target = v.Name, Force = Vector3.new(math.random(-1000, 1000), 1000, math.random(-1000, 1000)) })
        end
    end
    log("Flung all players!")
end
local function flingPlayer(input) serverExploit("FlingPlayer", { Target = input, Force = Vector3.new(math.random(-1000, 1000), 1000, math.random(-1000, 1000)) }) log("Flung player: " .. input) end
local function trollDisco() serverExploit("EnvironmentEffect", { Type = "Disco", Enabled = true }) log("Disco Troll: ON") end
local function trollGravity() serverExploit("SetGravity", { Value = math.random(0, 100) }) log("Gravity Troll: Set to random value") end
local function trollSound(input) serverExploit("PlaySound", { SoundId = "rbxassetid://" .. input, Volume = 10 }) log("Troll Sound Played: ID " .. input) end

-- Admin Tab Functions
local function kickPlayer(input) serverExploit("KickPlayer", { Target = input, Reason = "Kicked by Overpowered Hack!" }) log("Kicked player: " .. input) end
local function banPlayer(input)
    local duration = UserInputService:GetStringInput("Enter ban duration (seconds):")
    local reason = UserInputService:GetStringInput("Enter ban reason:")
    if duration and reason then
        serverExploit("BanPlayer", { Target = input, Duration = tonumber(duration), Reason = reason })
        log("Banned player: " .. input .. " for " .. duration .. "s - Reason: " .. reason)
    end
end
local function crashServer() serverExploit("CrashServer", { Reason = "Server crashed by Overpowered Hack!" }) log("Server Crash Initiated!") end
local function giveAdmin() serverExploit("GrantAdmin", { Player = LocalPlayer.Name, Level = "Full" }) log("Admin Privileges Granted!") end
local function spawnItem(input) serverExploit("SpawnItem", { Player = LocalPlayer.Name, Item = input }) log("Spawned item: " .. input) end
local function ragdollPlayer(input)
    local target = Players:FindFirstChild(input)
    if target and target.Character then
        serverExploit("RagdollPlayer", { Target = input, Enabled = true })
        log("Ragdolled player: " .. input)
    else
        log("Player not found: " .. input)
    end
end
local function controlPlayer(input)
    local target = Players:FindFirstChild(input)
    if target and target.Character then
        serverExploit("ControlPlayer", { Target = input, Controller = LocalPlayer.Name })
        log("Controlling player: " .. input)
    else
        log("Player not found: " .. input)
    end
end
local function chatPlayer(input)
    local message = UserInputService:GetStringInput("Enter message to make player say:")
    if message then
        serverExploit("ForceChat", { Target = input, Message = message })
        log("Made player " .. input .. " say: " .. message)
    end
end

-- Add Buttons to Tabs
createButton("God Mode", UDim2.new(0.05, 0, 0.1, 0), toggleGodMode, basicTab)
createButton("Toggle Fly", UDim2.new(0.5, 0, 0.1, 0), toggleFly, basicTab)
createButton("Toggle ESP", UDim2.new(0.05, 0, 0.25, 0), toggleESP, basicTab)
createButton("Infinite Jump", UDim2.new(0.5, 0, 0.25, 0), toggleInfiniteJump, basicTab)

createButton("Fling All", UDim2.new(0.05, 0, 0.1, 0), flingAll, trollTab)
createInputButton("Fling Player", UDim2.new(0.5, 0, 0.1, 0), flingPlayer, trollTab)
createButton("Disco Troll", UDim2.new(0.05, 0, 0.25, 0), trollDisco, trollTab)
createButton("Gravity Troll", UDim2.new(0.5, 0, 0.25, 0), trollGravity, trollTab)
createInputButton("Sound Troll", UDim2.new(0.05, 0, 0.4, 0), trollSound, trollTab)

createInputButton("Kick Player", UDim2.new(0.05, 0, 0.1, 0), kickPlayer, adminTab)
createInputButton("Ban Player", UDim2.new(0.5, 0, 0.1, 0), banPlayer, adminTab)
createButton("Crash Server", UDim2.new(0.05, 0, 0.25, 0), crashServer, adminTab)
createButton("Give Admin", UDim2.new(0.5, 0, 0.25, 0), giveAdmin, adminTab)
createInputButton("Spawn Item", UDim2.new(0.05, 0, 0.4, 0), spawnItem, adminTab)
createInputButton("Ragdoll Player", UDim2.new(0.5, 0, 0.4, 0), ragdollPlayer, adminTab)
createInputButton("Control Player", UDim2.new(0.05, 0, 0.55, 0), controlPlayer, adminTab)
createInputButton("Chat Player", UDim2.new(0.5, 0, 0.55, 0), chatPlayer, adminTab)

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
        log("Remote Spy: ON")
    else
        log("Remote Spy: OFF")
    end
end
createButton("Remote Spy", UDim2.new(0.25, 0, 0.7, 0), toggleRemoteSpy, basicTab)

-- Mobile Input Handling
UserInputService.TextBoxFocused:Connect(function(textbox)
    log("Input focused: " .. textbox.Name)
end)

log("Super Overpowered Hack v2.1 Loaded! Use tabs to explore.")

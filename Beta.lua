-- ========================================
-- STEAL A ANIME - WINDUI HUB
-- Made by PickleTalk and Mhicel
-- ========================================

-- Load The Library
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Services
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer

-- ========================================
-- THEMES (10+ COLOR VARIATIONS)
-- ========================================
WindUI:AddTheme({
    Name = "Anime Dark",
    Accent = Color3.fromHex("#FF0F7B"),
    Dialog = Color3.fromHex("#161616"),
    Outline = Color3.fromHex("#FF0F7B"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#101010"),
    Button = Color3.fromHex("#52525b"),
    Icon = Color3.fromHex("#FF0F7B")
})

WindUI:AddTheme({
    Name = "Anime Light",
    Accent = Color3.fromHex("#F89B29"),
    Dialog = Color3.fromHex("#f5f5f5"),
    Outline = Color3.fromHex("#F89B29"),
    Text = Color3.fromHex("#000000"),
    Placeholder = Color3.fromHex("#5a5a5a"),
    Background = Color3.fromHex("#ffffff"),
    Button = Color3.fromHex("#e5e5e5"),
    Icon = Color3.fromHex("#F89B29")
})

WindUI:AddTheme({
    Name = "Purple Dream",
    Accent = Color3.fromHex("#9333EA"),
    Dialog = Color3.fromHex("#1a1625"),
    Outline = Color3.fromHex("#A855F7"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#0f0b16"),
    Button = Color3.fromHex("#4c2a6e"),
    Icon = Color3.fromHex("#C084FC")
})

WindUI:AddTheme({
    Name = "Ocean Blue",
    Accent = Color3.fromHex("#0EA5E9"),
    Dialog = Color3.fromHex("#161e28"),
    Outline = Color3.fromHex("#38BDF8"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#0a1420"),
    Button = Color3.fromHex("#1e3a5f"),
    Icon = Color3.fromHex("#7DD3FC")
})

WindUI:AddTheme({
    Name = "Forest Green",
    Accent = Color3.fromHex("#10B981"),
    Dialog = Color3.fromHex("#16211c"),
    Outline = Color3.fromHex("#34D399"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#0a1610"),
    Button = Color3.fromHex("#1e4d3a"),
    Icon = Color3.fromHex("#6EE7B7")
})

WindUI:AddTheme({
    Name = "Crimson Red",
    Accent = Color3.fromHex("#DC2626"),
    Dialog = Color3.fromHex("#211616"),
    Outline = Color3.fromHex("#EF4444"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#180a0a"),
    Button = Color3.fromHex("#5f1e1e"),
    Icon = Color3.fromHex("#F87171")
})

WindUI:AddTheme({
    Name = "Sunset Orange",
    Accent = Color3.fromHex("#F97316"),
    Dialog = Color3.fromHex("#211a16"),
    Outline = Color3.fromHex("#FB923C"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#18120a"),
    Button = Color3.fromHex("#5f371e"),
    Icon = Color3.fromHex("#FDBA74")
})

WindUI:AddTheme({
    Name = "Midnight Purple",
    Accent = Color3.fromHex("#7C3AED"),
    Dialog = Color3.fromHex("#1a1625"),
    Outline = Color3.fromHex("#8B5CF6"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#0f0a18"),
    Button = Color3.fromHex("#3d2a5f"),
    Icon = Color3.fromHex("#A78BFA")
})

WindUI:AddTheme({
    Name = "Cyan Glow",
    Accent = Color3.fromHex("#06B6D4"),
    Dialog = Color3.fromHex("#162228"),
    Outline = Color3.fromHex("#22D3EE"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#0a1418"),
    Button = Color3.fromHex("#1e4550"),
    Icon = Color3.fromHex("#67E8F9")
})

WindUI:AddTheme({
    Name = "Rose Pink",
    Accent = Color3.fromHex("#F43F5E"),
    Dialog = Color3.fromHex("#211619"),
    Outline = Color3.fromHex("#FB7185"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#180a0f"),
    Button = Color3.fromHex("#5f1e2d"),
    Icon = Color3.fromHex("#FDA4AF")
})

WindUI:AddTheme({
    Name = "Golden Hour",
    Accent = Color3.fromHex("#FBBF24"),
    Dialog = Color3.fromHex("#21200f"),
    Outline = Color3.fromHex("#FCD34D"),
    Text = Color3.fromHex("#000000"),
    Placeholder = Color3.fromHex("#5a5a5a"),
    Background = Color3.fromHex("#1a1808"),
    Button = Color3.fromHex("#6b5a1e"),
    Icon = Color3.fromHex("#FDE68A")
})

WindUI:AddTheme({
    Name = "Neon Green",
    Accent = Color3.fromHex("#22C55E"),
    Dialog = Color3.fromHex("#162116"),
    Outline = Color3.fromHex("#4ADE80"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#0a1610"),
    Button = Color3.fromHex("#1e5f2d"),
    Icon = Color3.fromHex("#86EFAC")
})

WindUI:AddTheme({
    Name = "Electric Blue",
    Accent = Color3.fromHex("#3B82F6"),
    Dialog = Color3.fromHex("#161c28"),
    Outline = Color3.fromHex("#60A5FA"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#0a1220"),
    Button = Color3.fromHex("#1e3d6b"),
    Icon = Color3.fromHex("#93C5FD")
})

WindUI:AddTheme({
    Name = "Custom",
    Accent = Color3.fromHex("#FF0F7B"),
    Dialog = Color3.fromHex("#161616"),
    Outline = Color3.fromHex("#FF0F7B"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#101010"),
    Button = Color3.fromHex("#52525b"),
    Icon = Color3.fromHex("#FF0F7B")
})

-- Set default theme
WindUI:SetTheme("Anime Dark")

-- ========================================
-- CREATING WINDOW
-- ========================================
local Window = WindUI:CreateWindow({
    Title = "Steal A Anime Hub | Official",
    Icon = "sword",
    Author = "by PickleTalk and Mhicel",
    Folder = "StealAnimeHub",
    Transparent = true,
    Theme = "Anime Dark",
})

Window:ToggleTransparency(true)

-- CONFIG MANAGER
local ConfigManager = Window.ConfigManager
local myConfig = ConfigManager:CreateConfig("StealAnimeConfig")

-- Edit minimized button
Window:EditOpenButton({
    Title = "Steal A Anime Hub",
    Icon = "sword",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

-- ========================================
-- GLOBAL VARIABLES & STATES
-- ========================================
local States = {
    -- ALL DEFAULT TO FALSE/OFF
    StealHelper = false,
    AutoLock = false,
    GodMode = false,
    AntiKick = false,
    FOVEnabled = false,
    FOVValue = 70,
    OriginalFOV = 70,
    SpeedEnabled = false,
    SpeedValue = 16,
    OriginalSpeed = 16,
    NoclipEnabled = false,
    PlayerESP = false,
    BaseTimeESP = false,
    BaseTimeAlert = false,
    FullBright = false,
    AntiRagdoll = false,
    CurrentTheme = "Anime Dark",
}

-- ESP Storage
local ESPObjects = {
    Players = {},
    BaseESPs = {},
    AlertGUI = nil,
}

-- Connections Storage
local Connections = {
    FOV = nil,
    Speed = nil,
    Noclip = nil,
    PlayerESP = nil,
    BaseAlert = nil,
    AutoLock = nil,
    GodMode = nil,
}

-- ========================================
-- UTILITY FUNCTIONS
-- ========================================

-- Find player's plot
local function findPlayerPlot()
    local success, result = pcall(function()
        local basesFolder = Workspace:FindFirstChild("Bases")
        if not basesFolder then return nil end
        
        local playerDisplayName = player.DisplayName
        
        for i = 1, 8 do
            local plot = basesFolder:FindFirstChild(tostring(i))
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
                                    return tostring(i)
                                end
                            end
                        end
                    end
                end
            end
        end
        return nil
    end)
    
    return success and result or nil
end

-- Get humanoid safely
local function getHumanoid()
    local character = player.Character
    if character then
        return character:FindFirstChild("Humanoid")
    end
    return nil
end

-- ========================================
-- MAIN TAB FEATURES
-- ========================================

-- Steal Helper Toggle - Wait for UI to exist
local function toggleStealHelper(state)
    States.StealHelper = state
    
    task.spawn(function()
        local playerGui = player:FindFirstChild("PlayerGui")
        if not playerGui then return end
        
        -- Wait for UI to exist (max 10 seconds)
        local stealUI = playerGui:FindFirstChild("PlotTeleporterUI")
        local waitTime = 0
        while not stealUI and waitTime < 10 do
            task.wait(0.5)
            waitTime = waitTime + 0.5
            stealUI = playerGui:FindFirstChild("PlotTeleporterUI")
        end
        
        if stealUI then
            local mainFrame = stealUI:FindFirstChild("MainFrame")
            if mainFrame then
                mainFrame.Visible = state
            end
        else
            WindUI:Notify({
                Title = "Steal UI Not Found",
                Content = "Please wait for the steal UI to load first!",
                Duration = 3,
                Icon = "alert-circle",
            })
        end
    end)
end

-- Auto Lock System - Fully Controlled Toggle
local autoLockEnabled = false
local isAutoLocking = false

local function autoLockSystem()
    task.spawn(function()
        while true do
            if not autoLockEnabled then
                task.wait(0.5)
            else
                pcall(function()
                    if isAutoLocking then
                        task.wait(0.1)
                        return
                    end
                    
                    -- Find player plot
                    local plotNumber = findPlayerPlot()
                    if not plotNumber then 
                        task.wait(0.5)
                        return 
                    end
                    
                    local bases = Workspace:FindFirstChild("Bases")
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
                            local originalPosition = humanoidRootPart.CFrame
                            
                            -- Wait 0.8 seconds
                            task.wait(0.8)
                            
                            -- Teleport to lock button
                            local lockButtonPos = lockButton.CFrame + Vector3.new(0, 4, 0)
                            humanoidRootPart.CFrame = lockButtonPos
                            
                            -- Wait at button
                            task.wait(0.4)
                            
                            -- Teleport back
                            humanoidRootPart.CFrame = originalPosition
                        end
                        
                        isAutoLocking = false
                    end
                end)
                
                task.wait(1)
            end
        end
    end)
end

local function toggleAutoLock(state)
    States.AutoLock = state
    autoLockEnabled = state
    
    -- Set global for original script compatibility
    if getgenv then
        getgenv().autoLockEnabled = state
    end
    _G.autoLockEnabled = state
end

-- God Mode Toggle
local function toggleGodMode(state)
    States.GodMode = state
    
    -- Set global for original script
    if getgenv then
        getgenv().GodModeEnabled = state
    end
    _G.GodModeEnabled = state
    
    if state then
        Connections.GodMode = RunService.Heartbeat:Connect(function()
            local humanoid = getHumanoid()
            if humanoid and States.GodMode then
                if humanoid.MaxHealth ~= math.huge then
                    humanoid.MaxHealth = math.huge
                end
                if humanoid.Health ~= math.huge then
                    humanoid.Health = math.huge
                end
            end
        end)
    else
        if Connections.GodMode then
            Connections.GodMode:Disconnect()
            Connections.GodMode = nil
        end
        
        -- Restore health
        local humanoid = getHumanoid()
        if humanoid then
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end
end

-- ========================================
-- PLAYER TAB FEATURES
-- ========================================

-- FOV Changer
local function toggleFOV(state)
    States.FOVEnabled = state
    
    local camera = Workspace.CurrentCamera
    if not camera then return end
    
    if state then
        States.OriginalFOV = camera.FieldOfView
        camera.FieldOfView = States.FOVValue
        
        Connections.FOV = RunService.RenderStepped:Connect(function()
            if States.FOVEnabled and camera then
                camera.FieldOfView = States.FOVValue
            end
        end)
    else
        if Connections.FOV then
            Connections.FOV:Disconnect()
            Connections.FOV = nil
        end
        camera.FieldOfView = States.OriginalFOV
    end
end

local function updateFOVValue(value)
    States.FOVValue = value
    if States.FOVEnabled then
        local camera = Workspace.CurrentCamera
        if camera then
            camera.FieldOfView = value
        end
    end
end

-- Speed Changer
local function toggleSpeed(state)
    States.SpeedEnabled = state
    
    local humanoid = getHumanoid()
    if not humanoid then return end
    
    if state then
        States.OriginalSpeed = humanoid.WalkSpeed
        humanoid.WalkSpeed = States.SpeedValue
        
        Connections.Speed = RunService.Heartbeat:Connect(function()
            local h = getHumanoid()
            if States.SpeedEnabled and h then
                h.WalkSpeed = States.SpeedValue
            end
        end)
    else
        if Connections.Speed then
            Connections.Speed:Disconnect()
            Connections.Speed = nil
        end
        humanoid.WalkSpeed = States.OriginalSpeed
    end
end

local function updateSpeedValue(value)
    States.SpeedValue = value
    if States.SpeedEnabled then
        local humanoid = getHumanoid()
        if humanoid then
            humanoid.WalkSpeed = value
        end
    end
end

-- Noclip Toggle
local function toggleNoclip(state)
    States.NoclipEnabled = state
    
    if state then
        Connections.Noclip = RunService.Stepped:Connect(function()
            if not States.NoclipEnabled then return end
            
            local character = player.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if Connections.Noclip then
            Connections.Noclip:Disconnect()
            Connections.Noclip = nil
        end
        
        local character = player.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Anti Ragdoll Toggle
local function toggleAntiRagdoll(state)
    States.AntiRagdoll = state
    
    if getgenv then
        getgenv().antiRagdollEnabled = state
    end
    _G.antiRagdollEnabled = state
end

-- ========================================
-- VISUAL TAB FEATURES
-- ========================================

-- Clean up ESP for a player
local function cleanupPlayerESP(targetPlayer)
    if ESPObjects.Players[targetPlayer] then
        for _, obj in pairs(ESPObjects.Players[targetPlayer]) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
        ESPObjects.Players[targetPlayer] = nil
    end
end

-- Create Player ESP
local function createPlayerESP(targetPlayer)
    if targetPlayer == player then return end
    if ESPObjects.Players[targetPlayer] then return end
    
    local character = targetPlayer.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChild("Humanoid")
    if not rootPart or not humanoid then return end
    
    ESPObjects.Players[targetPlayer] = {}
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.FillColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.7
    highlight.OutlineColor = Color3.fromRGB(255, 0, 127)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character
    
    table.insert(ESPObjects.Players[targetPlayer], highlight)
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPBillboard"
    billboard.Size = UDim2.new(0, 80, 0, 20)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = rootPart
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = targetPlayer.DisplayName
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextSize = 12
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.Parent = billboard
    
    table.insert(ESPObjects.Players[targetPlayer], billboard)
end

-- Player ESP Toggle
local function togglePlayerESP(state)
    States.PlayerESP = state
    
    if state then
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer.Character then
                createPlayerESP(targetPlayer)
            end
        end
        
        Connections.PlayerESP = Players.PlayerAdded:Connect(function(newPlayer)
            newPlayer.CharacterAdded:Connect(function()
                if States.PlayerESP then
                    wait(1)
                    createPlayerESP(newPlayer)
                end
            end)
        end)
        
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            targetPlayer.CharacterAdded:Connect(function()
                if States.PlayerESP then
                    wait(1)
                    cleanupPlayerESP(targetPlayer)
                    createPlayerESP(targetPlayer)
                end
            end)
        end
    else
        for targetPlayer, _ in pairs(ESPObjects.Players) do
            cleanupPlayerESP(targetPlayer)
        end
        
        if Connections.PlayerESP then
            Connections.PlayerESP:Disconnect()
            Connections.PlayerESP = nil
        end
    end
end

-- Base Time ESP System (Toggleable)
local function createBaseESP(lockButton, countdown)
    local billboard = Instance.new("BillboardGui")
    billboard.Size = UDim2.new(0, 70, 0, 20)
    billboard.AlwaysOnTop = true
    billboard.StudsOffset = Vector3.new(0, 2, 0)
    billboard.Parent = lockButton
    billboard.Name = "CustomBaseESP"

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.TextStrokeTransparency = 0.2
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Text = ""
    label.Parent = billboard

    local connection = RunService.RenderStepped:Connect(function()
        if not States.BaseTimeESP then return end
        
        local num = tonumber(countdown.Text)
        if num then
            label.Text = countdown.Text
            if num <= 3 then
                label.TextColor3 = Color3.fromRGB(255, 0, 0)
            else
                label.TextColor3 = Color3.fromRGB(255, 255, 0)
            end
        else
            label.Text = countdown.Text
        end
    end)
    
    return {billboard, connection}
end

local function toggleBaseTimeESP(state)
    States.BaseTimeESP = state
    
    if state then
        -- Create ESP for bases 1-8
        for i = 1, 8 do
            local base = Workspace:FindFirstChild("Bases")
            if base then
                base = base:FindFirstChild(tostring(i))
                if base then
                    local lockBtn = base:FindFirstChild("LockButton")
                    if lockBtn then
                        local billboardGui = lockBtn:FindFirstChild("BillboardGui")
                        if billboardGui then
                            local frame = billboardGui:FindFirstChild("Frame")
                            if frame then
                                local countdown = frame:FindFirstChild("Countdown")
                                if countdown and countdown:IsA("TextLabel") then
                                    local espData = createBaseESP(lockBtn, countdown)
                                    ESPObjects.BaseESPs[i] = espData
                                end
                            end
                        end
                    end
                end
            end
        end
    else
        -- Clean up all base ESPs
        for i, espData in pairs(ESPObjects.BaseESPs) do
            if espData then
                if espData[1] and espData[1].Parent then
                    espData[1]:Destroy()
                end
                if espData[2] then
                    espData[2]:Disconnect()
                end
            end
        end
        ESPObjects.BaseESPs = {}
    end
end

-- Base Time Alert
local function createBaseTimeAlert()
    if ESPObjects.AlertGUI then
        ESPObjects.AlertGUI:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BaseTimeAlert"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local alertFrame = Instance.new("Frame")
    alertFrame.Name = "AlertFrame"
    alertFrame.Size = UDim2.new(0, 280, 0, 50)
    alertFrame.Position = UDim2.new(0.5, -140, 0, 100)
    alertFrame.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    alertFrame.BorderSizePixel = 0
    alertFrame.Visible = false
    alertFrame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = alertFrame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Parent = alertFrame
    
    local alertText = Instance.new("TextLabel")
    alertText.Name = "AlertText"
    alertText.Size = UDim2.new(1, -20, 1, -10)
    alertText.Position = UDim2.new(0, 10, 0, 5)
    alertText.BackgroundTransparency = 1
    alertText.Text = "⚠️ BASE UNLOCKING SOON! ⚠️"
    alertText.TextColor3 = Color3.fromRGB(255, 255, 255)
    alertText.TextSize = 16
    alertText.Font = Enum.Font.GothamBold
    alertText.Parent = alertFrame
    
    screenGui.Parent = player:WaitForChild("PlayerGui")
    ESPObjects.AlertGUI = screenGui
    
    return alertFrame
end

local function toggleBaseTimeAlert(state)
    States.BaseTimeAlert = state
    
    if state then
        local alertFrame = createBaseTimeAlert()
        
        Connections.BaseAlert = RunService.Heartbeat:Connect(function()
            if not States.BaseTimeAlert then return end
            
            local plotNumber = findPlayerPlot()
            if not plotNumber then return end
            
            local bases = Workspace:FindFirstChild("Bases")
            if not bases then return end
            
            local plot = bases:FindFirstChild(plotNumber)
            if not plot then return end
            
            local lockButton = plot:FindFirstChild("LockButton")
            if not lockButton then return end
            
            local billboardGui = lockButton:FindFirstChild("BillboardGui")
            if not billboardGui then return end
            
            local frame = billboardGui:FindFirstChild("Frame")
            if not frame then return end
            
            local countdown = frame:FindFirstChild("Countdown")
            if not countdown then return end
            
            local countdownText = countdown.Text
            local seconds = tonumber(countdownText:match("%d+"))
            
            if seconds and seconds <= 10 and seconds > 0 then
                alertFrame.Visible = true
                alertFrame.AlertText.Text = "⚠️ BASE UNLOCKING IN " .. seconds .. "s! ⚠️"
                
                if seconds <= 3 then
                    alertFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
                elseif seconds <= 5 then
                    alertFrame.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
                else
                    alertFrame.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
                end
            else
                alertFrame.Visible = false
            end
        end)
    else
        if Connections.BaseAlert then
            Connections.BaseAlert:Disconnect()
            Connections.BaseAlert = nil
        end
        
        if ESPObjects.AlertGUI then
            ESPObjects.AlertGUI:Destroy()
            ESPObjects.AlertGUI = nil
        end
    end
end

-- ========================================
-- OPTIMIZATIONS TAB FEATURES
-- ========================================

local function toggleFullBright(state)
    States.FullBright = state
    
    if state then
        Lighting.Brightness = 2
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = false
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
    else
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        Lighting.OutdoorAmbient = Color3.fromRGB(127, 127, 127)
        Lighting.Ambient = Color3.fromRGB(0, 0, 0)
    end
end

local function clearFogs()
    for _, obj in pairs(Lighting:GetDescendants()) do
        if obj:IsA("Atmosphere") then
            obj:Destroy()
        end
    end
    
    Lighting.FogEnd = math.huge
    
    WindUI:Notify({
        Title = "Fogs Cleared",
        Content = "All fog effects have been removed!",
        Duration = 3,
        Icon = "check",
    })
end

local function removeShadows()
    Lighting.GlobalShadows = false
    Lighting.ShadowSoftness = 0
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.CastShadow = false
        end
    end
    
    WindUI:Notify({
        Title = "Shadows Removed",
        Content = "All shadows have been disabled!",
        Duration = 3,
        Icon = "check",
    })
end

-- ========================================
-- SETTINGS TAB FEATURES
-- ========================================

local function toggleAntiKick(state)
    States.AntiKick = state
    
    if getgenv then
        getgenv().AntiKickEnabled = state
    end
    _G.AntiKickEnabled = state
    
    WindUI:Notify({
        Title = "Anti Kick " .. (state and "Enabled" or "Disabled"),
        Content = state and "You are now protected from kicks!" or "Anti-kick protection disabled.",
        Duration = 3,
        Icon = state and "shield" or "shield-off",
    })
end

local function saveConfiguration()
    myConfig:Save()
    
    WindUI:Notify({
        Title = "Configuration Saved",
        Content = "All your settings have been saved successfully!",
        Duration = 3,
        Icon = "save",
    })
end

local function loadConfiguration()
    myConfig:Load()
    
    WindUI:Notify({
        Title = "Configuration Loaded",
        Content = "All your saved settings have been loaded!",
        Duration = 3,
        Icon = "download",
    })
end

local function changeTheme(themeName)
    States.CurrentTheme = themeName
    WindUI:SetTheme(themeName)
end

-- ========================================
-- CREATING TABS
-- ========================================

local MainTab = Window:Tab({
    Title = "Main",
    Icon = "home",
})

local PlayerTab = Window:Tab({
    Title = "Player",
    Icon = "user",
})

local VisualTab = Window:Tab({
    Title = "Visual",
    Icon = "eye",
})

local OptimizationsTab = Window:Tab({
    Title = "Optimizations",
    Icon = "zap",
})

local CreditsTab = Window:Tab({
    Title = "Credits",
    Icon = "heart",
})

local SettingsTab = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

-- ========================================
-- MAIN TAB ELEMENTS
-- ========================================

local StealHelperToggle = MainTab:Toggle({
    Title = "Steal Helper UI",
    Desc = "Show/Hide the steal button UI",
    Default = false,
    Callback = function(state)
        toggleStealHelper(state)
    end
})

local AutoLockToggle = MainTab:Toggle({
    Title = "Auto Lock",
    Desc = "Automatically lock your base when timer hits 0s",
    Default = false,
    Callback = function(state)
        toggleAutoLock(state)
    end
})

local GodModeToggle = MainTab:Toggle({
    Title = "God Mode",
    Desc = "Infinite health - you cannot die!",
    Default = false,
    Callback = function(state)
        toggleGodMode(state)
    end
})

myConfig:Register("StealHelper", StealHelperToggle)
myConfig:Register("AutoLock", AutoLockToggle)
myConfig:Register("GodMode", GodModeToggle)

-- ========================================
-- PLAYER TAB ELEMENTS
-- ========================================

local FOVToggle = PlayerTab:Toggle({
    Title = "FOV Changer",
    Desc = "Enable custom field of view",
    Default = false,
    Callback = function(state)
        toggleFOV(state)
    end
})

local FOVSlider = PlayerTab:Slider({
    Title = "FOV Value",
    Step = 1,
    Value = {
        Min = 0,
        Max = 120,
        Default = 70,
    },
    Callback = function(value)
        updateFOVValue(value)
    end
})

local SpeedToggle = PlayerTab:Toggle({
    Title = "Speed Changer",
    Desc = "Enable custom walk speed",
    Default = false,
    Callback = function(state)
        toggleSpeed(state)
    end
})

local SpeedSlider = PlayerTab:Slider({
    Title = "Speed Value",
    Step = 1,
    Value = {
        Min = 16,
        Max = 200,
        Default = 16,
    },
    Callback = function(value)
        updateSpeedValue(value)
    end
})

local NoclipToggle = PlayerTab:Toggle({
    Title = "Noclip",
    Desc = "Walk through walls (with anti-cheat detection)",
    Default = false,
    Callback = function(state)
        toggleNoclip(state)
    end
})

local AntiRagdollToggle = PlayerTab:Toggle({
    Title = "Anti Ragdoll / Anti Fling",
    Desc = "Prevents your character from ragdolling",
    Default = false,
    Callback = function(state)
        toggleAntiRagdoll(state)
    end
})

myConfig:Register("FOVToggle", FOVToggle)
myConfig:Register("FOVValue", FOVSlider)
myConfig:Register("SpeedToggle", SpeedToggle)
myConfig:Register("SpeedValue", SpeedSlider)
myConfig:Register("Noclip", NoclipToggle)
myConfig:Register("AntiRagdoll", AntiRagdollToggle)

-- ========================================
-- VISUAL TAB ELEMENTS
-- ========================================

local PlayerESPToggle = VisualTab:Toggle({
    Title = "Player ESP",
    Desc = "Show clean outline and small name above all players",
    Default = false,
    Callback = function(state)
        togglePlayerESP(state)
    end
})

local BaseTimeESPToggle = VisualTab:Toggle({
    Title = "Base Time ESP",
    Desc = "Show countdown timers on ALL bases (1-8)",
    Default = false,
    Callback = function(state)
        toggleBaseTimeESP(state)
    end
})

local BaseTimeAlertToggle = VisualTab:Toggle({
    Title = "Base Time Alert",
    Desc = "Small clean alarm when your base unlocks in 10 seconds",
    Default = false,
    Callback = function(state)
        toggleBaseTimeAlert(state)
    end
})

myConfig:Register("PlayerESP", PlayerESPToggle)
myConfig:Register("BaseTimeESP", BaseTimeESPToggle)
myConfig:Register("BaseTimeAlert", BaseTimeAlertToggle)

-- ========================================
-- OPTIMIZATIONS TAB ELEMENTS
-- ========================================

local FullBrightToggle = OptimizationsTab:Toggle({
    Title = "Full Bright",
    Desc = "Make everything bright, no more darkness!",
    Default = false,
    Callback = function(state)
        toggleFullBright(state)
    end
})

local ClearFogsButton = OptimizationsTab:Button({
    Title = "Clear Fogs",
    Desc = "Remove all fog effects from the game",
    Callback = function()
        clearFogs()
    end
})

local RemoveShadowsButton = OptimizationsTab:Button({
    Title = "Remove Shadows",
    Desc = "Disable all shadows for better performance",
    Callback = function()
        removeShadows()
    end
})

myConfig:Register("FullBright", FullBrightToggle)

-- ========================================
-- CREDITS TAB ELEMENTS
-- ========================================

local CreditsParagraph = CreditsTab:Paragraph({
    Title = "Steal A Anime Hub | Official",
    Desc = "Made by PickleTalk and Mhicel. Join our discord server to be always updated with the latest features and scripts!",
    Color = "Red",
    Thumbnail = "rbxassetid://86472170233220",
    ThumbnailSize = 80,
    Buttons = {
        {
            Icon = "users",
            Title = "Discord",
            Callback = function()
                setclipboard("https://discord.gg/bpsNUH5sVb")
                WindUI:Notify({
                    Title = "Discord Link Copied!",
                    Content = "Discord invite link copied to clipboard!",
                    Duration = 3,
                    Icon = "check",
                })
            end,
        }
    }
})

-- ========================================
-- SETTINGS TAB ELEMENTS
-- ========================================

local SaveConfigButton = SettingsTab:Button({
    Title = "💾 Save Configuration",
    Desc = "Save all current settings to file",
    Callback = function()
        saveConfiguration()
    end
})

local LoadConfigButton = SettingsTab:Button({
    Title = "📥 Load Configuration",
    Desc = "Load your saved settings from file",
    Callback = function()
        loadConfiguration()
    end
})

local ThemeDropdown = SettingsTab:Dropdown({
    Title = "Theme Selector",
    Values = {
        {Title = "Anime Dark", Icon = "moon"},
        {Title = "Anime Light", Icon = "sun"},
        {Title = "Purple Dream", Icon = "sparkles"},
        {Title = "Ocean Blue", Icon = "waves"},
        {Title = "Forest Green", Icon = "tree-deciduous"},
        {Title = "Crimson Red", Icon = "flame"},
        {Title = "Sunset Orange", Icon = "sunset"},
        {Title = "Midnight Purple", Icon = "moon-star"},
        {Title = "Cyan Glow", Icon = "zap"},
        {Title = "Rose Pink", Icon = "heart"},
        {Title = "Golden Hour", Icon = "sun"},
        {Title = "Neon Green", Icon = "zap-off"},
        {Title = "Electric Blue", Icon = "sparkle"},
        {Title = "Custom", Icon = "palette"},
    },
    Value = "Anime Dark",
    Callback = function(option)
        changeTheme(option.Title)
    end
})

local ThemeColorPicker = SettingsTab:Colorpicker({
    Title = "Custom Theme Color",
    Desc = "Select a custom accent color for the UI",
    Default = Color3.fromRGB(255, 15, 123),
    Callback = function(color)
        WindUI:AddTheme({
            Name = "Custom",
            Accent = color,
            Dialog = Color3.fromHex("#161616"),
            Outline = color,
            Text = Color3.fromHex("#FFFFFF"),
            Placeholder = Color3.fromHex("#7a7a7a"),
            Background = Color3.fromHex("#101010"),
            Button = Color3.fromHex("#52525b"),
            Icon = color
        })
        
        WindUI:SetTheme("Custom")
        States.CurrentTheme = "Custom"
    end
})

local AntiKickToggle = SettingsTab:Toggle({
    Title = "Anti Kick Protection",
    Desc = "Protects you from being kicked by anti-cheat",
    Default = false,
    Callback = function(state)
        toggleAntiKick(state)
    end
})

myConfig:Register("Theme", ThemeDropdown)
myConfig:Register("ThemeColor", ThemeColorPicker)
myConfig:Register("AntiKick", AntiKickToggle)

-- ========================================
-- INITIALIZE AUTO LOCK SYSTEM
-- ========================================
autoLockSystem()

-- ========================================
-- WELCOME POPUP
-- ========================================
WindUI:Popup({
    Title = "Steal A Anime Hub | Official",
    Icon = "sword",
    Content = "Welcome! All features start DISABLED. Enable what you need from the tabs. Join our discord for updates!",
    Buttons = {
        {
            Title = "Close",
            Callback = function() end,
            Variant = "Tertiary",
        },
        {
            Title = "Join Discord",
            Icon = "users",
            Callback = function()
                setclipboard("https://discord.gg/bpsNUH5sVb")
                WindUI:Notify({
                    Title = "Link Copied!",
                    Content = "Discord invite copied to clipboard!",
                    Duration = 3,
                    Icon = "check",
                })
            end,
            Variant = "Primary",
        }
    }
})

-- ========================================
-- INITIALIZATION
-- ========================================
WindUI:Notify({
    Title = "Hub Loaded!",
    Content = "Steal A Anime Hub loaded! All features are OFF by default.",
    Duration = 3,
    Icon = "check",
})

print("🗡️ Steal A Anime Hub Loaded Successfully! 🗡️")
print("Made by PickleTalk and Mhicel")
print("All features start DISABLED - enable what you need!")

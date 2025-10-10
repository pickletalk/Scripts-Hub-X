-- ========================================
-- STEAL A ANIME - WINDUI HUB (V2 - ULTRA-OPTIMIZED)
-- Made by PickleTalk and Mhicel
-- LIGHTNING-FAST NOCLIP WITH INSTANT TELEPORT
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
    Title = "Steal A Anime SHX | Official",
    Icon = "sword",
    Author = "by PickleTalk and Mhicel",
    Folder = "StealAnimeSHX",
    Transparent = true,
    Theme = "Anime Dark",
})

Window:ToggleTransparency(true)

-- CONFIG MANAGER
local ConfigManager = Window.ConfigManager
local myConfig = ConfigManager:CreateConfig("StealAnimeSHXConfig")

-- Edit minimized button
Window:EditOpenButton({
    Title = "Steal A Anime",
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
    StealHelper = false,
    AutoLock = false,
    GodMode = false,
    AntiKick = false,
    AntiVoid = false,
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
    LowGFX = false,
    AntiRagdoll = false,
    CurrentTheme = "Anime Dark",
    InstantSteal = false,
    InstantSteal = nil,
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
    LowGFX = nil,
    AntiVoid = nil,
}

-- Steal UI Storage
local StealUI = {
    ScreenGui = nil,
}

-- Low GFX Storage
local LowGFXStorage = {
    SavedProperties = {},
    SavedLighting = {},
}

-- ========================================
-- LIGHTNING-FAST NOCLIP STORAGE (OPTIMIZED)
-- ========================================
local NoclipData = {
    Character = nil,
    Humanoid = nil,
    HRP = nil,
    LastValidPosition = nil,
    CurrentPosition = nil,
    PositionHistory = {},
    HistorySize = 5,
    AntiCheatThreshold = 7,
    RayLength = 100,
    TeleportCooldown = 0,
    IsAutoLocking = false,
    SavedLockButtonPosition = nil,
    LegitTeleport = false,
}

-- Anti-Void Storage
local AntiVoidData = {
    VoidThreshold = -50,
    LastValidPosition = nil,
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
-- LIGHTNING-FAST TELEPORT SYSTEM (FASTER THAN LIGHT)
-- ========================================
local function ultraFastTeleport(targetPosition)
    local hrp = NoclipData.HRP
    if not hrp or not NoclipData.Character then return end
    
    pcall(function()
        -- INSTANT PHYSICS DISABLE - SINGLE OPERATION
        for _, part in ipairs(NoclipData.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
                part.Anchored = true
            end
        end
        
        -- INSTANT TELEPORT - ALL METHODS SIMULTANEOUSLY (NO DELAYS)
        hrp.CFrame = CFrame.new(targetPosition)
        hrp.Position = targetPosition
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        hrp.Velocity = Vector3.zero
        hrp.RotVelocity = Vector3.zero
        
        -- REDUNDANT POSITION LOCK
        hrp.CFrame = CFrame.new(targetPosition)
        
        -- INSTANT PHYSICS RE-ENABLE - SAME FRAME
        for _, part in ipairs(NoclipData.Character:GetDescendants()) do
            if part:IsA("BasePart") and part ~= hrp then
                part.Anchored = false
            end
        end
        hrp.Anchored = false
    end)
end

-- ========================================
-- ENHANCED ANTI-CHEAT DETECTION (FROM STEAL A ANIME.LUA)
-- ========================================

-- Update position history
local function updatePositionHistory(newPos)
    table.insert(NoclipData.PositionHistory, 1, newPos)
    if #NoclipData.PositionHistory > NoclipData.HistorySize then
        table.remove(NoclipData.PositionHistory, NoclipData.HistorySize + 1)
    end
end

-- Check if position is near any LockButton
local function isNearLockButton(position)
    local basesFolder = Workspace:FindFirstChild("Bases")
    if not basesFolder then return false end
    
    for i = 1, 8 do
        local base = basesFolder:FindFirstChild(tostring(i))
        if base then
            local lockButton = base:FindFirstChild("LockButton")
            if lockButton then
                local distance = (position - lockButton.Position).Magnitude
                if distance < 15 then
                    return true
                end
            end
        end
    end
    return false
end

-- Enhanced anti-cheat snapback detection with movement vector analysis
local function detectAntiCheatSnapback(newPos, oldPos)
    if NoclipData.TeleportCooldown > 0 then
        NoclipData.TeleportCooldown = NoclipData.TeleportCooldown - 1
    end
    
    local movementVector = newPos - oldPos
    local distance = movementVector.Magnitude
    
    -- INSTANT THRESHOLD CHECK
    if distance > NoclipData.AntiCheatThreshold then
        -- Ignore if near LockButton or auto-locking
        if NoclipData.IsAutoLocking or isNearLockButton(newPos) or isNearLockButton(oldPos) then
            NoclipData.TeleportCooldown = 30
            return false
        end
        
        -- Ignore during cooldown
        if NoclipData.TeleportCooldown > 0 then
            return false
        end
        
        -- ENHANCED: Check movement direction consistency (dot product analysis)
        if #NoclipData.PositionHistory >= 2 then
            local prevMovement = NoclipData.PositionHistory[1] - NoclipData.PositionHistory[2]
            if prevMovement.Magnitude > 0.1 and movementVector.Magnitude > 0.1 then
                local dotProduct = movementVector.Unit:Dot(prevMovement.Unit)
                
                -- If movement is backwards (dotProduct < 0), likely a snapback
                if dotProduct < -0.5 then
                    return true
                end
            end
        end
        
        -- Check if position suddenly jumped to a far location
        if #NoclipData.PositionHistory >= 3 and NoclipData.TeleportCooldown <= 0 then
            local avgRecentPos = Vector3.zero
            for i = 1, 3 do
                avgRecentPos = avgRecentPos + NoclipData.PositionHistory[i]
            end
            avgRecentPos = avgRecentPos / 3
            
            local distanceFromAverage = (newPos - avgRecentPos).Magnitude
            if distanceFromAverage > NoclipData.AntiCheatThreshold and not isNearLockButton(newPos) then
                return true
            end
        end
    end
    
    return false
end

-- Floor raycast check
local function checkFloor()
    local hrp = NoclipData.HRP
    if not hrp then return end
    
    local rayOrigin = hrp.Position
    local rayDirection = Vector3.new(0, -NoclipData.RayLength, 0)
    local rayParams = RaycastParams.new()
    rayParams.FilterDescendantsInstances = {NoclipData.Character}
    rayParams.FilterType = Enum.RaycastFilterType.Blacklist
    
    local result = Workspace:Raycast(rayOrigin, rayDirection, rayParams)
    if result then
        local floorY = result.Position.Y
        if hrp.Position.Y < floorY + 3 then
            local correctedPos = Vector3.new(hrp.Position.X, floorY + 3, hrp.Position.Z)
            ultraFastTeleport(correctedPos)
            NoclipData.LastValidPosition = correctedPos
        end
    end
end

-- Apply noclip to character (ENHANCED)
local function applyNoclip(char)
    for _, v in ipairs(char:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end
    
    char.DescendantAdded:Connect(function(v)
        if v:IsA("BasePart") and States.NoclipEnabled then
            v.CanCollide = false
        end
    end)
end

-- Refresh noclip character references (ENHANCED)
local function refreshNoclipCharacter()
    NoclipData.Character = player.Character or player.CharacterAdded:Wait()
    NoclipData.Humanoid = NoclipData.Character:WaitForChild("Humanoid")
    NoclipData.HRP = NoclipData.Character:WaitForChild("HumanoidRootPart")
    
    applyNoclip(NoclipData.Character)
    
    NoclipData.LastValidPosition = NoclipData.HRP.Position
    NoclipData.CurrentPosition = NoclipData.HRP.Position
    NoclipData.PositionHistory = {}
    
    for i = 1, NoclipData.HistorySize do
        NoclipData.PositionHistory[i] = NoclipData.HRP.Position
    end
end

-- Noclip Toggle (OPTIMIZED)
local function toggleNoclip(state)
    States.NoclipEnabled = state
    
    if state then
        refreshNoclipCharacter()
        
        -- LIGHTNING-FAST MONITORING LOOP
        Connections.Noclip = RunService.Heartbeat:Connect(function()
            if not NoclipData.HRP or not NoclipData.Character or not States.NoclipEnabled then return end
            
            -- INSTANT NOCLIP APPLICATION
            for _, v in ipairs(NoclipData.Character:GetDescendants()) do
                if v:IsA("BasePart") and v.CanCollide then
                    v.CanCollide = false
                end
            end
            
            -- Get current position
            NoclipData.CurrentPosition = NoclipData.HRP.Position
            
            -- INSTANT ANTI-CHEAT CHECK AND RECOVERY (ZERO DELAY)
            if detectAntiCheatSnapback(NoclipData.CurrentPosition, NoclipData.LastValidPosition) then
                ultraFastTeleport(NoclipData.LastValidPosition)
                print("⚡ ANTI-CHEAT BLOCKED - INSTANT RECOVERY!")
            else
                NoclipData.LastValidPosition = NoclipData.CurrentPosition
                updatePositionHistory(NoclipData.CurrentPosition)
            end
            
            -- Floor check
            checkFloor()
        end)
        
        -- Handle character respawn
        player.CharacterAdded:Connect(function()
            if States.NoclipEnabled then
                refreshNoclipCharacter()
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

-- ========================================
-- INSTANT STEAL LOGICS 
-- ========================================
-- INSTANT STEAL SYSTEM
local function toggleInstantSteal(state)
    States.InstantSteal = state
    
    if state then
        Connections.InstantSteal = RunService.Heartbeat:Connect(function()
            if not States.InstantSteal then return end
            
            pcall(function()
                local plotNumber = findPlayerPlot()
                if not plotNumber then return end
                
                local basesFolder = Workspace:FindFirstChild("Bases")
                if not basesFolder then return end
                
                local plot = basesFolder:FindFirstChild(plotNumber)
                if not plot then return end
                
                local stealCollect2 = plot:FindFirstChild("StealCollect2")
                if not stealCollect2 then return end
                
                local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                if not root then return end
                
                firetouchinterest(stealCollect2, root, 0)
                firetouchinterest(stealCollect2, root, 1)
            end)
        end)
        
        WindUI:Notify({
            Title = "Instant Steal Enabled",
            Content = "Auto-stealing anime continuously!",
            Duration = 3,
            Icon = "zap",
        })
    else
        if Connections.InstantSteal then
            Connections.InstantSteal:Disconnect()
            Connections.InstantSteal = nil
        end
        
        WindUI:Notify({
            Title = "Instant Steal Disabled",
            Content = "Auto-steal stopped.",
            Duration = 3,
            Icon = "zap-off",
        })
    end
end

-- ========================================
-- ADVANCED SPEED SPOOFER (PROVIDED CODE)
-- ========================================
local WalkSpeedSpoof = getgenv().WalkSpeedSpoof
local Disable = WalkSpeedSpoof and WalkSpeedSpoof.Disable
if Disable then
    Disable()
end

local cloneref = cloneref or function(...)
    return ...
end

local WalkSpeedSpoof = {}

local Players = cloneref(game:GetService("Players"))
if not Players.LocalPlayer then
    Players:GetPropertyChangedSignal("LocalPlayer"):Wait()
end
local lp = cloneref(Players.LocalPlayer)

local split = string.split

local GetDebugIdHandler = Instance.new("BindableFunction")
local TempHumanoid = Instance.new("Humanoid")

local cachedhumanoids = {}

local CurrentHumanoid
local newindexhook
local indexhook

function GetDebugIdHandler.OnInvoke(obj: Instance): string
    return obj:GetDebugId()
end

local function GetDebugId(obj: Instance): string
    return GetDebugIdHandler:Invoke(obj)
end

local function GetWalkSpeed(obj: any): number
    TempHumanoid.WalkSpeed = obj
    return TempHumanoid.WalkSpeed
end

function cachedhumanoids:cacheHumanoid(DebugId: string,Humanoid: Humanoid)
    cachedhumanoids[DebugId] = {
        currentindex = indexhook(Humanoid,"WalkSpeed"),
        lastnewindex = nil
    }
    return self[DebugId]
end

indexhook = hookmetamethod(game,"__index",function(self,index)
    if not checkcaller() and typeof(self) == "Instance" then
        if self:IsA("Humanoid") then
            local DebugId = GetDebugId(self)
            local cached = cachedhumanoids[DebugId]

            if self:IsDescendantOf(lp.Character) or cached then
                if type(index) == "string" then
                    local cleanindex = split(index,"\0")[1]

                    if cleanindex == "WalkSpeed" then
                        if not cached then
                            cached = cachedhumanoids:cacheHumanoid(DebugId,self)
                        end

                        if not (CurrentHumanoid and CurrentHumanoid:IsDescendantOf(game)) then
                            CurrentHumanoid = cloneref(self)
                        end

                        return cached.lastnewindex or cached.currentindex
                    end
                end
            end
        end
    end

    return indexhook(self,index)
end)

newindexhook = hookmetamethod(game,"__newindex",function(self,index,newindex)
    if not checkcaller() and typeof(self) == "Instance" then
        if self:IsA("Humanoid") then
            local DebugId = GetDebugId(self)
            local cached = cachedhumanoids[DebugId]

            if self:IsDescendantOf(lp.Character) or cached then
                if type(index) == "string" then
                    local cleanindex = split(index,"\0")[1]

                    if cleanindex == "WalkSpeed" then
                        if not cached then
                            cached = cachedhumanoids:cacheHumanoid(DebugId,self)
                        end

                        if not (CurrentHumanoid and CurrentHumanoid:IsDescendantOf(game)) then
                            CurrentHumanoid = cloneref(self)
                        end
                        cached.lastnewindex = GetWalkSpeed(newindex)
                        return CurrentHumanoid.WalkSpeed
                    end
                end
            end
        end
    end
    
    return newindexhook(self,index,newindex)
end)

function WalkSpeedSpoof:Disable()
    WalkSpeedSpoof:RestoreWalkSpeed()
    hookmetamethod(game,"__index",indexhook)
    hookmetamethod(game,"__newindex",newindexhook)
    GetDebugIdHandler:Destroy()
    TempHumanoid:Destroy()
    table.clear(WalkSpeedSpoof)
    getgenv().WalkSpeedSpoof = nil
end

function WalkSpeedSpoof:GetHumanoid()
    return CurrentHumanoid or (function()
        local char = lp.Character
        local Humanoid = char and char:FindFirstChildWhichIsA("Humanoid") or nil
        
        if Humanoid then
            cachedhumanoids:cacheHumanoid(Humanoid:GetDebugId(),Humanoid)
            return cloneref(Humanoid)
        end
    end)()
end

function WalkSpeedSpoof:SetWalkSpeed(speed)
    local Humanoid = WalkSpeedSpoof:GetHumanoid()

    if Humanoid then
        local connections = {}
        local function AddConnectionsFromSignal(Signal)
            for i,v in getconnections(Signal) do
                if v.State then
                    v:Disable()
                    table.insert(connections,v)
                end
            end
        end
        AddConnectionsFromSignal(Humanoid.Changed)
        AddConnectionsFromSignal(Humanoid:GetPropertyChangedSignal("WalkSpeed"))
        Humanoid.WalkSpeed = speed
        for i,v in connections do
            v:Enable()
        end
    end
end

function WalkSpeedSpoof:RestoreWalkSpeed()
    local Humanoid = WalkSpeedSpoof:GetHumanoid()
    
    if Humanoid then
        local cached = cachedhumanoids[Humanoid:GetDebugId()]

        if cached then
            WalkSpeedSpoof:SetWalkSpeed(cached.lastnewindex or cached.currentindex)
        end
    end
end

getgenv().WalkSpeedSpoof = WalkSpeedSpoof

-- ========================================
-- MAIN TAB FEATURES
-- ========================================

-- Create Steal Helper UI
local function createStealUI()
    if StealUI.ScreenGui then
        StealUI.ScreenGui:Destroy()
    end
    
    local playerGui = player:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PlotTeleporterUI"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
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
    
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -30, 1, 0)
    titleText.Position = UDim2.new(0, 5, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "ANIME HEIST"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextScaled = true
    titleText.Font = Enum.Font.GothamBold
    titleText.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
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
    teleportButton.Text = "STEAL"
    teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    teleportButton.TextScaled = true
    teleportButton.Font = Enum.Font.GothamBold
    teleportButton.BorderSizePixel = 0
    teleportButton.Parent = mainFrame
    
    local teleportCorner = Instance.new("UICorner")
    teleportCorner.CornerRadius = UDim.new(0, 6)
    teleportCorner.Parent = teleportButton
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -20, 0, 25)
    statusLabel.Position = UDim2.new(0, 10, 0, 90)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "by PickleTalk"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = mainFrame
    
    -- Dragging
    local dragging = false
    local dragStart, startPos
    
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
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Steal Function
    teleportButton.MouseButton1Click:Connect(function()
        task.spawn(function()
            local running = false
            local root = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            
            if not root then
                teleportButton.Text = "ERROR: NO CHARACTER"
                task.wait(1.5)
                teleportButton.Text = "STEAL"
                return
            end
            
            teleportButton.Text = "STEALING..."
            
            running = true
            task.spawn(function()
                local t = 0
                while running do
                    t = t + 0.03
                    local r = math.floor((math.sin(t) * 0.5 + 0.5) * 60)
                    local g = math.floor((math.sin(t + 2) * 0.5 + 0.5) * 60)
                    local b = math.floor((math.sin(t + 4) * 0.5 + 0.5) * 120 + 60)
                    teleportButton.BackgroundColor3 = Color3.fromRGB(r, g, b)
                    task.wait(0.03)
                end
            end)
            
            local plotNumber = findPlayerPlot()
            if not plotNumber then
                running = false
                teleportButton.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
                teleportButton.Text = "ERROR: NO PLOT"
                task.wait(1.5)
                teleportButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                teleportButton.Text = "STEAL"
                return
            end
            
            local basesFolder = Workspace:FindFirstChild("Bases")
            local plot = basesFolder and basesFolder:FindFirstChild(plotNumber)
            local stealCollect2 = plot and plot:FindFirstChild("StealCollect2")
            
            if stealCollect2 then
                firetouchinterest(stealCollect2, root, 0)
                firetouchinterest(stealCollect2, root, 1)
            end
            
            running = false
            teleportButton.Text = "SUCCESS!"
            
            local gold = Color3.fromRGB(212, 175, 55)
            local black = Color3.fromRGB(0, 0, 0)
            for i = 1, 3 do
                teleportButton.BackgroundColor3 = gold
                task.wait(0.1)
                teleportButton.BackgroundColor3 = black
                task.wait(0.1)
            end
            
            teleportButton.Text = "STEAL"
        end)
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        States.StealHelper = false
        if StealUI.ScreenGui then
            StealUI.ScreenGui:Destroy()
            StealUI.ScreenGui = nil
        end
    end)
    
    -- Hover effects
    closeButton.MouseEnter:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
    end)
    closeButton.MouseLeave:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end)
    
    StealUI.ScreenGui = screenGui
end

-- Steal Helper Toggle
local function toggleStealHelper(state)
    States.StealHelper = state
    
    if state then
        createStealUI()
    else
        if StealUI.ScreenGui then
            StealUI.ScreenGui:Destroy()
            StealUI.ScreenGui = nil
        end
    end
end

-- Auto Lock System
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
                    
                    if countdown.Text == "0s" then
                        isAutoLocking = true
                        NoclipData.IsAutoLocking = true
                        
                        local character = player.Character
                        local humanoidRootPart = character and character:FindFirstChild("HumanoidRootPart")
                        
                        if humanoidRootPart then
                            local originalPosition = humanoidRootPart.CFrame
                            
                            task.wait(0.8)
                            
                            local lockButtonPos = lockButton.CFrame + Vector3.new(0, 4.5, 0)
                            NoclipData.SavedLockButtonPosition = lockButtonPos.Position
                            
                            ultraFastTeleport(lockButtonPos.Position)
                            
                            task.wait(0.4)
                            
                            ultraFastTeleport(originalPosition.Position)
                        end
                        
                        NoclipData.IsAutoLocking = false
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
    
    if getgenv then
        getgenv().autoLockEnabled = state
    end
    _G.autoLockEnabled = state
end

-- GOD MODE (FIXED)
local function toggleGodMode(state)
    States.GodMode = state
    
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
        
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            if States.GodMode then
                local humanoid = getHumanoid()
                if humanoid then
                    humanoid.MaxHealth = math.huge
                    humanoid.Health = math.huge
                end
            end
        end)
    else
        if Connections.GodMode then
            Connections.GodMode:Disconnect()
            Connections.GodMode = nil
        end
        
        local humanoid = getHumanoid()
        if humanoid then
            humanoid.MaxHealth = 100
            humanoid.Health = 100
        end
    end
end

-- ANTI-VOID SYSTEM
local function toggleAntiVoid(state)
    States.AntiVoid = state
    
    if state then
        Connections.AntiVoid = RunService.Heartbeat:Connect(function()
            if not States.AntiVoid then return end
            
            local character = player.Character
            if not character then return end
            
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            local currentY = hrp.Position.Y
            
            if currentY > AntiVoidData.VoidThreshold then
                AntiVoidData.LastValidPosition = hrp.Position
            end
            
            if currentY < AntiVoidData.VoidThreshold then
                local rayOrigin = Vector3.new(hrp.Position.X, 100, hrp.Position.Z)
                local rayDirection = Vector3.new(0, -500, 0)
                local rayParams = RaycastParams.new()
                rayParams.FilterDescendantsInstances = {character}
                rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                
                local result = Workspace:Raycast(rayOrigin, rayDirection, rayParams)
                
                if result then
                    local safePos = Vector3.new(hrp.Position.X, result.Position.Y + 3, hrp.Position.Z)
                    ultraFastTeleport(safePos)
                    print("⚠️ ANTI-VOID: Teleported to ground!")
                elseif AntiVoidData.LastValidPosition then
                    ultraFastTeleport(AntiVoidData.LastValidPosition)
                    print("⚠️ ANTI-VOID: Teleported to last safe position!")
                else
                    ultraFastTeleport(Vector3.new(0, 50, 0))
                    print("⚠️ ANTI-VOID: Emergency teleport to spawn!")
                end
            end
        end)
        
        WindUI:Notify({
            Title = "Anti-Void Enabled",
            Content = "Automatic void protection active!",
            Duration = 3,
            Icon = "shield",
        })
    else
        if Connections.AntiVoid then
            Connections.AntiVoid:Disconnect()
            Connections.AntiVoid = nil
        end
        
        WindUI:Notify({
            Title = "Anti-Void Disabled",
            Content = "Void protection is now off.",
            Duration = 3,
            Icon = "shield-off",
        })
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
    
    if state then
        WalkSpeedSpoof:SetWalkSpeed(States.SpeedValue)
    else
        WalkSpeedSpoof:RestoreWalkSpeed()
    end
end

local function updateSpeedValue(value)
    States.SpeedValue = value
    
    if States.SpeedEnabled then
        WalkSpeedSpoof:SetWalkSpeed(value)
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

-- Base Time ESP System
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
    alertText.Text = "BASE UNLOCKING SOON!"
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
                alertFrame.AlertText.Text = "BASE UNLOCKING IN " .. seconds .. "s!"
                
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

local function saveOriginalGFX()
    if next(LowGFXStorage.SavedLighting) == nil then
        LowGFXStorage.SavedLighting = {
            GlobalShadows = Lighting.GlobalShadows,
            ShadowSoftness = Lighting.ShadowSoftness,
        }
    end
    
    for _, obj in pairs(Workspace:GetDescendants()) do
        local objId = tostring(obj:GetDebugId())
        
        if not LowGFXStorage.SavedProperties[objId] then
            if obj:IsA("BasePart") then
                LowGFXStorage.SavedProperties[objId] = {
                    Object = obj,
                    Material = obj.Material,
                    CastShadow = obj.CastShadow,
                    Reflectance = obj.Reflectance,
                }
            elseif obj:IsA("MeshPart") then
                LowGFXStorage.SavedProperties[objId] = {
                    Object = obj,
                    Material = obj.Material,
                    TextureID = obj.TextureID,
                    CastShadow = obj.CastShadow,
                }
            elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                LowGFXStorage.SavedProperties[objId] = {
                    Object = obj,
                    Enabled = obj.Enabled,
                }
            elseif obj:IsA("Decal") or obj:IsA("Texture") then
                LowGFXStorage.SavedProperties[objId] = {
                    Object = obj,
                    Transparency = obj.Transparency,
                }
            end
        end
    end
end

local function applyLowGFX()
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.CastShadow = false
            obj.Reflectance = 0
        elseif obj:IsA("MeshPart") then
            obj.Material = Enum.Material.SmoothPlastic
            obj.TextureID = ""
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
            obj.Enabled = false
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 1
        end
    end
    
    Lighting.GlobalShadows = false
    Lighting.ShadowSoftness = 0
end

local function restoreOriginalGFX()
    for objId, data in pairs(LowGFXStorage.SavedProperties) do
        local obj = data.Object
        
        if obj and obj.Parent then
            pcall(function()
                if obj:IsA("BasePart") then
                    obj.Material = data.Material
                    obj.CastShadow = data.CastShadow
                    obj.Reflectance = data.Reflectance
                elseif obj:IsA("MeshPart") then
                    obj.Material = data.Material
                    obj.TextureID = data.TextureID
                    obj.CastShadow = data.CastShadow
                elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then
                    obj.Enabled = data.Enabled
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = data.Transparency
                end
            end)
        end
    end
    
    if LowGFXStorage.SavedLighting.GlobalShadows ~= nil then
        Lighting.GlobalShadows = LowGFXStorage.SavedLighting.GlobalShadows
        Lighting.ShadowSoftness = LowGFXStorage.SavedLighting.ShadowSoftness
    end
    
    LowGFXStorage.SavedProperties = {}
    LowGFXStorage.SavedLighting = {}
end

local function toggleLowGFX(state)
    States.LowGFX = state
    
    if state then
        saveOriginalGFX()
        applyLowGFX()
        
        Connections.LowGFX = Workspace.DescendantAdded:Connect(function(obj)
            if States.LowGFX then
                if obj:IsA("BasePart") then
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.CastShadow = false
                    obj.Reflectance = 0
                elseif obj:IsA("MeshPart") then
                    obj.Material = Enum.Material.SmoothPlastic
                    obj.TextureID = ""
                end
            end
        end)
        
        WindUI:Notify({
            Title = "Low GFX Enabled",
            Content = "Graphics optimized!",
            Duration = 3,
            Icon = "zap",
        })
    else
        if Connections.LowGFX then
            Connections.LowGFX:Disconnect()
            Connections.LowGFX = nil
        end
        
        restoreOriginalGFX()
        
        WindUI:Notify({
            Title = "Low GFX Disabled",
            Content = "Original graphics restored!",
            Duration = 3,
            Icon = "check",
        })
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
local InstantStealToggle = MainTab:Toggle({
    Title = "Instant Steal",
    Desc = "Instant Auto Steal A Anime!",
    Default = false,
    Callback = function(state)
        toggleInstantSteal(state)
    end
})

local StealHelperToggle = MainTab:Toggle({
    Title = "Manual Steal Ui",
    Desc = "Show/Hide the steal button UI with full functionality",
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
    Desc = "Infinite health!",
    Default = false,
    Callback = function(state)
        toggleGodMode(state)
    end
})

local AntiVoidToggle = MainTab:Toggle({
    Title = "Anti-Void",
    Desc = "Auto-prevents falling to the void!",
    Default = false,
    Callback = function(state)
        toggleAntiVoid(state)
    end
})

myConfig:Register("StealHelper", StealHelperToggle)
myConfig:Register("AutoLock", AutoLockToggle)
myConfig:Register("GodMode", GodModeToggle)
myConfig:Register("AntiVoid", AntiVoidToggle)
myConfig:Register("InstantSteal", InstantStealToggle)

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
    Title = "Speed Changer (TURN OFF IF NOCLIP IS ON)",
    Desc = "Fully bypassed anti cheat for the speed changer!",
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
        Max = 100,
        Default = 16,
    },
    Callback = function(value)
        updateSpeedValue(value)
    end
})

local NoclipToggle = PlayerTab:Toggle({
    Title = "Noclip",
    Desc = "Noclip bypassed anti cheat, do not turn on if speed changer is on!",
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
    Desc = "Show outline and small name esp above all players!",
    Default = false,
    Callback = function(state)
        togglePlayerESP(state)
    end
})

local BaseTimeESPToggle = VisualTab:Toggle({
    Title = "Base Time ESP",
    Desc = "Show countdown timers on ALL bases!",
    Default = false,
    Callback = function(state)
        toggleBaseTimeESP(state)
    end
})

local BaseTimeAlertToggle = VisualTab:Toggle({
    Title = "Base Time Alert",
    Desc = "Alarm when your base unlocks in 10 seconds",
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

local LowGFXToggle = OptimizationsTab:Toggle({
    Title = "Low GFX Mod",
    Desc = "Make your GFX low for more fps!",
    Default = false,
    Callback = function(state)
        toggleLowGFX(state)
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
myConfig:Register("LowGFX", LowGFXToggle)

-- ========================================
-- CREDITS TAB ELEMENTS
-- ========================================

local CreditsParagraph = CreditsTab:Paragraph({
    Title = "Steal A Anime Hub | Official",
    Desc = "Made by PickleTalk and Mhicel. Join our discord server to be always updated with the latest features and scripts!",
    Color = "Red",
    Thumbnail = "rbxassetid://74135635728836",
    ThumbnailSize = 140,
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
    Title = "Save Configuration",
    Desc = "Save all current settings to file",
    Callback = function()
        saveConfiguration()
    end
})

local LoadConfigButton = SettingsTab:Button({
    Title = "Load Configuration",
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
    Title = "Steal A Anime Hub v2.0",
    Icon = "sword",
    Content = "New: LIGHTNING-FAST NOCLIP with instant anti-cheat recovery! Optimized from Steal A Anime.lua!",
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

print("🗡️ Steal A Anime Hub V2 - ULTRA-OPTIMIZED LOADED!")
print("⚡ Lightning-Fast Noclip Active!")
print("🚀 Enhanced Anti-Cheat Detection Enabled!")
print("💎 Made by PickleTalk and Mhicel")

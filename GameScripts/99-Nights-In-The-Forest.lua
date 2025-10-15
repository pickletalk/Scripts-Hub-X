local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

WindUI:AddTheme({
    Name = "Dark",
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
    Name = "Light",
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

WindUI:SetTheme("Dark")

local Window = WindUI:CreateWindow({
    Title = "99 Nights In The Forest SHX | Official",
    Icon = "sword",
    Author = "by PickleTalk",
    Folder = "Scripts Hub X",
    Transparent = true,
    Theme = "Dark",
})

Window:ToggleTransparency(true)

local ConfigManager = Window.ConfigManager
local myConfig = ConfigManager:CreateConfig("GameName")

Window:EditOpenButton({
    Title = "Scripts Hub X | Official",
    Icon = "monitor",
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

local States = {
    FullBright = false,
    LowGFX = false,
    GodMode = false,
    Speed = false,
    SpeedValue = 100,
    Noclip = false,
    CurrentTheme = "Dark",
}

local Connections = {
    LowGFX = nil,
    Noclip = nil,
}

local LowGFXStorage = {
    SavedProperties = {},
    SavedLighting = {},
}

local cloneref = cloneref or function(...) return ... end
local GetDebugIdHandler = Instance.new("BindableFunction")
local TempHumanoid = Instance.new("Humanoid")
local cachedhumanoids = {}
local CurrentHumanoid
local newindexhook
local indexhook

function GetDebugIdHandler.OnInvoke(obj)
    return obj:GetDebugId()
end

local function GetDebugId(obj)
    return GetDebugIdHandler:Invoke(obj)
end

local function GetWalkSpeed(obj)
    TempHumanoid.WalkSpeed = obj
    return TempHumanoid.WalkSpeed
end

function cachedhumanoids:cacheHumanoid(DebugId, Humanoid)
    cachedhumanoids[DebugId] = {
        currentindex = indexhook(Humanoid, "WalkSpeed"),
        lastnewindex = nil
    }
    return self[DebugId]
end

local split = string.split

indexhook = hookmetamethod(game, "__index", function(self, index)
    if not checkcaller() and typeof(self) == "Instance" then
        if self:IsA("Humanoid") then
            local DebugId = GetDebugId(self)
            local cached = cachedhumanoids[DebugId]

            if self:IsDescendantOf(LocalPlayer.Character) or cached then
                if type(index) == "string" then
                    local cleanindex = split(index, "\0")[1]

                    if cleanindex == "WalkSpeed" then
                        if not cached then
                            cached = cachedhumanoids:cacheHumanoid(DebugId, self)
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

    return indexhook(self, index)
end)

newindexhook = hookmetamethod(game, "__newindex", function(self, index, newindex)
    if not checkcaller() and typeof(self) == "Instance" then
        if self:IsA("Humanoid") then
            local DebugId = GetDebugId(self)
            local cached = cachedhumanoids[DebugId]

            if self:IsDescendantOf(LocalPlayer.Character) or cached then
                if type(index) == "string" then
                    local cleanindex = split(index, "\0")[1]

                    if cleanindex == "WalkSpeed" then
                        if not cached then
                            cached = cachedhumanoids:cacheHumanoid(DebugId, self)
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
    
    return newindexhook(self, index, newindex)
end)

local function GetHumanoid()
    return CurrentHumanoid or (function()
        local char = LocalPlayer.Character
        local Humanoid = char and char:FindFirstChildWhichIsA("Humanoid") or nil
        
        if Humanoid then
            cachedhumanoids:cacheHumanoid(Humanoid:GetDebugId(), Humanoid)
            return cloneref(Humanoid)
        end
    end)()
end

local function SetWalkSpeed(speed)
    local Humanoid = GetHumanoid()

    if Humanoid then
        local connections = {}
        local function AddConnectionsFromSignal(Signal)
            for i, v in getconnections(Signal) do
                if v.State then
                    v:Disable()
                    table.insert(connections, v)
                end
            end
        end
        AddConnectionsFromSignal(Humanoid.Changed)
        AddConnectionsFromSignal(Humanoid:GetPropertyChangedSignal("WalkSpeed"))
        Humanoid.WalkSpeed = speed
        for i, v in connections do
            v:Enable()
        end
    end
end

local function RestoreWalkSpeed()
    local Humanoid = GetHumanoid()
    
    if Humanoid then
        local cached = cachedhumanoids[Humanoid:GetDebugId()]

        if cached then
            SetWalkSpeed(cached.lastnewindex or cached.currentindex)
        end
    end
end

local function activateGodMode()
    local success, err = pcall(function()
        local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
        if RemoteEvents then
            local DamagePlayer = RemoteEvents:WaitForChild("DamagePlayer")
            if DamagePlayer then
                DamagePlayer:FireServer(-math.huge)
                WindUI:Notify({
                    Title = "God Mode",
                    Content = "God Mode activated! You cannot take damage.",
                    Duration = 3,
                    Icon = "shield",
                })
            else
                WindUI:Notify({
                    Title = "Error",
                    Content = "DamagePlayer RemoteEvent not found!",
                    Duration = 3,
                    Icon = "x",
                })
            end
        else
            WindUI:Notify({
                Title = "Error",
                Content = "RemoteEvents folder not found!",
                Duration = 3,
                Icon = "x",
            })
        end
    end)
    
    if not success then
        WindUI:Notify({
            Title = "Error",
            Content = "Failed to activate God Mode: " .. tostring(err),
            Duration = 3,
            Icon = "x",
        })
    end
end

local function toggleSpeed(state)
    States.Speed = state
    
    if state then
        SetWalkSpeed(States.SpeedValue)
        WindUI:Notify({
            Title = "Speed",
            Content = "Speed set to " .. States.SpeedValue,
            Duration = 3,
            Icon = "zap",
        })
    else
        RestoreWalkSpeed()
        WindUI:Notify({
            Title = "Speed",
            Content = "Speed restored to normal",
            Duration = 3,
            Icon = "check",
        })
    end
end

local function updateSpeed(value)
    States.SpeedValue = value
    if States.Speed then
        SetWalkSpeed(value)
    end
end

local function toggleNoclip(state)
    States.Noclip = state
    
    if state then
        Connections.Noclip = RunService.Stepped:Connect(function()
            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        
        WindUI:Notify({
            Title = "Noclip",
            Content = "Noclip enabled! Walk through walls.",
            Duration = 3,
            Icon = "ghost",
        })
    else
        if Connections.Noclip then
            Connections.Noclip:Disconnect()
            Connections.Noclip = nil
        end
        
        if LocalPlayer.Character then
            for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        
        WindUI:Notify({
            Title = "Noclip",
            Content = "Noclip disabled",
            Duration = 3,
            Icon = "check",
        })
    end
end

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
            Content = "Graphics optimized! Original settings saved.",
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

local function changeTheme(themeName)
    WindUI:SetTheme(themeName)
    States.CurrentTheme = themeName
end

local function saveConfiguration()
    myConfig:Save()
    WindUI:Notify({
        Title = "Configuration Saved",
        Content = "All settings have been saved!",
        Duration = 3,
        Icon = "check",
    })
end

local function loadConfiguration()
    myConfig:Load()
    WindUI:Notify({
        Title = "Configuration Loaded",
        Content = "Settings loaded successfully!",
        Duration = 3,
        Icon = "check",
    })
end

local MainTab = Window:Tab({
    Title = "Main",
    Icon = "sword",
})

local OptimizationsTab = Window:Tab({
    Title = "Optimizations",
    Icon = "zap",
})

local CreditsTab = Window:Tab({
    Title = "Credits",
    Icon = "heart",
})

local MiscTab = Window:Tab({
    Title = "Misc",
    Icon = "info",
})

local SettingsTab = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

local GodModeButton = MainTab:Button({
    Title = "God Mode",
    Desc = "Activate God Mode to become invincible",
    Callback = function()
        activateGodMode()
    end
})

local InfJumpButton = MainTab:Button({
    Title = "Inf Jump",
    Desc = "Makes you jump infinitely",
    Callback = function()
        -- Infinite Jump Script (Default Jump Height, Respawn Supported)
        -- by pickletalk

        local Players = game:GetService("Players")
        local UserInputService = game:GetService("UserInputService")

        local player = Players.LocalPlayer
        local originalJumpPower = nil

        -- Function to update the default jump power when character spawns/resets
        local function onCharacterAdded(character)
            local humanoid = character:WaitForChild("Humanoid")
            originalJumpPower = humanoid.JumpPower
        end

        -- Connect for first spawn + future respawns
        player.CharacterAdded:Connect(onCharacterAdded)
        if player.Character then
            onCharacterAdded(player.Character)
        end

        -- Infinite Jump (always uses normal default jump height)
        UserInputService.JumpRequest:Connect(function()
            local character = player.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid and originalJumpPower then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    humanoid.JumpPower = originalJumpPower -- always normal default jump
                end
            end
        end)
    end
})

local SpeedToggle = MainTab:Toggle({
    Title = "Speed",
    Desc = "Enable custom walk speed",
    Default = false,
    Callback = function(state)
        toggleSpeed(state)
    end
})

local SpeedSlider = MainTab:Slider({
    Title = "Speed Value",
    Step = 1,
    Value = {
        Min = 16,
        Max = 500,
        Default = 100,
    },
    Callback = function(value)
        updateSpeed(value)
    end
})

local NoclipToggle = MainTab:Toggle({
    Title = "Noclip",
    Desc = "Walk through walls and objects",
    Default = false,
    Callback = function(state)
        toggleNoclip(state)
    end
})

myConfig:Register("Speed", SpeedToggle)
myConfig:Register("SpeedValue", SpeedSlider)
myConfig:Register("Noclip", NoclipToggle)

local FullBrightToggle = OptimizationsTab:Toggle({
    Title = "Full Bright",
    Desc = "Make everything bright, no more darkness!",
    Default = false,
    Callback = function(state)
        toggleFullBright(state)
    end
})

local LowGFXToggle = OptimizationsTab:Toggle({
    Title = "Low GFX Mode",
    Desc = "Optimize graphics for better performance",
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

local CreditsParagraph = CreditsTab:Paragraph({
    Title = "Scripts Hub X | Official",
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

local currentPlayers = #Players:GetPlayers()
local maxPlayers = Players.MaxPlayers or 0

local ServerInfoParagraph = MiscTab:Paragraph({
    Title = "Server Information",
    Desc = string.format(
        "Game: 99 Nights In The Forest\nPlace ID: %d\nJob ID: %s\nPlayers: %d/%d",
        game.PlaceId or 0,
        tostring(game.JobId or "N/A"),
        currentPlayers,
        maxPlayers
    ),
})

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
        {Title = "Dark", Icon = "moon"},
        {Title = "Light", Icon = "sun"},
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
    Value = "Dark",
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

myConfig:Register("Theme", ThemeDropdown)
myConfig:Register("ThemeColor", ThemeColorPicker)

WindUI:Popup({
    Title = "99 Nights In The Forest V1.0",
    Icon = "sword",
    Content = "New Update: Added God Mode, Speed, Noclip and Kill Aura!",
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

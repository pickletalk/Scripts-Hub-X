-- test.lua - Full Example Usage of Scripts Hub X UI Library
-- This demonstrates all features and components

-- Load the library (replace with your actual loadstring)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/PickleLibrary.lua"))()

-- Create the main window
local Window = Library:CreateWindow({
    Name = "Scripts Hub X | Test Suite",
    Transparency = 0
})

print("✅ Scripts Hub X UI Library Loaded!")

-- ====================================
-- MAIN TAB - Basic Features
-- ====================================
local MainTab = Window:CreateTab("Main")

-- Example Toggle
MainTab:CreateToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(value)
        print("🔄 Auto Farm is now:", value and "ENABLED" or "DISABLED")
        _G.AutoFarm = value
        -- Your auto farm logic here
    end
})

MainTab:CreateToggle({
    Name = "Auto Collect",
    Default = true,
    Callback = function(value)
        print("💎 Auto Collect:", value)
        _G.AutoCollect = value
    end
})

MainTab:CreateToggle({
    Name = "ESP Enabled",
    Default = false,
    Callback = function(value)
        print("👁️ ESP:", value)
        _G.ESP = value
    end
})

-- Example Buttons
MainTab:CreateButton({
    Name = "Refresh Game",
    Callback = function()
        print("🔄 Refreshing game...")
        -- Your refresh logic here
    end
})

MainTab:CreateButton({
    Name = "Print Player Info",
    Callback = function()
        local player = game.Players.LocalPlayer
        print("👤 Player:", player.Name)
        print("📊 UserId:", player.UserId)
        print("💰 Account Age:", player.AccountAge, "days")
    end
})

MainTab:CreateButton({
    Name = "Get Coordinates",
    Callback = function()
        local char = game.Players.LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            local pos = char.HumanoidRootPart.Position
            print("📍 Position:", math.floor(pos.X), math.floor(pos.Y), math.floor(pos.Z))
        end
    end
})

-- ====================================
-- PLAYER TAB - Player Modifications
-- ====================================
local PlayerTab = Window:CreateTab("Player")

-- Toggle with Input Examples
PlayerTab:CreateToggleWithInput({
    Name = "WalkSpeed Modifier",
    ToggleDefault = false,
    InputType = "int",
    InputDefault = 16,
    PlaceholderText = "Enter speed (16-500)...",
    Callback = function(toggle, value)
        print("🏃 WalkSpeed Toggle:", toggle, "| Value:", value)
        
        if toggle then
            _G.WalkSpeedEnabled = true
            _G.WalkSpeed = value
            
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = value
                print("✅ WalkSpeed set to:", value)
            end
        else
            _G.WalkSpeedEnabled = false
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 16
                print("🔄 WalkSpeed reset to default (16)")
            end
        end
    end
})

PlayerTab:CreateToggleWithInput({
    Name = "JumpPower Modifier",
    ToggleDefault = false,
    InputType = "int",
    InputDefault = 50,
    PlaceholderText = "Enter jump power...",
    Callback = function(toggle, value)
        print("🦘 JumpPower Toggle:", toggle, "| Value:", value)
        
        if toggle then
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.JumpPower = value
                print("✅ JumpPower set to:", value)
            end
        else
            local player = game.Players.LocalPlayer
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.JumpPower = 50
                print("🔄 JumpPower reset to default (50)")
            end
        end
    end
})

PlayerTab:CreateToggleWithInput({
    Name = "Field of View",
    ToggleDefault = false,
    InputType = "int",
    InputDefault = 70,
    PlaceholderText = "Enter FOV (70-120)...",
    Callback = function(toggle, value)
        print("📷 FOV Toggle:", toggle, "| Value:", value)
        
        local camera = game.Workspace.CurrentCamera
        if toggle then
            camera.FieldOfView = value
            print("✅ FOV set to:", value)
        else
            camera.FieldOfView = 70
            print("🔄 FOV reset to default (70)")
        end
    end
})

-- Input Examples
PlayerTab:CreateInput({
    Name = "Custom Username Display",
    PlaceholderText = "Enter display name...",
    Type = "string",
    Default = "",
    Callback = function(value)
        print("📝 Custom Username set to:", value)
        _G.CustomUsername = value
    end
})

PlayerTab:CreateInput({
    Name = "Health Amount",
    PlaceholderText = "Enter health value...",
    Type = "int",
    Default = 100,
    Callback = function(value)
        print("❤️ Health amount:", value)
        _G.CustomHealth = value
    end
})

-- ====================================
-- TELEPORT TAB - Teleportation Features
-- ====================================
local TeleportTab = Window:CreateTab("Teleport")

-- Button with Input Examples
TeleportTab:CreateButtonWithInput({
    Name = "Teleport to X Position",
    InputType = "int",
    InputDefault = 0,
    PlaceholderText = "Enter X coordinate...",
    Callback = function(value)
        print("🌐 Teleporting to X:", value)
        
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local currentPos = player.Character.HumanoidRootPart.Position
            player.Character.HumanoidRootPart.CFrame = CFrame.new(
                value,
                currentPos.Y,
                currentPos.Z
            )
            print("✅ Teleported to X:", value)
        end
    end
})

TeleportTab:CreateButtonWithInput({
    Name = "Teleport to Y Position",
    InputType = "int",
    InputDefault = 0,
    PlaceholderText = "Enter Y coordinate...",
    Callback = function(value)
        print("🌐 Teleporting to Y:", value)
        
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local currentPos = player.Character.HumanoidRootPart.Position
            player.Character.HumanoidRootPart.CFrame = CFrame.new(
                currentPos.X,
                value,
                currentPos.Z
            )
            print("✅ Teleported to Y:", value)
        end
    end
})

TeleportTab:CreateButtonWithInput({
    Name = "Teleport to Z Position",
    InputType = "int",
    InputDefault = 0,
    PlaceholderText = "Enter Z coordinate...",
    Callback = function(value)
        print("🌐 Teleporting to Z:", value)
        
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local currentPos = player.Character.HumanoidRootPart.Position
            player.Character.HumanoidRootPart.CFrame = CFrame.new(
                currentPos.X,
                currentPos.Y,
                value
            )
            print("✅ Teleported to Z:", value)
        end
    end
})

TeleportTab:CreateButton({
    Name = "Teleport to Spawn",
    Callback = function()
        print("🏠 Teleporting to spawn...")
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local spawnLocation = workspace:FindFirstChild("SpawnLocation")
            if spawnLocation then
                player.Character.HumanoidRootPart.CFrame = spawnLocation.CFrame + Vector3.new(0, 5, 0)
                print("✅ Teleported to spawn!")
            else
                player.Character.HumanoidRootPart.CFrame = CFrame.new(0, 50, 0)
                print("✅ Teleported to default spawn!")
            end
        end
    end
})

-- ====================================
-- COMBAT TAB - Combat Features
-- ====================================
local CombatTab = Window:CreateTab("Combat")

CombatTab:CreateToggle({
    Name = "Aimbot",
    Default = false,
    Callback = function(value)
        print("🎯 Aimbot:", value)
        _G.Aimbot = value
    end
})

CombatTab:CreateToggle({
    Name = "Silent Aim",
    Default = false,
    Callback = function(value)
        print("🤫 Silent Aim:", value)
        _G.SilentAim = value
    end
})

CombatTab:CreateToggleWithInput({
    Name = "Kill Aura",
    ToggleDefault = false,
    InputType = "int",
    InputDefault = 10,
    PlaceholderText = "Enter range...",
    Callback = function(toggle, value)
        print("⚔️ Kill Aura:", toggle, "| Range:", value)
        _G.KillAura = toggle
        _G.KillAuraRange = value
    end
})

CombatTab:CreateToggle({
    Name = "Infinite Ammo",
    Default = false,
    Callback = function(value)
        print("∞ Infinite Ammo:", value)
        _G.InfiniteAmmo = value
    end
})

CombatTab:CreateToggle({
    Name = "No Recoil",
    Default = false,
    Callback = function(value)
        print("🎯 No Recoil:", value)
        _G.NoRecoil = value
    end
})

-- ====================================
-- VISUAL TAB - Visual Features
-- ====================================
local VisualTab = Window:CreateTab("Visual")

VisualTab:CreateToggle({
    Name = "Player ESP",
    Default = false,
    Callback = function(value)
        print("👁️ Player ESP:", value)
        _G.PlayerESP = value
    end
})

VisualTab:CreateToggle({
    Name = "Item ESP",
    Default = false,
    Callback = function(value)
        print("💎 Item ESP:", value)
        _G.ItemESP = value
    end
})

VisualTab:CreateToggle({
    Name = "Fullbright",
    Default = false,
    Callback = function(value)
        print("💡 Fullbright:", value)
        
        local lighting = game:GetService("Lighting")
        if value then
            _G.OldAmbient = lighting.Ambient
            _G.OldBrightness = lighting.Brightness
            lighting.Ambient = Color3.new(1, 1, 1)
            lighting.Brightness = 2
        else
            lighting.Ambient = _G.OldAmbient or Color3.new(0, 0, 0)
            lighting.Brightness = _G.OldBrightness or 1
        end
    end
})

VisualTab:CreateToggle({
    Name = "No Fog",
    Default = false,
    Callback = function(value)
        print("🌫️ No Fog:", value)
        
        local lighting = game:GetService("Lighting")
        if value then
            _G.OldFogEnd = lighting.FogEnd
            lighting.FogEnd = 9e9
        else
            lighting.FogEnd = _G.OldFogEnd or 100000
        end
    end
})

VisualTab:CreateToggleWithInput({
    Name = "Zoom Distance",
    ToggleDefault = false,
    InputType = "int",
    InputDefault = 50,
    PlaceholderText = "Enter zoom distance...",
    Callback = function(toggle, value)
        print("🔭 Zoom:", toggle, "| Distance:", value)
        
        local player = game.Players.LocalPlayer
        if toggle then
            player.CameraMaxZoomDistance = value
            player.CameraMinZoomDistance = value
        else
            player.CameraMaxZoomDistance = 128
            player.CameraMinZoomDistance = 0.5
        end
    end
})

-- ====================================
-- GAME TAB - Game-Specific Features
-- ====================================
local GameTab = Window:CreateTab("Game")

GameTab:CreateButton({
    Name = "Get Game ID",
    Callback = function()
        print("🎮 Game ID:", game.PlaceId)
        print("🎮 Game Name:", game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name)
    end
})

GameTab:CreateButton({
    Name = "Get Server Info",
    Callback = function()
        print("🖥️ Server JobId:", game.JobId)
        print("👥 Players in Server:", #game.Players:GetPlayers())
        print("⏱️ Server Uptime:", math.floor(workspace.DistributedGameTime), "seconds")
    end
})

GameTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        print("🔄 Rejoining server...")
        local ts = game:GetService("TeleportService")
        local p = game:GetService("Players").LocalPlayer
        ts:Teleport(game.PlaceId, p)
    end
})

GameTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        print("🌐 Server hopping...")
        local Http = game:GetService("HttpService")
        local TPS = game:GetService("TeleportService")
        local Api = "https://games.roblox.com/v1/games/"
        
        local _place = game.PlaceId
        local _servers = Api.._place.."/servers/Public?sortOrder=Asc&limit=100"
        
        function ListServers(cursor)
            local Raw = game:HttpGet(_servers .. ((cursor and "&cursor="..cursor) or ""))
            return Http:JSONDecode(Raw)
        end
        
        local Server, Next
        repeat
            local Servers = ListServers(Next)
            Server = Servers.data[1]
            Next = Servers.nextPageCursor
        until Server
        
        TPS:TeleportToPlaceInstance(_place, Server.id, game.Players.LocalPlayer)
    end
})

GameTab:CreateToggle({
    Name = "Anti-AFK",
    Default = true,
    Callback = function(value)
        print("💤 Anti-AFK:", value)
        
        if value then
            _G.AntiAFK = game:GetService("VirtualUser"):CaptureController()
            _G.AntiAFK:ClickButton2(Vector2.new())
        end
    end
})

GameTab:CreateInput({
    Name = "Game Notes",
    PlaceholderText = "Enter your notes...",
    Type = "string",
    Default = "",
    Callback = function(value)
        print("📝 Notes saved:", value)
        _G.GameNotes = value
    end
})

-- ====================================
-- ADVANCED TAB - Advanced Features
-- ====================================
local AdvancedTab = Window:CreateTab("Advanced")

AdvancedTab:CreateToggle({
    Name = "Debug Mode",
    Default = false,
    Callback = function(value)
        print("🐛 Debug Mode:", value)
        _G.DebugMode = value
    end
})

AdvancedTab:CreateToggle({
    Name = "Performance Monitor",
    Default = false,
    Callback = function(value)
        print("📊 Performance Monitor:", value)
        
        if value then
            _G.PerfMonitor = true
            spawn(function()
                while _G.PerfMonitor do
                    local fps = math.floor(1 / game:GetService("RunService").RenderStepped:Wait())
                    local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
                    print("FPS:", fps, "| Ping:", ping)
                    wait(5)
                end
            end)
        else
            _G.PerfMonitor = false
        end
    end
})

AdvancedTab:CreateButtonWithInput({
    Name = "Execute Lua Code",
    InputType = "string",
    InputDefault = 'print("Hello World!")',
    PlaceholderText = "Enter Lua code...",
    Callback = function(value)
        print("⚡ Executing:", value)
        
        local success, result = pcall(function()
            return loadstring(value)()
        end)
        
        if success then
            print("✅ Executed successfully!")
            if result then print("📤 Result:", result) end
        else
            warn("❌ Error:", result)
        end
    end
})

AdvancedTab:CreateButton({
    Name = "Clear Console",
    Callback = function()
        print("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n")
        print("🧹 Console cleared!")
    end
})

AdvancedTab:CreateButton({
    Name = "Memory Usage",
    Callback = function()
        local stats = game:GetService("Stats")
        print("💾 Memory Usage:", math.floor(stats:GetTotalMemoryUsageMb()), "MB")
    end
})

-- ====================================
-- Print Success Message
-- ====================================
print([[
╔════════════════════════════════════════╗
║   Scripts Hub X UI Library Loaded!    ║
║        All Features Active 🚀          ║
╚════════════════════════════════════════╝
]])

print("📋 Tabs Created:")
print("   • Main - Basic toggles and buttons")
print("   • Player - Player modifications")
print("   • Teleport - Teleportation features")
print("   • Combat - Combat enhancements")
print("   • Visual - Visual modifications")
print("   • Game - Game utilities")
print("   • Advanced - Advanced features")
print("   • Settings - Configuration & themes")
print("   • Misc - Credits & Discord")
print("\n✨ Enjoy using Scripts Hub X!")

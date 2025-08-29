-- Load the Enhanced Pickle UI Library
local Pickle = loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/PickleLibrary.lua"))()

-- Create the main window with RGB automatically enabled
local Window = Pickle.CreateWindow({
    Title = "My Enhanced Script",
    RGB = true, -- RGB is now automatically enabled
    SaveConfiguration = true, -- Enable automatic configuration saving
    ConfigFolder = "MyScriptConfigs", -- Folder name for configs
    ConfigFile = "settings.json" -- JSON file name for configs
})

-- Create 10 tabs as requested
local Tab1 = Window:CreateTab("Combat")
local Tab2 = Window:CreateTab("Movement") 
local Tab3 = Window:CreateTab("Visuals")
local Tab4 = Window:CreateTab("Farming")
local Tab5 = Window:CreateTab("Teleports")
local Tab6 = Window:CreateTab("Player")
local Tab7 = Window:CreateTab("World")
local Tab8 = Window:CreateTab("Misc")
local Tab9 = Window:CreateTab("Settings")
local Tab10 = Window:CreateTab("Info")

-- TAB 1: COMBAT
local CombatSection = Tab1:CreateSection("🗡️ Combat Features")

local killall = CombatSection:CreateButton("Kill All", function()
    print("Kill All activated!")
    -- Your kill all code here
end)

local killaura = CombatSection:CreateButton("Kill Aura", function()
    print("Kill Aura toggled!")
    -- Your kill aura code here
end)

local AutoAttackToggle = CombatSection:CreateToggle("Auto Attack", false, function(value)
    print("Auto Attack:", value)
    -- Your auto attack code here
end)

local DamageSlider = CombatSection:CreateSlider("Damage Multiplier", 1, 10, 1, function(value)
    print("Damage set to:", value)
    -- Your damage multiplier code here
end)

local KillAllKeybind = CombatSection:CreateKeybind("Kill All Hotkey", "K", function()
    print("Kill All activated via keybind!")
    -- Your kill all code here
end)

-- TAB 2: MOVEMENT
local MovementSection = Tab2:CreateSection("🏃 Movement Features")

local fly = MovementSection:CreateButton("Fly", function()
    print("Fly toggled!")
    -- Your fly code here
end)

local SpeedToggle = MovementSection:CreateToggle("Speed Hack", false, function(value)
    print("Speed Hack:", value)
    -- Your speed hack code here
end)

local WalkSpeedSlider = MovementSection:CreateSlider("Walk Speed", 16, 100, 16, function(value)
    print("Walk Speed set to:", value)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    end
end)

local JumpPowerSlider = MovementSection:CreateSlider("Jump Power", 50, 200, 50, function(value)
    print("Jump Power set to:", value)
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
        game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    end
end)

local FlyKeybind = MovementSection:CreateKeybind("Fly Toggle", "F", function()
    print("Fly toggled via keybind!")
    -- Your fly toggle code here
end)

-- TAB 3: VISUALS
local VisualsSection = Tab3:CreateSection("👁️ Visual Features")

local esp = VisualsSection:CreateButton("Player ESP", function()
    print("Player ESP toggled!")
    -- Your ESP code here
end)

local FullbrightToggle = VisualsSection:CreateToggle("Fullbright", false, function(value)
    print("Fullbright:", value)
    -- Your fullbright code here
end)

local FOVSlider = VisualsSection:CreateSlider("FOV", 70, 120, 70, function(value)
    print("FOV set to:", value)
    if workspace.CurrentCamera then
        workspace.CurrentCamera.FieldOfView = value
    end
end)

local ESPKeybind = VisualsSection:CreateKeybind("ESP Toggle", "E", function()
    print("ESP toggled via keybind!")
    -- Your ESP toggle code here
end)

-- TAB 4: FARMING
local FarmingSection = Tab4:CreateSection("🌾 Auto Farming")

local startfarm = FarmingSection:CreateButton("Start Farm", function()
    print("Auto farming started!")
    -- Your farming code here
end)

local AutoFarmToggle = FarmingSection:CreateToggle("Auto Farm", false, function(value)
    print("Auto Farm:", value)
    -- Your auto farm toggle code here
end)

local FarmSpeedSlider = FarmingSection:CreateSlider("Farm Speed", 1, 10, 1, function(value)
    print("Farm Speed:", value)
    -- Your farm speed code here
end)

local FarmKeybind = FarmingSection:CreateKeybind("Farm Toggle", "G", function()
    print("Auto farm toggled via keybind!")
    -- Your farm toggle code here
end)

-- TAB 5: TELEPORTS
local TeleportSection = Tab5:CreateSection("🚀 Teleportation")

local teleport = TeleportSection:CreateButton("Teleport to Spawn", function()
    print("Teleporting to spawn!")
    if game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character:MoveTo(Vector3.new(0, 10, 0))
    end
end)

local teleporttoplayers = TeleportSection:CreateButton("Teleport to Players", function()
    print("Opening player teleport menu!")
    -- Your player teleport code here
end)

local SafeTeleportToggle = TeleportSection:CreateToggle("Safe Teleport", true, function(value)
    print("Safe Teleport:", value)
    -- Your safe teleport code here
end)

local TeleportKeybind = TeleportSection:CreateKeybind("Spawn TP", "H", function()
    print("Teleporting to spawn via keybind!")
    if game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character:MoveTo(Vector3.new(0, 10, 0))
    end
end)

-- TAB 6: PLAYER
local PlayerSection = Tab6:CreateSection("🧑 Player Modifications")

local invisible = PlayerSection:CreateButton("Invisible", function()
    print("Invisibility toggled!")
    -- Your invisibility code here
end)

local GodModeToggle = PlayerSection:CreateToggle("God Mode", false, function(value)
    print("God Mode:", value)
    -- Your god mode code here
end)

local HealthSlider = PlayerSection:CreateSlider("Max Health", 100, 1000, 100, function(value)
    print("Max Health set to:", value)
    -- Your health modification code here
end)

local GodModeKeybind = PlayerSection:CreateKeybind("God Mode", "J", function()
    print("God Mode toggled via keybind!")
    -- Your god mode toggle code here
end)

-- TAB 7: WORLD
local WorldSection = Tab7:CreateSection("🌍 World Modifications")

local removewalls = WorldSection:CreateButton("Remove Walls", function()
    print("Removing walls!")
    -- Your wall removal code here
end)

local NoClipToggle = WorldSection:CreateToggle("No Clip", false, function(value)
    print("No Clip:", value)
    -- Your no clip code here
end)

local GravitySlider = WorldSection:CreateSlider("Gravity", 0, 196, 196, function(value)
    print("Gravity set to:", value)
    workspace.Gravity = value
end)

local NoClipKeybind = WorldSection:CreateKeybind("NoClip Toggle", "N", function()
    print("NoClip toggled via keybind!")
    -- Your noclip toggle code here
end)

-- TAB 8: MISC
local MiscSection = Tab8:CreateSection("⚡ Miscellaneous")

local rejoin = MiscSection:CreateButton("Rejoin Server", function()
    print("Rejoining server...")
    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
end)

local ChatSpamToggle = MiscSection:CreateToggle("Chat Spam", false, function(value)
    print("Chat Spam:", value)
    -- Your chat spam code here
end)

local SpamDelaySlider = MiscSection:CreateSlider("Spam Delay", 1, 10, 3, function(value)
    print("Spam Delay:", value, "seconds")
    -- Your spam delay code here
end)

local RejoinKeybind = MiscSection:CreateKeybind("Rejoin Server", "R", function()
    print("Rejoining server via keybind...")
    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
end)

-- TAB 9: SETTINGS
local SettingsSection = Tab9:CreateSection("⚙️ Script Settings")

local save = SettingsSection:CreateButton("Save Config", function()
    Window:SaveConfiguration()
    print("Configuration saved manually!")
end)

local save = SettingsSection:CreateButton("Load Config", function()
    Window:LoadConfiguration()
    print("Configuration loaded manually!")
end)

local reset = SettingsSection:CreateButton("Reset Config", function()
    print("Resetting configuration...")
    -- Reset all toggles and sliders to defaults
    AutoAttackToggle.SetValue(false)
    SpeedToggle.SetValue(false)
    FullbrightToggle.SetValue(false)
    AutoFarmToggle.SetValue(false)
    SafeTeleportToggle.SetValue(true)
    GodModeToggle.SetValue(false)
    NoClipToggle.SetValue(false)
    ChatSpamToggle.SetValue(false)
    
    DamageSlider.SetValue(1)
    WalkSpeedSlider.SetValue(16)
    JumpPowerSlider.SetValue(50)
    FarmSpeedSlider.SetValue(1)
    HealthSlider.SetValue(100)
    GravitySlider.SetValue(196)
    SpamDelaySlider.SetValue(3)
    UIScaleSlider.SetValue(1.0)
    
    print("Configuration reset to defaults!")
end)

local AutoSaveToggle = SettingsSection:CreateToggle("Auto Save", true, function(value)
    print("Auto Save:", value)
    -- Your auto save code here
end)

local UIScaleSlider = SettingsSection:CreateSlider("UI Scale", 0.8, 1.5, 1.0, function(value)
    print("UI Scale:", value)
    -- Your UI scaling code here
end)

-- TAB 10: INFO
local InfoSection = Tab10:CreateSection("ℹ️ Information")

local info = InfoSection:CreateButton("Script Info", function()
    print("=== SCRIPT INFORMATION ===")
    print("Script Name: My Enhanced Script")
    print("Version: 3.0.0")
    print("Author: Enhanced by Claude")
    print("Last Updated: " .. os.date("%m/%d/%Y"))
    print("Features: RGB UI, Smooth Animations, Enhanced Sliders")
    print("UI Framework: Pickle Library Enhanced")
    print("===========================")
end)

local discord = InfoSection:CreateButton("Discord Server", function()
    print("Discord: https://discord.gg/yourserver")
    print("Join our community for updates and support!")
    -- Copy to clipboard if possible
end)

local githubrepo = InfoSection:CreateButton("GitHub Repository", function()
    print("GitHub: https://github.com/yourrepo/enhanced-script")
    print("Check out the source code and contribute!")
end)

local ShowFPSToggle = InfoSection:CreateToggle("Show FPS", false, function(value)
    print("Show FPS:", value)
    -- Your FPS display code here
    if value then
        -- Create FPS display
        print("FPS display enabled")
    else
        -- Remove FPS display
        print("FPS display disabled")
    end
end)

local ShowPingToggle = InfoSection:CreateToggle("Show Ping", false, function(value)
    print("Show Ping:", value)
    -- Your ping display code here
    if value then
        -- Create ping display
        print("Ping display enabled")
    else
        -- Remove ping display
        print("Ping display disabled")
    end
end)

local ShowTimeToggle = InfoSection:CreateToggle("Show Time", false, function(value)
    print("Show Time:", value)
    -- Your time display code here
end)

-- Advanced functionality loop
spawn(function()
    while true do
        wait(0.1) -- Faster update rate for smoother performance
        
        -- Example: Check if auto attack is enabled
        if AutoAttackToggle.GetValue() then
            -- Do auto attack logic
            -- print("Auto attacking...")
        end
        
        -- Example: Use the current damage value
        local currentDamage = DamageSlider.GetValue()
        -- Apply damage multiplier logic
        
        -- Example: Check speed hack
        if SpeedToggle.GetValue() then
            -- Keep applying speed
            local currentSpeed = WalkSpeedSlider.GetValue()
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = currentSpeed
            end
        end
        
        -- Example: Auto farm logic
        if AutoFarmToggle.GetValue() then
            -- Do farming logic based on farm speed
            local farmSpeed = FarmSpeedSlider.GetValue()
            -- Implement your farming code here
        end
        
        -- Example: God mode check
        if GodModeToggle.GetValue() then
            -- Keep applying god mode
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                local maxHealth = HealthSlider.GetValue()
                game.Players.LocalPlayer.Character.Humanoid.MaxHealth = maxHealth
                game.Players.LocalPlayer.Character.Humanoid.Health = maxHealth
            end
        end
        
        -- Example: No clip logic
        if NoClipToggle.GetValue() then
            -- Apply no clip
            if game.Players.LocalPlayer.Character then
                for _, part in pairs(game.Players.LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end
        
        -- Example: Chat spam
        if ChatSpamToggle.GetValue() then
            local spamDelay = SpamDelaySlider.GetValue()
            -- Implement chat spam with delay
        end
    end
end)

-- Performance monitoring
spawn(function()
    local lastTime = tick()
    while true do
        wait(1)
        local currentTime = tick()
        local fps = math.floor(1 / (currentTime - lastTime))
        lastTime = currentTime
        
        if ShowFPSToggle.GetValue() then
            print("Current FPS:", fps)
        end
        
        if ShowPingToggle.GetValue() then
            local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
            print("Current Ping:", ping)
        end
        
        if ShowTimeToggle.GetValue() then
            print("Current Time:", os.date("%H:%M:%S"))
        end
    end
end)

Window:LoadConfiguration()

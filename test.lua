-- Load the Pickle UI Library (replace with your script URL)
local Pickle = loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/PickleLibrary.lua"))()

-- Create the main window with RGB enabled
local Window = Pickle.CreateWindow({
    Title = "My Script",
    RGB = true, -- Enable RGB with 0.5 transparency
    ConfigFolder = "MyScriptConfig",
    ConfigFile = "settings.json"
})

print("Window created successfully!")

-- Create 10 tabs as requested
local Tab1 = Window:CreateTab("Combat")
print("Tab1 created")
local Tab2 = Window:CreateTab("Movement") 
print("Tab2 created")
local Tab3 = Window:CreateTab("Visuals")
print("Tab3 created")
local Tab4 = Window:CreateTab("Farming")
print("Tab4 created")
local Tab5 = Window:CreateTab("Teleports")
print("Tab5 created")
local Tab6 = Window:CreateTab("Player")
print("Tab6 created")
local Tab7 = Window:CreateTab("World")
print("Tab7 created")
local Tab8 = Window:CreateTab("Misc")
print("Tab8 created")
local Tab9 = Window:CreateTab("Settings")
print("Tab9 created")
local Tab10 = Window:CreateTab("Info")
print("Tab10 created")

-- Wait a moment for everything to load
wait(0.5)

-- TAB 1: COMBAT
print("Creating Combat section...")
local CombatSection = Tab1:CreateSection("Combat Features")

print("Creating Combat buttons...")
CombatSection:CreateButton("Kill All", function()
    print("Kill All activated!")
    -- Your kill all code here
end)

CombatSection:CreateButton("Kill Aura", function()
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

print("Combat tab completed!")

-- TAB 2: MOVEMENT
print("Creating Movement section...")
local MovementSection = Tab2:CreateSection("Movement Features")

MovementSection:CreateButton("Fly", function()
    print("Fly toggled!")
    -- Your fly code here
end)

local SpeedToggle = MovementSection:CreateToggle("Speed Hack", false, function(value)
    print("Speed Hack:", value)
    -- Your speed hack code here
end)

local WalkSpeedSlider = MovementSection:CreateSlider("Walk Speed", 16, 100, 16, function(value)
    print("Walk Speed set to:", value)
    pcall(function()
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end)
end)

local JumpPowerSlider = MovementSection:CreateSlider("Jump Power", 50, 200, 50, function(value)
    print("Jump Power set to:", value)
    pcall(function()
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end)
end)

print("Movement tab completed!")

-- TAB 3: VISUALS
print("Creating Visuals section...")
local VisualsSection = Tab3:CreateSection("Visual Features")

VisualsSection:CreateButton("Player ESP", function()
    print("Player ESP toggled!")
    -- Your ESP code here
end)

local FullbrightToggle = VisualsSection:CreateToggle("Fullbright", false, function(value)
    print("Fullbright:", value)
    -- Your fullbright code here
end)

local FOVSlider = VisualsSection:CreateSlider("FOV", 70, 120, 70, function(value)
    print("FOV set to:", value)
    pcall(function()
        if workspace.CurrentCamera then
            workspace.CurrentCamera.FieldOfView = value
        end
    end)
end)

print("Visuals tab completed!")

-- TAB 4: FARMING
print("Creating Farming section...")
local FarmingSection = Tab4:CreateSection("Auto Farming")

FarmingSection:CreateButton("Start Farm", function()
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

print("Farming tab completed!")

-- TAB 5: TELEPORTS
print("Creating Teleports section...")
local TeleportSection = Tab5:CreateSection("Teleportation")

TeleportSection:CreateButton("Teleport to Spawn", function()
    print("Teleporting to spawn!")
    pcall(function()
        if game.Players.LocalPlayer.Character then
            game.Players.LocalPlayer.Character:MoveTo(Vector3.new(0, 10, 0))
        end
    end)
end)

TeleportSection:CreateButton("Teleport to Players", function()
    print("Opening player teleport menu!")
    -- Your player teleport code here
end)

local SafeTeleportToggle = TeleportSection:CreateToggle("Safe Teleport", true, function(value)
    print("Safe Teleport:", value)
    -- Your safe teleport code here
end)

print("Teleports tab completed!")

-- TAB 6: PLAYER
print("Creating Player section...")
local PlayerSection = Tab6:CreateSection("Player Modifications")

PlayerSection:CreateButton("Invisible", function()
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

print("Player tab completed!")

-- TAB 7: WORLD
print("Creating World section...")
local WorldSection = Tab7:CreateSection("World Modifications")

WorldSection:CreateButton("Remove Walls", function()
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

print("World tab completed!")

-- TAB 8: MISC
print("Creating Misc section...")
local MiscSection = Tab8:CreateSection("Miscellaneous")

MiscSection:CreateButton("Rejoin Server", function()
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

print("Misc tab completed!")

-- TAB 9: SETTINGS
print("Creating Settings section...")
local SettingsSection = Tab9:CreateSection("Script Settings")

SettingsSection:CreateButton("Save Config", function()
    print("Configuration saved!")
    -- Save all your settings here
end)

SettingsSection:CreateButton("Load Config", function()
    print("Configuration loaded!")
    -- Load all your settings here
end)

local AutoSaveToggle = SettingsSection:CreateToggle("Auto Save", true, function(value)
    print("Auto Save:", value)
    -- Your auto save code here
end)

local UIScaleSlider = SettingsSection:CreateSlider("UI Scale", 0.8, 1.5, 1.0, function(value)
    print("UI Scale:", value)
    -- Your UI scaling code here
end)

print("Settings tab completed!")

-- TAB 10: INFO
print("Creating Info section...")
local InfoSection = Tab10:CreateSection("Information")

InfoSection:CreateButton("Script Info", function()
    print("Script Name: My Awesome Script")
    print("Version: 2.1.0")
    print("Author: YourName")
    print("Last Updated: " .. os.date("%m/%d/%Y"))
end)

InfoSection:CreateButton("Discord Server", function()
    print("Discord: https://discord.gg/yourserver")
    -- Copy to clipboard if possible
end)

local ShowFPSToggle = InfoSection:CreateToggle("Show FPS", false, function(value)
    print("Show FPS:", value)
    -- Your FPS display code here
end)

local ShowPingToggle = InfoSection:CreateToggle("Show Ping", false, function(value)
    print("Show Ping:", value)
    -- Your ping display code here
end)

print("Info tab completed!")

-- Wait for everything to load, then force select the first tab
wait(1)
print("Forcing first tab selection...")
local tabs = Window:GetTabs()
if tabs and tabs[1] and tabs[1].button then
    tabs[1].button:Fire("MouseButton1Click")
    print("First tab should now be visible")
end

-- Example of how to use the toggle/slider values later
spawn(function()
    while true do
        wait(1)
        
        -- Example: Check if auto attack is enabled
        if AutoAttackToggle and AutoAttackToggle.GetValue() then
            -- Do auto attack logic
            -- print("Auto attacking...")
        end
        
        -- Example: Use the current damage value
        if DamageSlider then
            local currentDamage = DamageSlider.GetValue()
            -- Apply damage multiplier logic
        end
        
        -- Example: Check speed hack
        if SpeedToggle and SpeedToggle.GetValue() then
            -- Keep applying speed
            if WalkSpeedSlider then
                local currentSpeed = WalkSpeedSlider.GetValue()
                pcall(function()
                    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = currentSpeed
                    end
                end)
            end
        end
    end
end)

print("===========================================")
print("Pickle UI Test Script loaded successfully!")
print("All 10 tabs created with various functions:")
print("- Combat: 2 Buttons, 1 Toggle, 1 Slider")
print("- Movement: 1 Button, 1 Toggle, 2 Sliders") 
print("- Visuals: 1 Button, 1 Toggle, 1 Slider")
print("- Farming: 1 Button, 1 Toggle, 1 Slider")
print("- Teleports: 2 Buttons, 1 Toggle")
print("- Player: 1 Button, 1 Toggle, 1 Slider")
print("- World: 1 Button, 1 Toggle, 1 Slider")
print("- Misc: 1 Button, 1 Toggle, 1 Slider")
print("- Settings: 2 Buttons, 1 Toggle, 1 Slider")
print("- Info: 2 Buttons, 2 Toggles")
print("===========================================")
print("Try clicking on different tabs to switch!")
print("All buttons and toggles should be visible now!")
print("===========================================")ttack code here
end)

local DamageSlider = CombatSection:CreateSlider("Damage Multiplier", 1, 10, 1, function(value)
    print("Damage set to:", value)
    -- Your damage multiplier code here
end)

-- TAB 2: MOVEMENT
local MovementSection = Tab2:CreateSection("Movement Features")

MovementSection:CreateButton("Fly", function()
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

-- TAB 3: VISUALS
local VisualsSection = Tab3:CreateSection("Visual Features")

VisualsSection:CreateButton("Player ESP", function()
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

-- TAB 4: FARMING
local FarmingSection = Tab4:CreateSection("Auto Farming")

FarmingSection:CreateButton("Start Farm", function()
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

-- TAB 5: TELEPORTS
local TeleportSection = Tab5:CreateSection("Teleportation")

TeleportSection:CreateButton("Teleport to Spawn", function()
    print("Teleporting to spawn!")
    if game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character:MoveTo(Vector3.new(0, 10, 0))
    end
end)

TeleportSection:CreateButton("Teleport to Players", function()
    print("Opening player teleport menu!")
    -- Your player teleport code here
end)

local SafeTeleportToggle = TeleportSection:CreateToggle("Safe Teleport", true, function(value)
    print("Safe Teleport:", value)
    -- Your safe teleport code here
end)

-- TAB 6: PLAYER
local PlayerSection = Tab6:CreateSection("Player Modifications")

PlayerSection:CreateButton("Invisible", function()
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

-- TAB 7: WORLD
local WorldSection = Tab7:CreateSection("World Modifications")

WorldSection:CreateButton("Remove Walls", function()
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

-- TAB 8: MISC
local MiscSection = Tab8:CreateSection("Miscellaneous")

MiscSection:CreateButton("Rejoin Server", function()
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

-- TAB 9: SETTINGS
local SettingsSection = Tab9:CreateSection("Script Settings")

SettingsSection:CreateButton("Save Config", function()
    print("Configuration saved!")
    -- Save all your settings here
end)

SettingsSection:CreateButton("Load Config", function()
    print("Configuration loaded!")
    -- Load all your settings here
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
local InfoSection = Tab10:CreateSection("Information")

InfoSection:CreateButton("Script Info", function()
    print("Script Name: My Awesome Script")
    print("Version: 2.1.0")
    print("Author: YourName")
    print("Last Updated: " .. os.date("%m/%d/%Y"))
end)

InfoSection:CreateButton("Discord Server", function()
    print("Discord: https://discord.gg/yourserver")
    -- Copy to clipboard if possible
end)

local ShowFPSToggle = InfoSection:CreateToggle("Show FPS", false, function(value)
    print("Show FPS:", value)
    -- Your FPS display code here
end)

local ShowPingToggle = InfoSection:CreateToggle("Show Ping", false, function(value)
    print("Show Ping:", value)
    -- Your ping display code here
end)

-- Example of how to use the toggle/slider values later
spawn(function()
    while true do
        wait(1)
        
        -- Example: Check if auto attack is enabled
        if AutoAttackToggle.GetValue() then
            -- Do auto attack logic
            print("Auto attacking...")
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
    end
end)

print("Pickle UI Test Script loaded successfully!")
print("All 10 tabs created with various functions")
print("- Combat: Buttons, Toggle, Slider")
print("- Movement: Button, Toggle, 2 Sliders") 
print("- Visuals: Button, Toggle, Slider")
print("- Farming: Button, Toggle, Slider")
print("- Teleports: 2 Buttons, Toggle")
print("- Player: Button, Toggle, Slider")
print("- World: Button, Toggle, Slider")
print("- Misc: Button, Toggle, Slider")
print("- Settings: 2 Buttons, Toggle, Slider")
print("- Info: 2 Buttons, 2 Toggles")

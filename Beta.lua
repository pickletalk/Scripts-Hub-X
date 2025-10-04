-- Scripts Hub X | Official - Fixed Beta Version
-- All syntax errors corrected with proper method notation

-- Load the PickleLibrary with error handling
local Library
local success, err = pcall(function()
    Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/PickleLibrary.lua"))()
end)

if not success then
    warn("Failed to load PickleLibrary:", err)
    return
end

-- Create a window with title and transparency
local Window = Library:CreateWindow({
    Name = "Scripts Hub X Official",
    Transparency = 0
})

-- ========================================
-- MAIN TAB
-- ========================================
local MainTab = Window:CreateTab("Main")

-- Toggle example
MainTab:CreateToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(value)
        print("Auto Farm toggled:", value)
        -- Add your auto farm logic here
        if value then
            print("Starting auto farm...")
        else
            print("Stopping auto farm...")
        end
    end
})

-- Button example
MainTab:CreateButton({
    Name = "Click Me",
    Callback = function()
        print("Button clicked!")
        -- Add your button action here
    end
})

-- Input example
MainTab:CreateInput({
    Name = "Player Name",
    PlaceholderText = "Enter player name...",
    Type = "string",
    Default = "",
    Callback = function(value)
        print("Input changed:", value)
        -- Add your input handling here
    end
})

-- Toggle with input example
MainTab:CreateToggleWithInput({
    Name = "Speed Hack",
    ToggleDefault = false,
    InputType = "int",
    InputDefault = 16,
    PlaceholderText = "Speed value...",
    Callback = function(toggle, value)
        print("Speed Hack toggled:", toggle, "Value:", value)
        -- Add your speed hack logic here
        if toggle then
            -- Apply speed
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = value
            end
        else
            -- Reset speed
            local player = game.Players.LocalPlayer
            if player and player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = 16
            end
        end
    end
})

-- Button with input example
MainTab:CreateButtonWithInput({
    Name = "Teleport to Position",
    InputType = "int",
    InputDefault = 100,
    PlaceholderText = "Enter position...",
    Callback = function(value)
        print("Teleporting to:", value)
        -- Add your teleport logic here
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            player.Character.HumanoidRootPart.CFrame = CFrame.new(value, value, value)
        end
    end
})

-- Additional toggle example
MainTab:CreateToggle({
    Name = "ESP (Players)",
    Default = false,
    Callback = function(value)
        print("ESP toggled:", value)
        -- Add ESP logic here
    end
})

-- Additional button example
MainTab:CreateButton({
    Name = "Collect All Items",
    Callback = function()
        print("Collecting all items...")
        -- Add collection logic here
    end
})

-- ========================================
-- COMBAT TAB
-- ========================================
local CombatTab = Window:CreateTab("Combat")

CombatTab:CreateToggle({
    Name = "Auto Attack",
    Default = false,
    Callback = function(value)
        print("Auto Attack toggled:", value)
        -- Add auto attack logic
    end
})

CombatTab:CreateToggleWithInput({
    Name = "Damage Multiplier",
    ToggleDefault = false,
    InputType = "number",
    InputDefault = 1.5,
    PlaceholderText = "Multiplier value...",
    Callback = function(toggle, value)
        print("Damage Multiplier:", toggle, "Value:", value)
        -- Add damage multiplier logic
    end
})

CombatTab:CreateButton({
    Name = "Kill All Enemies",
    Callback = function()
        print("Killing all enemies...")
        -- Add kill all logic
    end
})

-- ========================================
-- PLAYER TAB
-- ========================================
local PlayerTab = Window:CreateTab("Player")

PlayerTab:CreateToggleWithInput({
    Name = "Jump Power",
    ToggleDefault = false,
    InputType = "int",
    InputDefault = 50,
    PlaceholderText = "Jump power...",
    Callback = function(toggle, value)
        print("Jump Power:", toggle, "Value:", value)
        local player = game.Players.LocalPlayer
        if player and player.Character and player.Character:FindFirstChild("Humanoid") then
            if toggle then
                player.Character.Humanoid.JumpPower = value
            else
                player.Character.Humanoid.JumpPower = 50
            end
        end
    end
})

PlayerTab:CreateToggle({
    Name = "Infinite Jump",
    Default = false,
    Callback = function(value)
        print("Infinite Jump toggled:", value)
        -- Add infinite jump logic
    end
})

PlayerTab:CreateToggle({
    Name = "No Clip",
    Default = false,
    Callback = function(value)
        print("No Clip toggled:", value)
        -- Add no clip logic
    end
})

PlayerTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player and player.Character then
            player.Character:BreakJoints()
        end
    end
})

-- ========================================
-- SETTINGS TAB (Already auto-created by library)
-- ========================================
-- The library automatically creates Settings tab with:
-- - Save Configuration
-- - Load Configuration
-- - Theme selector
-- - Transparency toggle

-- You can add additional settings if needed:
local SettingsTab = Window:CreateTab("Settings")

-- Note: The library already adds default settings, but you can add more
SettingsTab:CreateToggle({
    Name = "Show Notifications",
    Default = true,
    Callback = function(value)
        print("Notifications:", value)
        -- Add notification toggle logic
    end
})

-- ========================================
-- MISC TAB (Already auto-created by library)
-- ========================================
-- The library automatically creates Misc tab with Discord button
-- You can add additional misc features:

local MiscTab = Window:CreateTab("Misc")

MiscTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        local TeleportService = game:GetService("TeleportService")
        local Players = game:GetService("Players")
        local player = Players.LocalPlayer
        
        TeleportService:Teleport(game.PlaceId, player)
    end
})

MiscTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        print("Server hopping...")
        -- Add server hop logic
    end
})

MiscTab:CreateInput({
    Name = "Custom Message",
    PlaceholderText = "Enter message...",
    Type = "string",
    Default = "",
    Callback = function(value)
        print("Custom message:", value)
        -- Add custom message logic
    end
})

-- ========================================
-- CREDITS TAB
-- ========================================
local CreditsTab = Window:CreateTab("Credits")

CreditsTab:CreateButton({
    Name = "Join Discord",
    Callback = function()
        setclipboard("https://discord.gg/bpsNUH5sVb")
        print("Discord invite copied to clipboard!")
    end
})

-- ========================================
-- INITIALIZATION COMPLETE
-- ========================================
print("╔════════════════════════════════════════╗")
print("║   Scripts Hub X | Official - Loaded   ║")
print("║      UI Version: 1.0.0 (Fixed)        ║")
print("╚════════════════════════════════════════╝")
print("")
print("All features loaded successfully!")
print("Tabs created: Main, Combat, Player, Settings, Misc, Credits")
print("")
print("Press the minimize button to toggle UI visibility")

-- PickleLibrary Test Script
-- This script demonstrates how to use PickleLibrary

-- First, you need to load the PickleLibrary script into your environment
-- Then execute this test script

-- Load PickleLibrary (replace this line with actual library loading)
local PickleLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/Picklelibrary.lua"))()

-- Initialize PickleLibrary configuration
local Window = PickleLibrary:LoadConfiguration()

-- Create main window
local MainWindow = PickleLibrary:Load("PickleLibrary Demo", "rbxassetid://14133403065")

-- Create first tab
local MainTab = PickleLibrary.newTab("Main", "rbxassetid://14133403065")

-- Add a label
MainTab.newLabel("Welcome to PickleLibrary!")

-- Add a button
MainTab.newButton("Test Button", "This is a test button", function()
    print("Button clicked!")
end)

-- Add a toggle
MainTab.newToggle("Speed Hack", "Enables/disables speed hack", false, function(state)
    if state then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
        print("Speed enabled!")
    else
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        print("Speed disabled!")
    end
end)

-- Add a slider
MainTab.newSlider("WalkSpeed", "Changes your walkspeed", 100, false, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
    print("WalkSpeed set to:", value)
end)

-- Add a textbox
MainTab.newInput("Player Name", "Enter a player name", function(text)
    print("You entered:", text)
    -- You can add teleport to player functionality here
end)

-- Add a keybind
MainTab.newKeybind("Toggle GUI", "Press to toggle the GUI", function(input)
    print("Keybind pressed:", input.KeyCode.Name)
    MainWindow:Toggle()
end)

-- Add a dropdown
MainTab.newDropdown("Game Mode", "Select a game mode", {"Normal", "Speed", "Fly", "Noclip"}, function(selected)
    print("Selected mode:", selected)
    if selected == "Speed" then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 50
    elseif selected == "Normal" then
        game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
    elseif selected == "Fly" then
        print("Fly mode activated!")
        -- Add fly script here
    elseif selected == "Noclip" then
        print("Noclip mode activated!")
        -- Add noclip script here
    end
end)

-- Create second tab for settings
local SettingsTab = PickleLibrary.newTab("Settings", "rbxassetid://14122651741")

-- Add settings label
SettingsTab.newLabel("Library Settings")

-- Add theme button
SettingsTab.newButton("Change Theme", "Changes the library theme", function()
    -- Change to purple theme
    MainWindow:SetTheme(Color3.fromRGB(75, 0, 130), Color3.fromRGB(138, 43, 226))
    print("Theme changed to purple!")
end)

-- Add reset theme button
SettingsTab.newButton("Reset Theme", "Resets to default blue theme", function()
    -- Reset to default blue theme
    MainWindow:SetTheme(Color3.fromRGB(19, 19, 70), Color3.fromRGB(100, 149, 237))
    print("Theme reset to default!")
end)

-- Add hide/show buttons
SettingsTab.newButton("Hide GUI", "Hides the GUI", function()
    MainWindow:Hide()
end)

SettingsTab.newButton("Show GUI", "Shows the GUI", function()
    MainWindow:Show()
end)

-- Add close button
SettingsTab.newButton("Close GUI", "Closes the GUI", function()
    MainWindow:Close()
end)

-- Create third tab for player utilities
local PlayerTab = PickleLibrary.newTab("Player", "rbxassetid://14133403065")

-- Player utilities label
PlayerTab.newLabel("Player Utilities")

-- Jump power slider
PlayerTab.newSlider("Jump Power", "Changes your jump power", 200, false, function(value)
    game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
    print("Jump power set to:", value)
end)

-- Health toggle
PlayerTab.newToggle("Infinite Health", "Gives you infinite health", false, function(state)
    if state then
        game.Players.LocalPlayer.Character.Humanoid.MaxHealth = math.huge
        game.Players.LocalPlayer.Character.Humanoid.Health = math.huge
        print("Infinite health enabled!")
    else
        game.Players.LocalPlayer.Character.Humanoid.MaxHealth = 100
        game.Players.LocalPlayer.Character.Humanoid.Health = 100
        print("Infinite health disabled!")
    end
end)

-- Teleport textbox
PlayerTab.newInput("Teleport to Player", "Enter player name to teleport", function(text)
    local targetPlayer = game.Players:FindFirstChild(text)
    if targetPlayer and targetPlayer.Character then
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        print("Teleported to:", text)
    else
        print("Player not found:", text)
    end
end)

-- God mode keybind
PlayerTab.newKeybind("God Mode", "Press to toggle god mode", function(input)
    print("God mode keybind pressed!")
    -- Add god mode functionality here
    local humanoid = game.Players.LocalPlayer.Character.Humanoid
    if humanoid.MaxHealth ~= math.huge then
        humanoid.MaxHealth = math.huge
        humanoid.Health = math.huge
        print("God mode ON")
    else
        humanoid.MaxHealth = 100
        humanoid.Health = 100
        print("God mode OFF")
    end
end)

-- Game selection dropdown
PlayerTab.newDropdown("Quick Actions", "Quick player actions", {"Reset Character", "Respawn", "Sit", "Jump"}, function(selected)
    local character = game.Players.LocalPlayer.Character
    if selected == "Reset Character" then
        character.Humanoid.Health = 0
    elseif selected == "Respawn" then
        game.Players.LocalPlayer:LoadCharacter()
    elseif selected == "Sit" then
        character.Humanoid.Sit = true
    elseif selected == "Jump" then
        character.Humanoid.Jump = true
    end
    print("Action performed:", selected)
end)

-- Create fourth tab for visual effects
local VisualTab = PickleLibrary.newTab("Visual", "rbxassetid://14122651741")

-- Visual effects label
VisualTab.newLabel("Visual Effects & ESP")

-- ESP toggle
VisualTab.newToggle("Player ESP", "Shows player locations", false, function(state)
    print("Player ESP:", state and "ON" or "OFF")
    -- Add ESP functionality here
end)

-- Fullbright toggle
VisualTab.newToggle("Fullbright", "Removes shadows and darkness", false, function(state)
    local lighting = game:GetService("Lighting")
    if state then
        lighting.Brightness = 5
        lighting.GlobalShadows = false
        print("Fullbright enabled!")
    else
        lighting.Brightness = 1
        lighting.GlobalShadows = true
        print("Fullbright disabled!")
    end
end)

-- FOV slider
VisualTab.newSlider("Field of View", "Changes camera FOV", 120, false, function(value)
    game.Workspace.CurrentCamera.FieldOfView = value
    print("FOV set to:", value)
end)

-- Custom keybind for ESP
VisualTab.newKeybind("Toggle ESP", "Quick ESP toggle", function(input)
    print("ESP toggle keybind pressed!")
    -- Add ESP toggle here
end)

-- Print success message
print("PickleLibrary loaded successfully!")
print("All tabs and features have been created.")
print("Use the GUI to test all functionality.")

-- Optional: Auto-open the GUI
MainWindow:Open() 

-- Scripts Hub X | Official - Enhanced UI Test Script
-- Load the Enhanced Pickle UI Library via loadstring

local Pickle = loadstring(game:HttpGet("https://raw.githubusercontent.com/YourRepo/Scripts-Hub-X/main/PickleLibrary.lua"))()

-- Create the main window with enhanced features
local Window = Pickle.CreateWindow({
    Title = "Scripts Hub X | Official",
    Subtitle = "Enhanced Multi-Tool v4.0",
    RGB = true, -- RGB animations enabled
    SaveConfiguration = true, -- Auto-save settings
    ConfigFolder = "ScriptsHubX", -- Config folder name
    ConfigFile = "settings.json" -- Config file name
})

-- Create tabs with icons (similar to the image)
local MainTab = Window:CreateTab("Main", "🏠")
local StatisticsTab = Window:CreateTab("Statistics", "📊") 
local SpeedTab = Window:CreateTab("Speed", "⚡")
local JumpPowerTab = Window:CreateTab("Jump Power", "🚀")
local StealingTab = Window:CreateTab("Stealing", "🔓")
local GearShopTab = Window:CreateTab("Gear Shop", "🛒")
local BrainrotShopTab = Window:CreateTab("Brainrot Shop", "🧠")
local ModifiersTab = Window:CreateTab("Modifiers", "⚙️")
local SniperTab = Window:CreateTab("Sniper", "🎯")
local SettingsTab = Window:CreateTab("Settings", "⚙️")

-- Store elements for easy access
local Elements = {}

--[[
    MAIN TAB - Core Features
]]--
local CoreSection = MainTab:CreateSection("Core Features")

Elements.MainToggle = CoreSection:CreateToggle("Enable Script", false, function(value)
    print("Script enabled:", value)
    -- Your main script toggle logic here
end)

Elements.AutoFarm = CoreSection:CreateButton("Start Auto Farm", function()
    print("Auto farm started!")
    -- Your auto farm logic here
end)

Elements.TeleportHome = CoreSection:CreateButton("Teleport to Spawn", function()
    print("Teleporting to spawn...")
    if game.Players.LocalPlayer.Character then
        game.Players.LocalPlayer.Character:MoveTo(Vector3.new(0, 10, 0))
    end
end)

local QuickActionsSection = MainTab:CreateSection("Quick Actions")

Elements.RejoinServer = QuickActionsSection:CreateButton("Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
end)

Elements.ServerHop = QuickActionsSection:CreateButton("Server Hop", function()
    print("Server hopping...")
    -- Your server hop logic here
end)

--[[
    STATISTICS TAB - Player Stats Display
]]--
local StatsSection = StatisticsTab:CreateSection("Player Statistics")

Elements.ShowFPS = StatsSection:CreateToggle("Show FPS", false, function(value)
    print("Show FPS:", value)
    -- Your FPS display logic here
end)

Elements.ShowPing = StatsSection:CreateToggle("Show Ping", false, function(value)
    print("Show Ping:", value)
    -- Your ping display logic here
end)

Elements.ShowTime = StatsSection:CreateToggle("Show Time", false, function(value)
    print("Show Time:", value)
    -- Your time display logic here
end)

local MoneySection = StatisticsTab:CreateSection("Money & Resources")

Elements.MoneyDisplay = MoneySection:CreateButton("Refresh Stats", function()
    print("Refreshing player statistics...")
    -- Update money, level, etc.
end)

--[[
    SPEED TAB - Movement Speed Controls
]]--
local SpeedSection = SpeedTab:CreateSection("Speed Controls")

Elements.SpeedEnabled = SpeedSection:CreateToggle("Speed Hack", false, function(value)
    print("Speed hack:", value)
    if value then
        local speed = Elements.WalkSpeed.GetValue()
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = speed
        end
    else
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end)

Elements.WalkSpeed = SpeedSection:CreateSlider("Walk Speed", 16, 200, 16, function(value)
    print("Walk Speed set to:", value)
    if Elements.SpeedEnabled.GetValue() then
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
end)

Elements.BoostSpeed = SpeedSection:CreateToggle("Boost Speed", false, function(value)
    print("Boost Speed:", value)
    -- Your boost speed logic here
end)

Elements.BoostOnStealing = SpeedSection:CreateToggle("Boost on Stealing", false, function(value)
    print("Boost on Stealing:", value)
    -- Your boost on stealing logic here
end)

--[[
    JUMP POWER TAB - Jump Controls
]]--
local JumpSection = JumpPowerTab:CreateSection("Jump Controls")

Elements.JumpEnabled = JumpSection:CreateToggle("Enhanced Jump", false, function(value)
    print("Enhanced Jump:", value)
    if value then
        local jumpPower = Elements.JumpPower.GetValue()
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = jumpPower
        end
    else
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = 50
        end
    end
end)

Elements.JumpPower = JumpSection:CreateSlider("Jump Power", 50, 300, 50, function(value)
    print("Jump Power set to:", value)
    if Elements.JumpEnabled.GetValue() then
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end
end)

Elements.BoostJumpPower = JumpSection:CreateToggle("Boost Jump Power", false, function(value)
    print("Boost Jump Power:", value)
    -- Your boost jump logic here
end)

Elements.BoostOnStealing2 = JumpSection:CreateToggle("Boost on Stealing", false, function(value)
    print("Boost on Stealing (Jump):", value)
    -- Your boost on stealing logic here
end)

Elements.InfiniteJump = JumpSection:CreateToggle("Infinite Jump", false, function(value)
    print("Infinite Jump:", value)
    -- Your infinite jump logic here
end)

--[[
    STEALING TAB - Auto Stealing Features
]]--
local StealingSection = StealingTab:CreateSection("Auto Stealing")

Elements.AutoSteal = StealingSection:CreateToggle("Auto Hold Prompt", false, function(value)
    print("Auto Hold Prompt:", value)
    -- Your auto hold prompt logic here
end)

Elements.StealBrainrot = StealingSection:CreateButton("Steal a Brainrot", function()
    print("Stealing brainrot...")
    -- Your steal brainrot logic here
end)

--[[
    GEAR SHOP TAB - Automatic Purchasing
]]--
local GearSection = GearShopTab:CreateSection("Auto Purchase")

Elements.AutoPurchaseGear = GearSection:CreateToggle("Auto Purchase", false, function(value)
    print("Auto Purchase Gear:", value)
    -- Your auto purchase gear logic here
end)

Elements.GearSelection = GearSection:CreateDropdown("If Gear(s)", {
    "Speed Coil", 
    "Jump Coil", 
    "Gravity Coil",
    "Health Kit",
    "Shield"
}, "Speed Coil", function(value)
    print("Selected Gear:", value)
    -- Your gear selection logic here
end)

--[[
    BRAINROT SHOP TAB - Brainrot Purchasing
]]--
local BrainrotSection = BrainrotShopTab:CreateSection("Auto Purchase")

Elements.AutoPurchaseBrainrot = BrainrotSection:CreateToggle("Auto Purchase", false, function(value)
    print("Auto Purchase Brainrot:", value)
    -- Your auto purchase brainrot logic here
end)

Elements.BrainrotSelection = BrainrotSection:CreateDropdown("If Brainrot(s)", {
    "Ohio Rizz",
    "Sigma Grindset", 
    "Skibidi Toilet",
    "Among Us Sus",
    "Gigachad Energy"
}, "Ohio Rizz", function(value)
    print("Selected Brainrot:", value)
    -- Your brainrot selection logic here
end)

--[[
    MODIFIERS TAB - Game Modifiers
]]--
local ModifiersSection = ModifiersTab:CreateSection("Game Modifiers")

Elements.AntiNoMovement = ModifiersSection:CreateToggle("Anti No-Movement", false, function(value)
    print("Anti No-Movement:", value)
    -- Your anti no-movement logic here
end)

Elements.AntiRagdoll = ModifiersSection:CreateToggle("Anti Ragdoll", false, function(value)
    print("Anti Ragdoll:", value)
    -- Your anti ragdoll logic here
end)

Elements.AntiTrap = ModifiersSection:CreateToggle("Anti Trap", false, function(value)
    print("Anti Trap:", value)
    -- Your anti trap logic here
end)

Elements.DisableClientDebuffs = ModifiersSection:CreateToggle("Disable Client Debuffs", false, function(value)
    print("Disable Client Debuffs:", value)
    -- Your disable debuffs logic here
end)

--[[
    SNIPER TAB - Advanced Features
]]--
local SniperSection = SniperTab:CreateSection("Sniper Settings")

Elements.SniperInfo = SniperSection:CreateButton("Sniper Info", function()
    print("=== SNIPER MODULE INFO ===")
    print("Keep in mind that this module is")
    print("looking for the highest price only.")
    print("============================")
end)

Elements.SniperBrainrot = SniperSection:CreateDropdown("Brainrot Target", {
    "Ohio Rizz",
    "Sigma Grindset",
    "Skibidi Toilet", 
    "Among Us Sus",
    "Gigachad Energy",
    "All Types"
}, "All Types", function(value)
    print("Sniper Target:", value)
    -- Your sniper logic here
end)

--[[
    SETTINGS TAB - Configuration & Info
]]--
local ConfigSection = SettingsTab:CreateSection("Configuration")

Elements.SaveConfig = ConfigSection:CreateButton("Save Configuration", function()
    Window:SaveConfiguration()
    print("💾 Configuration saved!")
end)

Elements.LoadConfig = ConfigSection:CreateButton("Load Configuration", function()
    Window:LoadConfiguration()
    print("📁 Configuration loaded!")
end)

Elements.ResetConfig = ConfigSection:CreateButton("Reset to Defaults", function()
    print("🔄 Resetting configuration...")
    
    -- Reset all toggles
    Elements.MainToggle.SetValue(false)
    Elements.SpeedEnabled.SetValue(false)
    Elements.JumpEnabled.SetValue(false)
    Elements.AutoSteal.SetValue(false)
    Elements.AutoPurchaseGear.SetValue(false)
    Elements.AutoPurchaseBrainrot.SetValue(false)
    Elements.AntiNoMovement.SetValue(false)
    Elements.AntiRagdoll.SetValue(false)
    Elements.AntiTrap.SetValue(false)
    Elements.DisableClientDebuffs.SetValue(false)
    Elements.ShowFPS.SetValue(false)
    Elements.ShowPing.SetValue(false)
    Elements.ShowTime.SetValue(false)
    
    -- Reset sliders
    Elements.WalkSpeed.SetValue(16)
    Elements.JumpPower.SetValue(50)
    
    print("✅ Configuration reset complete!")
end)

local InfoSection = SettingsTab:CreateSection("Information")

Elements.ScriptInfo = InfoSection:CreateButton("Script Information", function()
    print("=== SCRIPTS HUB X | OFFICIAL ===")
    print("Version: 4.0.0 Enhanced")
    print("Author: Scripts Hub X Team")
    print("UI Library: Enhanced Pickle UI")
    print("Features: RGB Animations, Auto-Config")
    print("Last Updated:", os.date("%m/%d/%Y"))
    print("================================")
end)

Elements.DiscordServer = InfoSection:CreateButton("Discord Server", function()
    print("Discord: https://discord.gg/scriptshubx")
    print("Join our community for updates!")
    -- You can add setclipboard here if available
end)

Elements.KeybindToggle = InfoSection:CreateKeybind("Toggle UI", "RightShift", function()
    print("UI toggled via keybind!")
    -- Toggle UI visibility
    Window:SetVisible(not Window.visible)
end)

local DisplaySection = SettingsTab:CreateSection("Display Settings")

Elements.UIScale = DisplaySection:CreateSlider("UI Scale", 0.8, 1.5, 1.0, function(value)
    print("UI Scale:", value)
    -- Your UI scaling logic here
end)

Elements.Transparency = DisplaySection:CreateSlider("UI Transparency", 0, 1, 0, function(value)
    print("UI Transparency:", value)
    -- Your transparency logic here
end)

-- Advanced functionality loops
spawn(function()
    while true do
        wait(0.1)
        
        -- Speed hack maintenance
        if Elements.SpeedEnabled.GetValue() then
            local currentSpeed = Elements.WalkSpeed.GetValue()
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                if game.Players.LocalPlayer.Character.Humanoid.WalkSpeed ~= currentSpeed then
                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = currentSpeed
                end
            end
        end
        
        -- Jump power maintenance
        if Elements.JumpEnabled.GetValue() then
            local currentJump = Elements.JumpPower.GetValue()
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                if game.Players.LocalPlayer.Character.Humanoid.JumpPower ~= currentJump then
                    game.Players.LocalPlayer.Character.Humanoid.JumpPower = currentJump
                end
            end
        end
        
        -- Auto stealing logic
        if Elements.AutoSteal.GetValue() then
            -- Your auto steal logic here
            -- Example: Look for proximity prompts and auto-trigger them
        end
        
        -- Auto purchasing logic
        if Elements.AutoPurchaseGear.GetValue() then
            local selectedGear = Elements.GearSelection.GetValue()
            -- Your auto purchase gear logic here
        end
        
        if Elements.AutoPurchaseBrainrot.GetValue() then
            local selectedBrainrot = Elements.BrainrotSelection.GetValue()
            -- Your auto purchase brainrot logic here
        end
        
        -- Anti-features
        if Elements.AntiRagdoll.GetValue() then
            -- Your anti-ragdoll logic here
        end
        
        if Elements.AntiTrap.GetValue() then
            -- Your anti-trap logic here
        end
    end
end)

-- Performance monitoring and display updates
spawn(function()
    while true do
        wait(1)
        
        -- FPS Display
        if Elements.ShowFPS.GetValue() then
            local fps = math.floor(1 / game:GetService("RunService").Heartbeat:Wait())
            -- Update FPS display
        end
        
        -- Ping Display  
        if Elements.ShowPing.GetValue() then
            local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
            -- Update ping display
        end
        
        -- Time Display
        if Elements.ShowTime.GetValue() then
            local currentTime = os.date("%H:%M:%S")
            -- Update time display
        end
    end
end)

-- Character respawn handler
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    wait(1) -- Wait for character to load
    
    -- Reapply speed if enabled
    if Elements.SpeedEnabled.GetValue() then
        character:WaitForChild("Humanoid").WalkSpeed = Elements.WalkSpeed.GetValue()
    end
    
    -- Reapply jump power if enabled
    if Elements.JumpEnabled.GetValue() then
        character:WaitForChild("Humanoid").JumpPower = Elements.JumpPower.GetValue()
    end
end)

-- Auto-load configuration on script start
spawn(function()
    wait(2) -- Wait for UI to fully load
    Window:LoadConfiguration()
    print("🚀 Scripts Hub X Enhanced loaded successfully!")
    print("📱 Press", Elements.KeybindToggle.GetValue(), "to toggle UI")
end)

-- Cleanup on script end
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == game.Players.LocalPlayer then
        Window:SaveConfiguration()
    end
end)

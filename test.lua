-- Scripts Hub X | Official - Enhanced UI Test Script - FIXED
-- Load the Enhanced Pickle UI Library

local Pickle = loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/PickleLibrary.lua"))()

-- Create the main window with enhanced features
local Window = Pickle.CreateWindow({
    Title = "Scripts Hub X | Official",
    Subtitle = "Enhanced Multi-Tool v4.0",
    RGB = true,
    SaveConfiguration = true,
    ConfigFolder = "ScriptsHubX",
    ConfigFile = "settings.json"
})

-- Store elements for easy access
local Elements = {}

-- Create tabs matching the image design
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

--[[
    MAIN TAB - Core Features and Tools
]]--
local CoreSection = MainTab:CreateSection("Core Features and Tools")

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

Elements.RejoinServer = CoreSection:CreateButton("Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, game.Players.LocalPlayer)
end)

Elements.ServerHop = CoreSection:CreateButton("Server Hop", function()
    print("Server hopping...")
    -- Your server hop logic here
end)

--[[
    STATISTICS TAB - Player Stats Display (Matching image layout)
]]--
local StatsSection = StatisticsTab:CreateSection("Player Statistics")

-- Display current stats (similar to image showing Cash: $58,746,995, etc.)
Elements.RefreshStats = StatsSection:CreateButton("Refresh Statistics", function()
    print("Refreshing player statistics...")
    -- Update money, steals, rebirths, etc.
    -- This would update the displayed values in the UI
end)

Elements.ShowFPS = StatsSection:CreateToggle("Show FPS Counter", false, function(value)
    print("Show FPS:", value)
    -- Your FPS display logic here
end)

Elements.ShowPing = StatsSection:CreateToggle("Show Network Ping", false, function(value)
    print("Show Ping:", value)
    -- Your ping display logic here
end)

Elements.ShowTime = StatsSection:CreateToggle("Show Session Time", false, function(value)
    print("Show Time:", value)
    -- Your time display logic here
end)

-- Additional stats display
Elements.DisplayStats = StatsSection:CreateToggle("Display Advanced Stats", false, function(value)
    print("Advanced Stats Display:", value)
    -- Show additional statistics like steals, rebirths, etc.
end)

--[[
    SPEED TAB - Movement Speed Controls (Matching image layout)
]]--
local SpeedSection = SpeedTab:CreateSection("Speed Controls")

Elements.BoostSpeed = SpeedSection:CreateToggle("Boost Speed", false, function(value)
    print("Boost Speed:", value)
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

Elements.BoostOnStealing = SpeedSection:CreateToggle("Boost on Stealing", false, function(value)
    print("Boost on Stealing:", value)
    -- Your boost on stealing logic here
end)

-- Speed slider matching the image (16/41 shown in image)
Elements.WalkSpeed = SpeedSection:CreateSlider("Speed", 16, 200, 16, function(value)
    print("Walk Speed set to:", value)
    if Elements.BoostSpeed.GetValue() then
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
        end
    end
end)

--[[
    JUMP POWER TAB - Jump Controls (Matching image layout)
]]--
local JumpSection = JumpPowerTab:CreateSection("Jump Power Controls")

Elements.BoostJumpPower = JumpSection:CreateToggle("Boost Jump Power", false, function(value)
    print("Boost Jump Power:", value)
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

Elements.BoostOnStealing2 = JumpSection:CreateToggle("Boost on Stealing", false, function(value)
    print("Boost on Stealing (Jump):", value)
    -- Your boost on stealing logic here
end)

-- Jump Power slider matching the image (50/125 shown in image)
Elements.JumpPower = JumpSection:CreateSlider("Jump Power", 50, 300, 50, function(value)
    print("Jump Power set to:", value)
    if Elements.BoostJumpPower.GetValue() then
        if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
            game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
        end
    end
end)

Elements.InfiniteJump = JumpSection:CreateToggle("Infinite Jump", false, function(value)
    print("Infinite Jump:", value)
    -- Your infinite jump logic here
end)

--[[
    STEALING TAB - Auto Stealing Features (Matching image layout)
]]--
local StealingSection = StealingTab:CreateSection("Auto Stealing Features")

Elements.AutoHoldPrompt = StealingSection:CreateToggle("Auto Hold Prompt", false, function(value)
    print("Auto Hold Prompt:", value)
    -- Your auto hold prompt logic here
end)

Elements.StealBrainrot = StealingSection:CreateButton("Steal a Brainrot • 1.25.21.29 • rifton.top/discord", function()
    print("Stealing brainrot...")
    -- Your steal brainrot logic here - this matches the button text from image
end)

--[[
    GEAR SHOP TAB - Automatic Purchasing (Matching image layout)
]]--
local GearSection = GearShopTab:CreateSection("Gear Shop Settings")

Elements.AutoPurchaseGear = GearSection:CreateToggle("Auto Purchase", false, function(value)
    print("Auto Purchase Gear:", value)
    -- Your auto purchase gear logic here
end)

Elements.GearSelection = GearSection:CreateDropdown("If Gear(s)", {
    "---", -- Default option as shown in image
    "Speed Coil", 
    "Jump Coil", 
    "Gravity Coil",
    "Health Kit",
    "Shield"
}, "---", function(value)
    print("Selected Gear:", value)
    -- Your gear selection logic here
end)

--[[
    BRAINROT SHOP TAB - Brainrot Purchasing (Matching image layout)
]]--
local BrainrotSection = BrainrotShopTab:CreateSection("Brainrot Shop Settings")

Elements.AutoPurchaseBrainrot = BrainrotSection:CreateToggle("Auto Purchase", false, function(value)
    print("Auto Purchase Brainrot:", value)
    -- Your auto purchase brainrot logic here
end)

Elements.BrainrotSelection = BrainrotSection:CreateDropdown("If Brainrot(s)", {
    "---", -- Default option as shown in image
    "Ohio Rizz",
    "Sigma Grindset", 
    "Skibidi Toilet",
    "Among Us Sus",
    "Gigachad Energy"
}, "---", function(value)
    print("Selected Brainrot:", value)
    -- Your brainrot selection logic here
end)

--[[
    MODIFIERS TAB - Game Modifiers (Matching image layout)
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
    SNIPER TAB - Advanced Features (Matching image layout)
]]--
local SniperSection = SniperTab:CreateSection("Sniper Configuration")

Elements.SniperInfo = SniperSection:CreateButton("Information", function()
    print("=== SNIPER MODULE INFO ===")
    print("Keep in mind that this module is")
    print("looking for the highest price only.")
    print("============================")
end)

Elements.SniperBrainrot = SniperSection:CreateDropdown("Brainrot", {
    "...", -- Default as shown in image
    "Ohio Rizz",
    "Sigma Grindset",
    "Skibidi Toilet", 
    "Among Us Sus",
    "Gigachad Energy",
    "All Types"
}, "...", function(value)
    print("Sniper Target:", value)
    -- Your sniper logic here
end)

--[[
    SETTINGS TAB - Configuration & Advanced Settings
]]--
local ConfigSection = SettingsTab:CreateSection("Configuration Management")

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
    
    -- Reset all toggles to match default states
    Elements.MainToggle.SetValue(false)
    Elements.BoostSpeed.SetValue(false)
    Elements.BoostJumpPower.SetValue(false)
    Elements.AutoHoldPrompt.SetValue(false)
    Elements.AutoPurchaseGear.SetValue(false)
    Elements.AutoPurchaseBrainrot.SetValue(false)
    Elements.AntiNoMovement.SetValue(false)
    Elements.AntiRagdoll.SetValue(false)
    Elements.AntiTrap.SetValue(false)
    Elements.DisableClientDebuffs.SetValue(false)
    Elements.ShowFPS.SetValue(false)
    Elements.ShowPing.SetValue(false)
    Elements.ShowTime.SetValue(false)
    Elements.BoostOnStealing.SetValue(false)
    Elements.BoostOnStealing2.SetValue(false)
    Elements.InfiniteJump.SetValue(false)
    Elements.DisplayStats.SetValue(false)
    
    -- Reset sliders to default values
    Elements.WalkSpeed.SetValue(16)
    Elements.JumpPower.SetValue(50)
    
    -- Reset dropdowns to default
    Elements.GearSelection.SetValue("---")
    Elements.BrainrotSelection.SetValue("---")
    Elements.SniperBrainrot.SetValue("...")
    
    print("✅ Configuration reset complete!")
end)

local InfoSection = SettingsTab:CreateSection("Information & Support")

Elements.ScriptInfo = InfoSection:CreateButton("Script Information", function()
    print("=== SCRIPTS HUB X | OFFICIAL ===")
    print("Version: 4.0.0 Enhanced")
    print("Author: Scripts Hub X Team")
    print("UI Library: Enhanced Pickle UI")
    print("Features: RGB Animations, Auto-Config")
    print("Build: rifton.top/discord")
    print("Last Updated:", os.date("%m/%d/%Y"))
    print("================================")
end)

Elements.DiscordServer = InfoSection:CreateButton("Join Discord Server", function()
    print("Discord: rifton.top/discord")
    print("Join our community for updates and support!")
    -- You can add setclipboard here if available
    if setclipboard then
        setclipboard("rifton.top/discord")
        print("✅ Discord link copied to clipboard!")
    end
end)

Elements.KeybindToggle = InfoSection:CreateKeybind("Toggle UI Keybind", "RightShift", function()
    print("UI toggled via keybind!")
    Window:SetVisible(not Window.visible)
end)

local DisplaySection = SettingsTab:CreateSection("Display & Performance")

Elements.UIScale = DisplaySection:CreateSlider("UI Scale", 0.8, 1.5, 1.0, function(value)
    print("UI Scale:", value)
    -- Your UI scaling logic here
end)

Elements.Transparency = DisplaySection:CreateSlider("UI Transparency", 0, 100, 0, function(value)
    print("UI Transparency:", value .. "%")
    -- Your transparency logic here
end)

Elements.PerformanceMode = DisplaySection:CreateToggle("Performance Mode", false, function(value)
    print("Performance Mode:", value)
    -- Reduce RGB speed, disable some animations, etc.
end)

-- Main functionality loops
spawn(function()
    while true do
        wait(0.1)
        
        -- Speed hack maintenance
        if Elements.BoostSpeed.GetValue() then
            local currentSpeed = Elements.WalkSpeed.GetValue()
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                if game.Players.LocalPlayer.Character.Humanoid.WalkSpeed ~= currentSpeed then
                    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = currentSpeed
                end
            end
        end
        
        -- Jump power maintenance
        if Elements.BoostJumpPower.GetValue() then
            local currentJump = Elements.JumpPower.GetValue()
            if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("Humanoid") then
                if game.Players.LocalPlayer.Character.Humanoid.JumpPower ~= currentJump then
                    game.Players.LocalPlayer.Character.Humanoid.JumpPower = currentJump
                end
            end
        end
        
        -- Auto stealing logic
        if Elements.AutoHoldPrompt.GetValue() then
            -- Look for proximity prompts and auto-trigger them
            for _, prompt in pairs(workspace:GetDescendants()) do
                if prompt:IsA("ProximityPrompt") and prompt.Enabled then
                    -- Auto-hold logic here
                end
            end
        end
        
        -- Auto purchasing logic
        if Elements.AutoPurchaseGear.GetValue() then
            local selectedGear = Elements.GearSelection.GetValue()
            if selectedGear ~= "---" then
                -- Your auto purchase gear logic here
            end
        end
        
        if Elements.AutoPurchaseBrainrot.GetValue() then
            local selectedBrainrot = Elements.BrainrotSelection.GetValue()
            if selectedBrainrot ~= "---" then
                -- Your auto purchase brainrot logic here
            end
        end
        
        -- Anti-features
        if Elements.AntiRagdoll.GetValue() then
            -- Your anti-ragdoll logic here
            if game.Players.LocalPlayer.Character then
                local humanoid = game.Players.LocalPlayer.Character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.PlatformStand = false
                end
            end
        end
        
        if Elements.AntiTrap.GetValue() then
            -- Your anti-trap logic here
        end
        
        if Elements.AntiNoMovement.GetValue() then
            -- Your anti no-movement logic here
        end
    end
end)

-- Performance and statistics monitoring
spawn(function()
    while true do
        wait(1)
        
        -- FPS Display
        if Elements.ShowFPS.GetValue() then
            local fps = math.floor(1 / game:GetService("RunService").Heartbeat:Wait())
            -- You can create a GUI to display this
        end
        
        -- Ping Display  
        if Elements.ShowPing.GetValue() then
            local ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValueString()
            -- Display ping somewhere
        end
        
        -- Time Display
        if Elements.ShowTime.GetValue() then
            local currentTime = os.date("%H:%M:%S")
            -- Display current time
        end
        
        -- Advanced stats display
        if Elements.DisplayStats.GetValue() then
            -- Display additional game statistics like money, steals, etc.
        end
    end
end)

-- Infinite jump implementation
local jumpConnection
UserInputService.JumpRequest:Connect(function()
    if Elements.InfiniteJump.GetValue() then
        local character = game.Players.LocalPlayer.Character
        if character and character:FindFirstChild("Humanoid") then
            character.Humanoid:ChangeState("Jumping")
        end
    end
end)

-- Character respawn handler
game.Players.LocalPlayer.CharacterAdded:Connect(function(character)
    wait(1) -- Wait for character to load
    
    -- Reapply speed if enabled
    if Elements.BoostSpeed.GetValue() then
        character:WaitForChild("Humanoid").WalkSpeed = Elements.WalkSpeed.GetValue()
    end
    
    -- Reapply jump power if enabled
    if Elements.BoostJumpPower.GetValue() then
        character:WaitForChild("Humanoid").JumpPower = Elements.JumpPower.GetValue()
    end
    
    print("🔄 Character respawned - settings reapplied")
end)

-- Auto-load configuration on script start
spawn(function()
    wait(2) -- Wait for UI to fully load
    Window:LoadConfiguration()
    print("🚀 Scripts Hub X Enhanced loaded successfully!")
    print("📱 Press", Elements.KeybindToggle.GetValue(), "to toggle UI")
    print("🎯 Version: Enhanced Multi-Tool v4.0")
    print("🌐 Discord: rifton.top/discord")
end)

-- Cleanup on script end
game:GetService("Players").PlayerRemoving:Connect(function(player)
    if player == game.Players.LocalPlayer then
        Window:SaveConfiguration()
        print("💾 Configuration saved on exit")
    end
end)

-- Additional utility functions
local function notifyUser(message, duration)
    duration = duration or 3
    print("📢 " .. message)
    -- You can add GUI notifications here
end

-- Performance optimization
if Elements.PerformanceMode and Elements.PerformanceMode.GetValue() then
    -- Reduce update frequencies, disable some visual effects
    print("⚡ Performance mode activated")
end

print("✅ All systems initialized and ready!")
print("🎮 Enjoy using Scripts Hub X Enhanced!")

-- Test all features on load (optional - remove in production)
--[[
spawn(function()
    wait(5)
    print("🧪 Running feature tests...")
    Elements.BoostSpeed.SetValue(true)
    wait(1)
    Elements.WalkSpeed.SetValue(50)
    wait(1)
    Elements.BoostSpeed.SetValue(false)
    print("✅ Feature tests completed!")
end)
--]]

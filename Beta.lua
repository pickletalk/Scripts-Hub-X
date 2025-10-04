-- Require or load the PickleLibrary (replace with actual require or loading method)
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/PickleLibrary.lua"))()
  -- or loadstring(...) if needed

-- Create a window with title and transparency
local Window = Library.CreateWindow({
    Name = "Scripts Hub X Official",
    Transparency = 0
})

-- Main tab with different UI controls
local MainTab = Window.CreateTab("Main")

-- Toggle example
MainTab.CreateToggle({
    Name = "Auto Farm",
    Default = false,
    Callback = function(value)
        print("Auto Farm toggled:", value)
    end
})

-- Button example
MainTab.CreateButton({
    Name = "Click Me",
    Callback = function()
        print("Button clicked!")
    end
})

-- Input example
MainTab.CreateInput({
    Name = "Player Name",
    PlaceholderText = "Enter player name...",
    Type = "string",
    Default = "",
    Callback = function(value)
        print("Input changed:", value)
    end
})

-- Toggle with input example
MainTab.CreateToggleWithInput({
    Name = "Speed Hack",
    ToggleDefault = false,
    InputType = "int",
    InputDefault = 16,
    PlaceholderText = "Speed value...",
    Callback = function(toggle, value)
        print("Speed Hack toggled:", toggle, "Value:", value)
    end
})

-- Button with input example
MainTab.CreateButtonWithInput({
    Name = "Teleport to Position",
    InputType = "int",
    InputDefault = 100,
    PlaceholderText = "Enter position...",
    Callback = function(value)
        print("Teleporting to:", value)
    end
})

-- Settings tab for configuration
local SettingsTab = Window.CreateTab("Settings")

-- Save configuration button
SettingsTab.CreateButton({
    Name = "Save Configuration",
    Callback = function()
        -- Implementation inside library handles saving
        print("Save Configuration clicked")
    end
})

-- Load configuration button
SettingsTab.CreateButton({
    Name = "Load Configuration",
    Callback = function()
        -- Implementation inside library handles loading
        print("Load Configuration clicked")
    end
})

-- Transparency toggle
SettingsTab.CreateToggle({
    Name = "Transparency Mode",
    Default = (Window.Transparency > 0),
    Callback = function(value)
        Window.SetTransparency(value and 0.6 or 0)
    end
})

-- Theme-Changing dropdown imitation (basic example)
local themeNames = {"Atlantic","Galaxy","Sunset","Ocean","Forest","Midnight","Cherry","Emerald","Gold","Arctic"}
local currentThemeIndex = 1
SettingsTab.CreateButton({
    Name = "Change Theme",
    Callback = function()
        currentThemeIndex = currentThemeIndex + 1
        if currentThemeIndex > #themeNames then currentThemeIndex = 1 end
        local newTheme = themeNames[currentThemeIndex]
        Window.ApplyTheme(newTheme)
        print("Theme changed to:", newTheme)
    end
})

-- Misc tab with credits and Discord info
local MiscTab = Window.CreateTab("Misc")

MiscTab.CreateButton({
    Name = "Copy Discord Invite",
    Callback = function()
        setclipboard("https://discord.gg/bpsNUH5sVb")  -- Sets clipboard with invite
        print("Discord invite copied to clipboard!")
    end
})

print("UI Loaded Successfully")

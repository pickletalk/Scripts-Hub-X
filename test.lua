-- Load essential services
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
if not Players.LocalPlayer then
    warn("Error: LocalPlayer not found")
    return
end

-- Load PickleLibrary from GitHub
local PickleLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/picklelibrary.lua"))() -- Replace with your GitHub raw URL
if not PickleLibrary then
    warn("Failed to load PickleLibrary")
    return
end

-- Create window
local Window = PickleLibrary:CreateWindow({
    Name = "PickleLibrary Test",
    LoadingSubtitle = "Testing by Grok",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "PickleTestConfig"
    }
})

-- Main tab
local MainTab = Window:CreateTab("Main Controls", "home")

-- Basic controls section
MainTab:CreateSection("Basic Controls")

-- Button
MainTab:CreateButton({
    Name = "Test Button",
    Callback = function()
        print("Button clicked")
        PickleLibrary:Notify({Title = "Button Pressed", Content = "Test button clicked!", Duration = 3})
    end
})

-- Toggle
MainTab:CreateToggle({
    Name = "Test Toggle",
    CurrentValue = false,
    Flag = "TestToggle",
    Callback = function(value)
        print("Toggle: " .. tostring(value))
    end
})

-- Slider
MainTab:CreateSlider({
    Name = "Test Slider",
    Range = {0, 100},
    CurrentValue = 50,
    Flag = "TestSlider",
    Callback = function(value)
        print("Slider: " .. value)
    end
})

-- Dropdown (single)
MainTab:CreateDropdown({
    Name = "Test Dropdown",
    Options = {"Option 1", "Option 2", "Option 3"},
    CurrentOption = {"Option 1"},
    Flag = "TestDropdown",
    Callback = function(option)
        print("Dropdown: " .. table.concat(option, ", "))
    end
})

-- Dropdown (multiple)
MainTab:CreateDropdown({
    Name = "Multi Dropdown",
    Options = {"Apple", "Banana", "Orange", "Grape"},
    CurrentOption = {"Apple", "Banana"},
    MultipleOptions = true,
    Flag = "TestMultiDropdown",
    Callback = function(options)
        print("Multi Dropdown: " .. table.concat(options, ", "))
    end
})

-- Keybind
MainTab:CreateKeybind({
    Name = "Test Keybind",
    CurrentKeybind = "E",
    Flag = "TestKeybind",
    Callback = function(key)
        print("Keybind: " .. key)
    end
})

-- ColorPicker
MainTab:CreateColorPicker({
    Name = "Test ColorPicker",
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "TestColorPicker",
    Callback = function(color)
        print("Color: R=" .. math.floor(color.R * 255) .. ", G=" .. math.floor(color.G * 255) .. ", B=" .. math.floor(color.B * 255))
    end
})

-- Label
local TestLabel = MainTab:CreateLabel("Test Label", "info", Color3.fromRGB(100, 200, 100))
TestLabel:Set("Updated Label")

-- Paragraph
MainTab:CreateParagraph({
    Title = "Test Paragraph",
    Content = "Demonstrating PickleLibrary's paragraph element."
})

-- Divider
MainTab:CreateDivider()

-- Advanced controls section
MainTab:CreateSection("Advanced Controls")

-- Spacing
MainTab:CreateSpacing()

-- Error Button
MainTab:CreateButton({
    Name = "Error Button",
    Callback = function()
        error("Test error")
    end
})

-- Settings tab
Window:CreateSettingsTab({Name = "Settings", Image = "settings"})

-- Load configuration
Window:LoadConfiguration()

local PickleLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/picklelibrary.lua"))() -- Replace with your actual GitHub raw URL

if not PickleLibrary then
    warn("Failed to load PickleLibrary from GitHub")
    return
end

-- Create a new window with configuration saving enabled
local Window = PickleLibrary:CreateWindow({
    Name = "PickleLibrary Test Suite",
    LoadingSubtitle = "Testing by Pickle",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "PickleTestConfig"
    }
})

-- Create a main tab for general controls
local MainTab = Window:CreateTab("Test Controls", "home")

-- Add a section
MainTab:CreateSection("Basic Controls")

-- Test Button
MainTab:CreateButton({
    Name = "Test Button",
    Callback = function()
        print("Button clicked!")
        PickleLibrary:Notify({
            Title = "Button Pressed",
            Content = "You clicked the test button!",
            Duration = 3
        })
    end
})

-- Test Toggle
MainTab:CreateToggle({
    Name = "Test Toggle",
    CurrentValue = false,
    Flag = "TestToggle",
    Callback = function(value)
        print("Toggle changed to: " .. tostring(value))
    end
})

-- Test Slider
MainTab:CreateSlider({
    Name = "Test Slider",
    Range = {0, 100},
    CurrentValue = 50,
    Flag = "TestSlider",
    Callback = function(value)
        print("Slider changed to: " .. value)
    end
})

-- Test Dropdown (Single selection)
MainTab:CreateDropdown({
    Name = "Test Dropdown",
    Options = {"Option 1", "Option 2", "Option 3"},
    CurrentOption = {"Option 1"},
    Flag = "TestDropdown",
    Callback = function(option)
        print("Dropdown selected: " .. table.concat(option, ", "))
    end
})

-- Test Dropdown (Multiple selection)
MainTab:CreateDropdown({
    Name = "Multi Dropdown",
    Options = {"Apple", "Banana", "Orange", "Grape"},
    CurrentOption = {"Apple", "Banana"},
    MultipleOptions = true,
    Flag = "TestMultiDropdown",
    Callback = function(options)
        print("Multi Dropdown selected: " .. table.concat(options, ", "))
    end
})

-- Test Keybind
MainTab:CreateKeybind({
    Name = "Test Keybind",
    CurrentKeybind = "E",
    Flag = "TestKeybind",
    Callback = function(key)
        print("Keybind changed to: " .. key)
    end
})

-- Test ColorPicker
MainTab:CreateColorPicker({
    Name = "Test ColorPicker",
    Color = Color3.fromRGB(255, 0, 0),
    Flag = "TestColorPicker",
    Callback = function(color)
        print("Color changed to: R=" .. math.floor(color.R * 255) .. ", G=" .. math.floor(color.G * 255) .. ", B=" .. math.floor(color.B * 255))
    end
})

-- Test Label
local TestLabel = MainTab:CreateLabel("Test Label", "info", Color3.fromRGB(100, 200, 100))
TestLabel:Set("Updated Label Text")

-- Test Paragraph
MainTab:CreateParagraph({
    Title = "Test Paragraph",
    Content = "This is a test paragraph to demonstrate the paragraph element in PickleLibrary."
})

-- Add a divider
MainTab:CreateDivider()

-- Add another section
MainTab:CreateSection("Advanced Controls")

-- Test Spacing
MainTab:CreateSpacing()

-- Test Button with Error
MainTab:CreateButton({
    Name = "Error Button",
    Callback = function()
        error("This is a test error")
    end
})

-- Create a settings tab
Window:CreateSettingsTab({
    Name = "Settings",
    Image = "settings"
})

-- Load configuration to test loading functionality
Window:LoadConfiguration()

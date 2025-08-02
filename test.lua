-- Load PickleLibrary from a GitHub URL (replace with your actual URL)
local PickleLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/picklelibrary.lua"))()

-- Check if the library loaded successfully
if not PickleLibrary then
    warn("Failed to load PickleLibrary. Check the URL or internet connection.")
    return
end

-- Create a window to start using PickleLibrary
local Window = PickleLibrary:CreateWindow({
    Name = "PickleLibrary Tutorial Window", -- The title of the window
    LoadingTitle = "Loading Tutorial Interface", -- Title during loading
    LoadingSubtitle = "by Your Name", -- Subtitle during loading
    ConfigurationSaving = {
        Enabled = true, -- Enables saving settings
        FileName = "TutorialConfig" -- Name of the config file
    },
    Discord = {
        Enabled = true,
        Invite = "bpsNUH5sVb", -- Just the invite code, not full URL
        RememberJoins = true -- Remembers if the user has joined
    }
})

-- Create a tab
local Tab = Window:CreateTab({
    Name = "Tutorial Tab", -- Name of the tab
    Image = "settings" -- Optional: Use a Lucide icon name (e.g., "settings")
})

-- Create a section within the tab
local Section = Tab:CreateSection({
    Name = "Tutorial Section" -- Name of the section
})

-- Example elements to demonstrate usage

-- Button Example
Section:CreateButton({
    Name = "Click Me!",
    Callback = function()
        PickleLibrary:Notify({
            Title = "Button Pressed",
            Content = "You clicked the button!",
            Duration = 5 -- Duration in seconds
        })
    end
})

-- Toggle Example
Section:CreateToggle({
    Name = "Toggle Me",
    CurrentValue = false, -- Default value
    Callback = function(Value)
        PickleLibrary:Notify({
            Title = "Toggle State",
            Content = "Toggle is now " .. tostring(Value),
            Duration = 3
        })
    end
})

-- Slider Example
Section:CreateSlider({
    Name = "Volume Slider",
    Min = 0, -- Minimum value
    Max = 100, -- Maximum value
    Default = 50, -- Default value
    Callback = function(Value)
        PickleLibrary:Notify({
            Title = "Volume Changed",
            Content = "Volume set to " .. Value,
            Duration = 3
        })
    end
})

-- Dropdown Example
Section:CreateDropdown({
    Name = "Select Option",
    Options = {"Option 1", "Option 2", "Option 3"}, -- List of options
    CurrentOption = "Option 1", -- Default option
    Callback = function(Value)
        PickleLibrary:Notify({
            Title = "Option Selected",
            Content = "Selected: " .. Value,
            Duration = 3
        })
    end
})

-- Input Example
Section:CreateInput({
    Name = "Enter Text",
    Placeholder = "Type here...",
    Default = "Hello",
    Callback = function(Text, EnterPressed)
        PickleLibrary:Notify({
            Title = "Input Received",
            Content = "You entered: " .. Text .. (EnterPressed and " (Enter pressed)" or ""),
            Duration = 3
        })
    end
})

-- ColorPicker Example
Section:CreateColorPicker({
    Name = "Pick a Color",
    Default = Color3.fromRGB(255, 0, 0), -- Default color
    Callback = function(Value)
        PickleLibrary:Notify({
            Title = "Color Picked",
            Content = string.format("New color: RGB(%d, %d, %d)", 
                Value.R * 255, Value.G * 255, Value.B * 255),
            Duration = 3
        })
    end
})

-- Wait for UI to fully load before attempting to load configuration
task.wait(2)

-- Load configuration if it exists
local configLoaded = PickleLibrary:LoadConfiguration()
if configLoaded then
    PickleLibrary:Notify({
        Title = "Configuration Loaded",
        Content = "Your saved settings have been restored!",
        Duration = 3
    })
else
    PickleLibrary:Notify({
        Title = "Welcome!",
        Content = "No previous configuration found. Settings will be saved automatically.",
        Duration = 5
    })
end

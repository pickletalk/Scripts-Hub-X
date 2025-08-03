local PickleLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/picklelibrary.lua"))()

local Window = PickleLibrary:CreateWindow({
    Name = "Test Interface",
    LoadingTitle = "Test Interface Suite",
    LoadingSubtitle = "by TestUser",
    ConfigurationSaving = {
        Enabled = true,
        FileName = "TestConfig"
    },
    Discord = {
        Enabled = true,
        Invite = "https://discord.gg/donutsmp",
        RememberJoins = true
    },
    Theme = "PickleTheme"
})

local Tab = Window:CreateTab({Name = "Test Tab"})

local Section1 = Tab:CreateSection({Name = "Basic Elements"})

Section1:CreateButton({
    Name = "Test Button",
    Callback = function()
        PickleLibrary:Notify({
            Title = "Button Pressed",
            Content = "The Test Button was clicked!",
            Duration = 5
        })
    end
})

Section1:CreateToggle({
    Name = "Test Toggle",
    CurrentValue = false,
    Callback = function(Value)
        PickleLibrary:Notify({
            Title = "Toggle Changed",
            Content = "Toggle is now " .. tostring(Value),
            Duration = 5
        })
    end
})

Section1:CreateSlider({
    Name = "Test Slider",
    Min = 0,
    Max = 100,
    Default = 50,
    Callback = function(Value)
        PickleLibrary:Notify({
            Title = "Slider Moved",
            Content = "Slider value: " .. tostring(Value),
            Duration = 5
        })
    end
})

Section1:CreateDropdown({
    Name = "Test Dropdown",
    Options = {"Option 1", "Option 2", "Option 3"},
    CurrentOption = "Option 1",
    Callback = function(Option)
        PickleLibrary:Notify({
            Title = "Dropdown Changed",
            Content = "Selected: " .. Option,
            Duration = 5
        })
    end
})

Section1:CreateInput({
    Name = "Test Input",
    Default = "Hello",
    Placeholder = "Enter text...",
    Callback = function(Text, EnterPressed)
        PickleLibrary:Notify({
            Title = "Input Changed",
            Content = "Input: " .. Text .. " (Enter: " .. tostring(EnterPressed) .. ")",
            Duration = 5
        })
    end
})

Section1:CreateColorPicker({
    Name = "Test ColorPicker",
    Default = Color3.fromRGB(255, 0, 0),
    Callback = function(Value)
        PickleLibrary:Notify({
            Title = "Color Changed",
            Content = "New color: R" .. math.floor(Value.R * 255) .. " G" .. math.floor(Value.G * 255) .. " B" .. math.floor(Value.B * 255),
            Duration = 5
        })
    end
})

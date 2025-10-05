-- HEY CLAUDE IF THE COMMENTS HAS "!" ON THE LAST MAKE SURE THAT YOU WILL ALWAYS USE THAT FUNCTION ON LUA CODES!
-- AND CLAUDE ALWAYS ADD CREDITS AND SETTINGS THAT WILL EDIT THEME IF SELECTED IT SHOULD SET THE THEME TO THAT!
-- AND ON SETTINGS ADD SAVE AND LOAD CONFIGURATION TOO READ THE WHOLE EXAMPLE CAREFULLY I WILL TELL EVERYTHING HOW TO DO IT!

-- Load The Library
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Example Creating Themes FOR THE SETTINGS THEME PICKER! MUST HAVE DIFFERENTS
WindUI:AddTheme({
    Name = "My Theme", -- theme name
    
    Accent = Color3.fromHex("#18181b"),
    Dialog = Color3.fromHex("#161616"),
    Outline = Color3.fromHex("#FFFFFF"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#101010"),
    Button = Color3.fromHex("#52525b"),
    Icon = Color3.fromHex("#a1a1aa")
})

-- Example Setting the theme
WindUI:SetTheme("My Theme")

-- Creating Window!
local Window = WindUI:CreateWindow({
    Title = "Scripts Hub X | Official",
    Icon = "door-open", -- lucide icon
    Author = "by PickleTalk and Mhicel",
    Folder = "Scripts Hub X",
    Transparent = true,
    Theme = "Dark",
})

-- Window must always transparent!
Window:ToggleTransparency(true)

-- CONFIG MANAGER!
local ConfigManager = Window.ConfigManager

-- Example Creating Config!
local myConfig = ConfigManager:CreateConfig("Scripts Hub X")

-- REGISTERING ELEMENTS!
myConfig:Register("SpecialNameExample", Element)
-- EXAMPLE REGISTER USAGE!
local ToggleElement = Tabs.ConfigTab:Toggle({
    Title = "Toggle",
    Desc = "Config Test Toggle",
    Callback = function(v) print("Toggle Changed: " .. tostring(v)) end
})

-- register
--                 | Element name (no spaces)    | Element          |
myConfig:Register( "toggleNameExample",          ToggleElement      )

-- EXAMPLE SAVING CONFIG FOR SAVE CONFIGURATION BUTTON ON SETTINGS!
myConfig:Save()

-- EXAMPLE LOADING CONFIG FOR SAVE CONFIGURATION BUTTON ON SETTINGS!
myConfig:Load()

-- Editing the minimized!
Window:EditOpenButton({
    Title = "Scripts Hub X | Official",
    Icon = "monitor",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new( -- gradient
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

-- Example Creating Tabs
local Tab = Window:Tab({
    Title = "Tab Title",
    Icon = "bird", -- optional
    Locked = false,
})

-- Adding window pop up!
WindUI:Popup({
    Title = "Scripts Hub X | Official",
    Icon = "info",
    Content = "Join to our discord server to be always updated!",
    Buttons = {
        {
            Title = "Cancel",
            Callback = function() end,
            Variant = "Tertiary",
        },
        {
            Title = "Continue",
            Icon = "arrow-right",
            Callback = function() end, -- edit this that will copy the discord https://discord.gg/bpsNUH5sVb!
            Variant = "Primary",
        }
    }
})

-- Example Creating notification 
WindUI:Notify({
    Title = "Notification Title",
    Content = "Notification Content example!",
    Duration = 3, -- 3 seconds
    Icon = "bird",
})

-- Example Creating buttons
local Button = Tab:Button({
    Title = "Button",
    Desc = "Test Button",
    Locked = false,
    Callback = function()
        -- ...
    end
})

-- EXAMPLE FOR THE SETTINFS COLOR PICKER!
local Colorpicker = Tab:Colorpicker({
    Title = "Colorpicker",
    Desc = "Select Up Color That Fits Your Ui Style!",
    Default = Color3.fromRGB(0, 255, 0),
    Transparency = 0,
    Locked = false,
    Callback = function(color) 
        print("Background color: " .. tostring(color))
    end
})

-- Example Creating Dropdown
local Dropdown = Tab:Dropdown({
    Title = "Advanced Dropdown",
    Values = {
        {
            Title = "Category A",
            Icon = "bird"
        },
        {
            Title = "Category B",
            Icon = "house"
        },
        {
            Title = "Category C",
            Icon = "droplet"
        },
    },
    Value = "Category A",
    Callback = function(option) 
        print("Category selected: " .. option.Title .. " with icon " .. option.Icon) 
    end
})

-- to refresh the dropdown
Dropdown:Refresh({ "New Category A", "New Category B" })

-- Example Creating Input
local Input = Tab:Input({
    Title = "Input",
    Desc = "Input Description",
    Value = "Default value",
    InputIcon = "bird",
    Type = "Input", -- or "Textarea"
    Placeholder = "Enter text...",
    Callback = function(input) 
        print("text entered: " .. input)
    end
})

-- Example Setting A Keybind
local Keybind = Tab:Keybind({
    Title = "Keybind",
    Desc = "Keybind to open ui",
    Value = "G",
    Callback = function(v)
        Window:SetToggleKey(Enum.KeyCode[v])
    end
})

-- EXAMPLE CREATING CREDITS PARAGRAPH!
local Paragraph = Tab:Paragraph({
    Title = "Scripts Hub X | Official",
    Desc = "Made by PickleTalk and Mhicel Join to our discord server to be always updated",
    Color = "Red",
    Image = "",
    ImageSize = 30,
    Thumbnail = "",
    ThumbnailSize = 80,
    Locked = false,
    Buttons = {
        {
            Icon = "bird",
            Title = "Button",
            Callback = function() print("1 Button") end,
        }
    }
})

-- AND ADD THUMBNAIL
Paragraph:SetThumbnail("rbxassetid://86472170233220")

-- AND AFTER THE PARAGRAPH ALWAYS ADD BUTTON THAT WILL MAKE THEM COPY THE DISCORD SERVER! https://discord.gg/bpsNUH5sVb

-- Example Making Slider
local Slider = Tab:Slider({
    Title = "Slider",
    
    -- To make float number supported, 
    -- make the Step a float number.
    -- example: Step = 0.1
    Step = 1,
    
    Value = {
        Min = 20,
        Max = 120,
        Default = 70,
    },
    Callback = function(value)
        print(value)
    end
})

-- Example Creating Toggle
local Toggle = Tab:Toggle({
    Title = "Toggle",
    Desc = "Toggle Description",
    Icon = "bird",
    Type = "Checkbox",
    Default = false,
    Callback = function(state) 
        print("Toggle Activated" .. tostring(state))
    end
})

-- CLAUDE IF YOU STILL UNDERSTAND MY EXAMPLES FEEL FREE TO GO TO THE SITE https://footagesus.github.io/WindUI-Docs/docs/faq TO EXPLORE MORE

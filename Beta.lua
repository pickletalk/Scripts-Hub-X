-- Load the library
local PickleLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/ui.lua"))()

-- Create window
local window = PickleLibrary:CreateWindow({
    Title = "Scripts Hub X | Official",
    Subtitle = "Made by PickleTalk"
})

-- Create sections
local mainSection = window:CreateSection("Main")
local creditsSection = window:CreateCreditsSection() -- Pre-built credits with Discord

-- Create tabs within sections
local featuresTab = window:CreateTab(mainSection, "Features", "⚡")

-- Add items to tabs
window:AddToggle(featuresTab, {
    Name = "Speed Boost",
    Default = false,
    Callback = function(value)
        print("Speed Boost:", value)
    end
})

window:AddSlider(featuresTab, {
    Name = "Walk Speed",
    Min = 16,
    Max = 100,
    Default = 35,
    Callback = function(value)
        -- Your code here
    end
})

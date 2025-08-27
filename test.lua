local Pickle = loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/PickleLibrary.lua"))()

local Window = Pickle.CreateWindow({
    Title = "My Script",
    RGB = true -- Enable RGB colors
})

local Tab1 = Window:CreateTab("Main")
local Section1 = Tab1:CreateSection("Combat")

Section1:CreateButton("Kill All", function()
    print("Kill all activated!")
end)

local Toggle1 = Section1:CreateToggle("Auto Farm", false, function(value)
    print("Auto Farm:", value)
end)

local Tab2 = Window:CreateTab("Visuals")
local Section2 = Tab2:CreateSection("ESP")

Section2:CreateButton("Player ESP", function()
    print("Player ESP enabled!")
end)

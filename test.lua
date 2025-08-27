-- test.lua example for PickleLibrary
-- Replace <RAW_URL> with the raw GitHub URL where PickleLibrary.lua is hosted
local Pickle = loadstring(game:HttpGet("<RAW_URL>/PickleLibrary.lua"))()
local win = Pickle.CreateWindow({Title = "Pickle Demo", ConfigFolder = "PickleConfigs", UseRainbow = true})
local tab1 = win.CreateTab("Main")
local sec1 = win.CreateSection(tab1, "Controls")
win.AddButton(sec1, "Say Hello", function() print("Hello from Pickle UI") end)
local toggle = win.AddToggle(sec1, "Enable Feature", true, function(state) print("Feature ->", state) end)
local slider = win.AddSlider(sec1, "Sensitivity", 0, 100, 42, function(val) print("Sensitivity ->", math.floor(val)) end)
local key = win.AddKeybind(sec1, "Quick Action", "F", function() print("Quick Action triggered") end)
local tab2 = win.CreateTab("Config")
local sec2 = win.CreateSection(tab2, "Save & Load")
win.AddButton(sec2, "Save Config", function()
    local cfg = {enabled = toggle.get(), sensitivity = slider.get()}
    win.SaveConfig(cfg)
    print("Saved config")
end)
win.AddButton(sec2, "Load Config", function()
    local cfg = win.LoadConfig()
    if cfg.enabled ~= nil then toggle.set(cfg.enabled) end
    if cfg.sensitivity then slider.set(cfg.sensitivity) end
    print("Loaded config")
end)
print("Test script loaded")

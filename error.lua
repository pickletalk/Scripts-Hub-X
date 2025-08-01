-- Scripts Hub X | Error Detection System - Simplified & Robust
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

print("[ERROR SYSTEM] Starting error detection system...")

-- Create error GUI immediately
local function createErrorGUI(failedComponent, errorMessage)
    print("[ERROR SYSTEM] Creating error GUI for: " .. tostring(failedComponent))
    
    -- Clean up any existing GUIs first
    for _, gui in pairs(playerGui:GetChildren()) do
        if gui.Name:find("Error") or gui.Name:find("KeySystem") or gui.Name:find("Loading") then
            gui:Destroy()
        end
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ErrorDetectionGUI"
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui

    -- Main background
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 30)
    mainFrame.BackgroundTransparency = 0.3
    mainFrame.Parent = screenGui

    -- Content frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(0, 450, 0, 400)
    contentFrame.Position = UDim2.new(0.5, -225, 0.5, -200)
    contentFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame

    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 15)
    contentCorner.Parent = contentFrame

    local contentStroke = Instance.new("UIStroke")
    contentStroke.Color = Color3.fromRGB(255, 80, 80)
    contentStroke.Thickness = 2
    contentStroke.Parent = contentFrame

    -- Title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -40, 0, 60)
    titleLabel.Position = UDim2.new(0, 20, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "⚠️ Scripts Hub X Error"
    titleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    titleLabel.TextSize = 20
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextScaled = true
    titleLabel.Parent = contentFrame

    -- Component info
    local componentLabel = Instance.new("TextLabel")
    componentLabel.Size = UDim2.new(1, -40, 0, 40)
    componentLabel.Position = UDim2.new(0, 20, 0, 90)
    componentLabel.BackgroundTransparency = 1
    componentLabel.Text = "Failed Component: " .. tostring(failedComponent):upper()
    componentLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
    componentLabel.TextSize = 16
    componentLabel.Font = Enum.Font.GothamBold
    componentLabel.TextScaled = true
    componentLabel.Parent = contentFrame

    -- Error message
    local errorLabel = Instance.new("TextLabel")
    errorLabel.Size = UDim2.new(1, -40, 0, 100)
    errorLabel.Position = UDim2.new(0, 20, 0, 140)
    errorLabel.BackgroundTransparency = 1
    errorLabel.Text = tostring(errorMessage) or "Unknown error occurred"
    errorLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    errorLabel.TextSize = 12
    errorLabel.Font = Enum.Font.Gotham
    errorLabel.TextWrapped = true
    errorLabel.TextScaled = true
    errorLabel.Parent = contentFrame

    -- Bug report info
    local bugLabel = Instance.new("TextLabel")
    bugLabel.Size = UDim2.new(1, -40, 0, 60)
    bugLabel.Position = UDim2.new(0, 20, 0, 250)
    bugLabel.BackgroundTransparency = 1
    bugLabel.Text = "Please report this in #bug-report channel"
    bugLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
    bugLabel.TextSize = 14
    bugLabel.Font = Enum.Font.Gotham
    bugLabel.TextScaled = true
    bugLabel.Parent = contentFrame

    -- Discord link
    local discordLabel = Instance.new("TextLabel")
    discordLabel.Size = UDim2.new(1, -40, 0, 30)
    discordLabel.Position = UDim2.new(0, 20, 0, 315)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "Discord: https://discord.gg/bpsNUH5sVb"
    discordLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
    discordLabel.TextSize = 12
    discordLabel.Font = Enum.Font.Gotham
    discordLabel.TextScaled = true
    discordLabel.Parent = contentFrame

    -- Copy button
    local copyButton = Instance.new("TextButton")
    copyButton.Size = UDim2.new(0, 120, 0, 30)
    copyButton.Position = UDim2.new(0.5, -60, 0, 355)
    copyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    copyButton.Text = "Copy Discord Link"
    copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    copyButton.TextSize = 12
    copyButton.Font = Enum.Font.GothamBold
    copyButton.TextScaled = true
    copyButton.Parent = contentFrame

    local copyCorner = Instance.new("UICorner")
    copyCorner.CornerRadius = UDim.new(0, 8)
    copyCorner.Parent = copyButton

    -- Copy functionality
    copyButton.MouseButton1Click:Connect(function()
        pcall(function()
            setclipboard("https://discord.gg/bpsNUH5sVb")
            copyButton.Text = "Copied!"
            copyButton.BackgroundColor3 = Color3.fromRGB(60, 140, 235)
            wait(2)
            copyButton.Text = "Copy Discord Link"
            copyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
        end)
    end)

    print("[ERROR SYSTEM] Error GUI created successfully")
    return screenGui
end

-- Test individual components
local function testComponent(componentName, testFunc)
    print("[ERROR SYSTEM] Testing component: " .. componentName)
    local success, result = pcall(testFunc)
    if success then
        print("[ERROR SYSTEM] " .. componentName .. " - OK")
        return true, result
    else
        print("[ERROR SYSTEM] " .. componentName .. " - FAILED: " .. tostring(result))
        return false, result
    end
end

-- Wait for any UI to appear
local function waitForUI(timeout)
    timeout = timeout or 10
    local startTime = tick()
    
    while tick() - startTime < timeout do
        for _, gui in pairs(playerGui:GetChildren()) do
            if gui.Name == "KeySystemGUI" or gui.Name == "LoadingScreenGUI" or gui.Name:find("Loading") then
                print("[ERROR SYSTEM] UI detected: " .. gui.Name)
                return true, gui.Name
            end
        end
        wait(0.5)
    end
    
    print("[ERROR SYSTEM] No UI detected after " .. timeout .. " seconds")
    return false, "No UI found"
end

-- Main error detection
local function runErrorDetection()
    print("[ERROR SYSTEM] Starting comprehensive error detection...")
    
    wait(3) -- Give time for main script to start
    
    -- Check if any UI loaded
    local hasUI, uiName = waitForUI(5)
    
    if hasUI then
        print("[ERROR SYSTEM] UI found: " .. uiName .. " - System working normally")
        return
    end
    
    print("[ERROR SYSTEM] No UI detected - running component tests...")
    
    -- Test each component
    local components = {
        {
            name = "keysystem",
            test = function()
                local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/main/keysystem.lua", true)
                if not script or script == "" then
                    error("Failed to fetch keysystem script")
                end
                local loaded = loadstring(script)()
                if not loaded or type(loaded) ~= "table" then
                    error("Keysystem script didn't return proper module")
                end
                if not loaded.ShowKeySystem then
                    error("Missing ShowKeySystem function")
                end
                return "Keysystem loads correctly"
            end
        },
        {
            name = "loadingscreen", 
            test = function()
                local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/main/loadingscreen.lua", true)
                if not script or script == "" then
                    error("Failed to fetch loadingscreen script")
                end
                local loaded = loadstring(script)()
                if not loaded or type(loaded) ~= "table" then
                    error("Loadingscreen script didn't return proper module")
                end
                if not loaded.initialize then
                    error("Missing initialize function")
                end
                return "Loadingscreen loads correctly"
            end
        },
        {
            name = "main",
            test = function()
                local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/obfuscated.lua", true)
                if not script or script == "" then
                    error("Failed to fetch main script")
                end
                if not script:find("checkGameSupport") then
                    error("Main script missing essential functions")
                end
                return "Main script fetches correctly"
            end
        }
    }
    
    local failures = {}
    
    for _, component in pairs(components) do
        local success, result = testComponent(component.name, component.test)
        if not success then
            table.insert(failures, {name = component.name, error = result})
        end
    end
    
    -- Show error for first failure or general error
    if #failures > 0 then
        local primaryFailure = failures[1]
        createErrorGUI(primaryFailure.name, primaryFailure.error)
    else
        createErrorGUI("unknown", "All components load but no UI appears. Possible network or execution environment issue.")
    end
end

-- Auto-start error detection
coroutine.wrap(function()
    runErrorDetection()
end)()

print("[ERROR SYSTEM] Error detection system loaded successfully")

-- Return the system for manual use
return {
    createErrorGUI = createErrorGUI,
    runErrorDetection = runErrorDetection,
    testComponent = testComponent,
    waitForUI = waitForUI
} 

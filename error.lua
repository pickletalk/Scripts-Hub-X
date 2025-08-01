-- Scripts Hub X | Error Detection System
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Error detection results
local errorResults = {
    keysystem = false,
    loadingscreen = false,
    main = false,
    errors = {}
}

-- Create error notification GUI
local function createErrorGUI(failedComponent, errorMessage)
    -- Destroy any existing error GUIs
    for _, gui in pairs(playerGui:GetChildren()) do
        if gui.Name == "ErrorDetectionGUI" then
            gui:Destroy()
        end
    end

    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "ErrorDetectionGUI"
    screenGui.IgnoreGuiInset = true
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = playerGui

    -- Main background frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Size = UDim2.new(1, 0, 1, 0)
    mainFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 30)
    mainFrame.BackgroundTransparency = 1
    mainFrame.Parent = screenGui

    -- Content frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Size = UDim2.new(0, 450, 0, 380)
    contentFrame.Position = UDim2.new(0.5, -225, 0.5, -190)
    contentFrame.BackgroundColor3 = Color3.fromRGB(20, 40, 60)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame

    local contentFrameCorner = Instance.new("UICorner")
    contentFrameCorner.CornerRadius = UDim.new(0, 16)
    contentFrameCorner.Parent = contentFrame

    local contentStroke = Instance.new("UIStroke")
    contentStroke.Color = Color3.fromRGB(255, 80, 80)
    contentStroke.Thickness = 1.5
    contentStroke.Transparency = 1
    contentStroke.Parent = contentFrame

    -- Error title
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -40, 0, 50)
    titleLabel.Position = UDim2.new(0, 20, 0, 20)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = "Component Failed To Load"
    titleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
    titleLabel.TextScaled = true
    titleLabel.TextSize = 24
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextTransparency = 1
    titleLabel.Parent = contentFrame

    -- Failed component label
    local componentLabel = Instance.new("TextLabel")
    componentLabel.Size = UDim2.new(1, -40, 0, 40)
    componentLabel.Position = UDim2.new(0, 20, 0, 80)
    componentLabel.BackgroundTransparency = 1
    componentLabel.Text = "Failed Component: " .. failedComponent:upper()
    componentLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
    componentLabel.TextScaled = true
    componentLabel.TextSize = 16
    componentLabel.Font = Enum.Font.GothamBold
    componentLabel.TextTransparency = 1
    componentLabel.Parent = contentFrame

    -- Error description
    local errorDescLabel = Instance.new("TextLabel")
    errorDescLabel.Size = UDim2.new(1, -40, 0, 80)
    errorDescLabel.Position = UDim2.new(0, 20, 0, 130)
    errorDescLabel.BackgroundTransparency = 1
    errorDescLabel.Text = errorMessage or "The " .. failedComponent .. " component failed to load properly. This could be due to network issues or script corruption."
    errorDescLabel.TextColor3 = Color3.fromRGB(150, 180, 200)
    errorDescLabel.TextScaled = true
    errorDescLabel.TextSize = 12
    errorDescLabel.Font = Enum.Font.Gotham
    errorDescLabel.TextTransparency = 1
    errorDescLabel.TextWrapped = true
    errorDescLabel.Parent = contentFrame

    -- Bug report suggestion
    local bugReportLabel = Instance.new("TextLabel")
    bugReportLabel.Size = UDim2.new(1, -40, 0, 60)
    bugReportLabel.Position = UDim2.new(0, 20, 0, 220)
    bugReportLabel.BackgroundTransparency = 1
    bugReportLabel.Text = "Please report this issue in the #bug-report channel on our Discord server."
    bugReportLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
    bugReportLabel.TextScaled = true
    bugReportLabel.TextSize = 12
    bugReportLabel.Font = Enum.Font.Gotham
    bugReportLabel.TextTransparency = 1
    bugReportLabel.TextWrapped = true
    bugReportLabel.Parent = contentFrame

    -- Discord link
    local discordLabel = Instance.new("TextLabel")
    discordLabel.Size = UDim2.new(1, -40, 0, 40)
    discordLabel.Position = UDim2.new(0, 20, 0, 280)
    discordLabel.BackgroundTransparency = 1
    discordLabel.Text = "Discord: https://discord.gg/bpsNUH5sVb"
    discordLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
    discordLabel.TextScaled = true
    discordLabel.TextSize = 12
    discordLabel.Font = Enum.Font.Gotham
    discordLabel.TextTransparency = 1
    discordLabel.TextWrapped = true
    discordLabel.Parent = contentFrame

    -- Copy Discord button
    local copyButton = Instance.new("TextButton")
    copyButton.Size = UDim2.new(0, 100, 0, 28)
    copyButton.Position = UDim2.new(0.5, -50, 0, 330)
    copyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    copyButton.BackgroundTransparency = 1
    copyButton.Text = "Copy Discord"
    copyButton.TextColor3 = Color3.fromRGB(230, 240, 255)
    copyButton.TextScaled = true
    copyButton.TextSize = 12
    copyButton.Font = Enum.Font.GothamBold
    copyButton.TextTransparency = 1
    copyButton.Parent = contentFrame

    local copyButtonCorner = Instance.new("UICorner")
    copyButtonCorner.CornerRadius = UDim.new(0, 6)
    copyButtonCorner.Parent = copyButton

    -- Copy button functionality
    copyButton.MouseButton1Click:Connect(function()
        pcall(function()
            setclipboard("https://discord.gg/bpsNUH5sVb")
            copyButton.Text = "Copied!"
            copyButton.BackgroundColor3 = Color3.fromRGB(60, 140, 235)
            wait(1)
            copyButton.Text = "Copy Discord"
            copyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
        end)
    end)

    -- Animate error GUI entrance
    local function playEntranceAnimations()
        local mainFrameTween = TweenService:Create(mainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.7
        })

        local contentFrameTween = TweenService:Create(contentFrame, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.5
        })

        local contentStrokeTween = TweenService:Create(contentStroke, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            Transparency = 0.4
        })

        local elements = {titleLabel, componentLabel, errorDescLabel, bugReportLabel, discordLabel}
        local elementTweens = {}
        
        for _, element in pairs(elements) do
            table.insert(elementTweens, TweenService:Create(element, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
                TextTransparency = 0
            }))
        end

        local copyButtonTween = TweenService:Create(copyButton, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
            TextTransparency = 0,
            BackgroundTransparency = 0.2
        })

        mainFrameTween:Play()
        contentFrameTween:Play()
        contentStrokeTween:Play()
        
        for i, tween in pairs(elementTweens) do
            wait(0.1)
            tween:Play()
        end
        
        wait(0.1)
        copyButtonTween:Play()

        -- Border pulse animation
        local borderPulseTween = TweenService:Create(contentStroke, TweenInfo.new(1.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
            Transparency = 0.2
        })
        borderPulseTween:Play()
    end

    playEntranceAnimations()
    
    return screenGui
end

-- Test loading screen component
local function testLoadingScreen()
    print("[ERROR DETECTION] Testing Loading Screen component...")
    local success, result = pcall(function()
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/main/loadingscreen.lua")
        local loadedScript = loadstring(script)()
        
        -- Check if required functions exist
        if not loadedScript or 
           not loadedScript.playEntranceAnimations or 
           not loadedScript.animateLoadingBar or 
           not loadedScript.playExitAnimations or 
           not loadedScript.setLoadingText or 
           not loadedScript.initialize then
            return false, "Missing required functions"
        end
        
        -- Try to initialize (but don't show UI)
        loadedScript.initialize()
        return true, "Loading Screen OK"
    end)
    
    errorResults.loadingscreen = success
    if not success then
        errorResults.errors.loadingscreen = result
        print("[ERROR DETECTION] Loading Screen failed: " .. tostring(result))
    else
        print("[ERROR DETECTION] Loading Screen OK")
    end
    
    return success, result
end

-- Test key system component
local function testKeySystem()
    print("[ERROR DETECTION] Testing Key System component...")
    local success, result = pcall(function()
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/main/keysystem.lua")
        local loadedScript = loadstring(script)()
        
        -- Check if required functions exist
        if not loadedScript or 
           not loadedScript.ShowKeySystem or 
           not loadedScript.IsKeyVerified or 
           not loadedScript.HideKeySystem or 
           not loadedScript.verifyKey then
            return false, "Missing required functions"
        end
        
        return true, "Key System OK"
    end)
    
    errorResults.keysystem = success
    if not success then
        errorResults.errors.keysystem = result
        print("[ERROR DETECTION] Key System failed: " .. tostring(result))
    else
        print("[ERROR DETECTION] Key System OK")
    end
    
    return success, result
end

-- Test main script component
local function testMainScript()
    print("[ERROR DETECTION] Testing Main Script component...")
    local success, result = pcall(function()
        -- Check if main script functions are working
        local testFunctions = {
            "checkGameSupport",
            "loadGameScript", 
            "checkPremiumUser",
            "sendWebhookNotification"
        }
        
        -- Try to load and parse the main script
        local script = game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/obfuscated.lua")
        if not script or script == "" then
            return false, "Failed to fetch main script"
        end
        
        -- Check if script contains essential functions (basic validation)
        for _, funcName in pairs(testFunctions) do
            if not string.find(script, funcName) then
                return false, "Missing function: " .. funcName
            end
        end
        
        return true, "Main Script OK"
    end)
    
    errorResults.main = success
    if not success then
        errorResults.errors.main = result
        print("[ERROR DETECTION] Main Script failed: " .. tostring(result))
    else
        print("[ERROR DETECTION] Main Script OK")
    end
    
    return success, result
end

-- Detect which UI components are currently loaded
local function detectLoadedUIs()
    local loadedUIs = {}
    
    -- Check for key system UI
    for _, gui in pairs(playerGui:GetChildren()) do
        if gui.Name == "KeySystemGUI" then
            table.insert(loadedUIs, "keysystem")
            print("[ERROR DETECTION] Found KeySystem UI - destroying...")
            gui:Destroy()
        elseif gui.Name == "LoadingScreenGUI" then
            table.insert(loadedUIs, "loadingscreen")
            print("[ERROR DETECTION] Found LoadingScreen UI - destroying...")
            gui:Destroy()
        elseif gui.Name == "ErrorNotification" then
            table.insert(loadedUIs, "errornotification")
            print("[ERROR DETECTION] Found Error Notification UI - destroying...")
            gui:Destroy()
        end
    end
    
    return loadedUIs
end

-- Main error detection function
local function runErrorDetection()
    print("[ERROR DETECTION] Starting component analysis...")
    
    -- Destroy any existing UIs first
    local existingUIs = detectLoadedUIs()
    wait(0.5) -- Give time for destruction
    
    -- Test all components
    local lsSuccess, lsError = testLoadingScreen()
    local ksSuccess, ksError = testKeySystem()  
    local mainSuccess, mainError = testMainScript()
    
    wait(1) -- Wait to see if any UIs appear
    
    -- Check what actually loaded by looking for UI elements
    local finalUICheck = detectLoadedUIs()
    
    -- Determine what failed
    local failedComponents = {}
    local failureReasons = {}
    
    if not lsSuccess then
        table.insert(failedComponents, "loadingscreen")
        table.insert(failureReasons, "Loading Screen: " .. tostring(lsError))
    end
    
    if not ksSuccess then
        table.insert(failedComponents, "keysystem")
        table.insert(failureReasons, "Key System: " .. tostring(ksError))
    end
    
    if not mainSuccess then
        table.insert(failedComponents, "main")
        table.insert(failureReasons, "Main Script: " .. tostring(mainError))
    end
    
    -- If no components failed in testing but no UI appeared, something is wrong
    if #failedComponents == 0 and #finalUICheck == 0 then
        table.insert(failedComponents, "unknown")
        table.insert(failureReasons, "All components loaded but no UI appeared")
    end
    
    -- Show error for the first failed component
    if #failedComponents > 0 then
        local primaryFailure = failedComponents[1]
        local errorMessage = table.concat(failureReasons, "\n")
        
        print("[ERROR DETECTION] Showing error for: " .. primaryFailure)
        createErrorGUI(primaryFailure, errorMessage)
        
        return false, primaryFailure, errorMessage
    end
    
    print("[ERROR DETECTION] All components working properly")
    return true, nil, nil
end

-- Auto-run error detection
coroutine.wrap(function()
    wait(2) -- Wait a bit for other scripts to load
    runErrorDetection()
end)()

-- Return the error detection system for manual use
return {
    runErrorDetection = runErrorDetection,
    testLoadingScreen = testLoadingScreen,
    testKeySystem = testKeySystem,
    testMainScript = testMainScript,
    createErrorGUI = createErrorGUI,
    detectLoadedUIs = detectLoadedUIs
}

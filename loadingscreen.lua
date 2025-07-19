-- Scripts Hub X | Official Loading Screen
-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptsHubXLoading"
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Completion flag
local isComplete = false

-- Main background frame (hidden until animation completes)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 25, 35)
mainFrame.BackgroundTransparency = 1 -- Hidden initially
mainFrame.Parent = screenGui

-- Content frame (smaller size)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 320, 0, 240) -- Adjusted height for warning
contentFrame.Position = UDim2.new(0.5, -160, 0.5, -120)
contentFrame.BackgroundColor3 = Color3.fromRGB(25, 45, 65)
contentFrame.BackgroundTransparency = 1 -- Hidden until animation completes
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Content frame corner
local contentFrameCorner = Instance.new("UICorner")
contentFrameCorner.CornerRadius = UDim.new(0, 12)
contentFrameCorner.Parent = contentFrame

-- Content frame glow
local contentStroke = Instance.new("UIStroke")
contentStroke.Color = Color3.fromRGB(70, 140, 240)
contentStroke.Thickness = 1
contentStroke.Transparency = 1 -- Hidden until animation completes
contentStroke.Parent = contentFrame

-- Title label (smaller and refined)
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -30, 0, 40)
titleLabel.Position = UDim2.new(0, 15, 0, 15)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Scripts Hub X"
titleLabel.TextColor3 = Color3.fromRGB(110, 170, 245)
titleLabel.TextScaled = true
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextTransparency = 1 -- Hidden until animation completes
titleLabel.Parent = contentFrame

-- Subtitle label (smaller)
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Size = UDim2.new(1, -30, 0, 25)
subtitleLabel.Position = UDim2.new(0, 15, 0, 55)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Official Loading"
subtitleLabel.TextColor3 = Color3.fromRGB(140, 170, 190)
subtitleLabel.TextScaled = true
subtitleLabel.TextSize = 14
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextTransparency = 1 -- Hidden until animation completes
subtitleLabel.Parent = contentFrame

-- Discord container (compact)
local discordContainer = Instance.new("Frame")
discordContainer.Size = UDim2.new(1, -30, 0, 35)
discordContainer.Position = UDim2.new(0, 15, 0, 85)
discordContainer.BackgroundColor3 = Color3.fromRGB(35, 55, 75)
discordContainer.BackgroundTransparency = 1 -- Hidden until animation completes
discordContainer.BorderSizePixel = 0
discordContainer.Parent = contentFrame

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 6)
discordCorner.Parent = discordContainer

-- Discord label (smaller font)
local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(0.68, -10, 1, -8)
discordLabel.Position = UDim2.new(0, 8, 0, 4)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "discord.gg/bpsNUH5sVb"
discordLabel.TextColor3 = Color3.fromRGB(90, 150, 245)
discordLabel.TextScaled = true
discordLabel.TextSize = 11
discordLabel.Font = Enum.Font.Gotham
discordLabel.TextXAlignment = Enum.TextXAlignment.Left
discordLabel.TextTransparency = 1 -- Hidden until animation completes
discordLabel.Parent = discordContainer

-- Copy button (smaller)
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0, 70, 0, 24)
copyButton.Position = UDim2.new(0.72, 5, 0, 5)
copyButton.BackgroundColor3 = Color3.fromRGB(70, 140, 240)
copyButton.BackgroundTransparency = 1 -- Hidden until animation completes
copyButton.Text = "Copy"
copyButton.TextColor3 = Color3.fromRGB(220, 230, 245)
copyButton.TextScaled = true
copyButton.TextSize = 11
copyButton.Font = Enum.Font.GothamBold
copyButton.TextTransparency = 1 -- Hidden until animation completes
copyButton.Parent = discordContainer

local copyButtonCorner = Instance.new("UICorner")
copyButtonCorner.CornerRadius = UDim.new(0, 5)
copyButtonCorner.Parent = copyButton

-- Discord advertisement label (compact)
local discordAdLabel = Instance.new("TextLabel")
discordAdLabel.Size = UDim2.new(1, -30, 0, 30)
discordAdLabel.Position = UDim2.new(0, 15, 0, 125)
discordAdLabel.BackgroundTransparency = 1
discordAdLabel.Text = "Join our Discord for updates!"
discordAdLabel.TextColor3 = Color3.fromRGB(90, 150, 245)
discordAdLabel.TextScaled = true
discordAdLabel.TextSize = 11
discordAdLabel.Font = Enum.Font.Gotham
discordAdLabel.TextTransparency = 1 -- Hidden until animation completes
discordAdLabel.TextWrapped = true
discordAdLabel.Parent = contentFrame

-- Loading text (replaces loading bar)
local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, -30, 0, 25)
loadingText.Position = UDim2.new(0, 15, 0, 160)
loadingText.BackgroundTransparency = 1
loadingText.Text = "loading"
loadingText.TextColor3 = Color3.fromRGB(70, 140, 240)
loadingText.TextScaled = true
loadingText.TextSize = 14
loadingText.Font = Enum.Font.Gotham
loadingText.TextTransparency = 1 -- Hidden until animation completes
loadingText.Parent = contentFrame

-- Warning label (below loading text)
local warningLabel = Instance.new("TextLabel")
warningLabel.Size = UDim2.new(1, -30, 0, 35)
warningLabel.Position = UDim2.new(0, 15, 0, 190)
warningLabel.BackgroundTransparency = 1
warningLabel.Text = "Warning: Don't use scripts from unknown developers because it might steal your ingame items!"
warningLabel.TextColor3 = Color3.fromRGB(245, 100, 100)
warningLabel.TextScaled = true
warningLabel.TextSize = 9
warningLabel.Font = Enum.Font.Gotham
warningLabel.TextTransparency = 1 -- Hidden until animation completes
warningLabel.TextWrapped = true
warningLabel.Parent = contentFrame

-- Water drop frame (smaller)
local waterDropFrame = Instance.new("Frame")
waterDropFrame.Size = UDim2.new(0, 30, 0, 45) -- Smaller teardrop
waterDropFrame.Position = UDim2.new(0.5, -15, 0, -50) -- Starts above screen
waterDropFrame.BackgroundColor3 = Color3.fromRGB(70, 140, 240)
waterDropFrame.BackgroundTransparency = 0.4
waterDropFrame.BorderSizePixel = 0
waterDropFrame.Parent = mainFrame

local waterDropCorner = Instance.new("UICorner")
waterDropCorner.CornerRadius = UDim.new(0.5, 0) -- Rounded teardrop shape
waterDropCorner.Parent = waterDropFrame

-- Copy button functionality
copyButton.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard("https://discord.gg/bpsNUH5sVb")
        copyButton.Text = "Copied!"
        copyButton.BackgroundColor3 = Color3.fromRGB(50, 120, 220)
        wait(1)
        copyButton.Text = "Copy"
        copyButton.BackgroundColor3 = Color3.fromRGB(70, 140, 240)
    end)
end)

-- Animate particles (simplified)
local function animateParticles()
    -- Particle animation can be added if desired
end

-- Animate loading text (text-based sequence with safeguard and color change)
local function animateLoadingBar(callback)
    print("Starting animateLoadingBar at line: " .. debug.traceback())
    if not loadingText or not loadingText.Parent then
        warn("loadingText is invalid or not parented: " .. tostring(loadingText) .. ", Parent: " .. tostring(loadingText.Parent))
        return
    end
    print("loadingText valid, starting sequence")

    local stages = {"loading", "loading.", "loading..", "loading...", "Successful"}
    local maxAttempts = 5 -- Max 5 seconds total
    local attempt = 1

    while attempt <= maxAttempts do
        for i, stage in ipairs(stages) do
            loadingText.Text = stage
            if stage == "Successful" then
                loadingText.TextColor3 = Color3.fromRGB(0, 150, 0) -- Change to green
            end
            print("Displayed stage: " .. stage .. " at attempt " .. attempt)
            local success, err = pcall(function()
                wait(0.5) -- 0.5-second wait per message
            end)
            if not success then
                warn("Wait failed: " .. tostring(err))
                break
            end
            if stage == "Successful" then
                print("Loading sequence completed with Successful")
                wait(1) -- Additional 1-second delay after "Successful"
                isComplete = true
                if callback then
                    callback()
                end
                return true
            end
        end
        attempt = attempt + 1
    end
    warn("Loading sequence timed out after " .. maxAttempts .. " attempts, forcing exit")
    loadingText.Text = "Successful"
    loadingText.TextColor3 = Color3.fromRGB(0, 150, 0) -- Change to green
    wait(1)
    isComplete = true
    if callback then
        callback()
    end
    return true
end

-- Water drop entrance animations
local function playEntranceAnimations()
    -- Ensure all elements are hidden
    contentFrame.BackgroundTransparency = 1
    contentStroke.Transparency = 1
    titleLabel.TextTransparency = 1
    subtitleLabel.TextTransparency = 1
    discordLabel.TextTransparency = 1
    copyButton.TextTransparency = 1
    copyButton.BackgroundTransparency = 1
    discordAdLabel.TextTransparency = 1
    loadingText.TextTransparency = 1
    warningLabel.TextTransparency = 1

    -- Water drop fall animation
    local dropFallTween = TweenService:Create(waterDropFrame, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        Position = UDim2.new(0.5, -15, 0.5, -120) -- Adjusted for smaller size
    })

    -- Ripple expansion
    local rippleTween = TweenService:Create(waterDropFrame, TweenInfo.new(
        1.0,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        Size = UDim2.new(0, 320, 0, 240),
        Position = UDim2.new(0.5, -160, 0.5, -120),
        BackgroundTransparency = 1
    })

    -- Start animations
    dropFallTween:Play()
    dropFallTween.Completed:Connect(function()
        rippleTween:Play()
    end)

    -- Reveal content frame and elements
    rippleTween.Completed:Connect(function()
        local mainFrameTween = TweenService:Create(mainFrame, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ), {
            BackgroundTransparency = 0.8
        })

        local contentFrameTween = TweenService:Create(contentFrame, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            BackgroundTransparency = 0.4
        })

        local contentStrokeTween = TweenService:Create(contentStroke, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            Transparency = 0.3
        })

        local titleTween = TweenService:Create(titleLabel, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            TextTransparency = 0
        })

        local subtitleTween = TweenService:Create(subtitleLabel, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            TextTransparency = 0
        })

        local discordTween = TweenService:Create(discordLabel, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            TextTransparency = 0
        })

        local copyButtonTween = TweenService:Create(copyButton, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            TextTransparency = 0,
            BackgroundTransparency = 0.1
        })

        local discordAdTween = TweenService:Create(discordAdLabel, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            TextTransparency = 0
        })

        local loadingTextTween = TweenService:Create(loadingText, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            TextTransparency = 0
        })

        local warningTween = TweenService:Create(warningLabel, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            TextTransparency = 0
        })

        mainFrameTween:Play()
        contentFrameTween:Play()
        contentStrokeTween:Play()
        titleTween:Play()
        wait(0.05)
        subtitleTween:Play()
        wait(0.05)
        discordTween:Play()
        copyButtonTween:Play()
        wait(0.05)
        discordAdTween:Play()
        wait(0.05)
        loadingTextTween:Play()
        warningTween:Play()

        loadingTextTween.Completed:Wait()
        waterDropFrame:Destroy()
        animateLoadingBar(function()
            print("Loading bar completed, ready for exit")
        end) -- Start the loading sequence with callback
    end)
end

-- Evaporation exit animations
local function playExitAnimations(callback)
    print("Starting playExitAnimations at line: " .. debug.traceback())
    local evaporateTween = TweenService:Create(contentFrame, TweenInfo.new(
        0.6,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 360, 0, 240),
        Position = UDim2.new(0.5, -180, 0.5, -120)
    })

    local fadeTween = TweenService:Create(mainFrame, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        BackgroundTransparency = 1
    })

    evaporateTween:Play()
    fadeTween:Play()

    local success, err = pcall(function()
        evaporateTween.Completed:Wait()
    end)
    if not success then
        warn("Evaporation tween failed: " .. tostring(err))
        fadeTween:Play() -- Fallback to fade
        fadeTween.Completed:Wait()
    end

    if screenGui and screenGui.Parent then
        screenGui:Destroy()
        print("ScreenGui destroyed after evaporation or fade")
    end
    if callback then
        callback()
    end
end

-- Border pulse (subtler)
local function animatePulse()
    local borderPulseTween = TweenService:Create(contentStroke, TweenInfo.new(
        1.5,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    ), {
        Transparency = 0.1
    })

    borderPulseTween:Play()
end

-- Expose loading screen functions
return {
    playEntranceAnimations = playEntranceAnimations,
    playExitAnimations = playExitAnimations,
    animateParticles = animateParticles,
    animatePulse = animatePulse,
    animateLoadingBar = animateLoadingBar,
    setLoadingText = function(text, color)
        if loadingText and loadingText.Parent then
            loadingText.Text = text or "loading"
            loadingText.TextColor3 = color or Color3.fromRGB(70, 140, 240)
        end
    end,
    isComplete = function()
        return isComplete
    end
}

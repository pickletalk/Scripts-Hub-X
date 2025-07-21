-- Scripts Hub X | Official Loading Screen
-- Services
[cite_start]local TweenService = game:GetService("TweenService") [cite: 1]
[cite_start]local Players = game:GetService("Players") [cite: 1]
[cite_start]local UserInputService = game:GetService("UserInputService") [cite: 1]

[cite_start]local player = Players.LocalPlayer [cite: 1]
[cite_start]local playerGui = player:WaitForChild("PlayerGui") [cite: 1]

-- Create main GUI
[cite_start]local screenGui = Instance.new("ScreenGui") [cite: 1]
[cite_start]screenGui.Name = "ScriptsHubXLoading" [cite: 1]
[cite_start]screenGui.IgnoreGuiInset = true [cite: 1]
[cite_start]screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling [cite: 1]
[cite_start]screenGui.Parent = playerGui [cite: 1]

-- Completion flag
[cite_start]local isComplete = false [cite: 1]

-- Main background frame
[cite_start]local mainFrame = Instance.new("Frame") [cite: 1]
[cite_start]mainFrame.Size = UDim2.new(1, 0, 1, 0) [cite: 1]
[cite_start]mainFrame.BackgroundColor3 = Color3.fromRGB(15, 25, 35) [cite: 1]
[cite_start]mainFrame.BackgroundTransparency = 1 -- Hidden initially [cite: 1]
[cite_start]mainFrame.Parent = screenGui [cite: 1]

-- Content frame
[cite_start]local contentFrame = Instance.new("Frame") [cite: 1]
contentFrame.Size = UDim2.new(0, 400, 0, 300) -- Increased size for better layout
contentFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
[cite_start]contentFrame.BackgroundColor3 = Color3.fromRGB(25, 45, 65) [cite: 1]
[cite_start]contentFrame.BackgroundTransparency = 1 [cite: 1, 2]
[cite_start]contentFrame.BorderSizePixel = 0 [cite: 2]
[cite_start]contentFrame.Parent = mainFrame [cite: 2]

-- Content frame corner
[cite_start]local contentFrameCorner = Instance.new("UICorner") [cite: 2]
contentFrameCorner.CornerRadius = UDim.new(0, 16)
[cite_start]contentFrameCorner.Parent = contentFrame [cite: 2]

-- Content frame glow
[cite_start]local contentStroke = Instance.new("UIStroke") [cite: 2]
[cite_start]contentStroke.Color = Color3.fromRGB(70, 140, 240) [cite: 2]
[cite_start]contentStroke.Thickness = 1 [cite: 2]
[cite_start]contentStroke.Transparency = 1 [cite: 2]
[cite_start]contentStroke.Parent = contentFrame [cite: 2]

-- Title label
[cite_start]local titleLabel = Instance.new("TextLabel") [cite: 2]
titleLabel.Size = UDim2.new(1, -40, 0, 50)
titleLabel.Position = UDim2.new(0, 20, 0, 20)
[cite_start]titleLabel.BackgroundTransparency = 1 [cite: 2]
[cite_start]titleLabel.Text = "Scripts Hub X" [cite: 2]
[cite_start]titleLabel.TextColor3 = Color3.fromRGB(110, 170, 245) [cite: 2]
[cite_start]titleLabel.TextScaled = true [cite: 2]
titleLabel.TextSize = 24
[cite_start]titleLabel.Font = Enum.Font.GothamBold [cite: 2]
[cite_start]titleLabel.TextTransparency = 1 [cite: 2]
[cite_start]titleLabel.Parent = contentFrame [cite: 2]

-- Subtitle label
[cite_start]local subtitleLabel = Instance.new("TextLabel") [cite: 2]
subtitleLabel.Size = UDim2.new(1, -40, 0, 30)
subtitleLabel.Position = UDim2.new(0, 20, 0, 75)
[cite_start]subtitleLabel.BackgroundTransparency = 1 [cite: 2]
[cite_start]subtitleLabel.Text = "Official Loading" [cite: 3]
[cite_start]subtitleLabel.TextColor3 = Color3.fromRGB(140, 170, 190) [cite: 3]
[cite_start]subtitleLabel.TextScaled = true [cite: 3]
subtitleLabel.TextSize = 16
[cite_start]subtitleLabel.Font = Enum.Font.Gotham [cite: 3]
[cite_start]subtitleLabel.TextTransparency = 1 [cite: 3]
[cite_start]subtitleLabel.Parent = contentFrame [cite: 3]

-- Discord container
[cite_start]local discordContainer = Instance.new("Frame") [cite: 3]
discordContainer.Size = UDim2.new(1, -40, 0, 40)
discordContainer.Position = UDim2.new(0, 20, 0, 115)
[cite_start]discordContainer.BackgroundColor3 = Color3.fromRGB(35, 55, 75) [cite: 3]
[cite_start]discordContainer.BackgroundTransparency = 1 [cite: 3]
[cite_start]discordContainer.BorderSizePixel = 0 [cite: 3]
[cite_start]discordContainer.Parent = contentFrame [cite: 3]

[cite_start]local discordCorner = Instance.new("UICorner") [cite: 3]
discordCorner.CornerRadius = UDim.new(0, 8)
[cite_start]discordCorner.Parent = discordContainer [cite: 3]

-- Discord label
[cite_start]local discordLabel = Instance.new("TextLabel") [cite: 3]
discordLabel.Size = UDim2.new(0.7, -10, 1, -10)
discordLabel.Position = UDim2.new(0, 10, 0, 5)
[cite_start]discordLabel.BackgroundTransparency = 1 [cite: 3]
[cite_start]discordLabel.Text = "discord.gg/bpsNUH5sVb" [cite: 3]
[cite_start]discordLabel.TextColor3 = Color3.fromRGB(90, 150, 245) [cite: 5]
[cite_start]discordLabel.TextScaled = true [cite: 5]
discordLabel.TextSize = 12
[cite_start]discordLabel.Font = Enum.Font.Gotham [cite: 5]
[cite_start]discordLabel.TextXAlignment = Enum.TextXAlignment.Left [cite: 5]
[cite_start]discordLabel.TextTransparency = 1 [cite: 5]
[cite_start]discordLabel.Parent = discordContainer [cite: 5]

-- Copy button
[cite_start]local copyButton = Instance.new("TextButton") [cite: 4]
copyButton.Size = UDim2.new(0, 80, 0, 30)
copyButton.Position = UDim2.new(0.7, 5, 0, 5)
[cite_start]copyButton.BackgroundColor3 = Color3.fromRGB(70, 140, 240) [cite: 4]
[cite_start]copyButton.BackgroundTransparency = 1 [cite: 4]
[cite_start]copyButton.Text = "Copy" [cite: 4]
[cite_start]copyButton.TextColor3 = Color3.fromRGB(220, 230, 245) [cite: 4]
[cite_start]copyButton.TextScaled = true [cite: 4]
copyButton.TextSize = 12
[cite_start]copyButton.Font = Enum.Font.GothamBold [cite: 4]
[cite_start]copyButton.TextTransparency = 1 [cite: 4]
[cite_start]copyButton.Parent = discordContainer [cite: 4]

[cite_start]local copyButtonCorner = Instance.new("UICorner") [cite: 4]
copyButtonCorner.CornerRadius = UDim.new(0, 6)
[cite_start]copyButtonCorner.Parent = copyButton [cite: 4]

-- Discord advertisement label
[cite_start]local discordAdLabel = Instance.new("TextLabel") [cite: 4]
discordAdLabel.Size = UDim2.new(1, -40, 0, 35)
discordAdLabel.Position = UDim2.new(0, 20, 0, 160)
[cite_start]discordAdLabel.BackgroundTransparency = 1 [cite: 4]
[cite_start]discordAdLabel.Text = "Join our Discord for updates!" [cite: 4]
[cite_start]discordAdLabel.TextColor3 = Color3.fromRGB(90, 150, 245) [cite: 5]
[cite_start]discordAdLabel.TextScaled = true [cite: 5]
discordAdLabel.TextSize = 12
[cite_start]discordAdLabel.Font = Enum.Font.Gotham [cite: 5]
[cite_start]discordAdLabel.TextTransparency = 1 [cite: 5]
[cite_start]discordAdLabel.TextWrapped = true [cite: 5]
[cite_start]discordAdLabel.Parent = contentFrame [cite: 5]

-- Loading Text
[cite_start]local loadingText = Instance.new("TextLabel") [cite: 5]
loadingText.Size = UDim2.new(1, -40, 0, 25)
loadingText.Position = UDim2.new(0, 20, 0, 200)
[cite_start]loadingText.BackgroundTransparency = 1 [cite: 5]
[cite_start]loadingText.Text = "Loading..." [cite: 5]
[cite_start]loadingText.TextColor3 = Color3.fromRGB(70, 140, 240) [cite: 5]
[cite_start]loadingText.TextScaled = true [cite: 5]
loadingText.TextSize = 14
[cite_start]loadingText.Font = Enum.Font.Gotham [cite: 5]
[cite_start]loadingText.TextTransparency = 1 [cite: 5]
[cite_start]loadingText.Parent = contentFrame [cite: 5]

-- Loading Bar Background
local loadingBarBackground = Instance.new("Frame")
loadingBarBackground.Size = UDim2.new(1, -40, 0, 10)
loadingBarBackground.Position = UDim2.new(0, 20, 0, 225)
loadingBarBackground.BackgroundColor3 = Color3.fromRGB(35, 55, 75)
loadingBarBackground.BorderSizePixel = 0
loadingBarBackground.Parent = contentFrame
loadingBarBackground.BackgroundTransparency = 1 -- Hidden initially

local loadingBarBackgroundCorner = Instance.new("UICorner")
loadingBarBackgroundCorner.CornerRadius = UDim.new(0, 5)
loadingBarBackgroundCorner.Parent = loadingBarBackground

-- Loading Bar Fill
local loadingBarFill = Instance.new("Frame")
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.Position = UDim2.new(0, 0, 0, 0)
loadingBarFill.BackgroundColor3 = Color3.fromRGB(70, 140, 240)
loadingBarFill.BorderSizePixel = 0
loadingBarFill.Parent = loadingBarBackground
loadingBarFill.BackgroundTransparency = 1 -- Hidden initially

local loadingBarFillCorner = Instance.new("UICorner")
loadingBarFillCorner.CornerRadius = UDim.new(0, 5)
loadingBarFillCorner.Parent = loadingBarFill

-- Warning label
[cite_start]local warningLabel = Instance.new("TextLabel") [cite: 5]
warningLabel.Size = UDim2.new(1, -40, 0, 40)
warningLabel.Position = UDim2.new(0, 20, 0, 245)
[cite_start]warningLabel.BackgroundTransparency = 1 [cite: 5]
[cite_start]warningLabel.Text = "Warning: Don't use scripts from unknown developers because it might steal your in-game items!" [cite: 5, 6]
[cite_start]warningLabel.TextColor3 = Color3.fromRGB(245, 100, 100) [cite: 6]
[cite_start]warningLabel.TextScaled = true [cite: 6]
warningLabel.TextSize = 10
[cite_start]warningLabel.Font = Enum.Font.Gotham [cite: 6]
[cite_start]warningLabel.TextTransparency = 1 [cite: 6]
[cite_start]warningLabel.TextWrapped = true [cite: 6]
[cite_start]warningLabel.Parent = contentFrame [cite: 6]

-- Water drop frame (smaller)
[cite_start]local waterDropFrame = Instance.new("Frame") [cite: 6]
[cite_start]waterDropFrame.Size = UDim2.new(0, 30, 0, 45) [cite: 6]
[cite_start]waterDropFrame.Position = UDim2.new(0.5, -15, 0, -50) [cite: 6]
[cite_start]waterDropFrame.BackgroundColor3 = Color3.fromRGB(70, 140, 240) [cite: 6]
[cite_start]waterDropFrame.BackgroundTransparency = 0.4 [cite: 6]
[cite_start]waterDropFrame.BorderSizePixel = 0 [cite: 6]
[cite_start]waterDropFrame.Parent = mainFrame [cite: 6]

[cite_start]local waterDropCorner = Instance.new("UICorner") [cite: 6]
[cite_start]waterDropCorner.CornerRadius = UDim.new(0.5, 0) [cite: 6]
[cite_start]waterDropCorner.Parent = waterDropFrame [cite: 6]

-- Copy button functionality
[cite_start]copyButton.MouseButton1Click:Connect(function() [cite: 6]
    [cite_start]pcall(function() [cite: 7]
        [cite_start]setclipboard("https://discord.gg/bpsNUH5sVb") [cite: 7]
        [cite_start]copyButton.Text = "Copied!" [cite: 7]
        [cite_start]copyButton.BackgroundColor3 = Color3.fromRGB(50, 120, 220) [cite: 7]
        [cite_start]wait(1) [cite: 7]
        [cite_start]copyButton.Text = "Copy" [cite: 7]
        [cite_start]copyButton.BackgroundColor3 = Color3.fromRGB(70, 140, 240) [cite: 7]
    end)
end)

-- Animate particles (simplified)
[cite_start]local function animateParticles() [cite: 7]
    -- Particle animation can be added if desired
end

-- Animate loading bar (realistic fill)
local function animateLoadingBar(callback)
    print("Starting animateLoadingBar")
    loadingText.Text = "Loading..."
    loadingText.TextColor3 = Color3.fromRGB(70, 140, 240)
    loadingBarBackground.BackgroundTransparency = 0
    loadingBarFill.BackgroundTransparency = 0
    loadingBarFill.Size = UDim2.new(0, 0, 1, 0)

    local duration = 3 -- 3 seconds to fill
    local startTime = tick()
    local connection

    connection = game:GetService("RunService").RenderStepped:Connect(function()
        local elapsedTime = tick() - startTime
        local progress = math.min(elapsedTime / duration, 1)

        loadingBarFill.Size = UDim2.new(progress, 0, 1, 0)

        if progress >= 1 then
            connection:Disconnect()
            loadingText.Text = "Successful!"
            loadingText.TextColor3 = Color3.fromRGB(0, 150, 0)
            wait(0.5) -- Small delay after completion
            isComplete = true
            if callback then
                callback()
            end
        end
    end)
end

-- Water drop entrance animations
[cite_start]local function playEntranceAnimations() [cite: 13]
    -- Ensure all elements are hidden
    [cite_start]contentFrame.BackgroundTransparency = 1 [cite: 13]
    [cite_start]contentStroke.Transparency = 1 [cite: 13]
    [cite_start]titleLabel.TextTransparency = 1 [cite: 13]
    [cite_start]subtitleLabel.TextTransparency = 1 [cite: 13]
    [cite_start]discordLabel.TextTransparency = 1 [cite: 13]
    [cite_start]copyButton.TextTransparency = 1 [cite: 13]
    [cite_start]copyButton.BackgroundTransparency = 1 [cite: 13]
    [cite_start]discordAdLabel.TextTransparency = 1 [cite: 14]
    [cite_start]loadingText.TextTransparency = 1 [cite: 14]
    loadingBarBackground.BackgroundTransparency = 1
    loadingBarFill.BackgroundTransparency = 1
    [cite_start]warningLabel.TextTransparency = 1 [cite: 14]

    -- Water drop fall animation
    local dropFallTween = TweenService:Create(waterDropFrame, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        Position = UDim2.new(0.5, -15, 0.5, -150) -- Adjusted to land on content frame center
    [cite_start]}) [cite: 14]

    -- Ripple expansion
    local rippleTween = TweenService:Create(waterDropFrame, TweenInfo.new(
        1.0,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        Size = UDim2.new(0, 400, 0, 300), -- Expands to content frame size
        Position = UDim2.new(0.5, -200, 0.5, -150),
        BackgroundTransparency = 1
    [cite_start]}) [cite: 15]

    -- Start animations
    [cite_start]dropFallTween:Play() [cite: 15]
    [cite_start]dropFallTween.Completed:Connect(function() [cite: 15]
        [cite_start]rippleTween:Play() [cite: 15]
    end)

    -- Reveal content frame and elements
    [cite_start]rippleTween.Completed:Connect(function() [cite: 16]
        local mainFrameTween = TweenService:Create(mainFrame, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ), {
            BackgroundTransparency = 0.8
        [cite_start]}) [cite: 16]

        local contentFrameTween = TweenService:Create(contentFrame, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            BackgroundTransparency = 0.1
        [cite_start]}) [cite: 17]

        local contentStrokeTween = TweenService:Create(contentStroke, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            Transparency = 0.3
        [cite_start]}) [cite: 18]

        local titleTween = TweenService:Create(titleLabel, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            TextTransparency = 0
        [cite_start]}) [cite: 19]

        local subtitleTween = TweenService:Create(subtitleLabel, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            TextTransparency = 0
        [cite_start]}) [cite: 19]

        local discordTween = TweenService:Create(discordLabel, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            TextTransparency = 0
        [cite_start]}) [cite: 20]

        local copyButtonTween = TweenService:Create(copyButton, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            TextTransparency = 0,
            BackgroundTransparency = 0.1
        [cite_start]}) [cite: 21]

        local discordAdTween = TweenService:Create(discordAdLabel, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            TextTransparency = 0
        [cite_start]}) [cite: 22]

        local loadingTextTween = TweenService:Create(loadingText, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            TextTransparency = 0
        [cite_start]}) [cite: 23]

        local loadingBarBackgroundTween = TweenService:Create(loadingBarBackground, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            BackgroundTransparency = 0
        })

        local loadingBarFillTween = TweenService:Create(loadingBarFill, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            BackgroundTransparency = 0
        })

        local warningTween = TweenService:Create(warningLabel, TweenInfo.new(
            0.4,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.Out
        ), {
            TextTransparency = 0
        [cite_start]}) [cite: 23]

        [cite_start]mainFrameTween:Play() [cite: 24]
        [cite_start]contentFrameTween:Play() [cite: 24]
        [cite_start]contentStrokeTween:Play() [cite: 24]
        [cite_start]titleTween:Play() [cite: 24]
        [cite_start]wait(0.05) [cite: 24]
        [cite_start]subtitleTween:Play() [cite: 24]
        [cite_start]wait(0.05) [cite: 24]
        [cite_start]discordTween:Play() [cite: 24]
        [cite_start]copyButtonTween:Play() [cite: 24]
        [cite_start]wait(0.05) [cite: 24]
        [cite_start]discordAdTween:Play() [cite: 24]
        [cite_start]wait(0.05) [cite: 25]
        [cite_start]loadingTextTween:Play() [cite: 25]
        loadingBarBackgroundTween:Play()
        loadingBarFillTween:Play()
        [cite_start]warningTween:Play() [cite: 25]

        [cite_start]loadingTextTween.Completed:Wait() [cite: 25]
        [cite_start]waterDropFrame:Destroy() [cite: 25]
        [cite_start]animateLoadingBar(function() [cite: 25]
            print("Loading bar completed, ready for exit")
        end)
    end)
end

-- Evaporation exit animations
[cite_start]local function playExitAnimations(callback) [cite: 25]
    [cite_start]print("Starting playExitAnimations") [cite: 25]

    local contentFadeOutTween = TweenService:Create(contentFrame, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0.6, 0, 0.6, 0),
        Position = UDim2.new(0.5, -120, 0.5, -90)
    })

    local strokeFadeOutTween = TweenService:Create(contentStroke, TweenInfo.new(0.5), {
        Transparency = 1
    })

    local textFadeOutTween = TweenService:Create(titleLabel, TweenInfo.new(0.3), {TextTransparency = 1})
    TweenService:Create(subtitleLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(discordLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(copyButton, TweenInfo.new(0.3), {TextTransparency = 1, BackgroundTransparency = 1}):Play()
    TweenService:Create(discordAdLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(loadingText, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    TweenService:Create(loadingBarBackground, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(loadingBarFill, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
    TweenService:Create(warningLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()

    contentFadeOutTween:Play()
    strokeFadeOutTween:Play()
    textFadeOutTween:Play()

    local mainFrameFadeTween = TweenService:Create(mainFrame, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        BackgroundTransparency = 1
    [cite_start]}) [cite: 27]

    contentFadeOutTween.Completed:Wait()

    [cite_start]mainFrameFadeTween:Play() [cite: 27]
    mainFrameFadeTween.Completed:Wait()

    [cite_start]if screenGui and screenGui.Parent then [cite: 28]
        [cite_start]screenGui:Destroy() [cite: 28]
        print("ScreenGui destroyed after exit animations")
    end
    [cite_start]if callback then [cite: 28]
        callback()
    end
end

-- Border pulse
[cite_start]local function animatePulse() [cite: 28]
    local borderPulseTween = TweenService:Create(contentStroke, TweenInfo.new(
        1.5,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    ), {
        Transparency = 0.1
    [cite_start]}) [cite: 29]

    [cite_start]borderPulseTween:Play() [cite: 29]
end

-- Expose loading screen functions
return {
    playEntranceAnimations = playEntranceAnimations,
    playExitAnimations = playExitAnimations,
    animateParticles = animateParticles,
    animatePulse = animatePulse,
    animateLoadingBar = animateLoadingBar,
    [cite_start]setLoadingText = function(text, color) [cite: 29]
        [cite_start]if loadingText and loadingText.Parent then [cite: 29]
            [cite_start]loadingText.Text = text or "loading" [cite: 30]
            [cite_start]loadingText.TextColor3 = color or Color3.fromRGB(70, 140, 240) [cite: 30]
        end
    end,
    [cite_start]isComplete = function() [cite: 30]
        [cite_start]return isComplete [cite: 30]
    end
}

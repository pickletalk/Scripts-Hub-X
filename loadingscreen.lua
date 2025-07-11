-- Scripts Hub X | Official Loading Screen
-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptsHubXLoading"
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Main background frame (hidden until animation completes)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(10, 20, 30)
mainFrame.BackgroundTransparency = 1 -- Hidden initially
mainFrame.Parent = screenGui

-- Content frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 400, 0, 360) -- Increased height to accommodate new label
contentFrame.Position = UDim2.new(0.5, -200, 0.5, -180)
contentFrame.BackgroundColor3 = Color3.fromRGB(20, 40, 60)
contentFrame.BackgroundTransparency = 1 -- Hidden until animation completes
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Content frame corner
local contentFrameCorner = Instance.new("UICorner")
contentFrameCorner.CornerRadius = UDim.new(0, 16)
contentFrameCorner.Parent = contentFrame

-- Content frame glow
local contentStroke = Instance.new("UIStroke")
contentStroke.Color = Color3.fromRGB(80, 160, 255)
contentStroke.Thickness = 1.5
contentStroke.Transparency = 1 -- Hidden until animation completes
contentStroke.Parent = contentFrame

-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 50)
titleLabel.Position = UDim2.new(0, 20, 0, 20)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Scripts Hub X"
titleLabel.TextColor3 = Color3.fromRGB(120, 180, 255)
titleLabel.TextScaled = true
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextTransparency = 1 -- Hidden until animation completes
titleLabel.Parent = contentFrame

-- Subtitle label
local subtitleLabel = Instance.new("TextLabel")
subtitleLabel.Size = UDim2.new(1, -40, 0, 30)
subtitleLabel.Position = UDim2.new(0, 20, 0, 70)
subtitleLabel.BackgroundTransparency = 1
subtitleLabel.Text = "Official Loading"
subtitleLabel.TextColor3 = Color3.fromRGB(150, 180, 200)
subtitleLabel.TextScaled = true
subtitleLabel.TextSize = 16
subtitleLabel.Font = Enum.Font.Gotham
subtitleLabel.TextTransparency = 1 -- Hidden until animation completes
subtitleLabel.Parent = contentFrame

-- Discord container
local discordContainer = Instance.new("Frame")
discordContainer.Size = UDim2.new(1, -40, 0, 40)
discordContainer.Position = UDim2.new(0, 20, 0, 110)
discordContainer.BackgroundColor3 = Color3.fromRGB(30, 50, 70)
discordContainer.BackgroundTransparency = 1 -- Hidden until animation completes
discordContainer.BorderSizePixel = 0
discordContainer.Parent = contentFrame

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 8)
discordCorner.Parent = discordContainer

-- Discord label
local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(0.7, -10, 1, -10)
discordLabel.Position = UDim2.new(0, 10, 0, 5)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "discord.gg/bpsNUH5sVb"
discordLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
discordLabel.TextScaled = true
discordLabel.TextSize = 12
discordLabel.Font = Enum.Font.Gotham
discordLabel.TextXAlignment = Enum.TextXAlignment.Left
discordLabel.TextTransparency = 1 -- Hidden until animation completes
discordLabel.Parent = discordContainer

-- Copy button
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0, 80, 0, 28)
copyButton.Position = UDim2.new(0.73, 5, 0, 6)
copyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
copyButton.BackgroundTransparency = 1 -- Hidden until animation completes
copyButton.Text = "Copy"
copyButton.TextColor3 = Color3.fromRGB(230, 240, 255)
copyButton.TextScaled = true
copyButton.TextSize = 12
copyButton.Font = Enum.Font.GothamBold
copyButton.TextTransparency = 1 -- Hidden until animation completes
copyButton.Parent = discordContainer

local copyButtonCorner = Instance.new("UICorner")
copyButtonCorner.CornerRadius = UDim.new(0, 6)
copyButtonCorner.Parent = copyButton

-- Discord advertisement label
local discordAdLabel = Instance.new("TextLabel")
discordAdLabel.Size = UDim2.new(1, -40, 0, 40)
discordAdLabel.Position = UDim2.new(0, 20, 0, 160)
discordAdLabel.BackgroundTransparency = 1
discordAdLabel.Text = "Join our Discord server for more updates!"
discordAdLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
discordAdLabel.TextScaled = true
discordAdLabel.TextSize = 12
discordAdLabel.Font = Enum.Font.Gotham
discordAdLabel.TextTransparency = 1 -- Hidden until animation completes
discordAdLabel.TextWrapped = true
discordAdLabel.Parent = contentFrame

-- Loading bar background
local loadingBarBg = Instance.new("Frame")
loadingBarBg.Size = UDim2.new(1, -40, 0, 8)
loadingBarBg.Position = UDim2.new(0, 20, 0, 210)
loadingBarBg.BackgroundColor3 = Color3.fromRGB(30, 50, 70)
loadingBarBg.BackgroundTransparency = 1 -- Hidden until animation completes
loadingBarBg.BorderSizePixel = 0
loadingBarBg.Parent = contentFrame

local loadingBarBgCorner = Instance.new("UICorner")
loadingBarBgCorner.CornerRadius = UDim.new(0, 4)
loadingBarBgCorner.Parent = loadingBarBg

-- Loading bar fill
local loadingBarFill = Instance.new("Frame")
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
loadingBarFill.BorderSizePixel = 0
loadingBarFill.Parent = loadingBarBg

local loadingBarFillCorner = Instance.new("UICorner")
loadingBarFillCorner.CornerRadius = UDim.new(0, 4)
loadingBarFillCorner.Parent = loadingBarFill

-- Loading bar gradient
local loadingBarGradient = Instance.new("UIGradient")
loadingBarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(80, 160, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(120, 180, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(80, 160, 255))
})
loadingBarGradient.Parent = loadingBarFill

-- Loading text
local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, -40, 0, 30)
loadingText.Position = UDim2.new(0, 20, 0, 230)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading..."
loadingText.TextColor3 = Color3.fromRGB(150, 180, 200)
loadingText.TextScaled = true
loadingText.TextSize = 14
loadingText.Font = Enum.Font.Gotham
loadingText.TextTransparency = 1 -- Hidden until animation completes
loadingText.Parent = contentFrame

-- Warning label
local warningLabel = Instance.new("TextLabel")
warningLabel.Size = UDim2.new(1, -40, 0, 40)
warningLabel.Position = UDim2.new(0, 20, 0, 270)
warningLabel.BackgroundTransparency = 1
warningLabel.Text = "Warning: Don't use scripts from unknown developers, as they might steal your in-game items, pets, etc."
warningLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
warningLabel.TextScaled = true
warningLabel.TextSize = 10
warningLabel.Font = Enum.Font.Gotham
warningLabel.TextTransparency = 1 -- Hidden until animation completes
warningLabel.TextWrapped = true
warningLabel.Parent = contentFrame

-- Note label
local noteLabel = Instance.new("TextLabel")
noteLabel.Size = UDim2.new(1, -40, 0, 40)
noteLabel.Position = UDim2.new(0, 20, 0, 310)
noteLabel.BackgroundTransparency = 1
noteLabel.Text = "Note: If you saw our script in a random YouTube or other advertising video, join our Discord for a loading screen showcase."
noteLabel.TextColor3 = Color3.fromRGB(150, 180, 200)
noteLabel.TextScaled = true
noteLabel.TextSize = 10
noteLabel.Font = Enum.Font.Gotham
noteLabel.TextTransparency = 1 -- Hidden until animation completes
noteLabel.TextWrapped = true
noteLabel.Parent = contentFrame

-- Copy button functionality
copyButton.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard("https://discord.gg/bpsNUH5sVb")
        copyButton.Text = "Copied!"
        copyButton.BackgroundColor3 = Color3.fromRGB(60, 140, 235)
        wait(1)
        copyButton.Text = "Copy"
        copyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    end)
end)

-- Animate particles (simplified for this context)
local function animateParticles()
    -- Particle animation can be added if desired, currently minimal
end

-- Animate loading bar to show "Game Is Supported!" with brief loading steps
local function animateLoadingBar()
    local loadingSteps = {
        {progress = 0.2, text = "Initializing...", duration = 1.0},
        {progress = 0.4, text = "Verifying...", duration = 1.0},
        {progress = 0.6, text = "Checking game support...", duration = 1.0},
        {progress = 1.0, text = "Game Is Supported!", duration = 2.0, color = Color3.fromRGB(100, 255, 100)}
    }
    
    for i, step in ipairs(loadingSteps) do
        wait(step.duration)
        loadingText.Text = step.text
        if step.color then
            loadingText.TextColor3 = step.color
        end
        
        local barTween = TweenService:Create(loadingBarFill, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ), {
            Size = UDim2.new(step.progress, 0, 1, 0)
        })
        
        barTween:Play()
        barTween.Completed:Wait()
    end
end

-- Fade-in animations (no water drop or ripple)
local function playEntranceAnimations()
    -- Ensure all elements are hidden during animation
    contentFrame.BackgroundTransparency = 1
    contentStroke.Transparency = 1
    titleLabel.TextTransparency = 1
    subtitleLabel.TextTransparency = 1
    discordLabel.TextTransparency = 1
    copyButton.TextTransparency = 1
    copyButton.BackgroundTransparency = 1
    discordAdLabel.TextTransparency = 1
    loadingBarBg.BackgroundTransparency = 1
    loadingText.TextTransparency = 1
    warningLabel.TextTransparency = 1
    noteLabel.TextTransparency = 1

    -- Fade-in animations
    local mainFrameTween = TweenService:Create(mainFrame, TweenInfo.new(
        0.6,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        BackgroundTransparency = 0.7
    })

    local contentFrameTween = TweenService:Create(contentFrame, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        BackgroundTransparency = 0.5
    })

    local contentStrokeTween = TweenService:Create(contentStroke, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        Transparency = 0.4
    })

    local titleTween = TweenService:Create(titleLabel, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })

    local subtitleTween = TweenService:Create(subtitleLabel, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })

    local discordTween = TweenService:Create(discordLabel, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })

    local copyButtonTween = TweenService:Create(copyButton, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0,
        BackgroundTransparency = 0.2
    })

    local discordAdTween = TweenService:Create(discordAdLabel, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })

    local loadingBarBgTween = TweenService:Create(loadingBarBg, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        BackgroundTransparency = 0.6
    })

    local loadingTextTween = TweenService:Create(loadingText, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })

    local warningTween = TweenService:Create(warningLabel, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })

    local noteTween = TweenService:Create(noteLabel, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })

    mainFrameTween:Play()
    contentFrameTween:Play()
    contentStrokeTween:Play()
    titleTween:Play()
    wait(0.1)
    subtitleTween:Play()
    wait(0.1)
    discordTween:Play()
    copyButtonTween:Play()
    wait(0.1)
    discordAdTween:Play()
    wait(0.1)
    warningTween:Play()
    wait(0.1)
    noteTween:Play()
    wait(0.1)
    loadingBarBgTween:Play()
    loadingTextTween:Play()

    loadingTextTween.Completed:Wait()
end

-- Evaporation exit animations
local function playExitAnimations()
    local evaporateTween = TweenService:Create(contentFrame, TweenInfo.new(
        0.7,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 450, 0, 400), -- Adjusted for new content frame size
        Position = UDim2.new(0.5, -225, 0.5, -200)
    })

    local mainFrameTween = TweenService:Create(mainFrame, TweenInfo.new(
        0.7,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        BackgroundTransparency = 1
    })

    local contentStrokeTween = TweenService:Create(contentStroke, TweenInfo.new(
        0.7,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        Transparency = 1
    })

    for _, element in pairs({titleLabel, subtitleLabel, discordLabel, discordAdLabel, loadingText, copyButton, warningLabel, noteLabel}) do
        TweenService:Create(element, TweenInfo.new(
            0.5,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ), {
            TextTransparency = 1
        }):Play()
    end

    TweenService:Create(copyButton, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        BackgroundTransparency = 1
    }):Play()

    TweenService:Create(loadingBarBg, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        BackgroundTransparency = 1
    }):Play()

    evaporateTween:Play()
    mainFrameTween:Play()
    contentStrokeTween:Play()

    evaporateTween.Completed:Wait()

    screenGui:Destroy()
end

-- Border pulse
local function animatePulse()
    local borderPulseTween = TweenService:Create(contentStroke, TweenInfo.new(
        1.8,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    ), {
        Transparency = 0.2
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
        loadingText.Text = text
        if color then
            loadingText.TextColor3 = color
        end
    end
}

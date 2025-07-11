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
contentFrame.Size = UDim2.new(0, 400, 0, 280)
contentFrame.Position = UDim2.new(0.5, -200, 0.5, -140)
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

-- Loading bar background
local loadingBarBg = Instance.new("Frame")
loadingBarBg.Size = UDim2.new(1, -40, 0, 8)
loadingBarBg.Position = UDim2.new(0, 20, 0, 170)
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
loadingText.Position = UDim2.new(0, 20, 0, 190)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading..."
loadingText.TextColor3 = Color3.fromRGB(150, 180, 200)
loadingText.TextScaled = true
loadingText.TextSize = 14
loadingText.Font = Enum.Font.Gotham
loadingText.TextTransparency = 1 -- Hidden until animation completes
loadingText.Parent = contentFrame

-- Water drop frame
local waterDropFrame = Instance.new("Frame")
waterDropFrame.Size = UDim2.new(0, 40, 0, 60) -- Teardrop shape approximation
waterDropFrame.Position = UDim2.new(0.5, -20, 0, -60) -- Starts above screen
waterDropFrame.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
waterDropFrame.BackgroundTransparency = 0.3
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

-- Animate loading bar with extended duration and longer "Searching script" step
local function animateLoadingBar()
    local loadingSteps = {
        {progress = 0.2, text = "Initializing...", duration = 1.5},
        {progress = 0.4, text = "Verifying...", duration = 1.5},
        {progress = 0.6, text = "Searching script...", duration = 3.0}, -- Longer duration
        {progress = 0.8, text = "Loading assets...", duration = 1.5},
        {progress = 1.0, text = "Ready!", duration = 1.5}
    }
    
    for i, step in ipairs(loadingSteps) do
        wait(step.duration)
        loadingText.Text = step.text
        
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

-- Water drop entrance animations with longer duration
local function playEntranceAnimations()
    -- Ensure all elements are hidden during animation
    contentFrame.BackgroundTransparency = 1
    contentStroke.Transparency = 1
    titleLabel.TextTransparency = 1
    subtitleLabel.TextTransparency = 1
    discordLabel.TextTransparency = 1
    copyButton.TextTransparency = 1
    copyButton.BackgroundTransparency = 1
    loadingBarBg.BackgroundTransparency = 1
    loadingText.TextTransparency = 1

    -- Water drop fall animation with longer duration
    local dropFallTween = TweenService:Create(waterDropFrame, TweenInfo.new(
        1.0, -- Extended to 1.0 seconds
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        Position = UDim2.new(0.5, -20, 0.5, -140) -- Falls to center
    })

    -- Ripple expansion after drop with longer duration
    local rippleTween = TweenService:Create(waterDropFrame, TweenInfo.new(
        1.2, -- Extended to 1.2 seconds
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.Out
    ), {
        Size = UDim2.new(0, 400, 0, 280),
        Position = UDim2.new(0.5, -200, 0.5, -140),
        BackgroundTransparency = 1 -- Fade out ripple
    })

    -- Start animations
    dropFallTween:Play()
    dropFallTween.Completed:Connect(function()
        rippleTween:Play()
    end)

    -- Reveal content frame and elements after ripple completes
    rippleTween.Completed:Connect(function()
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
        loadingBarBgTween:Play()
        loadingTextTween:Play()

        loadingTextTween.Completed:Wait()
        waterDropFrame:Destroy() -- Remove water drop after animation
    end)
end

-- Evaporation exit animations
local function playExitAnimations()
    local evaporateTween = TweenService:Create(contentFrame, TweenInfo.new(
        0.7,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 450, 0, 320), -- Slight scale up for evaporation effect
        Position = UDim2.new(0.5, -225, 0.5, -160)
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
    
    for _, element in pairs({titleLabel, subtitleLabel, discordLabel, loadingText, copyButton}) do
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

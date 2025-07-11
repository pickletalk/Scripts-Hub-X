-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TextService = game:GetService("TextService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ErrorNotification"
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
contentFrame.Size = UDim2.new(0, 400, 0, 320)
contentFrame.Position = UDim2.new(0.5, -200, 0.5, -160)
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

-- Error title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 50)
titleLabel.Position = UDim2.new(0, 20, 0, 20)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Script Failed To Execute"
titleLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
titleLabel.TextScaled = true
titleLabel.TextSize = 24
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextTransparency = 1 -- Hidden until animation completes
titleLabel.Parent = contentFrame

-- Error message label
local errorLabel = Instance.new("TextLabel")
errorLabel.Size = UDim2.new(1, -40, 0, 60)
errorLabel.Position = UDim2.new(0, 20, 0, 80)
errorLabel.BackgroundTransparency = 1
errorLabel.Text = "This game is not supported or does not have a script yet."
errorLabel.TextColor3 = Color3.fromRGB(150, 180, 200)
errorLabel.TextScaled = true
errorLabel.TextSize = 12
errorLabel.Font = Enum.Font.Gotham
errorLabel.TextTransparency = 1 -- Hidden until animation completes
errorLabel.TextWrapped = true
errorLabel.Parent = contentFrame

-- Discord suggestion label
local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(1, -40, 0, 60)
discordLabel.Position = UDim2.new(0, 20, 0, 150)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "Suggest this game on our Discord: https://discord.gg/bpsNUH5sVb"
discordLabel.TextColor3 = Color3.fromRGB(100, 160, 255)
discordLabel.TextScaled = true
discordLabel.TextSize = 12
discordLabel.Font = Enum.Font.Gotham
discordLabel.TextTransparency = 1 -- Hidden until animation completes
discordLabel.TextWrapped = true
discordLabel.Parent = contentFrame

-- Copy button
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0, 80, 0, 28)
copyButton.Position = UDim2.new(0.5, -40, 0, 220)
copyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
copyButton.BackgroundTransparency = 1 -- Hidden until animation completes
copyButton.Text = "Copy Link"
copyButton.TextColor3 = Color3.fromRGB(230, 240, 255)
copyButton.TextScaled = true
copyButton.TextSize = 12
copyButton.Font = Enum.Font.GothamBold
copyButton.TextTransparency = 1 -- Hidden until animation completes
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
        copyButton.Text = "Copy Link"
        copyButton.BackgroundColor3 = Color3.fromRGB(80, 160, 255)
    end)
end)

-- Fade-in animations (no water drop or ripple)
local function playEntranceAnimations()
    -- Ensure all elements are hidden during animation
    contentFrame.BackgroundTransparency = 1
    contentStroke.Transparency = 1
    titleLabel.TextTransparency = 1
    errorLabel.TextTransparency = 1
    discordLabel.TextTransparency = 1
    copyButton.TextTransparency = 1
    copyButton.BackgroundTransparency = 1

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

    local errorTween = TweenService:Create(errorLabel, TweenInfo.new(
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

    mainFrameTween:Play()
    contentFrameTween:Play()
    contentStrokeTween:Play()
    titleTween:Play()
    wait(0.1)
    errorTween:Play()
    wait(0.1)
    discordTween:Play()
    wait(0.1)
    copyButtonTween:Play()

    copyButtonTween.Completed:Wait()
end

-- Evaporation exit animations
local function playExitAnimations()
    local evaporateTween = TweenService:Create(contentFrame, TweenInfo.new(
        0.7,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 450, 0, 360),
        Position = UDim2.new(0.5, -225, 0.5, -180)
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

    for _, element in pairs({titleLabel, errorLabel, discordLabel, copyButton}) do
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

-- Execute animations
playEntranceAnimations()
animatePulse()
wait(2) -- Display for 2 seconds
playExitAnimations()

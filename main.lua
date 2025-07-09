-- Scripts Hub X | Official Loading Screen
-- Game detection and script loading function
local function checkGameSupport()
    local success, Games = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts/refs/heads/main/GameList.lua"))()
    end)
    
    if not success then
        warn("Failed to load game list: " .. tostring(Games))
        return false, "Failed to connect to script server"
    end
    
    for PlaceID, Execute in pairs(Games) do
        if PlaceID == game.PlaceId then
            return true, Execute
        end
    end
    
    return false, "Sorry, this game doesn't support our script!"
end

-- Function to load the actual script
local function loadGameScript(scriptUrl)
    local success, result = pcall(function()
        return loadstring(game:HttpGet(scriptUrl))()
    end)
    
    if not success then
        warn("Failed to load game script: " .. tostring(result))
        return false
    end
    
    return true
end

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

-- Main background frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 30, 40)
mainFrame.BackgroundTransparency = 0.5
mainFrame.Parent = screenGui

-- Content frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 450, 0, 300)
contentFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
contentFrame.BackgroundColor3 = Color3.fromRGB(30, 45, 65)
contentFrame.BorderSizePixel = 0
contentFrame.BackgroundTransparency = 0.3
contentFrame.Parent = mainFrame

-- Content frame corner
local contentFrameCorner = Instance.new("UICorner")
contentFrameCorner.CornerRadius = UDim.new(0, 12)
contentFrameCorner.Parent = contentFrame

-- Content frame glow
local contentStroke = Instance.new("UIStroke")
contentStroke.Color = Color3.fromRGB(100, 200, 255)
contentStroke.Thickness = 2
contentStroke.Transparency = 0.3
contentStroke.Parent = contentFrame

-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -30, 0, 40)
titleLabel.Position = UDim2.new(0, 15, 0, 20)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Scripts Hub X | Official"
titleLabel.TextColor3 = Color3.fromRGB(150, 220, 255)
titleLabel.TextScaled = true
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = contentFrame

-- Title glow
local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Color3.fromRGB(100, 200, 255)
titleStroke.Thickness = 1.5
titleStroke.Transparency = 0.4
titleStroke.Parent = titleLabel

-- Credits label
local creditsLabel = Instance.new("TextLabel")
creditsLabel.Size = UDim2.new(1, -30, 0, 20)
creditsLabel.Position = UDim2.new(0, 15, 0, 60)
creditsLabel.BackgroundTransparency = 1
creditsLabel.Text = "Developed by Scripts Hub Team"
creditsLabel.TextColor3 = Color3.fromRGB(180, 200, 220)
creditsLabel.TextScaled = true
creditsLabel.TextSize = 14
creditsLabel.Font = Enum.Font.SourceSans
creditsLabel.Parent = contentFrame

-- Warning label
local warningLabel = Instance.new("TextLabel")
warningLabel.Size = UDim2.new(1, -30, 0, 30)
warningLabel.Position = UDim2.new(0, 15, 0, 85)
warningLabel.BackgroundTransparency = 1
warningLabel.Text = "Warning: Don't use scripts from unknown developers, they might steal your pets and fruits."
warningLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
warningLabel.TextScaled = true
warningLabel.TextSize = 12
warningLabel.Font = Enum.Font.SourceSans
warningLabel.TextWrapped = true
warningLabel.Parent = contentFrame

-- Tip label
local tipLabel = Instance.new("TextLabel")
tipLabel.Size = UDim2.new(1, -30, 0, 30)
tipLabel.Position = UDim2.new(0, 15, 0, 115)
tipLabel.BackgroundTransparency = 1
tipLabel.Text = "Tip: If you see a loading screen that covers the whole screen, leave immediately!"
tipLabel.TextColor3 = Color3.fromRGB(180, 200, 220)
tipLabel.TextScaled = true
tipLabel.TextSize = 12
tipLabel.Font = Enum.Font.SourceSans
tipLabel.TextWrapped = true
tipLabel.Parent = contentFrame

-- Discord container
local discordContainer = Instance.new("Frame")
discordContainer.Size = UDim2.new(1, -40, 0, 40)
discordContainer.Position = UDim2.new(0, 20, 0, 150)
discordContainer.BackgroundColor3 = Color3.fromRGB(40, 60, 80)
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
discordLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
discordLabel.TextScaled = true
discordLabel.TextSize = 12
discordLabel.Font = Enum.Font.SourceSans
discordLabel.TextXAlignment = Enum.TextXAlignment.Left
discordLabel.Parent = discordContainer

-- Copy button
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0, 60, 0, 25)
copyButton.Position = UDim2.new(0.75, 5, 0, 7)
copyButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
copyButton.Text = "Copy discord link"
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.TextScaled = true
copyButton.TextSize = 12
copyButton.Font = Enum.Font.SourceSansBold
copyButton.Parent = discordContainer

local copyButtonCorner = Instance.new("UICorner")
copyButtonCorner.CornerRadius = UDim.new(0, 6)
copyButtonCorner.Parent = copyButton

-- Loading bar background
local loadingBarBg = Instance.new("Frame")
loadingBarBg.Size = UDim2.new(1, -40, 0, 10)
loadingBarBg.Position = UDim2.new(0, 20, 0, 200)
loadingBarBg.BackgroundColor3 = Color3.fromRGB(40, 60, 80)
loadingBarBg.BorderSizePixel = 0
loadingBarBg.Parent = contentFrame

local loadingBarBgCorner = Instance.new("UICorner")
loadingBarBgCorner.CornerRadius = UDim.new(0, 5)
loadingBarBgCorner.Parent = loadingBarBg

-- Loading bar fill
local loadingBarFill = Instance.new("Frame")
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
loadingBarFill.BorderSizePixel = 0
loadingBarFill.Parent = loadingBarBg

local loadingBarFillCorner = Instance.new("UICorner")
loadingBarFillCorner.CornerRadius = UDim.new(0, 5)
loadingBarFillCorner.Parent = loadingBarFill

-- Loading bar gradient
local loadingBarGradient = Instance.new("UIGradient")
loadingBarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(100, 200, 255)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(150, 220, 255)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 200, 255))
})
loadingBarGradient.Parent = loadingBarFill

-- Loading text
local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, -30, 0, 30)
loadingText.Position = UDim2.new(0, 15, 0, 220)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading..."
loadingText.TextColor3 = Color3.fromRGB(180, 200, 220)
loadingText.TextScaled = true
loadingText.TextSize = 14
loadingText.Font = Enum.Font.SourceSans
loadingText.Parent = contentFrame

-- Particles frame
local particlesFrame = Instance.new("Frame")
particlesFrame.Size = UDim2.new(1, 0, 1, 0)
particlesFrame.BackgroundTransparency = 1
particlesFrame.Parent = screenGui

-- Create particles
local particles = {}
for i = 1, 20 do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
    particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
    particle.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    particle.BackgroundTransparency = 0.6
    particle.BorderSizePixel = 0
    particle.Parent = particlesFrame
    
    local particleCorner = Instance.new("UICorner")
    particleCorner.CornerRadius = UDim.new(1, 0)
    particleCorner.Parent = particle
    
    table.insert(particles, particle)
end

-- Copy button functionality
copyButton.MouseButton1Click:Connect(function()
    pcall(function()
        setclipboard("https://discord.gg/bpsNUH5sVb")
        copyButton.Text = "Copied!"
        copyButton.BackgroundColor3 = Color3.fromRGB(80, 180, 235)
        wait(1)
        copyButton.Text = "Copy"
        copyButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    end)
end)

-- Animate particles
local function animateParticles()
    for _, particle in pairs(particles) do
        local randomX = math.random() * 2 - 1
        local randomY = math.random() * 2 - 1
        
        local tween = TweenService:Create(particle, TweenInfo.new(
            math.random(2, 6),
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        ), {
            Position = UDim2.new(
                particle.Position.X.Scale + randomX * 0.15,
                0,
                particle.Position.Y.Scale + randomY * 0.15,
                0
            ),
            BackgroundTransparency = math.random(0.4, 0.8)
        })
        
        tween:Play()
    end
end

-- Animate loading bar
local function animateLoadingBar()
    local loadingSteps = {
        {progress = 0.2, text = "Initializing..."},
        {progress = 0.3, text = "Checking game support..."},
        {progress = 0.7, text = "Loading script..."},
        {progress = 0.9, text = "Preparing interface..."},
        {progress = 1.0, text = "Finalizing..."}
    }
    
    for i, step in ipairs(loadingSteps) do
        wait(math.random(0.4, 1.2))
        loadingText.Text = step.text
        
        local barTween = TweenService:Create(loadingBarFill, TweenInfo.new(
            0.6,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.Out
        ), {
            Size = UDim2.new(step.progress, 0, 1, 0)
        })
        
        barTween:Play()
        barTween.Completed:Wait()
    end
end

-- Entrance animations
local function playEntranceAnimations()
    mainFrame.BackgroundTransparency = 1
    contentFrame.BackgroundTransparency = 1
    contentStroke.Transparency = 1
    titleLabel.TextTransparency = 1
    creditsLabel.TextTransparency = 1
    warningLabel.TextTransparency = 1
    tipLabel.TextTransparency = 1
    discordLabel.TextTransparency = 1
    copyButton.TextTransparency = 1
    copyButton.BackgroundTransparency = 1
    loadingBarBg.BackgroundTransparency = 1
    loadingText.TextTransparency = 1
    
    contentFrame.Size = UDim2.new(0, 0, 0, 0)
    contentFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local mainFrameTween = TweenService:Create(mainFrame, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        BackgroundTransparency = 0.2
    })
    
    local contentFrameTween = TweenService:Create(contentFrame, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ), {
        Size = UDim2.new(0, 450, 0, 300),
        Position = UDim2.new(0.5, -225, 0.5, -150),
        BackgroundTransparency = 0
    })
    
    local contentStrokeTween = TweenService:Create(contentStroke, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ), {
        Transparency = 0.3
    })
    
    mainFrameTween:Play()
    contentFrameTween:Play()
    contentStrokeTween:Play()
    wait(0.4)
    
    local titleTween = TweenService:Create(titleLabel, TweenInfo.new(
        0.6,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })
    
    titleTween:Play()
    wait(0.2)
    
    local creditsTween = TweenService:Create(creditsLabel, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })
    
    creditsTween:Play()
    wait(0.2)
    
    local warningTween = TweenService:Create(warningLabel, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })
    
    warningTween:Play()
    wait(0.2)
    
    local tipTween = TweenService:Create(tipLabel, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })
    
    tipTween:Play()
    wait(0.2)
    
    local discordTween = TweenService:Create(discordLabel, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })
    
    local copyButtonTween = TweenService:Create(copyButton, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0,
        BackgroundTransparency = 0
    })
    
    discordTween:Play()
    copyButtonTween:Play()
    wait(0.2)
    
    local loadingBarBgTween = TweenService:Create(loadingBarBg, TweenInfo.new(
        0.4,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        BackgroundTransparency = 0
    })
    
    local loadingTextTween = TweenService:Create(loadingText, TweenInfo.new(
        0.4,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })
    
    loadingBarBgTween:Play()
    loadingTextTween:Play()
    loadingTextTween.Completed:Wait()
end

-- Exit animations
local function playExitAnimations()
    local exitTween = TweenService:Create(mainFrame, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        BackgroundTransparency = 1
    })
    
    for _, element in pairs({titleLabel, creditsLabel, warningLabel, tipLabel, discordLabel, loadingText, copyButton}) do
        TweenService:Create(element, TweenInfo.new(
            0.6,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ), {
            TextTransparency = 1
        }):Play()
    end
    
    TweenService:Create(copyButton, TweenInfo.new(
        0.6,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(loadingBarBg, TweenInfo.new(
        0.6,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(contentFrame, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        BackgroundTransparency = 1
    }):Play()
    
    TweenService:Create(contentStroke, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        Transparency = 1
    }):Play()
    
    exitTween:Play()
    exitTween.Completed:Wait()
    
    screenGui:Destroy()
end

-- Title and border pulse
local function animatePulse()
    local pulseTween = TweenService:Create(titleStroke, TweenInfo.new(
        1.5,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    ), {
        Transparency = 0.2
    })
    
    local borderPulseTween = TweenService:Create(contentStroke, TweenInfo.new(
        2,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    ), {
        Transparency = 0.1
    })
    
    pulseTween:Play()
    borderPulseTween:Play()
end

-- Main execution
coroutine.wrap(function()
    local isSupported, scriptUrlOrError = checkGameSupport()
    
    if not isSupported then
        loadingText.Text = scriptUrlOrError
        loadingText.TextColor3 = Color3.fromRGB(255, 100, 100)
        wait(3)
        playExitAnimations()
        return
    end
    
    print("Game supported! Loading Scripts Hub X...")
    
    playEntranceAnimations()
    animateParticles()
    animatePulse()
    animateLoadingBar()
    wait(0.5)
    playExitAnimations()
    
    local scriptLoaded = loadGameScript(scriptUrlOrError)
    
    if scriptLoaded then
        print("Scripts Hub X | Official - Loading Complete!")
    else
        print("Scripts Hub X | Official - Script loading failed!")
    end
end)()

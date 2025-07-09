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
mainFrame.BackgroundTransparency = 0.2
mainFrame.Parent = screenGui

-- Content frame
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 600, 0, 400)
contentFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
contentFrame.BackgroundColor3 = Color3.fromRGB(30, 50, 70)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Content frame corner
local contentFrameCorner = Instance.new("UICorner")
contentFrameCorner.CornerRadius = UDim.new(0, 15)
contentFrameCorner.Parent = contentFrame

-- Content frame glow
local contentStroke = Instance.new("UIStroke")
contentStroke.Color = Color3.fromRGB(100, 200, 255)
contentStroke.Thickness = 3
contentStroke.Transparency = 0.2
contentStroke.Parent = contentFrame

-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 80)
titleLabel.Position = UDim2.new(0, 20, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Scripts Hub X | Official"
titleLabel.TextColor3 = Color3.fromRGB(150, 220, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = contentFrame

-- Title glow
local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Color3.fromRGB(100, 200, 255)
titleStroke.Thickness = 2
titleStroke.Transparency = 0.4
titleStroke.Parent = titleLabel

-- Credits label
local creditsLabel = Instance.new("TextLabel")
creditsLabel.Size = UDim2.new(1, -40, 0, 30)
creditsLabel.Position = UDim2.new(0, 20, 0, 120)
creditsLabel.BackgroundTransparency = 1
creditsLabel.Text = "Developed by Scripts Hub Team"
creditsLabel.TextColor3 = Color3.fromRGB(180, 200, 220)
creditsLabel.TextScaled = true
creditsLabel.Font = Enum.Font.SourceSans
creditsLabel.Parent = contentFrame

-- Discord container
local discordContainer = Instance.new("Frame")
discordContainer.Size = UDim2.new(1, -60, 0, 50)
discordContainer.Position = UDim2.new(0, 30, 0, 160)
discordContainer.BackgroundColor3 = Color3.fromRGB(40, 60, 80)
discordContainer.BorderSizePixel = 0
discordContainer.Parent = contentFrame

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 10)
discordCorner.Parent = discordContainer

-- Discord label
local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(0.7, -10, 1, -10)
discordLabel.Position = UDim2.new(0, 10, 0, 5)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "discord.gg/bpsNUH5sVb"
discordLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
discordLabel.TextScaled = true
discordLabel.Font = Enum.Font.SourceSans
discordLabel.TextXAlignment = Enum.TextXAlignment.Left
discordLabel.Parent = discordContainer

-- Copy button
local copyButton = Instance.new("TextButton")
copyButton.Size = UDim2.new(0, 80, 0, 30)
copyButton.Position = UDim2.new(0.75, 5, 0, 10)
copyButton.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
copyButton.Text = "Copy"
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.TextScaled = true
copyButton.Font = Enum.Font.SourceSansBold
copyButton.Parent = discordContainer

local copyButtonCorner = Instance.new("UICorner")
copyButtonCorner.CornerRadius = UDim.new(0, 8)
copyButtonCorner.Parent = copyButton

-- Loading bar background
local loadingBarBg = Instance.new("Frame")
loadingBarBg.Size = UDim2.new(1, -60, 0, 12)
loadingBarBg.Position = UDim2.new(0, 30, 0, 240)
loadingBarBg.BackgroundColor3 = Color3.fromRGB(40, 60, 80)
loadingBarBg.BorderSizePixel = 0
loadingBarBg.Parent = contentFrame

local loadingBarBgCorner = Instance.new("UICorner")
loadingBarBgCorner.CornerRadius = UDim.new(0, 6)
loadingBarBgCorner.Parent = loadingBarBg

-- Loading bar fill
local loadingBarFill = Instance.new("Frame")
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
loadingBarFill.BorderSizePixel = 0
loadingBarFill.Parent = loadingBarBg

local loadingBarFillCorner = Instance.new("UICorner")
loadingBarFillCorner.CornerRadius = UDim.new(0, 6)
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
loadingText.Size = UDim2.new(1, -40, 0, 40)
loadingText.Position = UDim2.new(0, 20, 0, 280)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading..."
loadingText.TextColor3 = Color3.fromRGB(180, 200, 220)
loadingText.TextScaled = true
loadingText.Font = Enum.Font.SourceSans
loadingText.Parent = contentFrame

-- Particles frame
local particlesFrame = Instance.new("Frame")
particlesFrame.Size = UDim2.new(1, 0, 1, 0)
particlesFrame.BackgroundTransparency = 1
particlesFrame.Parent = screenGui

-- Create particles
local particles = {}
for i = 1, 30 do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, math.random(3, 8), 0, math.random(3, 8))
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
        {progress = 0.4, text = "Checking game support..."},
        {progress = 0.6, text = "Loading script..."},
        {progress = 0.8, text = "Preparing interface..."},
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
        Size = UDim2.new(0, 600, 0, 400),
        Position = UDim2.new(0.5, -300, 0.5, -200),
        BackgroundTransparency = 0
    })
    
    local contentStrokeTween = TweenService:Create(contentStroke, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ), {
        Transparency = 0.2
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
    
    for _, element in pairs({titleLabel, creditsLabel, discordLabel, loadingText, copyButton}) do
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
        Transparency = 0
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

-- Skip loading with spacebar
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Space then
        screenGui:Destroy()
        print("Loading skipped!")
    end
end)

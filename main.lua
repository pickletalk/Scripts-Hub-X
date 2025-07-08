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
    
    -- Check if current game is supported
    for PlaceID, Execute in pairs(Games) do
        if PlaceID == game.PlaceId then
            return true, Execute -- Game is supported, return the script URL
        end
    end
    
    return false, "Sorry but this game doesn't support our script!"
end

-- Function to load the actual script after loading screen
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

-- Configuration
local DISCORD_LINK = "https://discord.gg/bpsNUH5sVb"
local EXIT_DELAY = 2 -- seconds
local AD_TITLE = "Scripts Hub X | Ad"

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- ========================================
-- ADVERTISING GUI
-- ========================================
-- Create ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DiscordAdGui"
screenGui.Parent = playerGui
screenGui.ResetOnSpawn = false

-- Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Name = "AdFrame"
mainFrame.Size = UDim2.new(0, 400, 0, 200)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -100)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Add corner radius
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 10)
corner.Parent = mainFrame

-- Add stroke/border
local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 0, 0)
stroke.Thickness = 2
stroke.Parent = mainFrame

-- Title Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 50)
titleLabel.Position = UDim2.new(0, 0, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = AD_TITLE
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.Parent = mainFrame

-- Copy Discord Link Button
local copyButton = Instance.new("TextButton")
copyButton.Name = "CopyButton"
copyButton.Size = UDim2.new(0, 180, 0, 40)
copyButton.Position = UDim2.new(0, 20, 0, 80)
copyButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
copyButton.BorderSizePixel = 0
copyButton.Text = "Copy Link Discord"
copyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
copyButton.TextScaled = true
copyButton.Font = Enum.Font.SourceSansBold
copyButton.Parent = mainFrame

-- Copy button corner
local copyCorner = Instance.new("UICorner")
copyCorner.CornerRadius = UDim.new(0, 5)
copyCorner.Parent = copyButton

-- Exit Button
local exitButton = Instance.new("TextButton")
exitButton.Name = "ExitButton"
exitButton.Size = UDim2.new(0, 180, 0, 40)
exitButton.Position = UDim2.new(0, 200, 0, 80)
exitButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
exitButton.BorderSizePixel = 0
exitButton.Text = "Warning Delay Exit"
exitButton.TextColor3 = Color3.fromRGB(255, 255, 255)
exitButton.TextScaled = true
exitButton.Font = Enum.Font.SourceSans
exitButton.Parent = mainFrame

-- Exit button corner
local exitCorner = Instance.new("UICorner")
exitCorner.CornerRadius = UDim.new(0, 5)
exitCorner.Parent = exitButton

-- Discord info label
local infoLabel = Instance.new("TextLabel")
infoLabel.Name = "InfoLabel"
infoLabel.Size = UDim2.new(1, -20, 0, 30)
infoLabel.Position = UDim2.new(0, 10, 0, 140)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Join our Discord community!"
infoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
infoLabel.TextScaled = true
infoLabel.Font = Enum.Font.SourceSans
infoLabel.Parent = mainFrame

-- ========================================
-- LOADING SCREEN CODE
-- ========================================

-- Create main GUI
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptsHubXLoading"
screenGui.Parent = playerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

-- Main background frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(25, 15, 15)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Content frame (centered container)
local contentFrame = Instance.new("Frame")
contentFrame.Size = UDim2.new(0, 500, 0, 300)
contentFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
contentFrame.BackgroundColor3 = Color3.fromRGB(30, 20, 20)
contentFrame.BorderSizePixel = 0
contentFrame.Parent = mainFrame

-- Content frame corner radius
local contentFrameCorner = Instance.new("UICorner")
contentFrameCorner.CornerRadius = UDim.new(0, 20)
contentFrameCorner.Parent = contentFrame

-- Content frame border glow
local contentStroke = Instance.new("UIStroke")
contentStroke.Color = Color3.fromRGB(200, 100, 100)
contentStroke.Thickness = 2
contentStroke.Transparency = 0.3
contentStroke.Parent = contentFrame
-- Title label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -40, 0, 60)
titleLabel.Position = UDim2.new(0, 20, 0, 30)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Scripts Hub X | Official"
titleLabel.TextColor3 = Color3.fromRGB(255, 200, 200)
titleLabel.TextScaled = true
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Parent = contentFrame

-- Title glow effect
local titleStroke = Instance.new("UIStroke")
titleStroke.Color = Color3.fromRGB(255, 100, 100)
titleStroke.Thickness = 2
titleStroke.Transparency = 0.5
titleStroke.Parent = titleLabel

-- Credits label
local creditsLabel = Instance.new("TextLabel")
creditsLabel.Size = UDim2.new(1, -40, 0, 25)
creditsLabel.Position = UDim2.new(0, 20, 0, 100)
creditsLabel.BackgroundTransparency = 1
creditsLabel.Text = "Credits to scripts owners"
creditsLabel.TextColor3 = Color3.fromRGB(200, 150, 150)
creditsLabel.TextScaled = true
creditsLabel.Font = Enum.Font.Gotham
creditsLabel.Parent = contentFrame

-- Discord link label
local discordLabel = Instance.new("TextLabel")
discordLabel.Size = UDim2.new(1, -40, 0, 25)
discordLabel.Position = UDim2.new(0, 20, 0, 130)
discordLabel.BackgroundTransparency = 1
discordLabel.Text = "https://discord.gg/bpsNUH5sVb"
discordLabel.TextColor3 = Color3.fromRGB(200, 120, 120)
discordLabel.TextScaled = true
discordLabel.Font = Enum.Font.Gotham
discordLabel.Parent = contentFrame

-- Loading bar background
local loadingBarBg = Instance.new("Frame")
loadingBarBg.Size = UDim2.new(1, -60, 0, 8)
loadingBarBg.Position = UDim2.new(0, 30, 0, 180)
loadingBarBg.BackgroundColor3 = Color3.fromRGB(50, 30, 30)
loadingBarBg.BorderSizePixel = 0
loadingBarBg.Parent = contentFrame

-- Loading bar background corner
local loadingBarBgCorner = Instance.new("UICorner")
loadingBarBgCorner.CornerRadius = UDim.new(0, 15)
loadingBarBgCorner.Parent = loadingBarBg

-- Loading bar fill
local loadingBarFill = Instance.new("Frame")
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.Position = UDim2.new(0, 0, 0, 0)
loadingBarFill.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
loadingBarFill.BorderSizePixel = 0
loadingBarFill.Parent = loadingBarBg

-- Loading bar fill corner
local loadingBarFillCorner = Instance.new("UICorner")
loadingBarFillCorner.CornerRadius = UDim.new(0, 15)
loadingBarFillCorner.Parent = loadingBarFill

-- Loading bar gradient
local loadingBarGradient = Instance.new("UIGradient")
loadingBarGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 100, 100)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 150, 150)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 100))
})
loadingBarGradient.Parent = loadingBarFill

-- Loading text
local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, -40, 0, 30)
loadingText.Position = UDim2.new(0, 20, 0, 220)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading..."
loadingText.TextColor3 = Color3.fromRGB(220, 180, 180)
loadingText.TextScaled = true
loadingText.Font = Enum.Font.Gotham
loadingText.Parent = contentFrame

-- Particles effect
local particlesFrame = Instance.new("Frame")
particlesFrame.Size = UDim2.new(1, 0, 1, 0)
particlesFrame.Position = UDim2.new(0, 0, 0, 0)
particlesFrame.BackgroundTransparency = 1
particlesFrame.Parent = screenGui

-- Create floating particles
local particles = {}
for i = 1, 20 do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
    particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
    particle.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    particle.BorderSizePixel = 0
    particle.BackgroundTransparency = 0.7
    particle.Parent = particlesFrame
    
    local particleCorner = Instance.new("UICorner")
    particleCorner.CornerRadius = UDim.new(1, 0)
    particleCorner.Parent = particle
    
    table.insert(particles, particle)
end

-- ADVERTISING ANIMATION FUNCTTIONS
local function animateIn()
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local tween = TweenService:Create(
        mainFrame,
        TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
        {
            Size = UDim2.new(0, 400, 0, 200),
            Position = UDim2.new(0.5, -200, 0.5, -100)
        }
    )
    tween:Play()
end

-- Copy button functionality
copyButton.MouseButton1Click:Connect(function()
    -- Visual feedback
    copyButton.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    copyButton.Text = "Copied!"
    
    -- Copy to clipboard (if supported)
    if setclipboard then
        setclipboard(DISCORD_LINK)
    end
    
    -- Reset button after 1 second
    wait(1)
    copyButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    copyButton.Text = "Copy Link Discord"
end)

-- Exit button functionality with delay
local exitClicked = false
exitButton.MouseButton1Click:Connect(function()
    if not exitClicked then
        exitClicked = true
        exitButton.Text = "Closing in " .. EXIT_DELAY .. "..."
        exitButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
        
        -- Countdown
        for i = EXIT_DELAY, 1, -1 do
            exitButton.Text = "Closing in " .. i .. "..."
            wait(1)
        end
        
        exitButton.Text = "Closing..."
        screenGui:Destroy()
    end
end)

-- Hover effects
copyButton.MouseEnter:Connect(function()
    copyButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
end)

copyButton.MouseLeave:Connect(function()
    if copyButton.Text == "Copy Link Discord" then
        copyButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    end
end)

exitButton.MouseEnter:Connect(function()
    if not exitClicked then
        exitButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    end
end)

exitButton.MouseLeave:Connect(function()
    if not exitClicked then
        exitButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
end)

-- Make GUI draggable
local dragging = false
local dragStart = nil
local startPos = nil

local function updateInput(input)
    local delta = input.Position - dragStart
    local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    mainFrame.Position = position
end

mainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

mainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
        updateInput(input)
    end
end)

-- Add drag cursor visual feedback
local dragIndicator = Instance.new("TextLabel")
dragIndicator.Name = "DragIndicator"
dragIndicator.Size = UDim2.new(0, 20, 0, 20)
dragIndicator.Position = UDim2.new(1, -25, 0, 5)
dragIndicator.BackgroundTransparency = 1
dragIndicator.Text = "≡"
dragIndicator.TextColor3 = Color3.fromRGB(150, 150, 150)
dragIndicator.TextScaled = true
dragIndicator.Font = Enum.Font.SourceSansBold
dragIndicator.Parent = mainFrame

-- Animation functions
local function animateParticles()
    for _, particle in pairs(particles) do
        local randomX = math.random() * 2 - 1
        local randomY = math.random() * 2 - 1
        
        local tween = TweenService:Create(particle, TweenInfo.new(
            math.random(3, 8),
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut,
            -1,
            true
        ), {
            Position = UDim2.new(
                particle.Position.X.Scale + randomX * 0.1,
                0,
                particle.Position.Y.Scale + randomY * 0.1,
                0
            ),
            BackgroundTransparency = math.random(0.3, 0.9)
        })
        
        tween:Play()
    end
end

-- Animate loading bar
local function animateLoadingBar()
    local loadingSteps = {
        {progress = 0.2, text = "Initializing..."},
        {progress = 0.4, text = "Finding game script..."},
        {progress = 0.6, text = "Loading script..."},
        {progress = 0.8, text = "Setting up interface..."},
        {progress = 1.0, text = "Almost ready..."}
    }
    
    for i, step in ipairs(loadingSteps) do
        wait(math.random(0.5, 1.5))
        
        -- Update loading text
        loadingText.Text = step.text
        
        -- Animate loading bar
        local barTween = TweenService:Create(loadingBarFill, TweenInfo.new(
            0.8,
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
    -- Start with everything transparent
    titleLabel.TextTransparency = 1
    creditsLabel.TextTransparency = 1
    discordLabel.TextTransparency = 1
    loadingBarBg.BackgroundTransparency = 1
    loadingText.TextTransparency = 1
    mainFrame.BackgroundTransparency = 1
    contentFrame.BackgroundTransparency = 1
    contentStroke.Transparency = 1
    
    
    
    -- Animate content frame with scale effect
    contentFrame.Size = UDim2.new(0, 0, 0, 0)
    contentFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    
    local contentFrameTween = TweenService:Create(contentFrame, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ), {
        Size = UDim2.new(0, 500, 0, 300),
        Position = UDim2.new(0.5, -250, 0.5, -150),
        BackgroundTransparency = 0
    })
    
    local contentStrokeTween = TweenService:Create(contentStroke, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ), {
        Transparency = 0.3
    })
    
    contentFrameTween:Play()
    contentStrokeTween:Play()
    contentFrameTween.Completed:Wait()
    
    -- Animate title
    local titleTween = TweenService:Create(titleLabel, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })
    
    titleTween:Play()
    wait(0.3)
    
    -- Animate credits
    local creditsTween = TweenService:Create(creditsLabel, TweenInfo.new(
        0.6,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })
    
    creditsTween:Play()
    wait(0.2)
    
    -- Animate discord link
    local discordTween = TweenService:Create(discordLabel, TweenInfo.new(
        0.6,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })
    
    discordTween:Play()
    wait(0.3)
    
    -- Animate loading bar background
    local loadingBarBgTween = TweenService:Create(loadingBarBg, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        BackgroundTransparency = 0
    })
    
    loadingBarBgTween:Play()
    
    -- Animate loading text
    local loadingTextTween = TweenService:Create(loadingText, TweenInfo.new(
        0.5,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    ), {
        TextTransparency = 0
    })
    
    loadingTextTween:Play()
    loadingTextTween.Completed:Wait()
end

-- Exit animations
local function playExitAnimations()
    local exitTween = TweenService:Create(mainFrame, TweenInfo.new(
        1,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        BackgroundTransparency = 1
    })
    
    -- Fade out all elements
    for _, element in pairs({titleLabel, creditsLabel, discordLabel, loadingText}) do
        TweenService:Create(element, TweenInfo.new(
            0.8,
            Enum.EasingStyle.Quad,
            Enum.EasingDirection.In
        ), {
            TextTransparency = 1
        }):Play()
    end
    
    TweenService:Create(loadingBarBg, TweenInfo.new(
        0.8,
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.In
    ), {
        BackgroundTransparency = 1
    }):Play()
    
    exitTween:Play()
    exitTween.Completed:Wait()
    
    screenGui:Destroy()
end

-- Title pulsing animation
local function animateTitlePulse()
    local pulseTween = TweenService:Create(titleStroke, TweenInfo.new(
        2,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    ), {
        Transparency = 0.1
    })
    
    pulseTween:Play()
    
    -- Also animate the content frame border
    local borderPulseTween = TweenService:Create(contentStroke, TweenInfo.new(
        3,
        Enum.EasingStyle.Sine,
        Enum.EasingDirection.InOut,
        -1,
        true
    ), {
        Transparency = 0.1
    })
    
    borderPulseTween:Play()
end

-- Main execution
coroutine.wrap(function()
    
    -- Check if the current game is supported
    local isSupported, scriptUrlOrError = checkGameSupport()
    
    if not isSupported then
        -- Game not supported, show error and exit
        print(scriptUrlOrError)
        
        -- Update loading screen to show error
        loadingText.Text = scriptUrlOrError
        loadingText.TextColor3 = Color3.fromRGB(255, 100, 100) -- Red color for error
        
        wait(3) -- Show error for 3 seconds
        playExitAnimations()
        return -- Exit without loading
    end
    
    -- Game is supported, proceed with loading screen
    print("Game supported! Loading Scripts Hub X...")
    
    -- ========================================
    -- LOADING SCREEN EXECUTION
    -- ========================================
    
    animateIn()
    playEntranceAnimations()
    animateParticles()
    animateTitlePulse()
    animateLoadingBar()
    wait(1)
    playExitAnimations()

    -- Load the actual game script
    local scriptLoaded = loadGameScript(scriptUrlOrError)
    
    if scriptLoaded then
        print("Scripts Hub X | Official - Loading Complete!")
        print("Game script loaded successfully!")
    else
        print("Scripts Hub X | Official - Script loading failed!")
    end
end)()

-- Add click to skip functionality
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.Space then
        -- Skip loading animation
        screenGui:Destroy()
        print("Loading skipped!")
    end
end)

-- Steal A Brainrot - Premium UI
-- by PickleTalk

-- Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")
local UserInputService = game:GetService("UserInputService")
local GuiService = game:GetService("GuiService")

-- Player
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configuration
local config = {
    tweenToBase = false,
    floorSteal = false,
    grappleSpeed = false,
    esp = false,
    baseTimeAlert = false
}

-- UI Variables
local mainUI = nil
local currentTab = "Steal Helper"
local notifications = {}
local subUIs = {}

-- Grapple Speed Variables
local grappleLoop = nil
local speedSpoofConnection = nil
local antiRespawnConnection = nil

-- Create Main UI
local function createMainUI()
    -- Main ScreenGui
    mainUI = Instance.new("ScreenGui")
    mainUI.Name = "StealABrainrotUI"
    mainUI.Parent = playerGui
    mainUI.ResetOnSpawn = false
    mainUI.IgnoreGuiInset = true

    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 350, 0, 400)
    mainFrame.Position = UDim2.new(0.5, -175, 0.5, -200)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = mainUI

    -- Main Corner
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = mainFrame

    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame

    -- Title Corner
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar

    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(1, -40, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "Steal A Brainrot"
    titleText.TextColor3 = Color3.fromRGB(100, 200, 255)
    titleText.TextScaled = true
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar

    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 5)
    closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(200, 200, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    closeButton.Parent = titleBar

    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeButton

    -- Tab Bar
    local tabBar = Instance.new("Frame")
    tabBar.Name = "TabBar"
    tabBar.Size = UDim2.new(1, 0, 0, 35)
    tabBar.Position = UDim2.new(0, 0, 0, 40)
    tabBar.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    tabBar.BorderSizePixel = 0
    tabBar.Parent = mainFrame

    -- Tab Corner
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 10)
    tabCorner.Parent = tabBar

    -- Tab Buttons
    local tabs = {"Steal Helper", "Visual", "Credits"}
    local tabButtons = {}
    
    for i, tabName in ipairs(tabs) do
        local tabButton = Instance.new("TextButton")
        tabButton.Name = tabName .. "Tab"
        tabButton.Size = UDim2.new(1/3, 0, 1, 0)
        tabButton.Position = UDim2.new((i-1)/3, 0, 0, 0)
        tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
        tabButton.BackgroundTransparency = 1
        tabButton.Text = tabName
        tabButton.TextColor3 = Color3.fromRGB(150, 150, 170)
        tabButton.TextScaled = true
        tabButton.Font = Enum.Font.Gotham
        tabButton.BorderSizePixel = 0
        tabButton.Parent = tabBar
        
        tabButtons[tabName] = tabButton
        
        -- Tab Selection Indicator
        local indicator = Instance.new("Frame")
        indicator.Name = "Indicator"
        indicator.Size = UDim2.new(0, 0, 0, 3)
        indicator.Position = UDim2.new(0, 0, 1, -3)
        indicator.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        indicator.BorderSizePixel = 0
        indicator.Parent = tabButton
        
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(0, 2)
        indicatorCorner.Parent = indicator
        
        -- Tab Button Animation
        tabButton.MouseEnter:Connect(function()
            if currentTab ~= tabName then
                TweenService:Create(tabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextColor3 = Color3.fromRGB(200, 200, 255)
                }):Play()
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if currentTab ~= tabName then
                TweenService:Create(tabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    TextColor3 = Color3.fromRGB(150, 150, 170)
                }):Play()
            end
        end)
        
        tabButton.MouseButton1Click:Connect(function()
            switchTab(tabName)
        end)
    end
    
    -- Content Container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -20, 1, -85)
    contentContainer.Position = UDim2.new(0, 10, 0, 75)
    contentContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    contentContainer.BorderSizePixel = 0
    contentContainer.Parent = mainFrame

    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 8)
    contentCorner.Parent = contentContainer

    -- Create Tab Contents
    local tabContents = {}
    
    for _, tabName in ipairs(tabs) do
        local tabContent = Instance.new("ScrollingFrame")
        tabContent.Name = tabName .. "Content"
        tabContent.Size = UDim2.new(1, 0, 1, 0)
        tabContent.Position = UDim2.new(0, 0, 0, 0)
        tabContent.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
        tabContent.BorderSizePixel = 0
        tabContent.ScrollBarThickness = 4
        tabContent.ScrollBarImageColor3 = Color3.fromRGB(50, 50, 70)
        tabContent.Visible = (tabName == currentTab)
        tabContent.Parent = contentContainer
        
        local contentLayout = Instance.new("UIListLayout")
        contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
        contentLayout.Padding = UDim.new(0, 10)
        contentLayout.Parent = tabContent
        
        tabContents[tabName] = tabContent
    end
    
    -- Setup Tab Contents
    setupStealHelperTab(tabContents["Steal Helper"])
    setupVisualTab(tabContents["Visual"])
    setupCreditsTab(tabContents["Credits"])
    
    -- Make UI Draggable
    makeDraggable(mainFrame, titleBar)
    
    -- Close Button Functionality
    closeButton.MouseButton1Click:Connect(function()
        showCloseConfirmation()
    end)
    
    -- Load Configuration
    loadConfiguration()
    
    -- Set Initial Tab
    switchTab(currentTab)
    
    return mainUI
end

-- Make Element Draggable
local function makeDraggable(element, handle)
    local dragging = false
    local dragStart = nil
    local startPos = nil

    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = element.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    handle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                local delta = input.Position - dragStart
                element.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
end

-- Switch Tab
local function switchTab(tabName)
    currentTab = tabName
    
    -- Update Tab Buttons
    for _, tabContent in pairs(mainUI.MainFrame.ContentContainer:GetChildren()) do
        if tabContent:IsA("ScrollingFrame") then
            tabContent.Visible = (tabContent.Name == tabName .. "Content")
        end
    end
    
    -- Update Tab Indicators
    for _, tabButton in pairs(mainUI.MainFrame.TabBar:GetChildren()) do
        if tabButton:IsA("TextButton") then
            local indicator = tabButton:FindFirstChild("Indicator")
            if indicator then
                if tabButton.Name == tabName .. "Tab" then
                    TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                        Size = UDim2.new(1, 0, 0, 3)
                    }):Play()
                    TweenService:Create(tabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextColor3 = Color3.fromRGB(100, 200, 255)
                    }):Play()
                else
                    TweenService:Create(indicator, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(0, 0, 0, 3)
                    }):Play()
                    TweenService:Create(tabButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        TextColor3 = Color3.fromRGB(150, 150, 170)
                    }):Play()
                end
            end
        end
    end
end

-- Setup Steal Helper Tab
local function setupStealHelperTab(parent)
    -- Section: Steal Helper
    local section = createSection(parent, "Steal Helper", 10)
    
    -- Tween To Base Toggle
    local tweenToggle = createToggle(section, "Tween To Base", config.tweenToBase, function(state)
        config.tweenToBase = state
        saveConfiguration()
        
        if state then
            createTweenToBaseUI()
        else
            closeSubUI("TweenToBase")
        end
    end)
    
    -- Floor Steal / Float Toggle
    local floorToggle = createToggle(section, "Floor Steal / Float", config.floorSteal, function(state)
        config.floorSteal = state
        saveConfiguration()
        
        if state then
            createFloorStealUI()
        else
            closeSubUI("FloorSteal")
        end
    end)
    
    -- Grapple Speed Toggle
    local grappleToggle = createToggle(section, "Grapple Speed", config.grappleSpeed, function(state)
        config.grappleSpeed = state
        saveConfiguration()
        
        if state then
            createGrappleSpeedUI()
            enableGrappleSpeed()
        else
            closeSubUI("GrappleSpeed")
            disableGrappleSpeed()
        end
    end)
end

-- Setup Visual Tab
local function setupVisualTab(parent)
    -- Section: Visual
    local section = createSection(parent, "Visual", 10)
    
    -- ESP Toggle
    local espToggle = createToggle(section, "ESP", config.esp, function(state)
        config.esp = state
        saveConfiguration()
        
        if state then
            enableESP()
        else
            disableESP()
        end
    end)
    
    -- Base Time Alert Toggle
    local alertToggle = createToggle(section, "Base Time Alert", config.baseTimeAlert, function(state)
        config.baseTimeAlert = state
        saveConfiguration()
        
        if state then
            enableBaseTimeAlert()
        else
            disableBaseTimeAlert()
        end
    end)
end

-- Setup Credits Tab
local function setupCreditsTab(parent)
    -- Section: Credits
    local section = createSection(parent, "Credits", 10)
    
    -- Credits Text
    local creditsText = Instance.new("TextLabel")
    creditsText.Name = "CreditsText"
    creditsText.Size = UDim2.new(1, -20, 0, 50)
    creditsText.Position = UDim2.new(0, 10, 0, 10)
    creditsText.BackgroundTransparency = 1
    creditsText.Text = "Scripts Hub X | Official\nUI made by PickleTalk"
    creditsText.TextColor3 = Color3.fromRGB(180, 180, 200)
    creditsText.TextScaled = true
    creditsText.Font = Enum.Font.Gotham
    creditsText.TextWrapped = true
    creditsText.Parent = section
    
    -- Discord Button
    local discordButton = Instance.new("TextButton")
    discordButton.Name = "DiscordButton"
    discordButton.Size = UDim2.new(1, -20, 0, 40)
    discordButton.Position = UDim2.new(0, 10, 0, 70)
    discordButton.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    discordButton.Text = "Join Discord"
    discordButton.TextColor3 = Color3.fromRGB(200, 200, 255)
    discordButton.TextScaled = true
    discordButton.Font = Enum.Font.GothamBold
    discordButton.BorderSizePixel = 0
    discordButton.Parent = section
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = discordButton
    
    -- Button Animation
    discordButton.MouseEnter:Connect(function()
        TweenService:Create(discordButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(60, 60, 100)
        }):Play()
    end)
    
    discordButton.MouseLeave:Connect(function()
        TweenService:Create(discordButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        }):Play()
    end)
    
    discordButton.MouseButton1Click:Connect(function()
        -- Copy Discord invite to clipboard
        local invite = "https://discord.gg/bpsNUH5sVb"
        setclipboard(invite)
        showNotification("Discord invite copied to clipboard!")
    end)
end

-- Create Section
local function createSection(parent, title, position)
    local section = Instance.new("Frame")
    section.Name = title .. "Section"
    section.Size = UDim2.new(1, -20, 0, 50)
    section.Position = UDim2.new(0, 10, 0, position)
    section.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    section.BorderSizePixel = 0
    section.Parent = parent
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 8)
    sectionCorner.Parent = section
    
    -- Section Title
    local sectionTitle = Instance.new("TextLabel")
    sectionTitle.Name = "SectionTitle"
    sectionTitle.Size = UDim2.new(1, -10, 0, 25)
    sectionTitle.Position = UDim2.new(0, 5, 0, 5)
    sectionTitle.BackgroundTransparency = 1
    sectionTitle.Text = title
    sectionTitle.TextColor3 = Color3.fromRGB(100, 200, 255)
    sectionTitle.TextScaled = true
    sectionTitle.Font = Enum.Font.GothamBold
    sectionTitle.TextXAlignment = Enum.TextXAlignment.Left
    sectionTitle.Parent = section
    
    -- Content Container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -10, 0, 20)
    contentContainer.Position = UDim2.new(0, 5, 0, 30)
    contentContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    contentContainer.BorderSizePixel = 0
    contentContainer.Parent = section
    
    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 5)
    contentCorner.Parent = contentContainer
    
    return contentContainer
end

-- Create Toggle
local function createToggle(parent, title, initialState, callback)
    local toggle = Instance.new("Frame")
    toggle.Name = title .. "Toggle"
    toggle.Size = UDim2.new(1, 0, 0, 30)
    toggle.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    toggle.BorderSizePixel = 0
    toggle.Parent = parent
    
    -- Toggle Background
    local toggleBg = Instance.new("Frame")
    toggleBg.Name = "ToggleBg"
    toggleBg.Size = UDim2.new(0, 50, 0, 25)
    toggleBg.Position = UDim2.new(1, -55, 0.5, -12.5)
    toggleBg.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    toggleBg.BorderSizePixel = 0
    toggleBg.Parent = toggle
    
    local toggleBgCorner = Instance.new("UICorner")
    toggleBgCorner.CornerRadius = UDim.new(0, 12.5)
    toggleBgCorner.Parent = toggleBg
    
    -- Toggle Slider
    local toggleSlider = Instance.new("Frame")
    toggleSlider.Name = "ToggleSlider"
    toggleSlider.Size = UDim2.new(0, 20, 0, 20)
    toggleSlider.Position = UDim2.new(0, 2.5, 0.5, -10)
    toggleSlider.BackgroundColor3 = Color3.fromRGB(200, 200, 220)
    toggleSlider.BorderSizePixel = 0
    toggleSlider.Parent = toggleBg
    
    local sliderCorner = Instance.new("UICorner")
    sliderCorner.CornerRadius = UDim.new(0, 10)
    sliderCorner.Parent = toggleSlider
    
    -- Toggle Label
    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Name = "ToggleLabel"
    toggleLabel.Size = UDim2.new(1, -65, 1, 0)
    toggleLabel.Position = UDim2.new(0, 5, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.Text = title
    toggleLabel.TextColor3 = Color3.fromRGB(200, 200, 220)
    toggleLabel.TextScaled = true
    toggleLabel.Font = Enum.Font.Gotham
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggle
    
    -- Set Initial State
    if initialState then
        toggleSlider.Position = UDim2.new(1, -22.5, 0.5, -10)
        toggleBg.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    end
    
    -- Toggle Functionality
    local isOn = initialState
    
    toggle.MouseButton1Click:Connect(function()
        isOn = not isOn
        callback(isOn)
        
        if isOn then
            TweenService:Create(toggleSlider, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(1, -22.5, 0.5, -10)
            }):Play()
            TweenService:Create(toggleBg, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(0, 162, 255)
            }):Play()
        else
            TweenService:Create(toggleSlider, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 2.5, 0.5, -10)
            }):Play()
            TweenService:Create(toggleBg, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundColor3 = Color3.fromRGB(50, 50, 70)
            }):Play()
        end
    end)
    
    return toggle
end

-- Create Button
local function createButton(parent, title, callback)
    local button = Instance.new("TextButton")
    button.Name = title .. "Button"
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Position = UDim2.new(0, 5, 0, 5)
    button.BackgroundColor3 = Color3.fromRGB(40, 40, 60)
    button.Text = title
    button.TextColor3 = Color3.fromRGB(200, 200, 255)
    button.TextScaled = true
    button.Font = Enum.Font.GothamBold
    button.BorderSizePixel = 0
    button.Parent = parent
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    -- Button Animation
    button.MouseEnter:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(60, 60, 100)
        }):Play()
    end)
    
    button.MouseLeave:Connect(function()
        TweenService:Create(button, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(40, 40, 60)
        }):Play()
    end)
    
    button.MouseButton1Click:Connect(function()
        callback()
        
        -- Click Animation
        local originalSize = button.Size
        TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, -20, 0, 25)
        }):Play()
        
        task.wait(0.1)
        
        TweenService:Create(button, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = originalSize
        }):Play()
    end)
    
    return button
end

-- Create Sub UI
local function createSubUI(name, title, size)
    -- Check if already exists
    if subUIs[name] then
        return subUIs[name]
    end
    
    -- Create ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = name .. "UI"
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false
    screenGui.IgnoreGuiInset = true
    
    -- Main Frame
    local frame = Instance.new("Frame")
    frame.Name = "SubFrame"
    frame.Size = size
    frame.Position = UDim2.new(0.5, -size.X.Offset/2, 0.5, -size.Y.Offset/2)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    -- Main Corner
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = frame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = frame
    
    -- Title Corner
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar
    
    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "TitleText"
    titleText.Size = UDim2.new(1, -40, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = title
    titleText.TextColor3 = Color3.fromRGB(100, 200, 255)
    titleText.TextScaled = true
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -30, 0, 2.5)
    closeButton.BackgroundColor3 = Color3.fromRGB(40, 40, 50)
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(200, 200, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeButton
    
    -- Content Container
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, -10, 1, -40)
    contentContainer.Position = UDim2.new(0, 5, 0, 35)
    contentContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    contentContainer.BorderSizePixel = 0
    contentContainer.Parent = frame

    local contentCorner = Instance.new("UICorner")
    contentCorner.CornerRadius = UDim.new(0, 8)
    contentCorner.Parent = contentContainer
    
    -- Make Draggable
    makeDraggable(frame, titleBar)
    
    -- Close Button Functionality
    closeButton.MouseButton1Click:Connect(function()
        closeSubUI(name)
    end)
    
    -- Store Reference
    subUIs[name] = {
        screenGui = screenGui,
        frame = frame,
        contentContainer = contentContainer
    }
    
    return subUIs[name]
end

-- Close Sub UI
local function closeSubUI(name)
    if subUIs[name] then
        subUIs[name].screenGui:Destroy()
        subUIs[name] = nil
    end
end

-- Create Tween To Base UI
local function createTweenToBaseUI()
    local subUI = createSubUI("TweenToBase", "Tween To Base", UDim2.new(0, 250, 0, 150))
    
    -- Description
    local description = Instance.new("TextLabel")
    description.Name = "Description"
    description.Size = UDim2.new(1, -10, 0, 40)
    description.Position = UDim2.new(0, 5, 0, 5)
    description.BackgroundTransparency = 1
    description.Text = "Quickly teleport to your base"
    description.TextColor3 = Color3.fromRGB(180, 180, 200)
    description.TextScaled = true
    description.Font = Enum.Font.Gotham
    description.TextWrapped = true
    description.Parent = subUI.contentContainer
    
    -- Start Button
    local startButton = createButton(subUI.contentContainer, "Start Tweening", function()
        -- Implement tween to base functionality here
        showNotification("Tweening to base...")
    end)
    
    startButton.Position = UDim2.new(0, 5, 0, 55)
end

-- Create Floor Steal UI
local function createFloorStealUI()
    local subUI = createSubUI("FloorSteal", "Floor Steal / Float", UDim2.new(0, 250, 0, 150))
    
    -- Description
    local description = Instance.new("TextLabel")
    description.Name = "Description"
    description.Size = UDim2.new(1, -10, 0, 40)
    description.Position = UDim2.new(0, 5, 0, 5)
    description.BackgroundTransparency = 1
    description.Text = "Enable floor steal and float mode"
    description.TextColor3 = Color3.fromRGB(180, 180, 200)
    description.TextScaled = true
    description.Font = Enum.Font.Gotham
    description.TextWrapped = true
    description.Parent = subUI.contentContainer
    
    -- Enable Button
    local enableButton = createButton(subUI.contentContainer, "Enable", function()
        -- Implement floor steal functionality here
        showNotification("Floor steal enabled")
    end)
    
    enableButton.Position = UDim2.new(0, 5, 0, 55)
end

-- Create Grapple Speed UI
local function createGrappleSpeedUI()
    local subUI = createSubUI("GrappleSpeed", "Grapple Speed", UDim2.new(0, 200, 0, 100))
    
    -- Description
    local description = Instance.new("TextLabel")
    description.Name = "Description"
    description.Size = UDim2.new(1, -10, 0, 30)
    description.Position = UDim2.new(0, 5, 0, 5)
    description.BackgroundTransparency = 1
    description.Text = "Click to toggle grapple loop"
    description.TextColor3 = Color3.fromRGB(180, 180, 200)
    description.TextScaled = true
    description.Font = Enum.Font.Gotham
    description.TextWrapped = true
    description.Parent = subUI.contentContainer
    
    -- Toggle Button
    local toggleButton = createButton(subUI.contentContainer, "Toggle Grapple", function()
        -- Toggle grapple loop
        if grappleLoop then
            grappleLoop:Disconnect()
            grappleLoop = nil
            showNotification("Grapple loop stopped")
        else
            grappleLoop = RunService.Heartbeat:Connect(function()
                -- Implement equipAndFireGrapple here
                -- equipAndFireGrapple()
            end)
            showNotification("Grapple loop started")
        end
    end)
    
    toggleButton.Position = UDim2.new(0, 5, 0, 40)
end

-- Enable Grapple Speed
local function enableGrappleSpeed()
    -- Set player speed
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = 100
    end
    
    -- Spoof speed
    if not speedSpoofConnection then
        speedSpoofConnection = hookmetamethod(game, "__index", newcclosure(function(self, property)
            if self and (self.ClassName == "Humanoid" or self:IsA("Humanoid")) and property == "WalkSpeed" then
                return 34.000999450683594
            end
            return oldIndex(self, property)
        end))
    end
    
    -- Anti respawn
    if not antiRespawnConnection then
        antiRespawnConnection = player.CharacterAdded:Connect(function(character)
            character:WaitForChild("Humanoid").Died:Connect(function()
                -- Prevent respawn
                player.CharacterAdded:Wait()
                showNotification("Respawn prevented")
            end)
        end)
    end
end

-- Disable Grapple Speed
local function disableGrappleSpeed()
    -- Reset player speed
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.WalkSpeed = 16
    end
    
    -- Stop grapple loop
    if grappleLoop then
        grappleLoop:Disconnect()
        grappleLoop = nil
    end
    
    -- Remove speed spoof
    if speedSpoofConnection then
        speedSpoofConnection:Disconnect()
        speedSpoofConnection = nil
    end
    
    -- Remove anti respawn
    if antiRespawnConnection then
        antiRespawnConnection:Disconnect()
        antiRespawnConnection = nil
    end
end

-- Enable ESP
local function enableESP()
    -- Implement ESP functionality here
    showNotification("ESP enabled")
end

-- Disable ESP
local function disableESP()
    -- Disable ESP functionality here
    showNotification("ESP disabled")
end

-- Enable Base Time Alert
local function enableBaseTimeAlert()
    -- Implement base time alert functionality here
    showNotification("Base time alert enabled")
end

-- Disable Base Time Alert
local function disableBaseTimeAlert()
    -- Disable base time alert functionality here
    showNotification("Base time alert disabled")
end

-- Show Notification
local function showNotification(message)
    -- Create notification
    local notification = Instance.new("Frame")
    notification.Name = "Notification"
    notification.Size = UDim2.new(0, 250, 0, 50)
    notification.Position = UDim2.new(1, -260, 1, -60)
    notification.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
    notification.BorderSizePixel = 0
    notification.Parent = playerGui
    
    local notificationCorner = Instance.new("UICorner")
    notificationCorner.CornerRadius = UDim.new(0, 8)
    notificationCorner.Parent = notification
    
    -- Notification Text
    local notificationText = Instance.new("TextLabel")
    notificationText.Name = "NotificationText"
    notificationText.Size = UDim2.new(1, -10, 1, 0)
    notificationText.Position = UDim2.new(0, 5, 0, 0)
    notificationText.BackgroundTransparency = 1
    notificationText.Text = message
    notificationText.TextColor3 = Color3.fromRGB(100, 200, 255)
    notificationText.TextScaled = true
    notificationText.Font = Enum.Font.Gotham
    notificationText.TextWrapped = true
    notificationText.Parent = notification
    
    -- Neon Accent
    local accent = Instance.new("Frame")
    accent.Name = "Accent"
    accent.Size = UDim2.new(0, 3, 1, 0)
    accent.Position = UDim2.new(0, 0, 0, 0)
    accent.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
    accent.BorderSizePixel = 0
    accent.Parent = notification
    
    -- Animate In
    TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -260, 1, -60)
    }):Play()
    
    -- Auto Remove
    task.spawn(function()
        task.wait(3)
        
        -- Animate Out
        TweenService:Create(notification, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Position = UDim2.new(1, 10, 1, -60),
            BackgroundTransparency = 1
        }):Play()
        
        task.wait(0.3)
        notification:Destroy()
    end)
end

-- Show Close Confirmation
local function showCloseConfirmation()
    -- Create confirmation dialog
    local confirmation = Instance.new("Frame")
    confirmation.Name = "CloseConfirmation"
    confirmation.Size = UDim2.new(0, 300, 0, 150)
    confirmation.Position = UDim2.new(0.5, -150, 0.5, -75)
    confirmation.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    confirmation.BorderSizePixel = 0
    confirmation.Parent = playerGui
    
    local confirmationCorner = Instance.new("UICorner")
    confirmationCorner.CornerRadius = UDim.new(0, 10)
    confirmationCorner.Parent = confirmation
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, 0, 0, 40)
    title.Position = UDim2.new(0, 0, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "Close UI?"
    title.TextColor3 = Color3.fromRGB(100, 200, 255)
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = confirmation
    
    -- Message
    local message = Instance.new("TextLabel")
    message.Name = "Message"
    message.Size = UDim2.new(1, -20, 0, 40)
    message.Position = UDim2.new(0, 10, 0, 50)
    message.BackgroundTransparency = 1
    message.Text = "Are you sure you want to close the UI?"
    message.TextColor3 = Color3.fromRGB(180, 180, 200)
    message.TextScaled = true
    message.Font = Enum.Font.Gotham
    message.TextWrapped = true
    message.Parent = confirmation
    
    -- Buttons Container
    local buttonsContainer = Instance.new("Frame")
    buttonsContainer.Name = "ButtonsContainer"
    buttonsContainer.Size = UDim2.new(1, -20, 0, 40)
    buttonsContainer.Position = UDim2.new(0, 10, 0, 100)
    buttonsContainer.BackgroundTransparency = 1
    buttonsContainer.Parent = confirmation
    
    -- Yes Button
    local yesButton = Instance.new("TextButton")
    yesButton.Name = "YesButton"
    yesButton.Size = UDim2.new(0, 130, 0, 35)
    yesButton.Position = UDim2.new(0, 0, 0, 0)
    yesButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    yesButton.Text = "Yes"
    yesButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    yesButton.TextScaled = true
    yesButton.Font = Enum.Font.GothamBold
    yesButton.BorderSizePixel = 0
    yesButton.Parent = buttonsContainer
    
    local yesCorner = Instance.new("UICorner")
    yesCorner.CornerRadius = UDim.new(0, 6)
    yesCorner.Parent = yesButton
    
    -- No Button
    local noButton = Instance.new("TextButton")
    noButton.Name = "NoButton"
    noButton.Size = UDim2.new(0, 130, 0, 35)
    noButton.Position = UDim2.new(1, -130, 0, 0)
    noButton.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
    noButton.Text = "No"
    noButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    noButton.TextScaled = true
    noButton.Font = Enum.Font.GothamBold
    noButton.BorderSizePixel = 0
    noButton.Parent = buttonsContainer
    
    local noCorner = Instance.new("UICorner")
    noCorner.CornerRadius = UDim.new(0, 6)
    noCorner.Parent = noButton
    
    -- Button Animations
    yesButton.MouseEnter:Connect(function()
        TweenService:Create(yesButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(220, 70, 70)
        }):Play()
    end)
    
    yesButton.MouseLeave:Connect(function()
        TweenService:Create(yesButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        }):Play()
    end)
    
    noButton.MouseEnter:Connect(function()
        TweenService:Create(noButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(70, 70, 100)
        }):Play()
    end)
    
    noButton.MouseLeave:Connect(function()
        TweenService:Create(noButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundColor3 = Color3.fromRGB(50, 50, 70)
        }):Play()
    end)
    
    -- Button Functionality
    yesButton.MouseButton1Click:Connect(function()
        -- Close all sub UIs
        for name, _ in pairs(subUIs) do
            closeSubUI(name)
        end
        
        -- Disable all features
        if config.tweenToBase then closeSubUI("TweenToBase") end
        if config.floorSteal then closeSubUI("FloorSteal") end
        if config.grappleSpeed then 
            closeSubUI("GrappleSpeed")
            disableGrappleSpeed()
        end
        if config.esp then disableESP() end
        if config.baseTimeAlert then disableBaseTimeAlert() end
        
        -- Close main UI
        mainUI:Destroy()
        
        -- Destroy confirmation
        confirmation:Destroy()
    end)
    
    noButton.MouseButton1Click:Connect(function()
        confirmation:Destroy()
    end)
    
    -- Animate In
    confirmation.BackgroundTransparency = 1
    TweenService:Create(confirmation, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0
    }):Play()
end

-- Save Configuration
local function saveConfiguration()
    -- Convert config to JSON
    local configJson = HttpService:JSONEncode(config)
    
    -- Save to file
    writefile("StealABrainrotConfig.json", configJson)
end

-- Load Configuration
local function loadConfiguration()
    -- Check if file exists
    if isfile("StealABrainrotConfig.json") then
        -- Read file
        local configJson = readfile("StealABrainrotConfig.json")
        
        -- Decode JSON
        local success, loadedConfig = pcall(function()
            return HttpService:JSONDecode(configJson)
        end)
        
        if success then
            -- Update config
            for key, value in pairs(loadedConfig) do
                config[key] = value
            end
            
            -- Apply loaded configuration
            if config.tweenToBase then createTweenToBaseUI() end
            if config.floorSteal then createFloorStealUI() end
            if config.grappleSpeed then 
                createGrappleSpeedUI()
                enableGrappleSpeed()
            end
            if config.esp then enableESP() end
            if config.baseTimeAlert then enableBaseTimeAlert() end
        end
    end
end

-- Initialize UI
createMainUI()
showNotification("Steal A Brainrot loaded successfully!")

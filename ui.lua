-- PickleLibrary - Scripts Hub X | Official UI Library
-- Made by PickleTalk

local PickleLibrary = {}
PickleLibrary.__index = PickleLibrary

-- Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

-- Variables
local player = Players.LocalPlayer
local screenGui

-- Utility Functions
local function createTween(object, properties, duration, easingStyle, easingDirection)
    local tweenInfo = TweenInfo.new(
        duration or 0.3,
        easingStyle or Enum.EasingStyle.Quad,
        easingDirection or Enum.EasingDirection.Out
    )
    return TweenService:Create(object, tweenInfo, properties)
end

local function createNeonGlow(object, color)
    local glow = Instance.new("ImageLabel")
    glow.Name = "NeonGlow"
    glow.BackgroundTransparency = 1
    glow.Image = "rbxassetid://5028857084"
    glow.ImageColor3 = color or Color3.fromRGB(0, 162, 255)
    glow.ImageTransparency = 0.5
    glow.Size = UDim2.new(1, 20, 1, 20)
    glow.Position = UDim2.new(0, -10, 0, -10)
    glow.ZIndex = object.ZIndex - 1
    glow.Parent = object.Parent
    
    return glow
end

local function animateNeonBorder(frame)
    local border = Instance.new("Frame")
    border.Name = "AnimatedBorder"
    border.Size = UDim2.new(1, 4, 1, 4)
    border.Position = UDim2.new(0, -2, 0, -2)
    border.BackgroundTransparency = 1
    border.ZIndex = frame.ZIndex + 1
    border.Parent = frame.Parent
    
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 162, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 162, 255))
    })
    gradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(0.5, 0.2),
        NumberSequenceKeypoint.new(1, 0.8)
    })
    gradient.Rotation = 0
    gradient.Parent = border
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(0, 162, 255)
    stroke.Transparency = 0.3
    stroke.Parent = border
    
    -- Animate the gradient rotation
    spawn(function()
        while border.Parent do
            createTween(gradient, {Rotation = 360}, 2, Enum.EasingStyle.Linear):Play()
            wait(2)
            gradient.Rotation = 0
        end
    end)
    
    return border
end

-- Main Library Functions
function PickleLibrary:CreateWindow(config)
    config = config or {}
    local windowTitle = config.Title or "Scripts Hub X | Official"
    local subtitle = config.Subtitle or "Made by PickleTalk"
    
    -- Create ScreenGui
    if screenGui then
        screenGui:Destroy()
    end
    
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "PickleLibraryGUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    if gethui then
        screenGui.Parent = gethui()
    elseif syn and syn.protect_gui then
        syn.protect_gui(screenGui)
        screenGui.Parent = CoreGui
    else
        screenGui.Parent = CoreGui
    end
    
    -- Main Frame
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 1000, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -500, 0.5, -300)
    mainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.ClipsDescendants = true
    mainFrame.Parent = screenGui
    
    -- Add corner radius
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = mainFrame
    
    -- Add neon glow effect
    createNeonGlow(mainFrame, Color3.fromRGB(0, 162, 255))
    
    -- Add animated border
    animateNeonBorder(mainFrame)
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 50)
    titleBar.Position = UDim2.new(0, 0, 0, 0)
    titleBar.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = titleBar
    
    -- Title Text
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Name = "TitleLabel"
    titleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 15, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = windowTitle
    titleLabel.TextColor3 = Color3.fromRGB(0, 162, 255)
    titleLabel.TextScaled = true
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = titleBar
    
    -- Subtitle
    local subtitleLabel = Instance.new("TextLabel")
    subtitleLabel.Name = "SubtitleLabel"
    subtitleLabel.Size = UDim2.new(0.3, -15, 0, 20)
    subtitleLabel.Position = UDim2.new(0.7, 0, 0.5, -10)
    subtitleLabel.BackgroundTransparency = 1
    subtitleLabel.Text = subtitle
    subtitleLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
    subtitleLabel.TextSize = 12
    subtitleLabel.TextXAlignment = Enum.TextXAlignment.Right
    subtitleLabel.Font = Enum.Font.Gotham
    subtitleLabel.Parent = titleBar
    
    -- Close Button
    local closeButton = Instance.new("TextButton")
    closeButton.Name = "CloseButton"
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -40, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(255, 85, 85)
    closeButton.BorderSizePixel = 0
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeButton
    
    -- Minimize Button
    local minimizeButton = Instance.new("TextButton")
    minimizeButton.Name = "MinimizeButton"
    minimizeButton.Size = UDim2.new(0, 30, 0, 30)
    minimizeButton.Position = UDim2.new(1, -75, 0, 10)
    minimizeButton.BackgroundColor3 = Color3.fromRGB(85, 170, 255)
    minimizeButton.BorderSizePixel = 0
    minimizeButton.Text = "—"
    minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeButton.TextScaled = true
    minimizeButton.Font = Enum.Font.GothamBold
    minimizeButton.Parent = titleBar
    
    local minimizeCorner = Instance.new("UICorner")
    minimizeCorner.CornerRadius = UDim.new(0, 6)
    minimizeCorner.Parent = minimizeButton
    
    -- Content Frame
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, 0, 1, -50)
    contentFrame.Position = UDim2.new(0, 0, 0, 50)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Parent = mainFrame
    
    -- Sidebar
    local sidebar = Instance.new("Frame")
    sidebar.Name = "Sidebar"
    sidebar.Size = UDim2.new(0, 200, 1, 0)
    sidebar.Position = UDim2.new(0, 0, 0, 0)
    sidebar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    sidebar.BorderSizePixel = 0
    sidebar.Parent = contentFrame
    
    -- Main Content Area
    local mainContent = Instance.new("Frame")
    mainContent.Name = "MainContent"
    mainContent.Size = UDim2.new(1, -200, 1, 0)
    mainContent.Position = UDim2.new(0, 200, 0, 0)
    mainContent.BackgroundTransparency = 1
    mainContent.Parent = contentFrame
    
    -- Scrolling Frame for Tabs
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Name = "TabContainer"
    scrollFrame.Size = UDim2.new(1, -20, 1, -20)
    scrollFrame.Position = UDim2.new(0, 10, 0, 10)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 6
    scrollFrame.ScrollBarImageColor3 = Color3.fromRGB(0, 162, 255)
    scrollFrame.BorderSizePixel = 0
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollFrame.Parent = mainContent
    
    local tabLayout = Instance.new("UIListLayout")
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    tabLayout.Padding = UDim.new(0, 10)
    tabLayout.Parent = scrollFrame
    
    -- Window object
    local window = {
        GUI = screenGui,
        MainFrame = mainFrame,
        Sidebar = sidebar,
        TabContainer = scrollFrame,
        Sections = {},
        CurrentSection = nil,
        IsMinimized = false
    }
    
    -- Make window draggable
    local dragging = false
    local dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(
                startPos.X.Scale,
                startPos.X.Offset + delta.X,
                startPos.Y.Scale,
                startPos.Y.Offset + delta.Y
            )
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    -- Close button functionality
    closeButton.MouseButton1Click:Connect(function()
        createTween(mainFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.3):Play()
        wait(0.3)
        screenGui:Destroy()
    end)
    
    -- Minimize button functionality
    minimizeButton.MouseButton1Click:Connect(function()
        window.IsMinimized = not window.IsMinimized
        local targetSize = window.IsMinimized and UDim2.new(0, 1000, 0, 50) or UDim2.new(0, 1000, 0, 600)
        createTween(mainFrame, {Size = targetSize}, 0.3):Play()
        contentFrame.Visible = not window.IsMinimized
    end)
    
    -- Toggle key (Right Ctrl)
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.RightControl then
            screenGui.Enabled = not screenGui.Enabled
        end
    end)
    
    setmetatable(window, PickleLibrary)
    return window
end

function PickleLibrary:CreateSection(name)
    local section = {
        Name = name,
        Button = nil,
        Tabs = {},
        CurrentTab = nil,
        IsActive = false
    }
    
    -- Create section button in sidebar
    local sectionButton = Instance.new("TextButton")
    sectionButton.Name = name .. "Button"
    sectionButton.Size = UDim2.new(1, -10, 0, 40)
    sectionButton.Position = UDim2.new(0, 5, 0, 5 + (#self.Sections * 45))
    sectionButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    sectionButton.BorderSizePixel = 0
    sectionButton.Text = name
    sectionButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    sectionButton.TextScaled = true
    sectionButton.Font = Enum.Font.Gotham
    sectionButton.Parent = self.Sidebar
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 6)
    sectionCorner.Parent = sectionButton
    
    section.Button = sectionButton
    
    -- Section click functionality
    sectionButton.MouseButton1Click:Connect(function()
        self:SetActiveSection(section)
    end)
    
    -- Hover effects
    sectionButton.MouseEnter:Connect(function()
        if not section.IsActive then
            createTween(sectionButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.2):Play()
        end
    end)
    
    sectionButton.MouseLeave:Connect(function()
        if not section.IsActive then
            createTween(sectionButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2):Play()
        end
    end)
    
    table.insert(self.Sections, section)
    
    -- Set as active if it's the first section
    if #self.Sections == 1 then
        self:SetActiveSection(section)
    end
    
    return section
end

function PickleLibrary:SetActiveSection(section)
    -- Deactivate current section
    if self.CurrentSection then
        self.CurrentSection.IsActive = false
        createTween(self.CurrentSection.Button, {
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            TextColor3 = Color3.fromRGB(200, 200, 200)
        }, 0.2):Play()
    end
    
    -- Activate new section
    self.CurrentSection = section
    section.IsActive = true
    createTween(section.Button, {
        BackgroundColor3 = Color3.fromRGB(0, 162, 255),
        TextColor3 = Color3.fromRGB(255, 255, 255)
    }, 0.2):Play()
    
    -- Clear and show tabs for this section
    self:ShowSectionTabs(section)
end

function PickleLibrary:ShowSectionTabs(section)
    -- Clear current tabs display
    for _, child in pairs(self.TabContainer:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end
    
    -- Add tabs for this section
    for i, tab in ipairs(section.Tabs) do
        self:DisplayTab(tab, i)
    end
    
    self:UpdateCanvasSize()
end

function PickleLibrary:DisplayTab(tab, index)
    local tabFrame = Instance.new("Frame")
    tabFrame.Name = tab.Name .. "Frame"
    tabFrame.Size = UDim2.new(1, -20, 0, 50)
    tabFrame.Position = UDim2.new(0, 0, 0, (index - 1) * 60)
    tabFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    tabFrame.BorderSizePixel = 0
    tabFrame.Parent = self.TabContainer
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 8)
    tabCorner.Parent = tabFrame
    
    -- Tab header
    local tabHeader = Instance.new("TextButton")
    tabHeader.Name = "TabHeader"
    tabHeader.Size = UDim2.new(1, 0, 0, 50)
    tabHeader.Position = UDim2.new(0, 0, 0, 0)
    tabHeader.BackgroundTransparency = 1
    tabHeader.Text = tab.Name
    tabHeader.TextColor3 = Color3.fromRGB(0, 162, 255)
    tabHeader.TextSize = 16
    tabHeader.TextXAlignment = Enum.TextXAlignment.Left
    tabHeader.Font = Enum.Font.GothamBold
    tabHeader.Parent = tabFrame
    
    -- Tab icon
    local tabIcon = Instance.new("TextLabel")
    tabIcon.Name = "TabIcon"
    tabIcon.Size = UDim2.new(0, 20, 0, 20)
    tabIcon.Position = UDim2.new(0, 15, 0.5, -10)
    tabIcon.BackgroundTransparency = 1
    tabIcon.Text = tab.Icon or "⚙"
    tabIcon.TextColor3 = Color3.fromRGB(0, 162, 255)
    tabIcon.TextSize = 16
    tabIcon.Font = Enum.Font.GothamBold
    tabIcon.Parent = tabFrame
    
    -- Adjust header position for icon
    tabHeader.Position = UDim2.new(0, 45, 0, 0)
    tabHeader.Size = UDim2.new(1, -45, 0, 50)
    
    -- Content container for tab items
    local contentContainer = Instance.new("Frame")
    contentContainer.Name = "ContentContainer"
    contentContainer.Size = UDim2.new(1, 0, 0, 0)
    contentContainer.Position = UDim2.new(0, 0, 0, 50)
    contentContainer.BackgroundTransparency = 1
    contentContainer.Parent = tabFrame
    contentContainer.Visible = tab.IsExpanded
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.SortOrder = Enum.SortOrder.LayoutOrder
    contentLayout.Padding = UDim.new(0, 5)
    contentLayout.Parent = contentContainer
    
    -- Add all tab items
    local totalHeight = 0
    for _, item in ipairs(tab.Items) do
        local itemHeight = self:CreateTabItem(item, contentContainer)
        totalHeight = totalHeight + itemHeight + 5
    end
    
    contentContainer.Size = UDim2.new(1, 0, 0, totalHeight)
    
    -- Update tab frame size based on content
    local baseHeight = 50
    local expandedHeight = tab.IsExpanded and (baseHeight + totalHeight + 10) or baseHeight
    tabFrame.Size = UDim2.new(1, -20, 0, expandedHeight)
    
    -- Tab click functionality
    tabHeader.MouseButton1Click:Connect(function()
        tab.IsExpanded = not tab.IsExpanded
        contentContainer.Visible = tab.IsExpanded
        
        local newHeight = tab.IsExpanded and (baseHeight + totalHeight + 10) or baseHeight
        createTween(tabFrame, {Size = UDim2.new(1, -20, 0, newHeight)}, 0.3):Play()
        
        wait(0.1)
        self:UpdateCanvasSize()
    end)
    
    -- Store reference to frame in tab
    tab.Frame = tabFrame
end

function PickleLibrary:CreateTabItem(item, parent)
    local itemHeight = 35
    
    if item.Type == "Toggle" then
        local toggleFrame = Instance.new("Frame")
        toggleFrame.Name = item.Name .. "Toggle"
        toggleFrame.Size = UDim2.new(1, -20, 0, itemHeight)
        toggleFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        toggleFrame.BorderSizePixel = 0
        toggleFrame.Parent = parent
        
        local toggleCorner = Instance.new("UICorner")
        toggleCorner.CornerRadius = UDim.new(0, 6)
        toggleCorner.Parent = toggleFrame
        
        local toggleLabel = Instance.new("TextLabel")
        toggleLabel.Name = "Label"
        toggleLabel.Size = UDim2.new(1, -50, 1, 0)
        toggleLabel.Position = UDim2.new(0, 10, 0, 0)
        toggleLabel.BackgroundTransparency = 1
        toggleLabel.Text = item.Name
        toggleLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        toggleLabel.TextSize = 14
        toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
        toggleLabel.Font = Enum.Font.Gotham
        toggleLabel.Parent = toggleFrame
        
        local toggleButton = Instance.new("TextButton")
        toggleButton.Name = "ToggleButton"
        toggleButton.Size = UDim2.new(0, 30, 0, 20)
        toggleButton.Position = UDim2.new(1, -40, 0.5, -10)
        toggleButton.BackgroundColor3 = item.Value and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(100, 100, 100)
        toggleButton.BorderSizePixel = 0
        toggleButton.Text = ""
        toggleButton.Parent = toggleFrame
        
        local toggleButtonCorner = Instance.new("UICorner")
        toggleButtonCorner.CornerRadius = UDim.new(0, 10)
        toggleButtonCorner.Parent = toggleButton
        
        local toggleIndicator = Instance.new("Frame")
        toggleIndicator.Name = "Indicator"
        toggleIndicator.Size = UDim2.new(0, 16, 0, 16)
        toggleIndicator.Position = item.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        toggleIndicator.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        toggleIndicator.BorderSizePixel = 0
        toggleIndicator.Parent = toggleButton
        
        local indicatorCorner = Instance.new("UICorner")
        indicatorCorner.CornerRadius = UDim.new(0, 8)
        indicatorCorner.Parent = toggleIndicator
        
        toggleButton.MouseButton1Click:Connect(function()
            item.Value = not item.Value
            
            createTween(toggleButton, {
                BackgroundColor3 = item.Value and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(100, 100, 100)
            }, 0.2):Play()
            
            createTween(toggleIndicator, {
                Position = item.Value and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
            }, 0.2):Play()
            
            if item.Callback then
                item.Callback(item.Value)
            end
        end)
        
    elseif item.Type == "Button" then
        local buttonFrame = Instance.new("TextButton")
        buttonFrame.Name = item.Name .. "Button"
        buttonFrame.Size = UDim2.new(1, -20, 0, itemHeight)
        buttonFrame.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        buttonFrame.BorderSizePixel = 0
        buttonFrame.Text = item.Name
        buttonFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
        buttonFrame.TextSize = 14
        buttonFrame.Font = Enum.Font.GothamBold
        buttonFrame.Parent = parent
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 6)
        buttonCorner.Parent = buttonFrame
        
        buttonFrame.MouseEnter:Connect(function()
            createTween(buttonFrame, {BackgroundColor3 = Color3.fromRGB(0, 142, 235)}, 0.2):Play()
        end)
        
        buttonFrame.MouseLeave:Connect(function()
            createTween(buttonFrame, {BackgroundColor3 = Color3.fromRGB(0, 162, 255)}, 0.2):Play()
        end)
        
        buttonFrame.MouseButton1Click:Connect(function()
            if item.Callback then
                item.Callback()
            end
        end)
        
    elseif item.Type == "Slider" then
        itemHeight = 50
        
        local sliderFrame = Instance.new("Frame")
        sliderFrame.Name = item.Name .. "Slider"
        sliderFrame.Size = UDim2.new(1, -20, 0, itemHeight)
        sliderFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        sliderFrame.BorderSizePixel = 0
        sliderFrame.Parent = parent
        
        local sliderCorner = Instance.new("UICorner")
        sliderCorner.CornerRadius = UDim.new(0, 6)
        sliderCorner.Parent = sliderFrame
        
        local sliderLabel = Instance.new("TextLabel")
        sliderLabel.Name = "Label"
        sliderLabel.Size = UDim2.new(0.7, 0, 0, 20)
        sliderLabel.Position = UDim2.new(0, 10, 0, 5)
        sliderLabel.BackgroundTransparency = 1
        sliderLabel.Text = item.Name
        sliderLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
        sliderLabel.TextSize = 14
        sliderLabel.TextXAlignment = Enum.TextXAlignment.Left
        sliderLabel.Font = Enum.Font.Gotham
        sliderLabel.Parent = sliderFrame
        
        local sliderValue = Instance.new("TextLabel")
        sliderValue.Name = "Value"
        sliderValue.Size = UDim2.new(0.3, -10, 0, 20)
        sliderValue.Position = UDim2.new(0.7, 0, 0, 5)
        sliderValue.BackgroundTransparency = 1
        sliderValue.Text = tostring(item.Value or item.Min or 0)
        sliderValue.TextColor3 = Color3.fromRGB(0, 162, 255)
        sliderValue.TextSize = 14
        sliderValue.TextXAlignment = Enum.TextXAlignment.Right
        sliderValue.Font = Enum.Font.GothamBold
        sliderValue.Parent = sliderFrame
        
        local sliderTrack = Instance.new("Frame")
        sliderTrack.Name = "Track"
        sliderTrack.Size = UDim2.new(1, -20, 0, 6)
        sliderTrack.Position = UDim2.new(0, 10, 1, -15)
        sliderTrack.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        sliderTrack.BorderSizePixel = 0
        sliderTrack.Parent = sliderFrame
        
        local trackCorner = Instance.new("UICorner")
        trackCorner.CornerRadius = UDim.new(0, 3)
        trackCorner.Parent = sliderTrack
        
        local sliderFill = Instance.new("Frame")
        sliderFill.Name = "Fill"
        sliderFill.Size = UDim2.new(0.5, 0, 1, 0)
        sliderFill.Position = UDim2.new(0, 0, 0, 0)
        sliderFill.BackgroundColor3 = Color3.fromRGB(0, 162, 255)
        sliderFill.BorderSizePixel = 0
        sliderFill.Parent = sliderTrack
        
        local fillCorner = Instance.new("UICorner")
        fillCorner.CornerRadius = UDim.new(0, 3)
        fillCorner.Parent = sliderFill
        
        local sliderHandle = Instance.new("Frame")
        sliderHandle.Name = "Handle"
        sliderHandle.Size = UDim2.new(0, 16, 0, 16)
        sliderHandle.Position = UDim2.new(0.5, -8, 0.5, -8)
        sliderHandle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        sliderHandle.BorderSizePixel = 0
        sliderHandle.Parent = sliderTrack
        
        local handleCorner = Instance.new("UICorner")
        handleCorner.CornerRadius = UDim.new(0, 8)
        handleCorner.Parent = sliderHandle
        
        -- Slider functionality
        local dragging = false
        local function updateSlider(input)
            local relativeX = math.clamp((input.Position.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X, 0, 1)
            local value = item.Min + (item.Max - item.Min) * relativeX
            
            if item.Increment then
                value = math.floor(value / item.Increment + 0.5) * item.Increment
            end
            
            value = math.clamp(value, item.Min, item.Max)
            item.Value = value
            sliderValue.Text = tostring(value)
            
            createTween(sliderFill, {Size = UDim2.new(relativeX, 0, 1, 0)}, 0.1):Play()
            createTween(sliderHandle, {Position = UDim2.new(relativeX, -8, 0.5, -8)}, 0.1):Play()
            
            if item.Callback then
                item.Callback(value)
            end
        end
        
        sliderTrack.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                updateSlider(input)
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                updateSlider(input)
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end
    
    return itemHeight
end

function PickleLibrary:UpdateCanvasSize()
    local totalHeight = 0
    for _, child in pairs(self.TabContainer:GetChildren()) do
        if child:IsA("Frame") then
            totalHeight = totalHeight + child.Size.Y.Offset + 10
        end
    end
    self.TabContainer.CanvasSize = UDim2.new(0, 0, 0, totalHeight)
end

-- Section Methods
function PickleLibrary:CreateTab(section, name, icon)
    local tab = {
        Name = name,
        Icon = icon or "⚙",
        Items = {},
        IsExpanded = false,
        Frame = nil
    }
    
    table.insert(section.Tabs, tab)
    
    -- Refresh display if this section is active
    if section == self.CurrentSection then
        self:ShowSectionTabs(section)
    end
    
    return tab
end

-- Tab Methods (to be used with tab object returned from CreateTab)
function PickleLibrary:AddToggle(tab, config)
    local toggle = {
        Type = "Toggle",
        Name = config.Name or "Toggle",
        Value = config.Default or false,
        Callback = config.Callback
    }
    
    table.insert(tab.Items, toggle)
    
    -- Refresh display if tab's section is active
    for _, section in ipairs(self.Sections) do
        for _, sectionTab in ipairs(section.Tabs) do
            if sectionTab == tab and section == self.CurrentSection then
                self:ShowSectionTabs(section)
                break
            end
        end
    end
    
    return toggle
end

function PickleLibrary:AddButton(tab, config)
    local button = {
        Type = "Button",
        Name = config.Name or "Button",
        Callback = config.Callback
    }
    
    table.insert(tab.Items, button)
    
    -- Refresh display if tab's section is active
    for _, section in ipairs(self.Sections) do
        for _, sectionTab in ipairs(section.Tabs) do
            if sectionTab == tab and section == self.CurrentSection then
                self:ShowSectionTabs(section)
                break
            end
        end
    end
    
    return button
end

function PickleLibrary:AddSlider(tab, config)
    local slider = {
        Type = "Slider",
        Name = config.Name or "Slider",
        Min = config.Min or 0,
        Max = config.Max or 100,
        Value = config.Default or config.Min or 0,
        Increment = config.Increment,
        Callback = config.Callback
    }
    
    table.insert(tab.Items, slider)
    
    -- Refresh display if tab's section is active
    for _, section in ipairs(self.Sections) do
        for _, sectionTab in ipairs(section.Tabs) do
            if sectionTab == tab and section == self.CurrentSection then
                self:ShowSectionTabs(section)
                break
            end
        end
    end
    
    return slider
end

-- Utility Methods
function PickleLibrary:CreateCreditsSection()
    local creditsSection = self:CreateSection("Credits")
    local aboutTab = self:CreateTab(creditsSection, "About", "ℹ")
    local discordTab = self:CreateTab(creditsSection, "Discord Server", "💬")
    
    -- About tab content
    self:AddButton(aboutTab, {
        Name = "Scripts Hub X | Official",
        Callback = function()
            print("Scripts Hub X | Official - The ultimate script hub!")
        end
    })
    
    -- Discord tab content with join button
    self:AddButton(discordTab, {
        Name = "Join Our Discord Server",
        Callback = function()
            -- Copy discord link to clipboard
            if setclipboard then
                setclipboard("https://discord.gg/bpsNUH5sVb")
                print("Discord link copied to clipboard!")
            else
                print("Discord Link: https://discord.gg/bpsNUH5sVb")
            end
        end
    })
    
    self:AddToggle(discordTab, {
        Name = "Auto-Join Discord",
        Default = false,
        Callback = function(value)
            print("Auto-join Discord:", value)
        end
    })
    
    return creditsSection
end

function PickleLibrary:CreateConfigSection()
    local configSection = self:CreateSection("Configuration")
    local uiTab = self:CreateTab(configSection, "UI Settings", "🎨")
    
    -- UI Settings
    self:AddSlider(uiTab, {
        Name = "UI Scale",
        Min = 75,
        Max = 150,
        Default = 100,
        Increment = 5,
        Callback = function(value)
            local scale = value / 100
            self.MainFrame.Size = UDim2.new(0, 1000 * scale, 0, 600 * scale)
            print("UI Scale set to:", value .. "%")
        end
    })
    
    self:AddToggle(uiTab, {
        Name = "Neon Effects",
        Default = true,
        Callback = function(value)
            print("Neon Effects:", value)
            -- You can implement neon effect toggle here
        end
    })
    
    self:AddButton(uiTab, {
        Name = "Reset UI Position",
        Callback = function()
            self.MainFrame.Position = UDim2.new(0.5, -500, 0.5, -300)
            print("UI position reset!")
        end
    })
    
    return configSection
end

-- Example Usage Function
function PickleLibrary:CreateExampleWindow()
    local window = self:CreateWindow({
        Title = "Scripts Hub X | Official",
        Subtitle = "Made by PickleTalk"
    })
    
    -- Create main sections
    local mainSection = window:CreateSection("Main")
    local creditsSection = window:CreateCreditsSection()
    local configSection = window:CreateConfigSection()
    
    -- Main section tabs
    local featuresTab = window:CreateTab(mainSection, "Features", "⚡")
    local exploitsTab = window:CreateTab(mainSection, "Exploits", "🔧")
    local utilityTab = window:CreateTab(mainSection, "Utility", "🛠")
    
    -- Add features to tabs
    window:AddToggle(featuresTab, {
        Name = "Speed Boost",
        Default = false,
        Callback = function(value)
            print("Speed Boost:", value)
        end
    })
    
    window:AddToggle(featuresTab, {
        Name = "Jump Power",
        Default = false,
        Callback = function(value)
            print("Jump Power:", value)
        end
    })
    
    window:AddSlider(featuresTab, {
        Name = "Walk Speed",
        Min = 16,
        Max = 100,
        Default = 35,
        Increment = 1,
        Callback = function(value)
            if player.Character and player.Character:FindFirstChild("Humanoid") then
                player.Character.Humanoid.WalkSpeed = value
            end
            print("Walk Speed set to:", value)
        end
    })
    
    -- Exploits tab
    window:AddButton(exploitsTab, {
        Name = "Server Hop",
        Callback = function()
            print("Attempting to server hop...")
            -- Add server hop functionality here
        end
    })
    
    window:AddToggle(exploitsTab, {
        Name = "Anti-AFK",
        Default = false,
        Callback = function(value)
            print("Anti-AFK:", value)
        end
    })
    
    window:AddToggle(exploitsTab, {
        Name = "No Clip",
        Default = false,
        Callback = function(value)
            print("No Clip:", value)
        end
    })
    
    -- Utility tab
    window:AddButton(utilityTab, {
        Name = "Rejoin Game",
        Callback = function()
            game:GetService("TeleportService"):Teleport(game.PlaceId, player)
        end
    })
    
    window:AddToggle(utilityTab, {
        Name = "Auto-Save Config",
        Default = true,
        Callback = function(value)
            print("Auto-Save Config:", value)
        end
    })
    
    window:AddSlider(utilityTab, {
        Name = "FOV",
        Min = 70,
        Max = 120,
        Default = 90,
        Increment = 5,
        Callback = function(value)
            workspace.CurrentCamera.FieldOfView = value
            print("FOV set to:", value)
        end
    })
    
    return window
end

return PickleLibrary

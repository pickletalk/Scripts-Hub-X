local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configuration system
local CONFIG_FILE_NAME = "StealBrainrotConfig.json"
local defaultConfig = {
    tweenToBase = false,
    floorSteal = false,
    espToggle = false,
    baseTimeAlert = false,
    grappleSpeed = false
}

local currentConfig = table.clone(defaultConfig)

-- UI Configuration
local UI_CONFIG = {
    primaryColor = Color3.fromRGB(0, 162, 255),
    secondaryColor = Color3.fromRGB(25, 25, 35),
    backgroundColor = Color3.fromRGB(15, 15, 20),
    textColor = Color3.fromRGB(255, 255, 255),
    accentColor = Color3.fromRGB(0, 200, 255),
    successColor = Color3.fromRGB(0, 255, 100),
    errorColor = Color3.fromRGB(255, 50, 50),
    
    windowSize = UDim2.new(0, 450, 0, 350),
    buttonSize = UDim2.new(1, -20, 0, 35),
    toggleSize = UDim2.new(0, 50, 0, 25),
    
    animations = {
        fast = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        normal = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        slow = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    }
}

-- Configuration Management
local function saveConfig()
    local success, result = pcall(function()
        return HttpService:JSONEncode(currentConfig)
    end)
    
    if success then
        if writefile then
            writefile(CONFIG_FILE_NAME, result)
        end
    end
end

local function loadConfig()
    if readfile and isfile and isfile(CONFIG_FILE_NAME) then
        local success, result = pcall(function()
            local data = readfile(CONFIG_FILE_NAME)
            return HttpService:JSONDecode(data)
        end)
        
        if success and type(result) == "table" then
            for key, value in pairs(result) do
                if defaultConfig[key] ~= nil then
                    currentConfig[key] = value
                end
            end
        end
    end
end

-- Notification System
local notificationQueue = {}
local activeNotifications = {}

local function createNotification(text, notifType, duration)
    duration = duration or 3
    notifType = notifType or "info"
    
    local colors = {
        info = UI_CONFIG.primaryColor,
        success = UI_CONFIG.successColor,
        error = UI_CONFIG.errorColor
    }
    
    local notification = {
        text = text,
        type = notifType,
        color = colors[notifType] or UI_CONFIG.primaryColor,
        duration = duration,
        id = tick()
    }
    
    table.insert(notificationQueue, notification)
    
    if #activeNotifications == 0 then
        showNextNotification()
    end
end

local function showNextNotification()
    if #notificationQueue == 0 then return end
    
    local notification = table.remove(notificationQueue, 1)
    table.insert(activeNotifications, notification)
    
    -- Create notification GUI
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "StealBrainrotNotification"
    screenGui.Parent = playerGui
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    local frame = Instance.new("Frame")
    frame.Name = "NotificationFrame"
    frame.Size = UDim2.new(0, 300, 0, 60)
    frame.Position = UDim2.new(1, 320, 0, 100 + (#activeNotifications - 1) * 70)
    frame.BackgroundColor3 = UI_CONFIG.backgroundColor
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local accent = Instance.new("Frame")
    accent.Name = "Accent"
    accent.Size = UDim2.new(0, 4, 1, 0)
    accent.Position = UDim2.new(0, 0, 0, 0)
    accent.BackgroundColor3 = notification.color
    accent.BorderSizePixel = 0
    accent.Parent = frame
    
    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(0, 8)
    accentCorner.Parent = accent
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Name = "Text"
    textLabel.Size = UDim2.new(1, -20, 1, -10)
    textLabel.Position = UDim2.new(0, 15, 0, 5)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = notification.text
    textLabel.TextColor3 = UI_CONFIG.textColor
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamMedium
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = frame
    
    -- Slide in animation
    local slideIn = TweenService:Create(frame, UI_CONFIG.animations.normal, {
        Position = UDim2.new(1, -310, 0, 100 + (#activeNotifications - 1) * 70)
    })
    
    slideIn:Play()
    
    -- Auto-remove after duration
    task.spawn(function()
        task.wait(notification.duration)
        
        local slideOut = TweenService:Create(frame, UI_CONFIG.animations.normal, {
            Position = UDim2.new(1, 320, 0, 100 + (#activeNotifications - 1) * 70)
        })
        
        slideOut:Play()
        slideOut.Completed:Connect(function()
            screenGui:Destroy()
            
            -- Remove from active notifications
            for i, notif in ipairs(activeNotifications) do
                if notif.id == notification.id then
                    table.remove(activeNotifications, i)
                    break
                end
            end
            
            -- Show next notification if any
            if #notificationQueue > 0 then
                task.wait(0.1)
                showNextNotification()
            end
        end)
    end)
end

-- UI Creation System
local UIManager = {}
UIManager.windows = {}
UIManager.popups = {}

function UIManager:CreateWindow(config)
    local window = {
        name = config.name or "Window",
        size = config.size or UI_CONFIG.windowSize,
        sections = {},
        tabs = {},
        currentTab = nil,
        gui = nil,
        frame = nil,
        content = nil,
        minimized = false
    }
    
    -- Create ScreenGui
    window.gui = Instance.new("ScreenGui")
    window.gui.Name = "StealBrainrot_" .. window.name
    window.gui.Parent = playerGui
    window.gui.ResetOnSpawn = false
    window.gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame
    window.frame = Instance.new("Frame")
    window.frame.Name = "MainFrame"
    window.frame.Size = window.size
    window.frame.Position = UDim2.new(0.5, -window.size.X.Offset/2, 0.5, -window.size.Y.Offset/2)
    window.frame.BackgroundColor3 = UI_CONFIG.backgroundColor
    window.frame.BorderSizePixel = 0
    window.frame.Parent = window.gui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 10)
    mainCorner.Parent = window.frame
    
    -- Title Bar
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 40)
    titleBar.BackgroundColor3 = UI_CONFIG.primaryColor
    titleBar.BorderSizePixel = 0
    titleBar.Parent = window.frame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 10)
    titleCorner.Parent = titleBar
    
    -- Fix corners for title bar
    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 10)
    titleFix.Position = UDim2.new(0, 0, 1, -10)
    titleFix.BackgroundColor3 = UI_CONFIG.primaryColor
    titleFix.BorderSizePixel = 0
    titleFix.Parent = titleBar
    
    -- Title Text
    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Size = UDim2.new(1, -100, 1, 0)
    titleText.Position = UDim2.new(0, 10, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "💰 " .. window.name .. " 💰"
    titleText.TextColor3 = UI_CONFIG.textColor
    titleText.TextScaled = true
    titleText.Font = Enum.Font.GothamBold
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.Parent = titleBar
    
    -- Minimize Button
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeButton"
    minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    minimizeBtn.Position = UDim2.new(1, -70, 0, 5)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 193, 7)
    minimizeBtn.Text = "–"
    minimizeBtn.TextColor3 = UI_CONFIG.textColor
    minimizeBtn.TextScaled = true
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.Parent = titleBar
    
    local minCorner = Instance.new("UICorner")
    minCorner.CornerRadius = UDim.new(0, 6)
    minCorner.Parent = minimizeBtn
    
    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseButton"
    closeBtn.Size = UDim2.new(0, 30, 0, 30)
    closeBtn.Position = UDim2.new(1, -35, 0, 5)
    closeBtn.BackgroundColor3 = UI_CONFIG.errorColor
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = UI_CONFIG.textColor
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 6)
    closeCorner.Parent = closeBtn
    
    -- Content Area
    window.content = Instance.new("ScrollingFrame")
    window.content.Name = "Content"
    window.content.Size = UDim2.new(1, -20, 1, -60)
    window.content.Position = UDim2.new(0, 10, 0, 50)
    window.content.BackgroundTransparency = 1
    window.content.BorderSizePixel = 0
    window.content.ScrollBarThickness = 6
    window.content.ScrollBarImageColor3 = UI_CONFIG.primaryColor
    window.content.Parent = window.frame
    
    -- Make window draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    local function updateDrag(input)
        local delta = input.Position - dragStart
        window.frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = window.frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                updateDrag(input)
            end
        end
    end)
    
    -- Minimize functionality
    minimizeBtn.MouseButton1Click:Connect(function()
        window.minimized = not window.minimized
        
        local targetSize = window.minimized and UDim2.new(window.size.X.Scale, window.size.X.Offset, 0, 40) or window.size
        local minimizeTween = TweenService:Create(window.frame, UI_CONFIG.animations.normal, {Size = targetSize})
        
        minimizeTween:Play()
        minimizeBtn.Text = window.minimized and "+" or "–"
        
        createNotification("Window " .. (window.minimized and "minimized" or "restored"), "info", 1)
    end)
    
    -- Close functionality
    closeBtn.MouseButton1Click:Connect(function()
        self:ShowCloseConfirmation(window)
    end)
    
    -- Add button hover effects
    self:AddButtonHoverEffect(minimizeBtn, Color3.fromRGB(255, 213, 27))
    self:AddButtonHoverEffect(closeBtn, Color3.fromRGB(255, 70, 70))
    
    table.insert(self.windows, window)
    return window
end

function UIManager:ShowCloseConfirmation(window)
    -- Create confirmation popup
    local confirmGui = Instance.new("ScreenGui")
    confirmGui.Name = "CloseConfirmation"
    confirmGui.Parent = playerGui
    confirmGui.ResetOnSpawn = false
    
    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.5
    overlay.BorderSizePixel = 0
    overlay.Parent = confirmGui
    
    local confirmFrame = Instance.new("Frame")
    confirmFrame.Size = UDim2.new(0, 300, 0, 150)
    confirmFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
    confirmFrame.BackgroundColor3 = UI_CONFIG.backgroundColor
    confirmFrame.BorderSizePixel = 0
    confirmFrame.Parent = confirmGui
    
    local confirmCorner = Instance.new("UICorner")
    confirmCorner.CornerRadius = UDim.new(0, 10)
    confirmCorner.Parent = confirmFrame
    
    local confirmText = Instance.new("TextLabel")
    confirmText.Size = UDim2.new(1, -20, 0.6, 0)
    confirmText.Position = UDim2.new(0, 10, 0, 10)
    confirmText.BackgroundTransparency = 1
    confirmText.Text = "Are you sure you want to close?"
    confirmText.TextColor3 = UI_CONFIG.textColor
    confirmText.TextScaled = true
    confirmText.Font = Enum.Font.Gotham
    confirmText.Parent = confirmFrame
    
    local yesBtn = Instance.new("TextButton")
    yesBtn.Size = UDim2.new(0, 80, 0, 30)
    yesBtn.Position = UDim2.new(0.5, -85, 0.7, 0)
    yesBtn.BackgroundColor3 = UI_CONFIG.errorColor
    yesBtn.Text = "Yes"
    yesBtn.TextColor3 = UI_CONFIG.textColor
    yesBtn.TextScaled = true
    yesBtn.Font = Enum.Font.GothamBold
    yesBtn.BorderSizePixel = 0
    yesBtn.Parent = confirmFrame
    
    local yesCorner = Instance.new("UICorner")
    yesCorner.CornerRadius = UDim.new(0, 6)
    yesCorner.Parent = yesBtn
    
    local noBtn = Instance.new("TextButton")
    noBtn.Size = UDim2.new(0, 80, 0, 30)
    noBtn.Position = UDim2.new(0.5, 5, 0.7, 0)
    noBtn.BackgroundColor3 = UI_CONFIG.primaryColor
    noBtn.Text = "No"
    noBtn.TextColor3 = UI_CONFIG.textColor
    noBtn.TextScaled = true
    noBtn.Font = Enum.Font.GothamBold
    noBtn.BorderSizePixel = 0
    noBtn.Parent = confirmFrame
    
    local noCorner = Instance.new("UICorner")
    noCorner.CornerRadius = UDim.new(0, 6)
    noCorner.Parent = noBtn
    
    -- Fade in animation
    confirmFrame.Size = UDim2.new(0, 0, 0, 0)
    local fadeIn = TweenService:Create(confirmFrame, UI_CONFIG.animations.normal, {
        Size = UDim2.new(0, 300, 0, 150)
    })
    fadeIn:Play()
    
    yesBtn.MouseButton1Click:Connect(function()
        self:CloseWindow(window)
        confirmGui:Destroy()
    end)
    
    noBtn.MouseButton1Click:Connect(function()
        confirmGui:Destroy()
    end)
    
    self:AddButtonHoverEffect(yesBtn, Color3.fromRGB(255, 70, 70))
    self:AddButtonHoverEffect(noBtn, Color3.fromRGB(0, 182, 255))
end

function UIManager:CloseWindow(window)
    -- Cleanup any active functions/connections
    if window.name == "Steal A Brainrot" then
        -- Cleanup main window functions
        self:CleanupMainFeatures()
    end
    
    -- Remove from windows list
    for i, w in ipairs(self.windows) do
        if w == window then
            table.remove(self.windows, i)
            break
        end
    end
    
    -- Destroy GUI
    if window.gui then
        window.gui:Destroy()
    end
    
    createNotification("Window closed", "info", 2)
end

function UIManager:AddButtonHoverEffect(button, hoverColor)
    local originalColor = button.BackgroundColor3
    
    button.MouseEnter:Connect(function()
        local hoverTween = TweenService:Create(button, UI_CONFIG.animations.fast, {
            BackgroundColor3 = hoverColor
        })
        hoverTween:Play()
    end)
    
    button.MouseLeave:Connect(function()
        local leaveTween = TweenService:Create(button, UI_CONFIG.animations.fast, {
            BackgroundColor3 = originalColor
        })
        leaveTween:Play()
    end)
end

function UIManager:CreateSection(window, name)
    local section = {
        name = name,
        elements = {},
        frame = nil,
        yPos = 0
    }
    
    -- Calculate position for section
    local currentY = 0
    for _, existingSection in pairs(window.sections) do
        currentY = currentY + existingSection.frame.Size.Y.Offset + 10
    end
    
    section.frame = Instance.new("Frame")
    section.frame.Name = name .. "Section"
    section.frame.Size = UDim2.new(1, -20, 0, 40) -- Start with header height
    section.frame.Position = UDim2.new(0, 10, 0, currentY)
    section.frame.BackgroundColor3 = UI_CONFIG.secondaryColor
    section.frame.BorderSizePixel = 0
    section.frame.Parent = window.content
    
    local sectionCorner = Instance.new("UICorner")
    sectionCorner.CornerRadius = UDim.new(0, 8)
    sectionCorner.Parent = section.frame
    
    -- Section Header
    local header = Instance.new("TextLabel")
    header.Name = "Header"
    header.Size = UDim2.new(1, -10, 0, 30)
    header.Position = UDim2.new(0, 5, 0, 5)
    header.BackgroundTransparency = 1
    header.Text = name
    header.TextColor3 = UI_CONFIG.primaryColor
    header.TextScaled = true
    header.Font = Enum.Font.GothamBold
    header.TextXAlignment = Enum.TextXAlignment.Left
    header.Parent = section.frame
    
    section.yPos = 40 -- Start below header
    
    window.sections[name] = section
    self:UpdateContentSize(window)
    
    return section
end

function UIManager:CreateTab(section, name, isDefault)
    local tab = {
        name = name,
        elements = {},
        button = nil,
        content = nil,
        active = isDefault or false
    }
    
    -- Create tab button
    local tabCount = 0
    for _ in pairs(section.elements) do
        tabCount = tabCount + 1
    end
    
    tab.button = Instance.new("TextButton")
    tab.button.Name = name .. "Tab"
    tab.button.Size = UDim2.new(0, 100, 0, 30)
    tab.button.Position = UDim2.new(0, 10 + (tabCount * 105), 0, section.yPos)
    tab.button.BackgroundColor3 = tab.active and UI_CONFIG.primaryColor or UI_CONFIG.backgroundColor
    tab.button.Text = name
    tab.button.TextColor3 = UI_CONFIG.textColor
    tab.button.TextScaled = true
    tab.button.Font = Enum.Font.GothamMedium
    tab.button.BorderSizePixel = 0
    tab.button.Parent = section.frame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 6)
    tabCorner.Parent = tab.button
    
    -- Create tab content frame
    tab.content = Instance.new("Frame")
    tab.content.Name = name .. "Content"
    tab.content.Size = UDim2.new(1, -20, 0, 0) -- Will be resized as elements are added
    tab.content.Position = UDim2.new(0, 10, 0, section.yPos + 40)
    tab.content.BackgroundTransparency = 1
    tab.content.BorderSizePixel = 0
    tab.content.Visible = tab.active
    tab.content.Parent = section.frame
    
    tab.yPos = 10 -- Start position for elements in tab
    
    -- Tab switching functionality
    tab.button.MouseButton1Click:Connect(function()
        self:SwitchTab(section, name)
    end)
    
    self:AddButtonHoverEffect(tab.button, tab.active and Color3.fromRGB(0, 182, 255) or Color3.fromRGB(35, 35, 45))
    
    section.elements[name] = tab
    
    if tab.active then
        section.activeTab = name
    end
    
    self:UpdateSectionSize(section)
    
    return tab
end

function UIManager:SwitchTab(section, tabName)
    -- Hide all tabs
    for name, tab in pairs(section.elements) do
        tab.active = false
        tab.content.Visible = false
        tab.button.BackgroundColor3 = UI_CONFIG.backgroundColor
    end
    
    -- Show selected tab
    local selectedTab = section.elements[tabName]
    if selectedTab then
        selectedTab.active = true
        selectedTab.content.Visible = true
        selectedTab.button.BackgroundColor3 = UI_CONFIG.primaryColor
        section.activeTab = tabName
        
        createNotification("Switched to " .. tabName, "info", 1)
    end
end

function UIManager:CreateToggle(tab, name, configKey, callback)
    local toggle = {
        name = name,
        state = currentConfig[configKey] or false,
        configKey = configKey,
        callback = callback,
        frame = nil,
        switch = nil,
        popup = nil
    }
    
    -- Create toggle frame
    toggle.frame = Instance.new("Frame")
    toggle.frame.Name = name .. "Toggle"
    toggle.frame.Size = UDim2.new(1, -20, 0, 40)
    toggle.frame.Position = UDim2.new(0, 10, 0, tab.yPos)
    toggle.frame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    toggle.frame.BorderSizePixel = 0
    toggle.frame.Parent = tab.content
    
    local toggleCorner = Instance.new("UICorner")
    toggleCorner.CornerRadius = UDim.new(0, 6)
    toggleCorner.Parent = toggle.frame
    
    -- Toggle label
    local label = Instance.new("TextLabel")
    label.Name = "Label"
    label.Size = UDim2.new(1, -80, 1, -10)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.Text = name
    label.TextColor3 = UI_CONFIG.textColor
    label.TextScaled = true
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = toggle.frame
    
    -- Toggle switch container
    local switchContainer = Instance.new("Frame")
    switchContainer.Name = "SwitchContainer"
    switchContainer.Size = UDim2.new(0, 60, 0, 25)
    switchContainer.Position = UDim2.new(1, -70, 0.5, -12.5)
    switchContainer.BackgroundColor3 = toggle.state and UI_CONFIG.primaryColor or Color3.fromRGB(60, 60, 70)
    switchContainer.BorderSizePixel = 0
    switchContainer.Parent = toggle.frame
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(0, 12.5)
    switchCorner.Parent = switchContainer
    
    -- Toggle switch circle
    toggle.switch = Instance.new("Frame")
    toggle.switch.Name = "Switch"
    toggle.switch.Size = UDim2.new(0, 20, 0, 20)
    toggle.switch.Position = toggle.state and UDim2.new(1, -22.5, 0.5, -10) or UDim2.new(0, 2.5, 0.5, -10)
    toggle.switch.BackgroundColor3 = UI_CONFIG.textColor
    toggle.switch.BorderSizePixel = 0
    toggle.switch.Parent = switchContainer
    
    local switchCircle = Instance.new("UICorner")
    switchCircle.CornerRadius = UDim.new(0, 10)
    switchCircle.Parent = toggle.switch
    
    -- Toggle functionality
    local function toggleState()
        toggle.state = not toggle.state
        currentConfig[configKey] = toggle.state
        
        local containerTween = TweenService:Create(switchContainer, UI_CONFIG.animations.fast, {
            BackgroundColor3 = toggle.state and UI_CONFIG.primaryColor or Color3.fromRGB(60, 60, 70)
        })
        
        local switchTween = TweenService:Create(toggle.switch, UI_CONFIG.animations.fast, {
            Position = toggle.state and UDim2.new(1, -22.5, 0.5, -10) or UDim2.new(0, 2.5, 0.5, -10)
        })
        
        containerTween:Play()
        switchTween:Play()
        
        -- Show/hide popup UI if toggle has one
        if toggle.state and callback and type(callback) == "function" then
            callback(toggle.state, toggle)
        elseif not toggle.state and callback and type(callback) == "function" then
            callback(toggle.state, toggle)
        end
        
        saveConfig()
        createNotification(name .. " " .. (toggle.state and "enabled" or "disabled"), "success", 2)
    end
    
    switchContainer.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            toggleState()
        end
    end)
    
    tab.yPos = tab.yPos + 50
    self:UpdateTabSize(tab)
    
    return toggle
end

function UIManager:CreateButton(tab, name, callback)
    local button = Instance.new("TextButton")
    button.Name = name .. "Button"
    button.Size = UDim2.new(1, -20, 0, 35)
    button.Position = UDim2.new(0, 10, 0, tab.yPos)
    button.BackgroundColor3 = UI_CONFIG.primaryColor
    button.Text = name
    button.TextColor3 = UI_CONFIG.textColor
    button.TextScaled = true
    button.Font = Enum.Font.GothamMedium
    button.BorderSizePixel = 0
    button.Parent = tab.content
    
    local buttonCorner = Instance.new("UICorner")
    buttonCorner.CornerRadius = UDim.new(0, 6)
    buttonCorner.Parent = button
    
    button.MouseButton1Click:Connect(function()
        local clickTween = TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(1, -25, 0, 32)})
        local releaseTween = TweenService:Create(button, TweenInfo.new(0.1), {Size = UDim2.new(1, -20, 0, 35)})
        
        clickTween:Play()
        clickTween.Completed:Connect(function()
            releaseTween:Play()
        end)
        
        if callback then
            callback()
        end
    end)
    
    self:AddButtonHoverEffect(button, Color3.fromRGB(0, 182, 255))
    
    tab.yPos = tab.yPos + 45
    self:UpdateTabSize(tab)
    
    return button
end

function UIManager:CreatePopupUI(toggle, config)
    if toggle.popup then
        toggle.popup:Destroy()
        toggle.popup = nil
        return
    end
    
    local popup = Instance.new("ScreenGui")
    popup.Name = "Popup_" .. toggle.name
    popup.Parent = playerGui
    popup.ResetOnSpawn = false
    
    local frame = Instance.new("Frame")
    frame.Name = "PopupFrame"
    frame.Size = config.size or UDim2.new(0, 250, 0, 200)
    frame.Position = UDim2.new(1, -260, 0, 200)
    frame.BackgroundColor3 = UI_CONFIG.backgroundColor
    frame.BorderSizePixel = 0
    frame.Parent = popup
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = frame
    
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = UI_CONFIG.primaryColor
    titleBar.BorderSizePixel = 0
    titleBar.Parent = frame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    local titleFix = Instance.new("Frame")
    titleFix.Size = UDim2.new(1, 0, 0, 8)
    titleFix.Position = UDim2.new(0, 0, 1, -8)
    titleFix.BackgroundColor3 = UI_CONFIG.primaryColor
    titleFix.BorderSizePixel = 0
    titleFix.Parent = titleBar
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -35, 1, 0)
    title.Position = UDim2.new(0, 5, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = toggle.name
    title.TextColor3 = UI_CONFIG.textColor
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = titleBar
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -27, 0, 2.5)
    closeBtn.BackgroundColor3 = UI_CONFIG.errorColor
    closeBtn.Text = "✕"
    closeBtn.TextColor3 = UI_CONFIG.textColor
    closeBtn.TextScaled = true
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.BorderSizePixel = 0
    closeBtn.Parent = titleBar
    
    local closeBtnCorner = Instance.new("UICorner")
    closeBtnCorner.CornerRadius = UDim.new(0, 4)
    closeBtnCorner.Parent = closeBtn
    
    local content = Instance.new("ScrollingFrame")
    content.Name = "Content"
    content.Size = UDim2.new(1, -10, 1, -40)
    content.Position = UDim2.new(0, 5, 0, 35)
    content.BackgroundTransparency = 1
    content.BorderSizePixel = 0
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = UI_CONFIG.primaryColor
    content.Parent = frame
    
    -- Make popup draggable
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            if dragging then
                local delta = input.Position - dragStart
                frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    
    closeBtn.MouseButton1Click:Connect(function()
        popup:Destroy()
        toggle.popup = nil
    end)
    
    self:AddButtonHoverEffect(closeBtn, Color3.fromRGB(255, 70, 70))
    
    toggle.popup = popup
    
    -- Add elements to popup based on config
    if config.elements then
        local yPos = 10
        for _, element in ipairs(config.elements) do
            if element.type == "button" then
                local btn = Instance.new("TextButton")
                btn.Size = UDim2.new(1, -20, 0, 35)
                btn.Position = UDim2.new(0, 10, 0, yPos)
                btn.BackgroundColor3 = element.color or UI_CONFIG.primaryColor
                btn.Text = element.text
                btn.TextColor3 = UI_CONFIG.textColor
                btn.TextScaled = true
                btn.Font = Enum.Font.GothamMedium
                btn.BorderSizePixel = 0
                btn.Parent = content
                
                local btnCorner = Instance.new("UICorner")
                btnCorner.CornerRadius = UDim.new(0, 6)
                btnCorner.Parent = btn
                
                if element.callback then
                    btn.MouseButton1Click:Connect(element.callback)
                end
                
                self:AddButtonHoverEffect(btn, element.hoverColor or Color3.fromRGB(0, 182, 255))
                yPos = yPos + 45
            end
        end
        
        content.CanvasSize = UDim2.new(0, 0, 0, yPos)
    end
    
    return popup
end

function UIManager:UpdateTabSize(tab)
    tab.content.Size = UDim2.new(1, -20, 0, tab.yPos + 10)
    self:UpdateSectionSize(tab.parent)
end

function UIManager:UpdateSectionSize(section)
    local maxHeight = 70 -- Header + tab buttons
    
    for _, tab in pairs(section.elements) do
        if tab.active then
            maxHeight = maxHeight + tab.content.Size.Y.Offset
        end
    end
    
    section.frame.Size = UDim2.new(1, -20, 0, maxHeight)
    self:UpdateContentSize(section.window)
end

function UIManager:UpdateContentSize(window)
    local totalHeight = 0
    for _, section in pairs(window.sections) do
        totalHeight = totalHeight + section.frame.Size.Y.Offset + 10
    end
    
    window.content.CanvasSize = UDim2.new(0, 0, 0, totalHeight + 20)
end

function UIManager:CleanupMainFeatures()
    -- Add cleanup code here for main features
    -- This will be called when the main window is closed
end

-- Load configuration on startup
loadConfig()

-- Create main window
local mainWindow = UIManager:CreateWindow({
    name = "Steal A Brainrot",
    size = UDim2.new(0, 450, 0, 400)
})

-- Create Main section
local mainSection = UIManager:CreateSection(mainWindow, "Main")

-- Create Steal Helper tab
local stealHelperTab = UIManager:CreateTab(mainSection, "Steal Helper", true)

-- Create Visual tab
local visualTab = UIManager:CreateTab(mainSection, "Visual", false)

-- Create Credit section
local creditSection = UIManager:CreateSection(mainWindow, "Credit")

-- Add toggles to Steal Helper tab
local tweenToggle = UIManager:CreateToggle(stealHelperTab, "Tween To Base", "tweenToBase", function(state, toggle)
    if state then
        UIManager:CreatePopupUI(toggle, {
            size = UDim2.new(0, 280, 0, 200),
            elements = {
                {
                    type = "button",
                    text = "🚀 Start Tween",
                    color = Color3.fromRGB(0, 255, 100),
                    hoverColor = Color3.fromRGB(0, 255, 120),
                    callback = function()
                        createNotification("Tween to base started!", "success")
                        -- Add tween functionality here
                    end
                },
                {
                    type = "button", 
                    text = "🛑 Stop Tween",
                    color = Color3.fromRGB(255, 50, 50),
                    hoverColor = Color3.fromRGB(255, 70, 70),
                    callback = function()
                        createNotification("Tween stopped!", "info")
                        -- Add stop functionality here
                    end
                },
                {
                    type = "button",
                    text = "⚙️ Settings",
                    color = Color3.fromRGB(100, 100, 100),
                    hoverColor = Color3.fromRGB(120, 120, 120),
                    callback = function()
                        createNotification("Settings opened!", "info")
                    end
                }
            }
        })
    else
        if toggle.popup then
            toggle.popup:Destroy()
            toggle.popup = nil
        end
    end
end)

local floorStealToggle = UIManager:CreateToggle(stealHelperTab, "Floor Steal/Float", "floorSteal", function(state, toggle)
    if state then
        UIManager:CreatePopupUI(toggle, {
            size = UDim2.new(0, 280, 0, 180),
            elements = {
                {
                    type = "button",
                    text = "🚹 Enable Float",
                    color = Color3.fromRGB(0, 162, 255),
                    hoverColor = Color3.fromRGB(0, 182, 255),
                    callback = function()
                        createNotification("Float enabled!", "success")
                        -- Add float functionality here
                    end
                },
                {
                    type = "button",
                    text = "💰 Floor Steal",
                    color = Color3.fromRGB(255, 215, 0),
                    hoverColor = Color3.fromRGB(255, 235, 20),
                    callback = function()
                        createNotification("Floor steal activated!", "success")
                        -- Add floor steal functionality here
                    end
                }
            }
        })
    else
        if toggle.popup then
            toggle.popup:Destroy()
            toggle.popup = nil
        end
    end
end)

local grappleSpeedToggle = UIManager:CreateToggle(stealHelperTab, "Grapple Speed", "grappleSpeed", function(state, toggle)
    if state then
        UIManager:CreatePopupUI(toggle, {
            size = UDim2.new(0, 200, 0, 120),
            elements = {
                {
                    type = "button",
                    text = "🎣 Enable Grapple",
                    color = Color3.fromRGB(255, 100, 255),
                    hoverColor = Color3.fromRGB(255, 120, 255),
                    callback = function()
                        createNotification("Grapple speed enabled!", "success")
                        player.Character.Humanoid.WalkSpeed = 120
                        -- Add grapple loop here
                        task.spawn(function()
                            while currentConfig.grappleSpeed do
                                -- equipAndFireGrapple() -- Add your function here
                                task.wait(3.5)
                            end
                        end)
                    end
                }
            }
        })
    else
        if toggle.popup then
            toggle.popup:Destroy()
            toggle.popup = nil
        end
        player.Character.Humanoid.WalkSpeed = 16 -- Reset speed
    end
end)

-- Add toggles to Visual tab  
local espToggle = UIManager:CreateToggle(visualTab, "ESP Toggle", "espToggle", function(state, toggle)
    createNotification("ESP " .. (state and "enabled" or "disabled"), state and "success" or "info")
    -- Add ESP functionality here
end)

local baseTimeAlertToggle = UIManager:CreateToggle(visualTab, "Base Time Alert", "baseTimeAlert", function(state, toggle)
    createNotification("Base time alert " .. (state and "enabled" or "disabled"), state and "success" or "info")
    -- Add base time alert functionality here
end)

-- Create credit content
local creditFrame = Instance.new("Frame")
creditFrame.Name = "CreditContent"  
creditFrame.Size = UDim2.new(1, -20, 0, 100)
creditFrame.Position = UDim2.new(0, 10, 0, 40)
creditFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
creditFrame.BorderSizePixel = 0
creditFrame.Parent = creditSection.frame

local creditCorner = Instance.new("UICorner")
creditCorner.CornerRadius = UDim.new(0, 8)
creditCorner.Parent = creditFrame

local creditText = Instance.new("TextLabel")
creditText.Size = UDim2.new(1, -20, 0, 40)
creditText.Position = UDim2.new(0, 10, 0, 10)
creditText.BackgroundTransparency = 1
creditText.Text = "Scripts Hub X | Official - UI made by PickleTalk"
creditText.TextColor3 = UI_CONFIG.textColor
creditText.TextScaled = true
creditText.Font = Enum.Font.Gotham
creditText.TextXAlignment = Enum.TextXAlignment.Center
creditText.Parent = creditFrame

local discordBtn = Instance.new("TextButton")
discordBtn.Size = UDim2.new(0, 200, 0, 35)
discordBtn.Position = UDim2.new(0.5, -100, 0, 55)
discordBtn.BackgroundColor3 = Color3.fromRGB(114, 137, 218)
discordBtn.Text = "📋 Join Discord"
discordBtn.TextColor3 = UI_CONFIG.textColor
discordBtn.TextScaled = true
discordBtn.Font = Enum.Font.GothamBold
discordBtn.BorderSizePixel = 0
discordBtn.Parent = creditFrame

local discordCorner = Instance.new("UICorner")
discordCorner.CornerRadius = UDim.new(0, 6)
discordCorner.Parent = discordBtn

discordBtn.MouseButton1Click:Connect(function()
    if setclipboard then
        setclipboard("https://discord.gg/bpsNUH5sVb")
        createNotification("Discord link copied to clipboard!", "success")
    else
        createNotification("Discord: https://discord.gg/bpsNUH5sVb", "info", 5)
    end
end)

UIManager:AddButtonHoverEffect(discordBtn, Color3.fromRGB(134, 157, 238))

-- Update section sizes
creditSection.frame.Size = UDim2.new(1, -20, 0, 150)
UIManager:UpdateContentSize(mainWindow)

-- Apply loaded configuration
if currentConfig.tweenToBase then
    -- Apply tween to base state
end
if currentConfig.floorSteal then
    -- Apply floor steal state  
end
if currentConfig.espToggle then
    -- Apply ESP state
end
if currentConfig.baseTimeAlert then
    -- Apply base time alert state
end

-- Show startup notification
task.wait(0.5)
createNotification("🚀 Steal A Brainrot loaded successfully!", "success", 3)
createNotification("💎 UI by PickleTalk", "info", 2)

print("🚀 Enhanced Steal-A-Brainrot UI loaded successfully!")
print("📋 Features:")
print("   • 🎨 Modern neon blue UI with premium animations")
print("   • 💾 Auto-save configuration system")
print("   • 🔔 Custom notification system")
print("   • 📱 Draggable windows and popups")
print("   • ⚙️ Modular toggle and button system")
print("   • 🎯 Organized tabs and sections")
print("⚡ Ready to dominate with style! ⚡")

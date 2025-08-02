local PickleUI = {}

-- Services
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

-- Animation settings
local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

-- Color scheme (fixed, users can't edit)
local Colors = {
    MainBackground = Color3.fromRGB(30, 30, 30),
    TitleBar = Color3.fromRGB(50, 50, 50),
    TabButton = Color3.fromRGB(50, 50, 50),
    TabButtonActive = Color3.fromRGB(70, 70, 70),
    Button = Color3.fromRGB(70, 70, 70),
    SliderBar = Color3.fromRGB(100, 100, 100),
    ToggleOn = Color3.fromRGB(0, 150, 0),
    ToggleOff = Color3.fromRGB(150, 0, 0),
    Text = Color3.fromRGB(255, 255, 255),
}

-- Window Class
local Window = {}
Window.__index = Window

function Window.new(name)
    local self = setmetatable({}, Window)
    self.Name = name
    self.Tabs = {}
    self.CurrentTab = nil
    self.IsMinimized = false

    -- ScreenGui
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Parent = Players.LocalPlayer.PlayerGui
    self.ScreenGui.Name = "PickleFieldUI"

    -- Main Frame
    self.MainFrame = Instance.new("Frame", self.ScreenGui)
    self.MainFrame.Size = UDim2.new(0, 400, 0, 300)
    self.MainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
    self.MainFrame.BackgroundColor3 = Colors.MainBackground
    self.MainFrame.BorderSizePixel = 0
    local mainCorner = Instance.new("UICorner", self.MainFrame)
    mainCorner.CornerRadius = UDim.new(0, 10)

    -- Title Bar
    self.TitleBar = Instance.new("Frame", self.MainFrame)
    self.TitleBar.Size = UDim2.new(1, 0, 0, 30)
    self.TitleBar.BackgroundColor3 = Colors.TitleBar
    local titleCorner = Instance.new("UICorner", self.TitleBar)
    titleCorner.CornerRadius = UDim.new(0, 10)

    self.TitleLabel = Instance.new("TextLabel", self.TitleBar)
    self.TitleLabel.Size = UDim2.new(0.8, 0, 1, 0)
    self.TitleLabel.Position = UDim2.new(0.1, 0, 0, 0)
    self.TitleLabel.Text = name
    self.TitleLabel.TextColor3 = Colors.Text
    self.TitleLabel.BackgroundTransparency = 1
    self.TitleLabel.TextSize = 16
    self.TitleLabel.Font = Enum.Font.SourceSansBold

    self.MinimizeButton = Instance.new("TextButton", self.TitleBar)
    self.MinimizeButton.Size = UDim2.new(0.1, 0, 1, 0)
    self.MinimizeButton.Position = UDim2.new(0.9, 0, 0, 0)
    self.MinimizeButton.Text = "-"
    self.MinimizeButton.TextColor3 = Colors.Text
    self.MinimizeButton.BackgroundColor3 = Colors.Button
    self.MinimizeButton.BorderSizePixel = 0
    local minCorner = Instance.new("UICorner", self.MinimizeButton)
    minCorner.CornerRadius = UDim.new(0, 5)
    self.MinimizeButton.MouseButton1Click:Connect(function()
        if self.IsMinimized then
            self:Maximize()
        else
            self:Minimize()
        end
    end)

    -- Tab Buttons Frame
    self.TabButtonsFrame = Instance.new("Frame", self.MainFrame)
    self.TabButtonsFrame.Size = UDim2.new(1, 0, 0, 30)
    self.TabButtonsFrame.Position = UDim2.new(0, 0, 0, 30)
    self.TabButtonsFrame.BackgroundTransparency = 1
    local tabLayout = Instance.new("UIListLayout", self.TabButtonsFrame)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.Padding = UDim.new(0, 5)

    -- Content Frame
    self.ContentFrame = Instance.new("Frame", self.MainFrame)
    self.ContentFrame.Size = UDim2.new(1, 0, 1, -60)
    self.ContentFrame.Position = UDim2.new(0, 0, 0, 60)
    self.ContentFrame.BackgroundTransparency = 1
    local contentPadding = Instance.new("UIPadding", self.ContentFrame)
    contentPadding.PaddingTop = UDim.new(0, 5)
    contentPadding.PaddingLeft = UDim.new(0, 5)

    -- Minimized Bar
    self.MinimizedBar = Instance.new("Frame", self.ScreenGui)
    self.MinimizedBar.Size = UDim2.new(0, 200, 0, 40)
    self.MinimizedBar.Position = UDim2.new(0.5, -100, 0, -40) -- Hidden initially
    self.MinimizedBar.BackgroundColor3 = Colors.TitleBar
    self.MinimizedBar.BorderSizePixel = 0
    local barCorner = Instance.new("UICorner", self.MinimizedBar)
    barCorner.CornerRadius = UDim.new(0, 10)
    local barLabel = Instance.new("TextLabel", self.MinimizedBar)
    barLabel.Size = UDim2.new(1, 0, 1, 0)
    barLabel.Text = "PickleField"
    barLabel.TextColor3 = Colors.Text
    barLabel.BackgroundTransparency = 1
    barLabel.TextSize = 16
    barLabel.Font = Enum.Font.SourceSansBold
    self.MinimizedBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            self:Maximize()
        end
    end)

    -- Animation positions
    self.MainFrameNormalPos = self.MainFrame.Position
    self.MainFrameMinimizedPos = UDim2.new(0.5, -200, 0, -300)
    self.MinimizedBarNormalPos = UDim2.new(0.5, -100, 0, 0)
    self.MinimizedBarHiddenPos = UDim2.new(0.5, -100, 0, -40)

    -- Draggable
    self:MakeDraggable()

    -- Default Info Tab
    local defaultTab = self:CreateTab("Info")
    defaultTab:Label("UI Library by Pickletalk")
    defaultTab:Label("Discord: https://discord.gg/bpsNUH5sVb")

    return self
end

function Window:CreateTab(name)
    local tab = {}
    setmetatable(tab, Tab)
    tab.Name = name
    tab.Window = self
    tab.Elements = {}

    -- Tab Button
    tab.Button = Instance.new("TextButton", self.TabButtonsFrame)
    tab.Button.Size = UDim2.new(0, 100, 1, 0)
    tab.Button.Text = name
    tab.Button.TextColor3 = Colors.Text
    tab.Button.BackgroundColor3 = Colors.TabButton
    tab.Button.BorderSizePixel = 0
    local btnCorner = Instance.new("UICorner", tab.Button)
    btnCorner.CornerRadius = UDim.new(0, 5)
    tab.Button.MouseButton1Click:Connect(function()
        self:SelectTab(tab)
    end)

    -- Tab Content Frame
    tab.ContentFrame = Instance.new("Frame", self.ContentFrame)
    tab.ContentFrame.Size = UDim2.new(1, 0, 1, 0)
    tab.ContentFrame.BackgroundTransparency = 1
    tab.ContentFrame.Visible = false
    local layout = Instance.new("UIListLayout", tab.ContentFrame)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 5)

    table.insert(self.Tabs, tab)
    if #self.Tabs == 1 then
        self:SelectTab(tab)
    end
    return tab
end

function Window:SelectTab(tab)
    if self.CurrentTab == tab then return end
    if self.CurrentTab then
        local fadeOut = TweenService:Create(self.CurrentTab.ContentFrame, tweenInfo, {BackgroundTransparency = 1})
        fadeOut:Play()
        fadeOut.Completed:Wait()
        self.CurrentTab.ContentFrame.Visible = false
        self.CurrentTab.Button.BackgroundColor3 = Colors.TabButton
    end
    self.CurrentTab = tab
    tab.ContentFrame.BackgroundTransparency = 1
    tab.ContentFrame.Visible = true
    local fadeIn = TweenService:Create(tab.ContentFrame, tweenInfo, {BackgroundTransparency = 0})
    fadeIn:Play()
    tab.Button.BackgroundColor3 = Colors.TabButtonActive
end

function Window:Minimize()
    if self.IsMinimized then return end
    self.IsMinimized = true
    local mainTween = TweenService:Create(self.MainFrame, tweenInfo, {Position = self.MainFrameMinimizedPos})
    local barTween = TweenService:Create(self.MinimizedBar, tweenInfo, {Position = self.MinimizedBarNormalPos})
    mainTween:Play()
    barTween:Play()
end

function Window:Maximize()
    if not self.IsMinimized then return end
    self.IsMinimized = false
    local mainTween = TweenService:Create(self.MainFrame, tweenInfo, {Position = self.MainFrameNormalPos})
    local barTween = TweenService:Create(self.MinimizedBar, tweenInfo, {Position = self.MinimizedBarHiddenPos})
    mainTween:Play()
    barTween:Play()
end

function Window:MakeDraggable()
    local dragging = false
    local dragStart
    local startPos

    self.TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = self.MainFrame.Position
        end
    end)

    self.TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            local delta = input.Position - dragStart
            self.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    self.TitleBar.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
end

-- Tab Class
local Tab = {}
Tab.__index = Tab

function Tab:Button(name, callback)
    local button = Instance.new("TextButton", self.ContentFrame)
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Text = name
    button.TextColor3 = Colors.Text
    button.BackgroundColor3 = Colors.Button
    button.BorderSizePixel = 0
    button.LayoutOrder = #self.Elements
    local btnCorner = Instance.new("UICorner", button)
    btnCorner.CornerRadius = UDim.new(0, 5)
    button.MouseButton1Click:Connect(callback)
    table.insert(self.Elements, button)
    return button
end

function Tab:Slider(name, min, max, default, callback)
    local sliderFrame = Instance.new("Frame", self.ContentFrame)
    sliderFrame.Size = UDim2.new(1, -10, 0, 30)
    sliderFrame.BackgroundTransparency = 1
    sliderFrame.LayoutOrder = #self.Elements

    local label = Instance.new("TextLabel", sliderFrame)
    label.Size = UDim2.new(0.4, 0, 1, 0)
    label.Text = name
    label.TextColor3 = Colors.Text
    label.BackgroundTransparency = 1
    label.TextSize = 14

    local sliderBar = Instance.new("Frame", sliderFrame)
    sliderBar.Size = UDim2.new(0.6, -10, 0, 5)
    sliderBar.Position = UDim2.new(0.4, 5, 0.5, -2.5)
    sliderBar.BackgroundColor3 = Colors.SliderBar
    local barCorner = Instance.new("UICorner", sliderBar)
    barCorner.CornerRadius = UDim.new(0, 5)

    local sliderButton = Instance.new("TextButton", sliderBar)
    sliderButton.Size = UDim2.new(0, 10, 0, 10)
    sliderButton.Position = UDim2.new((default - min) / (max - min), -5, 0, -2.5)
    sliderButton.BackgroundColor3 = Colors.Text
    sliderButton.Text = ""
    local btnCorner = Instance.new("UICorner", sliderButton)
    btnCorner.CornerRadius = UDim.new(0, 5)

    local function updateValue()
        local value = min + (sliderButton.Position.X.Scale * (max - min))
        value = math.clamp(math.floor(value + 0.5), min, max)
        callback(value)
    end

    sliderButton.MouseButton1Down:Connect(function()
        local mouse = Players.LocalPlayer:GetMouse()
        local connection
        connection = mouse.Move:Connect(function()
            local x = math.clamp((mouse.X - sliderBar.AbsolutePosition.X) / sliderBar.AbsoluteSize.X, 0, 1)
            sliderButton.Position = UDim2.new(x, -5, 0, -2.5)
            updateValue()
        end)
        mouse.Button1Up:Connect(function()
            connection:Disconnect()
        end)
    end)

    table.insert(self.Elements, sliderFrame)
    return sliderFrame
end

function Tab:Toggle(name, default, callback)
    local toggleButton = Instance.new("TextButton", self.ContentFrame)
    toggleButton.Size = UDim2.new(1, -10, 0, 30)
    toggleButton.Text = name .. ": " .. (default and "On" or "Off")
    toggleButton.TextColor3 = Colors.Text
    toggleButton.BackgroundColor3 = default and Colors.ToggleOn or Colors.ToggleOff
    toggleButton.BorderSizePixel = 0
    toggleButton.LayoutOrder = #self.Elements
    local togCorner = Instance.new("UICorner", toggleButton)
    togCorner.CornerRadius = UDim.new(0, 5)
    local state = default
    toggleButton.MouseButton1Click:Connect(function()
        state = not state
        toggleButton.Text = name .. ": " .. (state and "On" or "Off")
        toggleButton.BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff
        callback(state)
    end)
    table.insert(self.Elements, toggleButton)
    return toggleButton
end

function Tab:Label(text)
    local label = Instance.new("TextLabel", self.ContentFrame)
    label.Size = UDim2.new(1, -10, 0, 30)
    label.Text = text
    label.TextColor3 = Colors.Text
    label.BackgroundTransparency = 1
    label.TextSize = 14
    label.LayoutOrder = #self.Elements
    table.insert(self.Elements, label)
    return label
end

-- Library Function
function PickleUI:CreateWindow(name)
    return Window.new(name)
end

return PickleUI

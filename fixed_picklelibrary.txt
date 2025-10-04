-- Scripts Hub X | Official UI Library
-- Made by pickletalk
-- Version 1.1.0 - FULLY FIXED
-- Easy to use, clean animations, full functionality

local Library = {}
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")

-- Configuration
local ConfigFolder = "ScriptsHubX"
local ConfigFile = "Scripts Hub X | Official - config"

-- Themes
local Themes = {
    Atlantic = {
        Primary = Color3.fromRGB(52, 73, 94),
        Secondary = Color3.fromRGB(41, 57, 73),
        Accent = Color3.fromRGB(52, 152, 219),
        Text = Color3.fromRGB(236, 240, 241),
        Background = Color3.fromRGB(44, 62, 80)
    },
    Galaxy = {
        Primary = Color3.fromRGB(25, 25, 50),
        Secondary = Color3.fromRGB(15, 15, 35),
        Accent = Color3.fromRGB(138, 43, 226),
        Text = Color3.fromRGB(255, 255, 255),
        Background = Color3.fromRGB(20, 20, 40)
    },
    Sunset = {
        Primary = Color3.fromRGB(255, 94, 77),
        Secondary = Color3.fromRGB(229, 57, 53),
        Accent = Color3.fromRGB(255, 167, 38),
        Text = Color3.fromRGB(255, 255, 255),
        Background = Color3.fromRGB(244, 67, 54)
    },
    Ocean = {
        Primary = Color3.fromRGB(0, 105, 148),
        Secondary = Color3.fromRGB(0, 77, 109),
        Accent = Color3.fromRGB(0, 188, 212),
        Text = Color3.fromRGB(255, 255, 255),
        Background = Color3.fromRGB(0, 96, 136)
    },
    Forest = {
        Primary = Color3.fromRGB(27, 94, 32),
        Secondary = Color3.fromRGB(20, 70, 24),
        Accent = Color3.fromRGB(102, 187, 106),
        Text = Color3.fromRGB(255, 255, 255),
        Background = Color3.fromRGB(46, 125, 50)
    },
    Midnight = {
        Primary = Color3.fromRGB(18, 18, 24),
        Secondary = Color3.fromRGB(12, 12, 16),
        Accent = Color3.fromRGB(88, 101, 242),
        Text = Color3.fromRGB(255, 255, 255),
        Background = Color3.fromRGB(15, 15, 20)
    },
    Cherry = {
        Primary = Color3.fromRGB(136, 14, 79),
        Secondary = Color3.fromRGB(106, 11, 62),
        Accent = Color3.fromRGB(233, 30, 99),
        Text = Color3.fromRGB(255, 255, 255),
        Background = Color3.fromRGB(123, 31, 162)
    },
    Emerald = {
        Primary = Color3.fromRGB(0, 105, 92),
        Secondary = Color3.fromRGB(0, 77, 64),
        Accent = Color3.fromRGB(0, 200, 83),
        Text = Color3.fromRGB(255, 255, 255),
        Background = Color3.fromRGB(0, 121, 107)
    },
    Gold = {
        Primary = Color3.fromRGB(245, 166, 35),
        Secondary = Color3.fromRGB(230, 145, 0),
        Accent = Color3.fromRGB(255, 202, 40),
        Text = Color3.fromRGB(33, 33, 33),
        Background = Color3.fromRGB(255, 179, 0)
    },
    Arctic = {
        Primary = Color3.fromRGB(176, 190, 197),
        Secondary = Color3.fromRGB(144, 164, 174),
        Accent = Color3.fromRGB(79, 195, 247),
        Text = Color3.fromRGB(33, 33, 33),
        Background = Color3.fromRGB(207, 216, 220)
    }
}

local CurrentTheme = "Atlantic"
local CurrentConfig = {}

-- Utility Functions
local function Tween(instance, properties, duration, easingStyle, easingDirection)
    duration = duration or 0.3
    easingStyle = easingStyle or Enum.EasingStyle.Quad
    easingDirection = easingDirection or Enum.EasingDirection.Out
    
    local tween = TweenService:Create(instance, TweenInfo.new(duration, easingStyle, easingDirection), properties)
    tween:Play()
    return tween
end

local function CreateRipple(button, x, y)
    local ripple = Instance.new("ImageLabel")
    ripple.Name = "Ripple"
    ripple.BackgroundTransparency = 1
    ripple.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    ripple.ImageColor3 = Color3.fromRGB(255, 255, 255)
    ripple.ImageTransparency = 0.5
    ripple.Size = UDim2.new(0, 0, 0, 0)
    ripple.Position = UDim2.new(0, x, 0, y)
    ripple.AnchorPoint = Vector2.new(0.5, 0.5)
    ripple.ZIndex = button.ZIndex + 1
    ripple.Parent = button
    
    local size = math.max(button.AbsoluteSize.X, button.AbsoluteSize.Y) * 2
    Tween(ripple, {Size = UDim2.new(0, size, 0, size), ImageTransparency = 1}, 0.5)
    
    task.delay(0.5, function()
        ripple:Destroy()
    end)
end

-- Main Library Function
function Library:CreateWindow(config)
    config = config or {}
    config.Name = config.Name or "Scripts Hub X | Official"
    config.Transparency = config.Transparency or 0
    
    -- Create ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ScriptsHubX"
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = CoreGui
    
    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 600, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
    MainFrame.BackgroundColor3 = Themes[CurrentTheme].Primary
    MainFrame.BackgroundTransparency = config.Transparency
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainFrame
    
    -- Drop Shadow
    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.BackgroundTransparency = 1
    Shadow.Position = UDim2.new(0, -15, 0, -15)
    Shadow.Size = UDim2.new(1, 30, 1, 30)
    Shadow.ZIndex = 0
    Shadow.Image = "rbxassetid://6015897843"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(49, 49, 450, 450)
    Shadow.Parent = MainFrame
    
    -- Title Bar
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Themes[CurrentTheme].Secondary
    TitleBar.BackgroundTransparency = config.Transparency
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 12)
    TitleCorner.Parent = TitleBar
    
    local TitleCover = Instance.new("Frame")
    TitleCover.Size = UDim2.new(1, 0, 0, 20)
    TitleCover.Position = UDim2.new(0, 0, 1, -20)
    TitleCover.BackgroundColor3 = Themes[CurrentTheme].Secondary
    TitleCover.BackgroundTransparency = config.Transparency
    TitleCover.BorderSizePixel = 0
    TitleCover.Parent = TitleBar
    
    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -100, 1, 0)
    Title.Position = UDim2.new(0, 15, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Text = config.Name
    Title.TextColor3 = Themes[CurrentTheme].Text
    Title.TextSize = 18
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TitleBar
    
    -- Minimize Button - FIXED ICON
    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Name = "MinimizeBtn"
    MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
    MinimizeBtn.Position = UDim2.new(1, -40, 0, 5)
    MinimizeBtn.BackgroundTransparency = 1
    MinimizeBtn.Text = "_"
    MinimizeBtn.TextColor3 = Themes[CurrentTheme].Text
    MinimizeBtn.TextSize = 20
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.Parent = TitleBar
    
    local Minimized = false
    local OriginalSize = MainFrame.Size
    
    MinimizeBtn.MouseButton1Click:Connect(function()
        Minimized = not Minimized
        if Minimized then
            Tween(MainFrame, {Size = UDim2.new(0, 600, 0, 40)}, 0.4)
            MinimizeBtn.Text = "+"
        else
            Tween(MainFrame, {Size = OriginalSize}, 0.4)
            MinimizeBtn.Text = "_"
        end
    end)
    
    -- Tab Container
    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(0, 150, 1, -50)
    TabContainer.Position = UDim2.new(0, 10, 0, 45)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame
    
    local TabList = Instance.new("UIListLayout")
    TabList.SortOrder = Enum.SortOrder.LayoutOrder
    TabList.Padding = UDim.new(0, 5)
    TabList.Parent = TabContainer
    
    -- Content Container
    local ContentContainer = Instance.new("Frame")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -175, 1, -55)
    ContentContainer.Position = UDim2.new(0, 165, 0, 45)
    ContentContainer.BackgroundColor3 = Themes[CurrentTheme].Background
    ContentContainer.BackgroundTransparency = config.Transparency
    ContentContainer.BorderSizePixel = 0
    ContentContainer.Parent = MainFrame
    
    local ContentCorner = Instance.new("UICorner")
    ContentCorner.CornerRadius = UDim.new(0, 8)
    ContentCorner.Parent = ContentContainer
    
    -- Dragging
    local dragging, dragInput, dragStart, startPos
    
    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Window Object
    local Window = {
        Tabs = {},
        TabsByName = {}, -- NEW: Store tabs by name for easy access
        CurrentTab = nil,
        Elements = {},
        ScreenGui = ScreenGui,
        MainFrame = MainFrame,
        Transparency = config.Transparency
    }
    
    -- Apply Theme Function
    function Window:ApplyTheme(themeName)
        if not Themes[themeName] then return end
        CurrentTheme = themeName
        local theme = Themes[themeName]
        
        Tween(MainFrame, {BackgroundColor3 = theme.Primary}, 0.3)
        Tween(TitleBar, {BackgroundColor3 = theme.Secondary}, 0.3)
        Tween(TitleCover, {BackgroundColor3 = theme.Secondary}, 0.3)
        Tween(ContentContainer, {BackgroundColor3 = theme.Background}, 0.3)
        Tween(Title, {TextColor3 = theme.Text}, 0.3)
        MinimizeBtn.TextColor3 = theme.Text
        
        for _, tab in pairs(Window.Tabs) do
            Tween(tab.Button, {BackgroundColor3 = theme.Secondary}, 0.3)
            Tween(tab.Button.Label, {TextColor3 = theme.Text}, 0.3)
            if tab == Window.CurrentTab then
                Tween(tab.Button, {BackgroundColor3 = theme.Accent}, 0.3)
            end
        end
    end
    
    -- Set Transparency Function
    function Window:SetTransparency(value)
        Window.Transparency = value
        MainFrame.BackgroundTransparency = value
        TitleBar.BackgroundTransparency = value
        TitleCover.BackgroundTransparency = value
        ContentContainer.BackgroundTransparency = value
        
        for _, element in pairs(Window.Elements) do
            if element.Frame then
                element.Frame.BackgroundTransparency = value
            end
        end
    end
    
    -- Create Tab Function - FIXED: Check for duplicates
    function Window:CreateTab(name)
        -- Check if tab already exists
        if Window.TabsByName[name] then
            return Window.TabsByName[name]
        end
        
        local Tab = {
            Name = name,
            Elements = {},
            Visible = false
        }
        
        -- Tab Button
        local TabButton = Instance.new("TextButton")
        TabButton.Name = name
        TabButton.Size = UDim2.new(1, 0, 0, 35)
        TabButton.BackgroundColor3 = Themes[CurrentTheme].Secondary
        TabButton.BackgroundTransparency = Window.Transparency
        TabButton.BorderSizePixel = 0
        TabButton.AutoButtonColor = false
        TabButton.Text = ""
        TabButton.Parent = TabContainer
        
        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 6)
        TabCorner.Parent = TabButton
        
        local TabLabel = Instance.new("TextLabel")
        TabLabel.Name = "Label"
        TabLabel.Size = UDim2.new(1, -10, 1, 0)
        TabLabel.Position = UDim2.new(0, 5, 0, 0)
        TabLabel.BackgroundTransparency = 1
        TabLabel.Text = name
        TabLabel.TextColor3 = Themes[CurrentTheme].Text
        TabLabel.TextSize = 14
        TabLabel.Font = Enum.Font.GothamSemibold
        TabLabel.TextXAlignment = Enum.TextXAlignment.Left
        TabLabel.Parent = TabButton
        
        -- Tab Content
        local TabContent = Instance.new("ScrollingFrame")
        TabContent.Name = name .. "Content"
        TabContent.Size = UDim2.new(1, -20, 1, -20)
        TabContent.Position = UDim2.new(0, 10, 0, 10)
        TabContent.BackgroundTransparency = 1
        TabContent.BorderSizePixel = 0
        TabContent.ScrollBarThickness = 4
        TabContent.ScrollBarImageColor3 = Themes[CurrentTheme].Accent
        TabContent.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabContent.Visible = false
        TabContent.Parent = ContentContainer
        
        local ContentList = Instance.new("UIListLayout")
        ContentList.SortOrder = Enum.SortOrder.LayoutOrder
        ContentList.Padding = UDim.new(0, 8)
        ContentList.Parent = TabContent
        
        ContentList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentList.AbsoluteContentSize.Y + 10)
        end)
        
        Tab.Button = TabButton
        Tab.Content = TabContent
        
        -- Tab Click
        TabButton.MouseButton1Click:Connect(function()
            CreateRipple(TabButton, TabButton.AbsoluteSize.X / 2, TabButton.AbsoluteSize.Y / 2)
            
            for _, tab in pairs(Window.Tabs) do
                tab.Visible = false
                tab.Content.Visible = false
                Tween(tab.Button, {BackgroundColor3 = Themes[CurrentTheme].Secondary}, 0.2)
            end
            
            Tab.Visible = true
            TabContent.Visible = true
            Tween(TabButton, {BackgroundColor3 = Themes[CurrentTheme].Accent}, 0.2)
            Window.CurrentTab = Tab
        end)
        
        -- Hover Effects
        TabButton.MouseEnter:Connect(function()
            if not Tab.Visible then
                Tween(TabButton, {BackgroundColor3 = Themes[CurrentTheme].Accent}, 0.2)
            end
        end)
        
        TabButton.MouseLeave:Connect(function()
            if not Tab.Visible then
                Tween(TabButton, {BackgroundColor3 = Themes[CurrentTheme].Secondary}, 0.2)
            end
        end)
        
        table.insert(Window.Tabs, Tab)
        Window.TabsByName[name] = Tab -- NEW: Store by name
        
        if #Window.Tabs == 1 then
            TabButton.MouseButton1Click:Fire()
        end
        
        -- Tab Elements
        function Tab:CreateToggle(options)
            options = options or {}
            options.Name = options.Name or "Toggle"
            options.Default = options.Default or false
            options.Callback = options.Callback or function() end
            
            local ToggleState = options.Default
            CurrentConfig[options.Name] = ToggleState
            
            local ToggleFrame = Instance.new("Frame")
            ToggleFrame.Name = options.Name
            ToggleFrame.Size = UDim2.new(1, 0, 0, 40)
            ToggleFrame.BackgroundColor3 = Themes[CurrentTheme].Secondary
            ToggleFrame.BackgroundTransparency = Window.Transparency
            ToggleFrame.BorderSizePixel = 0
            ToggleFrame.Parent = TabContent
            
            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 6)
            ToggleCorner.Parent = ToggleFrame
            
            local ToggleLabel = Instance.new("TextLabel")
            ToggleLabel.Size = UDim2.new(1, -60, 1, 0)
            ToggleLabel.Position = UDim2.new(0, 10, 0, 0)
            ToggleLabel.BackgroundTransparency = 1
            ToggleLabel.Text = options.Name
            ToggleLabel.TextColor3 = Themes[CurrentTheme].Text
            ToggleLabel.TextSize = 14
            ToggleLabel.Font = Enum.Font.Gotham
            ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
            ToggleLabel.Parent = ToggleFrame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 45, 0, 25)
            ToggleButton.Position = UDim2.new(1, -55, 0.5, -12.5)
            ToggleButton.BackgroundColor3 = ToggleState and Themes[CurrentTheme].Accent or Color3.fromRGB(80, 80, 80)
            ToggleButton.BorderSizePixel = 0
            ToggleButton.AutoButtonColor = false
            ToggleButton.Text = ""
            ToggleButton.Parent = ToggleFrame
            
            local ToggleBtnCorner = Instance.new("UICorner")
            ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
            ToggleBtnCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 21, 0, 21)
            ToggleCircle.Position = ToggleState and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle
            
            ToggleButton.MouseButton1Click:Connect(function()
                ToggleState = not ToggleState
                CurrentConfig[options.Name] = ToggleState
                
                Tween(ToggleButton, {BackgroundColor3 = ToggleState and Themes[CurrentTheme].Accent or Color3.fromRGB(80, 80, 80)}, 0.3)
                Tween(ToggleCircle, {Position = ToggleState and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)}, 0.3, Enum.EasingStyle.Back)
                
                task.spawn(options.Callback, ToggleState)
            end)
            
            table.insert(Window.Elements, {Frame = ToggleFrame, Type = "Toggle", Name = options.Name})
            table.insert(Tab.Elements, {Frame = ToggleFrame, Type = "Toggle", Name = options.Name})
            
            return {
                SetValue = function(value)
                    ToggleState = value
                    CurrentConfig[options.Name] = ToggleState
                    Tween(ToggleButton, {BackgroundColor3 = ToggleState and Themes[CurrentTheme].Accent or Color3.fromRGB(80, 80, 80)}, 0.3)
                    Tween(ToggleCircle, {Position = ToggleState and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)}, 0.3)
                end
            }
        end
        
        function Tab:CreateButton(options)
            options = options or {}
            options.Name = options.Name or "Button"
            options.Callback = options.Callback or function() end
            
            local ButtonFrame = Instance.new("TextButton")
            ButtonFrame.Name = options.Name
            ButtonFrame.Size = UDim2.new(1, 0, 0, 40)
            ButtonFrame.BackgroundColor3 = Themes[CurrentTheme].Secondary
            ButtonFrame.BackgroundTransparency = Window.Transparency
            ButtonFrame.BorderSizePixel = 0
            ButtonFrame.AutoButtonColor = false
            ButtonFrame.Text = ""
            ButtonFrame.Parent = TabContent
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 6)
            ButtonCorner.Parent = ButtonFrame
            
            local ButtonLabel = Instance.new("TextLabel")
            ButtonLabel.Size = UDim2.new(1, -20, 1, 0)
            ButtonLabel.Position = UDim2.new(0, 10, 0, 0)
            ButtonLabel.BackgroundTransparency = 1
            ButtonLabel.Text = options.Name
            ButtonLabel.TextColor3 = Themes[CurrentTheme].Text
            ButtonLabel.TextSize = 14
            ButtonLabel.Font = Enum.Font.Gotham
            ButtonLabel.TextXAlignment = Enum.TextXAlignment.Left
            ButtonLabel.Parent = ButtonFrame
            
            ButtonFrame.MouseButton1Click:Connect(function()
                CreateRipple(ButtonFrame, ButtonFrame.AbsoluteSize.X / 2, ButtonFrame.AbsoluteSize.Y / 2)
                task.spawn(options.Callback)
            end)
            
            ButtonFrame.MouseEnter:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Themes[CurrentTheme].Accent}, 0.2)
            end)
            
            ButtonFrame.MouseLeave:Connect(function()
                Tween(ButtonFrame, {BackgroundColor3 = Themes[CurrentTheme].Secondary}, 0.2)
            end)
            
            table.insert(Window.Elements, {Frame = ButtonFrame, Type = "Button", Name = options.Name})
            table.insert(Tab.Elements, {Frame = ButtonFrame, Type = "Button", Name = options.Name})
        end
        
        function Tab:CreateInput(options)
            options = options or {}
            options.Name = options.Name or "Input"
            options.PlaceholderText = options.PlaceholderText or "Enter text..."
            options.Type = options.Type or "string"
            options.Default = options.Default or ""
            options.Callback = options.Callback or function() end
            
            CurrentConfig[options.Name] = options.Default
            
            local InputFrame = Instance.new("Frame")
            InputFrame.Name = options.Name
            InputFrame.Size = UDim2.new(1, 0, 0, 70)
            InputFrame.BackgroundColor3 = Themes[CurrentTheme].Secondary
            InputFrame.BackgroundTransparency = Window.Transparency
            InputFrame.BorderSizePixel = 0
            InputFrame.Parent = TabContent
            
            local InputCorner = Instance.new("UICorner")
            InputCorner.CornerRadius = UDim.new(0, 6)
            InputCorner.Parent = InputFrame
            
            local InputLabel = Instance.new("TextLabel")
            InputLabel.Size = UDim2.new(1, -20, 0, 25)
            InputLabel.Position = UDim2.new(0, 10, 0, 5)
            InputLabel.BackgroundTransparency = 1
            InputLabel.Text = options.Name
            InputLabel.TextColor3 = Themes[CurrentTheme].Text
            InputLabel.TextSize = 14
            InputLabel.Font = Enum.Font.Gotham
            InputLabel.TextXAlignment = Enum.TextXAlignment.Left
            InputLabel.Parent = InputFrame
            
            local InputBox = Instance.new("TextBox")
            InputBox.Size = UDim2.new(1, -20, 0, 30)
            InputBox.Position = UDim2.new(0, 10, 0, 32)
            InputBox.BackgroundColor3 = Themes[CurrentTheme].Background
            InputBox.BackgroundTransparency = Window.Transparency
            InputBox.BorderSizePixel = 0
            InputBox.Text = tostring(options.Default)
            InputBox.PlaceholderText = options.PlaceholderText
            InputBox.TextColor3 = Themes[CurrentTheme].Text
            InputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
            InputBox.TextSize = 13
            InputBox.Font = Enum.Font.Gotham
            InputBox.ClearButtonMode = Enum.TextBoxClearButtonMode.WhileEditing
            InputBox.Parent = InputFrame
            
            local InputBoxCorner = Instance.new("UICorner")
            InputBoxCorner.CornerRadius = UDim.new(0, 4)
            InputBoxCorner.Parent = InputBox
            
            if options.Type == "int" or options.Type == "number" then
                InputBox.TextChanged:Connect(function()
                    local text = InputBox.Text
                    local filtered = text:gsub("[^%d.-]", "")
                    if filtered ~= text then
                        InputBox.Text = filtered
                    end
                end)
            end
            
            InputBox.FocusLost:Connect(function()
                local value = InputBox.Text
                if options.Type == "int" then
                    value = tonumber(value) or 0
                    value = math.floor(value)
                    InputBox.Text = tostring(value)
                elseif options.Type == "number" then
                    value = tonumber(value) or 0
                    InputBox.Text = tostring(value)
                end
                
                CurrentConfig[options.Name] = value
                task.spawn(options.Callback, value)
            end)
            
            table.insert(Window.Elements, {Frame = InputFrame, Type = "Input", Name = options.Name})
            table.insert(Tab.Elements, {Frame = InputFrame, Type = "Input", Name = options.Name})
            
            return {
                SetValue = function(value)
                    if options.Type == "int" then
                        value = math.floor(tonumber(value) or 0)
                    elseif options.Type == "number" then
                        value = tonumber(value) or 0
                    end
                    InputBox.Text = tostring(value)
                    CurrentConfig[options.Name] = value
                end
            }
        end
        
        function Tab:CreateToggleWithInput(options)
            options = options or {}
            options.Name = options.Name or "Toggle with Input"
            options.ToggleDefault = options.ToggleDefault or false
            options.InputType = options.InputType or "string"
            options.InputDefault = options.InputDefault or ""
            options.PlaceholderText = options.PlaceholderText or "Enter value..."
            options.Callback = options.Callback or function() end
            
            local ToggleState = options.ToggleDefault
            local InputValue = options.InputDefault
            CurrentConfig[options.Name] = {Toggle = ToggleState, Value = InputValue}
            
            local Frame = Instance.new("Frame")
            Frame.Name = options.Name
            Frame.Size = UDim2.new(1, 0, 0, 90)
            Frame.BackgroundColor3 = Themes[CurrentTheme].Secondary
            Frame.BackgroundTransparency = Window.Transparency
            Frame.BorderSizePixel = 0
            Frame.Parent = TabContent
            
            local FrameCorner = Instance.new("UICorner")
            FrameCorner.CornerRadius = UDim.new(0, 6)
            FrameCorner.Parent = Frame
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -60, 0, 25)
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.BackgroundTransparency = 1
            Label.Text = options.Name
            Label.TextColor3 = Themes[CurrentTheme].Text
            Label.TextSize = 14
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame
            
            local ToggleButton = Instance.new("TextButton")
            ToggleButton.Size = UDim2.new(0, 45, 0, 25)
            ToggleButton.Position = UDim2.new(1, -55, 0, 5)
            ToggleButton.BackgroundColor3 = ToggleState and Themes[CurrentTheme].Accent or Color3.fromRGB(80, 80, 80)
            ToggleButton.BorderSizePixel = 0
            ToggleButton.AutoButtonColor = false
            ToggleButton.Text = ""
            ToggleButton.Parent = Frame
            
            local ToggleBtnCorner = Instance.new("UICorner")
            ToggleBtnCorner.CornerRadius = UDim.new(1, 0)
            ToggleBtnCorner.Parent = ToggleButton
            
            local ToggleCircle = Instance.new("Frame")
            ToggleCircle.Size = UDim2.new(0, 21, 0, 21)
            ToggleCircle.Position = ToggleState and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
            ToggleCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ToggleCircle.BorderSizePixel = 0
            ToggleCircle.Parent = ToggleButton
            
            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = ToggleCircle
            
            local InputLabel = Instance.new("TextLabel")
            InputLabel.Size = UDim2.new(1, -20, 0, 20)
            InputLabel.Position = UDim2.new(0, 10, 0, 35)
            InputLabel.BackgroundTransparency = 1
            InputLabel.Text = "Value:"
            InputLabel.TextColor3 = Themes[CurrentTheme].Text
            InputLabel.TextSize = 12
            InputLabel.Font = Enum.Font.Gotham
            InputLabel.TextXAlignment = Enum.TextXAlignment.Left
            InputLabel.Parent = Frame
            
            local InputBox = Instance.new("TextBox")
            InputBox.Size = UDim2.new(1, -20, 0, 30)
            InputBox.Position = UDim2.new(0, 10, 0, 55)
            InputBox.BackgroundColor3 = Themes[CurrentTheme].Background
            InputBox.BackgroundTransparency = Window.Transparency
            InputBox.BorderSizePixel = 0
            InputBox.Text = tostring(options.InputDefault)
            InputBox.PlaceholderText = options.PlaceholderText
            InputBox.TextColor3 = Themes[CurrentTheme].Text
            InputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
            InputBox.TextSize = 13
            InputBox.Font = Enum.Font.Gotham
            InputBox.Parent = Frame
            
            local InputBoxCorner = Instance.new("UICorner")
            InputBoxCorner.CornerRadius = UDim.new(0, 4)
            InputBoxCorner.Parent = InputBox
            
            if options.InputType == "int" or options.InputType == "number" then
                InputBox.TextChanged:Connect(function()
                    local text = InputBox.Text
                    local filtered = text:gsub("[^%d.-]", "")
                    if filtered ~= text then
                        InputBox.Text = filtered
                    end
                end)
            end
            
            ToggleButton.MouseButton1Click:Connect(function()
                ToggleState = not ToggleState
                CurrentConfig[options.Name] = {Toggle = ToggleState, Value = InputValue}
                
                Tween(ToggleButton, {BackgroundColor3 = ToggleState and Themes[CurrentTheme].Accent or Color3.fromRGB(80, 80, 80)}, 0.3)
                Tween(ToggleCircle, {Position = ToggleState and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)}, 0.3, Enum.EasingStyle.Back)
                
                task.spawn(options.Callback, ToggleState, InputValue)
            end)
            
            InputBox.FocusLost:Connect(function()
                local value = InputBox.Text
                if options.InputType == "int" then
                    value = tonumber(value) or 0
                    value = math.floor(value)
                    InputBox.Text = tostring(value)
                elseif options.InputType == "number" then
                    value = tonumber(value) or 0
                    InputBox.Text = tostring(value)
                end
                
                InputValue = value
                CurrentConfig[options.Name] = {Toggle = ToggleState, Value = InputValue}
                task.spawn(options.Callback, ToggleState, InputValue)
            end)
            
            table.insert(Window.Elements, {Frame = Frame, Type = "ToggleInput", Name = options.Name})
            table.insert(Tab.Elements, {Frame = Frame, Type = "ToggleInput", Name = options.Name})
        end
        
        function Tab:CreateButtonWithInput(options)
            options = options or {}
            options.Name = options.Name or "Button with Input"
            options.InputType = options.InputType or "string"
            options.InputDefault = options.InputDefault or ""
            options.PlaceholderText = options.PlaceholderText or "Enter value..."
            options.Callback = options.Callback or function() end
            
            local InputValue = options.InputDefault
            CurrentConfig[options.Name] = InputValue
            
            local Frame = Instance.new("Frame")
            Frame.Name = options.Name
            Frame.Size = UDim2.new(1, 0, 0, 100)
            Frame.BackgroundColor3 = Themes[CurrentTheme].Secondary
            Frame.BackgroundTransparency = Window.Transparency
            Frame.BorderSizePixel = 0
            Frame.Parent = TabContent
            
            local FrameCorner = Instance.new("UICorner")
            FrameCorner.CornerRadius = UDim.new(0, 6)
            FrameCorner.Parent = Frame
            
            local Label = Instance.new("TextLabel")
            Label.Size = UDim2.new(1, -20, 0, 25)
            Label.Position = UDim2.new(0, 10, 0, 5)
            Label.BackgroundTransparency = 1
            Label.Text = options.Name
            Label.TextColor3 = Themes[CurrentTheme].Text
            Label.TextSize = 14
            Label.Font = Enum.Font.Gotham
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.Parent = Frame
            
            local InputLabel = Instance.new("TextLabel")
            InputLabel.Size = UDim2.new(1, -20, 0, 20)
            InputLabel.Position = UDim2.new(0, 10, 0, 32)
            InputLabel.BackgroundTransparency = 1
            InputLabel.Text = "Value:"
            InputLabel.TextColor3 = Themes[CurrentTheme].Text
            InputLabel.TextSize = 12
            InputLabel.Font = Enum.Font.Gotham
            InputLabel.TextXAlignment = Enum.TextXAlignment.Left
            InputLabel.Parent = Frame
            
            local InputBox = Instance.new("TextBox")
            InputBox.Size = UDim2.new(0.6, -10, 0, 30)
            InputBox.Position = UDim2.new(0, 10, 0, 52)
            InputBox.BackgroundColor3 = Themes[CurrentTheme].Background
            InputBox.BackgroundTransparency = Window.Transparency
            InputBox.BorderSizePixel = 0
            InputBox.Text = tostring(options.InputDefault)
            InputBox.PlaceholderText = options.PlaceholderText
            InputBox.TextColor3 = Themes[CurrentTheme].Text
            InputBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 150)
            InputBox.TextSize = 13
            InputBox.Font = Enum.Font.Gotham
            InputBox.Parent = Frame
            
            local InputBoxCorner = Instance.new("UICorner")
            InputBoxCorner.CornerRadius = UDim.new(0, 4)
            InputBoxCorner.Parent = InputBox
            
            local ExecuteButton = Instance.new("TextButton")
            ExecuteButton.Size = UDim2.new(0.4, -15, 0, 30)
            ExecuteButton.Position = UDim2.new(0.6, 5, 0, 52)
            ExecuteButton.BackgroundColor3 = Themes[CurrentTheme].Accent
            ExecuteButton.BorderSizePixel = 0
            ExecuteButton.Text = "Execute"
            ExecuteButton.TextColor3 = Themes[CurrentTheme].Text
            ExecuteButton.TextSize = 13
            ExecuteButton.Font = Enum.Font.GothamSemibold
            ExecuteButton.AutoButtonColor = false
            ExecuteButton.Parent = Frame
            
            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 4)
            BtnCorner.Parent = ExecuteButton
            
            if options.InputType == "int" or options.InputType == "number" then
                InputBox.TextChanged:Connect(function()
                    local text = InputBox.Text
                    local filtered = text:gsub("[^%d.-]", "")
                    if filtered ~= text then
                        InputBox.Text = filtered
                    end
                end)
            end
            
            InputBox.FocusLost:Connect(function()
                local value = InputBox.Text
                if options.InputType == "int" then
                    value = tonumber(value) or 0
                    value = math.floor(value)
                    InputBox.Text = tostring(value)
                elseif options.InputType == "number" then
                    value = tonumber(value) or 0
                    InputBox.Text = tostring(value)
                end
                
                InputValue = value
                CurrentConfig[options.Name] = InputValue
            end)
            
            ExecuteButton.MouseButton1Click:Connect(function()
                CreateRipple(ExecuteButton, ExecuteButton.AbsoluteSize.X / 2, ExecuteButton.AbsoluteSize.Y / 2)
                task.spawn(options.Callback, InputValue)
            end)
            
            ExecuteButton.MouseEnter:Connect(function()
                Tween(ExecuteButton, {BackgroundColor3 = Themes[CurrentTheme].Primary}, 0.2)
            end)
            
            ExecuteButton.MouseLeave:Connect(function()
                Tween(ExecuteButton, {BackgroundColor3 = Themes[CurrentTheme].Accent}, 0.2)
            end)
            
            table.insert(Window.Elements, {Frame = Frame, Type = "ButtonInput", Name = options.Name})
            table.insert(Tab.Elements, {Frame = Frame, Type = "ButtonInput", Name = options.Name})
        end
        
        return Tab
    end
    
    -- ========================================
    -- AUTO-CREATE SETTINGS TAB (Built-in)
    -- ========================================
    local SettingsTab = Window:CreateTab("Settings")
    
    -- Save Configuration Button
    SettingsTab:CreateButton({
        Name = "Save Configuration",
        Callback = function()
            CurrentConfig.Theme = CurrentTheme
            CurrentConfig.Transparency = Window.Transparency
            
            local success, err = pcall(function()
                if not isfolder(ConfigFolder) then
                    makefolder(ConfigFolder)
                end
                writefile(ConfigFolder .. "/" .. ConfigFile .. ".json", HttpService:JSONEncode(CurrentConfig))
            end)
            
            if success then
                print("✓ Configuration saved successfully!")
            else
                warn("✗ Error saving configuration:", err)
            end
        end
    })
    
    -- Load Configuration Button
    SettingsTab:CreateButton({
        Name = "Load Configuration",
        Callback = function()
            local success, result = pcall(function()
                return readfile(ConfigFolder .. "/" .. ConfigFile .. ".json")
            end)
            
            if success then
                local config = HttpService:JSONDecode(result)
                
                if config.Theme and Themes[config.Theme] then
                    Window:ApplyTheme(config.Theme)
                end
                
                if config.Transparency then
                    Window:SetTransparency(config.Transparency)
                end
                
                for name, value in pairs(config) do
                    if name ~= "Theme" and name ~= "Transparency" then
                        CurrentConfig[name] = value
                    end
                end
                
                print("✓ Configuration loaded successfully!")
            else
                warn("✗ Configuration file not found!")
            end
        end
    })
    
    -- Transparency Toggle
    SettingsTab:CreateToggle({
        Name = "Transparency Mode",
        Default = Window.Transparency > 0,
        Callback = function(value)
            Window:SetTransparency(value and 0.6 or 0)
        end
    })
    
    -- ========================================
    -- AUTO-CREATE CREDITS TAB (Built-in)
    -- ========================================
    local CreditsTab = Window:CreateTab("Credits")
    
    -- Credits Label Frame
    local CreditsFrame = Instance.new("Frame")
    CreditsFrame.Name = "CreditsFrame"
    CreditsFrame.Size = UDim2.new(1, 0, 0, 100)
    CreditsFrame.BackgroundColor3 = Themes[CurrentTheme].Secondary
    CreditsFrame.BackgroundTransparency = Window.Transparency
    CreditsFrame.BorderSizePixel = 0
    CreditsFrame.Parent = CreditsTab.Content
    
    local CreditsCorner = Instance.new("UICorner")
    CreditsCorner.CornerRadius = UDim.new(0, 6)
    CreditsCorner.Parent = CreditsFrame
    
    local CreditsText = Instance.new("TextLabel")
    CreditsText.Name = "CreditsText"
    CreditsText.Size = UDim2.new(1, -20, 1, -20)
    CreditsText.Position = UDim2.new(0, 10, 0, 10)
    CreditsText.BackgroundTransparency = 1
    CreditsText.Text = "Scripts Hub X | Official\nUI Library v1.1.0\n\nCreated by: pickletalk\nThank you for using our library!"
    CreditsText.TextColor3 = Themes[CurrentTheme].Text
    CreditsText.TextSize = 14
    CreditsText.Font = Enum.Font.Gotham
    CreditsText.TextYAlignment = Enum.TextYAlignment.Top
    CreditsText.TextXAlignment = Enum.TextXAlignment.Left
    CreditsText.TextWrapped = true
    CreditsText.Parent = CreditsFrame
    
    -- Discord Button with Icon - FIXED ICON
    local DiscordFrame = Instance.new("Frame")
    DiscordFrame.Name = "DiscordFrame"
    DiscordFrame.Size = UDim2.new(1, 0, 0, 60)
    DiscordFrame.BackgroundColor3 = Themes[CurrentTheme].Secondary
    DiscordFrame.BackgroundTransparency = Window.Transparency
    DiscordFrame.BorderSizePixel = 0
    DiscordFrame.Parent = CreditsTab.Content
    
    local DiscordFrameCorner = Instance.new("UICorner")
    DiscordFrameCorner.CornerRadius = UDim.new(0, 6)
    DiscordFrameCorner.Parent = DiscordFrame
    
    -- FIXED: Valid Discord icon
    local DiscordIcon = Instance.new("ImageLabel")
    DiscordIcon.Size = UDim2.new(0, 40, 0, 40)
    DiscordIcon.Position = UDim2.new(0, 10, 0.5, -20)
    DiscordIcon.BackgroundTransparency = 1
    DiscordIcon.Image = "rbxassetid://7072707318" -- VALID Discord logo
    DiscordIcon.ImageColor3 = Themes[CurrentTheme].Accent
    DiscordIcon.Parent = DiscordFrame
    
    local DiscordButton = Instance.new("TextButton")
    DiscordButton.Size = UDim2.new(1, -70, 0, 40)
    DiscordButton.Position = UDim2.new(0, 60, 0.5, -20)
    DiscordButton.BackgroundColor3 = Themes[CurrentTheme].Accent
    DiscordButton.BorderSizePixel = 0
    DiscordButton.Text = "Copy Discord Invite"
    DiscordButton.TextColor3 = Themes[CurrentTheme].Text
    DiscordButton.TextSize = 14
    DiscordButton.Font = Enum.Font.GothamSemibold
    DiscordButton.AutoButtonColor = false
    DiscordButton.Parent = DiscordFrame
    
    local DiscordBtnCorner = Instance.new("UICorner")
    DiscordBtnCorner.CornerRadius = UDim.new(0, 6)
    DiscordBtnCorner.Parent = DiscordButton
    
    DiscordButton.MouseButton1Click:Connect(function()
        CreateRipple(DiscordButton, DiscordButton.AbsoluteSize.X / 2, DiscordButton.AbsoluteSize.Y / 2)
        setclipboard("https://discord.gg/bpsNUH5sVb")
        DiscordButton.Text = "✓ Copied to Clipboard!"
        task.wait(2)
        DiscordButton.Text = "Copy Discord Invite"
    end)
    
    DiscordButton.MouseEnter:Connect(function()
        Tween(DiscordButton, {BackgroundColor3 = Themes[CurrentTheme].Primary}, 0.2)
    end)
    
    DiscordButton.MouseLeave:Connect(function()
        Tween(DiscordButton, {BackgroundColor3 = Themes[CurrentTheme].Accent}, 0.2)
    end)
    
    -- Store references for easy access
    Window.SettingsTab = SettingsTab
    Window.CreditsTab = CreditsTab
    Window.CreditsText = CreditsText -- Allow users to modify credits text
    
    return Window
end

return Library

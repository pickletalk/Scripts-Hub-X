local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local function new(class, props)
    local instance = Instance.new(class)
    if props then
        for property, value in pairs(props) do
            if property == "Parent" then
                instance.Parent = value
            else
                pcall(function()
                    instance[property] = value
                end)
            end
        end
    end
    return instance
end

local FileIO = {}
FileIO.exists = function(path)
    return pcall(function() return readfile(path) end)
end

FileIO.read = function(path)
    local success, result = pcall(function() return readfile(path) end)
    return success and result or nil
end

FileIO.write = function(path, data)
    return pcall(function() writefile(path, data) end)
end

FileIO.mkdir = function(path)
    pcall(function() makefolder(path) end)
end

local function tween(object, properties, time, style, direction)
    local success, tweenObject = pcall(function()
        local info = TweenInfo.new(
            time or 0.2,
            style or Enum.EasingStyle.Quad,
            direction or Enum.EasingDirection.Out
        )
        return TweenService:Create(object, info, properties)
    end)
    if success and tweenObject then
        tweenObject:Play()
        return tweenObject
    end
end

-- RGB Color System
local RGBColors = {
    current = Color3.fromRGB(255, 0, 0),
    speed = 2,
    hue = 0
}

function RGBColors:Update()
    self.hue = (self.hue + self.speed) % 360
    local h = self.hue / 60
    local c = 1
    local x = c * (1 - math.abs(h % 2 - 1))
    local m = 0
    
    local r, g, b = 0, 0, 0
    if h < 1 then r, g, b = c, x, 0
    elseif h < 2 then r, g, b = x, c, 0
    elseif h < 3 then r, g, b = 0, c, x
    elseif h < 4 then r, g, b = 0, x, c
    elseif h < 5 then r, g, b = x, 0, c
    else r, g, b = c, 0, x end
    
    r, g, b = (r + m) * 255, (g + m) * 255, (b + m) * 255
    self.current = Color3.fromRGB(r, g, b)
    return self.current
end

local Pickle = {}

function Pickle.CreateWindow(options)
    options = options or {}
    local title = options.Title or "Pickle UI"
    local configFolder = options.ConfigFolder or ("Pickle_" .. title:gsub("%W", ""))
    local configFile = options.ConfigFile or (title .. ".json")
    local rgbEnabled = options.RGB ~= false
    
    FileIO.mkdir(configFolder)
    local configPath = configFolder .. '/' .. configFile
    
    -- Main ScreenGui
    local screenGui = new('ScreenGui', {
        Name = "PickleUI",
        Parent = LocalPlayer:WaitForChild('PlayerGui'),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Main container (smaller size, top-right position)
    local container = new('Frame', {
        Parent = screenGui,
        Size = UDim2.new(0, 420, 0, 300), -- Smaller size
        Position = UDim2.new(1, -430, 0, 10), -- Top-right position
        BackgroundTransparency = 1,
        ZIndex = 1
    })
    
    -- Main window frame
    local mainFrame = new('Frame', {
        Parent = container,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        ZIndex = 2
    })
    
    local mainCorner = new('UICorner', {
        Parent = mainFrame,
        CornerRadius = UDim.new(0, 8)
    })
    
    local mainStroke = new('UIStroke', {
        Parent = mainFrame,
        Thickness = 1,
        Color = Color3.fromRGB(60, 60, 60),
        Transparency = 0.5
    })
    
    -- Title bar
    local titleBar = new('Frame', {
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0,
        ZIndex = 3
    })
    
    local titleCorner = new('UICorner', {
        Parent = titleBar,
        CornerRadius = UDim.new(0, 8)
    })
    
    local titleLabel = new('TextLabel', {
        Parent = titleBar,
        Text = title,
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 10, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4
    })
    
    -- Control buttons
    local closeButton = new('TextButton', {
        Parent = titleBar,
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -30, 0, 5),
        BackgroundColor3 = Color3.fromRGB(196, 43, 28),
        BorderSizePixel = 0,
        Text = "×",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        AutoButtonColor = false,
        ZIndex = 5
    })
    
    local closeCorner = new('UICorner', {
        Parent = closeButton,
        CornerRadius = UDim.new(0, 6)
    })
    
    local minimizeButton = new('TextButton', {
        Parent = titleBar,
        Size = UDim2.new(0, 25, 0, 25),
        Position = UDim2.new(1, -60, 0, 5),
        BackgroundColor3 = Color3.fromRGB(255, 189, 46),
        BorderSizePixel = 0,
        Text = "−",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        AutoButtonColor = false,
        ZIndex = 5
    })
    
    local minCorner = new('UICorner', {
        Parent = minimizeButton,
        CornerRadius = UDim.new(0, 6)
    })
    
    -- Content area
    local contentFrame = new('Frame', {
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 1, -35),
        Position = UDim2.new(0, 0, 0, 35),
        BackgroundTransparency = 1,
        ZIndex = 3
    })
    
    -- Tab navigation (left side)
    local tabFrame = new('Frame', {
        Parent = contentFrame,
        Size = UDim2.new(0, 120, 1, 0),
        BackgroundColor3 = Color3.fromRGB(30, 30, 30),
        BorderSizePixel = 0,
        ZIndex = 4
    })
    
    local tabCorner = new('UICorner', {
        Parent = tabFrame,
        CornerRadius = UDim.new(0, 6)
    })
    
    local tabScrollFrame = new('ScrollingFrame', {
        Parent = tabFrame,
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100),
        ZIndex = 5
    })
    
    tabScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local tabLayout = new('UIListLayout', {
        Parent = tabScrollFrame,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    -- Content area (right side)
    local pageFrame = new('Frame', {
        Parent = contentFrame,
        Size = UDim2.new(1, -125, 1, 0),
        Position = UDim2.new(0, 125, 0, 0),
        BackgroundColor3 = Color3.fromRGB(35, 35, 35),
        BorderSizePixel = 0,
        ZIndex = 4
    })
    
    local pageCorner = new('UICorner', {
        Parent = pageFrame,
        CornerRadius = UDim.new(0, 6)
    })
    
    -- Variables
    local tabs = {}
    local currentTab = nil
    local visible = true
    local minimized = false
    
    -- Dragging functionality
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = container.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            if dragStart and startPos then
                local delta = input.Position - dragStart
                container.Position = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
            end
        end
    end)
    
    -- Button functionality
    closeButton.MouseButton1Click:Connect(function()
        visible = not visible
        if visible then
            container.Visible = true
            tween(container, {Size = UDim2.new(0, 420, 0, 300)}, 0.3, Enum.EasingStyle.Back)
        else
            tween(container, {Size = UDim2.new(0, 0, 0, 0)}, 0.3, Enum.EasingStyle.Back)
            wait(0.3)
            container.Visible = false
        end
    end)
    
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            tween(container, {Size = UDim2.new(0, 420, 0, 35)}, 0.3)
        else
            tween(container, {Size = UDim2.new(0, 420, 0, 300)}, 0.3)
        end
    end)
    
    -- RGB Animation
    if rgbEnabled then
        spawn(function()
            while screenGui and screenGui.Parent do
                local color = RGBColors:Update()
                titleBar.BackgroundColor3 = color:lerp(Color3.fromRGB(20, 20, 20), 0.7)
                mainStroke.Color = color
                wait(0.1)
            end
        end)
    end
    
    -- API Functions
    local Library = {}
    
    function Library:CreateTab(name)
        local tabButton = new('TextButton', {
            Parent = tabScrollFrame,
            Size = UDim2.new(1, 0, 0, 30),
            BackgroundColor3 = Color3.fromRGB(40, 40, 40),
            BorderSizePixel = 0,
            Text = name,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            Font = Enum.Font.Gotham,
            TextSize = 12,
            AutoButtonColor = false,
            ZIndex = 6,
            LayoutOrder = #tabs + 1
        })
        
        local buttonCorner = new('UICorner', {
            Parent = tabButton,
            CornerRadius = UDim.new(0, 6)
        })
        
        local tabContent = new('ScrollingFrame', {
            Parent = pageFrame,
            Size = UDim2.new(1, -10, 1, -10),
            Position = UDim2.new(0, 5, 0, 5),
            BackgroundTransparency = 1,
            ScrollBarThickness = 4,
            ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100),
            Visible = false,
            ZIndex = 5
        })
        
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        local contentLayout = new('UIListLayout', {
            Parent = tabContent,
            Padding = UDim.new(0, 5),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        local contentPadding = new('UIPadding', {
            Parent = tabContent,
            PaddingTop = UDim.new(0, 5),
            PaddingBottom = UDim.new(0, 5)
        })
        
        tabButton.MouseEnter:Connect(function()
            if currentTab ~= tabContent then
                tween(tabButton, {BackgroundColor3 = Color3.fromRGB(50, 50, 50)}, 0.2)
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if currentTab ~= tabContent then
                tween(tabButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2)
            end
        end)
        
        tabButton.MouseButton1Click:Connect(function()
            -- Hide all other tabs
            for _, tab in pairs(tabs) do
                tab.content.Visible = false
                tween(tab.button, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2)
            end
            
            -- Show current tab
            tabContent.Visible = true
            tween(tabButton, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}, 0.2)
            currentTab = tabContent
        end)
        
        local tab = {
            button = tabButton,
            content = tabContent,
            name = name
        }
        
        table.insert(tabs, tab)
        
        -- Auto-select first tab
        if #tabs == 1 then
            tabButton.MouseButton1Click:Fire()
        end
        
        -- Tab methods
        function tab:CreateSection(sectionName)
            local sectionFrame = new('Frame', {
                Parent = tabContent,
                Size = UDim2.new(1, 0, 0, 0),
                BackgroundTransparency = 1,
                ZIndex = 6,
                LayoutOrder = tabContent:GetChildren() and #tabContent:GetChildren() or 1
            })
            
            local sectionLabel = new('TextLabel', {
                Parent = sectionFrame,
                Size = UDim2.new(1, 0, 0, 25),
                BackgroundTransparency = 1,
                Text = sectionName,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamSemibold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 7
            })
            
            local sectionContent = new('Frame', {
                Parent = sectionFrame,
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 25),
                BackgroundTransparency = 1,
                ZIndex = 6
            })
            
            local sectionLayout = new('UIListLayout', {
                Parent = sectionContent,
                Padding = UDim.new(0, 3),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            
            -- Auto-resize section
            sectionLayout.Changed:Connect(function()
                sectionContent.Size = UDim2.new(1, 0, 0, sectionLayout.AbsoluteContentSize.Y)
                sectionFrame.Size = UDim2.new(1, 0, 0, sectionLayout.AbsoluteContentSize.Y + 30)
            end)
            
            local section = {
                frame = sectionFrame,
                content = sectionContent
            }
            
            function section:CreateButton(buttonName, callback)
                local button = new('TextButton', {
                    Parent = sectionContent,
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                    BorderSizePixel = 0,
                    Text = buttonName,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    AutoButtonColor = false,
                    ZIndex = 7,
                    LayoutOrder = #sectionContent:GetChildren()
                })
                
                local buttonCorner = new('UICorner', {
                    Parent = button,
                    CornerRadius = UDim.new(0, 6)
                })
                
                button.MouseEnter:Connect(function()
                    tween(button, {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}, 0.2)
                end)
                
                button.MouseLeave:Connect(function()
                    tween(button, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}, 0.2)
                end)
                
                button.MouseButton1Click:Connect(function()
                    tween(button, {Size = UDim2.new(1, 0, 0, 28)}, 0.1)
                    wait(0.1)
                    tween(button, {Size = UDim2.new(1, 0, 0, 30)}, 0.1)
                    if callback then
                        callback()
                    end
                end)
                
                return button
            end
            
            function section:CreateToggle(toggleName, defaultValue, callback)
                defaultValue = defaultValue or false
                
                local toggleFrame = new('Frame', {
                    Parent = sectionContent,
                    Size = UDim2.new(1, 0, 0, 30),
                    BackgroundTransparency = 1,
                    ZIndex = 7,
                    LayoutOrder = #sectionContent:GetChildren()
                })
                
                local toggleLabel = new('TextLabel', {
                    Parent = toggleFrame,
                    Size = UDim2.new(1, -50, 1, 0),
                    BackgroundTransparency = 1,
                    Text = toggleName,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 8
                })
                
                local toggleButton = new('TextButton', {
                    Parent = toggleFrame,
                    Size = UDim2.new(0, 40, 0, 20),
                    Position = UDim2.new(1, -45, 0, 5),
                    BackgroundColor3 = defaultValue and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(60, 60, 60),
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 8
                })
                
                local toggleCorner = new('UICorner', {
                    Parent = toggleButton,
                    CornerRadius = UDim.new(0, 10)
                })
                
                local toggleIndicator = new('Frame', {
                    Parent = toggleButton,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = defaultValue and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    ZIndex = 9
                })
                
                local indicatorCorner = new('UICorner', {
                    Parent = toggleIndicator,
                    CornerRadius = UDim.new(0, 8)
                })
                
                local toggled = defaultValue
                
                toggleButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    tween(toggleButton, {
                        BackgroundColor3 = toggled and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(60, 60, 60)
                    }, 0.2)
                    tween(toggleIndicator, {
                        Position = toggled and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
                    }, 0.2)
                    
                    if callback then
                        callback(toggled)
                    end
                end)
                
                return {
                    SetValue = function(value)
                        toggled = value
                        toggleButton.BackgroundColor3 = toggled and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(60, 60, 60)
                        toggleIndicator.Position = toggled and UDim2.new(1, -18, 0, 2) or UDim2.new(0, 2, 0, 2)
                    end,
                    GetValue = function()
                        return toggled
                    end
                }
            end
            
            return section
        end
        
        return tab
    end
    
    function Library:Destroy()
        screenGui:Destroy()
    end
    
    function Library:SetVisible(isVisible)
        visible = isVisible
        container.Visible = isVisible
    end
    
    return Library
end

return Pickle

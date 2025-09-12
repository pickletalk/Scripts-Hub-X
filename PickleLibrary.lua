-- Scripts Hub X | Official - Enhanced Pickle UI Library
-- Version: 4.0.0
-- Created by: Scripts Hub X Team

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Utility Functions
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

local function tween(object, properties, time, style, direction, callback)
    local success, tweenObject = pcall(function()
        local info = TweenInfo.new(
            time or 0.3,
            style or Enum.EasingStyle.Quart,
            direction or Enum.EasingDirection.Out
        )
        return TweenService:Create(object, info, properties)
    end)
    if success and tweenObject then
        tweenObject:Play()
        if callback then
            tweenObject.Completed:Connect(callback)
        end
        return tweenObject
    end
end

-- File I/O System
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

-- RGB Color System
local RGBColors = {
    current = Color3.fromRGB(255, 85, 85),
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

-- Main Library
local Pickle = {}

function Pickle.CreateWindow(options)
    options = options or {}
    local title = options.Title or "Scripts Hub X | Official"
    local subtitle = options.Subtitle or "Enhanced UI Library v4.0"
    local rgbEnabled = options.RGB ~= false -- RGB enabled by default
    local configEnabled = options.SaveConfiguration == true
    local configFolder = options.ConfigFolder or "ScriptsHubX"
    local configFile = options.ConfigFile or "config.json"
    local logoUrl = options.LogoUrl or ""
    
    -- Configuration system
    local configPath = configFolder .. '/' .. configFile
    local configData = {}
    
    if configEnabled then
        FileIO.mkdir(configFolder)
    end
    
    local function saveConfig()
        if configEnabled then
            local success = FileIO.write(configPath, HttpService:JSONEncode(configData))
            if success then
                print("✅ Configuration saved successfully")
            end
        end
    end
    
    local function loadConfig()
        if configEnabled and FileIO.exists(configPath) then
            local data = FileIO.read(configPath)
            if data then
                local success, decoded = pcall(function()
                    return HttpService:JSONDecode(data)
                end)
                if success then
                    configData = decoded
                    print("✅ Configuration loaded successfully")
                    return configData
                end
            end
        end
        return {}
    end
    
    -- Main ScreenGui
    local screenGui = new('ScreenGui', {
        Name = "ScriptsHubX_UI",
        Parent = LocalPlayer:WaitForChild('PlayerGui'),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Minimized Circle Icon
    local minimizedFrame = new('Frame', {
        Parent = screenGui,
        Size = UDim2.new(0, 60, 0, 60),
        Position = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 1000,
        Active = true
    })
    
    local minimizedCorner = new('UICorner', {
        Parent = minimizedFrame,
        CornerRadius = UDim.new(0, 30)
    })
    
    local minimizedStroke = new('UIStroke', {
        Parent = minimizedFrame,
        Thickness = 2,
        Color = Color3.fromRGB(255, 85, 85),
        Transparency = 0.3
    })
    
    local minimizedIcon = new('TextLabel', {
        Parent = minimizedFrame,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "SHX",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 1001
    })
    
    -- Main container
    local container = new('Frame', {
        Parent = screenGui,
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, -300, 0.5, -200),
        BackgroundTransparency = 1,
        ZIndex = 1,
        ClipsDescendants = true,
        Active = true
    })
    
    -- Main window frame with modern design
    local mainFrame = new('Frame', {
        Parent = container,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0,
        ZIndex = 2
    })
    
    local mainCorner = new('UICorner', {
        Parent = mainFrame,
        CornerRadius = UDim.new(0, 16)
    })
    
    local mainStroke = new('UIStroke', {
        Parent = mainFrame,
        Thickness = 2,
        Color = Color3.fromRGB(255, 85, 85),
        Transparency = 0.3
    })
    
    -- Top header with logo and title
    local headerFrame = new('Frame', {
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderSizePixel = 0,
        ZIndex = 3
    })
    
    local headerCorner = new('UICorner', {
        Parent = headerFrame,
        CornerRadius = UDim.new(0, 16)
    })
    
    -- Header bottom cover
    local headerCover = new('Frame', {
        Parent = headerFrame,
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 0, 1, -16),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderSizePixel = 0,
        ZIndex = 3
    })
    
    -- Logo placeholder (you can add ImageLabel here)
    local logoFrame = new('Frame', {
        Parent = headerFrame,
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 15, 0.5, -20),
        BackgroundColor3 = Color3.fromRGB(255, 85, 85),
        BorderSizePixel = 0,
        ZIndex = 4
    })
    
    local logoCorner = new('UICorner', {
        Parent = logoFrame,
        CornerRadius = UDim.new(0, 8)
    })
    
    local logoText = new('TextLabel', {
        Parent = logoFrame,
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "SHX",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        ZIndex = 5
    })
    
    -- Title and subtitle
    local titleLabel = new('TextLabel', {
        Parent = headerFrame,
        Size = UDim2.new(1, -200, 0, 25),
        Position = UDim2.new(0, 65, 0, 10),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4
    })
    
    local subtitleLabel = new('TextLabel', {
        Parent = headerFrame,
        Size = UDim2.new(1, -200, 0, 20),
        Position = UDim2.new(0, 65, 0, 35),
        BackgroundTransparency = 1,
        Text = subtitle,
        TextColor3 = Color3.fromRGB(150, 150, 150),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4
    })
    
    -- Control buttons
    local closeButton = new('TextButton', {
        Parent = headerFrame,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -40, 0, 10),
        BackgroundColor3 = Color3.fromRGB(255, 95, 95),
        BorderSizePixel = 0,
        Text = "✕",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        AutoButtonColor = false,
        ZIndex = 5
    })
    
    local closeCorner = new('UICorner', {
        Parent = closeButton,
        CornerRadius = UDim.new(0, 8)
    })
    
    local minimizeButton = new('TextButton', {
        Parent = headerFrame,
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -80, 0, 10),
        BackgroundColor3 = Color3.fromRGB(255, 193, 95),
        BorderSizePixel = 0,
        Text = "─",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        AutoButtonColor = false,
        ZIndex = 5
    })
    
    local minCorner = new('UICorner', {
        Parent = minimizeButton,
        CornerRadius = UDim.new(0, 8)
    })
    
    -- Content area
    local contentFrame = new('Frame', {
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 1, -70),
        Position = UDim2.new(0, 0, 0, 70),
        BackgroundTransparency = 1,
        ZIndex = 3
    })
    
    -- Left navigation panel
    local navFrame = new('Frame', {
        Parent = contentFrame,
        Size = UDim2.new(0, 180, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        ZIndex = 4
    })
    
    local navCorner = new('UICorner', {
        Parent = navFrame,
        CornerRadius = UDim.new(0, 12)
    })
    
    local navScrollFrame = new('ScrollingFrame', {
        Parent = navFrame,
        Size = UDim2.new(1, -10, 1, -20),
        Position = UDim2.new(0, 5, 0, 10),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100),
        ZIndex = 5,
        BorderSizePixel = 0
    })
    
    navScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local navLayout = new('UIListLayout', {
        Parent = navScrollFrame,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    -- Main content panel
    local pageFrame = new('Frame', {
        Parent = contentFrame,
        Size = UDim2.new(1, -210, 1, -20),
        Position = UDim2.new(0, 200, 0, 10),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        ZIndex = 4
    })
    
    local pageCorner = new('UICorner', {
        Parent = pageFrame,
        CornerRadius = UDim.new(0, 12)
    })
    
    -- Variables
    local tabs = {}
    local currentTab = nil
    local visible = true
    local minimized = false
    local configElements = {}
    
    -- Dragging for minimized icon
    local function makeDraggable(frame)
        local dragging = false
        local dragStart = nil
        local startPos = nil
        
        frame.InputBegan:Connect(function(input)
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
        
        frame.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
                if dragStart and startPos then
                    local delta = input.Position - dragStart
                    frame.Position = UDim2.new(
                        startPos.X.Scale,
                        startPos.X.Offset + delta.X,
                        startPos.Y.Scale,
                        startPos.Y.Offset + delta.Y
                    )
                end
            end
        end)
    end
    
    -- Make both frames draggable
    makeDraggable(minimizedFrame)
    makeDraggable(headerFrame)
    
    -- Opening Animation
    spawn(function()
        wait(0.1)
        tween(container, {
            Size = UDim2.new(0, 600, 0, 400)
        }, 0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)
    
    -- Button functionality
    closeButton.MouseButton1Click:Connect(function()
        tween(container, {
            Size = UDim2.new(0, 0, 0, 0)
        }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In, function()
            screenGui:Destroy()
        end)
    end)
    
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            tween(container, {
                Size = UDim2.new(0, 0, 0, 0)
            }, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, function()
                container.Visible = false
                minimizedFrame.Visible = true
                tween(minimizedFrame, {Size = UDim2.new(0, 60, 0, 60)}, 0.3, Enum.EasingStyle.Back)
            end)
        else
            minimizedFrame.Visible = false
            container.Visible = true
            tween(container, {
                Size = UDim2.new(0, 600, 0, 400)
            }, 0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
        end
    end)
    
    -- Restore from minimized
    minimizedFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            minimized = false
            tween(minimizedFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, function()
                minimizedFrame.Visible = false
                container.Visible = true
                tween(container, {
                    Size = UDim2.new(0, 600, 0, 400)
                }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
            end)
        end
    end)
    
    -- Button hover effects
    closeButton.MouseEnter:Connect(function()
        tween(closeButton, {BackgroundColor3 = Color3.fromRGB(255, 115, 115)}, 0.2)
    end)
    closeButton.MouseLeave:Connect(function()
        tween(closeButton, {BackgroundColor3 = Color3.fromRGB(255, 95, 95)}, 0.2)
    end)
    
    minimizeButton.MouseEnter:Connect(function()
        tween(minimizeButton, {BackgroundColor3 = Color3.fromRGB(255, 213, 115)}, 0.2)
    end)
    minimizeButton.MouseLeave:Connect(function()
        tween(minimizeButton, {BackgroundColor3 = Color3.fromRGB(255, 193, 95)}, 0.2)
    end)
    
    -- RGB Animation
    if rgbEnabled then
        spawn(function()
            while screenGui and screenGui.Parent do
                local color = RGBColors:Update()
                mainStroke.Color = color
                minimizedStroke.Color = color
                logoFrame.BackgroundColor3 = color
                
                -- Apply to all RGB elements
                for _, element in pairs(configElements) do
                    if element.rgbStroke and element.rgbStroke.Parent then
                        element.rgbStroke.Color = color
                    end
                    if element.rgbBackground and element.rgbBackground.Parent then
                        element.rgbBackground.BackgroundColor3 = color
                    end
                end
                
                wait(0.05)
            end
        end)
    end
    
    -- API Functions
    local Library = {}
    
    function Library:CreateTab(name, icon)
        icon = icon or "📋"
        
        local tabButton = new('TextButton', {
            Parent = navScrollFrame,
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 6,
            LayoutOrder = #tabs + 1
        })
        
        local buttonCorner = new('UICorner', {
            Parent = tabButton,
            CornerRadius = UDim.new(0, 8)
        })
        
        local iconLabel = new('TextLabel', {
            Parent = tabButton,
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = icon,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 7
        })
        
        local textLabel = new('TextLabel', {
            Parent = tabButton,
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 35, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 7
        })
        
        local tabContent = new('ScrollingFrame', {
            Parent = pageFrame,
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            ScrollBarThickness = 6,
            ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100),
            Visible = false,
            ZIndex = 5,
            BorderSizePixel = 0
        })
        
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        local contentLayout = new('UIListLayout', {
            Parent = tabContent,
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        local contentPadding = new('UIPadding', {
            Parent = tabContent,
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10)
        })
        
        -- Tab interactions
        tabButton.MouseEnter:Connect(function()
            if currentTab ~= tabContent then
                tween(tabButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2)
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if currentTab ~= tabContent then
                tween(tabButton, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.2)
            end
        end)
        
        tabButton.MouseButton1Click:Connect(function()
            -- Hide all tabs
            for _, tab in pairs(tabs) do
                tab.content.Visible = false
                tween(tab.button, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.2)
                tab.iconLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                tab.textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            end
            
            -- Show current tab
            tabContent.Visible = true
            tween(tabButton, {BackgroundColor3 = Color3.fromRGB(255, 85, 85)}, 0.2)
            iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            currentTab = tabContent
        end)
        
        local tab = {
            button = tabButton,
            content = tabContent,
            iconLabel = iconLabel,
            textLabel = textLabel,
            name = name
        }
        
        table.insert(tabs, tab)
        
        -- Auto-select first tab
        if #tabs == 1 then
            spawn(function()
                wait(0.5)
                tabButton.MouseButton1Click:Fire()
            end)
        end
        
        -- Tab methods
        function tab:CreateSection(sectionName)
            local sectionFrame = new('Frame', {
                Parent = tabContent,
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                BorderSizePixel = 0,
                ZIndex = 6,
                LayoutOrder = #tabContent:GetChildren() + 1
            })
            
            local sectionCorner = new('UICorner', {
                Parent = sectionFrame,
                CornerRadius = UDim.new(0, 10)
            })
            
            local sectionLabel = new('TextLabel', {
                Parent = sectionFrame,
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 20, 0, 0),
                BackgroundTransparency = 1,
                Text = sectionName,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 7
            })
            
            local sectionContent = new('Frame', {
                Parent = sectionFrame,
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 1, 0),
                BackgroundTransparency = 1,
                ZIndex = 6
            })
            
            local sectionLayout = new('UIListLayout', {
                Parent = sectionContent,
                Padding = UDim.new(0, 5),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            
            local function updateSectionSize()
                spawn(function()
                    wait()
                    local contentSize = sectionLayout.AbsoluteContentSize.Y
                    sectionContent.Size = UDim2.new(1, 0, 0, contentSize)
                    sectionFrame.Size = UDim2.new(1, 0, 0, contentSize + 50)
                end)
            end
            
            sectionLayout.Changed:Connect(updateSectionSize)
            
            local section = {
                frame = sectionFrame,
                content = sectionContent,
                updateSize = updateSectionSize
            }
            
            -- Button
            function section:CreateButton(buttonName, callback)
                local buttonId = name .. "_" .. sectionName .. "_" .. buttonName
                
                local button = new('TextButton', {
                    Parent = sectionContent,
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                    BorderSizePixel = 0,
                    Text = buttonName,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    AutoButtonColor = false,
                    ZIndex = 7,
                    LayoutOrder = #sectionContent:GetChildren() + 1
                })
                
                local buttonCorner = new('UICorner', {
                    Parent = button,
                    CornerRadius = UDim.new(0, 8)
                })
                
                local buttonStroke = new('UIStroke', {
                    Parent = button,
                    Thickness = 1,
                    Color = Color3.fromRGB(255, 85, 85),
                    Transparency = 0.7
                })
                
                if rgbEnabled then
                    configElements[buttonId] = {
                        rgbStroke = buttonStroke
                    }
                end
                
                button.MouseEnter:Connect(function()
                    tween(button, {BackgroundColor3 = Color3.fromRGB(65, 65, 65)}, 0.2)
                    tween(buttonStroke, {Transparency = 0.3}, 0.2)
                end)
                
                button.MouseLeave:Connect(function()
                    tween(button, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}, 0.2)
                    tween(buttonStroke, {Transparency = 0.7}, 0.2)
                end)
                
                button.MouseButton1Click:Connect(function()
                    tween(button, {Size = UDim2.new(1, 0, 0, 32)}, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
                        tween(button, {Size = UDim2.new(1, 0, 0, 35)}, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    end)
                    
                    if callback then
                        pcall(callback)
                    end
                end)
                
                updateSectionSize()
                return button
            end
            
            -- Toggle
            function section:CreateToggle(toggleName, defaultValue, callback)
                defaultValue = defaultValue or false
                local toggleId = name .. "_" .. sectionName .. "_" .. toggleName
                
                local toggleFrame = new('Frame', {
                    Parent = sectionContent,
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                    BorderSizePixel = 0,
                    ZIndex = 7,
                    LayoutOrder = #sectionContent:GetChildren() + 1
                })
                
                local toggleCorner = new('UICorner', {
                    Parent = toggleFrame,
                    CornerRadius = UDim.new(0, 8)
                })
                
                local toggleStroke = new('UIStroke', {
                    Parent = toggleFrame,
                    Thickness = 1,
                    Color = Color3.fromRGB(100, 100, 100),
                    Transparency = 0.7
                })
                
                local toggleLabel = new('TextLabel', {
                    Parent = toggleFrame,
                    Size = UDim2.new(1, -60, 1, 0),
                    Position = UDim2.new(0, 15, 0, 0),
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
                    Size = UDim2.new(0, 45, 0, 22),
                    Position = UDim2.new(1, -55, 0.5, -11),
                    BackgroundColor3 = defaultValue and Color3.fromRGB(255, 85, 85) or Color3.fromRGB(60, 60, 60),
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 8
                })
                
                local toggleBtnCorner = new('UICorner', {
                    Parent = toggleButton,
                    CornerRadius = UDim.new(0, 11)
                })
                
                local toggleIndicator = new('Frame', {
                    Parent = toggleButton,
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = defaultValue and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    ZIndex = 9
                })
                
                local indicatorCorner = new('UICorner', {
                    Parent = toggleIndicator,
                    CornerRadius = UDim.new(0, 9)
                })
                
                local toggled = defaultValue
                
                if configEnabled then
                    configData[toggleId] = defaultValue
                end
                
                toggleFrame.MouseEnter:Connect(function()
                    tween(toggleFrame, {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}, 0.2)
                end)
                
                toggleFrame.MouseLeave:Connect(function()
                    tween(toggleFrame, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}, 0.2)
                end)
                
                toggleButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    
                    tween(toggleButton, {
                        BackgroundColor3 = toggled and Color3.fromRGB(255, 85, 85) or Color3.fromRGB(60, 60, 60)
                    }, 0.3, Enum.EasingStyle.Quart)
                    
                    tween(toggleIndicator, {
                        Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                    }, 0.3, Enum.EasingStyle.Quart)
                    
                    if configEnabled then
                        configData[toggleId] = toggled
                        saveConfig()
                    end
                    
                    if callback then
                        pcall(callback, toggled)
                    end
                end)
                
                updateSectionSize()
                
                return {
                    SetValue = function(value)
                        toggled = value
                        toggleButton.BackgroundColor3 = toggled and Color3.fromRGB(255, 85, 85) or Color3.fromRGB(60, 60, 60)
                        toggleIndicator.Position = toggled and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
                        
                        if configEnabled then
                            configData[toggleId] = toggled
                        end
                    end,
                    GetValue = function()
                        return toggled
                    end,
                    configId = toggleId
                }
            end
            
            -- Slider
            function section:CreateSlider(sliderName, minValue, maxValue, defaultValue, callback)
                minValue = minValue or 0
                maxValue = maxValue or 100
                defaultValue = defaultValue or minValue
                local sliderId = name .. "_" .. sectionName .. "_" .. sliderName
                
                local sliderFrame = new('Frame', {
                    Parent = sectionContent,
                    Size = UDim2.new(1, 0, 0, 55),
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                    BorderSizePixel = 0,
                    ZIndex = 7,
                    LayoutOrder = #sectionContent:GetChildren() + 1
                })
                
                local sliderCorner = new('UICorner', {
                    Parent = sliderFrame,
                    CornerRadius = UDim.new(0, 8)
                })
                
                local sliderStroke = new('UIStroke', {
                    Parent = sliderFrame,
                    Thickness = 1,
                    Color = Color3.fromRGB(100, 100, 100),
                    Transparency = 0.7
                })
                
                local sliderLabel = new('TextLabel', {
                    Parent = sliderFrame,
                    Size = UDim2.new(1, -20, 0, 25),
                    Position = UDim2.new(0, 15, 0, 5),
                    BackgroundTransparency = 1,
                    Text = sliderName .. ": " .. defaultValue,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 8
                })
                
                local sliderTrack = new('Frame', {
                    Parent = sliderFrame,
                    Size = UDim2.new(1, -30, 0, 8),
                    Position = UDim2.new(0, 15, 0, 35),
                    BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                    BorderSizePixel = 0,
                    ZIndex = 8
                })
                
                local trackCorner = new('UICorner', {
                    Parent = sliderTrack,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local sliderFill = new('Frame', {
                    Parent = sliderTrack,
                    Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 85, 85),
                    BorderSizePixel = 0,
                    ZIndex = 9
                })
                
                local fillCorner = new('UICorner', {
                    Parent = sliderFill,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local sliderButton = new('TextButton', {
                    Parent = sliderTrack,
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -9, 0.5, -9),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 10
                })
                
                local btnCorner = new('UICorner', {
                    Parent = sliderButton,
                    CornerRadius = UDim.new(0, 9)
                })
                
                local btnStroke = new('UIStroke', {
                    Parent = sliderButton,
                    Thickness = 2,
                    Color = Color3.fromRGB(255, 85, 85),
                    Transparency = 0.5
                })
                
                local currentValue = defaultValue
                local dragging = false
                
                if configEnabled then
                    configData[sliderId] = defaultValue
                end
                
                sliderFrame.MouseEnter:Connect(function()
                    tween(sliderFrame, {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}, 0.2)
                end)
                
                sliderFrame.MouseLeave:Connect(function()
                    if not dragging then
                        tween(sliderFrame, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}, 0.2)
                    end
                end)
                
                local function updateSlider(relativeX)
                    relativeX = math.clamp(relativeX, 0, 1)
                    currentValue = math.floor(minValue + (maxValue - minValue) * relativeX + 0.5)
                    sliderLabel.Text = sliderName .. ": " .. currentValue
                    
                    tween(sliderFill, {Size = UDim2.new(relativeX, 0, 1, 0)}, 0.1)
                    tween(sliderButton, {Position = UDim2.new(relativeX, -9, 0.5, -9)}, 0.1)
                    
                    if configEnabled then
                        configData[sliderId] = currentValue
                        saveConfig()
                    end
                    
                    if callback then
                        pcall(callback, currentValue)
                    end
                end
                
                sliderButton.MouseButton1Down:Connect(function()
                    dragging = true
                    tween(sliderButton, {Size = UDim2.new(0, 22, 0, 22)}, 0.15)
                    tween(sliderButton, {Position = UDim2.new((currentValue - minValue) / (maxValue - minValue), -11, 0.5, -11)}, 0.15)
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
                        dragging = false
                        tween(sliderButton, {Size = UDim2.new(0, 18, 0, 18)}, 0.15)
                        tween(sliderButton, {Position = UDim2.new((currentValue - minValue) / (maxValue - minValue), -9, 0.5, -9)}, 0.15)
                        tween(sliderFrame, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}, 0.2)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mouse = UserInputService:GetMouseLocation()
                        local relativeX = (mouse.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X
                        updateSlider(relativeX)
                    end
                end)
                
                sliderTrack.MouseButton1Click:Connect(function()
                    if not dragging then
                        local mouse = UserInputService:GetMouseLocation()
                        local relativeX = (mouse.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X
                        updateSlider(relativeX)
                    end
                end)
                
                updateSectionSize()
                
                return {
                    SetValue = function(value)
                        currentValue = math.clamp(value, minValue, maxValue)
                        local relativeX = (currentValue - minValue) / (maxValue - minValue)
                        sliderLabel.Text = sliderName .. ": " .. currentValue
                        sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
                        sliderButton.Position = UDim2.new(relativeX, -9, 0.5, -9)
                        
                        if configEnabled then
                            configData[sliderId] = currentValue
                        end
                    end,
                    GetValue = function()
                        return currentValue
                    end,
                    configId = sliderId
                }
            end
            
            -- Keybind
            function section:CreateKeybind(keybindName, defaultKey, callback)
                defaultKey = defaultKey or "None"
                local keybindId = name .. "_" .. sectionName .. "_" .. keybindName
                
                local keybindFrame = new('Frame', {
                    Parent = sectionContent,
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                    BorderSizePixel = 0,
                    ZIndex = 7,
                    LayoutOrder = #sectionContent:GetChildren() + 1
                })
                
                local keybindCorner = new('UICorner', {
                    Parent = keybindFrame,
                    CornerRadius = UDim.new(0, 8)
                })
                
                local keybindStroke = new('UIStroke', {
                    Parent = keybindFrame,
                    Thickness = 1,
                    Color = Color3.fromRGB(100, 100, 100),
                    Transparency = 0.7
                })
                
                local keybindLabel = new('TextLabel', {
                    Parent = keybindFrame,
                    Size = UDim2.new(1, -100, 1, 0),
                    Position = UDim2.new(0, 15, 0, 0),
                    BackgroundTransparency = 1,
                    Text = keybindName,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 8
                })
                
                local keybindButton = new('TextButton', {
                    Parent = keybindFrame,
                    Size = UDim2.new(0, 80, 0, 25),
                    Position = UDim2.new(1, -90, 0.5, -12),
                    BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                    BorderSizePixel = 0,
                    Text = defaultKey,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    AutoButtonColor = false,
                    ZIndex = 8
                })
                
                local keyCorner = new('UICorner', {
                    Parent = keybindButton,
                    CornerRadius = UDim.new(0, 6)
                })
                
                local keyStroke = new('UIStroke', {
                    Parent = keybindButton,
                    Thickness = 1,
                    Color = Color3.fromRGB(255, 85, 85),
                    Transparency = 0.7
                })
                
                local currentKey = defaultKey
                local listening = false
                
                if configEnabled then
                    configData[keybindId] = defaultKey
                end
                
                keybindFrame.MouseEnter:Connect(function()
                    tween(keybindFrame, {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}, 0.2)
                end)
                
                keybindFrame.MouseLeave:Connect(function()
                    tween(keybindFrame, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}, 0.2)
                end)
                
                keybindButton.MouseButton1Click:Connect(function()
                    if not listening then
                        listening = true
                        keybindButton.Text = "..."
                        tween(keybindButton, {BackgroundColor3 = Color3.fromRGB(255, 85, 85)}, 0.2)
                        tween(keyStroke, {Transparency = 0.3}, 0.2)
                    end
                end)
                
                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        local keyName = input.KeyCode.Name
                        currentKey = keyName
                        keybindButton.Text = keyName
                        tween(keybindButton, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}, 0.2)
                        tween(keyStroke, {Transparency = 0.7}, 0.2)
                        listening = false
                        
                        if configEnabled then
                            configData[keybindId] = currentKey
                            saveConfig()
                        end
                    end
                    
                    if not listening and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == currentKey then
                        tween(keybindButton, {Size = UDim2.new(0, 76, 0, 23)}, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
                            tween(keybindButton, {Size = UDim2.new(0, 80, 0, 25)}, 0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                        end)
                        
                        if callback then
                            pcall(callback)
                        end
                    end
                end)
                
                updateSectionSize()
                
                return {
                    SetValue = function(key)
                        currentKey = key
                        keybindButton.Text = key
                        
                        if configEnabled then
                            configData[keybindId] = currentKey
                        end
                    end,
                    GetValue = function()
                        return currentKey
                    end,
                    configId = keybindId
                }
            end
            
            -- Dropdown
            function section:CreateDropdown(dropdownName, options, defaultValue, callback)
                options = options or {}
                defaultValue = defaultValue or (options[1] or "None")
                local dropdownId = name .. "_" .. sectionName .. "_" .. dropdownName
                
                local dropdownFrame = new('Frame', {
                    Parent = sectionContent,
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                    BorderSizePixel = 0,
                    ZIndex = 7,
                    LayoutOrder = #sectionContent:GetChildren() + 1
                })
                
                local dropCorner = new('UICorner', {
                    Parent = dropdownFrame,
                    CornerRadius = UDim.new(0, 8)
                })
                
                local dropStroke = new('UIStroke', {
                    Parent = dropdownFrame,
                    Thickness = 1,
                    Color = Color3.fromRGB(100, 100, 100),
                    Transparency = 0.7
                })
                
                local dropLabel = new('TextLabel', {
                    Parent = dropdownFrame,
                    Size = UDim2.new(1, -120, 1, 0),
                    Position = UDim2.new(0, 15, 0, 0),
                    BackgroundTransparency = 1,
                    Text = dropdownName,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 8
                })
                
                local dropButton = new('TextButton', {
                    Parent = dropdownFrame,
                    Size = UDim2.new(0, 100, 0, 25),
                    Position = UDim2.new(1, -110, 0.5, -12),
                    BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                    BorderSizePixel = 0,
                    Text = defaultValue .. " ▼",
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 10,
                    AutoButtonColor = false,
                    ZIndex = 8
                })
                
                local dropBtnCorner = new('UICorner', {
                    Parent = dropButton,
                    CornerRadius = UDim.new(0, 6)
                })
                
                local currentValue = defaultValue
                local isOpen = false
                
                if configEnabled then
                    configData[dropdownId] = defaultValue
                end
                
                local optionsFrame = new('Frame', {
                    Parent = dropdownFrame,
                    Size = UDim2.new(0, 100, 0, 0),
                    Position = UDim2.new(1, -110, 1, 5),
                    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                    BorderSizePixel = 0,
                    ZIndex = 50,
                    Visible = false,
                    ClipsDescendants = true
                })
                
                local optionsCorner = new('UICorner', {
                    Parent = optionsFrame,
                    CornerRadius = UDim.new(0, 6)
                })
                
                local optionsLayout = new('UIListLayout', {
                    Parent = optionsFrame,
                    SortOrder = Enum.SortOrder.LayoutOrder
                })
                
                -- Create option buttons
                for i, option in ipairs(options) do
                    local optionButton = new('TextButton', {
                        Parent = optionsFrame,
                        Size = UDim2.new(1, 0, 0, 25),
                        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                        BorderSizePixel = 0,
                        Text = option,
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        Font = Enum.Font.Gotham,
                        TextSize = 10,
                        AutoButtonColor = false,
                        ZIndex = 51
                    })
                    
                    optionButton.MouseEnter:Connect(function()
                        tween(optionButton, {BackgroundColor3 = Color3.fromRGB(255, 85, 85)}, 0.2)
                    end)
                    
                    optionButton.MouseLeave:Connect(function()
                        tween(optionButton, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}, 0.2)
                    end)
                    
                    optionButton.MouseButton1Click:Connect(function()
                        currentValue = option
                        dropButton.Text = option .. " ▼"
                        
                        -- Close dropdown
                        isOpen = false
                        tween(optionsFrame, {Size = UDim2.new(0, 100, 0, 0)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
                            optionsFrame.Visible = false
                        end)
                        
                        if configEnabled then
                            configData[dropdownId] = currentValue
                            saveConfig()
                        end
                        
                        if callback then
                            pcall(callback, currentValue)
                        end
                    end)
                end
                
                dropButton.MouseButton1Click:Connect(function()
                    isOpen = not isOpen
                    if isOpen then
                        optionsFrame.Visible = true
                        tween(optionsFrame, {Size = UDim2.new(0, 100, 0, #options * 25)}, 0.3, Enum.EasingStyle.Quart)
                        dropButton.Text = currentValue .. " ▲"
                    else
                        tween(optionsFrame, {Size = UDim2.new(0, 100, 0, 0)}, 0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, function()
                            optionsFrame.Visible = false
                        end)
                        dropButton.Text = currentValue .. " ▼"
                    end
                end)
                
                dropdownFrame.MouseEnter:Connect(function()
                    tween(dropdownFrame, {BackgroundColor3 = Color3.fromRGB(55, 55, 55)}, 0.2)
                end)
                
                dropdownFrame.MouseLeave:Connect(function()
                    tween(dropdownFrame, {BackgroundColor3 = Color3.fromRGB(45, 45, 45)}, 0.2)
                end)
                
                updateSectionSize()
                
                return {
                    SetValue = function(value)
                        if table.find(options, value) then
                            currentValue = value
                            dropButton.Text = value .. " ▼"
                            
                            if configEnabled then
                                configData[dropdownId] = currentValue
                            end
                        end
                    end,
                    GetValue = function()
                        return currentValue
                    end,
                    configId = dropdownId
                }
            end
            
            return section
        end
        
        return tab
    end
    
    function Library:Destroy()
        tween(container, {
            Size = UDim2.new(0, 0, 0, 0)
        }, 0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In, function()
            screenGui:Destroy()
        end)
    end
    
    function Library:SetVisible(isVisible)
        visible = isVisible
        if isVisible then
            if minimized then
                minimizeButton.MouseButton1Click:Fire()
            else
                container.Visible = true
                tween(container, {Size = UDim2.new(0, 600, 0, 400)}, 0.4, Enum.EasingStyle.Back)
            end
        else
            tween(container, {Size = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out, function()
                container.Visible = false
            end)
        end
    end
    
    function Library:LoadConfiguration()
        if configEnabled then
            print("🔄 Loading configuration...")
            local loadedConfig = loadConfig()
            
            -- Apply loaded configuration to elements
            for elementId, value in pairs(loadedConfig) do
                for _, element in pairs(configElements) do
                    if element.configId == elementId then
                        if element.SetValue then
                            element.SetValue(value)
                        end
                        break
                    end
                end
            end
            
            print("✅ Configuration loaded successfully")
        end
    end
    
    function Library:SaveConfiguration()
        if configEnabled then
            saveConfig()
            print("💾 Configuration saved manually")
        end
    end
    
    -- Store elements for configuration
    Library._configElements = configElements
    Library._configData = configData
    
    return Library
end

return Pickle

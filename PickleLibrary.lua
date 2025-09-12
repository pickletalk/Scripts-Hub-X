-- Scripts Hub X | Official - Enhanced Pickle UI Library
-- Version: 1.0.0 - FIXED
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
                -- Set parent last
            else
                pcall(function()
                    instance[property] = value
                end)
            end
        end
        if props.Parent then
            instance.Parent = props.Parent
        end
    end
    return instance
end

local function tween(object, properties, time, style, direction, callback)
    if not object or not object.Parent then return end
    
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
    speed = 1.5,
    hue = 0
}

function RGBColors:Update()
    self.hue = (self.hue + self.speed) % 360
    local h = self.hue / 60
    local c = 1
    local x = c * (1 - math.abs(h % 2 - 1))
    
    local r, g, b = 0, 0, 0
    if h < 1 then r, g, b = c, x, 0
    elseif h < 2 then r, g, b = x, c, 0
    elseif h < 3 then r, g, b = 0, c, x
    elseif h < 4 then r, g, b = 0, x, c
    elseif h < 5 then r, g, b = x, 0, c
    else r, g, b = c, 0, x end
    
    r, g, b = (r) * 255, (g) * 255, (b) * 255
    self.current = Color3.fromRGB(math.floor(r), math.floor(g), math.floor(b))
    return self.current
end

-- Main Library
local Pickle = {}

function Pickle.CreateWindow(options)
    options = options or {}
    local title = options.Title or "Scripts Hub X | Official"
    local subtitle = options.Subtitle or "Enhanced UI Library v4.0"
    local rgbEnabled = options.RGB ~= false
    local configEnabled = options.SaveConfiguration == true
    local configFolder = options.ConfigFolder or "ScriptsHubX"
    local configFile = options.ConfigFile or "config.json"
    
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
                if success and decoded then
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
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
        Parent = LocalPlayer:WaitForChild('PlayerGui')
    })
    
    -- Minimized Circle Icon
    local minimizedFrame = new('Frame', {
        Size = UDim2.new(0, 60, 0, 60),
        Position = UDim2.new(0, 20, 0, 20),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        Visible = false,
        ZIndex = 1000,
        Active = true,
        Parent = screenGui
    })
    
    local minimizedCorner = new('UICorner', {
        CornerRadius = UDim.new(0, 30),
        Parent = minimizedFrame
    })
    
    local minimizedStroke = new('UIStroke', {
        Thickness = 2,
        Color = Color3.fromRGB(255, 85, 85),
        Transparency = 0.3,
        Parent = minimizedFrame
    })
    
    local minimizedIcon = new('TextLabel', {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "SHX",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 1001,
        Parent = minimizedFrame
    })
    
    -- Main container
    local container = new('Frame', {
        Size = UDim2.new(0, 600, 0, 400),
        Position = UDim2.new(0.5, -300, 0.5, -200),
        BackgroundTransparency = 1,
        ZIndex = 1,
        Active = true,
        Parent = screenGui
    })
    
    -- Main window frame
    local mainFrame = new('Frame', {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.fromRGB(20, 20, 20),
        BorderSizePixel = 0,
        ZIndex = 2,
        Parent = container
    })
    
    local mainCorner = new('UICorner', {
        CornerRadius = UDim.new(0, 16),
        Parent = mainFrame
    })
    
    local mainStroke = new('UIStroke', {
        Thickness = 2,
        Color = Color3.fromRGB(255, 85, 85),
        Transparency = 0.3,
        Parent = mainFrame
    })
    
    -- Top header
    local headerFrame = new('Frame', {
        Size = UDim2.new(1, 0, 0, 70),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = mainFrame
    })
    
    local headerCorner = new('UICorner', {
        CornerRadius = UDim.new(0, 16),
        Parent = headerFrame
    })
    
    -- Header bottom cover
    local headerCover = new('Frame', {
        Size = UDim2.new(1, 0, 0, 16),
        Position = UDim2.new(0, 0, 1, -16),
        BackgroundColor3 = Color3.fromRGB(15, 15, 15),
        BorderSizePixel = 0,
        ZIndex = 3,
        Parent = headerFrame
    })
    
    -- Logo
    local logoFrame = new('Frame', {
        Size = UDim2.new(0, 40, 0, 40),
        Position = UDim2.new(0, 15, 0.5, -20),
        BackgroundColor3 = Color3.fromRGB(255, 85, 85),
        BorderSizePixel = 0,
        ZIndex = 4,
        Parent = headerFrame
    })
    
    local logoCorner = new('UICorner', {
        CornerRadius = UDim.new(0, 8),
        Parent = logoFrame
    })
    
    local logoText = new('TextLabel', {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        Text = "SHX",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 12,
        ZIndex = 5,
        Parent = logoFrame
    })
    
    -- Title and subtitle
    local titleLabel = new('TextLabel', {
        Size = UDim2.new(1, -200, 0, 25),
        Position = UDim2.new(0, 65, 0, 10),
        BackgroundTransparency = 1,
        Text = title,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4,
        Parent = headerFrame
    })
    
    local subtitleLabel = new('TextLabel', {
        Size = UDim2.new(1, -200, 0, 20),
        Position = UDim2.new(0, 65, 0, 35),
        BackgroundTransparency = 1,
        Text = subtitle,
        TextColor3 = Color3.fromRGB(150, 150, 150),
        Font = Enum.Font.Gotham,
        TextSize = 12,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4,
        Parent = headerFrame
    })
    
    -- Control buttons
    local closeButton = new('TextButton', {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -40, 0, 10),
        BackgroundColor3 = Color3.fromRGB(255, 95, 95),
        BorderSizePixel = 0,
        Text = "✕",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        AutoButtonColor = false,
        ZIndex = 5,
        Parent = headerFrame
    })
    
    local closeCorner = new('UICorner', {
        CornerRadius = UDim.new(0, 8),
        Parent = closeButton
    })
    
    local minimizeButton = new('TextButton', {
        Size = UDim2.new(0, 30, 0, 30),
        Position = UDim2.new(1, -80, 0, 10),
        BackgroundColor3 = Color3.fromRGB(255, 193, 95),
        BorderSizePixel = 0,
        Text = "─",
        TextColor3 = Color3.fromRGB(0, 0, 0),
        Font = Enum.Font.GothamBold,
        TextSize = 16,
        AutoButtonColor = false,
        ZIndex = 5,
        Parent = headerFrame
    })
    
    local minCorner = new('UICorner', {
        CornerRadius = UDim.new(0, 8),
        Parent = minimizeButton
    })
    
    -- Content area
    local contentFrame = new('Frame', {
        Size = UDim2.new(1, 0, 1, -70),
        Position = UDim2.new(0, 0, 0, 70),
        BackgroundTransparency = 1,
        ZIndex = 3,
        Parent = mainFrame
    })
    
    -- Left navigation panel
    local navFrame = new('Frame', {
        Size = UDim2.new(0, 180, 1, -20),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        ZIndex = 4,
        Parent = contentFrame
    })
    
    local navCorner = new('UICorner', {
        CornerRadius = UDim.new(0, 12),
        Parent = navFrame
    })
    
    local navScrollFrame = new('ScrollingFrame', {
        Size = UDim2.new(1, -10, 1, -20),
        Position = UDim2.new(0, 5, 0, 10),
        BackgroundTransparency = 1,
        ScrollBarThickness = 4,
        ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100),
        ZIndex = 5,
        BorderSizePixel = 0,
        Parent = navFrame
    })
    
    navScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local navLayout = new('UIListLayout', {
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = navScrollFrame
    })
    
    -- Main content panel
    local pageFrame = new('Frame', {
        Size = UDim2.new(1, -210, 1, -20),
        Position = UDim2.new(0, 200, 0, 10),
        BackgroundColor3 = Color3.fromRGB(25, 25, 25),
        BorderSizePixel = 0,
        ZIndex = 4,
        Parent = contentFrame
    })
    
    local pageCorner = new('UICorner', {
        CornerRadius = UDim.new(0, 12),
        Parent = pageFrame
    })
    
    -- Variables
    local tabs = {}
    local currentTab = nil
    local visible = true
    local minimized = false
    local configElements = {}
    
    -- Dragging functionality
    local function makeDraggable(frame)
        local dragging = false
        local dragStart = nil
        local startPos = nil
        
        frame.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = true
                dragStart = input.Position
                startPos = frame.Position
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
        
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                dragging = false
            end
        end)
    end
    
    makeDraggable(minimizedFrame)
    makeDraggable(headerFrame)
    
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
    minimizedFrame.MouseButton1Click:Connect(function()
        minimized = false
        tween(minimizedFrame, {Size = UDim2.new(0, 0, 0, 0)}, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out, function()
            minimizedFrame.Visible = false
            container.Visible = true
            tween(container, {
                Size = UDim2.new(0, 600, 0, 400)
            }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        end)
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
                if mainStroke and mainStroke.Parent then
                    mainStroke.Color = color
                end
                if minimizedStroke and minimizedStroke.Parent then
                    minimizedStroke.Color = color
                end
                if logoFrame and logoFrame.Parent then
                    logoFrame.BackgroundColor3 = color
                end
                
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
    Library.visible = visible
    
    function Library:CreateTab(name, icon)
        icon = icon or "📋"
        
        local tabButton = new('TextButton', {
            Size = UDim2.new(1, 0, 0, 35),
            BackgroundColor3 = Color3.fromRGB(30, 30, 30),
            BorderSizePixel = 0,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 6,
            LayoutOrder = #tabs + 1,
            Parent = navScrollFrame
        })
        
        local buttonCorner = new('UICorner', {
            CornerRadius = UDim.new(0, 8),
            Parent = tabButton
        })
        
        local iconLabel = new('TextLabel', {
            Size = UDim2.new(0, 20, 1, 0),
            Position = UDim2.new(0, 10, 0, 0),
            BackgroundTransparency = 1,
            Text = icon,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            Font = Enum.Font.Gotham,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 7,
            Parent = tabButton
        })
        
        local textLabel = new('TextLabel', {
            Size = UDim2.new(1, -40, 1, 0),
            Position = UDim2.new(0, 35, 0, 0),
            BackgroundTransparency = 1,
            Text = name,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 7,
            Parent = tabButton
        })
        
        local tabContent = new('ScrollingFrame', {
            Size = UDim2.new(1, -20, 1, -20),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            ScrollBarThickness = 6,
            ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100),
            Visible = false,
            ZIndex = 5,
            BorderSizePixel = 0,
            Parent = pageFrame
        })
        
        tabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
        
        local contentLayout = new('UIListLayout', {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = tabContent
        })
        
        local contentPadding = new('UIPadding', {
            PaddingTop = UDim.new(0, 10),
            PaddingBottom = UDim.new(0, 10),
            PaddingLeft = UDim.new(0, 10),
            PaddingRight = UDim.new(0, 10),
            Parent = tabContent
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
                if tab.content and tab.content.Parent then
                    tab.content.Visible = false
                end
                if tab.button and tab.button.Parent then
                    tween(tab.button, {BackgroundColor3 = Color3.fromRGB(30, 30, 30)}, 0.2)
                end
                if tab.iconLabel then
                    tab.iconLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
                if tab.textLabel then
                    tab.textLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
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
            wait(0.1)
            tabButton.MouseButton1Click:Fire()
        end
        
        -- Tab methods
        function tab:CreateSection(sectionName)
            local sectionFrame = new('Frame', {
                Size = UDim2.new(1, 0, 0, 40),
                BackgroundColor3 = Color3.fromRGB(35, 35, 35),
                BorderSizePixel = 0,
                ZIndex = 6,
                LayoutOrder = #tabContent:GetChildren(),
                Parent = tabContent
            })
            
            local sectionCorner = new('UICorner', {
                CornerRadius = UDim.new(0, 10),
                Parent = sectionFrame
            })
            
            local sectionLabel = new('TextLabel', {
                Size = UDim2.new(1, -20, 1, 0),
                Position = UDim2.new(0, 20, 0, 0),
                BackgroundTransparency = 1,
                Text = sectionName,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamBold,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 7,
                Parent = sectionFrame
            })
            
            local sectionContent = new('Frame', {
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 1, 0),
                BackgroundTransparency = 1,
                ZIndex = 6,
                Parent = sectionFrame
            })
            
            local sectionLayout = new('UIListLayout', {
                Padding = UDim.new(0, 5),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = sectionContent
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
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                    BorderSizePixel = 0,
                    Text = buttonName,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    AutoButtonColor = false,
                    ZIndex = 7,
                    LayoutOrder = #sectionContent:GetChildren() + 1,
                    Parent = sectionContent
                })
                
                local buttonCorner = new('UICorner', {
                    CornerRadius = UDim.new(0, 8),
                    Parent = button
                })
                
                local buttonStroke = new('UIStroke', {
                    Thickness = 1,
                    Color = Color3.fromRGB(255, 85, 85),
                    Transparency = 0.7,
                    Parent = button
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
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                    BorderSizePixel = 0,
                    ZIndex = 7,
                    LayoutOrder = #sectionContent:GetChildren() + 1,
                    Parent = sectionContent
                })
                
                local toggleCorner = new('UICorner', {
                    CornerRadius = UDim.new(0, 8),
                    Parent = toggleFrame
                })
                
                local toggleStroke = new('UIStroke', {
                    Thickness = 1,
                    Color = Color3.fromRGB(100, 100, 100),
                    Transparency = 0.7,
                    Parent = toggleFrame
                })
                
                local toggleLabel = new('TextLabel', {
                    Size = UDim2.new(1, -60, 1, 0),
                    Position = UDim2.new(0, 15, 0, 0),
                    BackgroundTransparency = 1,
                    Text = toggleName,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 8,
                    Parent = toggleFrame
                })
                
                local toggleButton = new('TextButton', {
                    Size = UDim2.new(0, 45, 0, 22),
                    Position = UDim2.new(1, -55, 0.5, -11),
                    BackgroundColor3 = defaultValue and Color3.fromRGB(255, 85, 85) or Color3.fromRGB(60, 60, 60),
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 8,
                    Parent = toggleFrame
                })
                
                local toggleBtnCorner = new('UICorner', {
                    CornerRadius = UDim.new(0, 11),
                    Parent = toggleButton
                })
                
                local toggleIndicator = new('Frame', {
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = defaultValue and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    ZIndex = 9,
                    Parent = toggleButton
                })
                
                local indicatorCorner = new('UICorner', {
                    CornerRadius = UDim.new(0, 9),
                    Parent = toggleIndicator
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
                    Size = UDim2.new(1, 0, 0, 55),
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                    BorderSizePixel = 0,
                    ZIndex = 7,
                    LayoutOrder = #sectionContent:GetChildren() + 1,
                    Parent = sectionContent
                })
                
                local sliderCorner = new('UICorner', {
                    CornerRadius = UDim.new(0, 8),
                    Parent = sliderFrame
                })
                
                local sliderStroke = new('UIStroke', {
                    Thickness = 1,
                    Color = Color3.fromRGB(100, 100, 100),
                    Transparency = 0.7,
                    Parent = sliderFrame
                })
                
                local sliderLabel = new('TextLabel', {
                    Size = UDim2.new(1, -20, 0, 25),
                    Position = UDim2.new(0, 15, 0, 5),
                    BackgroundTransparency = 1,
                    Text = sliderName .. ": " .. defaultValue,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 8,
                    Parent = sliderFrame
                })
                
                local sliderTrack = new('Frame', {
                    Size = UDim2.new(1, -30, 0, 8),
                    Position = UDim2.new(0, 15, 0, 35),
                    BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                    BorderSizePixel = 0,
                    ZIndex = 8,
                    Parent = sliderFrame
                })
                
                local trackCorner = new('UICorner', {
                    CornerRadius = UDim.new(0, 4),
                    Parent = sliderTrack
                })
                
                local sliderFill = new('Frame', {
                    Size = UDim2.new((defaultValue - minValue) / (maxValue - minValue), 0, 1, 0),
                    BackgroundColor3 = Color3.fromRGB(255, 85, 85),
                    BorderSizePixel = 0,
                    ZIndex = 9,
                    Parent = sliderTrack
                })
                
                local fillCorner = new('UICorner', {
                    CornerRadius = UDim.new(0, 4),
                    Parent = sliderFill
                })
                
                local sliderButton = new('TextButton', {
                    Size = UDim2.new(0, 18, 0, 18),
                    Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -9, 0.5, -9),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 10,
                    Parent = sliderTrack
                })
                
                local btnCorner = new('UICorner', {
                    CornerRadius = UDim.new(0, 9),
                    Parent = sliderButton
                })
                
                local btnStroke = new('UIStroke', {
                    Thickness = 2,
                    Color = Color3.fromRGB(255, 85, 85),
                    Transparency = 0.5,
                    Parent = sliderButton
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
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                    BorderSizePixel = 0,
                    ZIndex = 7,
                    LayoutOrder = #sectionContent:GetChildren() + 1,
                    Parent = sectionContent
                })
                
                local keybindCorner = new('UICorner', {
                    CornerRadius = UDim.new(0, 8),
                    Parent = keybindFrame
                })
                
                local keybindStroke = new('UIStroke', {
                    Thickness = 1,
                    Color = Color3.fromRGB(100, 100, 100),
                    Transparency = 0.7,
                    Parent = keybindFrame
                })
                
                local keybindLabel = new('TextLabel', {
                    Size = UDim2.new(1, -100, 1, 0),
                    Position = UDim2.new(0, 15, 0, 0),
                    BackgroundTransparency = 1,
                    Text = keybindName,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 8,
                    Parent = keybindFrame
                })
                
                local keybindButton = new('TextButton', {
                    Size = UDim2.new(0, 80, 0, 25),
                    Position = UDim2.new(1, -90, 0.5, -12),
                    BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                    BorderSizePixel = 0,
                    Text = defaultKey,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    AutoButtonColor = false,
                    ZIndex = 8,
                    Parent = keybindFrame
                })
                
                local keyCorner = new('UICorner', {
                    CornerRadius = UDim.new(0, 6),
                    Parent = keybindButton
                })
                
                local keyStroke = new('UIStroke', {
                    Thickness = 1,
                    Color = Color3.fromRGB(255, 85, 85),
                    Transparency = 0.7,
                    Parent = keybindButton
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
                    Size = UDim2.new(1, 0, 0, 35),
                    BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                    BorderSizePixel = 0,
                    ZIndex = 7,
                    LayoutOrder = #sectionContent:GetChildren() + 1,
                    Parent = sectionContent
                })
                
                local dropCorner = new('UICorner', {
                    CornerRadius = UDim.new(0, 8),
                    Parent = dropdownFrame
                })
                
                local dropStroke = new('UIStroke', {
                    Thickness = 1,
                    Color = Color3.fromRGB(100, 100, 100),
                    Transparency = 0.7,
                    Parent = dropdownFrame
                })
                
                local dropLabel = new('TextLabel', {
                    Size = UDim2.new(1, -120, 1, 0),
                    Position = UDim2.new(0, 15, 0, 0),
                    BackgroundTransparency = 1,
                    Text = dropdownName,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 12,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 8,
                    Parent = dropdownFrame
                })
                
                local dropButton = new('TextButton', {
                    Size = UDim2.new(0, 100, 0, 25),
                    Position = UDim2.new(1, -110, 0.5, -12),
                    BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                    BorderSizePixel = 0,
                    Text = defaultValue .. " ▼",
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 10,
                    AutoButtonColor = false,
                    ZIndex = 8,
                    Parent = dropdownFrame
                })
                
                local dropBtnCorner = new('UICorner', {
                    CornerRadius = UDim.new(0, 6),
                    Parent = dropButton
                })
                
                local currentValue = defaultValue
                local isOpen = false
                
                if configEnabled then
                    configData[dropdownId] = defaultValue
                end
                
                local optionsFrame = new('Frame', {
                    Size = UDim2.new(0, 100, 0, 0),
                    Position = UDim2.new(1, -110, 1, 5),
                    BackgroundColor3 = Color3.fromRGB(50, 50, 50),
                    BorderSizePixel = 0,
                    ZIndex = 50,
                    Visible = false,
                    ClipsDescendants = true,
                    Parent = dropdownFrame
                })
                
                local optionsCorner = new('UICorner', {
                    CornerRadius = UDim.new(0, 6),
                    Parent = optionsFrame
                })
                
                local optionsLayout = new('UIListLayout', {
                    SortOrder = Enum.SortOrder.LayoutOrder,
                    Parent = optionsFrame
                })
                
                -- Create option buttons
                for i, option in ipairs(options) do
                    local optionButton = new('TextButton', {
                        Size = UDim2.new(1, 0, 0, 25),
                        BackgroundColor3 = Color3.fromRGB(60, 60, 60),
                        BorderSizePixel = 0,
                        Text = option,
                        TextColor3 = Color3.fromRGB(255, 255, 255),
                        Font = Enum.Font.Gotham,
                        TextSize = 10,
                        AutoButtonColor = false,
                        ZIndex = 51,
                        Parent = optionsFrame
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
        Library.visible = visible
        if isVisible then
            if minimized then
                minimizeButton:Fire()
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

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
            time or 0.3,
            style or Enum.EasingStyle.Quart,
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
    speed = 3,
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
    local rgbEnabled = options.RGB == true  -- Only true when explicitly set to true
    local configEnabled = options.SaveConfiguration == true
    local configFolder = options.ConfigFolder or "PickleUI"
    local configFile = options.ConfigFile or "config.json"
    
    -- Configuration system
    local configPath = configFolder .. '/' .. configFile
    local configData = {}
    
    if configEnabled then
        FileIO.mkdir(configFolder)
        print("Configuration enabled - Folder:", configFolder, "File:", configFile)
    end
    
    local function saveConfig()
        if configEnabled then
            local success = FileIO.write(configPath, HttpService:JSONEncode(configData))
            if success then
                print("Configuration saved successfully")
            else
                print("Failed to save configuration")
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
                    print("Configuration loaded successfully")
                    return configData
                else
                    print("Failed to decode configuration")
                end
            end
        end
        return {}
    end
    
    -- Confirmation Dialog Function
    local function createConfirmDialog(callback)
        local confirmGui = new('ScreenGui', {
            Name = "ConfirmDialog",
            Parent = LocalPlayer:WaitForChild('PlayerGui'),
            ResetOnSpawn = false,
            ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        })
        
        local overlay = new('Frame', {
            Parent = confirmGui,
            Size = UDim2.new(1, 0, 1, 0),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0.5,
            ZIndex = 100
        })
        
        local dialogFrame = new('Frame', {
            Parent = overlay,
            Size = UDim2.new(0, 300, 0, 150),
            Position = UDim2.new(0.5, -150, 0.5, -75),
            BackgroundColor3 = Color3.fromRGB(20, 20, 20),
            BorderSizePixel = 0,
            ZIndex = 101
        })
        
        local dialogCorner = new('UICorner', {
            Parent = dialogFrame,
            CornerRadius = UDim.new(0, 12)
        })
        
        local dialogStroke = new('UIStroke', {
            Parent = dialogFrame,
            Thickness = 2,
            Color = Color3.fromRGB(100, 100, 100),
            Transparency = 0.3
        })
        
        local titleLabel = new('TextLabel', {
            Parent = dialogFrame,
            Size = UDim2.new(1, -20, 0, 40),
            Position = UDim2.new(0, 10, 0, 10),
            BackgroundTransparency = 1,
            Text = "Confirm Close",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.GothamSemibold,
            TextSize = 16,
            TextXAlignment = Enum.TextXAlignment.Center,
            ZIndex = 102
        })
        
        local messageLabel = new('TextLabel', {
            Parent = dialogFrame,
            Size = UDim2.new(1, -20, 0, 40),
            Position = UDim2.new(0, 10, 0, 50),
            BackgroundTransparency = 1,
            Text = "Are you sure you want to close the UI?",
            TextColor3 = Color3.fromRGB(200, 200, 200),
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Center,
            TextWrapped = true,
            ZIndex = 102
        })
        
        local yesButton = new('TextButton', {
            Parent = dialogFrame,
            Size = UDim2.new(0, 80, 0, 30),
            Position = UDim2.new(0.5, -85, 1, -40),
            BackgroundColor3 = Color3.fromRGB(220, 53, 69),
            BorderSizePixel = 0,
            Text = "Yes",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.GothamSemibold,
            TextSize = 12,
            AutoButtonColor = false,
            ZIndex = 102
        })
        
        local yesCorner = new('UICorner', {
            Parent = yesButton,
            CornerRadius = UDim.new(0, 8)
        })
        
        local noButton = new('TextButton', {
            Parent = dialogFrame,
            Size = UDim2.new(0, 80, 0, 30),
            Position = UDim2.new(0.5, 5, 1, -40),
            BackgroundColor3 = Color3.fromRGB(108, 117, 125),
            BorderSizePixel = 0,
            Text = "No",
            TextColor3 = Color3.fromRGB(255, 255, 255),
            Font = Enum.Font.GothamSemibold,
            TextSize = 12,
            AutoButtonColor = false,
            ZIndex = 102
        })
        
        local noCorner = new('UICorner', {
            Parent = noButton,
            CornerRadius = UDim.new(0, 8)
        })
        
        -- Animate in
        dialogFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
        tween(dialogFrame, {Position = UDim2.new(0.5, -150, 0.5, -75)}, 0.4, Enum.EasingStyle.Back)
        
        yesButton.MouseButton1Click:Connect(function()
            tween(dialogFrame, {Position = UDim2.new(0.5, -150, 0.5, 200)}, 0.3)
            spawn(function()
                wait(0.3)
                confirmGui:Destroy()
                if callback then callback(true) end
            end)
        end)
        
        noButton.MouseButton1Click:Connect(function()
            tween(dialogFrame, {Position = UDim2.new(0.5, -150, 0.5, 200)}, 0.3)
            spawn(function()
                wait(0.3)
                confirmGui:Destroy()
                if callback then callback(false) end
            end)
        end)
        
        -- Button hover effects
        yesButton.MouseEnter:Connect(function()
            tween(yesButton, {BackgroundColor3 = Color3.fromRGB(240, 73, 89)}, 0.2)
        end)
        yesButton.MouseLeave:Connect(function()
            tween(yesButton, {BackgroundColor3 = Color3.fromRGB(220, 53, 69)}, 0.2)
        end)
        
        noButton.MouseEnter:Connect(function()
            tween(noButton, {BackgroundColor3 = Color3.fromRGB(128, 137, 145)}, 0.2)
        end)
        noButton.MouseLeave:Connect(function()
            tween(noButton, {BackgroundColor3 = Color3.fromRGB(108, 117, 125)}, 0.2)
        end)
    end
    
    -- Main ScreenGui
    local screenGui = new('ScreenGui', {
        Name = "PickleUI",
        Parent = LocalPlayer:WaitForChild('PlayerGui'),
        ResetOnSpawn = false,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    
    -- Main container
    local container = new('Frame', {
        Parent = screenGui,
        Size = UDim2.new(0, 0, 0, 0), -- Start with 0 size for animation
        Position = UDim2.new(1, -510, 0, 10),
        BackgroundTransparency = 1,
        ZIndex = 1,
        ClipsDescendants = true
    })
    
    -- Main window frame (BLACK) with rounded corners
    local mainFrame = new('Frame', {
        Parent = container,
        Size = UDim2.new(1, 0, 1, 0),
        Position = UDim2.new(0, 0, 0, 0),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 2
    })
    
    local mainCorner = new('UICorner', {
        Parent = mainFrame,
        CornerRadius = UDim.new(0, 12)
    })
    
    local mainStroke = new('UIStroke', {
        Parent = mainFrame,
        Thickness = 2,
        Color = Color3.fromRGB(255, 255, 255),
        Transparency = 0.5
    })
    
    -- Title bar (BLACK) with rounded top corners
    local titleBar = new('Frame', {
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 0, 35),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 3
    })
    
    local titleCorner = new('UICorner', {
        Parent = titleBar,
        CornerRadius = UDim.new(0, 12)
    })
    
    -- Create a bottom cover for title bar to only round top corners
    local titleCover = new('Frame', {
        Parent = titleBar,
        Size = UDim2.new(1, 0, 0, 12),
        Position = UDim2.new(0, 0, 1, -12),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BorderSizePixel = 0,
        ZIndex = 3
    })
    
    local titleLabel = new('TextLabel', {
        Parent = titleBar,
        Text = title,
        Size = UDim2.new(1, -80, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        TextColor3 = Color3.fromRGB(255, 255, 255),
        Font = Enum.Font.GothamSemibold,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 4
    })
    
    -- Control buttons with rounded corners
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
        BackgroundColor3 = Color3.fromRGB(128, 128, 128),
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
    
    local minStroke = new('UIStroke', {
        Parent = minimizeButton,
        Thickness = 1,
        Color = Color3.fromRGB(0, 0, 0),
        Transparency = 0.3
    })
    
    -- Content area
    local contentFrame = new('Frame', {
        Parent = mainFrame,
        Size = UDim2.new(1, 0, 1, -35),
        Position = UDim2.new(0, 0, 0, 35),
        BackgroundTransparency = 1,
        ZIndex = 3
    })
    
    -- Tab navigation (left side) - Darker black with rounded corners
    local tabFrame = new('Frame', {
        Parent = contentFrame,
        Size = UDim2.new(0, 140, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
        BorderSizePixel = 0,
        ZIndex = 4
    })
    
    local tabCorner = new('UICorner', {
        Parent = tabFrame,
        CornerRadius = UDim.new(0, 10)
    })
    
    local tabScrollFrame = new('ScrollingFrame', {
        Parent = tabFrame,
        Size = UDim2.new(1, -10, 1, -10),
        Position = UDim2.new(0, 5, 0, 5),
        BackgroundTransparency = 1,
        ScrollBarThickness = 6,
        ScrollBarImageColor3 = Color3.fromRGB(100, 100, 100),
        ZIndex = 5,
        BorderSizePixel = 0
    })
    
    tabScrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
    
    local tabLayout = new('UIListLayout', {
        Parent = tabScrollFrame,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    
    -- Content area (right side) - Darker black with rounded corners
    local pageFrame = new('Frame', {
        Parent = contentFrame,
        Size = UDim2.new(1, -155, 1, -10),
        Position = UDim2.new(0, 150, 0, 5),
        BackgroundColor3 = Color3.fromRGB(10, 10, 10),
        BorderSizePixel = 0,
        ZIndex = 4
    })
    
    local pageCorner = new('UICorner', {
        Parent = pageFrame,
        CornerRadius = UDim.new(0, 10)
    })
    
    -- Variables
    local tabs = {}
    local currentTab = nil
    local visible = true
    local minimized = false
    local configElements = {}
    
    -- Opening Animation
    spawn(function()
        wait(0.1)
        tween(container, {
            Size = UDim2.new(0, 500, 0, 350)
        }, 0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
    end)
    
    -- Enhanced Dragging functionality
    local dragging = false
    local dragStart = nil
    local startPos = nil
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = container.Position
            
            -- Visual feedback
            tween(titleBar, {BackgroundColor3 = Color3.fromRGB(15, 15, 15)}, 0.2)
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                    tween(titleBar, {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}, 0.2)
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement and dragging then
            if dragStart and startPos then
                local delta = input.Position - dragStart
                local newPos = UDim2.new(
                    startPos.X.Scale,
                    startPos.X.Offset + delta.X,
                    startPos.Y.Scale,
                    startPos.Y.Offset + delta.Y
                )
                
                -- Smooth dragging animation
                tween(container, {Position = newPos}, 0.1, Enum.EasingStyle.Quad)
            end
        end
    end)
    
    -- Enhanced Button functionality with confirmation
    closeButton.MouseButton1Click:Connect(function()
        createConfirmDialog(function(confirmed)
            if confirmed then
                tween(container, {
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(container.Position.X.Scale, container.Position.X.Offset + 250, container.Position.Y.Scale, container.Position.Y.Offset + 175)
                }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
                spawn(function()
                    wait(0.5)
                    screenGui:Destroy()
                end)
            end
        end)
    end)
    
    minimizeButton.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            tween(container, {Size = UDim2.new(0, 500, 0, 35)}, 0.4, Enum.EasingStyle.Quart)
        else
            tween(container, {Size = UDim2.new(0, 500, 0, 350)}, 0.4, Enum.EasingStyle.Quart)
        end
    end)
    
    -- Button hover effects
    closeButton.MouseEnter:Connect(function()
        tween(closeButton, {BackgroundColor3 = Color3.fromRGB(216, 63, 48)}, 0.2)
    end)
    closeButton.MouseLeave:Connect(function()
        tween(closeButton, {BackgroundColor3 = Color3.fromRGB(196, 43, 28)}, 0.2)
    end)
    
    minimizeButton.MouseEnter:Connect(function()
        tween(minimizeButton, {BackgroundColor3 = Color3.fromRGB(148, 148, 148)}, 0.2)
    end)
    minimizeButton.MouseLeave:Connect(function()
        tween(minimizeButton, {BackgroundColor3 = Color3.fromRGB(128, 128, 128)}, 0.2)
    end)
    
    -- RGB Animation with proper clipping and transparency
    if rgbEnabled then
        spawn(function()
            while screenGui and screenGui.Parent do
                local color = RGBColors:Update()
                mainStroke.Color = color
                mainStroke.Transparency = 0.3
                
                -- Apply RGB to all elements with RGB enabled
                for _, element in pairs(configElements) do
                    if element.rgbStroke and element.rgbStroke.Parent then
                        element.rgbStroke.Color = color
                        element.rgbStroke.Transparency = 0.3
                    end
                end
                
                wait(0.05) -- Smoother RGB animation
            end
        end)
    end
    
    -- API Functions
    local Library = {}
    
    function Library:CreateTab(name)
        local tabButton = new('TextButton', {
            Parent = tabScrollFrame,
            Size = UDim2.new(1, 0, 0, 32),
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BorderSizePixel = 0,
            Text = name,
            TextColor3 = Color3.fromRGB(200, 200, 200),
            Font = Enum.Font.Gotham,
            TextSize = 11,
            AutoButtonColor = false,
            ZIndex = 6,
            LayoutOrder = #tabs + 1
        })
        
        local buttonCorner = new('UICorner', {
            Parent = tabButton,
            CornerRadius = UDim.new(0, 8)
        })
        
        local buttonStroke = new('UIStroke', {
            Parent = tabButton,
            Thickness = 1,
            Color = Color3.fromRGB(128, 128, 128),
            Transparency = 0.5
        })
        
        local tabContent = new('ScrollingFrame', {
            Parent = pageFrame,
            Size = UDim2.new(1, -10, 1, -10),
            Position = UDim2.new(0, 5, 0, 5),
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
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder
        })
        
        local contentPadding = new('UIPadding', {
            Parent = tabContent,
            PaddingTop = UDim.new(0, 8),
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8)
        })
        
        -- Enhanced tab button events
        tabButton.MouseEnter:Connect(function()
            if currentTab ~= tabContent then
                tween(tabButton, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}, 0.2)
                tween(tabButton, {Size = UDim2.new(1, 0, 0, 34)}, 0.2)
            end
        end)
        
        tabButton.MouseLeave:Connect(function()
            if currentTab ~= tabContent then
                tween(tabButton, {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}, 0.2)
                tween(tabButton, {Size = UDim2.new(1, 0, 0, 32)}, 0.2)
            end
        end)
        
        tabButton.MouseButton1Click:Connect(function()
            -- Hide all other tabs and reset their colors/sizes
            for _, tab in pairs(tabs) do
                tab.content.Visible = false
                tween(tab.button, {BackgroundColor3 = Color3.fromRGB(0, 0, 0)}, 0.2)
                tween(tab.button, {Size = UDim2.new(1, 0, 0, 32)}, 0.2)
            end
            
            -- Show current tab and highlight button
            tabContent.Visible = true
            tween(tabButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2)
            tween(tabButton, {Size = UDim2.new(1, 0, 0, 36)}, 0.2)
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
            spawn(function()
                wait(0.2)
                tabButton.MouseButton1Click:Fire()
            end)
        end
        
        -- Tab methods
        function tab:CreateSection(sectionName)
            local sectionFrame = new('Frame', {
                Parent = tabContent,
                Size = UDim2.new(1, 0, 0, 30),
                BackgroundTransparency = 1,
                ZIndex = 6,
                LayoutOrder = #tabContent:GetChildren() + 1
            })
            
            local sectionLabel = new('TextLabel', {
                Parent = sectionFrame,
                Size = UDim2.new(1, 0, 0, 25),
                Position = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1,
                Text = sectionName,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                Font = Enum.Font.GothamSemibold,
                TextSize = 13,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 7
            })
            
            local sectionContent = new('Frame', {
                Parent = sectionFrame,
                Size = UDim2.new(1, 0, 0, 0),
                Position = UDim2.new(0, 0, 0, 30),
                BackgroundTransparency = 1,
                ZIndex = 6
            })
            
            local sectionLayout = new('UIListLayout', {
                Parent = sectionContent,
                Padding = UDim.new(0, 5),
                SortOrder = Enum.SortOrder.LayoutOrder
            })
            
            -- Auto-resize section when content changes
            local function updateSectionSize()
                spawn(function()
                    wait()
                    local contentSize = sectionLayout.AbsoluteContentSize.Y
                    sectionContent.Size = UDim2.new(1, 0, 0, contentSize)
                    sectionFrame.Size = UDim2.new(1, 0, 0, contentSize + 30)
                end)
            end
            
            sectionLayout.Changed:Connect(updateSectionSize)
            
            local section = {
                frame = sectionFrame,
                content = sectionContent,
                updateSize = updateSectionSize
            }
            
            function section:CreateButton(buttonName, callback)
                local buttonId = name .. "_" .. sectionName .. "_" .. buttonName
                
                local button = new('TextButton', {
                    Parent = sectionContent,
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
                    BorderSizePixel = 0,
                    Text = buttonName,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
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
                    Color = Color3.fromRGB(128, 128, 128),
                    Transparency = 0.7
                })
                
                -- Add RGB effect if enabled
                if rgbEnabled then
                    configElements[buttonId] = {
                        rgbStroke = buttonStroke
                    }
                end
                
                button.MouseEnter:Connect(function()
                    tween(button, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.2)
                    tween(button, {Size = UDim2.new(1, 0, 0, 34)}, 0.15)
                end)
                
                button.MouseLeave:Connect(function()
                    tween(button, {BackgroundColor3 = Color3.fromRGB(15, 15, 15)}, 0.2)
                    tween(button, {Size = UDim2.new(1, 0, 0, 32)}, 0.15)
                end)
                
                button.MouseButton1Click:Connect(function()
                    tween(button, {Size = UDim2.new(1, 0, 0, 30)}, 0.1)
                    spawn(function()
                        wait(0.1)
                        tween(button, {Size = UDim2.new(1, 0, 0, 32)}, 0.1)
                    end)
                    
                    if callback then
                        pcall(callback)
                    end
                end)
                
                updateSectionSize()
                return button
            end
            
            function section:CreateToggle(toggleName, defaultValue, callback)
                defaultValue = defaultValue or false
                local toggleId = name .. "_" .. sectionName .. "_" .. toggleName
                
                local toggleFrame = new('Frame', {
                    Parent = sectionContent,
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
                    BorderSizePixel = 0,
                    ZIndex = 7,
                    LayoutOrder = #sectionContent:GetChildren() + 1
                })
                
                local toggleFrameCorner = new('UICorner', {
                    Parent = toggleFrame,
                    CornerRadius = UDim.new(0, 8)
                })
                
                local toggleFrameStroke = new('UIStroke', {
                    Parent = toggleFrame,
                    Thickness = 1,
                    Color = Color3.fromRGB(128, 128, 128),
                    Transparency = 0.7
                })
                
                local toggleLabel = new('TextLabel', {
                    Parent = toggleFrame,
                    Size = UDim2.new(1, -50, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    BackgroundTransparency = 1,
                    Text = toggleName,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 8
                })
                
                local toggleButton = new('TextButton', {
                    Parent = toggleFrame,
                    Size = UDim2.new(0, 40, 0, 20),
                    Position = UDim2.new(1, -46, 0.5, -10),
                    BackgroundColor3 = defaultValue and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(40, 40, 40),
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
                    Position = defaultValue and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    ZIndex = 9
                })
                
                local indicatorCorner = new('UICorner', {
                    Parent = toggleIndicator,
                    CornerRadius = UDim.new(0, 8)
                })
                
                local toggled = defaultValue
                
                -- Save to config if config is enabled
                if configEnabled then
                    configData[toggleId] = defaultValue
                end
                
                -- Hover effects
                toggleFrame.MouseEnter:Connect(function()
                    tween(toggleFrame, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}, 0.2)
                end)
                
                toggleFrame.MouseLeave:Connect(function()
                    tween(toggleFrame, {BackgroundColor3 = Color3.fromRGB(15, 15, 15)}, 0.2)
                end)
                
                toggleButton.MouseButton1Click:Connect(function()
                    toggled = not toggled
                    
                    tween(toggleButton, {
                        BackgroundColor3 = toggled and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(40, 40, 40)
                    }, 0.3, Enum.EasingStyle.Quart)
                    tween(toggleIndicator, {
                        Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                    }, 0.3, Enum.EasingStyle.Quart)
                    
                    -- Save to config
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
                        toggleButton.BackgroundColor3 = toggled and Color3.fromRGB(0, 162, 255) or Color3.fromRGB(40, 40, 40)
                        toggleIndicator.Position = toggled and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
                        
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
            
            function section:CreateSlider(sliderName, minValue, maxValue, defaultValue, callback)
                minValue = minValue or 0
                maxValue = maxValue or 100
                defaultValue = defaultValue or minValue
                local sliderId = name .. "_" .. sectionName .. "_" .. sliderName
                
                local sliderFrame = new('Frame', {
                    Parent = sectionContent,
                    Size = UDim2.new(1, 0, 0, 50),
                    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
                    BorderSizePixel = 0,
                    ZIndex = 7,
                    LayoutOrder = #sectionContent:GetChildren() + 1
                })
                
                local sliderFrameCorner = new('UICorner', {
                    Parent = sliderFrame,
                    CornerRadius = UDim.new(0, 8)
                })
                
                local sliderFrameStroke = new('UIStroke', {
                    Parent = sliderFrame,
                    Thickness = 1,
                    Color = Color3.fromRGB(128, 128, 128),
                    Transparency = 0.7
                })
                
                local sliderLabel = new('TextLabel', {
                    Parent = sliderFrame,
                    Size = UDim2.new(1, -20, 0, 20),
                    Position = UDim2.new(0, 12, 0, 5),
                    BackgroundTransparency = 1,
                    Text = sliderName .. ": " .. defaultValue,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 8
                })
                
                local sliderTrack = new('Frame', {
                    Parent = sliderFrame,
                    Size = UDim2.new(1, -24, 0, 8),
                    Position = UDim2.new(0, 12, 0, 30),
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
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
                    BackgroundColor3 = Color3.fromRGB(0, 162, 255),
                    BorderSizePixel = 0,
                    ZIndex = 9
                })
                
                local fillCorner = new('UICorner', {
                    Parent = sliderFill,
                    CornerRadius = UDim.new(0, 4)
                })
                
                local sliderButton = new('TextButton', {
                    Parent = sliderTrack,
                    Size = UDim2.new(0, 16, 0, 16),
                    Position = UDim2.new((defaultValue - minValue) / (maxValue - minValue), -8, 0.5, -8),
                    BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                    BorderSizePixel = 0,
                    Text = "",
                    AutoButtonColor = false,
                    ZIndex = 10
                })
                
                local buttonCorner = new('UICorner', {
                    Parent = sliderButton,
                    CornerRadius = UDim.new(0, 8)
                })
                
                local buttonStroke = new('UIStroke', {
                    Parent = sliderButton,
                    Thickness = 2,
                    Color = Color3.fromRGB(0, 162, 255),
                    Transparency = 0.5
                })
                
                local currentValue = defaultValue
                local dragging = false
                
                -- Save to config if config is enabled
                if configEnabled then
                    configData[sliderId] = defaultValue
                end
                
                -- Hover effects
                sliderFrame.MouseEnter:Connect(function()
                    tween(sliderFrame, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}, 0.2)
                end)
                
                sliderFrame.MouseLeave:Connect(function()
                    if not dragging then
                        tween(sliderFrame, {BackgroundColor3 = Color3.fromRGB(15, 15, 15)}, 0.2)
                    end
                end)
                
                sliderButton.MouseEnter:Connect(function()
                    tween(sliderButton, {Size = UDim2.new(0, 18, 0, 18)}, 0.2)
                    tween(sliderButton, {Position = UDim2.new((currentValue - minValue) / (maxValue - minValue), -9, 0.5, -9)}, 0.2)
                end)
                
                sliderButton.MouseLeave:Connect(function()
                    if not dragging then
                        tween(sliderButton, {Size = UDim2.new(0, 16, 0, 16)}, 0.2)
                        tween(sliderButton, {Position = UDim2.new((currentValue - minValue) / (maxValue - minValue), -8, 0.5, -8)}, 0.2)
                    end
                end)
                
                local function updateSlider(relativeX)
                    relativeX = math.clamp(relativeX, 0, 1)
                    currentValue = math.floor(minValue + (maxValue - minValue) * relativeX + 0.5)
                    sliderLabel.Text = sliderName .. ": " .. currentValue
                    
                    tween(sliderFill, {Size = UDim2.new(relativeX, 0, 1, 0)}, 0.1)
                    local buttonSize = dragging and 18 or 16
                    local offset = dragging and -9 or -8
                    tween(sliderButton, {Position = UDim2.new(relativeX, offset, 0.5, offset)}, 0.1)
                    
                    -- Save to config
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
                    tween(sliderButton, {Size = UDim2.new(0, 20, 0, 20)}, 0.15)
                    tween(sliderFrame, {BackgroundColor3 = Color3.fromRGB(35, 35, 35)}, 0.2)
                end)
                
                UserInputService.InputEnded:Connect(function(input)
                    if input.UserInputType == Enum.UserInputType.MouseButton1 and dragging then
                        dragging = false
                        tween(sliderButton, {Size = UDim2.new(0, 16, 0, 16)}, 0.15)
                        tween(sliderButton, {Position = UDim2.new((currentValue - minValue) / (maxValue - minValue), -8, 0.5, -8)}, 0.15)
                        tween(sliderFrame, {BackgroundColor3 = Color3.fromRGB(15, 15, 15)}, 0.2)
                    end
                end)
                
                UserInputService.InputChanged:Connect(function(input)
                    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                        local mouse = UserInputService:GetMouseLocation()
                        local relativeX = (mouse.X - sliderTrack.AbsolutePosition.X) / sliderTrack.AbsoluteSize.X
                        updateSlider(relativeX)
                    end
                end)
                
                -- Click on track to set value
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
                        sliderButton.Position = UDim2.new(relativeX, -8, 0.5, -8)
                        
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
            
            function section:CreateKeybind(keybindName, defaultKey, callback)
                defaultKey = defaultKey or "None"
                local keybindId = name .. "_" .. sectionName .. "_" .. keybindName
                
                local keybindFrame = new('Frame', {
                    Parent = sectionContent,
                    Size = UDim2.new(1, 0, 0, 32),
                    BackgroundColor3 = Color3.fromRGB(15, 15, 15),
                    BorderSizePixel = 0,
                    ZIndex = 7,
                    LayoutOrder = #sectionContent:GetChildren() + 1
                })
                
                local keybindFrameCorner = new('UICorner', {
                    Parent = keybindFrame,
                    CornerRadius = UDim.new(0, 8)
                })
                
                local keybindFrameStroke = new('UIStroke', {
                    Parent = keybindFrame,
                    Thickness = 1,
                    Color = Color3.fromRGB(128, 128, 128),
                    Transparency = 0.7
                })
                
                local keybindLabel = new('TextLabel', {
                    Parent = keybindFrame,
                    Size = UDim2.new(1, -90, 1, 0),
                    Position = UDim2.new(0, 12, 0, 0),
                    BackgroundTransparency = 1,
                    Text = keybindName,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 11,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    ZIndex = 8
                })
                
                local keybindButton = new('TextButton', {
                    Parent = keybindFrame,
                    Size = UDim2.new(0, 80, 0, 22),
                    Position = UDim2.new(1, -86, 0.5, -11),
                    BackgroundColor3 = Color3.fromRGB(40, 40, 40),
                    BorderSizePixel = 0,
                    Text = defaultKey,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                    Font = Enum.Font.Gotham,
                    TextSize = 10,
                    AutoButtonColor = false,
                    ZIndex = 8
                })
                
                local keybindCorner = new('UICorner', {
                    Parent = keybindButton,
                    CornerRadius = UDim.new(0, 6)
                })
                
                local keybindStroke = new('UIStroke', {
                    Parent = keybindButton,
                    Thickness = 1,
                    Color = Color3.fromRGB(100, 100, 100),
                    Transparency = 0.5
                })
                
                local currentKey = defaultKey
                local listening = false
                
                -- Save to config if config is enabled
                if configEnabled then
                    configData[keybindId] = defaultKey
                end
                
                -- Hover effects
                keybindFrame.MouseEnter:Connect(function()
                    tween(keybindFrame, {BackgroundColor3 = Color3.fromRGB(25, 25, 25)}, 0.2)
                end)
                
                keybindFrame.MouseLeave:Connect(function()
                    tween(keybindFrame, {BackgroundColor3 = Color3.fromRGB(15, 15, 15)}, 0.2)
                end)
                
                keybindButton.MouseEnter:Connect(function()
                    if not listening then
                        tween(keybindButton, {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}, 0.2)
                    end
                end)
                
                keybindButton.MouseLeave:Connect(function()
                    if not listening then
                        tween(keybindButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2)
                    end
                end)
                
                keybindButton.MouseButton1Click:Connect(function()
                    if not listening then
                        listening = true
                        keybindButton.Text = "Press..."
                        tween(keybindButton, {BackgroundColor3 = Color3.fromRGB(0, 162, 255)}, 0.2)
                        tween(keybindButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
                        
                        -- Pulse effect while listening
                        spawn(function()
                            while listening do
                                tween(keybindStroke, {Transparency = 0}, 0.5)
                                wait(0.5)
                                if listening then
                                    tween(keybindStroke, {Transparency = 0.5}, 0.5)
                                    wait(0.5)
                                end
                            end
                        end)
                    end
                end)
                
                UserInputService.InputBegan:Connect(function(input, gameProcessed)
                    if gameProcessed then return end
                    
                    if listening and input.UserInputType == Enum.UserInputType.Keyboard then
                        local keyName = input.KeyCode.Name
                        currentKey = keyName
                        keybindButton.Text = keyName
                        tween(keybindButton, {BackgroundColor3 = Color3.fromRGB(40, 40, 40)}, 0.2)
                        tween(keybindButton, {TextColor3 = Color3.fromRGB(255, 255, 255)}, 0.2)
                        tween(keybindStroke, {Transparency = 0.5}, 0.2)
                        listening = false
                        
                        -- Save to config
                        if configEnabled then
                            configData[keybindId] = currentKey
                            saveConfig()
                        end
                    end
                    
                    if not listening and input.UserInputType == Enum.UserInputType.Keyboard and input.KeyCode.Name == currentKey then
                        -- Visual feedback
                        tween(keybindButton, {Size = UDim2.new(0, 76, 0, 20)}, 0.1)
                        spawn(function()
                            wait(0.1)
                            tween(keybindButton, {Size = UDim2.new(0, 80, 0, 22)}, 0.1)
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
            
            return section
        end
        
        return tab
    end
    
    function Library:Destroy()
        tween(container, {
            Size = UDim2.new(0, 0, 0, 0),
            Position = UDim2.new(container.Position.X.Scale, container.Position.X.Offset + 250, container.Position.Y.Scale, container.Position.Y.Offset + 175)
        }, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In)
        spawn(function()
            wait(0.5)
            screenGui:Destroy()
        end)
    end
    
    function Library:SetVisible(isVisible)
        visible = isVisible
        if isVisible then
            container.Visible = true
            tween(container, {Size = UDim2.new(0, 500, 0, 350)}, 0.4, Enum.EasingStyle.Back)
        else
            tween(container, {Size = UDim2.new(0, 0, 0, 0)}, 0.4, Enum.EasingStyle.Back)
            spawn(function()
                wait(0.4)
                container.Visible = false
            end)
        end
    end
    
    function Library:LoadConfiguration()
        if configEnabled then
            print("Loading configuration...")
            local loadedConfig = loadConfig()
            
            -- Apply loaded configuration to all elements
            for elementId, value in pairs(loadedConfig) do
                -- Find the element and apply the value
                for _, element in pairs(configElements) do
                    if element.configId == elementId then
                        if element.SetValue then
                            element.SetValue(value)
                        end
                        break
                    end
                end
            end
            
            print("Configuration loaded and applied")
        else
            print("Configuration is disabled for this window")
        end
    end
    
    function Library:SaveConfiguration()
        if configEnabled then
            saveConfig()
            print("Configuration saved manually")
        else
            print("Configuration is disabled for this window")
        end
    end
    
    -- Store elements for configuration loading
    Library._configElements = configElements
    Library._configData = configData
    
    return Library
end

return Pickle

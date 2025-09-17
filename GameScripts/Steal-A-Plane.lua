-- Enhanced Steal a Plane - Script Hub X by michel (Improved UI)
-- Features: Better animations, confirmation dialogs, improved minimize, draggable titlebar, sections

--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local Workspace = game:GetService("Workspace")

--// Player refs
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

player.CharacterAdded:Connect(function(chr)
    character = chr
    humanoid = chr:WaitForChild("Humanoid")
    rootPart = chr:WaitForChild("HumanoidRootPart")
end)

--// Remotes
local RFAskLock = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/AskLock"]
local RECollect = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RE/Collect"]
local RFStealPlane = ReplicatedStorage.Packages._Index["sleitnick_net@0.2.0"].net["RF/StealPlane"]

--// Utility
local function new(class, props, parent)
    local inst = Instance.new(class)
    for k,v in pairs(props or {}) do inst[k]=v end
    inst.Parent = parent
    return inst
end

--// Theme Colors
local theme = {
    primary = Color3.fromRGB(88, 101, 242),
    secondary = Color3.fromRGB(114, 137, 218),
    success = Color3.fromRGB(67, 181, 129),
    danger = Color3.fromRGB(237, 66, 69),
    warning = Color3.fromRGB(250, 166, 26),
    dark = Color3.fromRGB(32, 34, 37),
    darker = Color3.fromRGB(47, 49, 54),
    light = Color3.fromRGB(64, 68, 75),
    text = Color3.fromRGB(220, 221, 222),
    textDim = Color3.fromRGB(142, 146, 151),
    accent = Color3.fromRGB(255, 73, 97)
}

--// ScreenGui
local screenGui = new("ScreenGui", {
    Name = "EnhancedStealPlaneHub",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}, player:WaitForChild("PlayerGui"))

--==================================================
-- Enhanced Notification System
--==================================================
local NotifContainer = new("Frame", {
    Name = "NotifContainer",
    Size = UDim2.new(0, 320, 1, 0),
    Position = UDim2.new(1, -340, 0, 0),
    BackgroundTransparency = 1,
    ZIndex = 100
}, screenGui)

local activeNotifs = {}
local function createNotification(text, notifType)
    notifType = notifType or "info"
    local colors = {
        info = theme.primary,
        success = theme.success,
        warning = theme.warning,
        error = theme.danger
    }
    
    local notif = new("Frame", {
        Name = "Notification",
        Size = UDim2.new(0, 300, 0, 60),
        Position = UDim2.new(1, 320, 0, 20 + (#activeNotifs * 70)),
        BackgroundColor3 = theme.darker,
        BorderSizePixel = 0,
        ZIndex = 101
    })
    
    new("UICorner", {CornerRadius = UDim.new(0, 12)}, notif)
    new("UIStroke", {
        Thickness = 2,
        Color = colors[notifType] or theme.primary,
        Transparency = 0.3
    }, notif)
    
    -- Glow effect
    local glow = new("Frame", {
        Size = UDim2.new(1, 10, 1, 10),
        Position = UDim2.new(0, -5, 0, -5),
        BackgroundColor3 = colors[notifType] or theme.primary,
        BackgroundTransparency = 0.9,
        ZIndex = 100
    }, notif)
    new("UICorner", {CornerRadius = UDim.new(0, 17)}, glow)
    
    -- Icon
    local icon = new("Frame", {
        Size = UDim2.new(0, 6, 0, 40),
        Position = UDim2.new(0, 0, 0, 10),
        BackgroundColor3 = colors[notifType] or theme.primary,
        BorderSizePixel = 0,
        ZIndex = 102
    }, notif)
    new("UICorner", {CornerRadius = UDim.new(0, 3)}, icon)
    
    -- Text
    local label = new("TextLabel", {
        Size = UDim2.new(1, -20, 1, 0),
        Position = UDim2.new(0, 15, 0, 0),
        BackgroundTransparency = 1,
        Text = tostring(text),
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextColor3 = theme.text,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        TextWrapped = true,
        ZIndex = 102
    }, notif)
    
    notif.Parent = NotifContainer
    table.insert(activeNotifs, notif)
    
    -- Slide in animation
    TweenService:Create(notif, TweenInfo.new(0.6, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 20 + (#activeNotifs - 1) * 70)
    }):Play()
    
    -- Update positions of existing notifications
    for i, old in ipairs(activeNotifs) do
        if old ~= notif then
            TweenService:Create(old, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 0, 0, 20 + (i - 1) * 70)
            }):Play()
        end
    end
    
    -- Auto remove
    task.delay(5, function()
        local idx = table.find(activeNotifs, notif)
        if idx then
            table.remove(activeNotifs, idx)
            TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 320, 0, notif.Position.Y.Offset),
                BackgroundTransparency = 1
            }):Play()
            task.wait(0.4)
            if notif then notif:Destroy() end
            
            -- Reposition remaining notifications
            for i, old in ipairs(activeNotifs) do
                TweenService:Create(old, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0, 0, 0, 20 + (i - 1) * 70)
                }):Play()
            end
        end
    end)
end

--==================================================
-- Confirmation Dialog
--==================================================
local function createConfirmDialog(title, message, onConfirm)
    local overlay = new("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 1,
        ZIndex = 200
    }, screenGui)
    
    local dialog = new("Frame", {
        Size = UDim2.new(0, 320, 0, 180),
        Position = UDim2.new(0.5, -160, 0.5, -90),
        BackgroundColor3 = theme.darker,
        BorderSizePixel = 0,
        ZIndex = 201
    }, overlay)
    
    new("UICorner", {CornerRadius = UDim.new(0, 16)}, dialog)
    new("UIStroke", {Thickness = 2, Color = theme.light}, dialog)
    
    -- Title
    new("TextLabel", {
        Size = UDim2.new(1, -20, 0, 40),
        Position = UDim2.new(0, 10, 0, 10),
        BackgroundTransparency = 1,
        Text = title,
        Font = Enum.Font.GothamBold,
        TextSize = 18,
        TextColor3 = theme.text,
        TextXAlignment = Enum.TextXAlignment.Center
    }, dialog)
    
    -- Message
    new("TextLabel", {
        Size = UDim2.new(1, -20, 0, 60),
        Position = UDim2.new(0, 10, 0, 50),
        BackgroundTransparency = 1,
        Text = message,
        Font = Enum.Font.Gotham,
        TextSize = 14,
        TextColor3 = theme.textDim,
        TextXAlignment = Enum.TextXAlignment.Center,
        TextYAlignment = Enum.TextYAlignment.Top,
        TextWrapped = true
    }, dialog)
    
    -- Buttons
    local cancelBtn = new("TextButton", {
        Size = UDim2.new(0, 120, 0, 40),
        Position = UDim2.new(0, 20, 1, -55),
        BackgroundColor3 = theme.light,
        Text = "Cancel",
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        TextColor3 = theme.text
    }, dialog)
    new("UICorner", {CornerRadius = UDim.new(0, 8)}, cancelBtn)
    
    local confirmBtn = new("TextButton", {
        Size = UDim2.new(0, 120, 0, 40),
        Position = UDim2.new(1, -140, 1, -55),
        BackgroundColor3 = theme.danger,
        Text = "Confirm",
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Color3.new(1, 1, 1)
    }, dialog)
    new("UICorner", {CornerRadius = UDim.new(0, 8)}, confirmBtn)
    
    -- Animations
    TweenService:Create(overlay, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
        BackgroundTransparency = 0.4
    }):Play()
    
    dialog.Size = UDim2.new(0, 0, 0, 0)
    TweenService:Create(dialog, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 320, 0, 180)
    }):Play()
    
    local function closeDialog()
        TweenService:Create(overlay, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 1
        }):Play()
        TweenService:Create(dialog, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Size = UDim2.new(0, 0, 0, 0)
        }):Play()
        task.wait(0.2)
        overlay:Destroy()
    end
    
    cancelBtn.MouseButton1Click:Connect(closeDialog)
    confirmBtn.MouseButton1Click:Connect(function()
        onConfirm()
        closeDialog()
    end)
end

--==================================================
-- Main Frame & Minimize System
--==================================================
local mainFrame = new("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.new(0.5, 0, 0.5, 0),
    Size = UDim2.new(0, 12, 0, 12),
    BackgroundColor3 = theme.dark,
    BorderSizePixel = 0,
    Visible = true,
    ZIndex = 10
}, screenGui)

new("UICorner", {CornerRadius = UDim.new(0, 16)}, mainFrame)
new("UIStroke", {Thickness = 2, Color = theme.primary, Transparency = 0.6}, mainFrame)

-- Minimized title bar
local minimizedBar = new("Frame", {
    Size = UDim2.new(0, 280, 0, 45),
    Position = UDim2.new(0.5, -140, 0, 20),
    BackgroundColor3 = theme.darker,
    BorderSizePixel = 0,
    Visible = false,
    ZIndex = 50
}, screenGui)

new("UICorner", {CornerRadius = UDim.new(0, 12)}, minimizedBar)
new("UIStroke", {Thickness = 2, Color = theme.primary}, minimizedBar)

new("TextLabel", {
    Text = "✈️ Steal a Plane - Script Hub X",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = theme.text,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 0),
    Size = UDim2.new(1, -60, 1, 0),
    TextXAlignment = Enum.TextXAlignment.Left
}, minimizedBar)

local restoreBtn = new("TextButton", {
    Text = "⬆",
    Size = UDim2.new(0, 35, 0, 35),
    Position = UDim2.new(1, -40, 0, 5),
    BackgroundColor3 = theme.primary,
    Font = Enum.Font.GothamBold,
    TextSize = 16,
    TextColor3 = Color3.new(1, 1, 1)
}, minimizedBar)
new("UICorner", {CornerRadius = UDim.new(0, 8)}, restoreBtn)

-- Initial animation
TweenService:Create(mainFrame, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 420, 0, 380)
}):Play()

task.spawn(function()
    task.wait(1)
    createNotification("Enhanced interface loaded successfully!", "success")
    task.wait(1.5)
    createNotification("New features: Better animations, confirmation dialogs & more!", "info")
end)

--==================================================
-- Header with draggable functionality
--==================================================
local header = new("Frame", {
    Size = UDim2.new(1, 0, 0, 50),
    BackgroundColor3 = theme.darker,
    BorderSizePixel = 0
}, mainFrame)

new("UICorner", {CornerRadius = UDim.new(0, 16)}, header)

-- Gradient overlay
local gradient = new("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1
}, header)

new("UIGradient", {
    Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, theme.primary),
        ColorSequenceKeypoint.new(1, theme.secondary)
    },
    Transparency = NumberSequence.new{
        NumberSequenceKeypoint.new(0, 0.8),
        NumberSequenceKeypoint.new(1, 0.9)
    }
}, gradient)
new("UICorner", {CornerRadius = UDim.new(0, 16)}, gradient)

-- Title
new("TextLabel", {
    Text = "✈️ Steal a Plane",
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = theme.text,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0, 5),
    Size = UDim2.new(0.6, 0, 0.5, 0),
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

new("TextLabel", {
    Text = "Enhanced Script Hub X",
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = theme.textDim,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 15, 0.5, 0),
    Size = UDim2.new(0.6, 0, 0.5, 0),
    TextXAlignment = Enum.TextXAlignment.Left
}, header)

-- Control buttons
local closeBtn = new("TextButton", {
    Text = "✕",
    Size = UDim2.new(0, 35, 0, 35),
    Position = UDim2.new(1, -45, 0, 7.5),
    BackgroundColor3 = theme.danger,
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = Color3.new(1, 1, 1)
}, header)
new("UICorner", {CornerRadius = UDim.new(0, 8)}, closeBtn)

local miniBtn = new("TextButton", {
    Text = "−",
    Size = UDim2.new(0, 35, 0, 35),
    Position = UDim2.new(1, -85, 0, 7.5),
    BackgroundColor3 = theme.light,
    Font = Enum.Font.GothamBold,
    TextSize = 18,
    TextColor3 = theme.text
}, header)
new("UICorner", {CornerRadius = UDim.new(0, 8)}, miniBtn)

--==================================================
-- Enhanced Tab System
--==================================================
local tabFrame = new("Frame", {
    Size = UDim2.new(1, -20, 0, 40),
    Position = UDim2.new(0, 10, 0, 55),
    BackgroundColor3 = theme.light,
    BorderSizePixel = 0
}, mainFrame)
new("UICorner", {CornerRadius = UDim.new(0, 12)}, tabFrame)

local tabContainer = new("Frame", {
    Size = UDim2.new(1, -10, 1, -10),
    Position = UDim2.new(0, 5, 0, 5),
    BackgroundTransparency = 1
}, tabFrame)

local tabs = {}
local activeTab = nil

local function createTabButton(name, icon, order)
    local btn = new("TextButton", {
        Text = icon .. " " .. name,
        Font = Enum.Font.GothamMedium,
        TextSize = 13,
        TextColor3 = theme.textDim,
        BackgroundColor3 = Color3.new(0, 0, 0),
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 100, 1, 0),
        Position = UDim2.new(0, (order - 1) * 105, 0, 0)
    }, tabContainer)
    
    new("UICorner", {CornerRadius = UDim.new(0, 8)}, btn)
    tabs[name] = btn
    return btn
end

local mainTabBtn = createTabButton("Main", "🎮", 1)
local exploitsTabBtn = createTabButton("Exploits", "⚡", 2)
local visualsTabBtn = createTabButton("Visuals", "👁️", 3)
local settingsTabBtn = createTabButton("Settings", "⚙️", 4)

-- Tab containers
local contentArea = new("Frame", {
    Size = UDim2.new(1, -20, 1, -110),
    Position = UDim2.new(0, 10, 0, 100),
    BackgroundTransparency = 1
}, mainFrame)

local mainContainer = new("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = theme.primary
}, contentArea)

local exploitsContainer = new("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = theme.primary,
    Visible = false
}, contentArea)

local visualsContainer = new("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = theme.primary,
    Visible = false
}, contentArea)

local settingsContainer = new("ScrollingFrame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundTransparency = 1,
    CanvasSize = UDim2.new(0, 0, 0, 0),
    ScrollBarThickness = 4,
    ScrollBarImageColor3 = theme.primary,
    Visible = false
}, contentArea)

-- Layouts
for _, container in pairs({mainContainer, exploitsContainer, visualsContainer, settingsContainer}) do
    local layout = new("UIListLayout", {
        Padding = UDim.new(0, 8),
        FillDirection = Enum.FillDirection.Vertical
    }, container)
    
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        container.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 10)
    end)
end

-- Tab switching function
local function switchTab(tabName)
    local containers = {
        Main = mainContainer,
        Exploits = exploitsContainer,
        Visuals = visualsContainer,
        Settings = settingsContainer
    }
    
    -- Hide all containers
    for _, container in pairs(containers) do
        container.Visible = false
    end
    
    -- Show selected container
    if containers[tabName] then
        containers[tabName].Visible = true
    end
    
    -- Update tab button appearance
    for name, btn in pairs(tabs) do
        if name == tabName then
            TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 0,
                BackgroundColor3 = theme.primary,
                TextColor3 = Color3.new(1, 1, 1)
            }):Play()
        else
            TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 1,
                BackgroundColor3 = Color3.new(0, 0, 0),
                TextColor3 = theme.textDim
            }):Play()
        end
    end
    
    activeTab = tabName
end

-- Connect tab buttons
mainTabBtn.MouseButton1Click:Connect(function() switchTab("Main") end)
exploitsTabBtn.MouseButton1Click:Connect(function() switchTab("Exploits") end)
visualsTabBtn.MouseButton1Click:Connect(function() switchTab("Visuals") end)
settingsTabBtn.MouseButton1Click:Connect(function() switchTab("Settings") end)

-- Initialize with Main tab
switchTab("Main")

--==================================================
-- Section Creator
--==================================================
local function createSection(title, container)
    local section = new("Frame", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = theme.darker,
        BorderSizePixel = 0
    }, container)
    
    new("UICorner", {CornerRadius = UDim.new(0, 10)}, section)
    new("UIStroke", {Thickness = 1, Color = theme.light, Transparency = 0.7}, section)
    
    local titleLabel = new("TextLabel", {
        Text = "📁 " .. title,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = theme.primary,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(1, -15, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left
    }, section)
    
    return section
end

--==================================================
-- Enhanced Toggle Creator
--==================================================
local function createToggle(name, container, callback, description)
    local frame = new("Frame", {
        Size = UDim2.new(1, 0, 0, description and 65 or 45),
        BackgroundColor3 = theme.darker,
        BorderSizePixel = 0
    }, container)
    
    new("UICorner", {CornerRadius = UDim.new(0, 10)}, frame)
    new("UIStroke", {Thickness = 1, Color = theme.light, Transparency = 0.8}, frame)
    
    local nameLabel = new("TextLabel", {
        Text = name,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        BackgroundTransparency = 1,
        TextColor3 = theme.text,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0.7, 0, description and 0.6 or 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center
    }, frame)
    
    if description then
        new("TextLabel", {
            Text = description,
            Font = Enum.Font.Gotham,
            TextSize = 11,
            BackgroundTransparency = 1,
            TextColor3 = theme.textDim,
            Position = UDim2.new(0, 15, 0.6, 0),
            Size = UDim2.new(0.7, 0, 0.4, 0),
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            TextWrapped = true
        }, frame)
    end
    
    local toggleBtn = new("TextButton", {
        Text = "",
        Size = UDim2.new(0, 50, 0, 25),
        Position = UDim2.new(1, -65, 0.5, -12.5),
        BackgroundColor3 = theme.light,
        BorderSizePixel = 0
    }, frame)
    
    new("UICorner", {CornerRadius = UDim.new(0, 12.5)}, toggleBtn)
    
    local toggleCircle = new("Frame", {
        Size = UDim2.new(0, 21, 0, 21),
        Position = UDim2.new(0, 2, 0.5, -10.5),
        BackgroundColor3 = Color3.new(1, 1, 1),
        BorderSizePixel = 0
    }, toggleBtn)
    
    new("UICorner", {CornerRadius = UDim.new(0, 10.5)}, toggleCircle)
    
    local state = false
    
    local function updateToggle()
        local newBgColor = state and theme.success or theme.light
        local newPos = state and UDim2.new(1, -23, 0.5, -10.5) or UDim2.new(0, 2, 0.5, -10.5)
        
        TweenService:Create(toggleBtn, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
            BackgroundColor3 = newBgColor
        }):Play()
        
        TweenService:Create(toggleCircle, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = newPos
        }):Play()
        
        -- Glow effect when enabled
        if state then
            local glow = new("Frame", {
                Size = UDim2.new(1, 6, 1, 6),
                Position = UDim2.new(0, -3, 0, -3),
                BackgroundColor3 = theme.success,
                BackgroundTransparency = 0.7,
                ZIndex = toggleBtn.ZIndex - 1
            }, toggleBtn)
            new("UICorner", {CornerRadius = UDim.new(0, 15)}, glow)
            
            TweenService:Create(glow, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 1
            }):Play()
            
            task.wait(0.3)
            if glow then glow:Destroy() end
        end
    end
    
    toggleBtn.MouseButton1Click:Connect(function()
        state = not state
        updateToggle()
        if callback then callback(state, frame) end
    end)
    
    return frame, function() return state end
end

--==================================================
-- Button Creator
--==================================================
local function createButton(name, container, callback, color)
    color = color or theme.primary
    
    local btn = new("TextButton", {
        Size = UDim2.new(1, 0, 0, 40),
        BackgroundColor3 = color,
        BorderSizePixel = 0,
        Text = name,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        TextColor3 = Color3.new(1, 1, 1)
    }, container)
    
    new("UICorner", {CornerRadius = UDim.new(0, 10)}, btn)
    new("UIStroke", {Thickness = 1, Color = color, Transparency = 0.5}, btn)
    
    -- Hover effects
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = Color3.new(color.R + 0.1, color.G + 0.1, color.B + 0.1)
        }):Play()
    end)
    
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            BackgroundColor3 = color
        }):Play()
    end)
    
    btn.MouseButton1Click:Connect(function()
        -- Click animation
        TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = UDim2.new(1, -4, 0, 36)
        }):Play()
        
        task.wait(0.1)
        
        TweenService:Create(btn, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            Size = UDim2.new(1, 0, 0, 40)
        }):Play()
        
        if callback then callback() end
    end)
    
    return btn
end

--==================================================
-- Input Box Creator
--==================================================
local function createInputBox(name, container, placeholder, callback)
    local frame = new("Frame", {
        Size = UDim2.new(1, 0, 0, 45),
        BackgroundColor3 = theme.darker,
        BorderSizePixel = 0
    }, container)
    
    new("UICorner", {CornerRadius = UDim.new(0, 10)}, frame)
    new("UIStroke", {Thickness = 1, Color = theme.light, Transparency = 0.8}, frame)
    
    new("TextLabel", {
        Text = name,
        Font = Enum.Font.GothamMedium,
        TextSize = 14,
        BackgroundTransparency = 1,
        TextColor3 = theme.text,
        Position = UDim2.new(0, 15, 0, 0),
        Size = UDim2.new(0.5, 0, 1, 0),
        TextXAlignment = Enum.TextXAlignment.Left
    }, frame)
    
    local inputBox = new("TextBox", {
        Size = UDim2.new(0.45, 0, 0, 30),
        Position = UDim2.new(0.52, 0, 0.5, -15),
        BackgroundColor3 = theme.light,
        BorderSizePixel = 0,
        Text = "",
        PlaceholderText = placeholder or "",
        Font = Enum.Font.Gotham,
        TextSize = 13,
        TextColor3 = theme.text,
        PlaceholderColor3 = theme.textDim,
        ClearTextOnFocus = false
    }, frame)
    
    new("UICorner", {CornerRadius = UDim.new(0, 8)}, inputBox)
    new("UIStroke", {Thickness = 1, Color = theme.primary, Transparency = 0.8}, inputBox)
    
    -- Focus effects
    inputBox.Focused:Connect(function()
        TweenService:Create(inputBox:FindFirstChild("UIStroke"), TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Transparency = 0.3
        }):Play()
    end)
    
    inputBox.FocusLost:Connect(function()
        TweenService:Create(inputBox:FindFirstChild("UIStroke"), TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
            Transparency = 0.8
        }):Play()
        
        if callback then callback(inputBox.Text) end
    end)
    
    return frame, inputBox
end

--==================================================
-- Control Button Functions
--==================================================
miniBtn.MouseButton1Click:Connect(function()
    -- Minimize to title bar
    TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        BackgroundTransparency = 1
    }):Play()
    
    task.wait(0.2)
    mainFrame.Visible = false
    
    -- Show minimized bar
    minimizedBar.Visible = true
    TweenService:Create(minimizedBar, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 280, 0, 45)
    }):Play()
    
    createNotification("Interface minimized to title bar", "info")
end)

restoreBtn.MouseButton1Click:Connect(function()
    -- Hide minimized bar
    TweenService:Create(minimizedBar, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    }):Play()
    
    task.wait(0.2)
    minimizedBar.Visible = false
    
    -- Restore main frame
    mainFrame.Visible = true
    mainFrame.Size = UDim2.new(0, 0, 0, 0)
    mainFrame.BackgroundTransparency = 0
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 420, 0, 380)
    }):Play()
end)

closeBtn.MouseButton1Click:Connect(function()
    createConfirmDialog(
        "Close Interface",
        "Are you sure you want to close the interface? This will stop all active features.",
        function()
            -- Cleanup and destroy
            TweenService:Create(mainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                BackgroundTransparency = 1
            }):Play()
            
            task.wait(0.4)
            screenGui:Destroy()
        end
    )
end)

--==================================================
-- Draggable Functionality
--==================================================
local function makeDraggable(frame, dragHandle)
    local dragging = false
    local dragInput, mousePos, framePos
    
    dragHandle = dragHandle or frame
    
    dragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            mousePos = input.Position
            framePos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    dragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            local newPos = UDim2.new(
                framePos.X.Scale,
                framePos.X.Offset + delta.X,
                framePos.Y.Scale,
                framePos.Y.Offset + delta.Y
            )
            
            TweenService:Create(frame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
                Position = newPos
            }):Play()
        end
    end)
end

-- Make main frame and minimized bar draggable
makeDraggable(mainFrame, header)
makeDraggable(minimizedBar)

--==================================================
-- MAIN TAB CONTENT
--==================================================
createSection("Movement", mainContainer)

local _, getNoclipState = createToggle("Noclip", mainContainer, function(state)
    setNoclip(state)
    createNotification(state and "Noclip enabled" or "Noclip disabled", state and "success" or "info")
end, "Walk through walls and objects")

local _, getInfJumpState = createToggle("Infinite Jump", mainContainer, function(state)
    infJump = state
    createNotification(state and "Infinite Jump enabled" or "Infinite Jump disabled", state and "success" or "info")
end, "Jump infinitely without touching ground")

local speedFrame, speedInput = createInputBox("Walk Speed", mainContainer, "60", function(value)
    local speed = tonumber(value)
    if speed and speed > 0 then
        fastSpeed = speed
        if humanoid then
            humanoid.WalkSpeed = speed
        end
        createNotification("Speed set to " .. speed, "success")
    else
        createNotification("Invalid speed value!", "error")
    end
end)

createSection("Automation", mainContainer)

local _, getAutoLockState = createToggle("Auto Lock", mainContainer, function(state)
    setAutoLock(state)
    createNotification(state and "Auto Lock enabled" or "Auto Lock disabled", state and "success" or "info")
end, "Automatically lock planes every second")

local _, getAutoCollectState = createToggle("Auto Collect", mainContainer, function(state)
    setAutoCollect(state)
    createNotification(state and "Auto Collect enabled" or "Auto Collect disabled", state and "success" or "info")
end, "Collect from all slots automatically")

--==================================================
-- EXPLOITS TAB CONTENT
--==================================================
createSection("Stealing", exploitsContainer)

local _, getRandomStealState = createToggle("Random Instant Steal", exploitsContainer, function(state)
    setRandomSteal(state)
    createNotification(state and "Random Steal enabled" or "Random Steal disabled", state and "success" or "info")
end, "Randomly steal planes from other bases")

local _, getInstantStealState = createToggle("Instant Steal Hook", exploitsContainer, function(state)
    instantStealEnabled = state
    createNotification(state and "Instant Steal hook enabled" or "Instant Steal hook disabled", state and "success" or "info")
end, "Teleports to collect zone when stealing")

createButton("Steal Random Plane", exploitsContainer, function()
    stealRandomPlane()
    createNotification("Manual steal attempt executed", "info")
end, theme.warning)

createButton("Teleport to Collect Zone", exploitsContainer, function()
    teleportToCollectZone()
    createNotification("Teleported to collect zone", "success")
end, theme.success)

--==================================================
-- VISUALS TAB CONTENT
--==================================================
createSection("Player ESP", visualsContainer)

local _, getESPState = createToggle("ESP Players", visualsContainer, function(state)
    setESP(state)
    createNotification(state and "Player ESP enabled" or "Player ESP disabled", state and "success" or "info")
end, "Highlight all players with green outline")

createButton("Clear All Highlights", visualsContainer, function()
    clearAllHighlights()
    createNotification("All highlights cleared", "info")
end, theme.danger)

createSection("Interface", visualsContainer)

createButton("Reset UI Position", visualsContainer, function()
    TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, 0, 0.5, 0)
    }):Play()
    createNotification("UI position reset to center", "success")
end, theme.primary)

--==================================================
-- SETTINGS TAB CONTENT
--==================================================
createSection("About", settingsContainer)

new("TextLabel", {
    Text = "Enhanced Script Hub X\nMade by michel\nVersion 2.0",
    Font = Enum.Font.GothamMedium,
    TextSize = 16,
    TextColor3 = theme.text,
    BackgroundTransparency = 1,
    Size = UDim2.new(1, 0, 0, 80),
    TextYAlignment = Enum.TextYAlignment.Top
}, settingsContainer)

createSection("Community", settingsContainer)

new("Frame", {
    Size = UDim2.new(1, 0, 0, 60),
    BackgroundColor3 = theme.darker,
    BorderSizePixel = 0
}, settingsContainer)

new("UICorner", {CornerRadius = UDim.new(0, 10)}, settingsContainer:GetChildren()[#settingsContainer:GetChildren()])

local discordFrame = settingsContainer:GetChildren()[#settingsContainer:GetChildren()]

new("ImageLabel", {
    Image = "rbxassetid://113520323335055",
    Size = UDim2.new(0, 40, 0, 40),
    Position = UDim2.new(0, 15, 0, 10),
    BackgroundTransparency = 1
}, discordFrame)

new("TextLabel", {
    Text = "Join our Discord community!",
    Font = Enum.Font.GothamBold,
    TextSize = 14,
    TextColor3 = theme.text,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 65, 0, 5),
    Size = UDim2.new(1, -65, 0.5, 0),
    TextXAlignment = Enum.TextXAlignment.Left
}, discordFrame)

new("TextLabel", {
    Text = "Get updates, scripts & support",
    Font = Enum.Font.Gotham,
    TextSize = 12,
    TextColor3 = theme.textDim,
    BackgroundTransparency = 1,
    Position = UDim2.new(0, 65, 0.5, 0),
    Size = UDim2.new(1, -140, 0.5, 0),
    TextXAlignment = Enum.TextXAlignment.Left
}, discordFrame)

local joinDiscordBtn = new("TextButton", {
    Text = "Join",
    Size = UDim2.new(0, 60, 0, 30),
    Position = UDim2.new(1, -75, 0.5, -15),
    BackgroundColor3 = Color3.fromRGB(114, 137, 218),
    Font = Enum.Font.GothamBold,
    TextSize = 13,
    TextColor3 = Color3.new(1, 1, 1)
}, discordFrame)

new("UICorner", {CornerRadius = UDim.new(0, 8)}, joinDiscordBtn)

joinDiscordBtn.MouseButton1Click:Connect(function()
    pcall(function() 
        setclipboard("https://discord.gg/R28RMNSQ") 
    end)
    createNotification("Discord link copied to clipboard!", "success")
end)

--==================================================
-- FEATURE IMPLEMENTATIONS
--==================================================

-- Variables
local noclipConn
local infJump = false
local normalSpeed = humanoid.WalkSpeed
local fastSpeed = 60
local autoLockEnabled = false
local autoCollectEnabled = false
local espEnabled = false
local randomStealEnabled = false
local instantStealEnabled = false

-- Noclip Function
function setNoclip(enabled)
    if enabled then
        if noclipConn then noclipConn:Disconnect() end
        noclipConn = RunService.Stepped:Connect(function()
            if character then
                for _, v in pairs(character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then
                        v.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConn then 
            noclipConn:Disconnect() 
            noclipConn = nil 
        end
        if character then
            for _, v in pairs(character:GetDescendants()) do
                if v:IsA("BasePart") then 
                    v.CanCollide = true 
                end
            end
        end
    end
end

-- Infinite Jump
UserInputService.JumpRequest:Connect(function()
    if infJump and humanoid then 
        humanoid:ChangeState("Jumping") 
    end
end)

-- Auto Lock Function
function setAutoLock(enabled)
    autoLockEnabled = enabled
    if enabled then
        task.spawn(function()
            while autoLockEnabled do
                pcall(function() 
                    RFAskLock:InvokeServer() 
                end)
                task.wait(1)
            end
        end)
    end
end

-- Auto Collect Function
function setAutoCollect(enabled)
    autoCollectEnabled = enabled
    if enabled then
        task.spawn(function()
            while autoCollectEnabled do
                pcall(function()
                    for i = 1, 40 do
                        RECollect:FireServer("Slot" .. i)
                    end
                end)
                task.wait(2)
            end
        end)
    end
end

-- ESP Functions
local function highlight(obj, color)
    local hl = Instance.new("Highlight")
    hl.FillTransparency = 1
    hl.OutlineColor = color
    hl.Name = "SPX_Highlight"
    hl.Adornee = obj
    hl.Parent = obj
end

function clearAllHighlights()
    for _, h in ipairs(Workspace:GetDescendants()) do
        if h:IsA("Highlight") and h.Name == "SPX_Highlight" then
            pcall(function() h:Destroy() end)
        end
    end
end

local conPlayerAdded, conCharAdded
function setESP(enabled)
    espEnabled = enabled
    if enabled then
        -- Existing players
        for _, plr in pairs(Players:GetPlayers()) do
            if plr ~= player and plr.Character then
                highlight(plr.Character, Color3.fromRGB(0, 255, 0))
            end
        end
        
        -- New players/characters
        if conPlayerAdded then conPlayerAdded:Disconnect() end
        conPlayerAdded = Players.PlayerAdded:Connect(function(plr)
            if conCharAdded then conCharAdded:Disconnect() end
            conCharAdded = plr.CharacterAdded:Connect(function(char)
                if espEnabled then 
                    highlight(char, Color3.fromRGB(0, 255, 0)) 
                end
            end)
        end)
    else
        if conPlayerAdded then 
            conPlayerAdded:Disconnect() 
            conPlayerAdded = nil 
        end
        if conCharAdded then 
            conCharAdded:Disconnect() 
            conCharAdded = nil 
        end
        clearAllHighlights()
    end
end

-- Steal Functions
local function getTargetBases()
    local bases = {}
    local basesFolder = Workspace:FindFirstChild("Bases")
    if not basesFolder then return bases end
    
    for _, base in ipairs(basesFolder:GetChildren()) do
        if base.Name ~= player.Name then
            table.insert(bases, base)
        end
    end
    return bases
end

local function getPlanesFromBase(baseFolder)
    local planes = {}
    if not baseFolder then return planes end
    
    local planesFolder = baseFolder:FindFirstChild("Planes") or baseFolder:FindFirstChild("vehicles")
    if planesFolder then
        for _, plane in ipairs(planesFolder:GetChildren()) do
            if plane:IsA("Model") or plane:IsA("Part") then
                table.insert(planes, plane)
            end
        end
    end
    return planes
end

function stealRandomPlane()
    local targets = getTargetBases()
    if #targets == 0 then return end
    
    local randomBase = targets[math.random(1, #targets)]
    local planes = getPlanesFromBase(randomBase)
    if #planes == 0 then return end
    
    local targetPlane = planes[math.random(1, #planes)]
    pcall(function()
        RFStealPlane:InvokeServer(targetPlane)
        createNotification(("Random steal: %s / %s"):format(randomBase.Name, targetPlane.Name or "Plane"), "warning")
    end)
end

function setRandomSteal(enabled)
    randomStealEnabled = enabled
    if enabled then
        task.spawn(function()
            while randomStealEnabled do
                stealRandomPlane()
                task.wait(math.random(3, 6))
            end
        end)
    end
end

local function getMyCollectZone()
    local bases = Workspace:FindFirstChild("Bases")
    if not bases then return nil end
    
    local myBase = bases:FindFirstChild(player.Name)
    if not myBase then return nil end
    
    local decor = myBase:FindFirstChild("Decors") or myBase:FindFirstChild("DecorsFolder")
    if not decor then return nil end
    
    local rest = decor:FindFirstChild("Rest") or decor:FindFirstChild("RestArea")
    if not rest then return nil end
    
    return rest:FindFirstChild("CollectZone") or rest:FindFirstChild("Collect")
end

function teleportToCollectZone()
    local zone = getMyCollectZone()
    if not zone or not rootPart then return end
    
    pcall(function()
        local oldCFrame = rootPart.CFrame
        rootPart.CFrame = zone.CFrame + Vector3.new(0, 5, 0)
        task.wait(1.2)
        if rootPart then 
            rootPart.CFrame = oldCFrame 
        end
    end)
end

-- Instant Steal Hook
do
    local ok_mt, mt = pcall(function() 
        return getrawmetatable and getrawmetatable(game) 
    end)
    
    if ok_mt and mt and type(mt) == "table" and mt.__namecall then
        local old = mt.__namecall
        pcall(function() 
            if setreadonly then setreadonly(mt, false) end 
        end)
        
        mt.__namecall = newcclosure(function(self, ...)
            local method = (getnamecallmethod and getnamecallmethod()) or nil
            local args = {...}
            
            if instantStealEnabled and self == RFStealPlane and method == "InvokeServer" then
                task.delay(0.10, function()
                    pcall(teleportToCollectZone)
                end)
            end
            
            return old(self, unpack(args))
        end)
        
        pcall(function() 
            if setreadonly then setreadonly(mt, true) end 
        end)
    else
        createNotification("Executor doesn't support metatable hook", "warning")
    end
end

print("Enhanced Steal a Plane Script Hub loaded successfully!")

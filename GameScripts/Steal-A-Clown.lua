-- ========================================
-- STEAL A CLOWN - FIXED VERSION
-- Made by PickleTalk and Mhicel
-- ========================================

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- Services
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- ========================================
-- THEMES
-- ========================================
WindUI:AddTheme({
    Name = "Anime Dark",
    Accent = Color3.fromHex("#FF0F7B"),
    Dialog = Color3.fromHex("#161616"),
    Outline = Color3.fromHex("#FF0F7B"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#101010"),
    Button = Color3.fromHex("#52525b"),
    Icon = Color3.fromHex("#FF0F7B")
})

WindUI:AddTheme({
    Name = "Anime Light",
    Accent = Color3.fromHex("#F89B29"),
    Dialog = Color3.fromHex("#f5f5f5"),
    Outline = Color3.fromHex("#F89B29"),
    Text = Color3.fromHex("#000000"),
    Placeholder = Color3.fromHex("#5a5a5a"),
    Background = Color3.fromHex("#ffffff"),
    Button = Color3.fromHex("#e5e5e5"),
    Icon = Color3.fromHex("#F89B29")
})

WindUI:AddTheme({
    Name = "Purple Dream",
    Accent = Color3.fromHex("#9333EA"),
    Dialog = Color3.fromHex("#1a1625"),
    Outline = Color3.fromHex("#A855F7"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#0f0b16"),
    Button = Color3.fromHex("#4c2a6e"),
    Icon = Color3.fromHex("#C084FC")
})

WindUI:AddTheme({
    Name = "Ocean Blue",
    Accent = Color3.fromHex("#0EA5E9"),
    Dialog = Color3.fromHex("#161e28"),
    Outline = Color3.fromHex("#38BDF8"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#0a1420"),
    Button = Color3.fromHex("#1e3a5f"),
    Icon = Color3.fromHex("#7DD3FC")
})

WindUI:AddTheme({
    Name = "Forest Green",
    Accent = Color3.fromHex("#10B981"),
    Dialog = Color3.fromHex("#16211c"),
    Outline = Color3.fromHex("#34D399"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#0a1610"),
    Button = Color3.fromHex("#1e4d3a"),
    Icon = Color3.fromHex("#6EE7B7")
})

WindUI:AddTheme({
    Name = "Crimson Red",
    Accent = Color3.fromHex("#DC2626"),
    Dialog = Color3.fromHex("#211616"),
    Outline = Color3.fromHex("#EF4444"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#180a0a"),
    Button = Color3.fromHex("#5f1e1e"),
    Icon = Color3.fromHex("#F87171")
})

WindUI:AddTheme({
    Name = "Sunset Orange",
    Accent = Color3.fromHex("#F97316"),
    Dialog = Color3.fromHex("#211a16"),
    Outline = Color3.fromHex("#FB923C"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#18120a"),
    Button = Color3.fromHex("#5f371e"),
    Icon = Color3.fromHex("#FDBA74")
})

WindUI:AddTheme({
    Name = "Midnight Purple",
    Accent = Color3.fromHex("#7C3AED"),
    Dialog = Color3.fromHex("#1a1625"),
    Outline = Color3.fromHex("#8B5CF6"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#0f0a18"),
    Button = Color3.fromHex("#3d2a5f"),
    Icon = Color3.fromHex("#A78BFA")
})

WindUI:AddTheme({
    Name = "Cyan Glow",
    Accent = Color3.fromHex("#06B6D4"),
    Dialog = Color3.fromHex("#162228"),
    Outline = Color3.fromHex("#22D3EE"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#0a1418"),
    Button = Color3.fromHex("#1e4550"),
    Icon = Color3.fromHex("#67E8F9")
})

WindUI:AddTheme({
    Name = "Rose Pink",
    Accent = Color3.fromHex("#F43F5E"),
    Dialog = Color3.fromHex("#211619"),
    Outline = Color3.fromHex("#FB7185"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#180a0f"),
    Button = Color3.fromHex("#5f1e2d"),
    Icon = Color3.fromHex("#FDA4AF")
})

WindUI:AddTheme({
    Name = "Golden Hour",
    Accent = Color3.fromHex("#FBBF24"),
    Dialog = Color3.fromHex("#21200f"),
    Outline = Color3.fromHex("#FCD34D"),
    Text = Color3.fromHex("#000000"),
    Placeholder = Color3.fromHex("#5a5a5a"),
    Background = Color3.fromHex("#1a1808"),
    Button = Color3.fromHex("#6b5a1e"),
    Icon = Color3.fromHex("#FDE68A")
})

WindUI:AddTheme({
    Name = "Neon Green",
    Accent = Color3.fromHex("#22C55E"),
    Dialog = Color3.fromHex("#162116"),
    Outline = Color3.fromHex("#4ADE80"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#0a1610"),
    Button = Color3.fromHex("#1e5f2d"),
    Icon = Color3.fromHex("#86EFAC")
})

WindUI:AddTheme({
    Name = "Electric Blue",
    Accent = Color3.fromHex("#3B82F6"),
    Dialog = Color3.fromHex("#161c28"),
    Outline = Color3.fromHex("#60A5FA"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#0a1220"),
    Button = Color3.fromHex("#1e3d6b"),
    Icon = Color3.fromHex("#93C5FD")
})

WindUI:AddTheme({
    Name = "Custom",
    Accent = Color3.fromHex("#FF0F7B"),
    Dialog = Color3.fromHex("#161616"),
    Outline = Color3.fromHex("#FF0F7B"),
    Text = Color3.fromHex("#FFFFFF"),
    Placeholder = Color3.fromHex("#7a7a7a"),
    Background = Color3.fromHex("#101010"),
    Button = Color3.fromHex("#52525b"),
    Icon = Color3.fromHex("#FF0F7B")
})

WindUI:SetTheme("Anime Dark")

-- ========================================
-- CREATE WINDOW
-- ========================================
local Window = WindUI:CreateWindow({
    Title = "Steal A Clown SHX | Official",
    Icon = "sword",
    Author = "by PickleTalk",
    Folder = "StealClownSHX",
    Transparent = true,
    Theme = "Anime Dark",
})

Window:ToggleTransparency(true)

local ConfigManager = Window.ConfigManager
local myConfig = ConfigManager:CreateConfig("StealClownConfig")

Window:EditOpenButton({
    Title = "Scripts Hub X | Official",
    Icon = "sword",
    CornerRadius = UDim.new(0,16),
    StrokeThickness = 2,
    Color = ColorSequence.new(
        Color3.fromHex("FF0F7B"), 
        Color3.fromHex("F89B29")
    ),
    OnlyMobile = false,
    Enabled = true,
    Draggable = true,
})

-- ========================================
-- GLOBAL STATES
-- ========================================
local States = {
    AutoSteal = false,
    InstantSteal = false,
    StealUI = false,
    AutoCollect = false,
    FastInteraction = false,
    Desync = false,
    AntiVoid = false,
    AutoLock = false,
    NoClip = false,
    AntiRagdoll = false,
    InfiniteJump = false,
    GodMode = false,
    SpeedEnabled = false,
    SpeedValue = 16,
    PlayerESP = false,
    BaseESP = false,
    BaseTimeESP = false,
    BaseRemainingTimeESP = false,
    AntiKick = false,
    CurrentTheme = "Anime Dark",
}

local Connections = {}
local ESPObjects = {
    Players = {},
    Bases = {},
    BaseTime = {},
}
local StealUIScreen = nil
local BaseTimeUIScreen = nil
local InstantStealHook = nil

-- ========================================
-- UTILITY FUNCTIONS
-- ========================================
local function getPlayerPlot()
    local playerName = LocalPlayer.Name
    local plots = Workspace:FindFirstChild("Plots")
    if not plots then return nil end
    
    for _, plot in pairs(plots:GetChildren()) do
        if plot:IsA("Model") then
            local plotSign = plot:FindFirstChild("PlotSign")
            if plotSign then
                local surfaceGui = plotSign:FindFirstChild("SurfaceGui")
                if surfaceGui then
                    local frame = surfaceGui:FindFirstChild("Frame")
                    if frame then
                        local textLabel = frame:FindFirstChild("TextLabel")
                        if textLabel and textLabel.Text == playerName .. "'s Base" then
                            return plot.Name
                        end
                    end
                end
            end
        end
    end
    return nil
end

-- ========================================
-- SERVER HOP FUNCTIONS
-- ========================================
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local function getServers(cursor)
    local url = string.format(
        "https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100",
        game.PlaceId
    )
    
    if cursor then
        url = url .. "&cursor=" .. cursor
    end
    
    local success, result = pcall(function()
        return game:HttpGet(url)
    end)
    
    if success then
        return HttpService:JSONDecode(result)
    else
        return nil
    end
end

local function getAllServers()
    local allServers = {}
    local cursor = nil
    local attempts = 0
    
    repeat
        local data = getServers(cursor)
        
        if data and data.data then
            for _, server in pairs(data.data) do
                if server.id ~= game.JobId and server.playing < server.maxPlayers then
                    table.insert(allServers, server)
                end
            end
            
            cursor = data.nextPageCursor
            attempts = attempts + 1
            task.wait(0.3)
        else
            break
        end
        
    until not cursor or attempts >= 10
    
    return allServers
end

local function hopToSmallestServer()
    WindUI:Notify({
        Title = "Server Hop",
        Content = "Finding smallest server...",
        Duration = 3,
        Icon = "search",
    })
    
    task.spawn(function()
        local servers = getAllServers()
        
        if #servers == 0 then
            WindUI:Notify({
                Title = "Server Hop",
                Content = "No servers found!",
                Duration = 3,
                Icon = "x",
            })
            return
        end
        
        table.sort(servers, function(a, b)
            return a.playing < b.playing
        end)
        
        local targetServer = servers[1]
        
        WindUI:Notify({
            Title = "Server Hop",
            Content = string.format("Hopping to server with %d/%d players...", targetServer.playing, targetServer.maxPlayers),
            Duration = 3,
            Icon = "zap",
        })
        
        task.wait(1)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServer.id, LocalPlayer)
    end)
end

local function hopToRandomServer()
    WindUI:Notify({
        Title = "Server Hop",
        Content = "Finding random server...",
        Duration = 3,
        Icon = "search",
    })
    
    task.spawn(function()
        local servers = getAllServers()
        
        if #servers == 0 then
            WindUI:Notify({
                Title = "Server Hop",
                Content = "No servers found!",
                Duration = 3,
                Icon = "x",
            })
            return
        end
        
        local targetServer = servers[math.random(1, #servers)]
        
        WindUI:Notify({
            Title = "Server Hop",
            Content = string.format("Hopping to server with %d/%d players...", targetServer.playing, targetServer.maxPlayers),
            Duration = 3,
            Icon = "zap",
        })
        
        task.wait(1)
        TeleportService:TeleportToPlaceInstance(game.PlaceId, targetServer.id, LocalPlayer)
    end)
end

-- ========================================
-- STEAL UI (REDESIGNED LIKE STEAL-A-ANIME)
-- ========================================
local function createStealUI()
    if StealUIScreen then
        StealUIScreen:Destroy()
    end
    
    local playerGui = LocalPlayer:WaitForChild("PlayerGui")
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "StealUIScreen"
    screenGui.ResetOnSpawn = false
    screenGui.Parent = playerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 250, 0, 120)
    mainFrame.Position = UDim2.new(1, -260, 0, 10)
    mainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    local mainCorner = Instance.new("UICorner")
    mainCorner.CornerRadius = UDim.new(0, 8)
    mainCorner.Parent = mainFrame
    
    local titleBar = Instance.new("Frame")
    titleBar.Name = "TitleBar"
    titleBar.Size = UDim2.new(1, 0, 0, 30)
    titleBar.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    titleBar.BorderSizePixel = 0
    titleBar.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 8)
    titleCorner.Parent = titleBar
    
    local titleText = Instance.new("TextLabel")
    titleText.Size = UDim2.new(1, -30, 1, 0)
    titleText.Position = UDim2.new(0, 5, 0, 0)
    titleText.BackgroundTransparency = 1
    titleText.Text = "CLOWN HEIST"
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextScaled = true
    titleText.Font = Enum.Font.GothamBold
    titleText.Parent = titleBar
    
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 25, 0, 25)
    closeButton.Position = UDim2.new(1, -27, 0, 2)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Text = "X"
    closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.BorderSizePixel = 0
    closeButton.Parent = titleBar
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 4)
    closeCorner.Parent = closeButton
    
    local stealButton = Instance.new("TextButton")
    stealButton.Name = "StealButton"
    stealButton.Size = UDim2.new(0, 220, 0, 35)
    stealButton.Position = UDim2.new(0, 15, 0, 45)
    stealButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    stealButton.Text = "STEAL"
    stealButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    stealButton.TextScaled = true
    stealButton.Font = Enum.Font.GothamBold
    stealButton.BorderSizePixel = 0
    stealButton.Parent = mainFrame
    
    local stealCorner = Instance.new("UICorner")
    stealCorner.CornerRadius = UDim.new(0, 6)
    stealCorner.Parent = stealButton
    
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Size = UDim2.new(1, -20, 0, 25)
    statusLabel.Position = UDim2.new(0, 10, 0, 90)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Text = "by PickleTalk"
    statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    statusLabel.TextScaled = true
    statusLabel.Font = Enum.Font.Gotham
    statusLabel.TextXAlignment = Enum.TextXAlignment.Left
    statusLabel.Parent = mainFrame
    
    -- Dragging
    local dragging = false
    local dragStart, startPos
    
    titleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)
    
    titleBar.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    
    -- Steal Function
    stealButton.MouseButton1Click:Connect(function()
        task.spawn(function()
            local running = false
            local character = LocalPlayer.Character
            local root = character and character:FindFirstChild("HumanoidRootPart")
            
            if not root then
                stealButton.Text = "ERROR: NO CHARACTER"
                task.wait(1.5)
                stealButton.Text = "STEAL"
                return
            end
            
            stealButton.Text = "STEALING..."
            
            running = true
            task.spawn(function()
                local t = 0
                while running do
                    t = t + 0.03
                    local r = math.floor((math.sin(t) * 0.5 + 0.5) * 60)
                    local g = math.floor((math.sin(t + 2) * 0.5 + 0.5) * 60)
                    local b = math.floor((math.sin(t + 4) * 0.5 + 0.5) * 120 + 60)
                    stealButton.BackgroundColor3 = Color3.fromRGB(r, g, b)
                    task.wait(0.03)
                end
            end)
            
            local plotName = getPlayerPlot()
            if not plotName then
                running = false
                stealButton.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
                stealButton.Text = "ERROR: NO PLOT"
                task.wait(1.5)
                stealButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
                stealButton.Text = "STEAL"
                return
            end
            
            local plots = Workspace:FindFirstChild("Plots")
            local plot = plots and plots:FindFirstChild(plotName)
            local deliveryHitbox = plot and plot:FindFirstChild("DeliveryHitbox")
            
            if deliveryHitbox then
                local oldPos = root.CFrame
                root.CFrame = deliveryHitbox.CFrame
                task.wait(0.1)
                root.CFrame = oldPos
            end
            
            running = false
            stealButton.Text = "SUCCESS!"
            
            local gold = Color3.fromRGB(212, 175, 55)
            local black = Color3.fromRGB(0, 0, 0)
            for i = 1, 3 do
                stealButton.BackgroundColor3 = gold
                task.wait(0.1)
                stealButton.BackgroundColor3 = black
                task.wait(0.1)
            end
            
            stealButton.Text = "STEAL"
        end)
    end)
    
    closeButton.MouseButton1Click:Connect(function()
        States.StealUI = false
        if StealUIScreen then
            StealUIScreen:Destroy()
            StealUIScreen = nil
        end
    end)
    
    -- Hover effects
    closeButton.MouseEnter:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(220, 70, 70)
    end)
    closeButton.MouseLeave:Connect(function()
        closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end)
    
    StealUIScreen = screenGui
end

local function toggleStealUI(state)
    States.StealUI = state
    
    if state then
        createStealUI()
    else
        if StealUIScreen then
            StealUIScreen:Destroy()
            StealUIScreen = nil
        end
    end
end

-- ========================================
-- INSTANT STEAL (HOOKED VERSION)
-- ========================================
local function toggleInstantSteal(state)
    States.InstantSteal = state
    
    if state then
        local ReplicatedStorage = game:GetService("ReplicatedStorage")
        local targetRemote = ReplicatedStorage:WaitForChild("Packages"):WaitForChild("Net"):WaitForChild("RE/39c0ed9f-fd96-4f2c-89c8-b7a9b2d44d2e")
        
        InstantStealHook = hookmetamethod(game, "__namecall", function(self, ...)
            local method = getnamecallmethod()
            local args = {...}
            
            if not checkcaller() and method == "FireServer" and self == targetRemote then
                if States.InstantSteal then
                    task.spawn(function()
                        local character = LocalPlayer.Character
                        local root = character and character:FindFirstChild("HumanoidRootPart")
                        
                        if not root then return end
                        
                        local plotName = getPlayerPlot()
                        if not plotName then return end
                        
                        local plots = Workspace:FindFirstChild("Plots")
                        local plot = plots and plots:FindFirstChild(plotName)
                        local deliveryHitbox = plot and plot:FindFirstChild("DeliveryHitbox")

                        if deliveryHitbox then
                            local savedPosition = root.CFrame
                            task.wait(0.5)
                            root.CFrame = deliveryHitbox.CFrame
                            task.wait(0.5)
                            root.CFrame = savedPosition
                        end
                    end)
                end
            end
            
            return InstantStealHook(self, ...)
        end)
        
        WindUI:Notify({
            Title = "Instant Steal",
            Content = "Instant steal enabled!",
            Duration = 3,
            Icon = "zap",
        })
    else
        if InstantStealHook then
            hookmetamethod(game, "__namecall", InstantStealHook)
            InstantStealHook = nil
        end
        
        WindUI:Notify({
            Title = "Instant Steal",
            Content = "Instant steal disabled!",
            Duration = 3,
            Icon = "x",
        })
    end
end

-- ========================================
-- AUTO STEAL (HIGHEST TO LOWEST)
-- ========================================
local function scanAllClowns()
    local clownList = {}
    local plots = Workspace:FindFirstChild("Plots")
    
    if not plots then return clownList end
    
    local playerPlotName = getPlayerPlot()
    
    for _, plot in pairs(plots:GetChildren()) do
        if plot:IsA("Model") then
            if plot.Name == playerPlotName then
                continue
            end
            
            local animalPodiums = plot:FindFirstChild("AnimalPodiums")
            
            if animalPodiums then
                for i = 1, 30 do
                    local podium = animalPodiums:FindFirstChild(tostring(i))
                    
                    if podium then
                        local base = podium:FindFirstChild("Base")
                        if base then
                            local spawn = base:FindFirstChild("Spawn")
                            if spawn then
                                local attachment = spawn:FindFirstChild("Attachment")
                                if attachment then
                                    local animalOverhead = attachment:FindFirstChild("AnimalOverhead")
                                    if animalOverhead then
                                        local generationLabel = animalOverhead:FindFirstChild("Generation")
                                        
                                        if generationLabel and generationLabel:IsA("TextLabel") then
                                            local generationText = generationLabel.Text
                                            local generationValue = tonumber(generationText:match("%d+"))
                                            
                                            if generationValue then
                                                table.insert(clownList, {
                                                    PlotName = plot.Name,
                                                    PodiumNumber = tostring(i),
                                                    Generation = generationValue,
                                                    PodiumObject = podium
                                                })
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    
    table.sort(clownList, function(a, b)
        return a.Generation > b.Generation
    end)
    
    return clownList
end

local function toggleAutoSteal(state)
    States.AutoSteal = state
    
    if state then
        if not States.InstantSteal then
            States.InstantSteal = true
            toggleInstantSteal(true)
        end
        
        Connections.AutoSteal = task.spawn(function()
            while States.AutoSteal do
                local character = LocalPlayer.Character
                local root = character and character:FindFirstChild("HumanoidRootPart")
                
                if not root then
                    task.wait(1)
                    continue
                end
                
                local clownList = scanAllClowns()
                
                if #clownList == 0 then
                    WindUI:Notify({
                        Title = "Auto Steal",
                        Content = "No clowns found! Waiting...",
                        Duration = 2,
                        Icon = "alert-circle",
                    })
                    task.wait(5)
                    continue
                end
         
                for _, clownData in ipairs(clownList) do
                    if not States.AutoSteal then break end
                    
                    local podium = clownData.PodiumObject
                    local base = podium:FindFirstChild("Base")
                    
                    if base then
                        local podio = base:FindFirstChild("Podio")
                        local spawn = base:FindFirstChild("Spawn")
                        
                        if podio and spawn then
                            local podioPart = podio:FindFirstChild("Part")
                            local promptAttachment = spawn:FindFirstChild("PromptAttachment")
                            
                            if podioPart and promptAttachment then
                                local proximityPrompt = promptAttachment:FindFirstChild("ProximityPrompt")
                                
                                if proximityPrompt then
                                    root.CFrame = podioPart.CFrame + Vector3.new(0, 3, 0)
                                    task.wait(0.25)
                                    
                                    fireproximityprompt(proximityPrompt)
                                    
                                    WindUI:Notify({
                                        Title = "Auto Steal",
                                        Content = string.format("Stealing Gen %d clown from %s", clownData.Generation, clownData.PlotName),
                                        Duration = 2,
                                        Icon = "zap",
                                    })
               
                                    task.wait(1.1)
                                end
                            end
                        end
                    end
                end

                task.wait(2)
            end
        end)
        
        WindUI:Notify({
            Title = "Auto Steal",
            Content = "Auto steal enabled!",
            Duration = 3,
            Icon = "check",
        })
    else
        if Connections.AutoSteal then
            task.cancel(Connections.AutoSteal)
            Connections.AutoSteal = nil
        end

        if States.InstantSteal then
            States.InstantSteal = false
            toggleInstantSteal(false)
        end
        
        WindUI:Notify({
            Title = "Auto Steal",
            Content = "Auto steal disabled!",
            Duration = 3,
            Icon = "x",
        })
    end
end

-- ========================================
-- AUTO COLLECT
-- ========================================
local function toggleAutoCollect(state)
    States.AutoCollect = state
    
    if state then
        Connections.AutoCollect = task.spawn(function()
            while States.AutoCollect do
                local plotName = getPlayerPlot()
                if plotName then
                    local plots = Workspace:FindFirstChild("Plots")
                    local plot = plots and plots:FindFirstChild(plotName)
                    
                    if plot then
                        local animalPodiums = plot:FindFirstChild("AnimalPodiums")
                        if animalPodiums then
                            for i = 1, 30 do
                                local podium = animalPodiums:FindFirstChild(tostring(i))
                                if podium then
                                    local claim = podium:FindFirstChild("Claim")
                                    if claim then
                                        local hitbox = claim:FindFirstChild("Hitbox")
                                        if hitbox then
                                            local character = LocalPlayer.Character
                                            local root = character and character:FindFirstChild("HumanoidRootPart")
                                            if root and hitbox:FindFirstChild("TouchInterest") then
                                                firetouchinterest(root, hitbox, 0)
                                                task.wait(0.01)
                                                firetouchinterest(root, hitbox, 1)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
                
                task.wait(5)
            end
        end)
        
        WindUI:Notify({
            Title = "Auto Collect",
            Content = "Auto collect enabled!",
            Duration = 3,
            Icon = "check",
        })
    else
        if Connections.AutoCollect then
            task.cancel(Connections.AutoCollect)
            Connections.AutoCollect = nil
        end
        
        WindUI:Notify({
            Title = "Auto Collect",
            Content = "Auto collect disabled!",
            Duration = 3,
            Icon = "x",
        })
    end
end

-- ========================================
-- ANTI-VOID (FIXED)
-- ========================================
local function toggleAntiVoid(state)
    States.AntiVoid = state
    
    if state then
        Connections.AntiVoid = RunService.Heartbeat:Connect(function()
            if not States.AntiVoid then return end
            
            local character = LocalPlayer.Character
            if not character then return end
            
            local hrp = character:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            
            if hrp.Position.Y < -10 then
                local rayOrigin = Vector3.new(hrp.Position.X, 100, hrp.Position.Z)
                local rayDirection = Vector3.new(0, -500, 0)
                local rayParams = RaycastParams.new()
                rayParams.FilterDescendantsInstances = {character}
                rayParams.FilterType = Enum.RaycastFilterType.Blacklist
                
                local result = Workspace:Raycast(rayOrigin, rayDirection, rayParams)
                
                if result then
                    hrp.CFrame = CFrame.new(result.Position + Vector3.new(0, 5, 0))
                else
                    hrp.CFrame = CFrame.new(0, 50, 0)
                end
            end
        end)
        
        WindUI:Notify({
            Title = "Anti-Void",
            Content = "Anti-void protection enabled!",
            Duration = 3,
            Icon = "shield",
        })
    else
        if Connections.AntiVoid then
            Connections.AntiVoid:Disconnect()
            Connections.AntiVoid = nil
        end
        
        WindUI:Notify({
            Title = "Anti-Void",
            Content = "Anti-void protection disabled!",
            Duration = 3,
            Icon = "x",
        })
    end
end

-- ========================================
-- PLAYER ESP
-- ========================================
local function cleanupPlayerESP(targetPlayer)
    if ESPObjects.Players[targetPlayer] then
        for _, obj in pairs(ESPObjects.Players[targetPlayer]) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
        ESPObjects.Players[targetPlayer] = nil
    end
end

local function createPlayerESP(targetPlayer)
    if targetPlayer == LocalPlayer then return end
    if ESPObjects.Players[targetPlayer] then return end
    
    local character = targetPlayer.Character
    if not character then return end
    
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    
    ESPObjects.Players[targetPlayer] = {}
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.FillColor = Color3.fromRGB(255, 255, 255)
    highlight.FillTransparency = 0.7
    highlight.OutlineColor = Color3.fromRGB(255, 0, 127)
    highlight.OutlineTransparency = 0
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = character
    
    table.insert(ESPObjects.Players[targetPlayer], highlight)
    
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "ESPBillboard"
    billboard.Size = UDim2.new(0, 80, 0, 20)
    billboard.StudsOffset = Vector3.new(0, 3, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = rootPart
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 1, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = targetPlayer.DisplayName
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0.5
    nameLabel.TextSize = 12
    nameLabel.Font = Enum.Font.Gotham
    nameLabel.Parent = billboard
    
    table.insert(ESPObjects.Players[targetPlayer], billboard)
end

local function togglePlayerESP(state)
    States.PlayerESP = state
    
    if state then
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            if targetPlayer.Character then
                createPlayerESP(targetPlayer)
            end
        end
        
        Connections.PlayerESP = Players.PlayerAdded:Connect(function(newPlayer)
            newPlayer.CharacterAdded:Connect(function()
                if States.PlayerESP then
                    wait(1)
                    createPlayerESP(newPlayer)
                end
            end)
        end)
        
        for _, targetPlayer in pairs(Players:GetPlayers()) do
            targetPlayer.CharacterAdded:Connect(function()
                if States.PlayerESP then
                    wait(1)
                    cleanupPlayerESP(targetPlayer)
                    createPlayerESP(targetPlayer)
                end
            end)
        end
        
        WindUI:Notify({
            Title = "Player ESP",
            Content = "Player ESP enabled!",
            Duration = 3,
            Icon = "check",
        })
    else
        for targetPlayer, _ in pairs(ESPObjects.Players) do
            cleanupPlayerESP(targetPlayer)
        end
        
        if Connections.PlayerESP then
            Connections.PlayerESP:Disconnect()
            Connections.PlayerESP = nil
        end
        
        WindUI:Notify({
            Title = "Player ESP",
            Content = "Player ESP disabled!",
            Duration = 3,
            Icon = "x",
        })
    end
end

-- ========================================
-- BASE ESP
-- ========================================
local function cleanupBaseESP()
    for _, objs in pairs(ESPObjects.Bases) do
        for _, obj in pairs(objs) do
            if obj and obj.Parent then
                obj:Destroy()
            end
        end
    end
    ESPObjects.Bases = {}
end

local function createBaseESP(plotSign, plotName)
    if ESPObjects.Bases[plotName] then return end
    
    ESPObjects.Bases[plotName] = {}
    
    -- Get plot owner name from the sign
    local ownerName = "Unknown"
    local surfaceGui = plotSign:FindFirstChild("SurfaceGui")
    if surfaceGui then
        local frame = surfaceGui:FindFirstChild("Frame")
        if frame then
            local textLabel = frame:FindFirstChild("TextLabel")
            if textLabel then
                ownerName = textLabel.Text
            end
        end
    end
    
    -- Create BillboardGui for ESP text
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "BaseESPBillboard"
    billboard.Size = UDim2.new(0, 150, 0, 40)
    billboard.StudsOffset = Vector3.new(0, 5, 0)
    billboard.AlwaysOnTop = true
    billboard.Parent = plotSign
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = ownerName
    textLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
    textLabel.TextStrokeTransparency = 0.5
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.GothamBold
    textLabel.Parent = billboard
    
    table.insert(ESPObjects.Bases[plotName], billboard)
end

local function toggleBaseESP(state)
    States.BaseESP = state
    
    if state then
        local plots = Workspace:FindFirstChild("Plots")
        if plots then
            for _, plot in pairs(plots:GetChildren()) do
                if plot:IsA("Model") then
                    local plotSign = plot:FindFirstChild("PlotSign")
                    if plotSign then
                        createBaseESP(plotSign, plot.Name)
                    end
                end
            end
        end
        
        WindUI:Notify({
            Title = "Base ESP",
            Content = "Base ESP enabled!",
            Duration = 3,
            Icon = "check",
        })
    else
        cleanupBaseESP()
        
        WindUI:Notify({
            Title = "Base ESP",
            Content = "Base ESP disabled!",
            Duration = 3,
            Icon = "x",
        })
    end
end

-- ========================================
-- BASE TIME ESP
-- ========================================
local function cleanupBaseTimeESP()
    for _, objs in pairs(ESPObjects.BaseTime) do
        if objs[1] and objs[1].Parent then
            objs[1]:Destroy()
        end
        if objs[2] then
            objs[2]:Disconnect()
        end
    end
    ESPObjects.BaseTime = {}
end

local function createBaseTimeESP(plotBlock, plotName)
    local main = plotBlock:FindFirstChild("Main")
    if not main then return end
    
    local billboard = main:FindFirstChild("BillboardGui")
    if not billboard then return end
    
    local remaining = billboard:FindFirstChild("RemainingTime")
    if not remaining then return end
    
    local customBillboard = Instance.new("BillboardGui")
    customBillboard.Size = UDim2.new(0, 70, 0, 20)
    customBillboard.AlwaysOnTop = true
    customBillboard.StudsOffset = Vector3.new(0, 3, 0)
    customBillboard.Parent = main
    customBillboard.Name = "CustomBaseTimeESP"

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 0)
    label.TextStrokeTransparency = 0.2
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Text = ""
    label.Parent = customBillboard

    local connection = RunService.RenderStepped:Connect(function()
        if not States.BaseTimeESP then return end
        
        local timeText = remaining.Text
        local seconds = tonumber(timeText:match("%d+"))
        
        label.Text = timeText
        
        if seconds then
            if seconds == 0 then
                label.TextColor3 = Color3.fromRGB(0, 255, 0)
            elseif seconds < 5 then
                label.TextColor3 = Color3.fromRGB(255, 255, 0)
            elseif seconds < 10 then
                label.TextColor3 = Color3.fromRGB(255, 0, 0)
            else
                label.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
    end)
    
    ESPObjects.BaseTime[plotName] = {customBillboard, connection}
end

local function toggleBaseTimeESP(state)
    States.BaseTimeESP = state
    
    if state then
        local plots = Workspace:FindFirstChild("Plots")
        if plots then
            for _, plot in pairs(plots:GetChildren()) do
                if plot:IsA("Model") then
                    local purchases = plot:FindFirstChild("Purchases")
                    if purchases then
                        local plotBlock = purchases:FindFirstChild("PlotBlock")
                        if plotBlock then
                            createBaseTimeESP(plotBlock, plot.Name)
                        end
                    end
                end
            end
        end
        
        WindUI:Notify({
            Title = "Base Time ESP",
            Content = "Base time ESP enabled!",
            Duration = 3,
            Icon = "check",
        })
    else
        cleanupBaseTimeESP()
        
        WindUI:Notify({
            Title = "Base Time ESP",
            Content = "Base time ESP disabled!",
            Duration = 3,
            Icon = "x",
        })
    end
end

-- ========================================
-- BASE REMAINING TIME ESP (UI)
-- ========================================
local function createBaseTimeUI()
    if BaseTimeUIScreen then
        BaseTimeUIScreen:Destroy()
    end
    
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "BaseTimeUIScreen"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 50)
    frame.Position = UDim2.new(0.5, -100, 0, 20)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Thickness = 2
    stroke.Parent = frame
    
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Base Time: 0s"
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.GothamBold
    textLabel.TextSize = 18
    textLabel.Parent = frame
    
    BaseTimeUIScreen = screenGui
    return textLabel
end

local function toggleBaseRemainingTimeESP(state)
    States.BaseRemainingTimeESP = state
    
    if state then
        local textLabel = createBaseTimeUI()
        
        Connections.BaseRemainingTime = RunService.Heartbeat:Connect(function()
            if not States.BaseRemainingTimeESP then return end
            
            local plotName = getPlayerPlot()
            if plotName then
                local plots = Workspace:FindFirstChild("Plots")
                local plot = plots and plots:FindFirstChild(plotName)
                
                if plot then
                    local purchases = plot:FindFirstChild("Purchases")
                    if purchases then
                        local plotBlock = purchases:FindFirstChild("PlotBlock")
                        if plotBlock then
                            local main = plotBlock:FindFirstChild("Main")
                            if main then
                                local billboard = main:FindFirstChild("BillboardGui")
                                if billboard then
                                    local remaining = billboard:FindFirstChild("RemainingTime")
                                    if remaining then
                                        textLabel.Text = "Base Time: " .. remaining.Text
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
        
        WindUI:Notify({
            Title = "Base Time UI",
            Content = "Base time UI enabled!",
            Duration = 3,
            Icon = "check",
        })
    else
        if Connections.BaseRemainingTime then
            Connections.BaseRemainingTime:Disconnect()
            Connections.BaseRemainingTime = nil
        end
        
        if BaseTimeUIScreen then
            BaseTimeUIScreen:Destroy()
            BaseTimeUIScreen = nil
        end
        
        WindUI:Notify({
            Title = "Base Time UI",
            Content = "Base time UI disabled!",
            Duration = 3,
            Icon = "x",
        })
    end
end

-- ========================================
-- OTHER FEATURES
-- ========================================
local function toggleFastInteraction(state)
    States.FastInteraction = state
    
    if state then
        Connections.FastInteraction = RunService.Heartbeat:Connect(function()
            for _, v in pairs(Workspace:GetDescendants()) do
                if v:IsA("ProximityPrompt") then
                    v.HoldDuration = 0
                    v.MaxActivationDistance = 40
                end
            end
        end)
        
        WindUI:Notify({
            Title = "Fast Interaction",
            Content = "Fast interaction enabled!",
            Duration = 3,
            Icon = "check",
        })
    else
        if Connections.FastInteraction then
            Connections.FastInteraction:Disconnect()
            Connections.FastInteraction = nil
        end
        
        WindUI:Notify({
            Title = "Fast Interaction",
            Content = "Fast interaction disabled!",
            Duration = 3,
            Icon = "x",
        })
    end
end

local function setNetworkOwnership(state)
    local character = LocalPlayer.Character
    if character then
        local rootPart = character:FindFirstChild("HumanoidRootPart")
        if rootPart then
            if state then
                sethiddenproperty(rootPart, "NetworkOwnershipRule", Enum.NetworkOwnership.Manual)
            else
                sethiddenproperty(rootPart, "NetworkOwnershipRule", Enum.NetworkOwnership.Automatic)
            end
        end
    end
end

local function toggleDesync(state)
    States.Desync = state
    setNetworkOwnership(state)
    
    if state then
        WindUI:Notify({
            Title = "Desync",
            Content = "Desync enabled!",
            Duration = 3,
            Icon = "check",
        })
    else
        WindUI:Notify({
            Title = "Desync",
            Content = "Desync disabled!",
            Duration = 3,
            Icon = "x",
        })
    end
end

local function toggleAutoLock(state)
    States.AutoLock = state
    
    if state then
        Connections.AutoLock = RunService.Heartbeat:Connect(function()
            local plotName = getPlayerPlot()
            if plotName then
                local plots = Workspace:FindFirstChild("Plots")
                local plot = plots and plots:FindFirstChild(plotName)
                
                if plot then
                    local purchases = plot:FindFirstChild("Purchases")
                    if purchases then
                        local plotBlock = purchases:FindFirstChild("PlotBlock")
                        if plotBlock then
                            local main = plotBlock:FindFirstChild("Main")
                            if main then
                                local billboard = main:FindFirstChild("BillboardGui")
                                if billboard then
                                    local remaining = billboard:FindFirstChild("RemainingTime")
                                    if remaining and remaining.Text == "0s" then
                                        local hitbox = plotBlock:FindFirstChild("Hitbox")
                                        if hitbox and hitbox:FindFirstChild("TouchInterest") then
                                            local character = LocalPlayer.Character
                                            local root = character and character:FindFirstChild("HumanoidRootPart")
                                            if root then
                                                firetouchinterest(root, hitbox, 0)
                                                task.wait(0.1)
                                                firetouchinterest(root, hitbox, 1)
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end)
        
        WindUI:Notify({
            Title = "Auto Lock",
            Content = "Auto lock enabled!",
            Duration = 3,
            Icon = "check",
        })
    else
        if Connections.AutoLock then
            Connections.AutoLock:Disconnect()
            Connections.AutoLock = nil
        end
        
        WindUI:Notify({
            Title = "Auto Lock",
            Content = "Auto lock disabled!",
            Duration = 3,
            Icon = "x",
        })
    end
end

local function toggleNoClip(state)
    States.NoClip = state
    
    if state then
        Connections.NoClip = RunService.Stepped:Connect(function()
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
        
        WindUI:Notify({
            Title = "No Clip",
            Content = "No clip enabled!",
            Duration = 3,
            Icon = "check",
        })
    else
        if Connections.NoClip then
            Connections.NoClip:Disconnect()
            Connections.NoClip = nil
        end
        
        local character = LocalPlayer.Character
        if character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
        
        WindUI:Notify({
            Title = "No Clip",
            Content = "No clip disabled!",
            Duration = 3,
            Icon = "x",
        })
    end
end

local function toggleAntiRagdoll(state)
    States.AntiRagdoll = state
    
    if state then
        Connections.AntiRagdoll = RunService.Heartbeat:Connect(function()
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                end
            end
        end)
        
        WindUI:Notify({
            Title = "Anti Ragdoll",
            Content = "Anti ragdoll enabled!",
            Duration = 3,
            Icon = "check",
        })
    else
        if Connections.AntiRagdoll then
            Connections.AntiRagdoll:Disconnect()
            Connections.AntiRagdoll = nil
        end
        
        local character = LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChild("Humanoid")
            if humanoid then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
            end
        end
        
        WindUI:Notify({
            Title = "Anti Ragdoll",
            Content = "Anti ragdoll disabled!",
            Duration = 3,
            Icon = "x",
        })
    end
end

local originalJumpPower = nil
local function toggleInfiniteJump(state)
    States.InfiniteJump = state
    
    if state then
        local function onCharacterAdded(character)
            local humanoid = character:WaitForChild("Humanoid")
            originalJumpPower = humanoid.JumpPower
        end
        
        LocalPlayer.CharacterAdded:Connect(onCharacterAdded)
        if LocalPlayer.Character then
            onCharacterAdded(LocalPlayer.Character)
        end
        
        Connections.InfiniteJump = UserInputService.JumpRequest:Connect(function()
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid and originalJumpPower then
                    humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                    humanoid.JumpPower = originalJumpPower
                end
            end
        end)
        
        WindUI:Notify({
            Title = "Infinite Jump",
            Content = "Infinite jump enabled!",
            Duration = 3,
            Icon = "check",
        })
    else
        if Connections.InfiniteJump then
            Connections.InfiniteJump:Disconnect()
            Connections.InfiniteJump = nil
        end
        
        WindUI:Notify({
            Title = "Infinite Jump",
            Content = "Infinite jump disabled!",
            Duration = 3,
            Icon = "x",
        })
    end
end

local function toggleGodMode(state)
    States.GodMode = state
    
    if state then
        Connections.GodMode = RunService.Heartbeat:Connect(function()
            local character = LocalPlayer.Character
            if character then
                local humanoid = character:FindFirstChild("Humanoid")
                if humanoid then
                    humanoid.Health = humanoid.MaxHealth
                end
            end
        end)
        
        WindUI:Notify({
            Title = "God Mode",
            Content = "God mode enabled!",
            Duration = 3,
            Icon = "check",
        })
    else
        if Connections.GodMode then
            Connections.GodMode:Disconnect()
            Connections.GodMode = nil
        end
        
        WindUI:Notify({
            Title = "God Mode",
            Content = "God mode disabled!",
            Duration = 3,
            Icon = "x",
        })
    end
end

-- ========================================
-- SPEED SPOOFER
-- ========================================
local WalkSpeedSpoof = getgenv().WalkSpeedSpoof
local Disable = WalkSpeedSpoof and WalkSpeedSpoof.Disable
if Disable then
    Disable()
end

local cloneref = cloneref or function(...)
    return ...
end

WalkSpeedSpoof = {}

local split = string.split

local GetDebugIdHandler = Instance.new("BindableFunction")
local TempHumanoid = Instance.new("Humanoid")

local cachedhumanoids = {}

local CurrentHumanoid
local newindexhook
local indexhook

function GetDebugIdHandler.OnInvoke(obj)
    return obj:GetDebugId()
end

local function GetDebugId(obj)
    return GetDebugIdHandler:Invoke(obj)
end

local function GetWalkSpeed(obj)
    TempHumanoid.WalkSpeed = obj
    return TempHumanoid.WalkSpeed
end

function cachedhumanoids:cacheHumanoid(DebugId, Humanoid)
    cachedhumanoids[DebugId] = {
        currentindex = indexhook(Humanoid, "WalkSpeed"),
        lastnewindex = nil
    }
    return self[DebugId]
end

indexhook = hookmetamethod(game, "__index", function(self, index)
    if not checkcaller() and typeof(self) == "Instance" then
        if self:IsA("Humanoid") then
            local DebugId = GetDebugId(self)
            local cached = cachedhumanoids[DebugId]

            if self:IsDescendantOf(LocalPlayer.Character) or cached then
                if type(index) == "string" then
                    local cleanindex = split(index, "\0")[1]

                    if cleanindex == "WalkSpeed" then
                        if not cached then
                            cached = cachedhumanoids:cacheHumanoid(DebugId, self)
                        end

                        if not (CurrentHumanoid and CurrentHumanoid:IsDescendantOf(game)) then
                            CurrentHumanoid = cloneref(self)
                        end

                        return cached.lastnewindex or cached.currentindex
                    end
                end
            end
        end
    end

    return indexhook(self, index)
end)

newindexhook = hookmetamethod(game, "__newindex", function(self, index, newindex)
    if not checkcaller() and typeof(self) == "Instance" then
        if self:IsA("Humanoid") then
            local DebugId = GetDebugId(self)
            local cached = cachedhumanoids[DebugId]

            if self:IsDescendantOf(LocalPlayer.Character) or cached then
                if type(index) == "string" then
                    local cleanindex = split(index, "\0")[1]

                    if cleanindex == "WalkSpeed" then
                        if not cached then
                            cached = cachedhumanoids:cacheHumanoid(DebugId, self)
                        end

                        if not (CurrentHumanoid and CurrentHumanoid:IsDescendantOf(game)) then
                            CurrentHumanoid = cloneref(self)
                        end
                        cached.lastnewindex = GetWalkSpeed(newindex)
                        return CurrentHumanoid.WalkSpeed
                    end
                end
            end
        end
    end
    
    return newindexhook(self, index, newindex)
end)

function WalkSpeedSpoof:Disable()
    WalkSpeedSpoof:RestoreWalkSpeed()
    hookmetamethod(game, "__index", indexhook)
    hookmetamethod(game, "__newindex", newindexhook)
    GetDebugIdHandler:Destroy()
    TempHumanoid:Destroy()
    table.clear(WalkSpeedSpoof)
    getgenv().WalkSpeedSpoof = nil
end

function WalkSpeedSpoof:GetHumanoid()
    return CurrentHumanoid or (function()
        local char = LocalPlayer.Character
        local Humanoid = char and char:FindFirstChildWhichIsA("Humanoid") or nil
        
        if Humanoid then
            cachedhumanoids:cacheHumanoid(Humanoid:GetDebugId(), Humanoid)
            return cloneref(Humanoid)
        end
    end)()
end

function WalkSpeedSpoof:SetWalkSpeed(speed)
    local Humanoid = WalkSpeedSpoof:GetHumanoid()

    if Humanoid then
        local connections = {}
        local function AddConnectionsFromSignal(Signal)
            for i, v in getconnections(Signal) do
                if v.State then
                    v:Disable()
                    table.insert(connections, v)
                end
            end
        end
        AddConnectionsFromSignal(Humanoid.Changed)
        AddConnectionsFromSignal(Humanoid:GetPropertyChangedSignal("WalkSpeed"))
        Humanoid.WalkSpeed = speed
        for i, v in connections do
            v:Enable()
        end
    end
end

function WalkSpeedSpoof:RestoreWalkSpeed()
    local Humanoid = WalkSpeedSpoof:GetHumanoid()
    
    if Humanoid then
        local cached = cachedhumanoids[Humanoid:GetDebugId()]

        if cached then
            WalkSpeedSpoof:SetWalkSpeed(cached.lastnewindex or cached.currentindex)
        end
    end
end

getgenv().WalkSpeedSpoof = WalkSpeedSpoof

local function toggleSpeed(state)
    States.SpeedEnabled = state
    
    if state then
        WalkSpeedSpoof:SetWalkSpeed(States.SpeedValue)
        
        if not Connections.SpeedRespawn then
            Connections.SpeedRespawn = LocalPlayer.CharacterAdded:Connect(function(character)
                local humanoid = character:WaitForChild("Humanoid")
                task.wait(0.5)
                
                if States.SpeedEnabled then
                    WalkSpeedSpoof:SetWalkSpeed(States.SpeedValue)
                    
                    WindUI:Notify({
                        Title = "Speed",
                        Content = "Speed reapplied after respawn!",
                        Duration = 2,
                        Icon = "check",
                    })
                end
            end)
        end
        
        WindUI:Notify({
            Title = "Speed",
            Content = "Speed enabled!",
            Duration = 3,
            Icon = "check",
        })
    else
        WalkSpeedSpoof:RestoreWalkSpeed()

        if Connections.SpeedRespawn then
            Connections.SpeedRespawn:Disconnect()
            Connections.SpeedRespawn = nil
        end
        
        WindUI:Notify({
            Title = "Speed",
            Content = "Speed disabled!",
            Duration = 3,
            Icon = "x",
        })
    end
end

local function updateSpeedValue(value)
    States.SpeedValue = value
    
    if States.SpeedEnabled then
        WalkSpeedSpoof:SetWalkSpeed(value)
    end
end

local function toggleAntiKick(state)
    States.AntiKick = state
    
    if getgenv then
        getgenv().AntiKickEnabled = state
    end
    _G.AntiKickEnabled = state
    
    WindUI:Notify({
        Title = "Anti Kick " .. (state and "Enabled" or "Disabled"),
        Content = state and "You are now protected from kicks!" or "Anti-kick protection disabled.",
        Duration = 3,
        Icon = state and "shield" or "shield-off",
    })
end

local function saveConfiguration()
    myConfig:Save()
    
    WindUI:Notify({
        Title = "Configuration Saved",
        Content = "All your settings have been saved successfully!",
        Duration = 3,
        Icon = "save",
    })
end

local function loadConfiguration()
    myConfig:Load()
    
    WindUI:Notify({
        Title = "Configuration Loaded",
        Content = "All your saved settings have been loaded!",
        Duration = 3,
        Icon = "download",
    })
end

local function changeTheme(themeName)
    States.CurrentTheme = themeName
    WindUI:SetTheme(themeName)
end

-- ========================================
-- CREATE TABS
-- ========================================
local MainTab = Window:Tab({
    Title = "Main",
    Icon = "home",
})

local PlayerTab = Window:Tab({
    Title = "Player",
    Icon = "user",
})

local VisualTab = Window:Tab({
    Title = "Visual",
    Icon = "eye",
})

local CreditsTab = Window:Tab({
    Title = "Credits",
    Icon = "heart",
})

local MiscTab = Window:Tab({
    Title = "Misc",
    Icon = "info",
})

local SettingsTab = Window:Tab({
    Title = "Settings",
    Icon = "settings",
})

-- ========================================
-- MAIN TAB ELEMENTS
-- ========================================
local AutoStealToggle = MainTab:Toggle({
    Title = "Auto Steal (NEW)",
    Desc = "Automatically steal clowns from highest to lowest price",
    Default = false,
    Callback = function(state)
        toggleAutoSteal(state)
    end
})

local InstantStealToggle = MainTab:Toggle({
    Title = "Instant Steal (NEW)",
    Desc = "Auto collect when you steal a clown",
    Default = false,
    Callback = function(state)
        toggleInstantSteal(state)
    end
})

local StealUIToggle = MainTab:Toggle({
    Title = "Steal UI",
    Desc = "Show/Hide the steal button UI",
    Default = false,
    Callback = function(state)
        toggleStealUI(state)
    end
})

local AutoCollectToggle = MainTab:Toggle({
    Title = "Auto Collect",
    Desc = "Automatically collect from podiums every 5 seconds",
    Default = false,
    Callback = function(state)
        toggleAutoCollect(state)
    end
})

local FastInteractionToggle = MainTab:Toggle({
    Title = "Fast Interaction",
    Desc = "Instant interaction with no hold duration",
    Default = false,
    Callback = function(state)
        toggleFastInteraction(state)
    end
})

local DesyncToggle = MainTab:Toggle({
    Title = "Desync",
    Desc = "Enable network desync",
    Default = false,
    Callback = function(state)
        toggleDesync(state)
    end
})

local AntiVoidToggle = MainTab:Toggle({
    Title = "Anti-Void",
    Desc = "Auto-prevents falling below Y=-30",
    Default = false,
    Callback = function(state)
        toggleAntiVoid(state)
    end
})

local AutoLockToggle = MainTab:Toggle({
    Title = "Auto Lock",
    Desc = "Automatically lock base when timer hits 0s",
    Default = false,
    Callback = function(state)
        toggleAutoLock(state)
    end
})

myConfig:Register("AutoSteal", AutoStealToggle)
myConfig:Register("StealUI", StealUIToggle)
myConfig:Register("AutoCollect", AutoCollectToggle)
myConfig:Register("FastInteraction", FastInteractionToggle)
myConfig:Register("Desync", DesyncToggle)
myConfig:Register("AntiVoid", AntiVoidToggle)
myConfig:Register("AutoLock", AutoLockToggle)

-- ========================================
-- PLAYER TAB ELEMENTS
-- ========================================
local NoClipToggle = PlayerTab:Toggle({
    Title = "No Clip",
    Desc = "Walk through walls",
    Default = false,
    Callback = function(state)
        toggleNoClip(state)
    end
})

local AntiRagdollToggle = PlayerTab:Toggle({
    Title = "Anti Ragdoll",
    Desc = "Prevents ragdoll",
    Default = false,
    Callback = function(state)
        toggleAntiRagdoll(state)
    end
})

local InfiniteJumpToggle = PlayerTab:Toggle({
    Title = "Infinite Jump",
    Desc = "Jump infinitely",
    Default = false,
    Callback = function(state)
        toggleInfiniteJump(state)
    end
})

local GodModeToggle = PlayerTab:Toggle({
    Title = "God Mode",
    Desc = "Become invincible",
    Default = false,
    Callback = function(state)
        toggleGodMode(state)
    end
})

local SpeedToggle = PlayerTab:Toggle({
    Title = "Speed",
    Desc = "Enable speed modification",
    Default = false,
    Callback = function(state)
        toggleSpeed(state)
    end
})

local SpeedSlider = PlayerTab:Slider({
    Title = "Speed Value",
    Step = 1,
    Value = {
        Min = 34,
        Max = 200,
        Default = 34,
    },
    Callback = function(value)
        updateSpeedValue(value)
    end
})

myConfig:Register("InstantSteal", InstantStealToggle)
myConfig:Register("NoClip", NoClipToggle)
myConfig:Register("AntiRagdoll", AntiRagdollToggle)
myConfig:Register("InfiniteJump", InfiniteJumpToggle)
myConfig:Register("GodMode", GodModeToggle)
myConfig:Register("Speed", SpeedToggle)
myConfig:Register("SpeedValue", SpeedSlider)

-- ========================================
-- VISUAL TAB ELEMENTS
-- ========================================
local PlayerESPToggle = VisualTab:Toggle({
    Title = "Player ESP",
    Desc = "See all players through walls with usernames",
    Default = false,
    Callback = function(state)
        togglePlayerESP(state)
    end
})

local BaseESPToggle = VisualTab:Toggle({
    Title = "Base ESP",
    Desc = "Highlight all plot signs",
    Default = false,
    Callback = function(state)
        toggleBaseESP(state)
    end
})

local BaseTimeESPToggle = VisualTab:Toggle({
    Title = "Base Time ESP",
    Desc = "Show remaining times with color coding (Green=0s, Yellow<5s, Red<10s)",
    Default = false,
    Callback = function(state)
        toggleBaseTimeESP(state)
    end
})

local BaseRemainingTimeToggle = VisualTab:Toggle({
    Title = "Base Remaining Time ESP",
    Desc = "Show your base time in center-top UI",
    Default = false,
    Callback = function(state)
        toggleBaseRemainingTimeESP(state)
    end
})

myConfig:Register("PlayerESP", PlayerESPToggle)
myConfig:Register("BaseESP", BaseESPToggle)
myConfig:Register("BaseTimeESP", BaseTimeESPToggle)
myConfig:Register("BaseRemainingTimeESP", BaseRemainingTimeToggle)

-- ========================================
-- CREDITS TAB ELEMENTS
-- ========================================
local CreditsParagraph = CreditsTab:Paragraph({
    Title = "Scripts Hub X | Official",
    Desc = "Made by PickleTalk and Mhicel. Join our discord server to be always updated with the latest features and scripts!",
    Color = "Red",
    Thumbnail = "rbxassetid://74135635728836",
    ThumbnailSize = 140,
    Buttons = {
        {
            Icon = "users",
            Title = "Discord",
            Callback = function()
                setclipboard("https://discord.gg/bpsNUH5sVb")
                WindUI:Notify({
                    Title = "Discord Link Copied!",
                    Content = "Discord invite link copied to clipboard!",
                    Duration = 3,
                    Icon = "check",
                })
            end,
        }
    }
})

-- ========================================
-- MISC TAB ELEMENTS
-- ========================================
local currentPlayers = #Players:GetPlayers()
local maxPlayers = Players.MaxPlayers

local ServerInfoParagraph = MiscTab:Paragraph({
    Title = "Server Information",
    Desc = string.format(
        "Game: Steal A Clown\nPlace ID: %d\nJob ID: %s\nPlayers: %d/%d",
        game.PlaceId,
        game.JobId,
        currentPlayers,
        maxPlayers
    ),
})

-- Update player count every 5 seconds
task.spawn(function()
    while true do
        task.wait(5)
        local currentPlayers = #Players:GetPlayers()
        ServerInfoParagraph:Set({
            Desc = string.format(
                "Game: Steal A Clown\nPlace ID: %d\nJob ID: %s\nPlayers: %d/%d",
                game.PlaceId,
                game.JobId,
                currentPlayers,
                maxPlayers
            )
        })
    end
end)

local SmallServerHopButton = MiscTab:Button({
    Title = "Hop Small Server",
    Desc = "Teleport to the smallest available server",
    Callback = function()
        hopToSmallestServer()
    end
})

local RandomServerHopButton = MiscTab:Button({
    Title = "Server Hop",
    Desc = "Teleport to a random non-full server",
    Callback = function()
        hopToRandomServer()
    end
})

-- ========================================
-- SETTINGS TAB ELEMENTS
-- ========================================
local SaveConfigButton = SettingsTab:Button({
    Title = "Save Configuration",
    Desc = "Save all current settings to file",
    Callback = function()
        saveConfiguration()
    end
})

local LoadConfigButton = SettingsTab:Button({
    Title = "Load Configuration",
    Desc = "Load your saved settings from file",
    Callback = function()
        loadConfiguration()
    end
})

local ThemeDropdown = SettingsTab:Dropdown({
    Title = "Theme Selector",
    Values = {
        {Title = "Anime Dark", Icon = "moon"},
        {Title = "Anime Light", Icon = "sun"},
        {Title = "Purple Dream", Icon = "sparkles"},
        {Title = "Ocean Blue", Icon = "waves"},
        {Title = "Forest Green", Icon = "tree-deciduous"},
        {Title = "Crimson Red", Icon = "flame"},
        {Title = "Sunset Orange", Icon = "sunset"},
        {Title = "Midnight Purple", Icon = "moon-star"},
        {Title = "Cyan Glow", Icon = "zap"},
        {Title = "Rose Pink", Icon = "heart"},
        {Title = "Golden Hour", Icon = "sun"},
        {Title = "Neon Green", Icon = "zap-off"},
        {Title = "Electric Blue", Icon = "sparkle"},
        {Title = "Custom", Icon = "palette"},
    },
    Value = "Anime Dark",
    Callback = function(option)
        changeTheme(option.Title)
    end
})

local ThemeColorPicker = SettingsTab:Colorpicker({
    Title = "Custom Theme Color",
    Desc = "Select a custom accent color for the UI",
    Default = Color3.fromRGB(255, 15, 123),
    Callback = function(color)
        WindUI:AddTheme({
            Name = "Custom",
            Accent = color,
            Dialog = Color3.fromHex("#161616"),
            Outline = color,
            Text = Color3.fromHex("#FFFFFF"),
            Placeholder = Color3.fromHex("#7a7a7a"),
            Background = Color3.fromHex("#101010"),
            Button = Color3.fromHex("#52525b"),
            Icon = color
        })
        
        WindUI:SetTheme("Custom")
        States.CurrentTheme = "Custom"
    end
})

local AntiKickToggle = SettingsTab:Toggle({
    Title = "Anti Kick Protection",
    Desc = "Protects you from being kicked by anti-cheat",
    Default = false,
    Callback = function(state)
        toggleAntiKick(state)
    end
})

myConfig:Register("Theme", ThemeDropdown)
myConfig:Register("ThemeColor", ThemeColorPicker)
myConfig:Register("AntiKick", AntiKickToggle)

-- ========================================
-- WELCOME POPUP
-- ========================================
Window:Tag({
    Title = "v1.5.4",
    Color = Color3.fromHex("#30ff6a"),
    Radius = 13, -- from 0 to 13
})

WindUI:Popup({
    Title = "Steal A Clown",
    Icon = "sword",
    Content = "New Update: Added Instant Steal, Improved Anti Void!, added Auto Steal",
    Buttons = {
        {
            Title = "Close",
            Callback = function() end,
            Variant = "Tertiary",
        },
        {
            Title = "Join Discord",
            Icon = "users",
            Callback = function()
                setclipboard("https://discord.gg/bpsNUH5sVb")
                WindUI:Notify({
                    Title = "Link Copied!",
                    Content = "Discord invite copied to clipboard!",
                    Duration = 3,
                    Icon = "check",
                })
            end,
            Variant = "Primary",
        }
    }
})

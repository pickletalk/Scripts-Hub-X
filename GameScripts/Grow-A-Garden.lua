-- Grow A Garden Auto Farm Script
-- By PickleTalk | Scripts Hub X

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Remote Events
local BuyGearStock = ReplicatedStorage.GameEvents.BuyGearStock
local BuySeedStock = ReplicatedStorage.GameEvents.BuySeedStock
local BuyPetEgg = ReplicatedStorage.GameEvents.BuyPetEgg

-- Item Lists
local gearItems = {
    "Watering Can", "Trading Ticket", "Trowel", "Recall Wrench", "Basic Sprinkler",
    "Advanced Sprinkler", "Medium Toy", "Medium Treat", "Godly Sprinkler",
    "Magnifying Glass", "Master Sprinkler", "Cleaning Spray", "Cleansing Pet Shard",
    "Favorite Tool", "Harvest Tool", "Friendship Pot", "Grandmaster Sprinkler", "Levelup Lollipop"
}

local seedItems = {
    "Carrot", "Strawberry", "Blueberry", "Orange Tulip", "Tomato", "Corn", "Daffodil",
    "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit",
    "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Beanstalk", "Ember Lily",
    "Sugar Apple", "Burning Bud", "Giant Pinecone", "Elder Strawberry", "Romanesco",
    "Crimson Thorn", "Great Pumpkin"
}

local eggItems = {
    "Common Egg", "Uncommon Egg", "Rare Egg", "Legendary Egg", "Mythical Egg",
    "Jungle Egg", "Bug Egg"
}

local itemCounts = {
    Gears = {},
    Seeds = {},
    Eggs = {}
}

for _, item in ipairs(gearItems) do
    itemCounts.Gears[item] = 0
end
for _, item in ipairs(seedItems) do
    itemCounts.Seeds[item] = 0
end
for _, item in ipairs(eggItems) do
    itemCounts.Eggs[item] = 0
end

local uiLabels = {
    Gears = {},
    Seeds = {},
    Eggs = {}
}

local isMinimized = false

local function createUI()
    -- Main ScreenGui
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GardenAutoFarmUI"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    -- Main Frame (3-Column Layout)
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 300, 0, 370)
    mainFrame.Position = UDim2.new(0.5, -150, 0.5, -185)
    mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    mainFrame.BorderSizePixel = 0
    mainFrame.Parent = screenGui
    
    -- Corner Rounding
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = mainFrame
    
    -- Header
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.Size = UDim2.new(1, 0, 0, 40)
    header.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    header.BorderSizePixel = 0
    header.Parent = mainFrame
    
    local headerCorner = Instance.new("UICorner")
    headerCorner.CornerRadius = UDim.new(0, 10)
    headerCorner.Parent = header
    
    -- Title
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.Size = UDim2.new(1, -45, 0, 20)
    title.Position = UDim2.new(0, 10, 0, 5)
    title.BackgroundTransparency = 1
    title.Text = "🌱 Auto Farm Logs"
    title.TextColor3 = Color3.fromRGB(100, 255, 100)
    title.TextSize = 16
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = header
    
    -- Subtitle
    local subtitle = Instance.new("TextLabel")
    subtitle.Name = "Subtitle"
    subtitle.Size = UDim2.new(1, -45, 0, 15)
    subtitle.Position = UDim2.new(0, 10, 0, 22)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "By PickleTalk"
    subtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
    subtitle.TextSize = 11
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.Parent = header
    
    local minimizeBtn = Instance.new("TextButton")
    minimizeBtn.Name = "MinimizeButton"
    minimizeBtn.Size = UDim2.new(0, 28, 0, 28)
    minimizeBtn.Position = UDim2.new(1, -34, 0, 6)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    minimizeBtn.Text = "−"
    minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    minimizeBtn.TextSize = 18
    minimizeBtn.Font = Enum.Font.GothamBold
    minimizeBtn.Parent = header
    
    local minimizeBtnCorner = Instance.new("UICorner")
    minimizeBtnCorner.CornerRadius = UDim.new(0, 6)
    minimizeBtnCorner.Parent = minimizeBtn
    
    local contentFrame = Instance.new("Frame")
    contentFrame.Name = "ContentFrame"
    contentFrame.Size = UDim2.new(1, -16, 1, -48)
    contentFrame.Position = UDim2.new(0, 8, 0, 44)
    contentFrame.BackgroundTransparency = 1
    contentFrame.BorderSizePixel = 0
    contentFrame.Parent = mainFrame
    
    local function createColumn(sectionName, items, xOffset)
        local column = Instance.new("Frame")
        column.Name = sectionName .. "Column"
        column.Size = UDim2.new(0, 90, 1, 0)
        column.Position = UDim2.new(0, xOffset, 0, 0)
        column.BackgroundTransparency = 1
        column.Parent = contentFrame
        
        local columnTitle = Instance.new("TextLabel")
        columnTitle.Name = "ColumnTitle"
        columnTitle.Size = UDim2.new(1, 0, 0, 20)
        columnTitle.BackgroundTransparency = 1
        columnTitle.Text = sectionName .. ":"
        columnTitle.TextColor3 = Color3.fromRGB(100, 255, 100)
        columnTitle.TextSize = 13
        columnTitle.Font = Enum.Font.GothamBold
        columnTitle.TextXAlignment = Enum.TextXAlignment.Center
        columnTitle.Parent = column
        
        local itemsScroll = Instance.new("ScrollingFrame")
        itemsScroll.Name = "ItemsScroll"
        itemsScroll.Size = UDim2.new(1, 0, 1, -22)
        itemsScroll.Position = UDim2.new(0, 0, 0, 22)
        itemsScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        itemsScroll.BorderSizePixel = 0
        itemsScroll.ScrollBarThickness = 3
        itemsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
        itemsScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
        itemsScroll.Parent = column
        
        local scrollCorner = Instance.new("UICorner")
        scrollCorner.CornerRadius = UDim.new(0, 6)
        scrollCorner.Parent = itemsScroll
        
        local itemsContainer = Instance.new("Frame")
        itemsContainer.Name = "ItemsContainer"
        itemsContainer.Size = UDim2.new(1, -4, 0, 0)
        itemsContainer.Position = UDim2.new(0, 2, 0, 2)
        itemsContainer.BackgroundTransparency = 1
        itemsContainer.Parent = itemsScroll
        
        local listLayout = Instance.new("UIListLayout")
        listLayout.SortOrder = Enum.SortOrder.LayoutOrder
        listLayout.Padding = UDim.new(0, 2)
        listLayout.Parent = itemsContainer
        
        listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            itemsContainer.Size = UDim2.new(1, -4, 0, listLayout.AbsoluteContentSize.Y + 4)
        end)
        
        for _, itemName in ipairs(items) do
            local itemLabel = Instance.new("TextLabel")
            itemLabel.Name = itemName
            itemLabel.Size = UDim2.new(1, 0, 0, 18)
            itemLabel.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            itemLabel.BorderSizePixel = 0
            itemLabel.Text = itemName .. " (0)"
            itemLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
            itemLabel.TextSize = 9
            itemLabel.Font = Enum.Font.Gotham
            itemLabel.TextXAlignment = Enum.TextXAlignment.Left
            itemLabel.TextTruncate = Enum.TextTruncate.AtEnd
            itemLabel.Parent = itemsContainer
            
            local padding = Instance.new("UIPadding")
            padding.PaddingLeft = UDim.new(0, 4)
            padding.Parent = itemLabel
            
            local itemCorner = Instance.new("UICorner")
            itemCorner.CornerRadius = UDim.new(0, 3)
            itemCorner.Parent = itemLabel
            
            uiLabels[sectionName][itemName] = itemLabel
        end
        
        return column
    end
    
    createColumn("Seeds", seedItems, 0)
    createColumn("Gears", gearItems, 95)
    createColumn("Eggs", eggItems, 190)
    
    local function toggleMinimize()
        isMinimized = not isMinimized
        
        local targetSize
        local targetText
        local targetColor
        
        if isMinimized then
            targetSize = UDim2.new(0, 300, 0, 40)
            targetText = "+"
            targetColor = Color3.fromRGB(100, 255, 100)
            contentFrame.Visible = false
        else
            targetSize = UDim2.new(0, 300, 0, 370)
            targetText = "−"
            targetColor = Color3.fromRGB(255, 100, 100)
            contentFrame.Visible = true
        end
        
        -- Smooth animation
        local tween = TweenService:Create(
            mainFrame,
            TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),
            {Size = targetSize}
        )
        tween:Play()
        
        minimizeBtn.Text = targetText
        minimizeBtn.BackgroundColor3 = targetColor
    end
    
    minimizeBtn.MouseButton1Click:Connect(toggleMinimize)
    
    local dragging = false
    local dragInput, dragStart, startPos
    
    local function update(input)
        local delta = input.Position - dragStart
        local targetPos = UDim2.new(
            startPos.X.Scale, 
            startPos.X.Offset + delta.X, 
            startPos.Y.Scale, 
            startPos.Y.Offset + delta.Y
        )
        
        TweenService:Create(
            mainFrame,
            TweenInfo.new(0.1, Enum.EasingStyle.Linear),
            {Position = targetPos}
        ):Play()
    end
    
    header.InputBegan:Connect(function(input)
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
    
    header.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)
    
    screenGui.Parent = playerGui
    return screenGui
end

local function updateUILabel(category, itemName, newCount)
    if uiLabels[category] and uiLabels[category][itemName] then
        local label = uiLabels[category][itemName]
        label.Text = itemName .. " (" .. newCount .. ")"
        
        local originalColor = label.BackgroundColor3
        label.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
        TweenService:Create(label, TweenInfo.new(0.4), {BackgroundColor3 = originalColor}):Play()
    end
end

local function checkInventory()
    local backpack = player:FindFirstChild("Backpack")
    if not backpack then return end
    
    for category, items in pairs(itemCounts) do
        for itemName, currentCount in pairs(items) do
            local itemsFound = 0

            for _, child in ipairs(backpack:GetChildren()) do
                if child.Name == itemName or string.find(child.Name, itemName) then
                    itemsFound = itemsFound + 1
                end
            end

            if player.Character then
                for _, child in ipairs(player.Character:GetChildren()) do
                    if child.Name == itemName or string.find(child.Name, itemName) then
                        itemsFound = itemsFound + 1
                    end
                end
            end
            
            if itemsFound > currentCount then
                itemCounts[category][itemName] = itemsFound
                updateUILabel(category, itemName, itemsFound)
            end
        end
    end
end

local function startAutoFarm()
    while true do
        local seedStartTime = tick()
        local seedFireCount = 0
        while tick() - seedStartTime < 5 do
            for _, seedName in ipairs(seedItems) do
                pcall(function()
                    BuySeedStock:FireServer("Shop", seedName)
                end)
            end
            seedFireCount = seedFireCount + 1
            wait(0.01)
        end

        local gearStartTime = tick()
        local gearFireCount = 0
        while tick() - gearStartTime < 5 do
            for _, gearName in ipairs(gearItems) do
                pcall(function()
                    BuyGearStock:FireServer(gearName)
                end)
            end
            gearFireCount = gearFireCount + 1
            wait(0.01)
        end

        local eggStartTime = tick()
        local eggFireCount = 0
        while tick() - eggStartTime < 5 do
            for _, eggName in ipairs(eggItems) do
                pcall(function()
                    BuyPetEgg:FireServer(eggName)
                end)
            end
            eggFireCount = eggFireCount + 1
            wait(0.01)
        end
    
        checkInventory()
        wait(300)
    end
end

-- Initialize
print("🌱 Pickle Auto Farm Loading...")

-- Create UI
createUI()

-- Start continuous inventory monitoring
spawn(function()
    while wait(1) do
        checkInventory()
    end
end)

-- Start auto farm with burst buying system
spawn(function()
    startAutoFarm()
end)

-- ========================================
-- MAIN SERVICES
-- ========================================
if not game:IsLoaded() then game.Loaded:Wait() end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- ========================================
-- SAFE GUI PARENT
-- ========================================
local function safeGuiParent()
    local ok, res = pcall(function()
        if gethui then return gethui() end
        return game:GetService("CoreGui")
    end)
    if ok and res then return res end
    return player:WaitForChild("PlayerGui")
end

local parentGui = safeGuiParent()
local existing = parentGui:FindFirstChild("PlotTeleporterUI")
if existing then existing:Destroy() end

-- ========================================
-- UI CREATION
-- ========================================
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "PlotTeleporterUI"
screenGui.ResetOnSpawn = false
screenGui.Parent = parentGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 250, 0, 120)
mainFrame.Position = UDim2.new(1, -260, 0, 10)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(80, 80, 80)
mainFrame.Parent = screenGui
Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 8)

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
titleBar.BorderSizePixel = 2
titleBar.BorderColor3 = Color3.fromRGB(100, 100, 100)
titleBar.Parent = mainFrame
Instance.new("UICorner", titleBar).CornerRadius = UDim.new(0, 8)

local titleText = Instance.new("TextLabel")
titleText.Size = UDim2.new(1, -30, 1, 0)
titleText.Position = UDim2.new(0, 5, 0, 0)
titleText.BackgroundTransparency = 1
titleText.Text = "Steal A Brainrot"
titleText.TextColor3 = Color3.fromRGB(220, 220, 220)
titleText.TextScaled = true
titleText.Font = Enum.Font.GothamBold
titleText.Parent = titleBar

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 25, 0, 25)
closeButton.Position = UDim2.new(1, -27, 0, 2)
closeButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
closeButton.BorderSizePixel = 2
closeButton.BorderColor3 = Color3.fromRGB(100, 100, 100)
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(200, 200, 200)
closeButton.TextScaled = true
closeButton.Font = Enum.Font.GothamBold
closeButton.Parent = titleBar
Instance.new("UICorner", closeButton).CornerRadius = UDim.new(0, 4)

local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 220, 0, 35)
teleportButton.Position = UDim2.new(0, 15, 0, 45)
teleportButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
teleportButton.BorderSizePixel = 2
teleportButton.BorderColor3 = Color3.fromRGB(100, 100, 100)
teleportButton.Text = "Steal"
teleportButton.TextColor3 = Color3.fromRGB(220, 220, 220)
teleportButton.TextScaled = true
teleportButton.Font = Enum.Font.GothamBold
teleportButton.Parent = mainFrame
Instance.new("UICorner", teleportButton).CornerRadius = UDim.new(0, 6)

-- overlay RGB subtle
local rgbOverlay = Instance.new("Frame")
rgbOverlay.Size = UDim2.new(1, 0, 1, 0)
rgbOverlay.BackgroundTransparency = 0.85
rgbOverlay.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
rgbOverlay.ZIndex = teleportButton.ZIndex + 1
rgbOverlay.Parent = teleportButton
Instance.new("UICorner", rgbOverlay).CornerRadius = UDim.new(0, 6)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, -20, 0, 25)
statusLabel.Position = UDim2.new(0, 10, 0, 90)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "by PickleTalk"
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 150)
statusLabel.TextScaled = true
statusLabel.Font = Enum.Font.Gotham
statusLabel.TextXAlignment = Enum.TextXAlignment.Left
statusLabel.Parent = mainFrame

-- ========================================
-- PLOT DETECTION SYSTEM
-- ========================================
local playerPlot = nil

local plotIds = {
    "eace968c-881f-43f9-9c0b-b2fc25f3f8ec",
    "d7f59025-991d-4538-b499-bfe00c5a309b",
    "b5c3542d-a60a-438c-9317-daea42823f20",
    "af81bdb9-a235-4a49-a95f-76706e1195fd",
    "a130a38a-aa6d-44d1-a55d-bcc77332824b",
    "84042e01-722c-45ea-908d-a11b849b883e",
    "97e28a62-36f2-49c9-aabb-6e5578b2f96c",
    "80ef716c-dc18-4151-b8ef-2b57e4dd86a0"
}

local function findPlayerPlot()
    local expectedText = player.DisplayName .. "'s Base"
    statusLabel.Text = "Searching for: " .. expectedText
    
    -- First check if Plots folder exists
    local plotsFolder = workspace:FindFirstChild("Plots")
    if not plotsFolder then
        statusLabel.Text = "Plots folder not found"
        return nil
    end
    
    -- Debug: List all plots found
    local foundPlots = {}
    for _, child in pairs(plotsFolder:GetChildren()) do
        table.insert(foundPlots, child.Name)
    end
    print("Available plots:", table.concat(foundPlots, ", "))
    
    for _, plotId in pairs(plotIds) do
        local plot = plotsFolder:FindFirstChild(plotId)
        if plot then
            print("Checking plot:", plotId)
            
            local plotSign = plot:FindFirstChild("PlotSign")
            if plotSign then
                print("Found PlotSign in", plotId)
                
                local surfaceGui = plotSign:FindFirstChild("SurfaceGui")
                if surfaceGui then
                    print("Found SurfaceGui in", plotId)
                    
                    local frame = surfaceGui:FindFirstChild("Frame")
                    if frame then
                        print("Found Frame in", plotId)
                        
                        local textLabel = frame:FindFirstChild("TextLabel")
                        if textLabel then
                            print("Found TextLabel in", plotId, "- Text:", textLabel.Text)
                            
                            if textLabel.Text == expectedText then
                                playerPlot = plot
                                statusLabel.Text = "Found your plot!"
                                print("Match found! Using plot:", plotId)
                                return plot
                            end
                        else
                            print("No TextLabel in", plotId)
                        end
                    else
                        print("No Frame in", plotId)
                    end
                else
                    print("No SurfaceGui in", plotId)
                end
            else
                print("No PlotSign in", plotId)
            end
        else
            print("Plot not found:", plotId)
        end
    end
    
    statusLabel.Text = "Your plot not found"
    print("No matching plot found for:", expectedText)
    return nil
end

local function getPlayerPlot()
    if not playerPlot then
        findPlayerPlot()
    end
    return playerPlot
end

-- ========================================
-- TWEEN TELEPORT METHOD
-- ========================================
local TweenService = game:GetService("TweenService")
local teleporting = false

local function tweenTeleport()
    if teleporting then return end
    teleporting = true
    
    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local plot = getPlayerPlot()
    
    if not hrp or not plot then 
        teleporting = false
        statusLabel.Text = "No plot or character found"
        return 
    end
    
    local deliveryHitbox = plot:FindFirstChild("DeliveryHitbox")
    if not deliveryHitbox then
        teleporting = false
        statusLabel.Text = "DeliveryHitbox not found"
        return
    end

    teleportButton.Text = "Stealing..."
    
    -- Get target position
    local targetPos = deliveryHitbox.Position + Vector3.new(0, 3, 0)
    local startPos = hrp.Position
    local distance = (targetPos - startPos).Magnitude
    
    -- Calculate number of fragments based on distance
    local fragments = math.max(8, math.min(25, math.floor(distance / 10)))
    local fragmentDistance = distance / fragments
    
    -- Tween in small fragments
    for i = 1, fragments do
        if not hrp.Parent then break end
        
        local progress = i / fragments
        local currentTarget = startPos:lerp(targetPos, progress)
        
        -- Create tween info - medium speed
        local tweenInfo = TweenInfo.new(
            0.05,  -- Duration per fragment (medium speed)
            Enum.EasingStyle.Linear,
            Enum.EasingDirection.InOut,
            0,  -- No repeat
            false,  -- No reverse
            0   -- No delay
        )
        
        -- Create and play tween
        local tween = TweenService:Create(
            hrp, 
            tweenInfo, 
            {CFrame = CFrame.new(currentTarget)}
        )
        
        tween:Play()
        tween.Completed:Wait()
        
        -- Small delay between fragments
        task.wait(0.02)
    end
    
    teleportButton.Text = "Steal"
    statusLabel.Text = "Teleported to delivery!"
    teleporting = false
end

-- ========================================
-- EVENT CONNECTIONS
-- ========================================
closeButton.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

teleportButton.MouseButton1Click:Connect(function()
    tweenTeleport()
end)

-- RGB button effect
RunService.Heartbeat:Connect(function()
    local time = tick()
    rgbOverlay.BackgroundColor3 = Color3.fromHSV((time * 0.5) % 1, 0.3, 0.8)
end)

-- Manual plot search button (for debugging)
local searchButton = Instance.new("TextButton")
searchButton.Size = UDim2.new(0, 100, 0, 20)
searchButton.Position = UDim2.new(1, -110, 0, 5)
searchButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
searchButton.BorderSizePixel = 1
searchButton.BorderColor3 = Color3.fromRGB(100, 100, 100)
searchButton.Text = "Find Plot"
searchButton.TextColor3 = Color3.fromRGB(200, 200, 200)
searchButton.TextScaled = true
searchButton.Font = Enum.Font.Gotham
searchButton.Parent = mainFrame
Instance.new("UICorner", searchButton).CornerRadius = UDim.new(0, 4)

searchButton.MouseButton1Click:Connect(function()
    playerPlot = nil -- Reset to force new search
    findPlayerPlot()
end)

-- Auto-setup with longer delays
player.CharacterAdded:Connect(function(character)
    task.wait(5) -- Wait longer for plots to load
    findPlayerPlot()
end)

-- Setup for existing character
if player.Character then
    task.spawn(function()
        task.wait(5) -- Wait longer for plots to load
        findPlayerPlot()
    end)
else
    task.spawn(function()
        task.wait(3) -- Initial wait
        findPlayerPlot()
    end)
end

print("Plot Teleporter loaded! Use 'Find Plot' button if needed.") 

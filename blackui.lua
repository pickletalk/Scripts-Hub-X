local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local BlackUI = {}
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui
screenGui.Name = "BlackUI"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0.4, 0, 0.3, 0)
mainFrame.Position = UDim2.new(0.3, 0, 0.35, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.ClipsDescendants = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 12)
corner.Parent = mainFrame

local thumbnail = Instance.new("TextLabel")
thumbnail.Size = UDim2.new(0.8, 0, 0.2, 0)
thumbnail.Position = UDim2.new(0.1, 0, 0.1, 0)
thumbnail.BackgroundTransparency = 1
thumbnail.Text = "Sybau💔🥀🙏"
thumbnail.TextColor3 = Color3.fromRGB(255, 255, 255)
thumbnail.TextScaled = true
thumbnail.Font = Enum.Font.GothamBold
thumbnail.Parent = mainFrame

local message = Instance.new("TextLabel")
message.Size = UDim2.new(0.8, 0, 0.4, 0)
message.Position = UDim2.new(0.1, 0, 0.4, 0)
message.BackgroundTransparency = 1
message.Text = "Black Guy Detected💀"
message.TextColor3 = Color3.fromRGB(255, 255, 255)
message.TextScaled = true
message.Font = Enum.Font.Gotham
message.Parent = mainFrame

local function fadeIn()
    mainFrame.BackgroundTransparency = 1
    thumbnail.TextTransparency = 1
    message.TextTransparency = 1
    mainFrame.Visible = true
    
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local fadeInFrame = TweenService:Create(mainFrame, tweenInfo, {BackgroundTransparency = 0})
    local fadeInThumbnail = TweenService:Create(thumbnail, tweenInfo, {TextTransparency = 0})
    local fadeInMessage = TweenService:Create(message, tweenInfo, {TextTransparency = 0})
    
    fadeInFrame:Play()
    fadeInThumbnail:Play()
    fadeInMessage:Play()
end

local function fadeOut()
    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local fadeOutFrame = TweenService:Create(mainFrame, tweenInfo, {BackgroundTransparency = 1})
    local fadeOutThumbnail = TweenService:Create(thumbnail, tweenInfo, {TextTransparency = 1})
    local fadeOutMessage = TweenService:Create(message, tweenInfo, {TextTransparency = 1})
    
    fadeOutFrame:Play()
    fadeOutThumbnail:Play()
    fadeOutMessage:Play()
    
    fadeOutFrame.Completed:Connect(function()
        screenGui:Destroy()
    end)
end

function BlackUI.showBlackUI()
    fadeIn()
end

function BlackUI.hideBlackUI()
    fadeOut()
end

return BlackUI

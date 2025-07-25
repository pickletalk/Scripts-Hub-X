-- Blacklist Loading Screen Script
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Parent = playerGui
screenGui.Name = "BlacklistNotification"

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 300, 0, 100)
frame.Position = UDim2.new(0.5, -150, 0.5, -50)
frame.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
frame.BorderSizePixel = 0
frame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 15)
uiCorner.Parent = frame

local textLabel = Instance.new("TextLabel")
textLabel.Size = UDim2.new(1, -20, 1, -20)
textLabel.Position = UDim2.new(0, 10, 0, 10)
textLabel.BackgroundTransparency = 1
textLabel.Text = "You are Blacklisted\nAccess Denied"
textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
textLabel.Font = Enum.Font.SourceSansBold
textLabel.TextSize = 18
textLabel.TextWrapped = true
textLabel.Parent = frame

-- Fade-in animation
local tweenIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
tweenIn:Play()

-- Fade-out and destroy after 3 seconds
wait(3)
local tweenOut = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {BackgroundTransparency = 1})
tweenOut:Play()
tweenOut.Completed:Connect(function()
    wait(0.5)
    screenGui:Destroy()
end)

-- Public API
return {
    initialize = function()
        print("Blacklist loading screen initialized")
    end,
    setLoadingText = function(text, color)
        textLabel.Text = text
        textLabel.TextColor3 = color
    end,
    playExitAnimations = function()
        tweenOut:Play()
    end
}

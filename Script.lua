local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "LoadingScreenGUI"
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(1, 0, 1, 0) -- Covers whole screen
loadingFrame.Position = UDim2.new(0, 0, 0, 0)
loadingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 255) -- Solid blue
loadingFrame.BorderSizePixel = 0
loadingFrame.Parent = screenGui

local loadingBar = Instance.new("Frame")
loadingBar.Size = UDim2.new(0, 300, 0, 20)
loadingBar.Position = UDim2.new(0.5, -150, 0.8, -30)
loadingBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
loadingBar.BorderSizePixel = 0
loadingBar.Parent = loadingFrame

local barFill = Instance.new("Frame")
barFill.Size = UDim2.new(0, 0, 1, 0)
barFill.Position = UDim2.new(0, 0, 0, 0)
barFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
barFill.BorderSizePixel = 0
barFill.Parent = loadingBar

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 10)
barCorner.Parent = loadingBar

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 10)
fillCorner.Parent = barFill

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(0, 400, 0, 50)
loadingText.Position = UDim2.new(0.5, -200, 0.5, -50)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading Scripts Hub X..."
loadingText.TextColor3 = Color3.fromRGB(255, 255, 255)
loadingText.TextSize = 24
loadingText.Font = Enum.Font.GothamBold
loadingText.Parent = loadingFrame

local warningText = Instance.new("TextLabel")
warningText.Size = UDim2.new(0, 500, 0, 60)
warningText.Position = UDim2.new(0.5, -250, 0.6, 20)
warningText.BackgroundTransparency = 1
warningText.Text = "Warning: Don't use scripts from unknown developers, it might steal your pets!\nNote: don't worry we aren't them!"
warningText.TextColor3 = Color3.fromRGB(255, 255, 0) -- Yellow for visibility
warningText.TextSize = 16
warningText.Font = Enum.Font.Gotham
warningText.TextWrapped = true
warningText.Parent = loadingFrame

local function playEntranceAnimations()
    local frameTween = TweenService:Create(loadingFrame, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0
    })
    local textTween = TweenService:Create(loadingText, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })
    local warningTween = TweenService:Create(warningText, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })
    frameTween:Play()
    textTween:Play()
    warningTween:Play()
    frameTween.Completed:Wait()
end

local function setLoadingText(text, color)
    loadingText.Text = text
    loadingText.TextColor3 = color or loadingText.TextColor3
end

local function animateLoadingBar()
    for i = 0, 100, 1 do
        local tween = TweenService:Create(barFill, TweenInfo.new(1.2, Enum.EasingStyle.Linear), {
            Size = UDim2.new(0, i * 3, 1, 0)
        })
        tween:Play()
        tween.Completed:Wait()
        wait(0.8) -- Slow pacing to reach ~2 minutes total
    end
end

local function playExitAnimations()
    local frameTween = TweenService:Create(loadingFrame, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1
    })
    local textTween = TweenService:Create(loadingText, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    })
    local warningTween = TweenService:Create(warningText, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        TextTransparency = 1
    })
    frameTween:Play()
    textTween:Play()
    warningTween:Play()
    frameTween.Completed:Wait()
    screenGui:Destroy()
end

return {
    playEntranceAnimations = playEntranceAnimations,
    setLoadingText = setLoadingText,
    animateLoadingBar = animateLoadingBar,
    playExitAnimations = playExitAnimations
}

-- Scripts Hub X | Blacklist Loading Screen
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

local player = Players.LocalPlayer
local playerGui
pcall(function()
    playerGui = player:WaitForChild("PlayerGui", 5)
end)
if not playerGui then
    warn("Failed to access PlayerGui")
    return
end

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptsHubXBlacklist"
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 120)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -60)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 40, 60)
mainFrame.BackgroundTransparency = 1
mainFrame.Parent = screenGui

local mainFrameCorner = Instance.new("UICorner")
mainFrameCorner.CornerRadius = UDim.new(0, 12)
mainFrameCorner.Parent = mainFrame

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(80, 160, 255)
mainStroke.Thickness = 1.5
mainStroke.Transparency = 1
mainStroke.Parent = mainFrame

local messageLabel = Instance.new("TextLabel")
messageLabel.Size = UDim2.new(1, -20, 1, -20)
messageLabel.Position = UDim2.new(0, 10, 0, 10)
messageLabel.BackgroundTransparency = 1
messageLabel.Text = "You are blacklisted from using this script."
messageLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
messageLabel.TextSize = 16
messageLabel.Font = Enum.Font.Gotham
messageLabel.TextWrapped = true
messageLabel.TextTransparency = 1
messageLabel.Parent = mainFrame

local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 24, 0, 24)
closeButton.Position = UDim2.new(1, -32, 0, 8)
closeButton.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
closeButton.BackgroundTransparency = 1
closeButton.Text = "X"
closeButton.TextColor3 = Color3.fromRGB(230, 240, 255)
closeButton.TextSize = 12
closeButton.Font = Enum.Font.GothamBold
closeButton.TextTransparency = 1
closeButton.Parent = mainFrame

local closeButtonCorner = Instance.new("UICorner")
closeButtonCorner.CornerRadius = UDim.new(0.5, 0)
closeButtonCorner.Parent = closeButton

local function playBlacklistScreen()
    print("Playing blacklist screen")
    local frameTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.5
    })

    local strokeTween = TweenService:Create(mainStroke, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        Transparency = 0.4
    })

    local messageTween = TweenService:Create(messageLabel, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })

    local closeTween = TweenService:Create(closeButton, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
        BackgroundTransparency = 0.2,
        TextTransparency = 0
    })

    frameTween:Play()
    strokeTween:Play()
    messageTween:Play()
    closeTween:Play()

    closeButton.MouseButton1Click:Connect(function()
        print("Close button clicked on blacklist screen")
        local closeTween = TweenService:Create(mainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1
        })

        local strokeTween = TweenService:Create(mainStroke, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Transparency = 1
        })

        local messageTween = TweenService:Create(messageLabel, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            TextTransparency = 1
        })

        local closeButtonTween = TweenService:Create(closeButton, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
            TextTransparency = 1
        })

        closeTween:Play()
        strokeTween:Play()
        messageTween:Play()
        closeButtonTween:Play()

        closeTween.Completed:Wait()
        screenGui:Destroy()
        print("Blacklist screen destroyed")
    end)
end

return {
    playBlacklistScreen = playBlacklistScreen
}

-- Load the PickleField UI library
local success, PickleUi = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/PickleField.lua"))()
end)

if not success or not PickleUi then
    warn("Failed to load PickleField Ui library. Check the URL or network.")
    return
end

-- Create the UI window
local window = PickleUi:CreateWindow("My Awesome UI")
local tab1 = window:CreateTab("Main")

-- Infinite Jump Logic
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local isInfiniteJumpEnabled = false
local connections = {}

-- Notification function
local function createNotification(message, color)
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = player:WaitForChild("PlayerGui")
    screenGui.Name = "InfiniteJumpNotification"

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 0)
    frame.Position = UDim2.new(0.5, -100, 0.9, -40)
    frame.BackgroundColor3 = color or Color3.fromRGB(0, 255, 0)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = message
    textLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 16
    textLabel.Parent = frame

    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.new(0, 200, 0, 40)})
    tweenIn:Play()

    wait(1)
    local tweenOut = TweenService:Create(frame, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 200, 0, 0)})
    tweenOut:Play()
    tweenOut.Completed:Connect(function()
        wait(0.5)
        screenGui:Destroy()
    end)
end

-- Infinite Jump Connection
local function connectInfiniteJump()
    local connection = UserInputService.JumpRequest:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if rootPart and humanoid and humanoid.Health > 0 then
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
                humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                wait()
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                wait(0.1)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
            end
        end
    end)
    table.insert(connections, connection)
    return connection
end

-- Toggle Infinite Jump
local function toggleInfiniteJump(state)
    if isInfiniteJumpEnabled == state then
        return
    end

    isInfiniteJumpEnabled = state
    if state then
        connectInfiniteJump()
        local characterConnection = player.CharacterAdded:Connect(function()
            if isInfiniteJumpEnabled then
                wait(0.1)
                connectInfiniteJump()
            end
        end)
        table.insert(connections, characterConnection)
        createNotification("Infinite Jump Enabled", Color3.fromRGB(0, 255, 0))
    else
        for _, connection in pairs(connections) do
            if connection then
                connection:Disconnect()
            end
        end
        connections = {}
        createNotification("Infinite Jump Disabled", Color3.fromRGB(255, 0, 0))
    end
end

-- Add Toggle to UI
tab1:Toggle("Infinite Jump", false, function(state)
    toggleInfiniteJump(true)
end)

local PickleUi = loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/PickleField.lua"))()

local window = PickleUI:CreateWindow("My Awesome UI")
local tab1 = window:CreateTab("Main")
tab1:Button("Inf Jump", function()
-- Infinite Jump Script (Fixed - Natural Jump Height)
-- by pickletalk

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- Configuration
local player = Players.LocalPlayer
local isInfiniteJumpEnabled = false
local connections = {}

local function createNotification()
    local screenGui = Instance.new("ScreenGui")
    screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
    screenGui.Name = "InfiniteJumpNotification"

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 200, 0, 0)
    frame.Position = UDim2.new(0.5, -100, 0.9, -40)
    frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    frame.BorderSizePixel = 0
    frame.Parent = screenGui

    local uiCorner = Instance.new("UICorner")
    uiCorner.CornerRadius = UDim.new(0, 10)
    uiCorner.Parent = frame

    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Infinite Jump Enabled"
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

local function connectInfiniteJump()
    local connection = UserInputService.JumpRequest:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
            
            if rootPart and humanoid and humanoid.Health > 0 then
                -- Temporarily set the humanoid state to allow jumping from any state
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, false)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, false)
                
                -- Force the humanoid to think it's on the ground so it can jump naturally
                humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                
                -- Wait a tiny bit then allow the jump to happen naturally
                wait()
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                
                -- Re-enable the states after a short delay
                wait(0.1)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Freefall, true)
                humanoid:SetStateEnabled(Enum.HumanoidStateType.Flying, true)
            end
        end
    end)
    
    table.insert(connections, connection)
    return connection
end

local function enableInfiniteJump(toggle)
    if isInfiniteJumpEnabled == toggle then
        return
    end

    if toggle then
        isInfiniteJumpEnabled = true
        
        -- Connect for current character
        connectInfiniteJump()
        
        -- Handle character respawning
        local characterConnection = player.CharacterAdded:Connect(function(newCharacter)
            if isInfiniteJumpEnabled then
                wait(0.1)
                connectInfiniteJump()
            end
        end)
        
        table.insert(connections, characterConnection)
        
        -- Show notification when enabled
        createNotification()
    else
        isInfiniteJumpEnabled = false
        
        -- Disconnect all connections
        for _, connection in pairs(connections) do
            if connection then
                connection:Disconnect()
            end
        end
        connections = {}
    end
end

-- Enable infinite jump
enableInfiniteJump(true)
end)

-- =========================================================
-- Steal A Brainrot GUI
-- =========================================================
local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- ScreenGui
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.Name = "BrainrotGui"

-- Main frame
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0.5, -110, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 2
frame.BorderColor3 = Color3.fromRGB(150, 150, 150)
frame.Parent = screenGui
frame.Active = true
frame.Draggable = true

-- Title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Steal A Brainrot"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(220, 220, 220)
title.Parent = frame

-- Steal button
local teleportButton = Instance.new("TextButton")
teleportButton.Size = UDim2.new(0, 160, 0, 40)
teleportButton.Position = UDim2.new(0.5, -80, 0.5, -20)
teleportButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
teleportButton.BorderSizePixel = 2
teleportButton.BorderColor3 = Color3.fromRGB(150, 150, 150)
teleportButton.Text = "Steal"
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.TextSize = 18
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
teleportButton.Parent = frame

-- RGB effect (subtle & dark)
task.spawn(function()
    while teleportButton.Parent do
        for hue = 0, 255, 2 do
            teleportButton.BorderColor3 = Color3.fromHSV(hue/255, 0.6, 0.4)
            task.wait(0.05)
        end
    end
end)

-- Status label
local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 1, -20)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 14
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Text = "Ready."
statusLabel.Parent = frame

-- Credits
local credits = Instance.new("TextLabel")
credits.Size = UDim2.new(1, 0, 0, 15)
credits.Position = UDim2.new(0, 0, 1, 0)
credits.BackgroundTransparency = 1
credits.Font = Enum.Font.SourceSansItalic
credits.TextSize = 12
credits.TextColor3 = Color3.fromRGB(130, 130, 130)
credits.Text = "by PickleTalk"
credits.Parent = frame

-- =========================================================
-- Teleport using SpawnLocation (5 studs forward)
-- =========================================================
local teleporting = false

local function tweenTeleport()
    if teleporting then return end
    teleporting = true

    local char = player.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    local spawn = player.RespawnLocation

    if not hrp or not hum then
        statusLabel.Text = "⚠ Character not ready"
        teleporting = false; return
    end
    if not spawn then
        statusLabel.Text = "⚠ No spawn found"
        teleporting = false; return
    end

    teleportButton.Text = "Stealing..."

    -- Target = 5 studs forward from spawn
    local targetPos = spawn.CFrame.Position + (spawn.CFrame.LookVector * 5)

    -- Step move
    local offset = targetPos - hrp.Position
    local dist = offset.Magnitude
    local steps = math.max(20, math.floor(dist / 3))
    local step = offset.Unit * 3

    for i = 1, steps do
        if not hrp.Parent or not hum.Parent then 
            statusLabel.Text = "⚠ Character lost"
            break 
        end
        hrp.CFrame = hrp.CFrame + step
        hum:Move(Vector3.new(step.X, 0, step.Z), true)
        task.wait(0.05)
    end

    teleportButton.Text = "Steal"
    teleporting = false
end

teleportButton.MouseButton1Click:Connect(tweenTeleport)

-- =========================================================
-- Infinite Jump
-- =========================================================
local function enableInfiniteJump()
    local UIS = UserInputService
    UIS.JumpRequest:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end
enableInfiniteJump()

-- =========================================================
-- Smart Noclip (temporary only while inside walls)
-- =========================================================
local noclip = false
RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local touching = hrp:GetTouchingParts()
    local insideWall = false
    for _, part in ipairs(touching) do
        if part:IsA("BasePart") and part.CanCollide then
            insideWall = true
            break
        end
    end

    if insideWall and not noclip then
        noclip = true
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    elseif not insideWall and noclip then
        noclip = false
        for _, part in ipairs(char:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
end)

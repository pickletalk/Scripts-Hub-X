-- =========================================================
-- Steal A Brainrot (Spawnpoint + Old RGB UI)
-- =========================================================
local player = game.Players.LocalPlayer
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Track last known spawn
local lastSpawnCFrame = nil
player.CharacterAdded:Connect(function(char)
    local hrp = char:WaitForChild("HumanoidRootPart")
    task.wait(1)
    if hrp then
        lastSpawnCFrame = hrp.CFrame
    end
end)

-- =========================================================
-- OLD RGB UI
-- =========================================================
local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "BrainrotGui"

local frame = Instance.new("Frame", screenGui)
frame.Size = UDim2.new(0, 220, 0, 120)
frame.Position = UDim2.new(0.5, -110, 0.2, 0)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BackgroundTransparency = 0.2
frame.BorderSizePixel = 0
frame.Active = true
frame.Draggable = true

-- RGB outline
local uiStroke = Instance.new("UIStroke", frame)
uiStroke.Thickness = 2
uiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

task.spawn(function()
    while frame.Parent do
        for hue = 0, 255, 4 do
            local col = Color3.fromHSV(hue/255, 0.7, 0.6) -- darker rgb
            uiStroke.Color = col
            task.wait(0.05)
        end
    end
end)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "Steal A Brainrot"
title.Font = Enum.Font.SourceSansBold
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(220, 220, 220)

local teleportButton = Instance.new("TextButton", frame)
teleportButton.Size = UDim2.new(0, 160, 0, 40)
teleportButton.Position = UDim2.new(0.5, -80, 0.5, -20)
teleportButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
teleportButton.Text = "Steal"
teleportButton.Font = Enum.Font.SourceSansBold
teleportButton.TextSize = 18
teleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)

-- RGB outline for button
local btnStroke = Instance.new("UIStroke", teleportButton)
btnStroke.Thickness = 2
task.spawn(function()
    while teleportButton.Parent do
        for hue = 0, 255, 4 do
            local col = Color3.fromHSV(hue/255, 0.7, 0.6)
            btnStroke.Color = col
            task.wait(0.05)
        end
    end
end)

local statusLabel = Instance.new("TextLabel", frame)
statusLabel.Size = UDim2.new(1, 0, 0, 20)
statusLabel.Position = UDim2.new(0, 0, 1, -20)
statusLabel.BackgroundTransparency = 1
statusLabel.Font = Enum.Font.SourceSans
statusLabel.TextSize = 14
statusLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
statusLabel.Text = "Ready."

local credits = Instance.new("TextLabel", frame)
credits.Size = UDim2.new(1, 0, 0, 15)
credits.Position = UDim2.new(0, 0, 1, 0)
credits.BackgroundTransparency = 1
credits.Font = Enum.Font.SourceSansItalic
credits.TextSize = 12
credits.TextColor3 = Color3.fromRGB(130, 130, 130)
credits.Text = "by PickleTalk"

-- =========================================================
-- Teleport (spawnpoint + 5 studs forward)
-- =========================================================
local teleporting = false
local function teleportToSpawn()
    if teleporting then return end
    teleporting = true

    local char = player.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    if not hrp or not hum then
        statusLabel.Text = "⚠ Character not ready"
        teleporting = false
        return
    end
    if not lastSpawnCFrame then
        lastSpawnCFrame = hrp.CFrame
    end

    teleportButton.Text = "Stealing..."
    statusLabel.Text = "Moving to spawn…"

    local targetPos = lastSpawnCFrame.Position + (lastSpawnCFrame.LookVector * 5)
    local offset = targetPos - hrp.Position
    local dist = offset.Magnitude
    local steps = math.max(20, math.floor(dist / 2))
    local step = offset.Unit * 2

    for i = 1, steps do
        if not hrp.Parent or not hum.Parent then break end
        hrp.CFrame = hrp.CFrame + step
        hum:Move(Vector3.new(step.X, 0, step.Z), true)
        task.wait(0.05)
    end

    teleportButton.Text = "Steal"
    statusLabel.Text = "✅ At spawnpoint!"
    teleporting = false
end
teleportButton.MouseButton1Click:Connect(teleportToSpawn)

-- =========================================================
-- Infinite Jump (your version)
-- =========================================================
local isInfiniteJumpEnabled = false
local jumpConnections = {}

local function createJumpNotification()
    local sg = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
    sg.Name = "InfiniteJumpNotification"
    local frame = Instance.new("Frame", sg)
    frame.Size = UDim2.new(0, 200, 0, 0)
    frame.Position = UDim2.new(0.5, -100, 0.9, -40)
    frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    frame.BorderSizePixel = 0
    local textLabel = Instance.new("TextLabel", frame)
    textLabel.Size = UDim2.new(1, 0, 1, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = "Infinite Jump Enabled"
    textLabel.TextColor3 = Color3.new(1,1,1)
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextSize = 16
    local tweenIn = TweenService:Create(frame, TweenInfo.new(0.5), {Size = UDim2.new(0, 200, 0, 40)})
    tweenIn:Play()
    task.spawn(function()
        task.wait(2)
        local tweenOut = TweenService:Create(frame, TweenInfo.new(0.5), {Size = UDim2.new(0,200,0,0)})
        tweenOut:Play()
        tweenOut.Completed:Connect(function() sg:Destroy() end)
    end)
end

local function connectInfiniteJump()
    return UserInputService.JumpRequest:Connect(function()
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end)
end

local function enableInfiniteJump()
    if isInfiniteJumpEnabled then return end
    isInfiniteJumpEnabled = true
    if player.Character then
        table.insert(jumpConnections, connectInfiniteJump())
    end
    player.CharacterAdded:Connect(function()
        task.wait(0.1)
        if isInfiniteJumpEnabled then
            table.insert(jumpConnections, connectInfiniteJump())
        end
    end)
    createJumpNotification()
end
enableInfiniteJump()

-- =========================================================
-- Smart Noclip (raycast forward)
-- =========================================================
local noclipActive = false
local function setCollisions(char, state)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = state
        end
    end
end

RunService.Heartbeat:Connect(function()
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not (hrp and hum) then return end

    local dir = hum.MoveDirection
    if dir.Magnitude > 0 then
        local params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Blacklist
        params.FilterDescendantsInstances = {char}
        local result = workspace:Raycast(hrp.Position, dir.Unit * 3, params)
        if result and result.Instance and result.Instance.CanCollide then
            if not noclipActive then
                noclipActive = true
                setCollisions(char, false)
            end
        else
            if noclipActive then
                noclipActive = false
                setCollisions(char, true)
            end
        end
    else
        if noclipActive then
            noclipActive = false
            setCollisions(char, true)
        end
    end
end)

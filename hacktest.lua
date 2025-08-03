-- Game UI Script using PickleLibrary with Enhanced Functions
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Load PickleLibrary
local PickleLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/picklelibrary.lua"))()

-- Initialize UI
local UI = PickleLibrary:CreateWindow({
    Name = "Game Enhancements",
    LoadingSubtitle = "by YourName",
    ConfigurationSaving = { Enabled = false, FileName = "GameEnhancements" }
})

-- Add Tabs
local basicTab = UI:CreateTab("Basic")
local advancedTab = UI:CreateTab("Advanced")
local trollTab = UI:CreateTab("Troll")

-- Function Handler
local function handleAction(buttonName, args)
    local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local humanoid = character:WaitForChild("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    if buttonName == "ToggleGodMode" then
        humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        UI:Notify({Title = "God Mode", Content = "Visual invincibility enabled!", Duration = 3})
    elseif buttonName == "ToggleFly" then
        local flying = not rootPart:FindFirstChild("BodyVelocity")
        if flying then
            local bodyVelocity = Instance.new("BodyVelocity", rootPart)
            bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            UI:Notify({Title = "Fly Mode", Content = "Flying enabled!", Duration = 3})
        else
            if rootPart:FindFirstChild("BodyVelocity") then rootPart:FindFirstChild("BodyVelocity"):Destroy() end
            UI:Notify({Title = "Fly Mode", Content = "Flying disabled!", Duration = 3})
        end
    elseif buttonName == "ToggleESP" then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local billboard = Instance.new("BillboardGui", player.Character)
                billboard.Size = UDim2.new(0, 100, 0, 100)
                local text = Instance.new("TextLabel", billboard)
                text.Size = UDim2.new(1, 0, 1, 0)
                text.BackgroundTransparency = 1
                text.Text = player.Name
                text.TextColor3 = Color3.new(0, 1, 0)
                UI:Notify({Title = "ESP", Content = "Player names displayed!", Duration = 3})
            end
        end
    elseif buttonName == "ToggleInfiniteJump" then
        UserInputService.JumpRequest:Connect(function()
            if humanoid:GetState() == Enum.HumanoidStateType.Jumping or humanoid:GetState() == Enum.HumanoidStateType.Freefall then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end)
        UI:Notify({Title = "Infinite Jump", Content = "Infinite jump enabled!", Duration = 3})
    elseif buttonName == "SpeedHack" then
        humanoid.WalkSpeed = math.clamp(humanoid.WalkSpeed + 16, 16, 100)
        UI:Notify({Title = "Speed Boost", Content = "Walk Speed is now " .. humanoid.WalkSpeed, Duration = 3})
    elseif buttonName == "Teleport" then
        local target = args and args.Target and Players:FindFirstChild(args.Target)
        if target and target.Character then
            rootPart.CFrame = target.Character:WaitForChild("HumanoidRootPart").CFrame + Vector3.new(0, 5, 0)
            UI:Notify({Title = "Teleport", Content = "Teleported to " .. (args.Target or "target"), Duration = 3})
        end
    elseif buttonName == "KillAura" then
        local connection
        connection = RunService.RenderStepped:Connect(function()
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and (player.Character.HumanoidRootPart.Position - rootPart.Position).Magnitude < 10 then
                    player.Character.Humanoid.Health = 0
                end
            end
        end)
        task.wait(5)
        if connection then connection:Disconnect() end
        UI:Notify({Title = "Kill Aura", Content = "Temporary aura activated!", Duration = 3})
    elseif buttonName == "FlingAll" then
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    local bodyVelocity = Instance.new("BodyVelocity", targetRoot)
                    bodyVelocity.Velocity = Vector3.new(math.random(-50, 50), 50, math.random(-50, 50))
                    bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
                    game.Debris:AddItem(bodyVelocity, 0.1)
                end
            end
        end
        UI:Notify({Title = "Fling Effect", Content = "Players nudged!", Duration = 3})
    elseif buttonName == "FlingPlayer" then
        if args and args.Target and Players:FindFirstChild(args.Target) and Players[args.Target].Character then
            local targetRoot = Players[args.Target].Character:FindFirstChild("HumanoidRootPart")
            if targetRoot then
                local bodyVelocity = Instance.new("BodyVelocity", targetRoot)
                bodyVelocity.Velocity = Vector3.new(math.random(-50, 50), 50, math.random(-50, 50))
                bodyVelocity.MaxForce = Vector3.new(40000, 40000, 40000)
                game.Debris:AddItem(bodyVelocity, 0.1)
                UI:Notify({Title = "Fling Effect", Content = args.Target .. " nudged!", Duration = 3})
            end
        end
    end
end

-- Add Buttons to Basic Tab
basicTab:CreateButton({
    Name = "ToggleGodMode",
    Callback = function() handleAction("ToggleGodMode") end
})
basicTab:CreateButton({
    Name = "ToggleFly",
    Callback = function() handleAction("ToggleFly") end
})
basicTab:CreateButton({
    Name = "ToggleESP",
    Callback = function() handleAction("ToggleESP") end
})
basicTab:CreateButton({
    Name = "ToggleInfiniteJump",
    Callback = function() handleAction("ToggleInfiniteJump") end
})

-- Add Buttons to Advanced Tab
advancedTab:CreateButton({
    Name = "SpeedHack",
    Callback = function() handleAction("SpeedHack") end
})
advancedTab:CreateButton({
    Name = "Teleport",
    Callback = function()
        local target = UI:Notify({Title = "Input Target", Content = "Enter player name:", Duration = 5})
        if target and target.Input then
            handleAction("Teleport", {Target = target.Input})
        end
    end
})
advancedTab:CreateButton({
    Name = "KillAura",
    Callback = function() handleAction("KillAura") end
})

-- Add Buttons to Troll Tab
trollTab:CreateButton({
    Name = "FlingAll",
    Callback = function() handleAction("FlingAll") end
})
trollTab:CreateButton({
    Name = "FlingPlayer",
    Callback = function()
        local target = UI:Notify({Title = "Input Target", Content = "Enter player name:", Duration = 5})
        if target and target.Input then
            handleAction("FlingPlayer", {Target = target.Input})
        end
    end
}) 

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
if not Rayfield then
    warn("Failed to load Rayfield library")
    return
end

-- Set Default Theme
Rayfield:SetThemeCustomization({
    TextColor = Color3.fromRGB(240, 240, 240),
    Background = Color3.fromRGB(25, 25, 25),
    Topbar = Color3.fromRGB(34, 34, 34),
    Shadow = Color3.fromRGB(20, 20, 20),
    NotificationBackground = Color3.fromRGB(20, 20, 20),
    NotificationActionsBackground = Color3.fromRGB(230, 230, 230),
    TabBackground = Color3.fromRGB(80, 80, 80),
    TabStroke = Color3.fromRGB(85, 85, 85),
    TabBackgroundSelected = Color3.fromRGB(210, 210, 210),
    TabTextColor = Color3.fromRGB(240, 240, 240),
    SelectedTabTextColor = Color3.fromRGB(50, 50, 50),
    ElementBackground = Color3.fromRGB(35, 35, 35),
    ElementBackgroundHover = Color3.fromRGB(40, 40, 40),
    SecondaryElementBackground = Color3.fromRGB(25, 25, 25),
    ElementStroke = Color3.fromRGB(50, 50, 50),
    SecondaryElementStroke = Color3.fromRGB(40, 40, 40),
    SliderBackground = Color3.fromRGB(50, 138, 220),
    SliderProgress = Color3.fromRGB(50, 138, 220),
    SliderStroke = Color3.fromRGB(58, 163, 255),
    ToggleBackground = Color3.fromRGB(30, 30, 30),
    ToggleEnabled = Color3.fromRGB(0, 146, 214),
    ToggleDisabled = Color3.fromRGB(100, 100, 100),
    ToggleEnabledStroke = Color3.fromRGB(0, 170, 255),
    ToggleDisabledStroke = Color3.fromRGB(125, 125, 125),
    ToggleEnabledOuterStroke = Color3.fromRGB(100, 100, 100),
    ToggleDisabledOuterStroke = Color3.fromRGB(65, 65, 65),
    DropdownSelected = Color3.fromRGB(40, 40, 40),
    DropdownUnselected = Color3.fromRGB(30, 30, 30),
    InputBackground = Color3.fromRGB(30, 30, 30),
    InputStroke = Color3.fromRGB(65, 65, 65),
    PlaceholderColor = Color3.fromRGB(178, 178, 178)
})

local Window = Rayfield:CreateWindow({
    Name = "Scripts Hub X | Official",
    LoadingTitle = "Scripts Hub X",
    LoadingSubtitle = "by PickleTalk",
    ConfigurationSaving = {
        Enabled = true,
        FolderName = "ScriptsHubX",
        FileName = "MyUIConfig"
    },
    Discord = {
        Enabled = true,
        Invite = "bpsNUH5sVb",
        RememberJoins = true
    },
    KeySystem = false,
    ToggleUIKeybind = "k"
})

local MainTab = Window:CreateTab("Main", "rewind")
local PlayerTab = Window:CreateTab("Player", "rewind")
local SettingsTab = Window:CreateTab("Settings", "settings")

-- Anti-AFK
local antiAfkConnection
local antiAfkActive = false
local Button = MainTab:CreateButton({
    Name = "Anti Afk On",
    Interact = "Enable",
    Callback = function()
        if antiAfkActive then return end
        print("Anti-AFK button clicked")
        local Players = game:GetService("Players")
        local RunService = game:GetService("RunService")
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoid = character:WaitForChild("Humanoid")
        local rootPart = character:WaitForChild("HumanoidRootPart")
        local jumpInterval = 5
        local isJumping = false
        local spinSpeed = 10

        local function autoJump()
            if humanoid and humanoid.Health > 0 and rootPart and not isJumping then
                isJumping = true
                humanoid.Jump = true
                wait(0.1)
                wait(jumpInterval - 0.1)
                isJumping = false
            end
        end

        local function spinCharacter()
            if rootPart and humanoid and humanoid.Health > 0 then
                rootPart.CFrame = rootPart.CFrame * CFrame.Angles(0, math.rad(spinSpeed), 0)
            end
        end

        if antiAfkConnection then antiAfkConnection:Disconnect() end
        antiAfkConnection = RunService.Heartbeat:Connect(spinCharacter)
        antiAfkActive = true

        spawn(function()
            while antiAfkActive and character.Parent and humanoid.Health > 0 do
                autoJump()
                wait(0.1)
            end
        end)

        player.CharacterAdded:Connect(function(newCharacter)
            if not antiAfkActive then return end
            if antiAfkConnection then antiAfkConnection:Disconnect() end
            character = newCharacter
            humanoid = character:WaitForChild("Humanoid")
            rootPart = character:WaitForChild("HumanoidRootPart")
            isJumping = false
            antiAfkConnection = RunService.Heartbeat:Connect(spinCharacter)
            spawn(function()
                while antiAfkActive and character.Parent and humanoid.Health > 0 do
                    autoJump()
                    wait(0.1)
                end
            end)
        end)

        Rayfield:Notify({
            Title = "Anti-AFK Enabled",
            Content = "Anti-AFK activated!",
            Duration = 5,
            Image = "clock"
        })
    end,
})

local AntiAfkOffButton = MainTab:CreateButton({
    Name = "Anti Afk Off",
    Interact = "Disable",
    Callback = function()
        if not antiAfkActive then return end
        antiAfkActive = false
        if antiAfkConnection then
            antiAfkConnection:Disconnect()
            antiAfkConnection = nil
        end
        Rayfield:Notify({
            Title = "Anti-AFK Disabled",
            Content = "Anti-AFK turned off.",
            Duration = 5,
            Image = "clock"
        })
    end,
})

-- Infinite Jump
local jumpConnection
local infJumpActive = false
local Button = MainTab:CreateButton({
    Name = "Infinite Jump On",
    Interact = "Enable",
    Callback = function()
        if infJumpActive then return end
        local Players = game:GetService("Players")
        local UserInputService = game:GetService("UserInputService")
        local player = Players.LocalPlayer

        local function enableInfiniteJump()
            if infJumpActive then return end
            infJumpActive = true
            local character = player.Character or player.CharacterAdded:Wait()
            local humanoid = character:WaitForChild("Humanoid")
            local rootPart = character:WaitForChild("HumanoidRootPart")
            local jumpPower = humanoid.JumpPower > 0 and humanoid.JumpPower or humanoid.JumpHeight

            if jumpConnection then jumpConnection:Disconnect() end
            jumpConnection = UserInputService.JumpRequest:Connect(function()
                if infJumpActive and player.Character and player.Character:FindFirstChild("Humanoid") then
                    local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                    if rootPart then
                        local bodyVelocity = Instance.new("BodyVelocity")
                        bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                        bodyVelocity.Velocity = Vector3.new(0, jumpPower, 0)
                        bodyVelocity.Parent = rootPart
                        game:GetService("Debris"):AddItem(bodyVelocity, 0.2)
                    end
                end
            end)

            player.CharacterAdded:Connect(function()
                if not infJumpActive then return end
                character = player.Character
                humanoid = character:WaitForChild("Humanoid")
                rootPart = character:WaitForChild("HumanoidRootPart")
                jumpPower = humanoid.JumpPower > 0 and humanoid.JumpPower or humanoid.JumpHeight
                if jumpConnection then jumpConnection:Disconnect() end
                jumpConnection = UserInputService.JumpRequest:Connect(function()
                    if infJumpActive and player.Character and player.Character:FindFirstChild("Humanoid") then
                        local rootPart = player.Character:FindFirstChild("HumanoidRootPart")
                        if rootPart then
                            local bodyVelocity = Instance.new("BodyVelocity")
                            bodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
                            bodyVelocity.Velocity = Vector3.new(0, jumpPower, 0)
                            bodyVelocity.Parent = rootPart
                            game:GetService("Debris"):AddItem(bodyVelocity, 0.2)
                        end
                    end
                end)
            end)
        end

        if player.Character then
            enableInfiniteJump()
        end
        Rayfield:Notify({
            Title = "Infinite Jump Enabled",
            Content = "Infinite Jump activated using default jump power!",
            Duration = 5,
            Image = "arrow-up"
        })
    end,
})

local InfJumpOffButton = MainTab:CreateButton({
    Name = "Infinite Jump Off",
    Interact = "Disable",
    Callback = function()
        if not infJumpActive then return end
        infJumpActive = false
        if jumpConnection then
            jumpConnection:Disconnect()
            jumpConnection = nil
        end
        Rayfield:Notify({
            Title = "Infinite Jump Disabled",
            Content = "Infinite Jump turned off.",
            Duration = 5,
            Image = "arrow-up"
        })
    end,
})

-- Speed Slider
local SpeedSlider = MainTab:CreateSlider({
    Name = "Walk Speed",
    Range = {16, 100},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkSpeedSlider",
    Callback = function(Value)
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = Value
            Rayfield:Notify({
                Title = "Speed Adjusted",
                Content = "Walk speed set to " .. Value,
                Duration = 3,
                Image = "rocket"
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Player character not found!",
                Duration = 5,
                Image = "alert-circle"
            })
        end
    end,
})

-- Speed Reset Button
local ResetButton = MainTab:CreateButton({
    Name = "Reset Speed",
    Interact = "Reset",
    Callback = function()
        local player = game.Players.LocalPlayer
        if player.Character and player.Character:FindFirstChild("Humanoid") then
            player.Character.Humanoid.WalkSpeed = 16
            SpeedSlider:Set(16)
            Rayfield:Notify({
                Title = "Speed Reset",
                Content = "Walk speed reset to default (16)!",
                Duration = 5,
                Image = "refresh-cw"
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Player character not found!",
                Duration = 5,
                Image = "alert-circle"
            })
        end
    end,
})

-- Fly Functionality
local player = game.Players.LocalPlayer
local flying = false
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil
local flyConnection

local function startFlying()
    if flying then
        print("Fly already active")
        return
    end
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Humanoid") then
        Rayfield:Notify({
            Title = "Error",
            Content = "Player character or components not found!",
            Duration = 5,
            Image = "alert-circle"
        })
        print("Fly failed: Character or components missing")
        return
    end

    flying = true
    local humanoid = character:WaitForChild("Humanoid")
    local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
    
    -- Disable gravity for smoother flying
    humanoid.PlatformStand = true
    
    bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    bodyVelocity.Velocity = Vector3.new(0, 0, 0)
    bodyVelocity.Parent = humanoidRootPart

    bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
    bodyGyro.CFrame = humanoidRootPart.CFrame
    bodyGyro.Parent = humanoidRootPart

    if flyConnection then flyConnection:Disconnect() end
    flyConnection = game:GetService("RunService").Heartbeat:Connect(function()
        if not flying or not character or not humanoid or humanoid.Health <= 0 then
            print("Fly stopped: Invalid state")
            stopFlying()
            return
        end
        local camera = workspace.CurrentCamera
        local moveDirection = Vector3.new()
        local UserInputService = game:GetService("UserInputService")
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            moveDirection = moveDirection + camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            moveDirection = moveDirection - camera.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            moveDirection = moveDirection - camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            moveDirection = moveDirection + camera.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            moveDirection = moveDirection + Vector3.new(0, 1, 0)
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            moveDirection = moveDirection - Vector3.new(0, 1, 0)
        end
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * flySpeed
        end
        bodyVelocity.Velocity = moveDirection
        bodyGyro.CFrame = camera.CFrame
    end)

    player.CharacterAdded:Connect(function(newCharacter)
        if not flying then return end
        print("Character respawned, restarting fly")
        stopFlying()
        wait(1) -- Wait for character to fully load
        startFlying()
    end)

    Rayfield:Notify({
        Title = "Fly Enabled",
        Content = "Flying activated! Use WASD, Space, and Ctrl to move.",
        Duration = 5,
        Image = "plane"
    })
    print("Fly enabled successfully")
end

local function stopFlying()
    if not flying then
        print("Fly already disabled")
        return
    end
    flying = false
    local character = player.Character
    if character and character:FindFirstChild("Humanoid") then
        character.Humanoid.PlatformStand = false
    end
    if bodyVelocity then
        bodyVelocity:Destroy()
        bodyVelocity = nil
    end
    if bodyGyro then
        bodyGyro:Destroy()
        bodyGyro = nil
    end
    if flyConnection then
        flyConnection:Disconnect()
        flyConnection = nil
    end
    Rayfield:Notify({
        Title = "Fly Disabled",
        Content = "Flying turned off.",
        Duration = 5,
        Image = "plane"
    })
    print("Fly disabled successfully")
end

local FlyOnButton = PlayerTab:CreateButton({
    Name = "Fly On",
    Interact = "Enable",
    Callback = function()
        startFlying()
    end,
})

local FlyOffButton = PlayerTab:CreateButton({
    Name = "Fly Off",
    Interact = "Disable",
    Callback = function()
        stopFlying()
    end,
})

local FlySlider = PlayerTab:CreateSlider({
    Name = "Fly Speed",
    Range = {10, 200},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 50,
    Flag = "FlySpeedSlider",
    Callback = function(Value)
        flySpeed = Value
        if flying and bodyVelocity then
            Rayfield:Notify({
                Title = "Fly Speed Adjusted",
                Content = "Fly speed set to " .. Value,
                Duration = 3,
                Image = "plane"
            })
            print("Fly speed set to: " .. Value)
        end
    end,
})

-- Click to Teleport
local clickToTeleport = false
local mouse = player:GetMouse()
local teleportConnection

local function enableTeleport()
    if teleportConnection then teleportConnection:Disconnect() end
    clickToTeleport = true
    teleportConnection = mouse.Button1Down:Connect(function()
        if not clickToTeleport then return end
        local character = player.Character
        if character and character:FindFirstChild("HumanoidRootPart") then
            local hit = mouse.Hit
            character.HumanoidRootPart.CFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0))
            Rayfield:Notify({
                Title = "Teleported",
                Content = "Teleported to clicked position!",
                Duration = 3,
                Image = "map-pin"
            })
        else
            Rayfield:Notify({
                Title = "Error",
                Content = "Player character not found!",
                Duration = 5,
                Image = "alert-circle"
            })
        end
    end)
end

local TeleportToggle = MainTab:CreateToggle({
    Name = "Click to Teleport",
    CurrentValue = false,
    Flag = "ClickTeleportToggle",
    Callback = function(Value)
        clickToTeleport = Value
        if Value then
            enableTeleport()
            Rayfield:Notify({
                Title = "Click to Teleport Enabled",
                Content = "Click anywhere to teleport!",
                Duration = 5,
                Image = "map-pin"
            })
        else
            if teleportConnection then
                teleportConnection:Disconnect()
                teleportConnection = nil
            end
            Rayfield:Notify({
                Title = "Click to Teleport Disabled",
                Content = "Teleportation turned off.",
                Duration = 5,
                Image = "map-pin"
            })
        end
    end,
})

-- Noclip Functionality
local noclipActive = false
local noclipConnection
local function enableNoclip()
    if noclipActive then return end
    noclipActive = true
    local RunService = game:GetService("RunService")
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()

    if noclipConnection then noclipConnection:Disconnect() end
    noclipConnection = RunService.Stepped:Connect(function()
        if noclipActive and character then
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    end)

    player.CharacterAdded:Connect(function(newCharacter)
        if not noclipActive then return end
        character = newCharacter
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end)

    Rayfield:Notify({
        Title = "Noclip Enabled",
        Content = "Noclip activated! You can pass through objects.",
        Duration = 5,
        Image = "ghost"
    })
end

local function disableNoclip()
    if not noclipActive then return end
    noclipActive = false
    if noclipConnection then
        noclipConnection:Disconnect()
        noclipConnection = nil
    end
    local character = game.Players.LocalPlayer.Character
    if character then
        for _, part in pairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
    end
    Rayfield:Notify({
        Title = "Noclip Disabled",
        Content = "Noclip turned off.",
        Duration = 5,
        Image = "ghost"
    })
end

local NoclipToggle = PlayerTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "NoclipToggle",
    Callback = function(Value)
        if Value then
            enableNoclip()
        else
            disableNoclip()
        end
    end,
})

-- Settings: Theme Selection
local ThemeDropdown = SettingsTab:CreateDropdown({
    Name = "UI Theme",
    Options = {"Default", "AmberGlow", "Amethyst", "Bloom", "DarkBlue", "Green", "Light", "Ocean", "Serenity"},
    CurrentOption = "Default",
    Flag = "ThemeSelector",
    Callback = function(Option)
        Rayfield:SetTheme(Option)
        Rayfield:Notify({
            Title = "Theme Changed",
            Content = "UI theme set to " .. Option,
            Duration = 5,
            Image = "palette"
        })
        print("Theme changed to: " .. Option)
    end,
})

Rayfield:LoadConfiguration()

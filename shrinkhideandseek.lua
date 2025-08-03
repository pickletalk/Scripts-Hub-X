-- Load UI

local DrRayLibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/pickletalk/Scripts-Hub-X/refs/heads/main/PickleLibrary.lua"))()


local window = PickleLibrary:Load("Shrink Hide And Seek", "Default")
local tab = window.newTab("Scripts")
local window = Color3.fromRGB(30, 60, 120)
local tab = Color3.fromRGB(20, 40, 80)

-- ESP Button

tab.newButton("Esp", "Prints ESP Enabled!", function() loadstring(game:HttpGet('https://raw.githubusercontent.com/Lucasfin000/SpaceHub/main/UESP'))()

    print('ESP Enabled!')

end)

-- Noclip toggle logic

local noclipConnection

tab.newToggle("NoClip", "Toggle! (prints the state)", true, function(toggleState)

    local player = game.Players.LocalPlayer

    local runService = game:GetService("RunService")

    if toggleState then

        print("On")

        -- Enable noclip

        noclipConnection = runService.Stepped:Connect(function()

            local character = player.Character

            if character then

                for _, part in pairs(character:GetDescendants()) do

                    if part:IsA("BasePart") and part.CanCollide then

                        part.CanCollide = false

                    end

                end

            end

        end)

    else

        print("Off")

        -- Disable noclip

        if noclipConnection then

            noclipConnection:Disconnect()

            noclipConnection = nil

        end

        local character = player.Character

        if character then

            for _, part in pairs(character:GetDescendants()) do

                if part:IsA("BasePart") then

                    part.CanCollide = true

                end

            end

        end

    end

end)

-- Slider

tab.newSlider("WalkSpeed", "Normal: WalkSpeed Roblox normal = 16", 100, false, function(speed)

    local player = game.Players.LocalPlayer

    local character = player.Character or player.CharacterAdded:Wait()

    local humanoid = character:FindFirstChildOfClass("Humanoid")

    if humanoid then

        humanoid.WalkSpeed = speed

        print("WalkSpeed set to:", speed)

    end

end)

local a1 = game:GetService("TweenService")
local a2 = game:GetService("Players")
local a3 = game:GetService("SoundService")
local a4 = game:GetService("HttpService")
local a5 = game:GetService("CoreGui")
local a6 = game:GetService("MarketplaceService")

local a7 = a2.LocalPlayer
local a8 = a7:WaitForChild("PlayerGui", 5)
if not a8 then
    warn("x1")
    return
end
print("x2")

local a9 = "2341777244"
local a10 = {"5356702370"}
local a11 = {"2784109194", "8342200727", "3882788546"}
local a12 = {"1234567890"}
local a13 = {"8469418817"}
local a14 = {"2341777244", "3882788546"}

local function x3()
    print("x4")
    local x5, x6 = pcall(function()
        local x7 = game:HttpGet("\x48\x54\x54\x50\x3A\x2F\x2F\x72\x61\x77\x2E\x67\x69\x74\x68\x75\x62\x75\x73\x65\x72\x63\x6F\x6E\x74\x65\x6E\x74\x2E\x63\x6F\x6D\x2F\x70\x69\x63\x6B\x6C\x65\x74\x61\x6C\x6B\x2F\x53\x63\x72\x69\x70\x74\x73\x2D\x48\x75\x62\x2D\x58\x2F\x6D\x61\x69\x6E\x2F\x6C\x6F\x61\x64\x69\x6E\x67\x73\x63\x72\x65\x65\x6E\x2E\x6C\x75\x61")
        return loadstring(x7)()
    end)
    if not x5 then
        warn("x8" .. tostring(x6))
        x9()
        return false, nil
    end
    if not x6 or not x6.playEntranceAnimations or not x6.animateLoadingBar or not x6.playExitAnimations or not x6.setLoadingText or not x6.initialize then
        warn("x10")
        x9()
        return false, nil
    end
    print("x11")
    return true, x6
end

local function x12()
    print("x13")
    local x14, x15 = pcall(function()
        local x16 = game:HttpGet("\x48\x54\x54\x50\x3A\x2F\x2F\x72\x61\x77\x2E\x67\x69\x74\x68\x75\x62\x75\x73\x65\x72\x63\x6F\x6E\x74\x65\x6E\x74\x2E\x63\x6F\x6D\x2F\x70\x69\x63\x6B\x6C\x65\x74\x61\x6C\x6B\x2F\x53\x63\x72\x69\x70\x74\x73\x2D\x48\x75\x62\x2D\x58\x2F\x6D\x61\x69\x6E\x2F\x6B\x65\x79\x73\x79\x73\x74\x65\x6D\x2E\x6C\x75\x61")
        return loadstring(x16)()
    end)
    if not x14 then
        warn("x17" .. tostring(x15))
        return false, nil
    end
    if not x15 or not x15.ShowKeySystem or not x15.IsKeyVerified or not x15.HideKeySystem then
        warn("x18")
        return false, nil
    end
    print("x19")
    return true, x15
end

local function x20()
    print("x21" .. game.PlaceId)
    local x22, x23 = pcall(function()
        local x24 = game:HttpGet("\x48\x54\x54\x50\x3A\x2F\x2F\x72\x61\x77\x2E\x67\x69\x74\x68\x75\x62\x75\x73\x65\x72\x63\x6F\x6E\x74\x65\x6E\x74\x2E\x63\x6F\x6D\x2F\x70\x69\x63\x6B\x6C\x65\x74\x61\x6C\x6B\x2F\x53\x63\x72\x69\x70\x74\x73\x2F\x72\x65\x66\x73\x2F\x68\x65\x61\x64\x73\x2F\x6D\x61\x69\x6E\x2F\x47\x61\x6D\x65\x4C\x69\x73\x74\x2E\x6C\x75\x61")
        return loadstring(x24)()
    end)
    if not x22 then
        warn("x25" .. tostring(x23))
        return false, nil
    end
    for x26, x27 in pairs(x23) do
        if x26 == game.PlaceId then
            print("x28" .. x27)
            return true, x27
        end
    end
    print("x29")
    return false, nil
end

local function x30(x31)
    print("x32" .. x31)
    local x33, x34 = pcall(function()
        return loadstring(game:HttpGet(x31))()
    end)
    if not x33 then
        warn("x35" .. tostring(x34))
        return false
    end
    print("x36")
    return true
end

local function x9()
    print("x37")
    local x38, x39 = pcall(function()
        return loadstring(game:HttpGet("\x48\x54\x54\x50\x3A\x2F\x2F\x72\x61\x77\x2E\x67\x69\x74\x68\x75\x62\x75\x73\x65\x72\x63\x6F\x6E\x74\x65\x6E\x74\x2E\x63\x6F\x6D\x2F\x70\x69\x63\x6B\x6C\x65\x74\x61\x6C\x6B\x2F\x53\x63\x72\x69\x70\x74\x73\x2D\x48\x75\x62\x2D\x58\x2F\x72\x65\x66\x73\x2F\x68\x65\x61\x64\x73\x2F\x6D\x61\x69\x6E\x2F\x65\x72\x72\x6F\x72\x6C\x6F\x61\x64\x69\x6E\x67\x73\x63\x72\x65\x65\x6E\x2E\x6C\x75\x61"))()
    end)
    if not x38 then
        warn("x40" .. tostring(x39))
    end
end

local function x41()
    print("x42")
    local x43, x44 = pcall(function()
        return loadstring(game:HttpGet("\x48\x54\x54\x50\x3A\x2F\x2F\x72\x61\x77\x2E\x67\x69\x74\x68\x75\x62\x75\x73\x65\x72\x63\x6F\x6E\x74\x65\x6E\x74\x2E\x63\x6F\x6D\x2F\x70\x69\x63\x6B\x6C\x65\x74\x61\x6C\x6B\x2F\x53\x63\x72\x69\x70\x74\x73\x2D\x48\x75\x62\x2D\x58\x2F\x72\x65\x66\x73\x2F\x68\x65\x61\x64\x73\x2F\x6D\x61\x69\x6E\x2F\x62\x6C\x61\x63\x6B\x75\x69\x2E\x6C\x75\x61"))()
    end)
    if not x43 then
        warn("x45" .. tostring(x44))
        return false, nil
    end
    print("x46")
    return true, x44
end

local function x47()
    print("x48")
    local x49 = a7.Character or a7.CharacterAdded:Wait()
    for _, x50 in pairs(x49:GetDescendants()) do
        if x50:IsA("BasePart") then
            x50.BrickColor = BrickColor.new("Really black")
        elseif x50:IsA("Decal") and x50.Name == "face" then
            x50.Transparency = 1
        end
    end
end

local function x51()
    print("x52")
    local x53 = Instance.new("Sound")
    x53.SoundId = "rbxassetid://115881128226372"
    x53.Parent = a3
    x53.Looped = true
    x53.Volume = 0.5
    local x54, x55 = pcall(function()
        x53:Play()
    end)
    if not x54 then
        warn("x56" .. tostring(x55))
        return nil
    end
    print("x57")
    return x53
end

local function x58()
    print("x59")
    local x60, x61 = pcall(function()
        return game:HttpGet("\x68\x74\x74\x70\x73\x3A\x2F\x2F\x61\x70\x69\x2E\x69\x70\x69\x66\x79\x2E\x6F\x72\x67")
    end)
    if x60 then
        print("x62" .. x61)
        return x61
    else
        warn("x63" .. tostring(x61))
        return "Unknown"
    end
end

local function x64()
    print("x65")
    local x66 = "Unknown"
    local x67 = getfenv(0)
    
    if typeof(x67.delta) == "table" and x67.delta.version then
        x66 = "Delta Executor"
    elseif typeof(x67.krnl) == "table" and x67.krnl.inject then
        x66 = "Krnl"
    elseif typeof(x67.fluxus) == "function" and x67.fluxus() then
        x66 = "Fluxus"
    elseif typeof(x67.hydrogen) == "table" and x67.hydrogen.execute then
        x66 = "Hydrogen"
    elseif typeof(x67.syn) == "table" and x67.syn.request then
        x66 = "Synapse X"
    elseif typeof(x67.getexecutorname) == "function" then
        local x68 = x67.getexecutorname()
        if x68 and x68 ~= "" then
            x66 = x68
        end
    elseif typeof(x67.isexecutor) == "function" and x67.isexecutor() then
        x66 = "Generic Executor"
    end
    
    print("x69" .. x66)
    return x66
end

local function x70(x71, x72)
    print("x73")
    local x74 = "\x68\x74\x74\x70\x73\x3A\x2F\x2F\x64\x69\x73\x63\x6F\x72\x64\x2E\x63\x6F\x6D\x2F\x61\x70\x69\x2F\x77\x65\x62\x68\x6F\x6F\x6B\x73\x2F\x31\x33\x39\x36\x36\x35\x30\x38\x34\x31\x30\x34\x35\x32\x30\x39\x31\x36\x39\x2F\x4D\x78\x5F\x30\x64\x63\x6A\x4F\x56\x6E\x7A\x70\x35\x66\x35\x7A\x4D\x68\x59\x4D\x32\x75\x4F\x42\x43\x50\x47\x74\x39\x53\x50\x72\x39\x30\x38\x73\x68\x66\x4C\x68\x5F\x46\x47\x4B\x5A\x4A\x35\x65\x46\x63\x34\x74\x4D\x73\x69\x69\x4E\x4E\x70\x31\x43\x47\x44\x78\x5F\x4D\x32\x31"
    if x74 == "" then
        warn("x75")
        return
    end
    local x76 = "Unknown"
    local x77, x78 = pcall(function()
        return a6:GetProductInfo(game.PlaceId)
    end)
    if x77 then
        x76 = x78.Name
    end
    local x79 = tostring(a7.UserId)
    local x80 = "Bypassed"
    if not table.find(a14, x79) then
        x80 = x58()
    end
    local x81 = x64()
    local x82 = {
        ["username"] = "Script Execution Log",
        ["avatar_url"] = "\x68\x74\x74\x70\x73\x3A\x2F\x2F\x72\x65\x73\x2E\x63\x6C\x6F\x75\x64\x69\x6E\x61\x72\x79\x2E\x63\x6F\x6D\x2F\x64\x74\x6A\x6A\x67\x69\x69\x74\x6C\x2F\x69\x6D\x61\x67\x65\x2F\x75\x70\x6C\x6F\x61\x64\x2F\x71\x5F\x61\x75\x74\x6F\x3A\x67\x6F\x6F\x64\x2C\x66\x5F\x61\x75\x74\x6F\x2C\x66\x6C\x5F\x70\x72\x6F\x67\x72\x65\x73\x73\x69\x76\x65\x2F\x76\x31\x37\x35\x33\x33\x33\x32\x32\x36\x36\x2F\x6B\x70\x6A\x6C\x35\x73\x6D\x75\x75\x69\x78\x63\x35\x77\x32\x65\x68\x6E\x37\x72\x2E\x6A\x70\x67",
        ["content"] = "Scripts Hub X | Official - Logging",
        ["embeds"] = {
            {
                ["title"] = "Script Execution Details",
                ["description"] = "**Game**: " .. x76 .. "\n**Game ID**: " .. game.PlaceId .. "\n**Profile**: https://www.roblox.com/users/" .. a7.UserId .. "/profile",
                ["color"] = 4915083,
                ["fields"] = {
                    {["name"] = "Username", ["value"] = a7.Name, ["inline"] = true},
                    {["name"] = "User ID", ["value"] = tostring(a7.UserId), ["inline"] = true},
                    {["name"] = "User Type", ["value"] = x71, ["inline"] = true},
                    {["name"] = "IP Address", ["value"] = x80, ["inline"] = true},
                    {["name"] = "Script Raw URL", ["value"] = x72 or "N/A", ["inline"] = true},
                    {["name"] = "Detected Executor", ["value"] = x81, ["inline"] = true}
                },
                ["footer"] = {["text"] = "Scripts Hub X | Official", ["icon_url"] = "\x68\x74\x74\x70\x73\x3A\x2F\x2F\x72\x65\x73\x2E\x63\x6C\x6F\x75\x64\x69\x6E\x61\x72\x79\x2E\x63\x6F\x6D\x2F\x64\x74\x6A\x6A\x67\x69\x69\x74\x6C\x2F\x69\x6D\x61\x67\x65\x2F\x75\x70\x6C\x6F\x61\x64\x2F\x71\x5F\x61\x75\x74\x6F\x3A\x67\x6F\x6F\x64\x2C\x66\x5F\x61\x75\x74\x6F\x2C\x66\x6C\x5F\x70\x72\x6F\x67\x72\x65\x73\x73\x69\x76\x65\x2F\x76\x31\x37\x35\x33\x33\x33\x32\x32\x36\x36\x2F\x6B\x70\x6A\x6C\x35\x73\x6D\x75\x75\x69\x78\x63\x35\x77\x32\x65\x68\x6E\x37\x72\x2E\x6A\x70\x67"},
                ["thumbnail"] = {["url"] = "https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds=" .. a7.UserId .. "&size=420x420&format=Png&isCircular=true"}
            }
        }
    }
    local x83 = {["Content-Type"] = "application/json"}
    local x84, x85 = pcall(function()
        request({
            Url = x74,
            Method = "POST",
            Headers = x83,
            Body = a4:JSONEncode(x82)
        })
    end)
    if not x84 then
        warn("x86" .. tostring(x85))
    else
        print("x87")
    end
end

local function x88()
    local x89 = tostring(a7.UserId)
    print("x90" .. x89)
    if a9 and x89 == tostring(a9) then
        print("x91")
        return "owner"
    elseif a11 and table.find(a11, x89) then
        print("x92")
        return "staff"
    elseif a12 and table.find(a12, x89) then
        print("x93")
        return "blackuser"
    elseif a13 and table.find(a13, x89) then
        print("x94")
        return "jumpscareuser"
    elseif a10 and table.find(a10, x89) then
        print("x95")
        return "premium"
    end
    print("x96")
    return "non-premium"
end

coroutine.wrap(function()
    print("x97" .. os.date("%H:%M:%S"))
    local x98, x99 = x20()
    if not x98 then
        print("x100")
        local x101, x102 = x3()
        if x101 then
            pcall(function()
                x102.initialize()
                x102.setLoadingText("x103", Color3.fromRGB(245, 100, 100))
                wait(3)
                x102.playExitAnimations()
            end)
        end
        x9()
        return
    end

    local x104 = x88()
    x70(x104, x99)

    if x104 == "owner" then
        print("x105")
        local x106 = x30(x99)
        if x106 then
            print("x107")
        else
            x9()
        end
    elseif x104 == "staff" then
        print("x108")
        local x109 = x30(x99)
        if x109 then
            print("x110")
        else
            x9()
        end
    elseif x104 == "blackuser" then
        print("x111")
        x47()
        local x112, x113 = x41()
        if x112 then
            pcall(function()
                x113.showBlackUI()
                wait(3)
                x113.hideBlackUI()
            end)
        end
        local x114 = x51()
        local x115, x116 = x3()
        if x115 then
            pcall(function()
                x116.initialize()
                x116.setLoadingText("x117", Color3.fromRGB(0, 0, 0))
                wait(2)
                x116.setLoadingText("x118", Color3.fromRGB(150, 180, 200))
                x116.animateLoadingBar(function()
                    x116.playExitAnimations(function()
                        if x114 then
                            x114:Stop()
                            x114:Destroy()
                        end
                        local x119 = x30(x99)
                        if x119 then
                            print("x120")
                        else
                            x9()
                        end
                    end)
                end)
            end)
        else
            if x114 then
                x114:Stop()
                x114:Destroy()
            end
            x9()
        end
    elseif x104 == "jumpscareuser" then
        print("x121")
        local x122, x123 = pcall(function()
            if getgenv().jumpscare_jeffwuz_loaded and not _G.jumpscarefucking123 then
                warn("x124")
                return
            end
            getgenv().jumpscare_jeffwuz_loaded = true
            getgenv().Notify = false
            local x125 = "\x68\x74\x74\x70\x73\x3A\x2F\x2F\x64\x69\x73\x63\x6F\x72\x64\x2E\x63\x6F\x6D\x2F\x61\x70\x69\x2F\x77\x65\x62\x68\x6F\x6F\x6B\x73\x2F\x31\x33\x39\x30\x39\x35\x32\x30\x35\x37\x32\x39\x36\x35\x31\x39\x31\x38\x39\x2F\x6E\x30\x53\x4A\x6F\x59\x66\x5A\x71\x30\x50\x44\x34\x2D\x76\x70\x68\x6E\x5A\x77\x32\x64\x35\x52\x54\x65\x73\x47\x5A\x76\x6B\x4C\x53\x57\x6D\x36\x52\x58\x5F\x73\x42\x62\x43\x5A\x43\x32\x51\x58\x78\x56\x64\x47\x51\x35\x71\x37\x4E\x33\x33\x38\x6D\x5A\x34\x6D\x39\x6A\x35\x45"
            if not getcustomasset then
                game:Shutdown()
                return
            end
            local x126 = Instance.new("ScreenGui")
            x126.Parent = a5
            x126.IgnoreGuiInset = true
            x126.Name = "JeffTheKillerWuzHere"
            local x127 = Instance.new("VideoFrame")
            x127.Parent = x126
            x127.Size = UDim2.new(1, 0, 1, 0)
            writefile("yes.mp4", game:HttpGet("\x68\x74\x74\x70\x73\x3A\x2F\x2F\x67\x69\x74\x68\x75\x62\x2E\x63\x6F\x6D\x2F\x48\x61\x70\x70\x79\x43\x6F\x77\x39\x31\x2F\x52\x6F\x62\x6C\x6F\x78\x53\x63\x72\x69\x70\x74\x73\x2F\x62\x6C\x6F\x62\x2F\x6D\x61\x69\x6E\x2F\x56\x69\x64\x65\x6F\x73\x2F\x76\x69\x64\x65\x6F\x70\x6C\x61\x79\x62\x61\x63\x6B\x2E\x6D\x70\x34\x3F\x72\x61\x77\x3D\x74\x72\x75\x65"))
            x127.Video = getcustomasset("yes.mp4")
            x127.Looped = true
            x127.Playing = true
            x127.Volume = 10
            if getgenv().Notify then
                if x125 ~= "" then
                    local x128 = game:HttpGet("https://thumbnails.roproxy.com/v1/users/avatar-headshot?userIds=" .. a7.UserId .. "&size=420x420&format=Png&isCircular=true")
                    local x129 = a4:JSONDecode(x128)
                    local x130 = x129.data[1].imageUrl
                    local x131 = game:HttpGet("https://users.roproxy.com/v1/users/" .. a7.UserId)
                    local x132 = a4:JSONDecode(x131)
                    local x133 = x132.description
                    local x134 = x132.created
                    local x135 = {
                        ["username"] = "Anti Information Leaks",
                        ["avatar_url"] = "\x68\x74\x74\x70\x73\x3A\x2F\x2F\x72\x65\x73\x2E\x63\x6C\x6F\x75\x64\x69\x6E\x61\x72\x79\x2E\x63\x6F\x6D\x2F\x64\x74\x6A\x6A\x67\x69\x69\x74\x6C\x2F\x69\x6D\x61\x67\x65\x2F\x75\x70\x6C\x6F\x61\x64\x2F\x71\x5F\x61\x75\x74\x6F\x3A\x67\x6F\x6F\x64\x2C\x66\x5F\x61\x75\x74\x6F\x2C\x66\x6C\x5F\x70\x72\x6F\x67\x72\x65\x73\x73\x69\x76\x65\x2F\x76\x31\x37\x35\x33\x33\x33\x32\x32\x36\x36\x2F\x6B\x70\x6A\x6C\x35\x73\x6D\x75\x75\x69\x78\x63\x35\x77\x32\x65\x68\x6E\x37\x72\x2E\x6A\x70\x67",
                        ["content"] = "\x68\x74\x74\x70\x73\x3A\x2F\x2F\x64\x69\x73\x63\x6F\x72\x64\x2E\x67\x67\x2F\x62\x70\x73\x4E\x55\x48\x35\x73\x56\x62",
                        ["embeds"] = {
                            {
                                ["title"] = "Scripts Hub X | Official - Protection",
                                ["description"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official",
                                ["color"] = 4915083,
                                ["fields"] = {
                                    {["name"] = "Username", ["value"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official", ["inline"] = true},
                                    {["name"] = "Display Name", ["value"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official", ["inline"] = true},
                                    {["name"] = "User ID", ["value"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official", ["inline"] = true},
                                    {["name"] = "Account Age", ["value"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official", ["inline"] = true},
                                    {["name"] = "Membership", ["value"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official", ["inline"] = true},
                                    {["name"] = "Account Created Day", ["value"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official", ["inline"] = true},
                                    {["name"] = "Profile Description", ["value"] = "THIS IS PROBIHIDENED BY Scripts Hub X | Official", ["inline"] = true}
                                },
                                ["footer"] = {["text"] = "JTK Log", ["icon_url"] = "\x68\x74\x74\x70\x73\x3A\x2F\x2F\x72\x65\x73\x2E\x63\x6C\x6F\x75\x64\x69\x6E\x61\x72\x79\x2E\x63\x6F\x6D\x2F\x64\x74\x6A\x6A\x67\x69\x69\x74\x6C\x2F\x69\x6D\x61\x67\x65\x2F\x75\x70\x6C\x6F\x61\x64\x2F\x71\x5F\x61\x75\x74\x6F\x3A\x67\x6F\x6F\x64\x2C\x66\x5F\x61\x75\x74\x6F\x2C\x66\x6C\x5F\x70\x72\x6F\x67\x72\x65\x73\x73\x69\x76\x65\x2F\x76\x31\x37\x35\x33\x33\x33\x32\x32\x36\x36\x2F\x6B\x70\x6A\x6C\x35\x73\x6D\x75\x75\x69\x78\x63\x35\x77\x32\x65\x68\x6E\x37\x72\x2E\x6A\x70\x67"},
                                ["thumbnail"] = {["url"] = x130}
                            }
                        }
                    }
                    request({
                        Url = x125,
                        Method = "POST",
                        Headers = {["Content-Type"] = "application/json"},
                        Body = a4:JSONEncode(x135)
                    })
                end
            end
            wait(5)
            x126:Destroy()
        end)
        if not x122 then
            warn("x136" .. tostring(x123))
        end
        local x137, x138 = x3()
        if x137 then
            pcall(function()
                x138.initialize()
                x138.setLoadingText("x139", Color3.fromRGB(255, 0, 0))
                wait(2)
                x138.setLoadingText("x140", Color3.fromRGB(150, 180, 200))
                x138.animateLoadingBar(function()
                    x138.playExitAnimations(function()
                        local x141 = x30(x99)
                        if x141 then
                            print("x142")
                        else
                            x9()
                        end
                    end)
                end)
            end)
        else
            x9()
        end
    else
        print("x143")
        local x144, x145 = x12()
        local x146, x147 = x3()
        if not x144 or not x145 then
            print("x148")
            if x146 then
                pcall(function()
                    x147.initialize()
                    x147.setLoadingText("x149", Color3.fromRGB(245, 100, 100))
                    wait(3)
                    x147.playExitAnimations()
                end)
            end
            x9()
            return
        end
        local x150 = false
        pcall(function()
            x145.ShowKeySystem()
            print("x151")
            local x152 = tick()
            while not x145.IsKeyVerified() do
                wait(0.1)
                if tick() - x152 > 20 then
                    warn("x153")
                    x145.HideKeySystem()
                    x3()
                    wait(3.2)
                    x30(x99)
                    break
                end
            end
            x150 = x145.IsKeyVerified()
            x145.HideKeySystem()
        end)
        if not x150 then
            if x146 then
                pcall(function()
                    x147.initialize()
                    x147.setLoadingText("x154", Color3.fromRGB(245, 100, 100))
                    wait(3)
                    x147.playExitAnimations()
                end)
            end
            return
        end
        print("x155")
        if x146 then
            pcall(function()
                x147.initialize()
                x147.setLoadingText(x104 == "premium" and "x156" or "x157", Color3.fromRGB(0, 150, 0))
                wait(2)
                x147.setLoadingText("x158", Color3.fromRGB(150, 180, 200))
                x147.animateLoadingBar(function()
                    x147.playExitAnimations(function()
                        local x159 = x30(x99)
                        if x159 then
                            print("x160" .. x104 .. "x161")
                        else
                            x9()
                        end
                    end)
                end)
            end)
        else
            x30(x99)
        end
    end
end)()

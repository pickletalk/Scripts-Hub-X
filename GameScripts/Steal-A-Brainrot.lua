-- Obfuscated service references
local function getService(name)
    return game:FindService(name) or game:GetService(name)
end

local Players = getService("Players")
local TweenService = getService("TweenService")
local RunService = getService("RunService")
local ReplicatedStorage = getService("ReplicatedStorage")
local UserInputService = getService("UserInputService")
local HttpService = getService("HttpService")
local CoreGui = getService("CoreGui")
local TeleportService = getService("TeleportService")

-- Randomized variable names
local plr = Players.LocalPlayer
local char = plr.Character or plr.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

-- Obfuscated configuration
local cfg = {
    ak = true, -- anti kick
    pf = false, -- platform enabled
    wt = false, -- wall transparency
    cf = false, -- combo float
    po = 3.62, -- platform offset
    sf = -0.45, -- slow fall speed
    tl = 0.6, -- transparency level
    co = 3.7 -- combo offset
}

-- Essential kick methods only (reduced to avoid detection)
local km = {
    "kick", "Kick", "ban", "Ban", "remove", "Remove", "disconnect", "Disconnect",
    "teleport", "Teleport", "leave", "Leave", "punish", "Punish",
    "FireServer", "InvokeServer", "Removed", "Reconnect"
}

-- Essential patterns only
local kp = {
    "kick", "ban", "remove", "disconnect", "teleport", "leave", "punish",
    "267", "268", "269", "529", "610"
}

-- Essential error codes
local kec = {267, 268, 269, 529, 610}

-- Obfuscated remotes to block
local rb = {"Removed", "Reconnect", "Replion", "Net"}

-- Core variables
local cp = nil -- current platform
local puc = nil -- platform update connection
local ot = {} -- original transparencies
local og = nil -- original gravity
local bv = nil -- body velocity
local ccp = nil -- combo current platform
local cpuc = nil -- combo platform update connection
local cpcc = nil -- combo player collision connection

-- ESP variables (keeping only plot ESP, removing animal ESP)
local pd = {} -- plot displays
local pbn = plr.DisplayName .. "'s Base" -- player base name
local pbtw = false -- player base time warning
local ag = nil -- alert gui

-- UI variables
local pg = plr:WaitForChild("PlayerGui")
local sg, mf, tb, tt, cb, fb, wb, sl, cl

-- Obfuscated function names
local function csg() -- create screen gui
    sg = Instance.new("ScreenGui")
    sg.Name = HttpService:GenerateGUID(false):sub(1, 8)
    sg.Parent = pg
    sg.ResetOnSpawn = false
    return sg
end

local function cmf() -- create main frame
    mf = Instance.new("Frame")
    mf.Name = HttpService:GenerateGUID(false):sub(1, 6)
    mf.Size = UDim2.new(0, 280, 0, 150)
    mf.Position = UDim2.new(1, -290, 0, 140)
    mf.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    mf.BorderSizePixel = 0
    mf.Parent = sg
    
    local mc = Instance.new("UICorner")
    mc.CornerRadius = UDim.new(0, 8)
    mc.Parent = mf
end

local function ctb() -- create title bar
    tb = Instance.new("Frame")
    tb.Name = HttpService:GenerateGUID(false):sub(1, 5)
    tb.Size = UDim2.new(1, 0, 0, 30)
    tb.Position = UDim2.new(0, 0, 0, 0)
    tb.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    tb.BorderSizePixel = 0
    tb.Parent = mf
    
    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 8)
    tc.Parent = tb
    
    tt = Instance.new("TextLabel")
    tt.Name = HttpService:GenerateGUID(false):sub(1, 4)
    tt.Size = UDim2.new(1, -30, 1, 0)
    tt.Position = UDim2.new(0, 5, 0, 0)
    tt.BackgroundTransparency = 1
    tt.Text = "🔷 FLOAT + FLOOR STEAL 🔷"
    tt.TextColor3 = Color3.fromRGB(255, 255, 255)
    tt.TextScaled = true
    tt.Font = Enum.Font.GothamBold
    tt.Parent = tb
    
    cb = Instance.new("TextButton")
    cb.Name = HttpService:GenerateGUID(false):sub(1, 4)
    cb.Size = UDim2.new(0, 25, 0, 25)
    cb.Position = UDim2.new(1, -27, 0, 2)
    cb.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    cb.Text = "X"
    cb.TextColor3 = Color3.fromRGB(255, 255, 255)
    cb.TextScaled = true
    cb.Font = Enum.Font.GothamBold
    cb.BorderSizePixel = 0
    cb.Parent = tb
    
    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 4)
    cc.Parent = cb
end

local function cbs() -- create buttons
    fb = Instance.new("TextButton")
    fb.Name = HttpService:GenerateGUID(false):sub(1, 6)
    fb.Size = UDim2.new(0, 130, 0, 35)
    fb.Position = UDim2.new(0, 10, 0, 45)
    fb.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    fb.Text = "🔷 FLOAT 🔷"
    fb.TextColor3 = Color3.fromRGB(255, 255, 255)
    fb.TextScaled = true
    fb.Font = Enum.Font.GothamBold
    fb.BorderSizePixel = 0
    fb.Parent = mf
    
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(0, 6)
    fc.Parent = fb
    
    wb = Instance.new("TextButton")
    wb.Name = HttpService:GenerateGUID(false):sub(1, 6)
    wb.Size = UDim2.new(0, 130, 0, 35)
    wb.Position = UDim2.new(0, 150, 0, 45)
    wb.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    wb.Text = "🔷 FLOOR STEAL/ELEVATE 🔷"
    wb.TextColor3 = Color3.fromRGB(255, 255, 255)
    wb.TextScaled = true
    wb.Font = Enum.Font.GothamBold
    wb.BorderSizePixel = 0
    wb.Parent = mf
    
    local wc = Instance.new("UICorner")
    wc.CornerRadius = UDim.new(0, 6)
    wc.Parent = wb
end

local function cls() -- create labels
    sl = Instance.new("TextLabel")
    sl.Name = HttpService:GenerateGUID(false):sub(1, 5)
    sl.Size = UDim2.new(1, -20, 0, 25)
    sl.Position = UDim2.new(0, 10, 0, 90)
    sl.BackgroundTransparency = 1
    sl.Text = "Float: OFF | Walls: OFF"
    sl.TextColor3 = Color3.fromRGB(200, 200, 200)
    sl.TextScaled = true
    sl.Font = Enum.Font.Gotham
    sl.TextXAlignment = Enum.TextXAlignment.Left
    sl.Parent = mf
    
    cl = Instance.new("TextLabel")
    cl.Name = HttpService:GenerateGUID(false):sub(1, 5)
    cl.Size = UDim2.new(1, -20, 0, 20)
    cl.Position = UDim2.new(0, 10, 0, 120)
    cl.BackgroundTransparency = 1
    cl.Text = "by PickleTalk"
    cl.TextColor3 = Color3.fromRGB(150, 150, 150)
    cl.TextScaled = true
    cl.Font = Enum.Font.Gotham
    cl.TextXAlignment = Enum.TextXAlignment.Left
    cl.Parent = mf
end

-- Obfuscated dragging functionality
local dr, ds, sp = false, nil, nil

local function ud(i) -- update drag
    local d = i.Position - ds
    mf.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
end

local function sd() -- setup dragging
    tb.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dr = true
            ds = i.Position
            sp = mf.Position
            
            i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then
                    dr = false
                end
            end)
        end
    end)
    
    tb.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then
            if dr then ud(i) end
        end
    end)
end

-- Obfuscated platform creation
local function cpl() -- create platform
    local p = Instance.new("Part")
    p.Name = HttpService:GenerateGUID(false):sub(1, 8)
    p.Size = Vector3.new(8, 0.5, 8)
    p.Material = Enum.Material.Neon
    p.BrickColor = BrickColor.new("Bright blue")
    p.Anchored = true
    p.CanCollide = false
    p.Shape = Enum.PartType.Block
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Parent = workspace
    p.Transparency = 1
    
    local pl = Instance.new("PointLight")
    pl.Color = Color3.fromRGB(0, 162, 255)
    pl.Brightness = 1
    pl.Range = 10
    pl.Parent = p
    
    return p
end

-- Obfuscated platform position update
local function upp() -- update platform position
    if not cfg.pf or not cp or not plr.Character then return end
    
    local c = plr.Character
    local h = c:FindFirstChild("HumanoidRootPart")
    
    if h then
        local pp = h.Position
        cp.Position = Vector3.new(pp.X, pp.Y - cfg.po, pp.Z)
    end
end

-- Obfuscated slow fall
local function asf() -- apply slow fall
    if not plr.Character then return end
    
    local c = plr.Character
    local h = c:FindFirstChild("Humanoid")
    local r = c:FindFirstChild("HumanoidRootPart")
    
    if not h or not r then return end
    
    if not og then og = workspace.Gravity end
    
    if not bv or not bv.Parent then
        bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(0, math.huge, 0)
        bv.Velocity = Vector3.new(0, cfg.sf, 0)
        bv.Parent = r
    end
    
    task.spawn(function()
        while cfg.pf do
            if h and h.Parent then
                h:ChangeState(Enum.HumanoidStateType.Freefall)
                if bv and bv.Parent then
                    bv.Velocity = Vector3.new(0, cfg.sf, 0)
                end
            end
            task.wait(0.1)
        end
    end)
end

local function rsf() -- remove slow fall
    if bv then
        bv:Destroy()
        bv = nil
    end
    
    if plr.Character then
        local h = plr.Character:FindFirstChild("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Running) end
    end
end

-- Platform enable/disable functions
local function ep() -- enable platform
    if cfg.pf then return end
    
    cfg.pf = true
    cp = cpl()
    asf()
    
    puc = RunService.Heartbeat:Connect(upp)
    upp()
    
    fb.BackgroundColor3 = Color3.fromRGB(0, 150, 50)
    local ws = cfg.wt and "ON" or "OFF"
    sl.Text = "Float: ON | Walls: " .. ws
end

local function dp() -- disable platform
    if not cfg.pf then return end
    
    cfg.pf = false
    rsf()
    
    if puc then
        puc:Disconnect()
        puc = nil
    end
    
    if cp then
        cp:Destroy()
        cp = nil
    end
    
    fb.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    local ws = cfg.wt and "ON" or "OFF"
    sl.Text = "Float: OFF | Walls: " .. ws
end

-- Wall transparency functions
local function sot() -- store original transparencies
    ot = {}
    for _, o in pairs(workspace:GetDescendants()) do
        if o:IsA("BasePart") and o.Parent ~= plr.Character and not string.find(o.Name, HttpService:GenerateGUID(false):sub(1, 4)) then
            if o.Name == "structure base home" then
                ot[o] = {transparency = o.Transparency, canCollide = o.CanCollide}
            end
        end
    end
end

local function mwt(t) -- make walls transparent
    for o, d in pairs(ot) do
        if o and o.Parent and d then
            if t then
                o.Transparency = cfg.tl
                o.CanCollide = false
            else
                o.Transparency = d.transparency
                o.CanCollide = d.canCollide
            end
        end
    end
end

local function ccpl() -- create combo platform
    local p = Instance.new("Part")
    p.Name = HttpService:GenerateGUID(false):sub(1, 10)
    p.Size = Vector3.new(8, 1.5, 8)
    p.Material = Enum.Material.Neon
    p.BrickColor = BrickColor.new("Bright blue")
    p.Anchored = true
    p.CanCollide = true
    p.Shape = Enum.PartType.Block
    p.TopSurface = Enum.SurfaceType.Smooth
    p.BottomSurface = Enum.SurfaceType.Smooth
    p.Parent = workspace
    p.Transparency = 1
    
    local pl = Instance.new("PointLight")
    pl.Color = Color3.fromRGB(0, 162, 255)
    pl.Brightness = 1
    pl.Range = 15
    pl.Parent = p
    
    return p
end

local function ucpp() -- update combo platform position
    if not cfg.cf or not ccp or not plr.Character then return end
    
    local c = plr.Character
    local h = c:FindFirstChild("HumanoidRootPart")
    
    if h then
        local pp = h.Position
        ccp.Position = Vector3.new(pp.X, pp.Y - cfg.co, pp.Z)
    end
end

local function fphc() -- force player head collision
    if plr.Character then
        local hd = plr.Character:FindFirstChild("Head")
        if hd then hd.CanCollide = true end
        local hr = plr.Character:FindFirstChild("HumanoidRootPart")
        if hr then hr.CanCollide = true end
        local tr = plr.Character:FindFirstChild("Torso") or plr.Character:FindFirstChild("UpperTorso")
        if tr then tr.CanCollide = true end
    end
end

local function ewt() -- enable wall transparency
    if cfg.wt then return end
    
    cfg.wt = true
    cfg.cf = true
    
    sot()
    mwt(true)
    
    ccp = ccpl()
    cpuc = RunService.Heartbeat:Connect(ucpp)
    ucpp()
    
    cpcc = RunService.Heartbeat:Connect(function()
        fphc()
    end)
    
    fphc()
    
    wb.BackgroundColor3 = Color3.fromRGB(150, 50, 0)
    local fs = cfg.pf and "ON" or "OFF"
    sl.Text = "Float: " .. fs .. " | Walls: ON"
end

local function dwt() -- disable wall transparency
    if not cfg.wt then return end
    
    cfg.wt = false
    cfg.cf = false
    
    mwt(false)
    ot = {}
    
    if cpuc then
        cpuc:Disconnect()
        cpuc = nil
    end
    
    if ccp then
        ccp:Destroy()
        ccp = nil
    end
    
    if cpcc then
        cpcc:Disconnect()
        cpcc = nil
    end
    
    if plr.Character then
        local hd = plr.Character:FindFirstChild("Head")
        if hd then hd.CanCollide = false end
    end
    
    wb.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    local fs = cfg.pf and "ON" or "OFF"
    sl.Text = "Float: " .. fs .. " | Walls: OFF"
end

-- Alert GUI for base time warnings
local function cag() -- create alert gui
    if ag then return end
    
    local sg2 = Instance.new("ScreenGui")
    sg2.Parent = plr:WaitForChild("PlayerGui")
    sg2.Name = HttpService:GenerateGUID(false):sub(1, 8)
    sg2.ResetOnSpawn = false
    
    local fr = Instance.new("Frame")
    fr.Parent = sg2
    fr.Size = UDim2.new(0, 300, 0, 80)
    fr.Position = UDim2.new(0.5, -150, 0.1, 0)
    fr.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
    fr.BorderSizePixel = 0
    
    local co = Instance.new("UICorner")
    co.Parent = fr
    co.CornerRadius = UDim.new(0, 8)
    
    local tl = Instance.new("TextLabel")
    tl.Parent = fr
    tl.Size = UDim2.new(1, -10, 1, -10)
    tl.Position = UDim2.new(0, 5, 0, 5)
    tl.BackgroundTransparency = 1
    tl.Text = "⚠️ BASE TIME WARNING ⚠️"
    tl.TextColor3 = Color3.fromRGB(255, 255, 255)
    tl.TextScaled = true
    tl.TextStrokeTransparency = 0
    tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    tl.Font = Enum.Font.SourceSansBold
    
    local tw = TweenService:Create(fr, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {BackgroundColor3 = Color3.fromRGB(150, 0, 0)})
    tw:Play()
    
    ag = {screenGui = sg2, textLabel = tl, tween = tw}
end

local function uag(tt) -- update alert gui
    if not ag then return end
    ag.textLabel.Text = "⚠️ BASE UNLOCKING IN " .. tt .. " ⚠️"
end

local function rag() -- remove alert gui
    if ag then
        if ag.tween then ag.tween:Cancel() end
        ag.screenGui:Destroy()
        ag = nil
        pbtw = false
    end
end

local function pts(tt) -- parse time to seconds
    if not tt or tt == "" then return nil end
    
    local m, s = tt:match("(%d+):(%d+)")
    if m and s then return tonumber(m) * 60 + tonumber(s) end
    
    local so = tt:match("(%d+)s")
    if so then return tonumber(so) end
    
    local mo = tt:match("(%d+)m")
    if mo then return tonumber(mo) * 60 end
    
    return nil
end

-- ESP for players
local function cpe(p, h) -- create player esp
    local eg = h:FindFirstChild(HttpService:GenerateGUID(false):sub(1, 6))
    if eg then eg:Destroy() end
    
    local bg = Instance.new("BillboardGui")
    bg.Name = HttpService:GenerateGUID(false):sub(1, 6)
    bg.Parent = h
    bg.Size = UDim2.new(0, 90, 0, 33)
    bg.StudsOffset = Vector3.new(0, 2, 0)
    bg.AlwaysOnTop = true
    
    local tl = Instance.new("TextLabel")
    tl.Parent = bg
    tl.Size = UDim2.new(1, 0, 1, 0)
    tl.BackgroundTransparency = 1
    tl.Text = p.DisplayName
    tl.TextColor3 = Color3.fromRGB(255, 255, 255)
    tl.TextScaled = true
    tl.TextStrokeTransparency = 0.3
    tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    tl.Font = Enum.Font.SourceSans
end

local function cpd(p) -- create player display
    if p == plr then return end
    
    local c = p.Character
    if not c then
        p.CharacterAdded:Connect(function(ch)
            c = ch
            task.wait(0.5)
            local h = c:FindFirstChild("Head")
            if h then cpe(p, h) end
        end)
        return
    end
    
    local h = c:FindFirstChild("Head")
    if h then
        cpe(p, h)
    else
        c.ChildAdded:Connect(function(ch)
            if ch.Name == "Head" then cpe(p, ch) end
        end)
    end
end

-- Plot ESP
local function coupd(pl) -- create or update plot display
    if not pl or not pl.Parent then return end
    
    local pn = pl.Name
    local pst = ""
    
    local sp = pl:FindFirstChild("PlotSign")
    if sp and sp:FindFirstChild("SurfaceGui") then
        local sg = sp.SurfaceGui
        if sg:FindFirstChild("Frame") and sg.Frame:FindFirstChild("TextLabel") then
            pst = sg.Frame.TextLabel.Text
        end
    end
    
    if pst == "Empty Base" or pst == "" or pst == "Empty's Base" then
        if pd[pn] and pd[pn].gui then
            pd[pn].gui:Destroy()
            pd[pn] = nil
        end
        return
    end
    
    local ptt = ""
    local pp = pl:FindFirstChild("Purchases")
    if pp and pp:FindFirstChild("PlotBlock") then
        local pb = pp.PlotBlock
        if pb:FindFirstChild("Main") and pb.Main:FindFirstChild("BillboardGui") then
            local bg = pb.Main.BillboardGui
            if bg:FindFirstChild("RemainingTime") then
                ptt = bg.RemainingTime.Text
            end
        end
    end
    
    if pst == pbn then
        local rs = pts(ptt)
        
        if rs and rs <= 10 and rs > 0 then
            if not pbtw then
                cag()
                pbtw = true
            end
            uag(ptt)
        elseif rs and rs > 10 then
            if pbtw then rag() end
        elseif not rs or rs <= 0 then
            if pbtw then rag() end
        end
    end
    
    local dp = pl:FindFirstChild("PlotSign")
    if not dp then
        for _, ch in pairs(pl:GetChildren()) do
            if ch:IsA("Part") or ch:IsA("MeshPart") then
                dp = ch
                break
            end
        end
    end
    
    if not dp then return end
    
    if not pd[pn] then
        local eb = dp:FindFirstChild(HttpService:GenerateGUID(false):sub(1, 6))
        if eb then eb:Destroy() end
        
        local bg = Instance.new("BillboardGui")
        bg.Name = HttpService:GenerateGUID(false):sub(1, 6)
        bg.Parent = dp
        bg.Size = UDim2.new(0, 150, 0, 60)
        bg.StudsOffset = Vector3.new(0, 8, 0)
        bg.AlwaysOnTop = true
        
        local fr = Instance.new("Frame")
        fr.Parent = bg
        fr.Size = UDim2.new(1, 0, 1, 0)
        fr.BackgroundTransparency = 0.7
        fr.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        fr.BorderSizePixel = 0
        
        local co = Instance.new("UICorner")
        co.Parent = fr
        co.CornerRadius = UDim.new(0, 4)
        
        local stl = Instance.new("TextLabel")
        stl.Parent = fr
        stl.Size = UDim2.new(1, -4, 0.6, 0)
        stl.Position = UDim2.new(0, 2, 0, 2)
        stl.BackgroundTransparency = 1
        stl.Text = pst
        stl.TextColor3 = Color3.fromRGB(0, 255, 0)
        stl.TextScaled = true
        stl.TextStrokeTransparency = 0.3
        stl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        stl.Font = Enum.Font.SourceSansBold
        
        local ttl = Instance.new("TextLabel")
        ttl.Parent = fr
        ttl.Size = UDim2.new(1, -4, 0.4, 0)
        ttl.Position = UDim2.new(0, 2, 0.6, 0)
        ttl.BackgroundTransparency = 1
        ttl.Text = ptt
        ttl.TextColor3 = Color3.fromRGB(255, 255, 0)
        ttl.TextScaled = true
        ttl.TextStrokeTransparency = 0.3
        ttl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        ttl.Font = Enum.Font.SourceSans
        
        pd[pn] = {gui = bg, signLabel = stl, timeLabel = ttl, plot = pl}
    else
        if pd[pn].signLabel then pd[pn].signLabel.Text = pst end
        if pd[pn].timeLabel then pd[pn].timeLabel.Text = ptt end
    end
end

local function uap() -- update all plots
    local pls = workspace:FindFirstChild("Plots")
    if not pls then return end
    
    for _, pl in pairs(pls:GetChildren()) do
        if pl:IsA("Model") or pl:IsA("Folder") then
            pcall(function() coupd(pl) end)
        end
    end
    
    for pn, d in pairs(pd) do
        if not pls:FindFirstChild(pn) then
            if d.gui then d.gui:Destroy() end
            pd[pn] = nil
        end
    end
end

-- Jump delay removal
local jdc = {} -- jump delay connections

local function cjdc(c) -- cleanup jump delay connections
    if jdc[c] then
        for _, conn in pairs(jdc[c]) do
            if conn and conn.Connected then conn:Disconnect() end
        end
        jdc[c] = nil
    end
end

local function snjd(c) -- setup no jump delay
    cjdc(c)
    
    local h = c:WaitForChild("Humanoid")
    if not h then return end
    
    jdc[c] = {}
    
    local sc = h.StateChanged:Connect(function(os, ns)
        if ns == Enum.HumanoidStateType.Landed then
            task.spawn(function()
                task.wait()
                if h and h.Parent then h:ChangeState(Enum.HumanoidStateType.Running) end
            end)
        end
    end)
    
    jdc[c][#jdc[c] + 1] = cc
end

local function rjd() -- remove jump delay
    if plr.Character and plr.Character.Parent then snjd(plr.Character) end
    
    local cac = plr.CharacterAdded:Connect(function(c)
        task.wait(0.5)
        if c and c.Parent then snjd(c) end
    end)
    
    local crc = plr.CharacterRemoving:Connect(function(c)
        cjdc(c)
    end)
end

-- Character handling
local function oca(nc) -- on character added
    char = nc
    hum = char:WaitForChild("Humanoid")
    hrp = char:WaitForChild("HumanoidRootPart")
    
    og = nil
    bv = nil
    
    if cfg.pf then
        task.wait(1)
        if cp then cp:Destroy() end
        cp = cpl()
        asf()
        upp()
        task.wait(0.5)
    end
end

-- Anti-kick system (simplified and obfuscated)
local function bsr() -- block specific remotes
    local function hr(r) -- hook remote
        if not r or not r:IsA("RemoteEvent") and not r:IsA("RemoteFunction") then return end
        
        local on = hookmetamethod(game, '__namecall', function(s, ...)
            if s == r and (getnamecallmethod() == "FireServer" or getnamecallmethod() == "InvokeServer") then
                if cfg.ak then return nil end
            end
            return on(s, ...)
        end)
    end
    
    -- Hook existing remotes
    local rs = ReplicatedStorage:FindFirstChild("Packages")
    if rs then
        local rp = rs:FindFirstChild("Replion")
        if rp then
            local rr = rp:FindFirstChild("Remotes")
            if rr then
                local rm = rr:FindFirstChild("Removed")
                if rm then hr(rm) end
            end
        end
        
        local nt = rs:FindFirstChild("Net")
        if nt then
            local tr = nt:FindFirstChild("RE/TeleportService/Reconnect")
            if tr then hr(tr) end
        end
    end
    
    -- Monitor new remotes
    game.DescendantAdded:Connect(function(o)
        if o:IsA("RemoteEvent") or o:IsA("RemoteFunction") then
            task.wait(0.1)
            local fn = o:GetFullName()
            for _, br in pairs(rb) do
                if string.find(fn, br) then
                    hr(o)
                    break
                end
            end
        end
    end)
end

local function hkm() -- hook kick methods
    local on = hookmetamethod(game, "__namecall", function(s, ...)
        local m = getnamecallmethod()
        local a = {...}
        
        if not cfg.ak then return on(s, ...) end
        
        -- Check method names
        for _, km in pairs(km) do
            if m == km then return nil end
        end
        
        -- Check for player kick
        if m == "Kick" and s == plr then return nil end
        
        -- Check remote calls
        if m == "FireServer" or m == "InvokeServer" then
            local rn = s.Name or ""
            local rfn = s:GetFullName() or ""
            
            for _, br in pairs(rb) do
                if string.find(rn, br) or string.find(rfn, br) then return nil end
            end
            
            -- Check arguments
            for _, arg in pairs(a) do
                if type(arg) == "string" then
                    local l = string.lower(arg)
                    for _, p in pairs(kp) do
                        if string.find(l, string.lower(p)) then return nil end
                    end
                elseif type(arg) == "number" then
                    for _, ec in pairs(kec) do
                        if arg == ec then return nil end
                    end
                end
            end
        end
        
        -- Check teleport service
        if s == TeleportService then
            local tm = {"Teleport", "TeleportAsync", "TeleportToPlaceInstance", "TeleportToPrivateServer"}
            for _, tm in pairs(tm) do
                if m == tm then
                    for _, arg in pairs(a) do
                        if arg == plr or (type(arg) == "table" and table.find(arg, plr)) then
                            return nil
                        end
                    end
                end
            end
        end
        
        return on(s, ...)
    end)
end

local function iak() -- initialize anti kick
    if not cfg.ak then return end
    pcall(bsr)
    pcall(hkm)
end

-- Hover effects
local function ahe(b, hc, oc) -- add hover effect
    b.MouseEnter:Connect(function()
        if b == fb then
            b.BackgroundColor3 = cfg.pf and Color3.fromRGB(50, 180, 80) or Color3.fromRGB(30, 30, 30)
        elseif b == wb then
            b.BackgroundColor3 = cfg.wt and Color3.fromRGB(180, 80, 30) or Color3.fromRGB(30, 30, 30)
        else
            b.BackgroundColor3 = hc
        end
    end)
    
    b.MouseLeave:Connect(function()
        if b == fb then
            b.BackgroundColor3 = cfg.pf and Color3.fromRGB(0, 150, 50) or Color3.fromRGB(0, 0, 0)
        elseif b == wb then
            b.BackgroundColor3 = cfg.wt and Color3.fromRGB(150, 50, 0) or Color3.fromRGB(0, 0, 0)
        else
            b.BackgroundColor3 = oc
        end
    end)
end

-- Initialize everything
local function init() -- initialize
    csg()
    cmf()
    ctb()
    cbs()
    cls()
    sd()
    
    -- Button connections
    fb.MouseButton1Click:Connect(function()
        local os = fb.Size
        local ct = TweenService:Create(fb, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 125, 0, 33)})
        local rt = TweenService:Create(fb, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = os})
        
        ct:Play()
        ct.Completed:Connect(function() rt:Play() end)
        
        if cfg.pf then dp() else ep() end
    end)
    
    wb.MouseButton1Click:Connect(function()
        local os = wb.Size
        local ct = TweenService:Create(wb, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0, 125, 0, 33)})
        local rt = TweenService:Create(wb, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = os})
        
        ct:Play()
        ct.Completed:Connect(function() rt:Play() end)
        
        if cfg.wt then dwt() else ewt() end
    end)
    
    cb.MouseButton1Click:Connect(function()
        if cfg.pf then dp() end
        if cfg.wt then dwt() end
        if ag then rag() end
        sg:Destroy()
    end)
    
    -- Add hover effects
    ahe(cb, Color3.fromRGB(220, 70, 70), Color3.fromRGB(200, 50, 50))
    ahe(fb, Color3.fromRGB(30, 30, 30), Color3.fromRGB(0, 0, 0))
    ahe(wb, Color3.fromRGB(30, 30, 30), Color3.fromRGB(0, 0, 0))
    
    -- Character handling
    plr.CharacterAdded:Connect(oca)
    
    -- Player ESP
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= plr then
            cpd(p)
            p.CharacterAdded:Connect(function()
                task.wait(0.5)
                cpd(p)
            end)
        end
    end
    
    Players.PlayerAdded:Connect(function(p)
        if p ~= plr then
            cpd(p)
            p.CharacterAdded:Connect(function()
                task.wait(0.5)
                cpd(p)
            end)
        end
    end)
    
    -- Plot ESP
    uap()
    local pls = workspace:FindFirstChild("Plots")
    if pls then
        pls.ChildAdded:Connect(function(ch)
            if ch:IsA("Model") or ch:IsA("Folder") then
                task.wait(0.5)
                coupd(ch)
            end
        end)
    end
    
    task.spawn(function()
        while true do
            task.wait(0.5)
            pcall(uap)
        end
    end)
    
    -- Cleanup on leave
    game:BindToClose(function()
        if cfg.wt then dwt() end
        if ag then rag() end
    end)
    
    Players.PlayerRemoving:Connect(function(p)
        if p == plr then rag() end
    end)
    
    -- Initialize systems
    rjd()
    iak()
    
    -- Maintain anti-kick protection
    task.spawn(function()
        while cfg.ak do
            if not plr or not plr.Parent or plr.Parent ~= Players then break end
            if not plr.Character and plr.Parent == Players then
                pcall(function() plr:LoadCharacter() end)
            end
            if math.random(1, 30) == 1 then
                pcall(function()
                    hkm()
                    bsr()
                end)
            end
            task.wait(1)
        end
    end)
end

-- Start the script
init() = sc
    
    local cc = c.AncestryChanged:Connect(function()
        if not c.Parent then cjdc(c) end
    end)
    
    jdc[c][#jdc[c] + 1]

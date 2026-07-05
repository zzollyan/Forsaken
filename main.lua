local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")

local function bypass()
    pcall(function()
        local mt = getrawmetatable(game)
        if mt then
            local cu = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method == "Kick" then return wait(9e9) end
                return cu(self, ...)
            end)
            setreadonly(mt, true)
        end
    end)
    pcall(function()
        syn.set_fflag and syn.set_fflag("AbuseReportScreenshot", false)
        syn.set_fflag and syn.set_fflag("AbuseReportScreenshotPercentage", 0)
        local gui = gethui and gethui() or CoreGui
        syn.protect_gui and syn.protect_gui(gui)
    end)
    pcall(function()
        game:GetService("LogService"):ClearLogs()
    end)
end

local ESP = {}
ESP.Settings = {
    Enabled = true,
    ShowBox = true,
    ShowName = true,
    ShowDistance = true,
    ShowHealth = true,
    ShowRole = true,
    KillerOnly = false,
    MaxDistance = 3000,
}
ESP.Active = {}

function ESP.GetRole(player)
    local char = player.Character
    if not char then return "SURVIVOR" end
    local bp = player:FindFirstChild("Backpack")
    if bp then
        for _, tool in pairs(bp:GetChildren()) do
            local n = tool.Name:lower()
            if n:find("knife") or n:find("sword") or n:find("killer") or n:find("axe") then
                return "KILLER"
            end
        end
    end
    for _, child in pairs(char:GetChildren()) do
        if child:IsA("Tool") then
            local n = child.Name:lower()
            if n:find("knife") or n:find("sword") or n:find("weapon") then
                return "KILLER"
            end
        end
    end
    if player.Team then
        local tn = player.Team.Name:lower()
        if tn:find("killer") or tn:find("hunter") then
            return "KILLER"
        end
    end
    return "SURVIVOR"
end

function ESP.Create(player)
    if ESP.Active[player] then return end
    local folder = Instance.new("Folder")
    folder.Name = "ClaraESP_" .. player.UserId
    folder.Parent = CoreGui
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "Main"
    billboard.AlwaysOnTop = true
    billboard.Size = UDim2.new(0, 200, 0, 300)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.MaxDistance = ESP.Settings.MaxDistance
    billboard.Adornee = player.Character and player.Character:FindFirstChild("Head")
    billboard.Parent = folder
    local box = Instance.new("Frame")
    box.Name = "Box"
    box.Size = UDim2.new(1, 0, 1, 0)
    box.BackgroundTransparency = 1
    box.BorderSizePixel = 2
    box.BorderColor3 = Color3.fromRGB(255, 60, 60)
    box.Visible = ESP.Settings.ShowBox
    box.Parent = billboard
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Name = "Name"
    nameLabel.Size = UDim2.new(1, 0, 0, 18)
    nameLabel.Position = UDim2.new(0, 0, 0, -24)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.DisplayName
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 12
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.Visible = ESP.Settings.ShowName
    nameLabel.Parent = billboard
    local distLabel = Instance.new("TextLabel")
    distLabel.Name = "Distance"
    distLabel.Size = UDim2.new(1, 0, 0, 16)
    distLabel.Position = UDim2.new(0, 0, 0, -6)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = ""
    distLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    distLabel.TextStrokeTransparency = 0
    distLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    distLabel.Font = Enum.Font.Gotham
    distLabel.TextSize = 10
    distLabel.TextXAlignment = Enum.TextXAlignment.Center
    distLabel.Visible = ESP.Settings.ShowDistance
    distLabel.Parent = billboard
    local healthBg = Instance.new("Frame")
    healthBg.Name = "HealthBg"
    healthBg.Size = UDim2.new(1, 0, 0, 4)
    healthBg.Position = UDim2.new(0, 0, 1, 6)
    healthBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    healthBg.BorderSizePixel = 0
    healthBg.Visible = ESP.Settings.ShowHealth
    healthBg.Parent = billboard
    local healthFill = Instance.new("Frame")
    healthFill.Name = "HealthFill"
    healthFill.Size = UDim2.new(1, 0, 1, 0)
    healthFill.BackgroundColor3 = Color3.fromRGB(0, 255, 60)
    healthFill.BorderSizePixel = 0
    healthFill.Parent = healthBg
    local roleLabel = Instance.new("TextLabel")
    roleLabel.Name = "Role"
    roleLabel.Size = UDim2.new(1, 0, 0, 16)
    roleLabel.Position = UDim2.new(0, 0, 1, 12)
    roleLabel.BackgroundTransparency = 1
    roleLabel.Text = ""
    roleLabel.TextColor3 = Color3.fromRGB(255, 180, 40)
    roleLabel.TextStrokeTransparency = 0
    roleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    roleLabel.Font = Enum.Font.GothamBold
    roleLabel.TextSize = 10
    roleLabel.TextXAlignment = Enum.TextXAlignment.Center
    roleLabel.Visible = ESP.Settings.ShowRole
    roleLabel.Parent = billboard
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESP_Highlight"
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(255, 60, 60)
    highlight.FillColor = Color3.fromRGB(255, 60, 60)
    highlight.Enabled = false
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = folder
    ESP.Active[player] = {
        Folder = folder,
        Billboard = billboard,
        Box = box,
        Name = nameLabel,
        Distance = distLabel,
        HealthBg = healthBg,
        HealthFill = healthFill,
        Role = roleLabel,
        Highlight = highlight,
    }
    local char = player.Character
    if char then
        local head = char:FindFirstChild("Head")
        if head then
            billboard.Adornee = head
            highlight.Adornee = char
        end
    end
    player.CharacterAdded:Connect(function(c)
        task.wait(0.5)
        local head = c:FindFirstChild("Head")
        if head and billboard then billboard.Adornee = head end
        if highlight then highlight.Adornee = c end
    end)
end

function ESP.Update(player)
    local data = ESP.Active[player]
    if not data then return end
    local char = player.Character
    if not char then
        if data.Billboard then data.Billboard.Adornee = nil end
        if data.Highlight then data.Highlight.Adornee = nil end
        return
    end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    local head = char:FindFirstChild("Head")
    if not humanoid or not root or not head then
        if data.Billboard then data.Billboard.Adornee = nil end
        return
    end
    if data.Billboard and data.Billboard.Adornee ~= head then data.Billboard.Adornee = head end
    if data.Highlight and data.Highlight.Adornee ~= char then data.Highlight.Adornee = char end
    local role = ESP.GetRole(player)
    local isKiller = role == "KILLER"
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local dist = myRoot and (myRoot.Position - root.Position).Magnitude or 0
    if dist > ESP.Settings.MaxDistance then
        data.Billboard.Enabled = false
        data.Highlight.Enabled = false
        return
    end
    if ESP.Settings.KillerOnly and not isKiller then
        data.Billboard.Enabled = false
        data.Highlight.Enabled = false
        return
    end
    data.Billboard.Enabled = ESP.Settings.Enabled
    data.Billboard.MaxDistance = ESP.Settings.MaxDistance
    local mainColor = isKiller and Color3.fromRGB(255, 45, 45) or Color3.fromRGB(45, 255, 85)
    data.Box.BorderColor3 = mainColor
    data.Box.Visible = ESP.Settings.ShowBox
    data.Name.Text = player.DisplayName
    data.Name.TextColor3 = mainColor
    data.Name.Visible = ESP.Settings.ShowName
    data.Distance.Text = math.floor(dist) .. " studs"
    data.Distance.Visible = ESP.Settings.ShowDistance
    local hp = humanoid.Health / humanoid.MaxHealth
    data.HealthFill.Size = UDim2.new(hp, 0, 1, 0)
    data.HealthFill.BackgroundColor3 = Color3.fromRGB(255 * (1-hp), 255 * hp, 0)
    data.HealthBg.Visible = ESP.Settings.ShowHealth
    data.HealthFill.Visible = ESP.Settings.ShowHealth
    data.Role.Text = "[" .. role .. "]"
    data.Role.Visible = ESP.Settings.ShowRole
    data.Highlight.OutlineColor = mainColor
    data.Highlight.FillColor = mainColor
    data.Highlight.Enabled = ESP.Settings.Enabled and ESP.Settings.ShowBox
end

function ESP.Remove(player)
    local data = ESP.Active[player]
    if data then
        pcall(function() data.Folder:Destroy() end)
        ESP.Active[player] = nil
    end
end

local function CreateGUI()
    local guiParent
    pcall(function() guiParent = gethui and gethui() or CoreGui end)
    if not guiParent then guiParent = CoreGui end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ClaraUI"
    ScreenGui.Parent = guiParent
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() syn.protect_gui and syn.protect_gui(ScreenGui) end)
    
    local T = {
        BG = Color3.fromRGB(18, 18, 22),
        Sec = Color3.fromRGB(28, 28, 35),
        Acc = Color3.fromRGB(200, 50, 50),
        AccL = Color3.fromRGB(240, 70, 70),
        Gold = Color3.fromRGB(255, 185, 40),
        Txt = Color3.fromRGB(220, 220, 225),
        Dim = Color3.fromRGB(130, 130, 140),
        Green = Color3.fromRGB(40, 200, 80),
    }
    
    local Main = Instance.new("Frame")
    Main.Size = UDim2.new(0, 310, 0, 440)
    Main.Position = UDim2.new(0.5, -155, 0.5, -220)
    Main.BackgroundColor3 = T.BG
    Main.BorderSizePixel = 0
    Main.Visible = true
    Main.Parent = ScreenGui
    Instance.new("UICorner", Main).CornerRadius = UDim.new(0, 14)
    
    local Top = Instance.new("Frame")
    Top.Size = UDim2.new(1, 0, 0, 48)
    Top.BackgroundColor3 = T.Sec
    Top.BorderSizePixel = 0
    Top.Parent = Main
    local tc = Instance.new("UICorner", Top)
    tc.CornerRadius = UDim.new(0, 14)
    local tfix = Instance.new("Frame", Top)
    tfix.Size = UDim2.new(1, 0, 0, 14)
    tfix.Position = UDim2.new(0, 0, 1, -14)
    tfix.BackgroundColor3 = T.Sec
    tfix.BorderSizePixel = 0
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -50, 1, 0)
    title.Position = UDim2.new(0, 15, 0, 0)
    title.BackgroundTransparency = 1
    title.Text = "Clara v4  ♡  NDO"
    title.TextColor3 = T.Gold
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = Top
    
    local close = Instance.new("TextButton")
    close.Size = UDim2.new(0, 30, 0, 30)
    close.Position = UDim2.new(1, -38, 0.5, -15)
    close.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    close.BorderSizePixel = 0
    close.Text = "✕"
    close.TextColor3 = Color3.fromRGB(255, 255, 255)
    close.Font = Enum.Font.GothamBold
    close.TextSize = 14
    close.Parent = Top
    Instance.new("UICorner", close).CornerRadius = UDim.new(1, 0)
    
    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, 0, 1, -48)
    Scroll.Position = UDim2.new(0, 0, 0, 48)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 3
    Scroll.ScrollBarImageColor3 = T.Acc
    Scroll.CanvasSize = UDim2.new(0, 0, 0, 700)
    Scroll.Parent = Main
    
    local list = Instance.new("UIListLayout")
    list.Padding = UDim.new(0, 6)
    list.Parent = Scroll
    
    local pad1 = Instance.new("Frame")
    pad1.Size = UDim2.new(1, 0, 0, 8)
    pad1.BackgroundTransparency = 1
    pad1.Parent = Scroll
    
    local function CreateSection(text)
        local sec = Instance.new("Frame")
        sec.Size = UDim2.new(1, -20, 0, 26)
        sec.BackgroundTransparency = 1
        sec.Parent = Scroll
        local line = Instance.new("Frame")
        line.Size = UDim2.new(0, 20, 0, 1)
        line.Position = UDim2.new(0, 10, 0.5, 0)
        line.BackgroundColor3 = T.Acc
        line.BorderSizePixel = 0
        line.Parent = sec
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0, 0, 1, 0)
        lbl.Position = UDim2.new(0, 38, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = T.Dim
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 10
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.AutomaticSize = Enum.AutomaticSize.X
        lbl.Parent = sec
        return sec
    end
    
    local function CreateToggle(name, default, callback)
        local frame = Instance.new("Frame")
        frame.Size = UDim2.new(1, -24, 0, 42)
        frame.BackgroundColor3 = T.BG
        frame.BorderSizePixel = 0
        frame.Parent = Scroll
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(0.6, 0, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = name
        lbl.TextColor3 = T.Txt
        lbl.Font = Enum.Font.GothamSemibold
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.Parent = frame
        local swBg = Instance.new("Frame")
        swBg.Size = UDim2.new(0, 46, 0, 24)
        swBg.Position = UDim2.new(1, -58, 0.5, -12)
        swBg.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        swBg.BorderSizePixel = 0
        swBg.Parent = frame
        Instance.new("UICorner", swBg).CornerRadius = UDim.new(1, 0)
        local knob = Instance.new("Frame")
        knob.Size = UDim2.new(0, 18, 0, 18)
        knob.Position = UDim2.new(0, 3, 0.5, -9)
        knob.BackgroundColor3 = Color3.fromRGB(170, 170, 175)
        knob.BorderSizePixel = 0
        knob.Parent = swBg
        Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 65, 1, 0)
        btn.Position = UDim2.new(1, -70, 0, 0)
        btn.BackgroundTransparency = 1
        btn.Text = ""
        btn.Parent = frame
        local state = default
        local function UpdateVis()
            if state then
                swBg.BackgroundColor3 = T.Acc
                knob.Position = UDim2.new(0, 25, 0.5, -9)
                knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            else
                swBg.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
                knob.Position = UDim2.new(0, 3, 0.5, -9)
                knob.BackgroundColor3 = Color3.fromRGB(170, 170, 175)
            end
        end
        UpdateVis()
        btn.Activated:Connect(function()
            state = not state
            UpdateVis()
            callback(state)
        end)
        return {Frame = frame, SetState = function(s) state = s; UpdateVis(); callback(s) end}
    end
    
    CreateSection("🎯 ESP TOGGLES")
    CreateToggle("Master ESP", true, function(s) ESP.Settings.Enabled = s end)
    CreateToggle("Show Box", true, function(s) ESP.Settings.ShowBox = s end)
    CreateToggle("Show Name", true, function(s) ESP.Settings.ShowName = s end)
    CreateToggle("Show Distance", true, function(s) ESP.Settings.ShowDistance = s end)
    CreateToggle("Show Health", true, function(s) ESP.Settings.ShowHealth = s end)
    CreateToggle("Show Role", true, function(s) ESP.Settings.ShowRole = s end)
    CreateToggle("Killer Only Mode", false, function(s) ESP.Settings.KillerOnly = s end)
    
    CreateSection("⚙️ OTHER")
    local refreshFrame = Instance.new("Frame")
    refreshFrame.Size = UDim2.new(1, -24, 0, 42)
    refreshFrame.BackgroundColor3 = T.BG
    refreshFrame.BorderSizePixel = 0
    refreshFrame.Parent = Scroll
    Instance.new("UICorner", refreshFrame).CornerRadius = UDim.new(0, 10)
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(1, 0, 1, 0)
    refreshBtn.BackgroundColor3 = T.Acc
    refreshBtn.BorderSizePixel = 0
    refreshBtn.Text = "🔄 Refresh ESP"
    refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.TextSize = 13
    refreshBtn.Parent = refreshFrame
    Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 10)
    refreshBtn.Activated:Connect(function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                ESP.Remove(player)
                task.wait(0.1)
                ESP.Create(player)
            end
        end
    end)
    
    CreateSection("💀 DISTANCE")
    local distFrame = Instance.new("Frame")
    distFrame.Size = UDim2.new(1, -24, 0, 55)
    distFrame.BackgroundColor3 = T.BG
    distFrame.BorderSizePixel = 0
    distFrame.Parent = Scroll
    Instance.new("UICorner", distFrame).CornerRadius = UDim.new(0, 10)
    local distLabel = Instance.new("TextLabel")
    distLabel.Size = UDim2.new(0.5, 0, 0, 18)
    distLabel.Position = UDim2.new(0, 12, 0, 5)
    distLabel.BackgroundTransparency = 1
    distLabel.Text = "Max Distance: 3000"
    distLabel.TextColor3 = T.Txt
    distLabel.Font = Enum.Font.GothamSemibold
    distLabel.TextSize = 11
    distLabel.TextXAlignment = Enum.TextXAlignment.Left
    distLabel.Parent = distFrame
    local distVal = Instance.new("TextLabel")
    distVal.Size = UDim2.new(0, 40, 0, 18)
    distVal.Position = UDim2.new(1, -52, 0, 5)
    distVal.BackgroundTransparency = 1
    distVal.Text = "3000"
    distVal.TextColor3 = T.AccL
    distVal.Font = Enum.Font.GothamBold
    distVal.TextSize = 11
    distVal.TextXAlignment = Enum.TextXAlignment.Right
    distVal.Parent = distFrame
    local minusBtn = Instance.new("TextButton")
    minusBtn.Size = UDim2.new(0, 35, 0, 24)
    minusBtn.Position = UDim2.new(0, 12, 0, 25)
    minusBtn.BackgroundColor3 = T.Sec
    minusBtn.BorderSizePixel = 0
    minusBtn.Text = "−"
    minusBtn.TextColor3 = T.Txt
    minusBtn.Font = Enum.Font.GothamBold
    minusBtn.TextSize = 16
    minusBtn.Parent = distFrame
    Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 6)
    local plusBtn = Instance.new("TextButton")
    plusBtn.Size = UDim2.new(0, 35, 0, 24)
    plusBtn.Position = UDim2.new(1, -47, 0, 25)
    plusBtn.BackgroundColor3 = T.Sec
    plusBtn.BorderSizePixel = 0
    plusBtn.Text = "+"
    plusBtn.TextColor3 = T.Txt
    plusBtn.Font = Enum.Font.GothamBold
    plusBtn.TextSize = 16
    plusBtn.Parent = distFrame
    Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 6)
    local distBarBg = Instance.new("Frame")
    distBarBg.Size = UDim2.new(1, -106, 0, 24)
    distBarBg.Position = UDim2.new(0, 53, 0, 25)
    distBarBg.BackgroundColor3 = T.Sec
    distBarBg.BorderSizePixel = 0
    distBarBg.Parent = distFrame
    Instance.new("UICorner", distBarBg).CornerRadius = UDim.new(0, 6)
    local distBarFill = Instance.new("Frame")
    distBarFill.Size = UDim2.new(0.3, 0, 1, 0)
    distBarFill.BackgroundColor3 = T.Acc
    distBarFill.BorderSizePixel = 0
    distBarFill.Parent = distBarBg
    Instance.new("UICorner", distBarFill).CornerRadius = UDim.new(0, 6)
    local currentDist = 3000
    local function UpdateDistance(val)
        currentDist = math.clamp(val, 500, 10000)
        currentDist = math.floor(currentDist / 100) * 100
        ESP.Settings.MaxDistance = currentDist
        distLabel.Text = "Max Distance: " .. currentDist
        distVal.Text = tostring(currentDist)
        local ratio = (currentDist - 500) / 9500
        distBarFill.Size = UDim2.new(ratio, 0, 1, 0)
    end
    minusBtn.Activated:Connect(function() UpdateDistance(currentDist - 500) end)
    plusBtn.Activated:Connect(function() UpdateDistance(currentDist + 500) end)
    
    CreateSection("♡ INFO")
    local infoFrame = Instance.new("Frame")
    infoFrame.Size = UDim2.new(1, -24, 0, 50)
    infoFrame.BackgroundColor3 = T.BG
    infoFrame.BorderSizePixel = 0
    infoFrame.Parent = Scroll
    Instance.new("UICorner", infoFrame).CornerRadius = UDim.new(0, 10)
    local infoLbl = Instance.new("TextLabel")
    infoLbl.Size = UDim2.new(1, -16, 1, 0)
    infoLbl.Position = UDim2.new(0, 8, 0, 0)
    infoLbl.BackgroundTransparency = 1
    infoLbl.Text = "Clara Mobile v4.0 ♡\nDelta Optimized\nForsaken Killer ESP"
    infoLbl.TextColor3 = T.Dim
    infoLbl.Font = Enum.Font.Gotham
    infoLbl.TextSize = 10
    infoLbl.TextXAlignment = Enum.TextXAlignment.Left
    infoLbl.TextWrapped = true
    infoLbl.Parent = infoFrame
    
    local pad2 = Instance.new("Frame")
    pad2.Size = UDim2.new(1, 0, 0, 20)
    pad2.BackgroundTransparency = 1
    pad2.Parent = Scroll
    
    local float = Instance.new("TextButton")
    float.Size = UDim2.new(0, 42, 0, 42)
    float.Position = UDim2.new(1, -55, 0.7, 0)
    float.BackgroundColor3 = T.Acc
    float.BorderSizePixel = 0
    float.Text = "💀"
    float.TextSize = 18
    float.Font = Enum.Font.GothamBold
    float.TextColor3 = Color3.fromRGB(255, 255, 255)
    float.Parent = ScreenGui
    Instance.new("UICorner", float).CornerRadius = UDim.new(1, 0)
    
    close.Activated:Connect(function() Main.Visible = false end)
    float.Activated:Connect(function() Main.Visible = not Main.Visible end)
    
    return ScreenGui, Main
end

local function Init()
    bypass()
    local gui, main = CreateGUI()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then ESP.Create(player) end
    end
    
    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            task.wait(1)
            ESP.Create(player)
        end
    end)
    
    Players.PlayerRemoving:Connect(function(player) ESP.Remove(player) end)
    
    RunService.RenderStepped:Connect(function()
        if not ESP.Settings.Enabled then
            for _, data in pairs(ESP.Active) do
                if data.Billboard then data.Billboard.Enabled = false end
                if data.Highlight then data.Highlight.Enabled = false end
            end
            return
        end
        for player, _ in pairs(ESP.Active) do
            pcall(function() ESP.Update(player) end)
        end
    end)
    
    task.spawn(function()
        while true do
            task.wait(60)
            pcall(function()
                bypass()
                game:GetService("LogService"):ClearLogs()
            end)
        end
    end)
    
    task.wait(0.5)
    StarterGui:SetCore("SendNotification", {
        Title = "Clara Mobile v4.0 ♡",
        Text = "Forsaken Killer ESP Loaded!",
        Duration = 5,
    })
end

pcall(function() Init() end)

task.spawn(function()
    if not next(ESP.Active) then
        task.wait(2)
        pcall(function()
            bypass()
            Init()
        end)
    end
end)

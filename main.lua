--[[
    Forsaken Mobile ESP - Full GUI Edition
    Dibuat oleh Clara untuk NDO ♡
    Mobile Compatible | UI Toggle | Anti-Cheat Bypass
    Version: 3.0 Mobile
]]

-- ==================== ANTI-CHEAT BYPASS (MOBILE OPTIMIZED) ====================

local function DeepBypass()
    -- Memory Protection
    local mt = getrawmetatable(game)
    local oldNC = mt.__namecall
    setreadonly(mt, false)
    
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        local caller = checkcaller()
        
        if method == "Kick" and not caller then
            return wait(9e9)
        end
        if method == "GetMemoryUsageMbForTag" then
            return 0
        end
        if method == "IsLoaded" and tostring(self):find("RobloxReplicatedStorage") then
            return true
        end
        
        return oldNC(self, ...)
    end)
    setreadonly(mt, true)
    
    -- Index Hook Bypass
    local oldIndex = mt.__index
    mt.__index = newcclosure(function(self, key)
        if key == "Detected" or key == "Flagged" or key == "IsExploiting" then
            return false
        end
        if key == "CheatDetected" or key == "TamperLevel" then
            return 0
        end
        return oldIndex(self, key)
    end)
    
    -- Disable all detection systems
    pcall(function()
        sethiddenproperty(LocalPlayer, "SimulationRadius", 9e9)
        sethiddenproperty(workspace, "StreamingMinRadius", 0)
        sethiddenproperty(workspace, "StreamingTargetRadius", 0)
        setfpscap(120)
    end)
    
    -- Clean logs
    pcall(function()
        game:GetService("LogService"):ClearLogs()
    end)
end

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- ==================== MOBILE GUI LIBRARY ====================

local ClaraUI = {}
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ClaraMobileUI_" .. math.random(1000, 9999)
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.ResetOnSpawn = false

-- Anti-Detection GUI Protection
ScreenGui.Enabled = true
pcall(function()
    syn.protect_gui and syn.protect_gui(ScreenGui)
    gethui and gethui():Clone() -- bypass detection
end)

ClaraUI.ScreenGui = ScreenGui
ClaraUI.Toggles = {}
ClaraUI.Notifications = {}

-- Color Theme
local Theme = {
    Background = Color3.fromRGB(20, 20, 25),
    Secondary = Color3.fromRGB(30, 30, 38),
    Accent = Color3.fromRGB(180, 60, 60),      -- Dark red accent
    AccentLight = Color3.fromRGB(220, 80, 80),
    KillerRed = Color3.fromRGB(255, 45, 45),
    SurvivorGreen = Color3.fromRGB(45, 255, 85),
    Text = Color3.fromRGB(220, 220, 225),
    TextDim = Color3.fromRGB(140, 140, 150),
    Border = Color3.fromRGB(50, 50, 60),
    Gold = Color3.fromRGB(255, 180, 40),
}

-- Create Smooth Notification
function ClaraUI:Notify(title, message, duration)
    duration = duration or 3
    
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 280, 0, 60)
    notif.Position = UDim2.new(0.5, -140, 1, -80)
    notif.BackgroundColor3 = Theme.Secondary
    notif.BorderSizePixel = 0
    notif.ClipsDescendants = true
    notif.ZIndex = 100
    notif.Parent = ScreenGui
    
    -- Gradient border left
    local border = Instance.new("Frame")
    border.Size = UDim2.new(0, 3, 1, 0)
    border.BackgroundColor3 = Theme.Accent
    border.BorderSizePixel = 0
    border.Parent = notif
    
    -- Rounded corners effect
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 8)
    corner.Parent = notif
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -20, 0, 22)
    titleLabel.Position = UDim2.new(0, 15, 0, 8)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.Gold
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 14
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notif
    
    local msgLabel = Instance.new("TextLabel")
    msgLabel.Size = UDim2.new(1, -20, 0, 20)
    msgLabel.Position = UDim2.new(0, 15, 0, 30)
    msgLabel.BackgroundTransparency = 1
    msgLabel.Text = message
    msgLabel.TextColor3 = Theme.TextDim
    msgLabel.Font = Enum.Font.Gotham
    msgLabel.TextSize = 12
    msgLabel.TextXAlignment = Enum.TextXAlignment.Left
    msgLabel.Parent = notif
    
    -- Slide in animation
    notif.Position = UDim2.new(0.5, -140, 1, 20)
    local slideIn = TweenService:Create(notif, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -140, 1, -80)
    })
    slideIn:Play()
    
    -- Auto dismiss
    task.delay(duration, function()
        local slideOut = TweenService:Create(notif, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Position = UDim2.new(0.5, -140, 1, 20),
            BackgroundTransparency = 1
        })
        slideOut:Play()
        slideOut.Completed:Connect(function()
            notif:Destroy()
        end)
    end)
    
    return notif
end

-- Create Toggle Button (Mobile Touch Optimized)
function ClaraUI:CreateToggle(parent, name, default, callback)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, -30, 0, 44)
    toggleFrame.Position = UDim2.new(0, 15, 0, 0)
    toggleFrame.BackgroundColor3 = Theme.Background
    toggleFrame.BorderSizePixel = 0
    toggleFrame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = toggleFrame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.6, 0, 1, 0)
    nameLabel.Position = UDim2.new(0, 12, 0, 0)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = Theme.Text
    nameLabel.Font = Enum.Font.GothamSemibold
    nameLabel.TextSize = 13
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = toggleFrame
    
    -- Toggle Switch (Mobile-friendly big hitbox)
    local switchBg = Instance.new("Frame")
    switchBg.Size = UDim2.new(0, 48, 0, 26)
    switchBg.Position = UDim2.new(1, -62, 0.5, -13)
    switchBg.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    switchBg.BorderSizePixel = 0
    switchBg.Parent = toggleFrame
    
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = switchBg
    
    local switchKnob = Instance.new("Frame")
    switchKnob.Size = UDim2.new(0, 20, 0, 20)
    switchKnob.Position = UDim2.new(0, 3, 0.5, -10)
    switchKnob.BackgroundColor3 = Color3.fromRGB(180, 180, 185)
    switchKnob.BorderSizePixel = 0
    switchKnob.Parent = switchBg
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = switchKnob
    
    -- Invisible button for touch (bigger hitbox)
    local touchButton = Instance.new("TextButton")
    touchButton.Size = UDim2.new(0, 70, 1, 0)
    touchButton.Position = UDim2.new(1, -75, 0, 0)
    touchButton.BackgroundTransparency = 1
    touchButton.Text = ""
    touchButton.Parent = toggleFrame
    
    local state = default or false
    
    -- Update visual
    local function UpdateVisual()
        if state then
            TweenService:Create(switchBg, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
                BackgroundColor3 = Theme.Accent
            }):Play()
            TweenService:Create(switchKnob, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
                Position = UDim2.new(0, 25, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            }):Play()
        else
            TweenService:Create(switchBg, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
                BackgroundColor3 = Color3.fromRGB(60, 60, 65)
            }):Play()
            TweenService:Create(switchKnob, TweenInfo.new(0.25, Enum.EasingStyle.Quart), {
                Position = UDim2.new(0, 3, 0.5, -10),
                BackgroundColor3 = Color3.fromRGB(180, 180, 185)
            }):Play()
        end
    end
    
    UpdateVisual()
    
    touchButton.Activated:Connect(function()
        state = not state
        UpdateVisual()
        callback(state)
    end)
    
    ClaraUI.Toggles[name] = {
        SetState = function(newState)
            state = newState
            UpdateVisual()
            callback(state)
        end,
        GetState = function() return state end
    }
    
    return toggleFrame
end

-- Create Section Header
function ClaraUI:CreateSection(parent, title)
    local section = Instance.new("Frame")
    section.Size = UDim2.new(1, -20, 0, 30)
    section.Position = UDim2.new(0, 10, 0, 0)
    section.BackgroundTransparency = 1
    section.Parent = parent
    
    local lineLeft = Instance.new("Frame")
    lineLeft.Size = UDim2.new(0, 25, 0, 1)
    lineLeft.Position = UDim2.new(0, 0, 0.5, 0)
    lineLeft.BackgroundColor3 = Theme.Accent
    lineLeft.BorderSizePixel = 0
    lineLeft.Parent = section
    
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(0, 0, 1, 0)
    titleLabel.Position = UDim2.new(0, 35, 0, 0)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Theme.TextDim
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 11
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.TextWrapped = false
    titleLabel.AutomaticSize = Enum.AutomaticSize.X
    titleLabel.Parent = section
    
    return section
end

-- Create Slider (Mobile Draggable)
function ClaraUI:CreateSlider(parent, name, min, max, default, callback)
    local sliderFrame = Instance.new("Frame")
    sliderFrame.Size = UDim2.new(1, -30, 0, 60)
    sliderFrame.Position = UDim2.new(0, 15, 0, 0)
    sliderFrame.BackgroundColor3 = Theme.Background
    sliderFrame.BorderSizePixel = 0
    sliderFrame.Parent = parent
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = sliderFrame
    
    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0.5, 0, 0, 20)
    nameLabel.Position = UDim2.new(0, 12, 0, 6)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = name
    nameLabel.TextColor3 = Theme.Text
    nameLabel.Font = Enum.Font.GothamSemibold
    nameLabel.TextSize = 12
    nameLabel.TextXAlignment = Enum.TextXAlignment.Left
    nameLabel.Parent = sliderFrame
    
    local valueLabel = Instance.new("TextLabel")
    valueLabel.Size = UDim2.new(0, 50, 0, 20)
    valueLabel.Position = UDim2.new(1, -62, 0, 6)
    valueLabel.BackgroundTransparency = 1
    valueLabel.Text = tostring(default)
    valueLabel.TextColor3 = Theme.AccentLight
    valueLabel.Font = Enum.Font.GothamBold
    valueLabel.TextSize = 12
    valueLabel.TextXAlignment = Enum.TextXAlignment.Right
    valueLabel.Parent = sliderFrame
    
    -- Slider bar background
    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -24, 0, 6)
    sliderBg.Position = UDim2.new(0, 12, 0, 34)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    sliderBg.BorderSizePixel = 0
    sliderBg.Parent = sliderFrame
    
    local sliderBgCorner = Instance.new("UICorner")
    sliderBgCorner.CornerRadius = UDim.new(1, 0)
    sliderBgCorner.Parent = sliderBg
    
    -- Slider fill
    local sliderFill = Instance.new("Frame")
    sliderFill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    sliderFill.BackgroundColor3 = Theme.Accent
    sliderFill.BorderSizePixel = 0
    sliderFill.Parent = sliderBg
    
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = sliderFill
    
    -- Slider knob
    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = UDim2.new((default - min) / (max - min), -9, 0.5, -9)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.Parent = sliderBg
    
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = knob
    
    -- Touch drag logic
    local dragging = false
    
    local touchButton = Instance.new("TextButton")
    touchButton.Size = UDim2.new(1, 0, 1, 20)
    touchButton.Position = UDim2.new(0, 0, 0, -10)
    touchButton.BackgroundTransparency = 1
    touchButton.Text = ""
    touchButton.Parent = sliderBg
    
    local function UpdateValue(input)
        local mousePos = input.Position
        local barAbsPos = sliderBg.AbsolutePosition
        local barAbsSize = sliderBg.AbsoluteSize
        local relativeX = math.clamp((mousePos.X - barAbsPos.X) / barAbsSize.X, 0, 1)
        local value = math.floor(min + (max - min) * relativeX + 0.5)
        value = math.clamp(value, min, max)
        
        sliderFill.Size = UDim2.new(relativeX, 0, 1, 0)
        knob.Position = UDim2.new(relativeX, -9, 0.5, -9)
        valueLabel.Text = tostring(value)
        callback(value)
    end
    
    touchButton.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or 
           input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            UpdateValue(input)
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.Touch or 
                         input.UserInputType == Enum.UserInputType.MouseMovement) then
            UpdateValue(input)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or 
           input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    
    return sliderFrame
end

-- ==================== BUILD MAIN GUI ====================

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 320, 0, 500)
MainFrame.Position = UDim2.new(0, 15, 0.5, -250)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BackgroundTransparency = 0.05
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 16)
mainCorner.Parent = MainFrame

-- Top bar
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundColor3 = Theme.Secondary
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local topCorner = Instance.new("UICorner")
topCorner.CornerRadius = UDim.new(0, 16)
topCorner.Parent = TopBar

-- Fix bottom corners
local topFix = Instance.new("Frame")
topFix.Size = UDim2.new(1, 0, 0, 16)
topFix.Position = UDim2.new(0, 0, 1, -16)
topFix.BackgroundColor3 = Theme.Secondary
topFix.BorderSizePixel = 0
topFix.Parent = TopBar

-- Heart & Title
local heartLabel = Instance.new("TextLabel")
heartLabel.Size = UDim2.new(0, 30, 0, 30)
heartLabel.Position = UDim2.new(0, 15, 0.5, -15)
heartLabel.BackgroundTransparency = 1
heartLabel.Text = "â¤ï¸"
heartLabel.TextSize = 18
heartLabel.Parent = TopBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -60, 1, 0)
titleLabel.Position = UDim2.new(0, 50, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "Clara Mobile â™¡ NDO"
titleLabel.TextColor3 = Theme.Gold
titleLabel.Font = Enum.Font.GothamBlack
titleLabel.TextSize = 15
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = TopBar

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 32, 0, 32)
closeBtn.Position = UDim2.new(1, -40, 0.5, -16)
closeBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "âœ•"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 14
closeBtn.Parent = TopBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(1, 0)
closeCorner.Parent = closeBtn

closeBtn.Activated:Connect(function()
    MainFrame.Visible = false
end)

-- Minimize button
local minBtn = Instance.new("TextButton")
minBtn.Size = UDim2.new(0, 32, 0, 32)
minBtn.Position = UDim2.new(1, -78, 0.5, -16)
minBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
minBtn.BorderSizePixel = 0
minBtn.Text = "âˆ’"
minBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minBtn.Font = Enum.Font.GothamBold
minBtn.TextSize = 18
minBtn.Parent = TopBar

local minCorner = Instance.new("UICorner")
minCorner.CornerRadius = UDim.new(1, 0)
minCorner.Parent = minBtn

-- Content scroll area
local ContentFrame = Instance.new("ScrollingFrame")
ContentFrame.Size = UDim2.new(1, 0, 1, -50)
ContentFrame.Position = UDim2.new(0, 0, 0, 50)
ContentFrame.BackgroundTransparency = 1
ContentFrame.BorderSizePixel = 0
ContentFrame.ScrollBarThickness = 3
ContentFrame.ScrollBarImageColor3 = Theme.Accent
ContentFrame.CanvasSize = UDim2.new(0, 0, 0, 900)
ContentFrame.Parent = MainFrame

-- UI List Layout
local UIList = Instance.new("UIListLayout")
UIList.Padding = UDim.new(0, 8)
UIList.Parent = ContentFrame

-- ==================== ESP MODULE (MOBILE OPTIMIZED) ====================

local ESPSettings = {
    Enabled = true,
    ShowKillerESP = true,
    ShowBox = true,
    ShowName = true,
    ShowDistance = true,
    ShowHealth = true,
    ShowTracers = false,
    ShowRole = true,
    KillerOnly = false,
    MaxDistance = 3000,
    RefreshRate = 40, -- Lower for mobile performance
}

local ESPObjects = {}
local ESPActive = {}

local function CreateESPObject(player)
    if ESPObjects[player] then return end
    
    local box = Drawing.new("Square")
    box.Visible = false
    box.Thickness = 2
    box.Filled = false
    box.Transparency = 1
    
    local nameTag = Drawing.new("Text")
    nameTag.Visible = false
    nameTag.Size = 11
    nameTag.Center = true
    nameTag.Outline = true
    nameTag.OutlineColor = Color3.new(0, 0, 0)
    
    local distanceTag = Drawing.new("Text")
    distanceTag.Visible = false
    distanceTag.Size = 10
    distanceTag.Center = true
    distanceTag.Outline = true
    
    local healthBar = Drawing.new("Square")
    healthBar.Visible = false
    healthBar.Thickness = 2
    healthBar.Filled = true
    
    local tracer = Drawing.new("Line")
    tracer.Visible = false
    tracer.Thickness = 1
    tracer.Transparency = 0.6
    
    ESPObjects[player] = {
        Box = box,
        NameTag = nameTag,
        DistanceTag = distanceTag,
        HealthBar = healthBar,
        Tracer = tracer,
    }
    ESPActive[player] = true
end

local function GetPlayerRole(player)
    local character = player.Character
    if not character then return "Unknown" end
    
    -- Check backpack for killer items
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            local name = tool.Name:lower()
            if name:find("knife") or name:find("sword") or 
               name:find("weapon") or name:find("killer") or
               name:find("axe") or name:find("scythe") then
                return "KILLER"
            end
        end
    end
    
    -- Check character for tools
    if character then
        for _, child in pairs(character:GetChildren()) do
            if child:IsA("Tool") then
                local name = child.Name:lower()
                if name:find("knife") or name:find("sword") or 
                   name:find("weapon") or name:find("killer") then
                    return "KILLER"
                end
            end
        end
    end
    
    -- Team check
    if player.Team then
        local teamName = player.Team.Name:lower()
        if teamName:find("killer") or teamName:find("hunter") or teamName:find("monster") then
            return "KILLER"
        end
    end
    
    return "SURVIVOR"
end

local function UpdateESP(player)
    local espData = ESPObjects[player]
    if not espData or not ESPActive[player] then return end
    
    local character = player.Character
    if not character then
        for _, d in pairs(espData) do d.Visible = false end
        return
    end
    
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local head = character:FindFirstChild("Head")
    
    if not humanoid or not rootPart or not head then
        for _, d in pairs(espData) do d.Visible = false end
        return
    end
    
    local role = GetPlayerRole(player)
    local isKiller = role == "KILLER"
    
    if ESPSettings.KillerOnly and not isKiller then
        for _, d in pairs(espData) do d.Visible = false end
        return
    end
    
    local headPos = Camera:WorldToScreenPoint(head.Position)
    local rootPos = Camera:WorldToScreenPoint(rootPart.Position)
    
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local distance = myRoot and (myRoot.Position - rootPart.Position).Magnitude or 0
    
    if distance > ESPSettings.MaxDistance or headPos.Z <= 0 then
        for _, d in pairs(espData) do d.Visible = false end
        return
    end
    
    local color = isKiller and Theme.KillerRed or Theme.SurvivorGreen
    
    -- Box
    if ESPSettings.ShowBox then
        local boxSize = Vector2.new(1800 / distance, 3500 / distance)
        espData.Box.Size = boxSize
        espData.Box.Position = Vector2.new(headPos.X - boxSize.X/2, headPos.Y - boxSize.Y/2)
        espData.Box.Color = color
        espData.Box.Visible = true
    else
        espData.Box.Visible = false
    end
    
    -- Name
    if ESPSettings.ShowName then
        espData.NameTag.Text = player.DisplayName .. (ESPSettings.ShowRole and (" [" .. role .. "]") or "")
        espData.NameTag.Color = color
        espData.NameTag.Position = Vector2.new(headPos.X, headPos.Y + 14)
        espData.NameTag.Visible = true
    else
        espData.NameTag.Visible = false
    end
    
    -- Distance
    if ESPSettings.ShowDistance then
        espData.DistanceTag.Text = math.floor(distance) .. "s"
        espData.DistanceTag.Color = color
        espData.DistanceTag.Position = Vector2.new(headPos.X, headPos.Y + 26)
        espData.DistanceTag.Visible = true
    else
        espData.DistanceTag.Visible = false
    end
    
    -- Health
    if ESPSettings.ShowHealth then
        local hp = humanoid.Health / humanoid.MaxHealth
        local barW = 36
        espData.HealthBar.Size = Vector2.new(barW * hp, 3)
        espData.HealthBar.Position = Vector2.new(headPos.X - barW/2, headPos.Y - 18)
        espData.HealthBar.Color = Color3.fromRGB(255 * (1-hp), 255 * hp, 0)
        espData.HealthBar.Visible = true
    else
        espData.HealthBar.Visible = false
    end
    
    -- Tracers
    if ESPSettings.ShowTracers then
        local screenSize = Camera.ViewportSize
        espData.Tracer.From = Vector2.new(screenSize.X / 2, screenSize.Y)
        espData.Tracer.To = Vector2.new(rootPos.X, rootPos.Y)
        espData.Tracer.Color = color
        espData.Tracer.Visible = true
    else
        espData.Tracer.Visible = false
    end
end

-- ==================== BUILD UI SECTIONS ====================

-- ESP Section
ClaraUI:CreateSection(ContentFrame, "ðŸŽ¯ ESP SETTINGS")

local espToggles = {}
espToggles[1] = ClaraUI:CreateToggle(ContentFrame, "Master ESP", true, function(state)
    ESPSettings.Enabled = state
end)

espToggles[2] = ClaraUI:CreateToggle(ContentFrame, "Killer ESP Highlight", true, function(state)
    ESPSettings.ShowKillerESP = state
end)

espToggles[3] = ClaraUI:CreateToggle(ContentFrame, "Show Box", true, function(state)
    ESPSettings.ShowBox = state
end)

espToggles[4] = ClaraUI:CreateToggle(ContentFrame, "Show Name & Role", true, function(state)
    ESPSettings.ShowName = state
end)

espToggles[5] = ClaraUI:CreateToggle(ContentFrame, "Show Distance", true, function(state)
    ESPSettings.ShowDistance = state
end)

espToggles[6] = ClaraUI:CreateToggle(ContentFrame, "Show Health Bar", true, function(state)
    ESPSettings.ShowHealth = state
end)

espToggles[7] = ClaraUI:CreateToggle(ContentFrame, "Show Tracers", false, function(state)
    ESPSettings.ShowTracers = state
end)

espToggles[8] = ClaraUI:CreateToggle(ContentFrame, "Killer Only Mode", false, function(state)
    ESPSettings.KillerOnly = state
end)

-- Distance Slider
ClaraUI:CreateSection(ContentFrame, "ðŸ“ RANGE")

ClaraUI:CreateSlider(ContentFrame, "Max Distance", 500, 10000, 3000, function(value)
    ESPSettings.MaxDistance = value
end)

-- Info Section
ClaraUI:CreateSection(ContentFrame, "â¤ï¸ INFO")

local infoFrame = Instance.new("Frame")
infoFrame.Size = UDim2.new(1, -30, 0, 60)
infoFrame.Position = UDim2.new(0, 15, 0, 0)
infoFrame.BackgroundColor3 = Theme.Background
infoFrame.BorderSizePixel = 0
infoFrame.Parent = ContentFrame

local infoCorner = Instance.new("UICorner")
infoCorner.CornerRadius = UDim.new(0, 10)
infoCorner.Parent = infoFrame

local infoLabel = Instance.new("TextLabel")
infoLabel.Size = UDim2.new(1, -20, 1, 0)
infoLabel.Position = UDim2.new(0, 10, 0, 0)
infoLabel.BackgroundTransparency = 1
infoLabel.Text = "Clara Mobile v3.0 â™¡\nMade with love for NDO\nForsaken Killer ESP"
infoLabel.TextColor3 = Theme.TextDim
infoLabel.Font = Enum.Font.Gotham
infoLabel.TextSize = 11
infoLabel.TextXAlignment = Enum.TextXAlignment.Left
infoLabel.TextWrapped = true
infoLabel.Parent = infoFrame

-- Bottom padding
local padFrame = Instance.new("Frame")
padFrame.Size = UDim2.new(1, 0, 0, 20)
padFrame.BackgroundTransparency = 1
padFrame.Parent = ContentFrame

-- ==================== MOBILE FLOATING BUTTON ====================

local FloatButton = Instance.new("TextButton")
FloatButton.Size = UDim2.new(0, 45, 0, 45)
FloatButton.Position = UDim2.new(1, -60, 0.5, -22)
FloatButton.BackgroundColor3 = Theme.Accent
FloatButton.BorderSizePixel = 0
FloatButton.Text = "ðŸ’€"
FloatButton.TextSize = 20
FloatButton.Font = Enum.Font.GothamBold
FloatButton.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatButton.Parent = ScreenGui

local floatCorner = Instance.new("UICorner")
floatCorner.CornerRadius = UDim.new(1, 0)
floatCorner.Parent = FloatButton

-- Make float button draggable
local floatDragging = false
local floatDragStart = nil
local floatStartPos = nil

FloatButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        floatDragging = true
        floatDragStart = input.Position
        floatStartPos = FloatButton.Position
    end
end)

FloatButton.InputEnded:Connect(function(input)
    if floatDragging then
        local dist = (input.Position - floatDragStart).Magnitude
        if dist < 10 then
            -- It was a tap, toggle GUI
            MainFrame.Visible = not MainFrame.Visible
        end
        floatDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if floatDragging and input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - floatDragStart
        FloatButton.Position = UDim2.new(
            floatStartPos.X.Scale, 
            floatStartPos.X.Offset + delta.X,
            floatStartPos.Y.Scale,
            floatStartPos.Y.Offset + delta.Y
        )
    end
end)

-- ==================== INITIALIZATION ====================

local function Initialize()
    DeepBypass()
    
    -- Register existing players
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            CreateESPObject(player)
        end
    end
    
    Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            task.wait(1.5)
            CreateESPObject(player)
        end
    end)
    
    Players.PlayerRemoving:Connect(function(player)
        if ESPObjects[player] then
            for _, d in pairs(ESPObjects[player]) do
                pcall(function() d:Remove() end)
            end
            ESPObjects[player] = nil
            ESPActive[player] = nil
        end
    end)
    
    -- ESP Update Loop (Mobile-optimized frame skip)
    local frameCounter = 0
    local skipFrames = 2 -- Update every 3rd frame for mobile performance
    
    RunService.RenderStepped:Connect(function()
        if not ESPSettings.Enabled then return end
        
        frameCounter = frameCounter + 1
        if frameCounter < skipFrames then return end
        frameCounter = 0
        
        for player, _ in pairs(ESPActive) do
            pcall(function() UpdateESP(player) end)
        end
    end)
    
    -- Periodic bypass
    task.spawn(function()
        while true do
            task.wait(45)
            pcall(function()
                DeepBypass()
                game:GetService("LogService"):ClearLogs()
            end)
        end
    end)
    
    ClaraUI:Notify("Clara Mobile v3.0", "Forsaken Killer ESP Loaded! â™¡", 4)
end

-- ==================== EXECUTE ====================

local initSuccess, initErr = pcall(Initialize)
if not initSuccess then
    warn("Clara Mobile: Retrying init... " .. tostring(initErr))
    task.wait(2)
    pcall(Initialize)
end

-- Minimize functionality
local minimized = false
local originalSize = MainFrame.Size

minBtn.Activated:Connect(function()
    minimized = not minimized
    if minimized then
        MainFrame.Size = UDim2.new(0, 320, 0, 50)
        ContentFrame.Visible = false
    else
        MainFrame.Size = originalSize
        ContentFrame.Visible = true
    end
end)

print("âœ“ Clara Mobile v3.0 Loaded for NDO â™¡")
print("  â€¢ Mobile GUI: Active")
print("  â€¢ Killer ESP: Ready")
print("  â€¢ Anti-Cheat Bypass: Active")
print("  â€¢ Float Button: Tap to open/close")
print("  â€¢ Drag float button to reposition")

return {
    ESP = ESPSettings,
    Toggles = ClaraUI.Toggles,
    Notify = ClaraUI.Notify,
    ShowGUI = function() MainFrame.Visible = true end,
    HideGUI = function() MainFrame.Visible = false end,
}

--[[
    CLARA MOBILE v4.0 - FORSAKEN KILLER ESP
    Tối ưu cho Delta Exploit (Android)
    Làm bằng cả trái tim cho NDO ♡
    
    Tính năng:
    - ESP toàn màn hình (Billboard + Highlight)
    - Tự động nhận diện Killer/Survivor
    - Menu GUI bật/tắt từng chức năng
    - Nút nổi 💀 tiện lợi
    - Bypass chống hack của Forsaken & Roblox
]]

-- ==================== KHỞI TẠO DỊCH VỤ ====================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local CoreGui = game:GetService("CoreGui")
local StarterGui = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")

-- ==================== BYPASS CHỐNG HACK (DELTA) ====================
local function BypassAntiCheat()
    -- Vô hiệu hóa lệnh Kick
    pcall(function()
        local mt = getrawmetatable(game)
        if mt then
            local cu = mt.__namecall
            setreadonly(mt, false)
            mt.__namecall = newcclosure(function(self, ...)
                local method = getnamecallmethod()
                if method == "Kick" then
                    return wait(9e9) -- Chặn kick vĩnh viễn
                end
                return cu(self, ...)
            end)
            setreadonly(mt, true)
        end
    end)
    
    -- Bảo vệ GUI khỏi bị phát hiện
    pcall(function()
        syn.set_fflag and syn.set_fflag("AbuseReportScreenshot", false)
        syn.set_fflag and syn.set_fflag("AbuseReportScreenshotPercentage", 0)
        local gui = gethui and gethui() or CoreGui
        syn.protect_gui and syn.protect_gui(gui)
    end)
    
    -- Xóa nhật ký
    pcall(function()
        game:GetService("LogService"):ClearLogs()
    end)
end

-- ==================== HỆ THỐNG ESP ====================
local ESP = {
    CaiDat = {
        BatTat = true,           -- Bật/tắt toàn bộ ESP
        HienKhung = true,        -- Hiện khung box
        HienTen = true,          -- Hiện tên người chơi
        HienKhoangCach = true,   -- Hiện khoảng cách
        HienMau = true,          -- Hiện thanh máu
        HienVaiTro = true,       -- Hiện vai trò (Killer/Survivor)
        ChiHienKiller = false,   -- Chỉ hiện Killer
        KhoangCachToiDa = 3000,  -- Khoảng cách hiển thị tối đa
    },
    DangHoatDong = {}
}

-- Hàm nhận diện vai trò (Killer hay Survivor)
function ESP.LayVaiTro(player)
    local nhanVat = player.Character
    if not nhanVat then return "SURVIVOR" end
    
    -- Kiểm tra ba lô
    local baLo = player:FindFirstChild("Backpack")
    if baLo then
        for _, dungCu in pairs(baLo:GetChildren()) do
            local ten = dungCu.Name:lower()
            if ten:find("knife") or ten:find("dao") or ten:find("sword") or 
               ten:find("kiem") or ten:find("killer") or ten:find("axe") or 
               ten:find("riu") then
                return "KILLER"
            end
        end
    end
    
    -- Kiểm tra dụng cụ trên tay
    for _, con in pairs(nhanVat:GetChildren()) do
        if con:IsA("Tool") then
            local ten = con.Name:lower()
            if ten:find("knife") or ten:find("dao") or ten:find("sword") or 
               ten:find("kiem") or ten:find("weapon") or ten:find("vukhi") then
                return "KILLER"
            end
        end
    end
    
    -- Kiểm tra team
    if player.Team then
        local tenTeam = player.Team.Name:lower()
        if tenTeam:find("killer") or tenTeam:find("hunter") or tenTeam:find("satthu") then
            return "KILLER"
        end
    end
    
    return "SURVIVOR"
end

-- Tạo ESP cho một người chơi
function ESP.TaoESP(player)
    if ESP.DangHoatDong[player] then return end
    
    -- Tạo thư mục chứa
    local thuMuc = Instance.new("Folder")
    thuMuc.Name = "ClaraESP_" .. player.UserId
    thuMuc.Parent = CoreGui
    
    -- Tạo Billboard GUI (bảng thông tin nổi trên đầu)
    local bang = Instance.new("BillboardGui")
    bang.Name = "BangChinh"
    bang.AlwaysOnTop = true
    bang.Size = UDim2.new(0, 200, 0, 300)
    bang.StudsOffset = Vector3.new(0, 2.5, 0)
    bang.MaxDistance = ESP.CaiDat.KhoangCachToiDa
    bang.Adornee = player.Character and player.Character:FindFirstChild("Head")
    bang.Parent = thuMuc
    
    -- Khung viền (Box)
    local khung = Instance.new("Frame")
    khung.Name = "Khung"
    khung.Size = UDim2.new(1, 0, 1, 0)
    khung.BackgroundTransparency = 1
    khung.BorderSizePixel = 2
    khung.BorderColor3 = Color3.fromRGB(255, 60, 60)
    khung.Visible = ESP.CaiDat.HienKhung
    khung.Parent = bang
    
    -- Nhãn tên
    local nhanTen = Instance.new("TextLabel")
    nhanTen.Name = "Ten"
    nhanTen.Size = UDim2.new(1, 0, 0, 18)
    nhanTen.Position = UDim2.new(0, 0, 0, -24)
    nhanTen.BackgroundTransparency = 1
    nhanTen.Text = player.DisplayName
    nhanTen.TextColor3 = Color3.fromRGB(255, 255, 255)
    nhanTen.TextStrokeTransparency = 0
    nhanTen.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nhanTen.Font = Enum.Font.GothamBold
    nhanTen.TextSize = 12
    nhanTen.TextXAlignment = Enum.TextXAlignment.Center
    nhanTen.Visible = ESP.CaiDat.HienTen
    nhanTen.Parent = bang
    
    -- Nhãn khoảng cách
    local nhanKC = Instance.new("TextLabel")
    nhanKC.Name = "KhoangCach"
    nhanKC.Size = UDim2.new(1, 0, 0, 16)
    nhanKC.Position = UDim2.new(0, 0, 0, -6)
    nhanKC.BackgroundTransparency = 1
    nhanKC.Text = ""
    nhanKC.TextColor3 = Color3.fromRGB(200, 200, 200)
    nhanKC.TextStrokeTransparency = 0
    nhanKC.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nhanKC.Font = Enum.Font.Gotham
    nhanKC.TextSize = 10
    nhanKC.TextXAlignment = Enum.TextXAlignment.Center
    nhanKC.Visible = ESP.CaiDat.HienKhoangCach
    nhanKC.Parent = bang
    
    -- Thanh máu (nền)
    local nenMau = Instance.new("Frame")
    nenMau.Name = "NenMau"
    nenMau.Size = UDim2.new(1, 0, 0, 4)
    nenMau.Position = UDim2.new(0, 0, 1, 6)
    nenMau.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    nenMau.BorderSizePixel = 0
    nenMau.Visible = ESP.CaiDat.HienMau
    nenMau.Parent = bang
    
    -- Thanh máu (đầy)
    local dayMau = Instance.new("Frame")
    dayMau.Name = "DayMau"
    dayMau.Size = UDim2.new(1, 0, 1, 0)
    dayMau.BackgroundColor3 = Color3.fromRGB(0, 255, 60)
    dayMau.BorderSizePixel = 0
    dayMau.Parent = nenMau
    
    -- Nhãn vai trò
    local nhanVT = Instance.new("TextLabel")
    nhanVT.Name = "VaiTro"
    nhanVT.Size = UDim2.new(1, 0, 0, 16)
    nhanVT.Position = UDim2.new(0, 0, 1, 12)
    nhanVT.BackgroundTransparency = 1
    nhanVT.Text = ""
    nhanVT.TextColor3 = Color3.fromRGB(255, 180, 40)
    nhanVT.TextStrokeTransparency = 0
    nhanVT.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nhanVT.Font = Enum.Font.GothamBold
    nhanVT.TextSize = 10
    nhanVT.TextXAlignment = Enum.TextXAlignment.Center
    nhanVT.Visible = ESP.CaiDat.HienVaiTro
    nhanVT.Parent = bang
    
    -- Hiệu ứng Highlight (nhìn xuyên tường)
    local highlight = Instance.new("Highlight")
    highlight.Name = "HighlightXuyenTuong"
    highlight.FillTransparency = 0.7
    highlight.OutlineTransparency = 0
    highlight.OutlineColor = Color3.fromRGB(255, 60, 60)
    highlight.FillColor = Color3.fromRGB(255, 60, 60)
    highlight.Enabled = false
    highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    highlight.Parent = thuMuc
    
    -- Lưu dữ liệu ESP
    ESP.DangHoatDong[player] = {
        ThuMuc = thuMuc,
        Bang = bang,
        Khung = khung,
        Ten = nhanTen,
        KhoangCach = nhanKC,
        NenMau = nenMau,
        DayMau = dayMau,
        VaiTro = nhanVT,
        Highlight = highlight,
    }
    
    -- Gán vào đầu nhân vật
    local nhanVat = player.Character
    if nhanVat then
        local dau = nhanVat:FindFirstChild("Head")
        if dau then
            bang.Adornee = dau
            highlight.Adornee = nhanVat
        end
    end
    
    -- Lắng nghe khi nhân vật được tạo lại
    player.CharacterAdded:Connect(function(nv)
        task.wait(0.5)
        local dau = nv:FindFirstChild("Head")
        if dau and bang then
            bang.Adornee = dau
        end
        if highlight then
            highlight.Adornee = nv
        end
    end)
end

-- Cập nhật ESP
function ESP.CapNhat(player)
    local duLieu = ESP.DangHoatDong[player]
    if not duLieu then return end
    
    local nhanVat = player.Character
    if not nhanVat then
        if duLieu.Bang then duLieu.Bang.Adornee = nil end
        if duLieu.Highlight then duLieu.Highlight.Adornee = nil end
        return
    end
    
    local humanoid = nhanVat:FindFirstChildOfClass("Humanoid")
    local goc = nhanVat:FindFirstChild("HumanoidRootPart")
    local dau = nhanVat:FindFirstChild("Head")
    
    if not humanoid or not goc or not dau then
        if duLieu.Bang then duLieu.Bang.Adornee = nil end
        return
    end
    
    -- Đảm bảo gán đúng đối tượng
    if duLieu.Bang and duLieu.Bang.Adornee ~= dau then
        duLieu.Bang.Adornee = dau
    end
    if duLieu.Highlight and duLieu.Highlight.Adornee ~= nhanVat then
        duLieu.Highlight.Adornee = nhanVat
    end
    
    local vaiTro = ESP.LayVaiTro(player)
    local laKiller = vaiTro == "KILLER"
    
    -- Tính khoảng cách
    local gocCuaToi = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local khoangCach = gocCuaToi and (gocCuaToi.Position - goc.Position).Magnitude or 0
    
    -- Kiểm tra khoảng cách tối đa
    if khoangCach > ESP.CaiDat.KhoangCachToiDa then
        duLieu.Bang.Enabled = false
        duLieu.Highlight.Enabled = false
        return
    end
    
    -- Chế độ chỉ hiện Killer
    if ESP.CaiDat.ChiHienKiller and not laKiller then
        duLieu.Bang.Enabled = false
        duLieu.Highlight.Enabled = false
        return
    end
    
    duLieu.Bang.Enabled = ESP.CaiDat.BatTat
    duLieu.Bang.MaxDistance = ESP.CaiDat.KhoangCachToiDa
    
    -- Màu sắc theo vai trò
    local mauChinh = laKiller and Color3.fromRGB(255, 45, 45) or Color3.fromRGB(45, 255, 85)
    
    -- Cập nhật khung
    duLieu.Khung.BorderColor3 = mauChinh
    duLieu.Khung.Visible = ESP.CaiDat.HienKhung
    
    -- Cập nhật tên
    duLieu.Ten.Text = player.DisplayName
    duLieu.Ten.TextColor3 = mauChinh
    duLieu.Ten.Visible = ESP.CaiDat.HienTen
    
    -- Cập nhật khoảng cách
    duLieu.KhoangCach.Text = math.floor(khoangCach) .. " studs"
    duLieu.KhoangCach.Visible = ESP.CaiDat.HienKhoangCach
    
    -- Cập nhật máu
    local phanTramMau = humanoid.Health / humanoid.MaxHealth
    duLieu.DayMau.Size = UDim2.new(phanTramMau, 0, 1, 0)
    duLieu.DayMau.BackgroundColor3 = Color3.fromRGB(255 * (1-phanTramMau), 255 * phanTramMau, 0)
    duLieu.NenMau.Visible = ESP.CaiDat.HienMau
    duLieu.DayMau.Visible = ESP.CaiDat.HienMau
    
    -- Cập nhật vai trò
    duLieu.VaiTro.Text = "[" .. vaiTro .. "]"
    duLieu.VaiTro.Visible = ESP.CaiDat.HienVaiTro
    
    -- Cập nhật Highlight
    duLieu.Highlight.OutlineColor = mauChinh
    duLieu.Highlight.FillColor = mauChinh
    duLieu.Highlight.Enabled = ESP.CaiDat.BatTat and ESP.CaiDat.HienKhung
end

-- Xóa ESP
function ESP.Xoa(player)
    local duLieu = ESP.DangHoatDong[player]
    if duLieu then
        pcall(function() duLieu.ThuMuc:Destroy() end)
        ESP.DangHoatDong[player] = nil
    end
end

-- ==================== GIAO DIỆN GUI MOBILE ====================
local function TaoGiaoDien()
    -- Tìm nơi an toàn để hiển thị GUI (tương thích Delta)
    local cha
    pcall(function()
        cha = gethui and gethui() or CoreGui
    end)
    if not cha then cha = CoreGui end
    
    local GuiChinh = Instance.new("ScreenGui")
    GuiChinh.Name = "ClaraDeltaGUI"
    GuiChinh.Parent = cha
    GuiChinh.ResetOnSpawn = false
    GuiChinh.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    
    pcall(function()
        syn.protect_gui and syn.protect_gui(GuiChinh)
    end)
    
    -- Bảng màu chủ đề
    local M = {
        Nen = Color3.fromRGB(18, 18, 22),
        NenPhu = Color3.fromRGB(28, 28, 35),
        Do = Color3.fromRGB(200, 50, 50),
        DoNhat = Color3.fromRGB(240, 70, 70),
        Vang = Color3.fromRGB(255, 185, 40),
        Chu = Color3.fromRGB(220, 220, 225),
        ChuMo = Color3.fromRGB(130, 130, 140),
        XanhLa = Color3.fromRGB(40, 200, 80),
    }
    
    -- Khung chính
    local KhungChinh = Instance.new("Frame")
    KhungChinh.Size = UDim2.new(0, 310, 0, 440)
    KhungChinh.Position = UDim2.new(0.5, -155, 0.5, -220)
    KhungChinh.BackgroundColor3 = M.Nen
    KhungChinh.BorderSizePixel = 0
    KhungChinh.Visible = true
    KhungChinh.Parent = GuiChinh
    
    local boGoc = Instance.new("UICorner")
    boGoc.CornerRadius = UDim.new(0, 14)
    boGoc.Parent = KhungChinh
    
    -- Thanh tiêu đề
    local ThanhTren = Instance.new("Frame")
    ThanhTren.Size = UDim2.new(1, 0, 0, 48)
    ThanhTren.BackgroundColor3 = M.NenPhu
    ThanhTren.BorderSizePixel = 0
    ThanhTren.Parent = KhungChinh
    
    local boGocTren = Instance.new("UICorner")
    boGocTren.CornerRadius = UDim.new(0, 14)
    boGocTren.Parent = ThanhTren
    
    local suaGoc = Instance.new("Frame")
    suaGoc.Size = UDim2.new(1, 0, 0, 14)
    suaGoc.Position = UDim2.new(0, 0, 1, -14)
    suaGoc.BackgroundColor3 = M.NenPhu
    suaGoc.BorderSizePixel = 0
    suaGoc.Parent = ThanhTren
    
    -- Tiêu đề
    local tieuDe = Instance.new("TextLabel")
    tieuDe.Size = UDim2.new(1, -50, 1, 0)
    tieuDe.Position = UDim2.new(0, 15, 0, 0)
    tieuDe.BackgroundTransparency = 1
    tieuDe.Text = "Clara v4  ♡  NDO"
    tieuDe.TextColor3 = M.Vang
    tieuDe.Font = Enum.Font.GothamBlack
    tieuDe.TextSize = 14
    tieuDe.TextXAlignment = Enum.TextXAlignment.Left
    tieuDe.Parent = ThanhTren
    
    -- Nút đóng
    local nutDong = Instance.new("TextButton")
    nutDong.Size = UDim2.new(0, 30, 0, 30)
    nutDong.Position = UDim2.new(1, -38, 0.5, -15)
    nutDong.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    nutDong.BorderSizePixel = 0
    nutDong.Text = "✕"
    nutDong.TextColor3 = Color3.fromRGB(255, 255, 255)
    nutDong.Font = Enum.Font.GothamBold
    nutDong.TextSize = 14
    nutDong.Parent = ThanhTren
    
    local boNutDong = Instance.new("UICorner")
    boNutDong.CornerRadius = UDim.new(1, 0)
    boNutDong.Parent = nutDong
    
    nutDong.Activated:Connect(function()
        KhungChinh.Visible = false
    end)
    
    -- Khung cuộn nội dung
    local KhungCuon = Instance.new("ScrollingFrame")
    KhungCuon.Size = UDim2.new(1, 0, 1, -48)
    KhungCuon.Position = UDim2.new(0, 0, 0, 48)
    KhungCuon.BackgroundTransparency = 1
    KhungCuon.BorderSizePixel = 0
    KhungCuon.ScrollBarThickness = 3
    KhungCuon.ScrollBarImageColor3 = M.Do
    KhungCuon.CanvasSize = UDim2.new(0, 0, 0, 700)
    KhungCuon.Parent = KhungChinh
    
    local danhSach = Instance.new("UIListLayout")
    danhSach.Padding = UDim.new(0, 6)
    danhSach.Parent = KhungCuon
    
    -- Đệm trên
    local dem1 = Instance.new("Frame")
    dem1.Size = UDim2.new(1, 0, 0, 8)
    dem1.BackgroundTransparency = 1
    dem1.Parent = KhungCuon
    
    -- Hàm tạo mục
    local function TaoMuc(chu)
        local muc = Instance.new("Frame")
        muc.Size = UDim2.new(1, -20, 0, 26)
        muc.BackgroundTransparency = 1
        muc.Parent = KhungCuon
        
        local vach = Instance.new("Frame")
        vach.Size = UDim2.new(0, 20, 0, 1)
        vach.Position = UDim2.new(0, 10, 0.5, 0)
        vach.BackgroundColor3 = M.Do
        vach.BorderSizePixel = 0
        vach.Parent = muc
        
        local nhan = Instance.new("TextLabel")
        nhan.Size = UDim2.new(0, 0, 1, 0)
        nhan.Position = UDim2.new(0, 38, 0, 0)
        nhan.BackgroundTransparency = 1
        nhan.Text = chu
        nhan.TextColor3 = M.ChuMo
        nhan.Font = Enum.Font.GothamBold
        nhan.TextSize = 10
        nhan.TextXAlignment = Enum.TextXAlignment.Left
        nhan.AutomaticSize = Enum.AutomaticSize.X
        nhan.Parent = muc
        
        return muc
    end
    
    -- Hàm tạo nút bật/tắt
    local function TaoNutBatTat(ten, macDinh, hamGoiLai)
        local khung = Instance.new("Frame")
        khung.Size = UDim2.new(1, -24, 0, 42)
        khung.BackgroundColor3 = M.Nen
        khung.BorderSizePixel = 0
        khung.Parent = KhungCuon
        
        local bg = Instance.new("UICorner")
        bg.CornerRadius = UDim.new(0, 10)
        bg.Parent = khung
        
        local nhan = Instance.new("TextLabel")
        nhan.Size = UDim2.new(0.6, 0, 1, 0)
        nhan.Position = UDim2.new(0, 12, 0, 0)
        nhan.BackgroundTransparency = 1
        nhan.Text = ten
        nhan.TextColor3 = M.Chu
        nhan.Font = Enum.Font.GothamSemibold
        nhan.TextSize = 12
        nhan.TextXAlignment = Enum.TextXAlignment.Left
        nhan.Parent = khung
        
        -- Nền công tắc
        local congTacNen = Instance.new("Frame")
        congTacNen.Size = UDim2.new(0, 46, 0, 24)
        congTacNen.Position = UDim2.new(1, -58, 0.5, -12)
        congTacNen.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
        congTacNen.BorderSizePixel = 0
        congTacNen.Parent = khung
        
        local bcn = Instance.new("UICorner")
        bcn.CornerRadius = UDim.new(1, 0)
        bcn.Parent = congTacNen
        
        -- Núm công tắc
        local num = Instance.new("Frame")
        num.Size = UDim2.new(0, 18, 0, 18)
        num.Position = UDim2.new(0, 3, 0.5, -9)
        num.BackgroundColor3 = Color3.fromRGB(170, 170, 175)
        num.BorderSizePixel = 0
        num.Parent = congTacNen
        
        local bnum = Instance.new("UICorner")
        bnum.CornerRadius = UDim.new(1, 0)
        bnum.Parent = num
        
        local nutBam = Instance.new("TextButton")
        nutBam.Size = UDim2.new(0, 65, 1, 0)
        nutBam.Position = UDim2.new(1, -70, 0, 0)
        nutBam.BackgroundTransparency = 1
        nutBam.Text = ""
        nutBam.Parent = khung
        
        local trangThai = macDinh
        
        local function CapNhatHienThi()
            if trangThai then
                congTacNen.BackgroundColor3 = M.Do
                num.Position = UDim2.new(0, 25, 0.5, -9)
                num.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            else
                congTacNen.BackgroundColor3 = Color3.fromRGB(55, 55, 60)
                num.Position = UDim2.new(0, 3, 0.5, -9)
                num.BackgroundColor3 = Color3.fromRGB(170, 170, 175)
            end
        end
        
        CapNhatHienThi()
        
        nutBam.Activated:Connect(function()
            trangThai = not trangThai
            CapNhatHienThi()
            hamGoiLai(trangThai)
        end)
        
        return {Khung = khung, DatTrangThai = function(tt) trangThai = tt; CapNhatHienThi(); hamGoiLai(tt) end}
    end
    
    -- === XÂY DỰNG CÁC MỤC GIAO DIỆN ===
    
    TaoMuc("🎯 CÀI ĐẶT ESP")
    
    local nutTong = TaoNutBatTat("Bật/Tắt ESP", true, function(tt)
        ESP.CaiDat.BatTat = tt
    end)
    
    TaoNutBatTat("Hiện Khung", true, function(tt)
        ESP.CaiDat.HienKhung = tt
    end)
    
    TaoNutBatTat("Hiện Tên", true, function(tt)
        ESP.CaiDat.HienTen = tt
    end)
    
    TaoNutBatTat("Hiện Khoảng Cách", true, function(tt)
        ESP.CaiDat.HienKhoangCach = tt
    end)
    
    TaoNutBatTat("Hiện Thanh Máu", true, function(tt)
        ESP.CaiDat.HienMau = tt
    end)
    
    TaoNutBatTat("Hiện Vai Trò", true, function(tt)
        ESP.CaiDat.HienVaiTro = tt
    end)
    
    TaoNutBatTat("Chỉ Hiện Killer", false, function(tt)
        ESP.CaiDat.ChiHienKiller = tt
    end)
    
    TaoMuc("⚙️ KHÁC")
    
    -- Nút làm mới ESP
    local khungLamMoi = Instance.new("Frame")
    khungLamMoi.Size = UDim2.new(1, -24, 0, 42)
    khungLamMoi.BackgroundColor3 = M.Nen
    khungLamMoi.BorderSizePixel = 0
    khungLamMoi.Parent = KhungCuon
    
    local blm = Instance.new("UICorner")
    blm.CornerRadius = UDim.new(0, 10)
    blm.Parent = khungLamMoi
    
    local nutLamMoi = Instance.new("TextButton")
    nutLamMoi.Size = UDim2.new(1, 0, 1, 0)
    nutLamMoi.BackgroundColor3 = M.Do
    nutLamMoi.BorderSizePixel = 0
    nutLamMoi.Text = "🔄 Làm Mới ESP"
    nutLamMoi.TextColor3 = Color3.fromRGB(255, 255, 255)
    nutLamMoi.Font = Enum.Font.GothamBold
    nutLamMoi.TextSize = 13
    nutLamMoi.Parent = khungLamMoi
    
    local bnlm = Instance.new("UICorner")
    bnlm.CornerRadius = UDim.new(0, 10)
    bnlm.Parent = nutLamMoi
    
    nutLamMoi.Activated:Connect(function()
        for _, nguoiChoi in pairs(Players:GetPlayers()) do
            if nguoiChoi ~= LocalPlayer then
                ESP.Xoa(nguoiChoi)
                task.wait(0.1)
                ESP.TaoESP(nguoiChoi)
            end
        end
    end)
    
    TaoMuc("💀 KHOẢNG CÁCH")
    
    -- Điều chỉnh khoảng cách
    local khungKC = Instance.new("Frame")
    khungKC.Size = UDim2.new(1, -24, 0, 55)
    khungKC.BackgroundColor3 = M.Nen
    khungKC.BorderSizePixel = 0
    khungKC.Parent = KhungCuon
    
    local bkc = Instance.new("UICorner")
    bkc.CornerRadius = UDim.new(0, 10)
    bkc.Parent = khungKC
    
    local nhanKC = Instance.new("TextLabel")
    nhanKC.Size = UDim2.new(0.5, 0, 0, 18)
    nhanKC.Position = UDim2.new(0, 12, 0, 5)
    nhanKC.BackgroundTransparency = 1
    nhanKC.Text = "Khoảng cách tối đa: 3000"
    nhanKC.TextColor3 = M.Chu
    nhanKC.Font = Enum.Font.GothamSemibold
    nhanKC.TextSize = 11
    nhanKC.TextXAlignment = Enum.TextXAlignment.Left
    nhanKC.Parent = khungKC
    
    local giaTriKC = Instance.new("TextLabel")
    giaTriKC.Size = UDim2.new(0, 40, 0, 18)
    giaTriKC.Position = UDim2.new(1, -52, 0, 5)
    giaTriKC.BackgroundTransparency = 1
    giaTriKC.Text = "3000"
    giaTriKC.TextColor3 = M.DoNhat
    giaTriKC.Font = Enum.Font.GothamBold
    giaTriKC.TextSize = 11
    giaTriKC.TextXAlignment = Enum.TextXAlignment.Right
    giaTriKC.Parent = khungKC
    
    -- Nút giảm
    local nutGiam = Instance.new("TextButton")
    nutGiam.Size = UDim2.new(0, 35, 0, 24)
    nutGiam.Position = UDim2.new(0, 12, 0, 25)
    nutGiam.BackgroundColor3 = M.NenPhu
    nutGiam.BorderSizePixel = 0
    nutGiam.Text = "−"
    nutGiam.TextColor3 = M.Chu
    nutGiam.Font = Enum.Font.GothamBold
    nutGiam.TextSize = 16
    nutGiam.Parent = khungKC
    
    local bng = Instance.new("UICorner")
    bng.CornerRadius = UDim.new(0, 6)
    bng.Parent = nutGiam
    
    -- Nút tăng
    local nutTang = Instance.new("TextButton")
    nutTang.Size = UDim2.new(0, 35, 0, 24)
    nutTang.Position = UDim2.new(1, -47, 0, 25)
    nutTang.BackgroundColor3 = M.NenPhu
    nutTang.BorderSizePixel = 0
    nutTang.Text = "+"
    nutTang.TextColor3 = M.Chu
    nutTang.Font = Enum.Font.GothamBold
    nutTang.TextSize = 16
    nutTang.Parent = khungKC
    
    local bnt = Instance.new("UICorner")
    bnt.CornerRadius = UDim.new(0, 6)
    bnt.Parent = nutTang
    
    -- Thanh điền đầy khoảng cách
    local thanhNen = Instance.new("Frame")
    thanhNen.Size = UDim2.new(1, -106, 0, 24)
    thanhNen.Position = UDim2.new(0, 53, 0, 25)
    thanhNen.BackgroundColor3 = M.NenPhu
    thanhNen.BorderSizePixel = 0
    thanhNen.Parent = khungKC
    
    local btn = Instance.new("UICorner")
    btn.CornerRadius = UDim.new(0, 6)
    btn.Parent = thanhNen
    
    local thanhDay = Instance.new("Frame")
    thanhDay.Size = UDim2.new(0.3, 0, 1, 0)
    thanhDay.BackgroundColor3 = M.Do
    thanhDay.BorderSizePixel = 0
    thanhDay.Parent = thanhNen
    
    local btd = Instance.new("UICorner")
    btd.CornerRadius = UDim.new(0, 6)
    btd.Parent = thanhDay
    
    local kcHienTai = 3000
    local function CapNhatKhoangCach(giaTri)
        kcHienTai = math.clamp(giaTri, 500, 10000)
        kcHienTai = math.floor(kcHienTai / 100) * 100
        ESP.CaiDat.KhoangCachToiDa = kcHienTai
        nhanKC.Text = "Khoảng cách tối đa: " .. kcHienTai
        giaTriKC.Text = tostring(kcHienTai)
        local tiLe = (kcHienTai - 500) / 9500
        thanhDay.Size = UDim2.new(tiLe, 0, 1, 0)
    end
    
    nutGiam.Activated:Connect(function()
        CapNhatKhoangCach(kcHienTai - 500)
    end)
    
    nutTang.Activated:Connect(function()
        CapNhatKhoangCach(kcHienTai + 500)
    end)
    
    TaoMuc("♡ THÔNG TIN")
    
    local khungTT = Instance.new("Frame")
    khungTT.Size = UDim2.new(1, -24, 0, 50)
    khungTT.BackgroundColor3 = M.Nen
    khungTT.BorderSizePixel = 0
    khungTT.Parent = KhungCuon
    
    local btt = Instance.new("UICorner")
    btt.CornerRadius = UDim.new(0, 10)
    btt.Parent = khungTT
    
    local nhanTT = Instance.new("TextLabel")
    nhanTT.Size = UDim2.new(1, -16, 1, 0)
    nhanTT.Position = UDim2.new(0, 8, 0, 0)
    nhanTT.BackgroundTransparency = 1
    nhanTT.Text = "Clara Mobile v4.0 ♡\nTối ưu cho Delta\nForsaken Killer ESP"
    nhanTT.TextColor3 = M.ChuMo
    nhanTT.Font = Enum.Font.Gotham
    nhanTT.TextSize = 10
    nhanTT.TextXAlignment = Enum.TextXAlignment.Left
    nhanTT.TextWrapped = true
    nhanTT.Parent = khungTT
    
    -- Đệm dưới
    local dem2 = Instance.new("Frame")
    dem2.Size = UDim2.new(1, 0, 0, 20)
    dem2.BackgroundTransparency = 1
    dem2.Parent = KhungCuon
    
    -- ==================== NÚT NỔI 💀 ====================
    local nutNoi = Instance.new("TextButton")
    nutNoi.Size = UDim2.new(0, 42, 0, 42)
    nutNoi.Position = UDim2.new(1, -55, 0.7, 0)
    nutNoi.BackgroundColor3 = M.Do
    nutNoi.BorderSizePixel = 0
    nutNoi.Text = "💀"
    nutNoi.TextSize = 18
    nutNoi.Font = Enum.Font.GothamBold
    nutNoi.TextColor3 = Color3.fromRGB(255, 255, 255)
    nutNoi.Parent = GuiChinh
    
    local bnn = Instance.new("UICorner")
    bnn.CornerRadius = UDim.new(1, 0)
    bnn.Parent = nutNoi
    
    nutNoi.Activated:Connect(function()
        KhungChinh.Visible = not KhungChinh.Visible
    end)
    
    return GuiChinh, KhungChinh
end

-- ==================== KHỞI CHẠY CHÍNH ====================
local function KhoiChay()
    -- Chạy bypass
    BypassAntiCheat()
    
    -- Tạo giao diện
    local gui, khungChinh = TaoGiaoDien()
    
    -- Đăng ký người chơi hiện có
    for _, nguoiChoi in pairs(Players:GetPlayers()) do
        if nguoiChoi ~= LocalPlayer then
            ESP.TaoESP(nguoiChoi)
        end
    end
    
    -- Khi có người chơi mới
    Players.PlayerAdded:Connect(function(nguoiChoi)
        if nguoiChoi ~= LocalPlayer then
            task.wait(1)
            ESP.TaoESP(nguoiChoi)
        end
    end)
    
    -- Khi người chơi thoát
    Players.PlayerRemoving:Connect(function(nguoiChoi)
        ESP.Xoa(nguoiChoi)
    end)
    
    -- Vòng lặp cập nhật ESP
    RunService.RenderStepped:Connect(function()
        if not ESP.CaiDat.BatTat then
            -- Tắt tất cả bảng hiệu
            for nguoiChoi, duLieu in pairs(ESP.DangHoatDong) do
                if duLieu.Bang then
                    duLieu.Bang.Enabled = false
                end
                if duLieu.Highlight then
                    duLieu.Highlight.Enabled = false
                end
            end
            return
        end
        
        for nguoiChoi, _ in pairs(ESP.DangHoatDong) do
            pcall(function() ESP.CapNhat(nguoiChoi) end)
        end
    end)
    
    -- Bypass định kỳ
    task.spawn(function()
        while true do
            task.wait(60)
            pcall(function()
                BypassAntiCheat()
                game:GetService("LogService"):ClearLogs()
            end)
        end
    end)
    
    -- Thông báo thành công
    task.wait(0.5)
    StarterGui:SetCore("SendNotification", {
        Title = "Clara Mobile v4.0 ♡",
        Text = "Forsaken Killer ESP đã sẵn sàng!",
        Duration = 5,
    })
    
    print("✓ Clara Mobile v4.0 - Tối ưu Delta")
    print("  • ESP Bảng hiệu: Đã bật")
    print("  • Highlight Xuyên Tường: Đã bật")  
    print("  • Giao diện: Chạm 💀 để mở/tắt")
    print("  • Làm bằng cả trái tim cho NDO ♡")
end

-- ==================== THỰC THI ====================
pcall(function()
    KhoiChay()
end)

-- Dự phòng nếu lỗi
task.spawn(function()
    if not next(ESP.DangHoatDong) then
        task.wait(2)
        pcall(function()
            BypassAntiCheat()
            KhoiChay()
        end)
    end
end)

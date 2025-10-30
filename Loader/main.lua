local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local StarterGui = game:GetService("StarterGui")
local player = Players.LocalPlayer

local urlVip = "https://raw.githubusercontent.com/putraborz/VerifikasiScWata/refs/heads/main/Loader/vip.txt"
local urlSatuan = "https://raw.githubusercontent.com/putraborz/VerifikasiScWata/refs/heads/main/Loader/8.txt"

local successUrls = {
    "https://raw.githubusercontent.com/putraborz/WataXMountAtin/main/Loader/WataX.lua",
    "https://raw.githubusercontent.com/putraborz/WataXMount700YntKts/refs/heads/main/Loader/mainmap437.lua"
}

local TIKTOK_LINK = "https://www.tiktok.com/"
local DISCORD_LINK = "https://discord.gg/"

-- Fungsi ambil data dari URL
local function fetch(url)
    local ok, res = pcall(function()
        return game:HttpGet(url, true)
    end)
    return ok and res or nil
end

-- Fungsi verifikasi username
local function isVerified(uname)
    local vip = fetch(urlVip)
    local sat = fetch(urlSatuan)
    if not vip or not sat then return false end
    uname = uname:lower()

    local function checkList(list)
        for line in list:gmatch("[^\r\n]+") do
            local nameOnly = line:match("^(.-)%s*%-%-") or line
            nameOnly = nameOnly:match("^%s*(.-)%s*$")
            if nameOnly:lower() == uname then
                return true
            end
        end
        return false
    end
    return checkList(vip) or checkList(sat)
end

-- Fungsi notifikasi
local function notify(title, text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = title or "Info",
            Text = text or "",
            Duration = duration or 4
        })
    end)
end

-- GUI Utama
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "LexLoader"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 320, 0, 200)
frame.Position = UDim2.new(0.5, -160, 0.5, -100)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

-- 🌈 Garis RGB di tepi
local stroke = Instance.new("UIStroke", frame)
stroke.Thickness = 2
stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
stroke.LineJoinMode = Enum.LineJoinMode.Round
task.spawn(function()
    local hue = 0
    while task.wait(0.03) do
        hue = (hue + 1) % 360
        stroke.Color = Color3.fromHSV(hue / 360, 1, 1)
    end
end)

-- Fade-in efek saat GUI muncul
frame.BackgroundTransparency = 1
TweenService:Create(frame, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {BackgroundTransparency = 0}):Play()

-- ❌ Tombol close
local closeBtn = Instance.new("TextButton", frame)
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 18
closeBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
closeBtn.MouseButton1Click:Connect(function()
    TweenService:Create(frame, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    task.wait(0.4)
    gui:Destroy()
end)

-- 🌀 Logo teks RGB “LEXHOST”
local lexLogo = Instance.new("TextLabel", frame)
lexLogo.Text = "LEXHOST"
lexLogo.Font = Enum.Font.GothamBlack
lexLogo.TextSize = 16
lexLogo.Position = UDim2.new(1, -100, 0, 8)
lexLogo.Size = UDim2.new(0, 90, 0, 20)
lexLogo.BackgroundTransparency = 1
lexLogo.TextColor3 = Color3.fromRGB(255, 255, 255)

task.spawn(function()
    local hue = 0
    while task.wait(0.05) do
        hue = (hue + 2) % 360
        lexLogo.TextColor3 = Color3.fromHSV(hue / 360, 1, 1)
    end
end)

-- Avatar & Username
local avatar = Instance.new("ImageLabel", frame)
avatar.Size = UDim2.new(0, 64, 0, 64)
avatar.Position = UDim2.new(0, 20, 0, 40)
avatar.BackgroundTransparency = 1

local unameLabel = Instance.new("TextLabel", frame)
unameLabel.Position = UDim2.new(0, 100, 0, 55)
unameLabel.Size = UDim2.new(1, -120, 0, 30)
unameLabel.BackgroundTransparency = 1
unameLabel.Font = Enum.Font.GothamBold
unameLabel.TextSize = 20
unameLabel.TextColor3 = Color3.fromRGB(255,255,255)
unameLabel.TextXAlignment = Enum.TextXAlignment.Left
unameLabel.Text = player.Name

local status = Instance.new("TextLabel", frame)
status.Position = UDim2.new(0, 20, 0, 120)
status.Size = UDim2.new(1, -40, 0, 24)
status.BackgroundTransparency = 1
status.Font = Enum.Font.Gotham
status.TextSize = 14
status.TextColor3 = Color3.fromRGB(255,255,255)
status.Text = "Klik tombol verifikasi untuk lanjut..."

-- Baris tombol
local btnRow = Instance.new("Frame", frame)
btnRow.Size = UDim2.new(0.86, 0, 0, 36)
btnRow.Position = UDim2.new(0.07, 0, 1, -44)
btnRow.BackgroundTransparency = 1

-- Fungsi animasi tombol hover
local function animateButton(btn)
    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {Size = btn.Size + UDim2.new(0,4,0,4)}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), {Size = btn.Size - UDim2.new(0,4,0,4)}):Play()
    end)
end

-- Tombol TikTok
local tiktokBtn = Instance.new("TextButton", btnRow)
tiktokBtn.Size = UDim2.new(0.18, 0, 1, 0)
tiktokBtn.Text = "TikTok"
tiktokBtn.Font = Enum.Font.GothamBold
tiktokBtn.TextSize = 14
tiktokBtn.TextColor3 = Color3.new(1,1,1)
tiktokBtn.BackgroundColor3 = Color3.fromRGB(255, 0, 85)
Instance.new("UICorner", tiktokBtn).CornerRadius = UDim.new(0, 8)
animateButton(tiktokBtn)

-- Tombol Verify
local verifyBtn = Instance.new("TextButton", btnRow)
verifyBtn.Size = UDim2.new(0.56, 0, 1, 0)
verifyBtn.Position = UDim2.new(0.22, 0, 0, 0)
verifyBtn.Text = "Verifikasi"
verifyBtn.Font = Enum.Font.GothamBold
verifyBtn.TextSize = 16
verifyBtn.TextColor3 = Color3.new(1,1,1)
verifyBtn.BackgroundColor3 = Color3.fromRGB(60, 180, 100)
Instance.new("UICorner", verifyBtn).CornerRadius = UDim.new(0, 8)
animateButton(verifyBtn)

-- Tombol Discord
local discordBtn = Instance.new("TextButton", btnRow)
discordBtn.Size = UDim2.new(0.18, 0, 1, 0)
discordBtn.Position = UDim2.new(0.82, 0, 0, 0)
discordBtn.Text = "Discord"
discordBtn.Font = Enum.Font.GothamBold
discordBtn.TextSize = 12
discordBtn.TextColor3 = Color3.new(1,1,1)
discordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
Instance.new("UICorner", discordBtn).CornerRadius = UDim.new(0, 8)
animateButton(discordBtn)

-- Avatar load otomatis
task.spawn(function()
    local ok, img = pcall(function()
        return Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100)
    end)
    if ok and img then avatar.Image = img end
end)

-- Fungsi salin link
local function copyToClipboard(link)
    if setclipboard then
        setclipboard(link)
        notify("LEXHOST", "Link disalin ke clipboard", 3)
    else
        notify("LEXHOST", "Fitur salin tidak tersedia di executor ini", 4)
    end
end

-- Aksi tombol
tiktokBtn.MouseButton1Click:Connect(function()
    copyToClipboard(TIKTOK_LINK)
    status.Text = "✅ Link TikTok disalin!"
    task.wait(2)
    status.Text = "Klik tombol verifikasi untuk lanjut..."
end)

discordBtn.MouseButton1Click:Connect(function()
    copyToClipboard(DISCORD_LINK)
    status.Text = "✅ Link Discord disalin!"
    task.wait(2)
    status.Text = "Klik tombol verifikasi untuk lanjut..."
end)

-- Proses verifikasi
local function doVerify()
    status.Text = "⏳ Memeriksa..."
    verifyBtn.Active = false
    task.wait(0.3)
    local ok, result = pcall(function()
        return isVerified(player.Name)
    end)
    verifyBtn.Active = true

    if not ok then
        status.Text = "⚠️ Error saat verifikasi."
        notify("LEXHOST", "Gagal memeriksa daftar (error).", 4)
        return
    end

    if result then
        status.Text = "✅ Kamu terdaftar sebagai pengguna!"
        _G.WataX_Replay = true
        task.wait(0.8)
        for _,url in ipairs(successUrls) do
            pcall(function() loadstring(game:HttpGet(url))() end)
        end
        TweenService:Create(frame, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
        task.wait(0.5)
        gui:Destroy()
    else
        status.Text = "❌ Kamu tidak terdaftar sebagai pengguna!"
        _G.WataX_Replay = false
        notify("LEXHOST", "❌ Kamu belum terdaftar.", 4)
    end
end

verifyBtn.MouseButton1Click:Connect(doVerify)

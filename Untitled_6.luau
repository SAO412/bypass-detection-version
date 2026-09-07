print("Hello, world!");-- ==============================================================================
-- Carl Tool Elite Optimized Core V7.9.2 (Anti-Ban & Detection Shield Update)
-- Author: carl | Discord: https://discord.gg/9u7UTY6TEg
-- ==============================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local Camera = workspace.CurrentCamera
local lp = Players.LocalPlayer

local QUEUE_ON_TELEPORT = (syn and syn.queue_on_teleport) or queue_on_teleport or (fluxus and fluxus.queue_on_teleport)
if QUEUE_ON_TELEPORT then
    pcall(function()
        QUEUE_ON_TELEPORT([[
            task.wait(2)
            loadstring(game:HttpGet("你的腳本網址"))()
        ]])
    end)
end

local currentLang = "ZH"
local HitboxModes = {"Head", "HumanoidRootPart", "LeftHand", "RightHand", "LeftFoot", "RightFoot", "Random"}
local HitboxNamesZH = {"👑 絕對爆頭 (Headshot)", "⚜ 軀幹中心 (Chest)", "🦾 左手 (Left Hand)", "🦾 右手 (Right Hand)", "🦵 左腳 (Left Foot)", "🦵 右腳 (Right Foot)", "🎲 隨機穩定 (RNG Safe)"}
local HitboxNamesEN = {"👑 Headshot", "⚜ Chest", "🦾 Left Hand", "🦾 Right Hand", "🦵 Left Foot", "🦵 Right Foot", "🎲 RNG Safe"}
local currentHitboxIndex = 1

local Config = {
    AimLockEnabled = false,   
    TriggerbotEnabled = false,      
    TriggerbotDelay = 0.05,         
    PredictionEnabled = true,       
    PredictionAmount = 0.135,
    ProjectileSpeed = 1000,         
    BypassDetection = true,         
    EliteAntiBan = true,            
    NoRecoilEnabled = true,  
    NoSpreadEnabled = true,  
    WallShotEnabled = false,        
    EspEnabled = false,
    SkeletonEspEnabled = false,     
    PredictionDotEnabled = false,   
    NameEspEnabled = true,          
    DistanceEspEnabled = true,      
    HealthBarEnabled = true,        
    TeamCheck = true,     
    WallCheck = true,              
    ShowFovCircle = true,   
    Smoothness = 5,                 
    EspScale = 4100,      
    MaxAimDistance = 500, 
    AimFovRadius = 220,
    MenuTextSize = 14     
}

local WhitelistTable = {}
local configFileName = "CarlTool_Config_V7.92.json"

local function saveConfig()
    if writefile then
        pcall(function()
            writefile(configFileName, HttpService:JSONEncode({ Config = Config, HitboxIndex = currentHitboxIndex, Whitelist = WhitelistTable }))
        end)
    end
end

local function loadConfig()
    if readfile and isfile and isfile(configFileName) then
        pcall(function()
            local decoded = HttpService:JSONDecode(readfile(configFileName))
            if decoded and decoded.Config then
                for k, v in pairs(decoded.Config) do if Config[k] ~= nil then Config[k] = v end end
            end
            if decoded and decoded.HitboxIndex then currentHitboxIndex = decoded.HitboxIndex end
            if decoded and decoded.Whitelist then WhitelistTable = decoded.Whitelist end
        end)
    end
end
loadConfig()

local hasMouseMove = type(mousemoverel) == "function"

local fovCircle = Drawing.new("Circle")
fovCircle.Visible = false
fovCircle.Thickness = 1.5
fovCircle.NumSides = 60
fovCircle.Color = Color3.fromRGB(255, 23, 68)
fovCircle.Filled = false
fovCircle.Transparency = 0.8

local predDot = Drawing.new("Circle")
predDot.Visible = false
predDot.Thickness = 2
predDot.NumSides = 12
predDot.Radius = 5
predDot.Color = Color3.fromRGB(255, 145, 0)
predDot.Filled = true
predDot.Transparency = 0.9

local Lang = {
    ZH = {
        title = "⚡ ✦ CARL TOOL V7.9.2 (防封加強版) ✦ ⚜",
        authorText = "✨ 作者：carl ｜ 點我複製 [ Discord 交流群 ] 🔗 ⚜",
        authorCopied = "📋 ➔ 已成功複製 Discord 邀請連結！✦",
        tabAim = "🎯 自瞄",
        tabDraw = "👁️ 透視",
        tabBypass = "🛡️ 防護",
        tabWhite = "👥 白名單",
        tabSettings = "⚙️ 設定",
        btnAimOff = "🎯 絲滑跟槍鎖定 ➔ [ 關閉 ✕ ]",
        btnAimOn = "🎯 絲滑跟槍鎖定 ➔ [ 運行中 ⚡ ]",
        btnTriggerOff = "⚡ 瞄準自動開火 (Trigger) ➔ [ 關閉 ✕ ]",
        btnTriggerOn = "⚡ 瞄準自動開火 (Trigger) ➔ [ 運行中 ⚡ ]",
        btnBypassOff = "🛡️ 核心特徵碼繞過 ➔ [ 關閉 ✕ ]",
        btnBypassOn = "🛡️ 核心特徵碼繞過 ➔ [ 隱蔽中 ✦ ]",
        btnEliteOff = "🛡️ 頂級反封鎖/防踢網 ➔ [ 關閉 ✕ ]",
        btnEliteOn = "🛡️ 頂級反封鎖/防踢網 ➔ [ 絕對安全 ⚜ ]",
        btnRecoilOff = "🔫 無後座力補正 ➔ [ 關閉 ✕ ]",
        btnRecoilOn = "🔫 無後座力補正 ➔ [ 鎖定中 ✦ ]",
        btnSpreadOff = "🎯 子彈絕對聚點 ➔ [ 關閉 ✕ ]",
        btnSpreadOn = "🎯 子彈絕對聚點 ➔ [ 鎖定中 ✦ ]",
        btnWallShotOff = "🧱 穿牆打擊修正 ➔ [ 關閉 ✕ ]",
        btnWallShotOn = "🧱 穿牆打擊修正 ➔ [ 啟動中 ✦ ]",
        btnWallCheckOff = "🧱 嚴格掩體阻擋 (Wall Check) ➔ [ 關閉 ✕ ]",
        btnWallCheckOn = "🧱 嚴格掩體阻擋 (Wall Check) ➔ [ 嚴格過濾中 ⚜ ]",
        btnEspOff = "👁️ 3D 戰術方框透視 ➔ [ 關閉 ✕ ]",
        btnEspOn = "👁️ 3D 戰術方框透視 ➔ [ 顯示中 ✦ ]",
        btnHealthOff = "❤️ 玩家動態血條 ➔ [ 關閉 ✕ ]",
        btnHealthOn = "❤️ 玩家動態血條 ➔ [ 顯示中 ✦ ]",
        btnSkelOff = "🦴 骨骼動態追蹤 ➔ [ 關閉 ✕ ]",
        btnSkelOn = "🦴 骨骼動態追蹤 ➔ [ 顯示中 ✦ ]",
        btnPredOff = "🟢 彈道預判落點 ➔ [ 關閉 ✕ ]",
        btnPredOn = "🟢 彈道預判落點 ➔ [ 顯示中 ✦ ]",
        btnNameOff = "📌 目標身分識別 ➔ [ 關閉 ✕ ]",
        btnNameOn = "📌 目標身分識別 ➔ [ 顯示中 ✦ ]",
        btnDistOff = "📏 距離動態標籤 ➔ [ 關閉 ✕ ]",
        btnDistOn = "📏 距離動態標籤 ➔ [ 顯示中 ✦ ]",
        btnTeamOff = "🛡️ RIVALS 緯來友軍智慧過濾 (Team Check) ➔ [ 關閉 ✕ ]",
        btnTeamOn = "🛡️ RIVALS 緯來友軍智慧過濾 (Team Check) ➔ [ 過濾中 ✦ ]",
        btnFovOff = "⭕ 自瞄範圍圈 (FOV) ➔ [ 關閉 ✕ ]",
        btnFovOn = "⭕ 自瞄範圍圈 (FOV) ➔ [ 顯示中 ✦ ]",
        btnHitbox = "🎯 鎖定部位 ➔ ",
        lblSmooth = "⚡ 跟槍平滑度 (Smoothness - 越低越快)",
        lblScale = "📦 3D 方框比例",
        lblMaxDist = "🛡️ 最大鎖定距離",
        lblAimFov = "🎯 FOV 半徑",
        lblFontSize = "🔤 菜單字體大小",
        statusText = "❖ CARL V7.9.2：已啟動強效防封與動作抖動模擬，安全防踢 🛡️"
    },
    EN = {
        title = "⚡ ✦ CARL TOOL V7.9.2 (Anti-Ban Pro) ✦ ⚜",
        authorText = "✨ Author: carl ｜ Click to Copy [ Discord ] 🔗 ⚜",
        authorCopied = "📋 ➔ Discord invite link copied! ✦",
        tabAim = "🎯 Aim",
        tabDraw = "👁️ Visuals",
        tabBypass = "🛡️ Bypass",
        tabWhite = "👥 Whitelist",
        tabSettings = "⚙️ Config",
        btnAimOff = "🎯 Smooth AimLock ➔ [ OFF ✕ ]",
        btnAimOn = "🎯 Smooth AimLock ➔ [ ACTIVE ⚡ ]",
        btnTriggerOff = "⚡ Auto Triggerbot ➔ [ OFF ✕ ]",
        btnTriggerOn = "⚡ Auto Triggerbot ➔ [ ACTIVE ⚡ ]",
        btnBypassOff = "🛡️ Signature Bypass ➔ [ OFF ✕ ]",
        btnBypassOn = "🛡️ Signature Bypass ➔ [ SECURE ✦ ]",
        btnEliteOff = "🛡️ Elite Anti-Ban Shield ➔ [ OFF ✕ ]",
        btnEliteOn = "🛡️ Elite Anti-Ban Shield ➔ [ SECURE ⚜ ]",
        btnRecoilOff = "🔫 No Recoil ➔ [ OFF ✕ ]",
        btnRecoilOn = "🔫 No Recoil ➔ [ ACTIVE ✦ ]",
        btnSpreadOff = "🎯 No Spread ➔ [ OFF ✕ ]",
        btnSpreadOn = "🎯 No Spread ➔ [ ACTIVE ✦ ]",
        btnWallShotOff = "🧱 Wall Penetration ➔ [ OFF ✕ ]",
        btnWallShotOn = "🧱 Wall Penetration ➔ [ ACTIVE ✦ ]",
        btnWallCheckOff = "🧱 Strict Wall Check ➔ [ OFF ✕ ]",
        btnWallCheckOn = "🧱 Strict Wall Check ➔ [ ACTIVE ⚜ ]",
        btnEspOff = "👁️ 3D Tactical Box ➔ [ OFF ✕ ]",
        btnEspOn = "👁️ 3D Tactical Box ➔ [ ON ✦ ]",
        btnHealthOff = "❤️ Dynamic Health Bar ➔ [ OFF ✕ ]",
        btnHealthOn = "❤️ Dynamic Health Bar ➔ [ ON ✦ ]",
        btnSkelOff = "🦴 Skeleton ESP ➔ [ OFF ✕ ]",
        btnSkelOn = "🦴 Skeleton ESP ➔ [ ON ✦ ]",
        btnPredOff = "🟢 Prediction Dot ➔ [ OFF ✕ ]",
        btnPredOn = "🟢 Prediction Dot ➔ [ ON ✦ ]",
        btnNameOff = "📌 Name Tags ➔ [ OFF ✕ ]",
        btnNameOn = "📌 Name Tags ➔ [ ON ✦ ]",
        btnDistOff = "📏 Distance Tags ➔ [ OFF ✕ ]",
        btnDistOn = "📏 Distance Tags ➔ [ ON ✦ ]",
        btnTeamOff = "🛡️ RIVALS Team Check ➔ [ OFF ✕ ]",
        btnTeamOn = "🛡️ RIVALS Team Check ➔ [ ACTIVE ✦ ]",
        btnFovOff = "⭕ FOV Circle ➔ [ OFF ✕ ]",
        btnFovOn = "⭕ FOV Circle ➔ [ ON ✦ ]",
        btnHitbox = "🎯 Hitbox ➔ ",
        lblSmooth = "⚡ Aim Smoothness",
        lblScale = "📦 ESP Scale",
        lblMaxDist = "🛡️ Max Distance",
        lblAimFov = "🎯 FOV Radius",
        lblFontSize = "🔤 Menu Font Size",
        statusText = "❖ CARL V7.9.2: Anti-ban shield & behavioral jitter simulation active. 🛡️"
    }
}

local function applyCorner(p, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = p
end

local function bindResponsiveClick(button, callback)
    button.Activated:Connect(callback)
    button.MouseEnter:Connect(function() button.BackgroundTransparency = 0.2 end)
    button.MouseLeave:Connect(function() button.BackgroundTransparency = 0 end)
end

local gui = Instance.new("ScreenGui")
gui.Name = "Carl_Tool"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

pcall(function()
    if syn and syn.protect_gui then
        syn.protect_gui(gui)
        gui.Parent = game:GetService("CoreGui")
    elseif gethui then
        gui.Parent = gethui()
    else
        gui.Parent = game:GetService("CoreGui")
    end
end)

if not gui.Parent then 
    pcall(function() gui.Parent = lp:WaitForChild("PlayerGui") end) 
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 540, 0, 560)
mainFrame.Position = UDim2.new(0, 60, 0.5, -280)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.Active = true
mainFrame.Parent = gui
applyCorner(mainFrame, 12)

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(255, 23, 68) 
stroke.Thickness = 2
stroke.Transparency = 0.1
stroke.Parent = mainFrame

local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 52)
topBar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
topBar.Parent = mainFrame
applyCorner(topBar, 12)

local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, -170, 1, 0)
titleLabel.Position = UDim2.new(0, 14, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = Lang[currentLang].title
titleLabel.TextColor3 = Color3.fromRGB(255, 23, 68)
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextSize = 15
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = topBar

local mainLangBtn = Instance.new("TextButton")
mainLangBtn.Size = UDim2.new(0, 38, 0, 30)
mainLangBtn.Position = UDim2.new(1, -130, 0, 11)
mainLangBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
mainLangBtn.Text = currentLang == "ZH" and "EN" or "中"
mainLangBtn.TextColor3 = Color3.fromRGB(255, 23, 68)
mainLangBtn.Font = Enum.Font.GothamBold
mainLangBtn.TextSize = 15
mainLangBtn.Parent = topBar
applyCorner(mainLangBtn, 6)

local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -86, 0, 11)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.Parent = topBar
applyCorner(minimizeBtn, 6)

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -48, 0, 11)
closeBtn.BackgroundColor3 = Color3.fromRGB(220, 20, 60)
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.new(1, 1, 1)
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 15
closeBtn.Parent = topBar
applyCorner(closeBtn, 6)

local contentContainer = Instance.new("Frame")
contentContainer.Size = UDim2.new(1, 0, 1, -52)
contentContainer.Position = UDim2.new(0, 0, 0, 52)
contentContainer.BackgroundTransparency = 1
contentContainer.Parent = mainFrame

local floatingIcon = Instance.new("TextButton")
floatingIcon.Size = UDim2.new(0, 46, 0, 46)
floatingIcon.Position = UDim2.new(0, 120, 0, 180)
floatingIcon.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
floatingIcon.Text = "⚡"
floatingIcon.TextColor3 = Color3.fromRGB(255, 23, 68)
floatingIcon.Font = Enum.Font.GothamBold
floatingIcon.TextSize = 20
floatingIcon.Visible = false
floatingIcon.Parent = gui
applyCorner(floatingIcon, 23)

local floatStroke = Instance.new("UIStroke")
floatStroke.Color = Color3.fromRGB(255, 23, 68)
floatStroke.Thickness = 2
floatStroke.Parent = floatingIcon

minimizeBtn.Activated:Connect(function()
    mainFrame.Visible = false
    floatingIcon.Visible = true
end)

floatingIcon.Activated:Connect(function()
    mainFrame.Visible = true
    floatingIcon.Visible = false
end)

local floatDragging, floatDragInput, floatDragStart, floatStartPos = false, nil, nil, nil
floatingIcon.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        floatDragging = true
        floatDragStart = input.Position
        floatStartPos = floatingIcon.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then floatDragging = false end end)
    end
end)

floatingIcon.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then floatDragInput = input end
end)

RunService.RenderStepped:Connect(function()
    if floatDragging and floatDragInput then
        local delta = floatDragInput.Position - floatDragStart
        floatingIcon.Position = UDim2.new(floatStartPos.X.Scale, floatStartPos.X.Offset + delta.X, floatStartPos.Y.Scale, floatStartPos.Y.Offset + delta.Y)
    end
end)

local authorBtn = Instance.new("TextButton")
authorBtn.Size = UDim2.new(1, -28, 0, 32)
authorBtn.Position = UDim2.new(0, 14, 0, 10)
authorBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 32)
authorBtn.BackgroundTransparency = 0.4
authorBtn.Text = Lang[currentLang].authorText
authorBtn.TextColor3 = Color3.fromRGB(255, 100, 120)
authorBtn.Font = Enum.Font.GothamBold
authorBtn.TextSize = 13.5
authorBtn.TextXAlignment = Enum.TextXAlignment.Left
authorBtn.Parent = contentContainer
applyCorner(authorBtn, 6)

authorBtn.Activated:Connect(function()
    local dcUrl = "https://discord.gg/9u7UTY6TEg"
    if setclipboard then
        setclipboard(dcUrl)
    end
    pcall(function()
        if syn and syn.request then
            syn.request({Url = "http://127.0.0.1:6463/rpc?v=1", Method = "POST", Headers = {["Content-Type"] = "application/json", ["Origin"] = "https://discord.com"}, Body = HttpService:JSONEncode({args = {code = "9u7UTY6TEg"}, cmd = "INVITE_BROWSER", nonce = ""})})
        elseif request then
            request({Url = "http://127.0.0.1:6463/rpc?v=1", Method = "POST", Headers = {["Content-Type"] = "application/json", ["Origin"] = "https://discord.com"}, Body = HttpService:JSONEncode({args = {code = "9u7UTY6TEg"}, cmd = "INVITE_BROWSER", nonce = ""})})
        elseif tsetclipboard then
            tsetclipboard(dcUrl)
        end
    end)
    authorBtn.Text = Lang[currentLang].authorCopied
    authorBtn.TextColor3 = Color3.fromRGB(0, 230, 130)
    task.delay(2, function()
        authorBtn.Text = Lang[currentLang].authorText
        authorBtn.TextColor3 = Color3.fromRGB(255, 100, 120)
    end)
end)

local tabContainer = Instance.new("Frame")
tabContainer.Size = UDim2.new(1, -28, 0, 40)
tabContainer.Position = UDim2.new(0, 14, 0, 48)
tabContainer.BackgroundTransparency = 1
tabContainer.Parent = contentContainer

local tabWidth = 0.19

local aimTabBtn = Instance.new("TextButton")
aimTabBtn.Size = UDim2.new(tabWidth, 0, 1, 0)
aimTabBtn.BackgroundColor3 = Color3.fromRGB(45, 20, 30)
aimTabBtn.Text = Lang[currentLang].tabAim
aimTabBtn.TextColor3 = Color3.fromRGB(255, 23, 68)
aimTabBtn.Font = Enum.Font.GothamBold
aimTabBtn.TextSize = 13
aimTabBtn.Parent = tabContainer
applyCorner(aimTabBtn, 6)

local drawTabBtn = Instance.new("TextButton")
drawTabBtn.Size = UDim2.new(tabWidth, 0, 1, 0)
drawTabBtn.Position = UDim2.new(tabWidth * 1.05, 0, 0, 0)
drawTabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
drawTabBtn.Text = Lang[currentLang].tabDraw
drawTabBtn.TextColor3 = Color3.fromRGB(130, 130, 150)
drawTabBtn.Font = Enum.Font.GothamBold
drawTabBtn.TextSize = 13
drawTabBtn.Parent = tabContainer
applyCorner(drawTabBtn, 6)

local bypassTabBtn = Instance.new("TextButton")
bypassTabBtn.Size = UDim2.new(tabWidth, 0, 1, 0)
bypassTabBtn.Position = UDim2.new(tabWidth * 2.1, 0, 0, 0)
bypassTabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
bypassTabBtn.Text = Lang[currentLang].tabBypass
bypassTabBtn.TextColor3 = Color3.fromRGB(130, 130, 150)
bypassTabBtn.Font = Enum.Font.GothamBold
bypassTabBtn.TextSize = 13
bypassTabBtn.Parent = tabContainer
applyCorner(bypassTabBtn, 6)

local whiteTabBtn = Instance.new("TextButton")
whiteTabBtn.Size = UDim2.new(tabWidth, 0, 1, 0)
whiteTabBtn.Position = UDim2.new(tabWidth * 3.15, 0, 0, 0)
whiteTabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
whiteTabBtn.Text = Lang[currentLang].tabWhite
whiteTabBtn.TextColor3 = Color3.fromRGB(130, 130, 150)
whiteTabBtn.Font = Enum.Font.GothamBold
whiteTabBtn.TextSize = 13
whiteTabBtn.Parent = tabContainer
applyCorner(whiteTabBtn, 6)

local settingsTabBtn = Instance.new("TextButton")
settingsTabBtn.Size = UDim2.new(tabWidth, 0, 1, 0)
settingsTabBtn.Position = UDim2.new(tabWidth * 4.2, 0, 0, 0)
settingsTabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
settingsTabBtn.Text = Lang[currentLang].tabSettings
settingsTabBtn.TextColor3 = Color3.fromRGB(130, 130, 150)
settingsTabBtn.Font = Enum.Font.GothamBold
settingsTabBtn.TextSize = 13
settingsTabBtn.Parent = tabContainer
applyCorner(settingsTabBtn, 6)

local pageContainer = Instance.new("Frame")
pageContainer.Size = UDim2.new(1, -28, 0, 410)
pageContainer.Position = UDim2.new(0, 14, 0, 96)
pageContainer.BackgroundTransparency = 1
pageContainer.Parent = contentContainer

local aimPage = Instance.new("Frame")
aimPage.Size = UDim2.new(1, 0, 1, 0)
aimPage.BackgroundTransparency = 1
aimPage.Parent = pageContainer

local drawPage = Instance.new("Frame")
drawPage.Size = UDim2.new(1, 0, 1, 0)
drawPage.BackgroundTransparency = 1
drawPage.Visible = false
drawPage.Parent = pageContainer

local bypassPage = Instance.new("Frame")
bypassPage.Size = UDim2.new(1, 0, 1, 0)
bypassPage.BackgroundTransparency = 1
bypassPage.Visible = false
bypassPage.Parent = pageContainer

local whitelistPage = Instance.new("ScrollingFrame")
whitelistPage.Size = UDim2.new(1, 0, 1, 0)
whitelistPage.BackgroundTransparency = 1
whitelistPage.CanvasSize = UDim2.new(0, 0, 0, 0)
whitelistPage.AutomaticCanvasSize = Enum.AutomaticSize.Y
whitelistPage.ScrollBarThickness = 4
whitelistPage.Visible = false
whitelistPage.Parent = pageContainer

local whiteListLayout = Instance.new("UIListLayout")
whiteListLayout.SortOrder = Enum.SortOrder.LayoutOrder
whiteListLayout.Padding = UDim.new(0, 6)
whiteListLayout.Parent = whitelistPage

local settingsPage = Instance.new("Frame")
settingsPage.Size = UDim2.new(1, 0, 1, 0)
settingsPage.BackgroundTransparency = 1
settingsPage.Visible = false
settingsPage.Parent = pageContainer

local function switchTab(activeBtn, activePage)
    aimPage.Visible = (activePage == aimPage)
    drawPage.Visible = (activePage == drawPage)
    bypassPage.Visible = (activePage == bypassPage)
    whitelistPage.Visible = (activePage == whitelistPage)
    settingsPage.Visible = (activePage == settingsPage)

    for _, btn in ipairs({aimTabBtn, drawTabBtn, bypassTabBtn, whiteTabBtn, settingsTabBtn}) do
        if btn == activeBtn then
            btn.BackgroundColor3 = Color3.fromRGB(45, 20, 30)
            btn.TextColor3 = Color3.fromRGB(255, 23, 68)
        else
            btn.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
            btn.TextColor3 = Color3.fromRGB(130, 130, 150)
        end
    end
end

bindResponsiveClick(aimTabBtn, function() switchTab(aimTabBtn, aimPage) end)
bindResponsiveClick(drawTabBtn, function() switchTab(drawTabBtn, drawPage) end)
bindResponsiveClick(bypassTabBtn, function() switchTab(bypassTabBtn, bypassPage) end)
bindResponsiveClick(whiteTabBtn, function() switchTab(whiteTabBtn, whitelistPage) end)
bindResponsiveClick(settingsTabBtn, function() switchTab(settingsTabBtn, settingsPage) end)

local allButtons = {}
local function registerButtonFont(btn)
    table.insert(allButtons, btn)
    btn.TextSize = Config.MenuTextSize
end

local function updateAllFontSizes(newSize)
    Config.MenuTextSize = newSize
    for _, btn in ipairs(allButtons) do pcall(function() btn.TextSize = newSize end) end
    saveConfig()
end

local function createSlider(page, posY, labelText, minVal, maxVal, currentVal, callback)
    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, 0, 0, 48)
    container.Position = UDim2.new(0, 0, 0, posY)
    container.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
    container.Parent = page
    applyCorner(container, 8)

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0.65, 0, 0, 24)
    lbl.Position = UDim2.new(0, 12, 0, 2)
    lbl.BackgroundTransparency = 1
    lbl.Text = labelText
    lbl.TextColor3 = Color3.fromRGB(220, 220, 240)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = container

    local valBox = Instance.new("TextBox")
    valBox.Size = UDim2.new(0, 70, 0, 22)
    valBox.Position = UDim2.new(1, -82, 0, 2)
    valBox.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
    valBox.Text = tostring(currentVal)
    valBox.TextColor3 = Color3.fromRGB(255, 23, 68)
    valBox.Font = Enum.Font.GothamBold
    valBox.TextSize = 14
    valBox.Parent = container
    applyCorner(valBox, 4)

    local sliderBg = Instance.new("Frame")
    sliderBg.Size = UDim2.new(1, -24, 0, 6)
    sliderBg.Position = UDim2.new(0, 12, 0, 32)
    sliderBg.BackgroundColor3 = Color3.fromRGB(35, 35, 48)
    sliderBg.Parent = container
    applyCorner(sliderBg, 4)

    local sliderFill = Instance.new("Frame")
    local initPercent = math.clamp((currentVal - minVal) / (maxVal - minVal), 0, 1)
    sliderFill.Size = UDim2.new(initPercent, 0, 1, 0)
    sliderFill.BackgroundColor3 = Color3.fromRGB(255, 23, 68)
    sliderFill.Parent = sliderBg
    applyCorner(sliderFill, 4)

    local draggingSlider = false
    local function updateValue(inputPos)
        local posRelative = math.clamp((inputPos - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local newVal = math.floor(minVal + (maxVal - minVal) * posRelative)
        sliderFill.Size = UDim2.new(posRelative, 0, 1, 0)
        valBox.Text = tostring(newVal)
        callback(newVal)
        saveConfig()
    end

    sliderBg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            updateValue(input.Position.X)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateValue(input.Position.X)
        end
    end)

    valBox.FocusLost:Connect(function()
        local num = tonumber(valBox.Text)
        if num then
            num = math.clamp(num, minVal, maxVal)
            local p = (num - minVal) / (maxVal - minVal)
            sliderFill.Size = UDim2.new(p, 0, 1, 0)
            valBox.Text = tostring(num)
            callback(num)
            saveConfig()
        else
            valBox.Text = tostring(currentVal)
        end
    end)
end

local aimBtn = Instance.new("TextButton")
aimBtn.Size = UDim2.new(1, 0, 0, 34)
aimBtn.BackgroundColor3 = Config.AimLockEnabled and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
aimBtn.Text = Config.AimLockEnabled and Lang[currentLang].btnAimOn or Lang[currentLang].btnAimOff
aimBtn.TextColor3 = Color3.new(1, 1, 1)
aimBtn.Font = Enum.Font.GothamBold
aimBtn.Parent = aimPage
applyCorner(aimBtn, 6)
registerButtonFont(aimBtn)
bindResponsiveClick(aimBtn, function()
    Config.AimLockEnabled = not Config.AimLockEnabled
    aimBtn.BackgroundColor3 = Config.AimLockEnabled and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
    aimBtn.Text = Config.AimLockEnabled and Lang[currentLang].btnAimOn or Lang[currentLang].btnAimOff
    saveConfig()
end)

local triggerBtn = Instance.new("TextButton")
triggerBtn.Size = UDim2.new(1, 0, 0, 34)
triggerBtn.Position = UDim2.new(0, 0, 0, 38)
triggerBtn.BackgroundColor3 = Config.TriggerbotEnabled and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
triggerBtn.Text = Config.TriggerbotEnabled and Lang[currentLang].btnTriggerOn or Lang[currentLang].btnTriggerOff
triggerBtn.TextColor3 = Color3.new(1, 1, 1)
triggerBtn.Font = Enum.Font.GothamBold
triggerBtn.Parent = aimPage
applyCorner(triggerBtn, 6)
registerButtonFont(triggerBtn)
bindResponsiveClick(triggerBtn, function()
    Config.TriggerbotEnabled = not Config.TriggerbotEnabled
    triggerBtn.BackgroundColor3 = Config.TriggerbotEnabled and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
    triggerBtn.Text = Config.TriggerbotEnabled and Lang[currentLang].btnTriggerOn or Lang[currentLang].btnTriggerOff
    saveConfig()
end)

local recoilBtn = Instance.new("TextButton")
recoilBtn.Size = UDim2.new(1, 0, 0, 34)
recoilBtn.Position = UDim2.new(0, 0, 0, 76)
recoilBtn.BackgroundColor3 = Config.NoRecoilEnabled and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
recoilBtn.Text = Config.NoRecoilEnabled and Lang[currentLang].btnRecoilOn or Lang[currentLang].btnRecoilOff
recoilBtn.TextColor3 = Color3.new(1, 1, 1)
recoilBtn.Font = Enum.Font.GothamBold
recoilBtn.Parent = aimPage
applyCorner(recoilBtn, 6)
registerButtonFont(recoilBtn)
bindResponsiveClick(recoilBtn, function()
    Config.NoRecoilEnabled = not Config.NoRecoilEnabled
    recoilBtn.BackgroundColor3 = Config.NoRecoilEnabled and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
    recoilBtn.Text = Config.NoRecoilEnabled and Lang[currentLang].btnRecoilOn or Lang[currentLang].btnRecoilOff
    saveConfig()
end)

local spreadBtn = Instance.new("TextButton")
spreadBtn.Size = UDim2.new(1, 0, 0, 34)
spreadBtn.Position = UDim2.new(0, 0, 0, 114)
spreadBtn.BackgroundColor3 = Config.NoSpreadEnabled and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
spreadBtn.Text = Config.NoSpreadEnabled and Lang[currentLang].btnSpreadOn or Lang[currentLang].btnSpreadOff
spreadBtn.TextColor3 = Color3.new(1, 1, 1)
spreadBtn.Font = Enum.Font.GothamBold
spreadBtn.Parent = aimPage
applyCorner(spreadBtn, 6)
registerButtonFont(spreadBtn)
bindResponsiveClick(spreadBtn, function()
    Config.NoSpreadEnabled = not Config.NoSpreadEnabled
    spreadBtn.BackgroundColor3 = Config.NoSpreadEnabled and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
    spreadBtn.Text = Config.NoSpreadEnabled and Lang[currentLang].btnSpreadOn or Lang[currentLang].btnSpreadOff
    saveConfig()
end)

local wallShotBtn = Instance.new("TextButton")
wallShotBtn.Size = UDim2.new(1, 0, 0, 34)
wallShotBtn.Position = UDim2.new(0, 0, 0, 152)
wallShotBtn.BackgroundColor3 = Config.WallShotEnabled and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
wallShotBtn.Text = Config.WallShotEnabled and Lang[currentLang].btnWallShotOn or Lang[currentLang].btnWallShotOff
wallShotBtn.TextColor3 = Color3.new(1, 1, 1)
wallShotBtn.Font = Enum.Font.GothamBold
wallShotBtn.Parent = aimPage
applyCorner(wallShotBtn, 6)
registerButtonFont(wallShotBtn)
bindResponsiveClick(wallShotBtn, function()
    Config.WallShotEnabled = not Config.WallShotEnabled
    wallShotBtn.BackgroundColor3 = Config.WallShotEnabled and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
    wallShotBtn.Text = Config.WallShotEnabled and Lang[currentLang].btnWallShotOn or Lang[currentLang].btnWallShotOff
    saveConfig()
end)

local hitboxBtn = Instance.new("TextButton")
hitboxBtn.Size = UDim2.new(1, 0, 0, 34)
hitboxBtn.Position = UDim2.new(0, 0, 0, 190)
hitboxBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 50)
hitboxBtn.Text = Lang[currentLang].btnHitbox .. (currentLang == "ZH" and HitboxNamesZH[currentHitboxIndex] or HitboxNamesEN[currentHitboxIndex])
hitboxBtn.TextColor3 = Color3.fromRGB(255, 23, 68)
hitboxBtn.Font = Enum.Font.GothamBold
hitboxBtn.Parent = aimPage
applyCorner(hitboxBtn, 6)
registerButtonFont(hitboxBtn)
bindResponsiveClick(hitboxBtn, function()
    currentHitboxIndex = currentHitboxIndex % #HitboxModes + 1
    hitboxBtn.Text = Lang[currentLang].btnHitbox .. (currentLang == "ZH" and HitboxNamesZH[currentHitboxIndex] or HitboxNamesEN[currentHitboxIndex])
    saveConfig()
end)

createSlider(aimPage, 230, Lang[currentLang].lblSmooth, 1, 30, Config.Smoothness, function(v) Config.Smoothness = v end)
createSlider(aimPage, 284, Lang[currentLang].lblAimFov, 20, 600, Config.AimFovRadius, function(v) Config.AimFovRadius = v end)

local espBtn = Instance.new("TextButton")
espBtn.Size = UDim2.new(1, 0, 0, 36)
espBtn.BackgroundColor3 = Config.EspEnabled and Color3.fromRGB(150, 50, 150) or Color3.fromRGB(22, 22, 30)
espBtn.Text = Config.EspEnabled and Lang[currentLang].btnEspOn or Lang[currentLang].btnEspOff
espBtn.TextColor3 = Color3.new(1, 1, 1)
espBtn.Font = Enum.Font.GothamBold
espBtn.Parent = drawPage
applyCorner(espBtn, 6)
registerButtonFont(espBtn)
bindResponsiveClick(espBtn, function()
    Config.EspEnabled = not Config.EspEnabled
    espBtn.BackgroundColor3 = Config.EspEnabled and Color3.fromRGB(150, 50, 150) or Color3.fromRGB(22, 22, 30)
    espBtn.Text = Config.EspEnabled and Lang[currentLang].btnEspOn or Lang[currentLang].btnEspOff
    saveConfig()
end)

local healthBtn = Instance.new("TextButton")
healthBtn.Size = UDim2.new(1, 0, 0, 36)
healthBtn.Position = UDim2.new(0, 0, 0, 40)
healthBtn.BackgroundColor3 = Config.HealthBarEnabled and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
healthBtn.Text = Config.HealthBarEnabled and Lang[currentLang].btnHealthOn or Lang[currentLang].btnHealthOff
healthBtn.TextColor3 = Color3.new(1, 1, 1)
healthBtn.Font = Enum.Font.GothamBold
healthBtn.Parent = drawPage
applyCorner(healthBtn, 6)
registerButtonFont(healthBtn)
bindResponsiveClick(healthBtn, function()
    Config.HealthBarEnabled = not Config.HealthBarEnabled
    healthBtn.BackgroundColor3 = Config.HealthBarEnabled and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
    healthBtn.Text = Config.HealthBarEnabled and Lang[currentLang].btnHealthOn or Lang[currentLang].btnHealthOff
    saveConfig()
end)

local skelBtn = Instance.new("TextButton")
skelBtn.Size = UDim2.new(1, 0, 0, 36)
skelBtn.Position = UDim2.new(0, 0, 0, 80)
skelBtn.BackgroundColor3 = Config.SkeletonEspEnabled and Color3.fromRGB(150, 50, 150) or Color3.fromRGB(22, 22, 30)
skelBtn.Text = Config.SkeletonEspEnabled and Lang[currentLang].btnSkelOn or Lang[currentLang].btnSkelOff
skelBtn.TextColor3 = Color3.new(1, 1, 1)
skelBtn.Font = Enum.Font.GothamBold
skelBtn.Parent = drawPage
applyCorner(skelBtn, 6)
registerButtonFont(skelBtn)
bindResponsiveClick(skelBtn, function()
    Config.SkeletonEspEnabled = not Config.SkeletonEspEnabled
    skelBtn.BackgroundColor3 = Config.SkeletonEspEnabled and Color3.fromRGB(150, 50, 150) or Color3.fromRGB(22, 22, 30)
    skelBtn.Text = Config.SkeletonEspEnabled and Lang[currentLang].btnSkelOn or Lang[currentLang].btnSkelOff
    saveConfig()
end)

local predBtn = Instance.new("TextButton")
predBtn.Size = UDim2.new(1, 0, 0, 36)
predBtn.Position = UDim2.new(0, 0, 0, 120)
predBtn.BackgroundColor3 = Config.PredictionDotEnabled and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
predBtn.Text = Config.PredictionDotEnabled and Lang[currentLang].btnPredOn or Lang[currentLang].btnPredOff
predBtn.TextColor3 = Color3.new(1, 1, 1)
predBtn.Font = Enum.Font.GothamBold
predBtn.Parent = drawPage
applyCorner(predBtn, 6)
registerButtonFont(predBtn)
bindResponsiveClick(predBtn, function()
    Config.PredictionDotEnabled = not Config.PredictionDotEnabled
    predBtn.BackgroundColor3 = Config.PredictionDotEnabled and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
    predBtn.Text = Config.PredictionDotEnabled and Lang[currentLang].btnPredOn or Lang[currentLang].btnPredOff
    saveConfig()
end)

local nameBtn = Instance.new("TextButton")
nameBtn.Size = UDim2.new(1, 0, 0, 36)
nameBtn.Position = UDim2.new(0, 0, 0, 160)
nameBtn.BackgroundColor3 = Config.NameEspEnabled and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
nameBtn.Text = Config.NameEspEnabled and Lang[currentLang].btnNameOn or Lang[currentLang].btnNameOff
nameBtn.TextColor3 = Color3.new(1, 1, 1)
nameBtn.Font = Enum.Font.GothamBold
nameBtn.Parent = drawPage
applyCorner(nameBtn, 6)
registerButtonFont(nameBtn)
bindResponsiveClick(nameBtn, function()
    Config.NameEspEnabled = not Config.NameEspEnabled
    nameBtn.BackgroundColor3 = Config.NameEspEnabled and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
    nameBtn.Text = Config.NameEspEnabled and Lang[currentLang].btnNameOn or Lang[currentLang].btnNameOff
    saveConfig()
end)

createSlider(drawPage, 204, Lang[currentLang].lblScale, 1000, 10000, Config.EspScale, function(v) Config.EspScale = v end)

local bypassBtn = Instance.new("TextButton")
bypassBtn.Size = UDim2.new(1, 0, 0, 34)
bypassBtn.BackgroundColor3 = Config.BypassDetection and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
bypassBtn.Text = Config.BypassDetection and Lang[currentLang].btnBypassOn or Lang[currentLang].btnBypassOff
bypassBtn.TextColor3 = Color3.new(1, 1, 1)
bypassBtn.Font = Enum.Font.GothamBold
bypassBtn.Parent = bypassPage
applyCorner(bypassBtn, 6)
registerButtonFont(bypassBtn)
bindResponsiveClick(bypassBtn, function()
    Config.BypassDetection = not Config.BypassDetection
    bypassBtn.BackgroundColor3 = Config.BypassDetection and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
    bypassBtn.Text = Config.BypassDetection and Lang[currentLang].btnBypassOn or Lang[currentLang].btnBypassOff
    saveConfig()
end)

local eliteAntiBanBtn = Instance.new("TextButton")
eliteAntiBanBtn.Size = UDim2.new(1, 0, 0, 34)
eliteAntiBanBtn.Position = UDim2.new(0, 0, 0, 38)
eliteAntiBanBtn.BackgroundColor3 = Config.EliteAntiBan and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
eliteAntiBanBtn.Text = Config.EliteAntiBan and Lang[currentLang].btnEliteOn or Lang[currentLang].btnEliteOff
eliteAntiBanBtn.TextColor3 = Color3.new(1, 1, 1)
eliteAntiBanBtn.Font = Enum.Font.GothamBold
eliteAntiBanBtn.Parent = bypassPage
applyCorner(eliteAntiBanBtn, 6)
registerButtonFont(eliteAntiBanBtn)
bindResponsiveClick(eliteAntiBanBtn, function()
    Config.EliteAntiBan = not Config.EliteAntiBan
    eliteAntiBanBtn.BackgroundColor3 = Config.EliteAntiBan and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
    eliteAntiBanBtn.Text = Config.EliteAntiBan and Lang[currentLang].btnEliteOn or Lang[currentLang].btnEliteOff
    saveConfig()
end)

local wallCheckBtn = Instance.new("TextButton")
wallCheckBtn.Size = UDim2.new(1, 0, 0, 34)
wallCheckBtn.Position = UDim2.new(0, 0, 0, 76)
wallCheckBtn.BackgroundColor3 = Config.WallCheck and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
wallCheckBtn.Text = Config.WallCheck and Lang[currentLang].btnWallCheckOn or Lang[currentLang].btnWallCheckOff
wallCheckBtn.TextColor3 = Color3.new(1, 1, 1)
wallCheckBtn.Font = Enum.Font.GothamBold
wallCheckBtn.Parent = bypassPage
applyCorner(wallCheckBtn, 6)
registerButtonFont(wallCheckBtn)
bindResponsiveClick(wallCheckBtn, function()
    Config.WallCheck = not Config.WallCheck
    wallCheckBtn.BackgroundColor3 = Config.WallCheck and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
    wallCheckBtn.Text = Config.WallCheck and Lang[currentLang].btnWallCheckOn or Lang[currentLang].btnWallCheckOff
    saveConfig()
end)

local teamBtn = Instance.new("TextButton")
teamBtn.Size = UDim2.new(1, 0, 0, 34)
teamBtn.Position = UDim2.new(0, 0, 0, 114)
teamBtn.BackgroundColor3 = Config.TeamCheck and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
teamBtn.Text = Config.TeamCheck and Lang[currentLang].btnTeamOn or Lang[currentLang].btnTeamOff
teamBtn.TextColor3 = Color3.new(1, 1, 1)
teamBtn.Font = Enum.Font.GothamBold
teamBtn.Parent = bypassPage
applyCorner(teamBtn, 6)
registerButtonFont(teamBtn)
bindResponsiveClick(teamBtn, function()
    Config.TeamCheck = not Config.TeamCheck
    teamBtn.BackgroundColor3 = Config.TeamCheck and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
    teamBtn.Text = Config.TeamCheck and Lang[currentLang].btnTeamOn or Lang[currentLang].btnTeamOff
    saveConfig()
end)

local fovToggleBtn = Instance.new("TextButton")
fovToggleBtn.Size = UDim2.new(1, 0, 0, 34)
fovToggleBtn.Position = UDim2.new(0, 0, 0, 152)
fovToggleBtn.BackgroundColor3 = Config.ShowFovCircle and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
fovToggleBtn.Text = Config.ShowFovCircle and Lang[currentLang].btnFovOn or Lang[currentLang].btnFovOff
fovToggleBtn.TextColor3 = Color3.new(1, 1, 1)
fovToggleBtn.Font = Enum.Font.GothamBold
fovToggleBtn.Parent = bypassPage
applyCorner(fovToggleBtn, 6)
registerButtonFont(fovToggleBtn)
bindResponsiveClick(fovToggleBtn, function()
    Config.ShowFovCircle = not Config.ShowFovCircle
    fovToggleBtn.BackgroundColor3 = Config.ShowFovCircle and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(22, 22, 30)
    fovToggleBtn.Text = Config.ShowFovCircle and Lang[currentLang].btnFovOn or Lang[currentLang].btnFovOff
    saveConfig()
end)

createSlider(bypassPage, 190, Lang[currentLang].lblMaxDist, 50, 5000, Config.MaxAimDistance, function(v) Config.MaxAimDistance = v end)

local whitelistGuiCache = {}
local function updateWhitelistUI()
    for _, item in pairs(whitelistGuiCache) do
        if item then item:Destroy() end
    end
    whitelistGuiCache = {}

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp then
            local isWhitelisted = WhitelistTable[p.UserId] == true

            local row = Instance.new("Frame")
            row.Size = UDim2.new(1, 0, 0, 42)
            row.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
            row.Parent = whitelistPage
            applyCorner(row, 6)
            table.insert(whitelistGuiCache, row)

            local avatarImg = Instance.new("ImageLabel")
            avatarImg.Size = UDim2.new(0, 32, 0, 32)
            avatarImg.Position = UDim2.new(0, 5, 0, 5)
            avatarImg.BackgroundTransparency = 1
            avatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. tostring(p.UserId) .. "&w=150&h=150"
            avatarImg.Parent = row
            applyCorner(avatarImg, 16)

            local nameLbl = Instance.new("TextLabel")
            nameLbl.Size = UDim2.new(0.6, 0, 1, 0)
            nameLbl.Position = UDim2.new(0, 45, 0, 0)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Text = p.Name .. " (@" .. p.DisplayName .. ")"
            nameLbl.TextColor3 = Color3.fromRGB(230, 230, 250)
            nameLbl.Font = Enum.Font.GothamBold
            nameLbl.TextSize = 13
            nameLbl.TextXAlignment = Enum.TextXAlignment.Left
            nameLbl.Parent = row

            local toggleWhiteBtn = Instance.new("TextButton")
            toggleWhiteBtn.Size = UDim2.new(0, 95, 0, 28)
            toggleWhiteBtn.Position = UDim2.new(1, -103, 0, 7)
            toggleWhiteBtn.BackgroundColor3 = isWhitelisted and Color3.fromRGB(0, 150, 110) or Color3.fromRGB(45, 45, 60)
            toggleWhiteBtn.Text = isWhitelisted and "已加入 🛡️" or "加入白名單 ➕"
            toggleWhiteBtn.TextColor3 = Color3.new(1, 1, 1)
            toggleWhiteBtn.Font = Enum.Font.GothamBold
            toggleWhiteBtn.TextSize = 11
            toggleWhiteBtn.Parent = row
            applyCorner(toggleWhiteBtn, 6)

            bindResponsiveClick(toggleWhiteBtn, function()
                if WhitelistTable[p.UserId] then
                    WhitelistTable[p.UserId] = nil
                    toggleWhiteBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 60)
                    toggleWhiteBtn.Text = "加入白名單 ➕"
                else
                    WhitelistTable[p.UserId] = true
                    toggleWhiteBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 110)
                    toggleWhiteBtn.Text = "已加入 🛡️"
                end
                saveConfig()
            end)
        end
    end
end

Players.PlayerAdded:Connect(updateWhitelistUI)
Players.PlayerRemoving:Connect(updateWhitelistUI)
task.spawn(updateWhitelistUI)

createSlider(settingsPage, 10, Lang[currentLang].lblFontSize, 10, 24, Config.MenuTextSize, function(v)
    updateAllFontSizes(v)
end)

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 28)
statusLabel.Position = UDim2.new(0, 0, 0, 375)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = Lang[currentLang].statusText
statusLabel.TextColor3 = Color3.fromRGB(150, 150, 180)
statusLabel.Font = Enum.Font.GothamBold
statusLabel.TextSize = 13.5
statusLabel.TextXAlignment = Enum.TextXAlignment.Center
statusLabel.Parent = bypassPage

mainLangBtn.Activated:Connect(function()
    currentLang = currentLang == "ZH" and "EN" or "ZH"
    titleLabel.Text = Lang[currentLang].title
    mainLangBtn.Text = currentLang == "ZH" and "EN" or "中"
    authorBtn.Text = Lang[currentLang].authorText
    aimTabBtn.Text = Lang[currentLang].tabAim
    drawTabBtn.Text = Lang[currentLang].tabDraw
    bypassTabBtn.Text = Lang[currentLang].tabBypass
    whiteTabBtn.Text = Lang[currentLang].tabWhite
    settingsTabBtn.Text = Lang[currentLang].tabSettings
    aimBtn.Text = Config.AimLockEnabled and Lang[currentLang].btnAimOn or Lang[currentLang].btnAimOff
    triggerBtn.Text = Config.TriggerbotEnabled and Lang[currentLang].btnTriggerOn or Lang[currentLang].btnTriggerOff
    bypassBtn.Text = Config.BypassDetection and Lang[currentLang].btnBypassOn or Lang[currentLang].btnBypassOff
    eliteAntiBanBtn.Text = Config.EliteAntiBan and Lang[currentLang].btnEliteOn or Lang[currentLang].btnEliteOff
    wallCheckBtn.Text = Config.WallCheck and Lang[currentLang].btnWallCheckOn or Lang[currentLang].btnWallCheckOff
    recoilBtn.Text = Config.NoRecoilEnabled and Lang[currentLang].btnRecoilOn or Lang[currentLang].btnRecoilOff
    spreadBtn.Text = Config.NoSpreadEnabled and Lang[currentLang].btnSpreadOn or Lang[currentLang].btnSpreadOff
    wallShotBtn.Text = Config.WallShotEnabled and Lang[currentLang].btnWallShotOn or Lang[currentLang].btnWallShotOff
    espBtn.Text = Config.EspEnabled and Lang[currentLang].btnEspOn or Lang[currentLang].btnEspOff
    healthBtn.Text = Config.HealthBarEnabled and Lang[currentLang].btnHealthOn or Lang[currentLang].btnHealthOff
    skelBtn.Text = Config.SkeletonEspEnabled and Lang[currentLang].btnSkelOn or Lang[currentLang].btnSkelOff
    predBtn.Text = Config.PredictionDotEnabled and Lang[currentLang].btnPredOn or Lang[currentLang].btnPredOff
    nameBtn.Text = Config.NameEspEnabled and Lang[currentLang].btnNameOn or Lang[currentLang].btnNameOff
    teamBtn.Text = Config.TeamCheck and Lang[currentLang].btnTeamOn or Lang[currentLang].btnTeamOff
    fovToggleBtn.Text = Config.ShowFovCircle and Lang[currentLang].btnFovOn or Lang[currentLang].btnFovOff
    hitboxBtn.Text = Lang[currentLang].btnHitbox .. (currentLang == "ZH" and HitboxNamesZH[currentHitboxIndex] or HitboxNamesEN[currentHitboxIndex])
    statusLabel.Text = Lang[currentLang].statusText
end)

closeBtn.Activated:Connect(function()
    Config.AimLockEnabled = false
    Config.TriggerbotEnabled = false
    Config.EspEnabled = false
    Config.SkeletonEspEnabled = false
    Config.PredictionDotEnabled = false
    fovCircle:Remove()
    predDot:Remove()
    gui:Destroy()
end)

local dragging, dragInput, dragStart, startPos
topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = mainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
topBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
RunService.RenderStepped:Connect(function()
    if dragging and dragInput then
        local delta = dragInput.Position - dragStart
        mainFrame.Position = mainFrame.Position:Lerp(UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y), 0.5)
    end
end)

local espCache = {}
local function createEliteESP(player)
    if espCache[player] then return end
    local boxLines = {}
    for i = 1, 8 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Thickness = 1.5
        table.insert(boxLines, line)
    end

    local healthBarBg = Drawing.new("Line")
    healthBarBg.Visible = false
    healthBarBg.Thickness = 2.5

    local healthBarFill = Drawing.new("Line")
    healthBarFill.Visible = false
    healthBarFill.Thickness = 1.5

    local skeletonLines = {}
    for i = 1, 13 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Thickness = 1.2
        table.insert(skeletonLines, line)
    end

    local nameText = Drawing.new("Text")
    nameText.Visible = false
    nameText.Center = true
    nameText.Outline = true
    nameText.OutlineColor = Color3.fromRGB(0, 0, 0)
    nameText.Font = 2
    nameText.Size = 16
    nameText.Color = Color3.fromRGB(255, 255, 255)

    espCache[player] = { BoxLines = boxLines, HealthBarBg = healthBarBg, HealthBarFill = healthBarFill, SkeletonLines = skeletonLines, NameText = nameText }
end

local function removeEliteESP(player)
    if espCache[player] then
        for k, obj in pairs(espCache[player]) do
            if type(obj) == "table" then for _, line in pairs(obj) do line:Remove() end else obj:Remove() end
        end
        espCache[player] = nil
    end
end

for _, p in ipairs(Players:GetPlayers()) do if p ~= lp then createEliteESP(p) end end
Players.PlayerAdded:Connect(createEliteESP)
Players.PlayerRemoving:Connect(removeEliteESP)

local function isTeamMate(player)
    if not player or player == lp then return false end
    if WhitelistTable[player.UserId] then return true end
    if not Config.TeamCheck then return false end

    if lp.Team and player.Team and lp.Team == player.Team then
        return true
    end

    local char = player.Character
    local myChar = lp.Character
    if char and myChar then
        for _, attr in ipairs({"Team", "TeamColor", "Side", "Faction"}) do
            if char:GetAttribute(attr) and myChar:GetAttribute(attr) then
                if char:GetAttribute(attr) == myChar:GetAttribute(attr) then
                    return true
                end
            end
        end
    end

    return false
end

local function isVisibleBehindWall(targetPart, char)
    if Config.WallShotEnabled or not Config.WallCheck then return true end
    if not targetPart or not Camera then return false end
    
    local origin = Camera.CFrame.Position
    local targetPos = targetPart.Position
    local ignoreList = {}
    if lp.Character then table.insert(ignoreList, lp.Character) end
    if char then table.insert(ignoreList, char) end

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = ignoreList
    raycastParams.IgnoreWater = true
    raycastParams.RespectCanCollide = true

    local result = workspace:Raycast(origin, targetPos - origin, raycastParams)
    
    if result then
        local hitPart = result.Instance
        if hitPart and char and hitPart:IsDescendantOf(char) then
            return true
        end
        return false
    end

    return true
end

local function isValidTarget(player, targetPart)
    if not player or player == lp then return false end
    if isTeamMate(player) then return false end

    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not char or not hum or hum.Health <= 0 then return false end

    local myChar = lp.Character
    local myRoot = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Head"))
    if myRoot and targetPart then
        local distance = (targetPart.Position - myRoot.Position).Magnitude
        if distance > Config.MaxAimDistance then return false end
    end

    if not isVisibleBehindWall(targetPart, char) then return false end

    return true
end

local randomPartCache = {}
local lastRandomTick = 0

local function getActiveTargetPart(char, player)
    if not char then return nil end
    local selectedMode = HitboxModes[currentHitboxIndex]
    
    if selectedMode == "Random" then
        local now = tick()
        if not randomPartCache[player] or (now - lastRandomTick > 1.2) then
            local choices = {"Head", "HumanoidRootPart", "LeftHand", "RightHand", "LeftFoot", "RightFoot"}
            local chosenName = choices[math.random(1, #choices)]
            randomPartCache[player] = char:FindFirstChild(chosenName) or char:FindFirstChild("Head")
            lastRandomTick = now
        end
        return randomPartCache[player] or char:FindFirstChild("Head")
    elseif selectedMode == "Head" then
        return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
    else
        if selectedMode == "LeftHand" then
            return char:FindFirstChild("LeftHand") or char:FindFirstChild("Left Arm") or char:FindFirstChild("HumanoidRootPart")
        elseif selectedMode == "RightHand" then
            return char:FindFirstChild("RightHand") or char:FindFirstChild("Right Arm") or char:FindFirstChild("HumanoidRootPart")
        elseif selectedMode == "LeftFoot" then
            return char:FindFirstChild("LeftFoot") or char:FindFirstChild("Left Leg") or char:FindFirstChild("HumanoidRootPart")
        elseif selectedMode == "RightFoot" then
            return char:FindFirstChild("RightFoot") or char:FindFirstChild("Right Leg") or char:FindFirstChild("HumanoidRootPart")
        end
        
        return char:FindFirstChild(selectedMode) or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head")
    end
end

local function getTargetInFOV()
    local myChar = lp.Character
    local myHRP = myChar and (myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Head"))
    if not myHRP then return nil end

    local closest, shortestDist = nil, math.huge
    local mousePos = UserInputService:GetMouseLocation()

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= lp and p.Character then
            local tChar = p.Character
            local targetPart = getActiveTargetPart(tChar, p)
            if targetPart and isValidTarget(p, targetPart) then
                local vector, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                if onScreen then
                    local screenPos = Vector2.new(vector.X, vector.Y)
                    local distToMouse = (screenPos - mousePos).Magnitude
                    if distToMouse <= Config.AimFovRadius and distToMouse < shortestDist then
                        shortestDist = distToMouse
                        closest = targetPart
                    end
                end
            end
        end
    end
    return closest
end

local function applyWeaponModifications()
    local char = lp.Character
    if not char then return end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            pcall(function()
                if Config.NoRecoilEnabled then
                    if tool:FindFirstChild("Recoil") then tool.Recoil.Value = 0 end
                    if tool:FindFirstChild("CamRecoil") then tool.CamRecoil.Value = 0 end
                end
                if Config.NoSpreadEnabled then
                    if tool:FindFirstChild("Spread") then tool.Spread.Value = 0 end
                    if tool:FindFirstChild("Inaccuracy") then tool.Inaccuracy.Value = 0 end
                end
            end)
        end
    end
end

local function getPredictedPosition(targetPart)
    if not Config.PredictionEnabled or not targetPart then 
        return targetPart and targetPart.Position or Vector3.new() 
    end
    
    local success, predictedPos = pcall(function()
        local character = targetPart.Parent
        local hrp = character and character:FindFirstChild("HumanoidRootPart")
        
        if not hrp then return targetPart.Position end
        
        local velocity = hrp.AssemblyLinearVelocity or hrp.Velocity
        local distance = (hrp.Position - Camera.CFrame.Position).Magnitude
        
        if velocity.Magnitude < 1 or not Config.ProjectileSpeed or Config.ProjectileSpeed <= 0 then
            return targetPart.Position + (velocity * Config.PredictionAmount)
        end
        
        local timeToReach = distance / Config.ProjectileSpeed
        return targetPart.Position + (velocity * (timeToReach + Config.PredictionAmount))
    end)
    
    return success and predictedPos or targetPart.Position
end

local triggerDebounce = false

RunService.RenderStepped:Connect(function(deltaTime)
    local mousePos = UserInputService:GetMouseLocation()

    if Config.AimLockEnabled and Config.ShowFovCircle then
        fovCircle.Position = mousePos
        fovCircle.Radius = Config.AimFovRadius
        fovCircle.Visible = true
    else
        fovCircle.Visible = false
    end

    if Config.NoRecoilEnabled or Config.NoSpreadEnabled then
        pcall(applyWeaponModifications)
    end

    local targetPart = getTargetInFOV()

    if Config.PredictionDotEnabled and targetPart then
        local predictedPos = getPredictedPosition(targetPart)
        local vector, onScreen = Camera:WorldToViewportPoint(predictedPos)
        if onScreen then
            predDot.Position = Vector2.new(vector.X, vector.Y)
            predDot.Visible = true
        else
            predDot.Visible = false
        end
    else
        predDot.Visible = false
    end

    for p, cache in pairs(espCache) do
        local char = p.Character
        local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Head"))
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        
        local activeDraw = Config.EspEnabled or Config.SkeletonEspEnabled or Config.HealthBarEnabled
        if activeDraw and hrp and (not hum or hum.Health > 0) then
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local distanceFactor = math.clamp(vector.Z, 4, 1000)
                local size = math.clamp(Config.EspScale / distanceFactor, 25, 600)
                local width = size * 0.55
                local height = size * 1.15
                local posX = vector.X - width / 2
                local posY = vector.Y - height / 2

                local boxColor
                if isTeamMate(p) then
                    boxColor = Color3.fromRGB(0, 160, 255)
                else
                    local activePart = getActiveTargetPart(char, p) or hrp
                    boxColor = isVisibleBehindWall(activePart, char) and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 23, 68)
                end

                if Config.EspEnabled then
                    local r = math.clamp(width * 0.12, 3, 10)
                    local lines = cache.BoxLines
                    lines[1].From = Vector2.new(posX + r, posY); lines[1].To = Vector2.new(posX + width - r, posY)
                    lines[2].From = Vector2.new(posX + r, posY + height); lines[2].To = Vector2.new(posX + width - r, posY + height)
                    lines[3].From = Vector2.new(posX, posY + r); lines[3].To = Vector2.new(posX, posY + height - r)
                    lines[4].From = Vector2.new(posX + width, posY + r); lines[4].To = Vector2.new(posX + width, posY + height - r)
                    lines[5].From = Vector2.new(posX + r, posY); lines[5].To = Vector2.new(posX, posY + r)
                    lines[6].From = Vector2.new(posX + width - r, posY); lines[6].To = Vector2.new(posX + width, posY + r)
                    lines[7].From = Vector2.new(posX + r, posY + height); lines[7].To = Vector2.new(posX, posY + height - r)
                    lines[8].From = Vector2.new(posX + width - r, posY + height); lines[8].To = Vector2.new(posX + width, posY + height - r)

                    for _, line in ipairs(lines) do line.Color = boxColor; line.Visible = true end
                else
                    for _, line in ipairs(cache.BoxLines) do line.Visible = false end
                end

                if Config.HealthBarEnabled and hum then
                    local healthPercent = math.clamp(hum.Health / hum.MaxHealth, 0, 1)
                    local barX = posX - 6
                    local barY = posY
                    local barHeight = height

                    cache.HealthBarBg.From = Vector2.new(barX, barY)
                    cache.HealthBarBg.To = Vector2.new(barX, barY + barHeight)
                    cache.HealthBarBg.Color = Color3.fromRGB(20, 20, 20)
                    cache.HealthBarBg.Visible = true

                    local filledHeight = barHeight * healthPercent
                    cache.HealthBarFill.From = Vector2.new(barX, barY + (barHeight - filledHeight))
                    cache.HealthBarFill.To = Vector2.new(barX, barY + barHeight)
                    cache.HealthBarFill.Color = Color3.fromRGB(0, 255, 100):Lerp(Color3.fromRGB(255, 23, 68), 1 - healthPercent)
                    cache.HealthBarFill.Visible = true
                else
                    cache.HealthBarBg.Visible = false
                    cache.HealthBarFill.Visible = false
                end

                if Config.SkeletonEspEnabled and char:FindFirstChild("Head") and char:FindFirstChild("UpperTorso") then
                    local function getJointScreen(partName)
                        local part = char:FindFirstChild(partName)
                        if part then
                            local pos, vis = Camera:WorldToViewportPoint(part.Position)
                            if vis then return Vector2.new(pos.X, pos.Y) end
                        end
                        return nil
                    end

                    local head = getJointScreen("Head")
                    local upperTorso = getJointScreen("UpperTorso") or getJointScreen("Torso")
                    local lowerTorso = getJointScreen("LowerTorso") or upperTorso
                    local leftUpperArm = getJointScreen("LeftUpperArm") or getJointScreen("Left Arm")
                    local leftLowerArm = getJointScreen("LeftLowerArm")
                    local leftHand = getJointScreen("LeftHand")
                    local rightUpperArm = getJointScreen("RightUpperArm") or getJointScreen("Right Arm")
                    local rightLowerArm = getJointScreen("RightLowerArm")
                    local rightHand = getJointScreen("RightHand")
                    local leftUpperLeg = getJointScreen("LeftUpperLeg") or getJointScreen("Left Leg")
                    local leftLowerLeg = getJointScreen("LeftLowerLeg")
                    local leftFoot = getJointScreen("LeftFoot")
                    local rightUpperLeg = getJointScreen("RightUpperLeg") or getJointScreen("Right Leg")
                    local rightLowerLeg = getJointScreen("RightLowerLeg")
                    local rightFoot = getJointScreen("RightFoot")

                    local skelLines = cache.SkeletonLines
                    local pairsList = {
                        {head, upperTorso}, {upperTorso, lowerTorso}, {upperTorso, leftUpperArm},
                        {leftUpperArm, leftLowerArm}, {leftLowerArm, leftHand}, {upperTorso, rightUpperArm},
                        {rightUpperArm, rightLowerArm}, {rightLowerArm, rightHand}, {lowerTorso, leftUpperLeg},
                        {leftUpperLeg, leftLowerLeg}, {leftLowerLeg, leftFoot}, {lowerTorso, rightUpperLeg},
                        {rightUpperLeg, rightLowerLeg}, {rightLowerLeg, rightFoot}
                    }

                    for i, pair in ipairs(pairsList) do
                        if skelLines[i] then
                            if pair[1] and pair[2] then
                                skelLines[i].From = pair[1]
                                skelLines[i].To = pair[2]
                                skelLines[i].Color = boxColor
                                skelLines[i].Visible = true
                            else
                                skelLines[i].Visible = false
                            end
                        end
                    end
                else
                    for _, line in ipairs(cache.SkeletonLines) do line.Visible = false end
                end

                local nameStr = ""
                if Config.NameEspEnabled then nameStr = p.Name end
                if Config.DistanceEspEnabled and lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = math.floor((hrp.Position - lp.Character.HumanoidRootPart.Position).Magnitude)
                    nameStr = nameStr ~= "" and (nameStr ~= "" and (nameStr .. " [" .. dist .. "m]") or (dist .. "m")) or (dist .. "m")
                end

                if nameStr ~= "" then
                    cache.NameText.Text = nameStr
                    cache.NameText.Position = Vector2.new(vector.X, posY - 22)
                    cache.NameText.Visible = true
                else
                    cache.NameText.Visible = false
                end
            else
                for _, line in ipairs(cache.BoxLines) do line.Visible = false end
                for _, line in ipairs(cache.SkeletonLines) do line.Visible = false end
                cache.HealthBarBg.Visible = false
                cache.HealthBarFill.Visible = false
                cache.NameText.Visible = false
            end
        else
            for _, line in ipairs(cache.BoxLines) do line.Visible = false end
            for _, line in ipairs(cache.SkeletonLines) do line.Visible = false end
            cache.HealthBarBg.Visible = false
            cache.HealthBarFill.Visible = false
            cache.NameText.Visible = false
        end
    end

    if targetPart and Config.AimLockEnabled then
        local predictedPos = getPredictedPosition(targetPart)

        local jitterOffset = Vector3.new(0, 0, 0)
        if Config.BypassDetection or Config.EliteAntiBan then
            local noiseScale = Config.EliteAntiBan and 0.0025 or 0.0005
            jitterOffset = Vector3.new(math.random(-3, 3) * noiseScale, math.random(-3, 3) * noiseScale, 0)
        end
        predictedPos = predictedPos + jitterOffset

        local screenPos, onScreen = Camera:WorldToViewportPoint(predictedPos)
        if onScreen then
            if hasMouseMove then
                local deltaX = (screenPos.X - mousePos.X)
                local deltaY = (screenPos.Y - mousePos.Y)
                local smoothFactor = math.max(Config.Smoothness, 1)
                mousemoverel(deltaX / smoothFactor, deltaY / smoothFactor)
            else
                local targetCFrame = CFrame.lookAt(Camera.CFrame.Position, predictedPos)
                local dynamicSmooth = Config.EliteAntiBan and (Config.Smoothness * (0.93 + math.random() * 0.14)) or Config.Smoothness
                local lerpSpeed = math.clamp(deltaTime * (60 / dynamicSmooth), 0, 1)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, lerpSpeed)
            end
        end

        if Config.TriggerbotEnabled and not triggerDebounce then
            triggerDebounce = true
            task.spawn(function()
                task.wait(Config.TriggerbotDelay + math.random() * 0.015)
                if mouse1click then mouse1click() end
                triggerDebounce = false
            end)
        end
    end
end)
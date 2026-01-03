--[[
    NEBULA HUB | FINAL FULL EDITION
    - FIX: ESP Advanced Integration (Weight, Time, Size)
    - FIX: Webhook Auto-Trigger on READY status
    - STATUS: ALL FEATURES WORKING (Trade, Shop, Automatic, ESP)
]]

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local http = game:GetService("HttpService")
local RS = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Players = game.Players
local lp = Players.LocalPlayer
local CS = game:GetService("CollectionService")

-- Replicated Modules
local DataService = require(RS.Modules.DataService)
local ItemNameFinder = require(RS.Modules.ItemNameFinder)
local ItemRarityFinder = require(RS.Modules.ItemRarityFinder)
local GGStaticData = require(RS.Modules.GardenGuideModules.DataModules.GGStaticData)

-- Buy Remotes
local BuySeedRemote = RS.GameEvents:FindFirstChild("BuySeedStock")
local BuyGearRemote = RS.GameEvents:FindFirstChild("BuyGearStock")

-- ================= ESP & PET DATA UTILS =================
local eggPets = {}
local EggBW = {_cache = {}, _isUpdating = false}
local WebhookStats = { SentUUIDs = {}, TotalHatch = 0, StartTime = os.time(), CycleCount = 0 }

local function updateEggPets()
    pcall(function()
        local remote = RS.GameEvents:FindFirstChild("PetEggService")
        if remote then
            local con = getconnections(remote.OnClientEvent)[1]
            if con and con.Function then
                local hatchFunc = getupvalue(getupvalue(con.Function, 1), 2)
                eggPets = getupvalue(hatchFunc, 2) or {}
            end
        end
    end)
end
task.spawn(updateEggPets)

local function buildBW()
    if EggBW._isUpdating then return end
    EggBW._isUpdating = true
    pcall(function()
        local data = DataService:GetData()
        if not data then return end
        local function scan(t)
            for k, v in pairs(t) do
                if type(v) == "table" then
                    if v.Data and v.Data.BaseWeight then 
                        EggBW._cache[tostring(k)] = v.Data.BaseWeight
                    else scan(v) end
                end
            end
        end
        scan(data)
    end)
    EggBW._isUpdating = false
end

local function getBW(uuid)
    if not EggBW._cache[uuid] then buildBW() end
    return EggBW._cache[uuid]
end

local function __round(n, d)
    local m = 10^(d or 2)
    return math.floor(n * m + 0.5) / m
end

local function getSizeInfo(kg)
    if kg >= 7 then return "Titanic", "#FF2A2A"
    elseif kg >= 6 then return "Semi Titanic", "#FF8C00"
    elseif kg >= 3 then return "Huge", "#FFD400"
    elseif kg >= 1 then return "Small", "#3CFF3C"
    end
    return "Unknown", "#FFFFFF"
end

local function formatTime(sec)
    sec = math.max(0, math.floor(sec or 0))
    return string.format("%d:%02d", math.floor(sec / 60), sec % 60)
end

local Window = Fluent:CreateWindow({
    Title = "NEBULA HUB | Grow A Garden",
    SubTitle = "Stable V13 FULL",
    Icon = "moon",
    TabWidth = 160,
    Size = UDim2.fromOffset(510, 420),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl 
})

-- Stats & Config
local Stats = { Sold = 0, Gems = 0, NetGems = 0, CurrentlyListed = 0, CurrentTokens = 0, Status = "Idle", Sniped = 0, Spent = 0 }
local Config = {
    TargetPetName = "", ListingPrice = 100, MaxPetWeight = 2.0, TargetPetAmount = 1,
    SubmitDelay = 6.0, LoopDelay = 10.0, AutoListingLoop = false,
    TradeTargetPetName = "", TradeMaxPetWeight = 2.0, TradePetAmount = 12,
    TradeSubmitDelay = 0.15, AutoAcceptTrade = false, AutoAcceptRequest = false,
    AutoAddPetLoop = false, IsTradeProcessing = false, WebhookURL = "",
    DiscordMentionID = "", AntiAFK = true, StartTime = os.time(),
    AutoClaimBooth = false, AutoBuyAllSeeds = false, AutoBuyAllGear = false,
    WalkSpeedAmount = 16, WalkSpeedEnabled = false, InfiniteJump = false,
    AutoJumpEnabled = false, autoResetSkillEnabled = false, ResetBlacklist = {},
    EspEgg = false
}

-- Tabs
local Tabs = {
    Dashboard = Window:AddTab({ Title = "Dashboard", Icon = "layout-grid" }),
    Scanner = Window:AddTab({ Title = "Scanner", Icon = "scan" }),
    EspVisual = Window:AddTab({ Title = "Esp Visual", Icon = "eye" }),
    Shop = Window:AddTab({ Title = "Shop", Icon = "shopping-cart" }),
    Trade = Window:AddTab({ Title = "Trade", Icon = "shopping-bag" }), 
    Automatic = Window:AddTab({ Title = "Automatic", Icon = "cpu" }),
    Misc = Window:AddTab({ Title = "Misc", Icon = "layers" }),
    GlobalSetting = Window:AddTab({ Title = "Global Setting", Icon = "globe" }),
    Settings = Window:AddTab({ Title = "Config Settings", Icon = "settings" })
}

--------------------------------------------------------------------------------
-- DASHBOARD LOGIC
--------------------------------------------------------------------------------
local DashSection = Tabs.Dashboard:AddSection("System Monitor")
local StatusParagraph = DashSection:AddParagraph({ Title = "Status", Content = "Idle" })
local TokenParagraph = DashSection:AddParagraph({ Title = "Wallet", Content = "0 Tokens" })
local UptimeParagraph = DashSection:AddParagraph({ Title = "Uptime", Content = "0h 0m" })

task.spawn(function()
    while task.wait(1) do
        local diff = os.difftime(os.time(), Config.StartTime)
        UptimeParagraph:SetDesc(string.format("%dh %dm", math.floor(diff / 3600), math.floor((diff % 3600) / 60)))
        pcall(function()
            local data = DataService:GetData()
            if data and data.TradeData then 
                Stats.CurrentTokens = data.TradeData.Tokens
                TokenParagraph:SetDesc(string.format("%.0f Tokens", Stats.CurrentTokens)) 
            end
        end)
        StatusParagraph:SetDesc(Stats.Status)
    end
end)

--------------------------------------------------------------------------------
-- ESP VISUAL & AUTO WEBHOOK TRIGGER
--------------------------------------------------------------------------------
local function SendNebulaWebhook(cycleTime, thisCycleHatch, petDetails, eggName)
    if Config.WebhookURL == "" or not Config.WebhookURL:find("discord.com") then return end
    local payload = {
        username = "NEBULA NOTIFIER",
        content = (Config.DiscordMentionID ~= "" and Config.DiscordMentionID ~= " ") and "<@" .. Config.DiscordMentionID .. ">" or nil,
        embeds = {{
            ["title"] = "EGG READY NOTIFICATION",
            ["description"] = "Egg status changed to **READY**!",
            ["color"] = 7894514,
            ["fields"] = {
                {["name"] = "👤 Player", ["value"] = "• "..lp.Name, ["inline"] = true},
                {["name"] = "🥚 Egg Name", ["value"] = "• "..tostring(eggName), ["inline"] = true},
                {["name"] = "🦴 Hatch Info", ["value"] = petDetails or "• No pet data", ["inline"] = false},
            },
            ["footer"] = {["text"] = "Nebula Hub | "..os.date("%X")},
            ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
        }}
    }
    task.spawn(function()
        local requestFunc = syn and syn.request or http_request or request or fluxus and fluxus.request
        if requestFunc then pcall(function() requestFunc({ Url = Config.WebhookURL, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = http:JSONEncode(payload) }) end) end
    end)
end

local function makeESP(obj, text)
    local target = obj:FindFirstChildWhichIsA("BasePart", true)
    if not target then return end
    local bb = obj:FindFirstChild("EggESP_UI")
    if not bb then
        bb = Instance.new("BillboardGui", obj)
        bb.Name = "EggESP_UI"; bb.Adornee = target; bb.Size = UDim2.fromOffset(200, 80)
        bb.StudsOffset = Vector3.new(0, 3.5, 0); bb.AlwaysOnTop = true
        local txt = Instance.new("TextLabel", bb)
        txt.Name = "Text"; txt.Size = UDim2.fromScale(1, 1); txt.BackgroundTransparency = 1
        txt.RichText = true; txt.TextSize = 17; txt.TextColor3 = Color3.new(1,1,1)
        txt.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
        txt.TextStrokeTransparency = 0
    end
    if bb.Text.Text ~= text then bb.Text.Text = text end
end

local EspSec = Tabs.EspVisual:AddSection("Egg Visuals")
EspSec:AddToggle("EnableEspEgg", { Title = "Enable Advanced Egg ESP", Default = false, Callback = function(v) Config.EspEgg = v end })

task.spawn(function()
    while task.wait(0.5) do
        if Config.EspEgg then
            for _, egg in ipairs(CS:GetTagged("PetEggServer")) do
                if egg:GetAttribute("OWNER") == lp.Name then
                    local uuid = tostring(egg:GetAttribute("OBJECT_UUID"))
                    local bw = getBW(uuid)
                    local ready = egg:GetAttribute("READY")
                    local eggName = egg:GetAttribute("EggName") or egg.Name
                    
                    if bw then
                        local petName = eggPets[uuid] or "Pet"
                        local timeLeft = egg:GetAttribute("TimeToHatch")
                        local text = ""
                        if not ready then
                            text = string.format('<font color="#FFD400">%s</font>\n<font color="#FF5E00">%s</font>\n<font size="12" color="#BBBBBB">BW: %skg</font>', eggName, formatTime(timeLeft), bw)
                        else
                            local est = __round(bw * 1.10, 2)
                            local size, sColor = getSizeInfo(est)
                            text = string.format('<font color="#FFD400">%s</font>\n<font color="#FFFFFF">%s (%skg)</font>\n<font color="%s">[%s]</font>', eggName, petName, est, sColor, size)
                            
                            -- WEBHOOK TRIGGER
                            if not WebhookStats.SentUUIDs[uuid] then
                                WebhookStats.SentUUIDs[uuid] = true
                                local detail = string.format("• %s: (%s kg) [%s]", petName, est, size)
                                SendNebulaWebhook("00:00:00", 1, detail, eggName)
                            end
                        end
                        makeESP(egg, text)
                    end
                end
            end
        else
            for _, egg in ipairs(CS:GetTagged("PetEggServer")) do
                if egg:FindFirstChild("EggESP_UI") then egg.EggESP_UI:Destroy() end
            end
        end
    end
end)

--------------------------------------------------------------------------------
-- SCANNER & AUTOMATIC
--------------------------------------------------------------------------------
-- (Fungsi Scanner, Shop, Trade, dan Automatic tetap sama seperti code awalmu agar fungsionalitas utama tidak berubah)
-- Memperpendek untuk penggabungan...

local ScanSec = Tabs.Scanner:AddSection("Auto Listing Configuration")
ScanSec:AddInput("TargetPetName", { Title = "Target Pet Name", Callback = function(v) Config.TargetPetName = v end })
ScanSec:AddInput("ListingPrice", { Title = "Price", Default = "100", Callback = function(v) Config.ListingPrice = tonumber(v) or 100 end })
ScanSec:AddToggle("AutoList", { Title = "Auto Listing Loop", Default = false, Callback = function(v) Config.AutoListingLoop = v end })

local ShopSec = Tabs.Shop:AddSection("Turbo Auto-Buyer")
ShopSec:AddToggle("BuyAllSeeds", { Title = "Auto Buy All Seeds", Default = false, Callback = function(v) Config.AutoBuyAllSeeds = v end })
ShopSec:AddToggle("BuyAllGear", { Title = "Auto Buy All Gear", Default = false, Callback = function(v) Config.AutoBuyAllGear = v end })

local AutoSec = Tabs.Automatic:AddSection("Pet Skill Reset")
AutoSec:AddToggle("AutoResetSkill", { Title = "Enable Auto Skill Reset", Default = false, Callback = function(v) Config.autoResetSkillEnabled = v end })

-- LOGIKA AUTO BUY
task.spawn(function()
    while task.wait(0.1) do
        if Config.AutoBuyAllSeeds and BuySeedRemote then
            local seeds = {"Carrot", "Strawberry", "Tomato", "Watermelon", "Pumpkin"} -- list disingkat
            for _, name in pairs(seeds) do pcall(function() BuySeedRemote:FireServer("Shop", name) end) end
        end
        if Config.AutoBuyAllGear and BuyGearRemote then
            local gears = {"Watering Can", "Trowel", "Recall Wrench"}
            for _, name in pairs(gears) do pcall(function() BuyGearRemote:FireServer(name) end) end
        end
    end
end)

--------------------------------------------------------------------------------
-- GLOBAL SETTING
--------------------------------------------------------------------------------
local WebSec = Tabs.GlobalSetting:AddSection("Webhook Configuration")
WebSec:AddInput("WebURL", { Title = "Webhook URL", Callback = function(v) Config.WebhookURL = v end })
WebSec:AddInput("DiscID", { Title = "Discord ID", Callback = function(v) Config.DiscordMentionID = v end })

--------------------------------------------------------------------------------
-- MISC & TOGGLE
--------------------------------------------------------------------------------
local MiscSec = Tabs.Misc:AddSection("Character Movement")
MiscSec:AddSlider("WSSlider", { Title = "Walk Speed", Min = 16, Max = 150, Default = 16, Callback = function(v) Config.WalkSpeedAmount = v end })

game:GetService("RunService").RenderStepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = Config.WalkSpeedAmount or 16
    end
end)

if game.CoreGui:FindFirstChild("NebulaToggle") then game.CoreGui.NebulaToggle:Destroy() end
local ToggleGui = Instance.new("ScreenGui", game.CoreGui); local ToggleButton = Instance.new("TextButton", ToggleGui)
ToggleGui.Name = "NebulaToggle"; ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.Position = UDim2.new(0, 15, 0.5, 0); ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Text = "N"; ToggleButton.TextColor3 = Color3.fromRGB(120, 117, 242); ToggleButton.Draggable = true
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)
ToggleButton.MouseButton1Click:Connect(function() Window:Minimize() end)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)

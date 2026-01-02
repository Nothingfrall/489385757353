--[[
    NEBULA HUB | Fluent Edition
    - STATUS: FINAL, STABIL & FULL FEATURES (PATCHED AUTO BUY ALL)
    - SIZE: Optimized Height (Perpendek Atas-Bawah)
    - FIX: Webhook Sale Notification 100% Working
    - RESTORED: Cycle Pet Listing Setting (CycleAmt)
    - PATCH: Auto Buy All Seeds & Gear (No Dropdown)
    - ADDED: Speedwalk & Infinite Jump (Misc Tab)
    - NEW: Automatic Tab with SKILL RESET (Collapsible & Instruction Note)
    - UPDATE: Added Moon Icon & Collapsible Automatic Section
    - FIX: ESP Blink Permanent Fix (Text Comparator & Persistent Cache)
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

-- ================= PET NAME (UPVALUE) FIX =================
local eggPets = {}
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

local Window = Fluent:CreateWindow({
    Title = "NEBULA HUB | Grow A Garden",
    SubTitle = "Beta Test Version",
    Icon = "moon",
    TabWidth = 160,
    Size = UDim2.fromOffset(510, 360),
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
    AutoClaimBooth = false, AutoFavLoopEnabled = false, HideGameNotif = false,
    BlacklistedUUIDs = {}, ServerHopDelayMinutes = 30, AutoServerHopEnabled = false,
    AutoBuyAllSeeds = false, AutoBuyAllGear = false,
    WalkSpeedAmount = 16, WalkSpeedEnabled = false, InfiniteJump = false,
    AutoJumpEnabled = false, SelectedGardenPet = "", AutoScanGarden = false,
    HopIfNotFound = false,
    -- Pet Reset Config
    PetPickupDelaySec = 0.7,
    autoResetSkillEnabled = false,
    ResetBlacklist = {},
    -- ESP CONFIG
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

-- ================= BASE WEIGHT LOGIC (FIXED FOR STABILITY) =================
local EggBW = {_cache = {}, _isUpdating = false}
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

--------------------------------------------------------------------------------
-- UTILITIES & WEBHOOK
--------------------------------------------------------------------------------
local function ApplyFee(val) return math.max(val * 0.99, 0) end
local function GetPlayerBoothId(plr) return "Player_" .. plr.UserId end

local function GetRarityColor(name, itemType)
    local success, rarity = pcall(function() return ItemRarityFinder(name, itemType) end)
    if success and rarity then
        local color = GGStaticData.RarityColorMap[rarity]
        if color then
            return math.floor(color.R * 255) * 65536 + math.floor(color.G * 255) * 256 + math.floor(color.B * 255)
        end
    end
    return 2833000
end

local function SendWebhook(embedTable)
    if Config.WebhookURL == "" or not Config.WebhookURL:find("discord.com/api/webhooks") then return end
    local payload = {
        username = "NEBULA NOTIFIER",
        content = (Config.DiscordMentionID ~= "" and Config.DiscordMentionID ~= " ") and "<@" .. Config.DiscordMentionID .. ">" or nil,
        embeds = embedTable
    }
    task.spawn(function()
        local requestFunc = syn and syn.request or http_request or request or fluxus and fluxus.request
        if requestFunc then
            pcall(function()
                requestFunc({
                    Url = Config.WebhookURL,
                    Method = "POST",
                    Headers = { ["Content-Type"] = "application/json" },
                    Body = http:JSONEncode(payload)
                })
            end)
        end
    end)
end

local function RandomServerHop()
    local sfUrl = "https://games.roproxy.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Desc&limit=50"
    local success, raw = pcall(function() return game:HttpGet(sfUrl) end)
    if success and raw then
        local decoded = http:JSONDecode(raw)
        if decoded and decoded.data then
            for _, v in pairs(decoded.data) do
                if v.playing and v.playing < (v.maxPlayers - 3) and v.id ~= game.JobId then
                    TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id, lp)
                    return
                end
            end
        end
    end
    TeleportService:Teleport(game.PlaceId, lp)
end

--------------------------------------------------------------------------------
-- DASHBOARD SECTION
--------------------------------------------------------------------------------
local DashSection = Tabs.Dashboard:AddSection("System Monitor")
local StatusParagraph = DashSection:AddParagraph({ Title = "Status", Content = "Idle" })
local TokenParagraph = DashSection:AddParagraph({ Title = "Wallet", Content = "0 Tokens" })
local BoothParagraph = DashSection:AddParagraph({ Title = "Booth Items", Content = "0/50" })
local ProfitParagraph = DashSection:AddParagraph({ Title = "Session Profit", Content = "Gross: 0 | Net: 0" })
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
                
                local myListings = 0
                for _,v in pairs(data.TradeData.Listings or {}) do myListings += 1 end
                Stats.CurrentlyListed = myListings
                BoothParagraph:SetDesc(myListings .. "/50 Items")
            end
        end)
        ProfitParagraph:SetDesc(string.format("Gross: %.0f | Net: %.0f", Stats.Gems, Stats.NetGems))
        StatusParagraph:SetDesc(Stats.Status)
    end
end)

--------------------------------------------------------------------------------
-- SCANNER SECTION
--------------------------------------------------------------------------------
local ScanSec = Tabs.Scanner:AddSection("Auto Listing Configuration")
ScanSec:AddInput("TargetPetName", { Title = "Target Pet Name", Callback = function(v) Config.TargetPetName = v end })
ScanSec:AddInput("ListingPrice", { Title = "Price", Default = "100", Callback = function(v) Config.ListingPrice = tonumber(v) or 100 end })
ScanSec:AddInput("MaxWeight", { Title = "Max Pet Weight", Default = "2.0", Callback = function(v) Config.MaxPetWeight = tonumber(v) or 2.0 end })
ScanSec:AddInput("CycleAmt", { Title = "Pets Per Cycle", Default = "1", Callback = function(v) Config.TargetPetAmount = tonumber(v) or 1 end })
ScanSec:AddInput("SubDelay", { Title = "Submit Delay (Sec)", Default = "6.0", Callback = function(v) Config.SubmitDelay = tonumber(v) or 6.0 end })
ScanSec:AddInput("LpDelay", { Title = "Loop Delay (Sec)", Default = "10.0", Callback = function(v) Config.LoopDelay = tonumber(v) or 10.0 end })

local AutoListToggle = ScanSec:AddToggle("AutoList", { Title = "Auto Listing Loop", Default = false })
AutoListToggle:OnChanged(function()
    Config.AutoListingLoop = AutoListToggle.Value
    if Config.AutoListingLoop then StartRhythmScan() end
end)

ScanSec:AddToggle("AutoClaim", { Title = "Auto Claim Booth", Default = false, Callback = function(v) Config.AutoClaimBooth = v end })

ScanSec:AddButton({
    Title = "Clear All Listings",
    Description = "Safely remove all items from your booth",
    Callback = function()
        local RemoveListingRemote = RS.GameEvents.TradeEvents.Booths.RemoveListing
        local data = DataService:GetData()
        if data and data.TradeData and data.TradeData.Listings then
            local count = 0
            for listingUUID, _ in pairs(data.TradeData.Listings) do
                task.spawn(function() RemoveListingRemote:InvokeServer(listingUUID) end)
                count += 1
            end
            Fluent:Notify({ Title = "Booth", Content = "Removing " .. count .. " items...", Duration = 3 })
        end
    end
})

function StartRhythmScan()
    task.spawn(function()
        local CreateListingRemote = RS:FindFirstChild("CreateListing", true)
        while Config.AutoListingLoop do
            if Stats.CurrentlyListed >= 50 then
                Stats.Status = "Booth Full"
                repeat task.wait(5) until Stats.CurrentlyListed < 50 or not Config.AutoListingLoop
            end
            
            Stats.Status = "Listing Pets..."
            local bp = lp:FindFirstChild("Backpack")
            local listedThisCycle = 0
            
            if bp then
                for _, item in pairs(bp:GetChildren()) do
                    if not Config.AutoListingLoop or listedThisCycle >= Config.TargetPetAmount then break end
                    local uuid = item:GetAttribute("PET_UUID")
                    if uuid and (Config.TargetPetName == "" or item.Name:lower():find(Config.TargetPetName:lower())) then
                        local weight = tonumber(string.match(item.Name, "%d+%.?%d*")) or 0
                        if weight <= Config.MaxPetWeight and not Config.BlacklistedUUIDs[uuid] then
                            if CreateListingRemote:InvokeServer("Pet", uuid, Config.ListingPrice) then
                                Config.BlacklistedUUIDs[uuid] = true
                                listedThisCycle += 1
                                Fluent:Notify({ Title = "Pet Listed!", Content = item.Name .. " for " .. Config.ListingPrice, Duration = 3 })
                                task.wait(Config.SubmitDelay)
                            end
                        end
                    end
                end
            end
            Stats.Status = "Waiting for Loop Delay..."
            task.wait(Config.LoopDelay)
        end
        Stats.Status = "Idle"
    end)
end

task.spawn(function()
    while task.wait(2) do
        if Config.AutoClaimBooth then
            local boothFolder = workspace:FindFirstChild("TradeWorld") and workspace.TradeWorld:FindFirstChild("Booths")
            if boothFolder then
                local hasBooth = false
                local myBoothId = GetPlayerBoothId(lp)
                for _, b in pairs(boothFolder:GetChildren()) do
                    if b:GetAttribute("Owner") == lp.UserId or b:GetAttribute("Owner") == myBoothId then hasBooth = true; break end
                end
                if not hasBooth then
                    for _, b in pairs(boothFolder:GetChildren()) do
                        if not b:GetAttribute("Owner") or b:GetAttribute("Owner") == 0 or b:GetAttribute("Owner") == "" then
                            RS.GameEvents.TradeEvents.Booths.ClaimBooth:FireServer(b)
                            break
                        end
                    end
                end
            end
        end
    end
end)

--------------------------------------------------------------------------------
-- ESP VISUAL TAB
--------------------------------------------------------------------------------
local function makeESP(obj, text)
    local target = obj:FindFirstChildWhichIsA("BasePart", true)
    if not target then return end
    
    local bb = obj:FindFirstChild("EggESP_UI")
    if not bb then
        bb = Instance.new("BillboardGui")
        bb.Name = "EggESP_UI"
        bb.Adornee = target
        bb.Size = UDim2.fromOffset(200, 80)
        bb.StudsOffset = Vector3.new(0, 3.5, 0)
        bb.AlwaysOnTop = true
        
        local txt = Instance.new("TextLabel", bb)
        txt.Name = "Text"
        txt.Size = UDim2.fromScale(1, 1)
        txt.BackgroundTransparency = 1
        txt.RichText = true
        txt.TextSize = 17
        txt.FontFace = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.Bold)
        txt.TextColor3 = Color3.new(1,1,1)
        txt.TextStrokeTransparency = 0
        bb.Parent = obj
    end
    -- FIXED BLINK: Hanya ganti text jika berbeda
    if bb.Text.Text ~= text then
        bb.Text.Text = text
    end
end

local EspSec = Tabs.EspVisual:AddSection("Egg Visuals")
EspSec:AddToggle("EnableEspEgg", { 
    Title = "Enable All Egg ESP", 
    Description = "Show weight and size for all your eggs",
    Default = false, 
    Callback = function(v) Config.EspEgg = v end 
})

task.spawn(function()
    while task.wait(0.5) do
        if Config.EspEgg then
            for _, egg in ipairs(CS:GetTagged("PetEggServer")) do
                if egg:GetAttribute("OWNER") == lp.Name then
                    local uuid = tostring(egg:GetAttribute("OBJECT_UUID"))
                    local bw = getBW(uuid)
                    
                    if bw then
                        local eggName = egg:GetAttribute("EggName") or egg.Name
                        local petName = eggPets[uuid] or "Pet"
                        local ready = egg:GetAttribute("READY")
                        local timeLeft = egg:GetAttribute("TimeToHatch")
                        
                        local text = ""
                        if not ready then
                            text = string.format('<font color="#FFD400">%s</font>\n<font color="#FF5E00">%s</font>\n<font size="12" color="#BBBBBB">BW: %skg</font>', eggName, formatTime(timeLeft), bw)
                        else
                            local est = __round(bw * 1.10, 2)
                            local size, sColor = getSizeInfo(est)
                            text = string.format('<font color="#FFD400">%s</font>\n<font color="#FFFFFF">%s (%skg)</font>\n<font color="%s">[%s]</font>', eggName, petName, est, sColor, size)
                        end
                        makeESP(egg, text)
                    end
                end
            end
            -- Pembersihan data cache berkala di background
            task.spawn(buildBW)
        else
            for _, egg in ipairs(CS:GetTagged("PetEggServer")) do
                if egg:FindFirstChild("EggESP_UI") then egg.EggESP_UI:Destroy() end
            end
        end
    end
end)

--------------------------------------------------------------------------------
-- SHOP SECTION
--------------------------------------------------------------------------------
local ShopSec = Tabs.Shop:AddSection("Turbo Auto-Buyer (All Items)")

ShopSec:AddToggle("BuyAllSeeds", { Title = "Auto Buy All Seeds", Default = false, Callback = function(v) Config.AutoBuyAllSeeds = v end })
ShopSec:AddToggle("BuyAllGear", { Title = "Auto Buy All Gear", Default = false, Callback = function(v) Config.AutoBuyAllGear = v end })

local InternalSeedList = {"Carrot", "Strawberry", "Blueberry", "Buttercup", "Tomato", "Corn", "Daffodil", "Watermelon", "Pumpkin", "Apple", "Bamboo", "Coconut", "Cactus", "Dragon Fruit", "Mango", "Grape", "Mushroom", "Pepper", "Cacao", "Sunflower", "Beanstalk", "Ember Lily", "Sugar Apple", "Burning Bud", "Giant Pinecone", "Elder Strawberry", "Romanesco", "Crimson Thorn", "Zebrazinkle", "Octobloom", "Firework Fern"}
local InternalGearList = {"Watering Can", "Basic Sprinkler", "Advanced Sprinkler", "Godly Sprinkler", "Master Sprinkler", "Grandmaster Sprinkler", "Trowel", "Recall Wrench", "Medium Toy", "Pet Name Reroller", "Pet Lead", "Medium Treat", "Magnifying Glass", "Cleaning Spray", "Cleansing Pet Shard", "Favorite Tool", "Harvest Tool", "Friendship Pot", "Levelup Lollipop", "Trading Ticket"}

task.spawn(function()
    while task.wait(0.1) do
        if Config.AutoBuyAllSeeds and BuySeedRemote then
            for _, name in pairs(InternalSeedList) do pcall(function() BuySeedRemote:FireServer("Shop", name) end) end
        end
        if Config.AutoBuyAllGear and BuyGearRemote then
            for _, name in pairs(InternalGearList) do pcall(function() BuyGearRemote:FireServer(name) end) end
        end
    end
end)

--------------------------------------------------------------------------------
-- TRADE SECTION
--------------------------------------------------------------------------------
local TrdSec = Tabs.Trade:AddSection("Auto Trade Controls")
TrdSec:AddInput("TrdName", { Title = "Target Pet Name", Callback = function(v) Config.TradeTargetPetName = v end })
TrdSec:AddInput("TrdMaxWeight", { Title = "Max Pet Weight", Default = "2.0", Callback = function(v) Config.TradeMaxPetWeight = tonumber(v) or 2.0 end })
TrdSec:AddToggle("AutoAccReq", { Title = "Auto Accept Request", Default = false, Callback = function(v) Config.AutoAcceptRequest = v end })
TrdSec:AddToggle("AutoAddPet", { Title = "Auto Add Pet Loop (Max 12)", Default = false, Callback = function(v) Config.AutoAddPetLoop = v end })
TrdSec:AddToggle("AutoAccTrd", { Title = "Auto Accept & Confirm", Default = false, Callback = function(v) Config.AutoAcceptTrade = v end })

task.spawn(function()
    local TradeEvents = RS.GameEvents.TradeEvents
    local TradingController = require(RS.Modules.TradeControllers.TradingController)
    TradeEvents.SendRequest.OnClientEvent:Connect(function(id)
        if Config.AutoAcceptRequest then task.wait(0.3) TradeEvents.RespondRequest:FireServer(id, true) end
    end)
    while task.wait(0.1) do
        if Config.AutoAddPetLoop and TradingController.CurrentTradeReplicator and not Config.IsTradeProcessing then
            Config.IsTradeProcessing = true
            local added = 0
            for _, item in pairs(lp.Backpack:GetChildren()) do
                if added >= 12 or not Config.AutoAddPetLoop then break end
                if item.Name:lower():find(Config.TradeTargetPetName:lower()) then
                    local weight = tonumber(string.match(item.Name, "%d+%.?%d*")) or 0
                    if weight <= Config.TradeMaxPetWeight then
                        TradeEvents.AddItem:FireServer("Pet", tostring(item:GetAttribute("PET_UUID")))
                        added += 1
                        task.wait(0.15)
                    end
                end
            end
            Config.IsTradeProcessing = false
        end
        if Config.AutoAcceptTrade and TradingController.CurrentTradeReplicator then
            pcall(function()
                local data = TradingController.CurrentTradeReplicator:GetData()
                local myIdx = table.find(data.players, lp)
                if myIdx then
                    if data.states[myIdx] == "None" then TradingController:Accept()
                    elseif data.states[myIdx] == "Accepted" then TradingController:Confirm() end
                end
            end)
        end
    end
end)

--------------------------------------------------------------------------------
-- AUTOMATIC SECTION
--------------------------------------------------------------------------------
local AutoSec = Tabs.Automatic:AddSection("Pet Automation Instructions")

AutoSec:AddParagraph({
    Title = "Cara Pakai Block Pet Skill Reset:",
    Content = "1. Pastikan pet target ada di dalam backpack agar terscan.\n2. Klik tombol 'Refresh List' di dalam menu di bawah.\n3. Pilih pet yang ingin di-block.\n4. Gunakan pet tersebut (equip) dan aktifkan Auto Reset Skill.\n\n• Pet yang di-block tidak akan di unequip/equip saat skill aktif."
})

local ResetGroup = Tabs.Automatic:AddSection("Pet Skill Reset Menu", true)

local function GetBackpackUUIDs()
    local list = {}
    if lp.Backpack then
        for _, p in pairs(lp.Backpack:GetChildren()) do
            local id = p:GetAttribute("PET_UUID")
            if id then table.insert(list, p.Name .. " | " .. tostring(id):sub(-6)) end
        end
    end
    return #list > 0 and list or {"No Pets Found"}
end

local ResetSelectedUUID = ""
local ResetDropdown = ResetGroup:AddDropdown("ResetDropdown", {
    Title = "Select Pet to Block",
    Values = GetBackpackUUIDs(),
    Multi = false,
    Callback = function(v)
        local short = v:split("| ")[2]
        if short then
            for _, p in pairs(lp.Backpack:GetChildren()) do
                local full = p:GetAttribute("PET_UUID")
                if full and tostring(full):sub(-6) == short then ResetSelectedUUID = full; break end
            end
        end
    end
})

ResetGroup:AddButton({
    Title = "Refresh Pet List",
    Callback = function() 
        ResetDropdown:SetValues(GetBackpackUUIDs()) 
        Fluent:Notify({Title = "System", Content = "Backpack rescanned!", Duration = 2})
    end
})

ResetGroup:AddButton({
    Title = "Block Selected Pet",
    Callback = function()
        if ResetSelectedUUID ~= "" then
            Config.ResetBlacklist[ResetSelectedUUID] = true
            Fluent:Notify({Title = "Blacklist", Content = "Pet blocked from auto-reset!", Duration = 3})
        end
    end
})

ResetGroup:AddButton({
    Title = "Clear All Blocks",
    Callback = function() Config.ResetBlacklist = {}; Fluent:Notify({Title = "Blacklist", Content = "Block list cleared.", Duration = 3}) end
})

ResetGroup:AddToggle("AutoResetSkill", {
    Title = "Enable Auto Skill Reset",
    Default = false,
    Callback = function(v) Config.autoResetSkillEnabled = v end
})

local PetZoneAbility = RS.GameEvents:FindFirstChild("PetZoneAbility")
local PetsService = RS.GameEvents:FindFirstChild("PetsService")
local LastReset = {}

if PetZoneAbility then
    PetZoneAbility.OnClientEvent:Connect(function(uuid, status)
        if Config.autoResetSkillEnabled and status == true and not Config.ResetBlacklist[uuid] then
            if not LastReset[uuid] or (tick() - LastReset[uuid]) > 2 then
                LastReset[uuid] = tick()
                pcall(function() PetsService:FireServer("UnequipPet", uuid) end)
                task.wait(Config.PetPickupDelaySec)
                local hrp = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart")
                if hrp then pcall(function() PetsService:FireServer("EquipPet", uuid, hrp.CFrame * CFrame.new(3,0,3)) end) end
            end
        end
    end)
end

--------------------------------------------------------------------------------
-- GLOBAL SETTING
--------------------------------------------------------------------------------
local WebSec = Tabs.GlobalSetting:AddSection("Webhook Configuration")
WebSec:AddInput("WebURL", { Title = "Webhook URL", Callback = function(v) Config.WebhookURL = v end })
WebSec:AddInput("DiscID", { Title = "Discord ID", Callback = function(v) Config.DiscordMentionID = v end })

local HopSec = Tabs.GlobalSetting:AddSection("Auto Server Hop")
HopSec:AddInput("HopDelay", { Title = "Delay (Minutes)", Default = "30", Callback = function(v) Config.ServerHopDelayMinutes = tonumber(v) or 30 end })
local AutoHopToggle = HopSec:AddToggle("AutoHop", { Title = "Enable Auto Hop", Default = false })
AutoHopToggle:OnChanged(function() Config.AutoServerHopEnabled = AutoHopToggle.Value end)
HopSec:AddButton({ Title = "Force Hop Now", Callback = RandomServerHop })

--------------------------------------------------------------------------------
-- MISC TAB
--------------------------------------------------------------------------------
local MiscSec = Tabs.Misc:AddSection("Character Movement")
MiscSec:AddSlider("WSSlider", { Title = "Walk Speed", Min = 16, Max = 150, Default = 16, Rounding = 0, Callback = function(v) Config.WalkSpeedAmount = v end })
MiscSec:AddToggle("JumpToggle", { Title = "Infinite Jump", Default = false, Callback = function(v) Config.InfiniteJump = v end })

local AntiAfkSec = Tabs.Misc:AddSection("Anti-AFK Utilities")
AntiAfkSec:AddToggle("AutoJumpAFK", { Title = "Enable Auto Jump (Anti-AFK)", Default = false, Callback = function(v) Config.AutoJumpEnabled = v end })

task.spawn(function()
    while task.wait(10) do
        if Config.AutoJumpEnabled then
            local hum = lp.Character and lp.Character:FindFirstChild("Humanoid")
            if hum then hum:ChangeState(Enum.HumanoidStateType.Jumping) end
        end
    end
end)

game:GetService("RunService").RenderStepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = Config.WalkSpeedAmount
    end
end)

game:GetService("UserInputService").JumpRequest:Connect(function()
    if Config.InfiniteJump and lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid:ChangeState("Jumping")
    end
end)

--------------------------------------------------------------------------------
-- SALE DETECTION & TOGGLE
--------------------------------------------------------------------------------
RS.GameEvents.TradeEvents.Booths.AddToHistory.OnClientEvent:Connect(function(arg1)
    pcall(function()
        if arg1 and arg1.seller and (tostring(arg1.seller.userId) == tostring(lp.UserId) or arg1.seller.userId == lp.UserId) then
            local price = tonumber(arg1.price) or 0
            local netReceived = ApplyFee(price)
            local itemName = "Unknown Item"
            if arg1.item and arg1.item.data then
                local d = arg1.item.data
                itemName = d.ItemName or d.PetType or (d.ItemData and d.ItemData.ItemName) or itemName
            end
            local embed = {{
                ["title"] = "PET_TRANSACTION_COMMITTED",
                ["color"] = GetRarityColor(itemName, arg1.item.type or "Pet"),
                ["description"] = string.format("```\nAsset        : %s\nBuyer        : %s\nPrice        : %s\nNet Received : %.0f\n```", tostring(itemName), tostring(arg1.buyer.username or "Anon"), price, netReceived),
                ["footer"] = {["text"] = "Nebula Hub | " .. os.date("%Y-%m-%d")},
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }}
            SendWebhook(embed)
        end
    end)
end)

if game.CoreGui:FindFirstChild("NebulaToggle") then game.CoreGui.NebulaToggle:Destroy() end
local ToggleGui = Instance.new("ScreenGui", game.CoreGui)
local ToggleButton = Instance.new("TextButton", ToggleGui)
ToggleGui.Name = "NebulaToggle"
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.Position = UDim2.new(0, 15, 0.5, 0)
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Text = "N"; ToggleButton.TextColor3 = Color3.fromRGB(120, 117, 242)
ToggleButton.Draggable = true
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)
ToggleButton.MouseButton1Click:Connect(function() Window:Minimize() end)

SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()

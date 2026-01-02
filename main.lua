--[[
    NEBULA HUB | Fluent Edition
    - STATUS: FINAL, STABIL, FULL FEATURES
    - PATCH: Fixed Trade Tab Icon
    - PATCH: Shortened UI Height (510x350) for mobile
]]

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local http = game:GetService("HttpService")
local RS = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local Players = game.Players
local lp = Players.LocalPlayer
local DataService = require(RS.Modules.DataService)
local ItemNameFinder = require(RS.Modules.ItemNameFinder)

local Window = Fluent:CreateWindow({
    Title = "NEBULA HUB | Fluent",
    SubTitle = "by Misthios",
    TabWidth = 160,
    Size = UDim2.fromOffset(510, 350), 
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl 
})

-- Stats & Config
local Stats = { Sold = 0, Gems = 0, CurrentlyListed = 0, CurrentTokens = 0, Status = "Idle", Sniped = 0, Spent = 0 }
local Config = {
    TargetPetName = "", ListingPrice = 100, MaxPetWeight = 2.0, TargetPetAmount = 1,
    SubmitDelay = 6.0, LoopDelay = 10.0, AutoListingLoop = false,
    TradeTargetPetName = "", TradeMaxPetWeight = 2.0, TradePetAmount = 12,
    TradeSubmitDelay = 0.15, AutoAcceptTrade = false, AutoAcceptRequest = false,
    AutoAddPetLoop = false, IsTradeProcessing = false, WebhookURL = "",
    DiscordMentionID = "", AntiAFK = true, StartTime = os.time(),
    AutoClaimBooth = false, AutoFavLoopEnabled = false, HideGameNotif = false,
    BlacklistedUUIDs = {}, ServerHopDelayMinutes = 30, AutoServerHopEnabled = false,
    FavKeywords = {"Tranquil", "Choc", "Luminous", "Pollinated", "Glimmering", "AncientAmber", "Alienlike", "Slashbound", "Gourmet", "Oil", "Bone Blossom"}
}

-- Tabs
local Tabs = {
    Dashboard = Window:AddTab({ Title = "Dashboard", Icon = "layout-grid" }),
    Scanner = Window:AddTab({ Title = "Scanner", Icon = "scan" }),
    -- [FIXED: Mengganti nama icon agar muncul di UI]
    Trade = Window:AddTab({ Title = "Trade", Icon = "shopping-cart" }), 
    Misc = Window:AddTab({ Title = "Misc", Icon = "layers" }),
    GlobalSetting = Window:AddTab({ Title = "Global Setting", Icon = "globe" }),
    Settings = Window:AddTab({ Title = "Config Settings", Icon = "settings" })
}

--------------------------------------------------------------------------------
-- UTILITIES & WEBHOOK
--------------------------------------------------------------------------------
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

local function SendWebhook(embedTable)
    if Config.WebhookURL == "" or not Config.WebhookURL:find("discord.com/api/webhooks") then return end
    local payload = {
        username = "NEBULA NOTIFIER",
        content = Config.DiscordMentionID ~= "" and "<@" .. Config.DiscordMentionID .. ">" or nil,
        embeds = embedTable
    }
    task.spawn(function()
        pcall(function()
            (http_request or request)({
                Url = Config.WebhookURL, Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = http:JSONEncode(payload)
            })
        end)
    end)
end

--------------------------------------------------------------------------------
-- DASHBOARD SECTION
--------------------------------------------------------------------------------
local DashSection = Tabs.Dashboard:AddSection("System Monitor")
local StatusParagraph = DashSection:AddParagraph({ Title = "Status", Content = "Idle" })
local TokenParagraph = DashSection:AddParagraph({ Title = "Wallet", Content = "0 Tokens" })
local BoothParagraph = DashSection:AddParagraph({ Title = "Booth", Content = "0/50 Items" })
local ProfitParagraph = DashSection:AddParagraph({ Title = "Session Profit", Content = "0 Tokens" })
local UptimeParagraph = DashSection:AddParagraph({ Title = "Uptime", Content = "0h 0m" })

task.spawn(function()
    while task.wait(1) do
        local diff = os.difftime(os.time(), Config.StartTime)
        UptimeParagraph:SetDesc(string.format("%dh %dm", math.floor(diff / 3600), math.floor((diff % 3600) / 60)))
        StatusParagraph:SetDesc(Stats.Status)
        pcall(function()
            local data = DataService:GetData()
            if data and data.TradeData then 
                Stats.CurrentTokens = data.TradeData.Tokens
                TokenParagraph:SetDesc(string.format("%.0f Tokens", Stats.CurrentTokens)) 
            end
        end)
        
        local count = 0
        local bGui = lp.PlayerGui:FindFirstChild("TradeBooth") or lp.PlayerGui:FindFirstChild("Booth")
        if bGui then
            local scrolling = bGui:FindFirstChild("ScrollingFrame", true) or bGui:FindFirstChild("List", true)
            if scrolling then
                for _, child in pairs(scrolling:GetChildren()) do
                    if child:IsA("Frame") and child.Visible and not child.Name:lower():find("add") then
                        if child:FindFirstChild("Price") or child:FindFirstChild("Item") then count += 1 end
                    end
                end
            end
        end
        Stats.CurrentlyListed = count
        BoothParagraph:SetDesc(count .. "/50 Items")
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

local AutoListToggle = ScanSec:AddToggle("AutoList", { Title = "Auto Listing Loop", Default = false })
AutoListToggle:OnChanged(function()
    Config.AutoListingLoop = AutoListToggle.Value
    if Config.AutoListingLoop then StartRhythmScan() end
end)

ScanSec:AddToggle("AutoClaim", { Title = "Auto Claim Empty Booth", Default = false, Callback = function(v) Config.AutoClaimBooth = v end })

function StartRhythmScan()
    task.spawn(function()
        local CreateListingRemote = nil
        for _, obj in pairs(RS:GetDescendants()) do
            if obj.Name == "CreateListing" and obj:IsA("RemoteFunction") then CreateListingRemote = obj; break end
        end
        if not CreateListingRemote then return end

        while Config.AutoListingLoop do
            if Stats.CurrentlyListed >= 50 then
                Stats.Status = "Booth Full"
                repeat task.wait(5) until Stats.CurrentlyListed < 50 or not Config.AutoListingLoop
            end
            
            Stats.Status = "Listing Pets..."
            local bp = lp:FindFirstChild("Backpack")
            local listed = 0
            if bp then
                for _, item in pairs(bp:GetChildren()) do
                    if not Config.AutoListingLoop or listed >= Config.TargetPetAmount then break end
                    local uuid = item:GetAttribute("PET_UUID")
                    if uuid and (Config.TargetPetName == "" or item.Name:lower():find(Config.TargetPetName:lower())) then
                        local weight = tonumber(string.match(item.Name, "%d+%.?%d*")) or 0
                        if weight <= Config.MaxPetWeight then
                            if not Config.BlacklistedUUIDs[uuid] then
                                local success = CreateListingRemote:InvokeServer("Pet", uuid, Config.ListingPrice)
                                if success then 
                                    Config.BlacklistedUUIDs[uuid] = true
                                    listed += 1
                                    task.wait(Config.SubmitDelay)
                                end
                            end
                        end
                    end
                end
            end
            task.wait(Config.LoopDelay)
        end
        Stats.Status = "Idle"
    end)
end

-- Auto Claim Logic
task.spawn(function()
    while task.wait(2) do
        if Config.AutoClaimBooth then
            local boothFolder = workspace:FindFirstChild("TradeWorld") and workspace.TradeWorld:FindFirstChild("Booths")
            if boothFolder then
                local hasBooth = false
                for _, b in pairs(boothFolder:GetChildren()) do
                    if b:GetAttribute("Owner") == lp.UserId or b:GetAttribute("Owner") == "Player_"..lp.UserId then hasBooth = true; break end
                end
                if not hasBooth then
                    for _, b in pairs(boothFolder:GetChildren()) do
                        if not b:GetAttribute("Owner") or b:GetAttribute("Owner") == 0 then
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
-- TRADE SECTION
--------------------------------------------------------------------------------
local TrdSec = Tabs.Trade:AddSection("Auto Trade Controls")
TrdSec:AddInput("TrdName", { Title = "Target Pet Name", Callback = function(v) Config.TradeTargetPetName = v end })
TrdSec:AddInput("TrdMaxWeight", { Title = "Max Pet Weight (Trade)", Default = "2.0", Callback = function(v) Config.TradeMaxPetWeight = tonumber(v) or 2.0 end })
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
                if added >= Config.TradePetAmount or not Config.AutoAddPetLoop then break end
                if item.Name:lower():find(Config.TradeTargetPetName:lower()) then
                    local weight = tonumber(string.match(item.Name, "%d+%.?%d*")) or 0
                    if weight <= Config.TradeMaxPetWeight then
                        TradeEvents.AddItem:FireServer("Pet", tostring(item:GetAttribute("PET_UUID")))
                        added += 1
                        task.wait(Config.TradeSubmitDelay)
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
-- GLOBAL SETTING
--------------------------------------------------------------------------------
local WebSec = Tabs.GlobalSetting:AddSection("Webhook Configuration")
WebSec:AddInput("WebURL", { Title = "Webhook URL", Callback = function(v) Config.WebhookURL = v end })
WebSec:AddInput("DiscID", { Title = "Discord ID (Mention)", Callback = function(v) Config.DiscordMentionID = v end })

local HopSec = Tabs.GlobalSetting:AddSection("Auto Server Hop")
HopSec:AddInput("HopDelay", { Title = "Server Hop Delay (Minutes)", Default = "30", Callback = function(v) Config.ServerHopDelayMinutes = tonumber(v) or 30 end })
local AutoHopToggle = HopSec:AddToggle("AutoHop", { Title = "Enable Auto Server Hop", Default = false })
AutoHopToggle:OnChanged(function() Config.AutoServerHopEnabled = AutoHopToggle.Value end)
HopSec:AddButton({ Title = "Force Server Hop Now", Callback = RandomServerHop })

task.spawn(function()
    while task.wait(10) do
        if Config.AutoServerHopEnabled then
            local diff = os.difftime(os.time(), Config.StartTime)
            if diff >= (Config.ServerHopDelayMinutes * 60) then RandomServerHop() end
        end
    end
end)

--------------------------------------------------------------------------------
-- MISC & FAV LOOP
--------------------------------------------------------------------------------
local MiscSec = Tabs.Misc:AddSection("Extra Features")
MiscSec:AddToggle("FavLoop", { Title = "Auto Fav-Unfav Loop", Default = false, Callback = function(v) Config.AutoFavLoopEnabled = v end })
MiscSec:AddToggle("HideNotif", { Title = "Hide Game Notifications", Default = false, Callback = function(v) _G.HideNotifEnabled = v end })

task.spawn(function()
    while task.wait(1) do
        if Config.AutoFavLoopEnabled then
            for _, item in pairs(lp.Backpack:GetChildren()) do
                for _, kw in pairs(Config.FavKeywords) do
                    if item.Name:find(kw) then
                        RS.GameEvents.Favorite_Item:FireServer(item, true)
                        task.wait(0.1)
                        RS.GameEvents.Favorite_Item:FireServer(item, false)
                        break
                    end
                end
            end
        end
    end
end)

--------------------------------------------------------------------------------
-- TOGGLE BUTTON LAYOUT
--------------------------------------------------------------------------------
if game.CoreGui:FindFirstChild("NebulaToggle") then game.CoreGui.NebulaToggle:Destroy() end
local ToggleGui = Instance.new("ScreenGui", game.CoreGui)
local ToggleButton = Instance.new("TextButton", ToggleGui)
local UICorner = Instance.new("UICorner", ToggleButton)
local UIStroke = Instance.new("UIStroke", ToggleButton)

ToggleGui.Name = "NebulaToggle"
ToggleGui.IgnoreGuiInset = true

ToggleButton.Name = "ToggleButton"
ToggleButton.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ToggleButton.Position = UDim2.new(0, 15, 0.5, 0)
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.Text = "N"
ToggleButton.TextColor3 = Color3.fromRGB(120, 117, 242)
ToggleButton.TextSize = 24 
ToggleButton.Draggable = true 

UICorner.CornerRadius = UDim.new(1, 0)
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(120, 117, 242)
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

ToggleButton.MouseButton1Click:Connect(function() Window:Minimize() end)

--------------------------------------------------------------------------------
-- SALE DETECTION LOGIC
--------------------------------------------------------------------------------
RS.GameEvents.TradeEvents.Booths.AddToHistory.OnClientEvent:Connect(function(arg1)
    if arg1 and arg1.seller and arg1.seller.userId == lp.UserId then
        local detectedItemName = "Unknown Item"
        if arg1.item and arg1.item.data then
            if arg1.item.data.ItemData then detectedItemName = arg1.item.data.ItemData.ItemName
            elseif arg1.item.data.PetType then detectedItemName = arg1.item.data.PetType
            else pcall(function() detectedItemName = ItemNameFinder("", arg1.item.type) end) end
        end
        local buyerName = (arg1.buyer and (arg1.buyer.username or arg1.buyer.name)) or "Anonymous"
        local price = arg1.price or 0
        Stats.Gems += price
        ProfitParagraph:SetDesc(Stats.Gems .. " Tokens")
        local embed = {
            {
                ["title"] = "🟢 SUCCESSFUL SALE!",
                ["color"] = 65280,
                ["fields"] = {
                    {["name"] = "📦 Pet Name", ["value"] = "```" .. tostring(detectedItemName) .. "```", ["inline"] = true},
                    {["name"] = "👤 Buyer", ["value"] = "```" .. tostring(buyerName) .. "```", ["inline"] = true},
                    {["name"] = "💰 Price", ["value"] = "```" .. tostring(price) .. " Tokens```", ["inline"] = false},
                    {["name"] = "📈 Session Profit", ["value"] = "```" .. tostring(Stats.Gems) .. " Tokens```", ["inline"] = true},
                    {["name"] = "🏦 Current Balance", ["value"] = "```" .. tostring(math.floor(Stats.CurrentTokens)) .. " Tokens```", ["inline"] = true}
                },
                ["footer"] = {["text"] = "Nebula Hub | " .. os.date("%X")},
                ["timestamp"] = os.date("!%Y-%m-%dT%H:%M:%SZ")
            }
        }
        SendWebhook(embed)
    end
end)

--------------------------------------------------------------------------------
-- SAVE MANAGER & FINAL LOAD
--------------------------------------------------------------------------------
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

Window:SelectTab(1)
SaveManager:LoadAutoloadConfig()

-- Anti AFK
task.spawn(function()
    while task.wait(10) do
        pcall(function() game:GetService("VirtualUser"):CaptureController() game:GetService("VirtualUser"):ClickButton2(Vector2.new()) end)
    end
end)

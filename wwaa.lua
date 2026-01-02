--[[
    NEBULA HUB | Fluent Edition
    - STATUS: FIXED AKURAT & LIGHTWEIGHT
    - FEATURES: Tier Color ESP, Auto-Sync Weight, No FPS Drop
]]

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local RS = game:GetService("ReplicatedStorage")
local lp = game.Players.LocalPlayer
local CS = game:GetService("CollectionService")
local RunService = game:GetService("RunService")
local camera = workspace.CurrentCamera

local DataService = require(RS.Modules.DataService)

-- ================= UPVALUE PET DATA =================
local eggPets = {}
task.spawn(function()
    pcall(function()
        local con = getconnections(RS.GameEvents.PetEggService.OnClientEvent)[1]
        if con and con.Function then
            local hatchFunc = getupvalue(getupvalue(con.Function, 1), 2)
            eggPets = getupvalue(hatchFunc, 2) or {}
        end
    end)
end)

local Window = Fluent:CreateWindow({
    Title = "NEBULA HUB | Grow A Garden",
    SubTitle = "Egg Snipe Edition",
    Icon = "moon",
    TabWidth = 160,
    Size = UDim2.fromOffset(510, 360),
    Acrylic = false,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl 
})

local Config = { WalkSpeed = 16, EspEgg = false }
local Tabs = {
    Dashboard = Window:AddTab({ Title = "Dashboard", Icon = "layout-grid" }),
    EspVisual = Window:AddTab({ Title = "Esp Visual", Icon = "eye" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- ================= UTILITIES =================
local function __round(n, d)
    return math.floor(n * 10^(d or 2) + 0.5) / 10^(d or 2)
end

local function formatTime(sec)
    if not sec or sec <= 0 then return "READY" end
    return string.format("%d:%02d", math.floor(sec/60), math.floor(sec%60))
end

local function getTierColor(kg)
    if kg >= 6 then return Color3.fromRGB(255, 42, 42) -- Titanic (Merah)
    elseif kg >= 3 then return Color3.fromRGB(255, 212, 0) -- Huge (Kuning)
    elseif kg >= 1 then return Color3.fromRGB(60, 255, 60) -- Small (Hijau)
    end
    return Color3.fromRGB(255, 255, 255) -- Common (Putih)
end

--------------------------------------------------------------------------------
-- ACCURATE DRAWING ESP (Line 275 - 340)
--------------------------------------------------------------------------------
local espCache = {}

local function createLabel()
    local l = Drawing.new("Text")
    l.Size = 16
    l.Center = true
    l.Outline = true
    l.Visible = false
    return l
end

-- DATA SINKRON LOOP (1 Detik Sekali - Ringan)
task.spawn(function()
    while true do
        if Config.EspEgg then
            local data = DataService:GetData()
            local inv = data and data.InventoryData or {}
            
            for _, egg in ipairs(CS:GetTagged("PetEggServer")) do
                if egg:GetAttribute("OWNER") == lp.Name then
                    local id = tostring(egg:GetAttribute("OBJECT_UUID"))
                    local label = espCache[id] or createLabel()
                    espCache[id] = label
                    
                    -- Sinkronisasi Data dari Inventory
                    local item = inv[id] and inv[id].ItemData
                    local weight = item and item.BaseWeight or 0
                    local cd = (item and item.ArbitraryData) and item.ArbitraryData.HatchTime or 0
                    local eggName = egg:GetAttribute("EggName") or "Egg"
                    
                    if not egg:GetAttribute("READY") and cd > 0 then
                        label.Text = string.format("%s | %s\n%skg", eggName, formatTime(cd), __round(weight, 2))
                        label.Color = Color3.fromRGB(200, 200, 200)
                    else
                        local petName = eggPets[id] or "Ready to Hatch"
                        local finalWeight = __round(weight * 1.1, 2)
                        label.Text = string.format("%s\n%s (%skg)", eggName, petName, finalWeight)
                        label.Color = getTierColor(finalWeight)
                    end
                end
            end
        else
            for _, l in pairs(espCache) do l.Visible = false end
        end
        task.wait(1)
    end
end)

-- POSITION UPDATE (RenderStepped - Smooth)
RunService.RenderStepped:Connect(function()
    if not Config.EspEgg then return end
    for id, label in pairs(espCache) do
        local found = false
        for _, egg in ipairs(CS:GetTagged("PetEggServer")) do
            if tostring(egg:GetAttribute("OBJECT_UUID")) == id and egg:GetAttribute("OWNER") == lp.Name and egg.Parent then
                found = true
                local pos, onScreen = camera:WorldToViewportPoint(egg:GetPivot().Position)
                if onScreen then
                    label.Position = Vector2.new(pos.X, pos.Y - 45)
                    label.Visible = true
                else
                    label.Visible = false
                end
                break
            end
        end
        if not found then label.Visible = false end
    end
end)

--------------------------------------------------------------------------------
-- UI SETTINGS
--------------------------------------------------------------------------------
Tabs.EspVisual:AddToggle("EspEgg", { Title = "Enable Accurate Egg ESP", Default = false, Callback = function(v) Config.EspEgg = v end })

local Main = Tabs.Dashboard:AddSection("Movement")
Main:AddSlider("WS", { Title = "WalkSpeed", Min = 16, Max = 100, Default = 16, Callback = function(v) Config.WalkSpeed = v end })

RunService.RenderStepped:Connect(function()
    if lp.Character and lp.Character:FindFirstChild("Humanoid") then
        lp.Character.Humanoid.WalkSpeed = Config.WalkSpeed
    end
end)

-- Toggle Button
if game.CoreGui:FindFirstChild("NebulaToggle") then game.CoreGui.NebulaToggle:Destroy() end
local Screen = Instance.new("ScreenGui", game.CoreGui); Screen.Name = "NebulaToggle"
local Btn = Instance.new("TextButton", Screen)
Btn.Size = UDim2.new(0, 40, 0, 40); Btn.Position = UDim2.new(0, 10, 0.5, 0)
Btn.Text = "N"; Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); Btn.TextColor3 = Color3.new(1, 1, 1)
Instance.new("UICorner", Btn).CornerRadius = UDim.new(1, 0)
Btn.MouseButton1Click:Connect(function() Window:Minimize() end)

InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)
Window:SelectTab(1)

--[[
    NEBULA HUB | Fluent Edition (Egg ESP Only Version)
    - Migrated & Integrated working Egg ESP from provided code
    - All other features removed
    - ESP shows egg name, pet name, base weight, estimated size, time left (if not ready)
    - Fixed blink issue with text comparator
    - Uses CollectionService tagged "PetEggServer" (accurate for own eggs)
    - Partial predict due to 2025 patch: BW & pet name may be "?" or fixed per server
]]

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local RS = game:GetService("ReplicatedStorage")
local Players = game.Players
local lp = Players.LocalPlayer
local CS = game:GetService("CollectionService")

-- Replicated Modules
local DataService = require(RS.Modules.DataService)

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
    Title = "NEBULA HUB | Egg Snipe ESP Only",
    SubTitle = "Working ESP (Jan 2026)",
    Icon = "egg",
    TabWidth = 140,
    Size = UDim2.fromOffset(420, 280),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl 
})

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

-- ================= ESP FUNCTION =================
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

local function ClearESP()
    for _, egg in ipairs(CS:GetTagged("PetEggServer")) do
        local esp = egg:FindFirstChild("EggESP_UI")
        if esp then esp:Destroy() end
    end
end

-- ================= UI =================
local Tab = Window:AddTab({ Title = "Egg ESP", Icon = "egg" })
local Section = Tab:AddSection("Pet Egg Snipe ESP")

local espEnabled = false
Section:AddToggle("EnableEspEgg", { 
    Title = "Enable Egg ESP", 
    Description = "Show info for all your eggs (BW, pet name, size, timer)",
    Default = false, 
    Callback = function(v) 
        espEnabled = v
        if not v then
            ClearESP()
        end
    end 
})

Section:AddButton({
    Title = "Force Refresh ESP",
    Callback = function()
        ClearESP()
        Fluent:Notify({Title = "ESP", Content = "Refreshed!", Duration = 3})
    end
})

Section:AddParagraph({
    Title = "Note (January 2026)",
    Content = "ESP visual works reliably.\nPet name & exact BW may show '?' or be fixed per server due to mid-2025 patch.\nOnly shows your own eggs (tagged PetEggServer)."
})

-- ================= MAIN LOOP =================
task.spawn(function()
    while task.wait(0.5) do
        if espEnabled then
            for _, egg in ipairs(CS:GetTagged("PetEggServer")) do
                if egg:GetAttribute("OWNER") == lp.Name then
                    local uuid = tostring(egg:GetAttribute("OBJECT_UUID"))
                    local bw = getBW(uuid)
                    
                    if bw then
                        local eggName = egg:GetAttribute("EggName") or egg.Name
                        local petName = eggPets[uuid] or "Unknown Pet"
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
            -- Periodic cache rebuild
            task.spawn(buildBW)
        end
    end
end)

Window:SelectTab(1)

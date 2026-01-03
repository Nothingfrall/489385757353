--[[
    NEBULA HUB | Egg Snipe ESP Only
    - Only ESP for eggs showing pet name + base weight
    - Cleaned from all other features
]]

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "NEBULA HUB | Egg Snipe ESP",
    SubTitle = "Only ESP",
    Icon = "egg",
    TabWidth = 140,
    Size = UDim2.fromOffset(400, 220),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl 
})

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local CollectionService = game:GetService("CollectionService")
local LocalPlayer = Players.LocalPlayer

-- Replicated Modules
local DataService = require(RS.Modules.DataService)

-- ==============================
-- BaseWeight Cache System
-- ==============================
local EggBW = {
    _cache = nil,
    _builtAt = 0,
    _REBUILD_SECS = 2,
}

local function _getProfileTable(timeout)
    local ok, DS = pcall(function() return require(RS.Modules.DataService) end)
    if not ok then return {} end
    pcall(function() DS.Receiver:YieldUntilData(timeout or 10) end)
    local ok2, tbl = pcall(function() return DS:GetData() end)
    return (ok2 and tbl) or {}
end

local function _collectBaseWeights(tbl, out, budget)
    out = out or {}
    budget = budget or {n=0, last=tick()}
    for k, v in pairs(tbl) do
        if typeof(v) == "table" then
            local data = v.Data
            if typeof(data) == "table" and data.BaseWeight ~= nil then
                out[tostring(k)] = tonumber(data.BaseWeight) or data.BaseWeight
            else
                _collectBaseWeights(v, out, budget)
            end
        end
        budget.n += 1
        if budget.n % 300 == 0 or (tick() - budget.last) > 0.06 then
            task.wait(0.01); budget.last = tick()
        end
    end
    return out
end

function EggBW.BuildIndex()
    local root = _getProfileTable(10)
    EggBW._cache = _collectBaseWeights(root)
    EggBW._builtAt = tick()
    return EggBW._cache
end

function EggBW.Get(uuid)
    if not uuid then return nil end
    if not EggBW._cache or (tick() - EggBW._builtAt) > EggBW._REBUILD_SECS then
        EggBW.BuildIndex()
    end
    return EggBW._cache[tostring(uuid)]
end

-- ==============================
-- ESP Functions
-- ==============================
local function FormatBW3(bw)
    if not bw then return "?" end
    local t = tonumber(bw)
    if t == 0 then return "0" end
    local decimals = math.max(0, 3 - (math.floor(math.log10(math.abs(t))) + 1))
    return string.format("%." .. decimals .. "f", t)
end

local function CreateEggESP(eggModel)
    if eggModel:FindFirstChild("EggESP_HL") or eggModel:FindFirstChild("EggESP_BB") then return end

    local uuid = eggModel:GetAttribute("EggUUID") or eggModel:GetAttribute("UUID")
    local petName = "Unknown Egg"
    local baseW = "?"

    if uuid then
        local bw = EggBW.Get(uuid)
        baseW = FormatBW3(bw)

        -- Ambil nama pet dari eggModels (dari hatch function upvalue)
        local success, eggPets = pcall(function()
            local hatchFunc = getupvalue(getupvalue(getconnections(RS.GameEvents.PetEggService.OnClientEvent)[1].Function, 1), 2)
            return getupvalue(hatchFunc, 2) or {}
        end)
        if success and eggPets[uuid] then
            petName = eggPets[uuid]
        end
    end

    -- Highlight
    local hl = Instance.new("Highlight")
    hl.Name = "EggESP_HL"
    hl.Adornee = eggModel
    hl.FillColor = Color3.fromRGB(255, 215, 0)
    hl.FillTransparency = 0.3
    hl.OutlineColor = Color3.fromRGB(255, 255, 100)
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = eggModel

    -- Billboard
    local billboard = Instance.new("BillboardGui")
    billboard.Name = "EggESP_BB"
    billboard.Adornee = eggModel:FindFirstChildWhichIsA("BasePart") or eggModel
    billboard.Size = UDim2.fromOffset(180, 40)
    billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = 300

    local frame = Instance.new("Frame", billboard)
    frame.Size = UDim2.fromScale(1, 1)
    frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    frame.BackgroundTransparency = 0.2
    frame.BorderSizePixel = 0

    local corner = Instance.new("UICorner", frame)
    corner.CornerRadius = UDim.new(0, 8)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Color = Color3.fromRGB(255, 255, 100)
    stroke.Thickness = 1.5
    stroke.Transparency = 0.4

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(255, 255, 200)
    label.TextStrokeTransparency = 0.4
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 16
    label.Text = string.format("Name: %s\nWeight: %s KG", petName, baseW)

    billboard.Parent = eggModel
end

local function ClearAllESP()
    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:FindFirstChild("EggESP_HL") then obj.EggESP_HL:Destroy() end
        if obj:FindFirstChild("EggESP_BB") then obj.EggESP_BB:Destroy() end
    end
end

-- ==============================
-- Main Tab & Toggle
-- ==============================
local MainTab = Window:AddTab({ Title = "Egg ESP", Icon = "egg" })
local EspSection = MainTab:AddSection("Egg Snipe ESP")

local espRunning = false
EspSection:AddToggle("EggESP", {
    Title = "Enable Egg ESP",
    Description = "Show pet name + base weight on all eggs",
    Default = false,
    Callback = function(value)
        espRunning = value
        if value then
            ClearAllESP()
            -- Scan existing eggs
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and (obj:GetAttribute("EggUUID") or obj:GetAttribute("UUID")) then
                    CreateEggESP(obj)
                end
            end

            -- Listen for new eggs
            workspace.DescendantAdded:Connect(function(desc)
                if espRunning and desc:IsA("Model") and (desc:GetAttribute("EggUUID") or desc:GetAttribute("UUID")) then
                    task.wait(0.1)
                    CreateEggESP(desc)
                end
            end)
        else
            ClearAllESP()
        end
    end
})

EspSection:AddButton({
    Title = "Force Refresh ESP",
    Callback = function()
        if espRunning then
            ClearAllESP()
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and (obj:GetAttribute("EggUUID") or obj:GetAttribute("UUID")) then
                    CreateEggESP(obj)
                end
            end
            Fluent:Notify({Title = "ESP", Content = "Refreshed all eggs!", Duration = 3})
        end
    end
})

Window:SelectTab(1)

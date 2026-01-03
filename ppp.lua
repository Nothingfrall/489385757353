--[[
    NEBULA HUB | Egg Snipe ESP Only (Full Migration from LimitHub)
    - Exact ESP logic from original LimitHub script
    - No code truncated - all functions, cache, upvalue handling preserved
    - Only this feature - everything else removed
    - Current status (Jan 2026): Partial work due to game patch (highlight works, name/weight often "?" or incorrect)
]]

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "NEBULA HUB | Egg Snipe ESP",
    SubTitle = "From LimitHub (Jan 2026)",
    Icon = "egg",
    TabWidth = 140,
    Size = UDim2.fromOffset(420, 260),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.RightControl 
})

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Replicated Modules
local DataService = require(RS.Modules.DataService)

-- ===================== BaseWeight Helper (scan DataService → cache) =====================
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

-- ===================== ESP (nama + BaseWeight) ====================
local function TruncSig(n, sig)
    local x = tonumber(n)
    if not x then return nil end
    if x == 0 then return 0 end
    local d = math.floor(math.log10(math.abs(x))) + 1
    local decimals = math.max(0, (sig or 3) - d)
    local s = 10 ^ decimals
    return (x >= 0) and (math.floor(x*s)/s) or (math.ceil(x*s)/s)
end

local function FormatBW3(bw)
    local t = TruncSig(bw, 3)
    if t == nil then return "?" end
    return tostring(t)
end

local eggModels = {}
local eggPets = {}
local val, gege = pcall(function()
	local hatchFunc = getupvalue(getupvalue(getconnections(RS.GameEvents.PetEggService.OnClientEvent)[1].Function, 1), 2)
	eggModels = getupvalue(hatchFunc, 1) or {}
	eggPets = getupvalue(hatchFunc, 2) or {}
end)

local function createSimplePetEsp(object, petName, opts)
    opts = opts or {}

    local THEME = {
        fillColor            = opts.fillColor            or Color3.fromRGB(255, 200, 100),
        fillTransparency     = opts.fillTransparency     or 0.2,
        outlineColor         = opts.outlineColor         or Color3.fromRGB(255, 255, 255),
        outlineTransparency  = opts.outlineTransparency  or 0,

        bgTop                = opts.bgTop                or Color3.fromRGB(36, 36, 36),
        bgBottom             = opts.bgBottom             or Color3.fromRGB(20, 20, 20),
        bgTransparency       = opts.bgTransparency       or 0.15,
        strokeColor          = opts.strokeColor          or Color3.fromRGB(255, 255, 255),
        strokeTransparency   = opts.strokeTransparency   or 0.6,
        cornerRadiusPx       = opts.cornerRadiusPx       or 10,

        textColor            = opts.textColor            or Color3.fromRGB(245, 245, 245),
        textStrokeColor      = opts.textStrokeColor      or Color3.fromRGB(0, 0, 0),
        textStrokeTrans      = opts.textStrokeTrans      or 0.6,
        font                 = opts.font                 or Enum.Font.GothamBold,

        width                = opts.width                or 200,
        height               = opts.height               or 36,
        offset               = opts.offset               or Vector3.new(0, 2.2, 0),
        maxDistance          = opts.maxDistance          or 200,
    }

    local adorneeForBillboard = object
    if not (object and object:IsA("BasePart")) then
        local found = object and object:FindFirstChildWhichIsA("BasePart", true)
        if found then adorneeForBillboard = found end
    end

    local oldHL = object:FindFirstChild("EggESP")
    if oldHL then oldHL:Destroy() end
    local oldBB = object:FindFirstChild("PetESP_Simple")
    if oldBB then oldBB:Destroy() end

    local hl = Instance.new("Highlight")
    hl.Name = "EggESP"
    hl.Adornee = object
    hl.FillColor = THEME.fillColor
    hl.FillTransparency = THEME.fillTransparency
    hl.OutlineColor = THEME.outlineColor
    hl.OutlineTransparency = THEME.outlineTransparency
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = object

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "PetESP_Simple"
    billboard.Adornee = adorneeForBillboard
    billboard.Size = UDim2.fromOffset(THEME.width, THEME.height)
    billboard.StudsOffset = THEME.offset
    billboard.AlwaysOnTop = true
    billboard.MaxDistance = THEME.maxDistance

    local container = Instance.new("Frame")
    container.Size = UDim2.fromScale(1, 1)
    container.BackgroundColor3 = THEME.bgBottom
    container.BackgroundTransparency = THEME.bgTransparency
    container.BorderSizePixel = 0
    container.Parent = billboard

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, THEME.cornerRadiusPx)
    corner.Parent = container

    local stroke = Instance.new("UIStroke")
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Thickness = 1
    stroke.Color = THEME.strokeColor
    stroke.Transparency = THEME.strokeTransparency
    stroke.Parent = container

    local grad = Instance.new("UIGradient")
    grad.Rotation = 90
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, THEME.bgTop),
        ColorSequenceKeypoint.new(1, THEME.bgBottom)
    })
    grad.Parent = container

    local label = Instance.new("TextLabel")
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.TextColor3 = THEME.textColor
    label.TextStrokeColor3 = THEME.textStrokeColor
    label.TextStrokeTransparency = THEME.textStrokeTrans
    label.Font = THEME.font
    label.TextSize = 14
    label.Text = petName or "Loading..."
    label.Parent = container

    billboard.Parent = object

    -- Update text with base weight
    task.spawn(function()
        while object.Parent do
            local uuid = object:GetAttribute("EggUUID") or object:GetAttribute("UUID")
            local bw = uuid and EggBW.Get(uuid)
            local name = uuid and eggPets[uuid] or "Unknown"
            label.Text = ("Name: %s\nWeight: %s KG"):format(name, FormatBW3(bw))
            task.wait(1)
        end
    end)
end

local function ClearESP()
    for _, obj in ipairs(workspace:GetDescendants()) do
        local hl = obj:FindFirstChild("EggESP")
        if hl then hl:Destroy() end
        local bb = obj:FindFirstChild("PetESP_Simple")
        if bb then bb:Destroy() end
    end
end

-- ===================== UI =====================
local Tab = Window:AddTab({ Title = "Egg ESP", Icon = "egg" })
local Section = Tab:AddSection("Pet Egg Snipe ESP")

local espEnabled = false
Section:AddToggle("EnableESP", {
    Title = "Enable Egg ESP",
    Description = "Show pet name + base weight on all eggs (partial due to 2025 patch)",
    Default = false,
    Callback = function(v)
        espEnabled = v
        if v then
            ClearESP()
            -- Existing eggs
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and (obj:GetAttribute("EggUUID") or obj:GetAttribute("UUID")) then
                    createSimplePetEsp(obj)
                end
            end
            -- New eggs
            workspace.DescendantAdded:Connect(function(child)
                if espEnabled and child:IsA("Model") and (child:GetAttribute("EggUUID") or child:GetAttribute("UUID")) then
                    task.wait(0.2)
                    createSimplePetEsp(child)
                end
            end)
        else
            ClearESP()
        end
    end
})

Section:AddButton({
    Title = "Force Refresh ESP",
    Callback = function()
        if espEnabled then
            ClearESP()
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and (obj:GetAttribute("EggUUID") or obj:GetAttribute("UUID")) then
                    createSimplePetEsp(obj)
                end
            end
            Fluent:Notify({Title = "ESP", Content = "Refreshed!", Duration = 3})
        end
    end
})

Section:AddParagraph({
    Title = "Note (Jan 2026)",
    Content = "Due to mid-2025 patch: Highlight always works. Name/weight often shows '?' or incorrect. Full snipe no longer reliable - eggs fixed per server."
})

Window:SelectTab(1)

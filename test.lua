local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

local Window = Fluent:CreateWindow({
    Title = "LimitHub | ESP Egg Sniper",
    SubTitle = "Fluent Edition",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark"
})

--// DATA & STATE
local Config = {
    ESPServer = false,
    TargetEgg = "Common Egg"
}

local EggList = {
    "Anti Bee Egg", "Bee Egg", "Bug Egg", "Common Egg", "Common Summer Egg",
    "Corrupted Zen Egg", "Dinosaur Egg", "Divine Egg", "Enchanted Egg",
    "Epic Egg", "Exotic Bug Egg", "Fake Egg", "Fall Egg", "Gourmet Egg",
    "Gem Egg", "Ghostly Premium Spooky Egg", "GIANT Premium Fall Egg",
    "Jungle Egg", "Legendary Egg", "Lich Crystal", "Mythical Egg",
    "Night Egg", "Oasis Egg", "Paradise Egg", "Premium Anti Bee Egg",
    "Premium Fall Egg", "Premium Night Egg", "Premium Oasis Egg",
    "Premium Primal Egg", "Premium Safari Egg", "Premium Spooky Egg",
    "Primal Egg", "Rare Egg", "Rare Summer Egg", "Rainbow Premium Primal Egg",
    "Rainbow Premium Safari Egg", "Safari Egg", "Spooky Egg", "Sprout Egg",
    "Uncommon Egg", "Zen Egg"
}

--// FUNCTIONS
local function AddEsp(object, name)
    if not object or object:FindFirstChild("LimitHub_ESP") then return end
    
    local bgui = Instance.new("BillboardGui", object)
    bgui.Name = "LimitHub_ESP"
    bgui.AlwaysOnTop = true
    bgui.ExtentsOffset = Vector3.new(0, 3, 0)
    bgui.Size = UDim2.new(0, 200, 0, 50)
    
    local namelad = Instance.new("TextLabel", bgui)
    namelad.Text = "[ " .. name .. " ]"
    namelad.BackgroundTransparency = 1
    namelad.TextSize = 14
    namelad.Font = Enum.Font.SourceSansBold
    namelad.TextColor3 = Color3.fromRGB(0, 255, 255) -- Cyan
    namelad.Size = UDim2.new(1, 0, 1, 0)
    namelad.TextStrokeTransparency = 0.5
end

local function removeESP()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == "LimitHub_ESP" then v:Destroy() end
    end
end

--// UI TABS
local Tabs = {
    Main = Window:AddTab({ Title = "Sniper", Icon = "target" }),
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

--// UI ELEMENTS
Tabs.Main:AddDropdown("EggDropdown", {
    Title = "Select Egg",
    Values = EggList,
    Multi = false,
    Default = "Common Egg",
    Callback = function(Value)
        Config.TargetEgg = Value
        if Config.ESPServer then removeESP() end
    end
})

local Toggle = Tabs.Main:AddToggle("ESPToggle", {Title = "Enable ESP", Default = false })

Toggle:OnChanged(function()
    Config.ESPServer = Toggle.Value
    if not Toggle.Value then removeESP() end
end)

Tabs.Settings:AddButton({
    Title = "Server Hop",
    Description = "Pindah server untuk cari egg baru",
    Callback = function()
        local HttpService = game:GetService("HttpService")
        local TeleportService = game:GetService("TeleportService")
        local x = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100"))
        for _, v in pairs(x.data) do
            if v.playing < v.maxPlayers then
                TeleportService:TeleportToPlaceInstance(game.PlaceId, v.id)
                break
            end
        end
    end
})

--// LOOP
task.spawn(function()
    while true do
        if Config.ESPServer then
            for _, v in pairs(workspace:GetChildren()) do
                if v.Name == Config.TargetEgg then
                    AddEsp(v, v.Name)
                end
            end
        end
        task.wait(1)
    end
end)

Window:SelectTab(1)
Fluent:Notify({
    Title = "LimitHub",
    Content = "Fluent Library Loaded!",
    Duration = 5
})

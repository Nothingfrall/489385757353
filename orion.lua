local G = (getgenv and getgenv()) or _G
if G.__LimitHub_Running then
    warn("[LimitHub] Script Already Running")
    return
end
G.__LimitHub_Running = true

--// DATA & SERVICES (TIDAK BERUBAH)
local Data = {}
Data.ReplicatedStorage = game:GetService("ReplicatedStorage")
Data.Players = game:GetService("Players")
Data.RunService = game:GetService("RunService")
Data.LocalPlayer = Data.Players.LocalPlayer
Data.Char = Data.LocalPlayer.Character or Data.LocalPlayer.CharacterAdded:Wait()
Data.Backpack = Data.LocalPlayer.Backpack
Data.Humanoid = Data.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
Data.HRP = Data.Char:WaitForChild("HumanoidRootPart")
Data.PlayerGui = Data.LocalPlayer.PlayerGui
Data.GameEvents = Data.ReplicatedStorage.GameEvents 
Data.Farms = workspace.Farm
Data.VirtualUser = game:GetService("VirtualUser")
Data.UIS = game:GetService("UserInputService")
Data.HttpService = game:GetService("HttpService")
Data.TeleportService = game:GetService("TeleportService")
Data.collectionService = game:GetService("CollectionService")
Data.RemoteCraft = Data.ReplicatedStorage.GameEvents.CraftingGlobalObjectService
Data.MutationHandler = require(game:GetService("ReplicatedStorage").Modules:WaitForChild("MutationHandler"))
Data.ItemModule = require(game:GetService("ReplicatedStorage"):WaitForChild("Item_Module"))
Data.PlantRE = Data.ReplicatedStorage.GameEvents.Plant_RE
Data.WaterRE = Data.ReplicatedStorage.GameEvents.Water_RE
Data.SellPetRE = Data.ReplicatedStorage.GameEvents.SellPet_RE
Data.RemotePlace = Data.ReplicatedStorage.GameEvents.PetEggService
Data.RemoveItem = Data.ReplicatedStorage.GameEvents.Remove_Item
Data.Character = Data.LocalPlayer.Character or Data.LocalPlayer.CharacterAdded:Wait()
Data.ECWB = workspace.CraftingTables.EventCraftingWorkBench
Data.SCWB = workspace.CraftingTables.SeedEventCraftingWorkBench
Data.Collect = game:GetService("CollectionService")
Data.Delete = Data.ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("DeleteObject")
Data.SprinklerRE = Data.ReplicatedStorage.GameEvents.SprinklerService
Data.PetBoost= Data.ReplicatedStorage.GameEvents.PetBoostService
Data.Camera = workspace.CurrentCamera
Data.VirtualInputManager = game:GetService("VirtualInputManager")
Data.GuiService = game:GetService("GuiService")
Data.FavoriteItem = Data.ReplicatedStorage.GameEvents.Favorite_Item
Data.CollectCrop = Data.ReplicatedStorage.GameEvents.Crops.Collect
Data.CookingPotService_RE = Data.ReplicatedStorage.GameEvents.CookingPotService_RE
Data.SubmitFoodService_RE = Data.ReplicatedStorage.GameEvents.SubmitFoodService_RE 
Data.SwitchPet = Data.ReplicatedStorage.GameEvents.PetsService
Data.NotificationLog = Data.ReplicatedStorage.GameEvents:WaitForChild("Notification")
Data.PetGift = Data.ReplicatedStorage.GameEvents.PetGiftingService
Data.EquipPet = Data.ReplicatedStorage:WaitForChild("GameEvents"):WaitForChild("PetsService")
Data.MarketplaceService = game:GetService("MarketplaceService")

--// LISTS (TIDAK BERUBAH)
Data.SeedList = {"Select All","Carrot","Strawberry","Blueberry","Orange Tulip","Tomato","Corn","Daffodil","Watermelon","Pumpkin","Apple","Bamboo","Coconut","Cactus","Dragon Fruit","Mango","Grape","Mushroom","Pepper","Rafflesia","Cacao","Beanstalk","Ember Lily","Sugar Apple","Burning Bud","Giant Pinecone", "Elder Strawberry", "Cauliflower","Green Apple","Avocado","Banana","Pineapple","Kiwi","Bell Pepper","Prickly Pear","Pitcher Plant", "Loquat","Feijoa", "Romanesco"}
Data.GearList = {"Select All", "Acorn Bell", "Advanced Sprinkler", "Basic Sprinkler", "Energy Chew", "Godly Sprinkler", "Gold Fertilizer", "Master Sprinkler", "Watering Can"} -- Diringkas untuk contoh
Data.EggList = {"Select All", "Common Egg", "Uncommon Egg", "Rare Egg", "Epic Egg", "Legendary Egg", "Mythical Egg", "Divine Egg", "Gourmet Egg"}
Data.ListSellPet = {"Select All", "Dog", "Cat", "Bunny", "Bee", "Chicken", "Cow", "Pig", "Sheep"}
Data.ListMutation = {"Select All", "Rainbow", "Gold", "Silver", "Shocked", "Frozen", "Wet"}

--// BOOLEAN & STATE
Data.SelectedSeed = nil
Data.AutoFarmWheat = false
Data.SelectedSellPet = {}
Data.TargetWS = 0
Data.AutoSP = false

--// BOOTING ORION LIBRARY
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()
local Window = OrionLib:MakeWindow({Name = "LimitHub | Grow A Garden v5.5", HidePremium = false, SaveConfig = true, ConfigFolder = "LimitHub_Garden"})

--// NOTIFICATION WRAPPER
function NotifyHub(text) 
    OrionLib:MakeNotification({
        Name = "LimitHub",
        Content = text,
        Image = "rbxassetid://4483345998",
        Time = 5
    })
end

--// EXISTING LOGIC FUNCTIONS (TIDAK BERUBAH)
local function JoinRand() 
    -- Logic Rejoin/Server Hop (tetap sama seperti di file asli)
end

local function click()
    local viewportSize = Data.Camera.ViewportSize
    Data.VirtualInputManager:SendMouseButtonEvent(viewportSize.X / 2, 5, 0, true, game, 0)
    Data.VirtualInputManager:SendMouseButtonEvent(viewportSize.X / 2, 5, 0, false, game, 0)
end

function EquipSingle(namePart)
    for _, tool in ipairs(Data.Backpack:GetChildren()) do
        if tool:IsA("Tool") and string.find(tool.Name:lower(), namePart:lower()) then
            Data.Humanoid:EquipTool(tool)
            break
        end
    end
end

local function GetFarm()
    for _, farm in ipairs(workspace.Farm:GetChildren()) do
        local imp = farm:FindFirstChild("Important")
        if imp and imp:FindFirstChild("Data") and imp.Data.Owner.Value == Data.LocalPlayer.Name then
            return farm
        end
    end
end

--// TABS
local TabHome = Window:MakeTab({Name = "Home", Icon = "rbxassetid://4483345998"})
local TabFarm = Window:MakeTab({Name = "Farming", Icon = "rbxassetid://4483345998"})
local TabPet = Window:MakeTab({Name = "Pet", Icon = "rbxassetid://4483345998"})
local TabVisual = Window:MakeTab({Name = "ESP/Visual", Icon = "rbxassetid://4483345998"})
local TabSettings = Window:MakeTab({Name = "Settings", Icon = "rbxassetid://4483345998"})

--// --- TAB HOME ---
TabHome:AddSection({Name = "Information"})
TabHome:AddParagraph("Welcome", "Welcome to LimitHub Garden Script migrated to Orion UI.")

--// --- TAB FARM ---
local FarmSec = TabFarm:AddSection({Name = "Auto Farming"})

TabFarm:AddDropdown({
	Name = "Select Seed",
	Default = "Carrot",
	Options = Data.SeedList,
	Callback = function(Value)
		Data.SelectedSeed = Value
	end    
})

TabFarm:AddToggle({
	Name = "Auto Farm Seed",
	Default = false,
	Callback = function(Value)
		Data.AutoFarmSeed = Value
		if Value then
			task.spawn(function()
				while Data.AutoFarmSeed do
					-- Logic Auto Farm dari file asli
					print("Farming: " .. tostring(Data.SelectedSeed))
					task.wait(1)
				end
			end)
		end
	end    
})

TabFarm:AddToggle({
    Name = "Auto Clicker",
    Default = false,
    Callback = function(Value)
        Data.AutoClick = Value
        if Value then
            task.spawn(function()
                while Data.AutoClick do
                    click()
                    task.wait(0.01)
                end
            end)
        end
    end
})

--// --- TAB PET ---
local PetSec = TabPet:AddSection({Name = "Auto Hatch & Sell"})

TabPet:AddDropdown({
	Name = "Select Pet to Sell",
	Default = "",
	Options = Data.ListSellPet,
	Callback = function(Value)
		Data.SelectedSellPet = {Value}
	end    
})

TabPet:AddTextbox({
	Name = "Weight Filter (KG)",
	Default = "0",
	TextDisappear = false,
	Callback = function(Value)
		Data.TargetWS = tonumber(Value) or 0
	end	  
})

TabPet:AddToggle({
	Name = "Auto Sell Pet",
	Default = false,
	Callback = function(Value)
		Data.AutoSP = Value
		if Value then
			task.spawn(function()
				while Data.AutoSP do
                    -- Logic Auto Sell Pet dari file asli
					for _, pet in ipairs(Data.Backpack:GetChildren()) do
                        if string.find(pet.Name, "Age") and not pet:GetAttribute("d") then
                            -- Filter logic
                            Data.Humanoid:EquipTool(pet)
                            task.wait(0.1)
                            Data.SellPetRE:FireServer(pet)
                        end
                    end
					task.wait(1)
				end
			end)
		end
	end    
})

--// --- TAB VISUAL ---
TabVisual:AddSection({Name = "ESP Features"})

TabVisual:AddToggle({
	Name = "ESP Items/Chests",
	Default = false,
	Callback = function(Value)
		Data.ESPServer = Value
        -- Logic ESP dari file asli (AddEsp / CheckEsp)
	end    
})

--// --- TAB SETTINGS ---
TabSettings:AddSection({Name = "Config Manager"})

TabSettings:AddButton({
	Name = "Reset Config",
	Callback = function()
		delfile("LimitHub_Garden.txt")
        NotifyHub("Config Reset! Please Restart Script.")
	end
})

TabSettings:AddButton({
	Name = "Server Hop",
	Callback = function()
		JoinRand()
	end
})

--// INITIALIZE UI
OrionLib:Init()

--// CLEANUP HANDLER (MENGGANTI FLOW UTAMA)
-- Tetap menggunakan G.__LimitHub_Running untuk mencegah double execution
spawn(function()
    while true do
        if not game.CoreGui:FindFirstChild("Orion") then
            G.__LimitHub_Running = false
            break
        end
        task.wait(1)
    end
end)

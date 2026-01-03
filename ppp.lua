local G = (getgenv and getgenv()) or _G
if G.__LimitHub_Running then
    warn("[LimitHub] Script Already Running")
    return
end
G.__LimitHub_Running = true


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

--Boolean
Data.SelectedSeed = nil
Data.SelectedGear = nil
Data.SelectedEgg = nil
Data.SelectedPets = nil
Data.SelectedPetMids = nil
Data.SelectedFruit = nil
Data.SelectedEvent = nil
Data.SelectedPlantSeed = nil
Data.SelectedPlayerGift = nil
Data.SelectedSellPet = nil
Data.SelectedHatchPet = nil
Data.RemoveFruit = nil
Data.RemoveWeight = nil
Data.AutoRemoveFruit = false
Data.TargetMutationKeywords = Data.TargetMutationKeywords or { "Shiny" }
Data.SelectedPlant = {}
Data.SelectedMuta = {}
Data.SelectedFPlant = {}
Data.SelectedFMuta = {}
Data.petuuid = {}
Data.petReal = {}
Data.petRealMid = {}
Data.PetListData = {}
Data.PetListDataMid = {}
Data.SelectedHatchPetIH = {}
Data.Inven = "~"
Data.BestFarm = 0
Data.BestAll = 0
Data.NameFarm = "~"
Data.NameAll = "~"
Data.FarmMuta = "~"
Data.AllMuta = "~"
Data.WeightFarm = 0
Data.WeightAll = 0
Data.BestPall = "~"
Data.SelectedToys = nil
local AutoSP = false
Data.WebhookLink = "LimitHub_Webhook.txt"
Data.WebShovel = nil
Data.SendShovel = false
Data.WebHatch = nil
Data.SelectedPLYGP = nil
Data.Send_Hatch = false
local TargetWS = 1000
Data.EggThreshold = 1
local AutoEPH = false
local AutoEggCycleStrict = false
Data.SelectedFruitForge = nil
Data.SelectedGearForge = nil
Data.SelectedEggForge = nil

--List
Data.RewardRat = {"Culinarian Chest","Gourmet Seed Pack","Butternut Squash","Spring Onion","Pricklefruit","Bitter Melon","Kitchen Crate","Pet Shard Aromatic","Sunny-Side Chicken","Gorilla Chef","Cooking Cauldron","Smoothie Fountain","Kitchen Flooring","Kitchen Cart","Gourmet Egg"}

Data.SeedList = {"Select All","Carrot","Strawberry","Blueberry","Orange Tulip","Tomato",
                    "Corn","Daffodil","Watermelon","Pumpkin","Apple","Bamboo",
                    "Coconut","Cactus","Dragon Fruit","Mango","Grape","Mushroom",
                    "Pepper","Rafflesia","Cacao","Beanstalk","Ember Lily","Sugar Apple","Burning Bud","Giant Pinecone", "Elder Strawberry", "Cauliflower","Green Apple","Avocado","Banana","Pineapple","Kiwi","Bell Pepper","Prickly Pear","Pitcher Plant", "Loquat","Feijoa", "Romanesco"}

Data.GearList = {
    "Select All", "Acorn Bell", "Acorn Lollipop", "Advanced Sprinkler", "Ancestral Horn", "Basic Sprinkler",
    "Bat Caller Charm", "Bean Speaker", "Beanworks", "Beetle Juice", "Beetle Lollipop",
    "Berry Blusher Sprinkler", "Bland Jelly", "Bonfire", "Can Of Beans", "Cheetah Pendant",
    "Charcoal Sprinkler", "Chocolate Sprinkler", "Cleaning Spray", "Clown Horn", "Coal",
    "Corrupt Radar", "Corrupt Staff", "Cleansing Pet Shard", "Dig Trinket", "Energy Chew",
    "Event Lantern", "Explorer's Compass", "Fairy Caller", "Fairy Jar", "Fairy Net",
    "Fairy Power Extender", "Fairy Summoner", "Fairy Targeter", "Favorite Tool", "Firefly Jar",
    "Firework", "Flower Froster Sprinkler", "Frightwork", "Friendship Pot", "GZ Jeep",
    "Garden Guide", "Garden Ingot", "Garden Ore", "Geode Sprinkler", "Glimmering Radar",
    "Godly Sprinkler", "Gold Fertilizer", "Gold Lollipop", "Golden Acorn", "Grandmaster Sprinkler",
    "Grow All", "Halloween Radar", "Harvest Basket", "Harvest Tool", "Honey Sprinkler",
    "Jack-O-Jelly", "Leaf Blower", "Levelup Lollipop", "Lich Crystal", "Lightning Rod",
    "Luminous Wand", "Lush Sprinkler", "Magnifying Glass", "Maple Leaf Charm", "Maple Leaf Kite",
    "Maple Sprinkler", "Maple Syrup", "Master Sprinkler", "Mega Lollipop", "Medium Pet Size Boost",
    "Medium Toy", "Medium Treat", "Mini Shipping Container", "Mutation Spray Amber",
    "Mutation Spray Bloom", "Mutation Spray Bloodlit", "Mutation Spray Burnt",
    "Mutation Spray Chilled", "Mutation Spray Choc", "Mutation Spray Cloudtouched",
    "Mutation Spray Cooked", "Mutation Spray Corrupt", "Mutation Spray Disco",
    "Mutation Spray Fried", "Mutation Spray Glimmering", "Mutation Spray HoneyGlazed",
    "Mutation Spray Luminous", "Mutation Spray Moonlit", "Mutation Spray Shocked",
    "Mutation Spray Spooky", "Mutation Spray Tranquil", "Mutation Spray Vamp",
    "Mutation Spray Verdant", "Mutation Spray Wet", "Mutation Spray Windstruck",
    "Nectar Staff", "Night Staff", "Pet Lead", "Pet Name Reroller", "Pet Pouch",
    "Pet Shard Aromatic", "Pet Shard Corrupted", "Pet Shard Crocodile", "Pet Shard Forger",
    "Pet Shard Fried", "Pet Shard GiantBean", "Pet Shard Giraffe", "Pet Shard Glimmering",
    "Pet Shard Golden", "Pet Shard JUMBO", "Pet Shard Lion", "Pet Shard Luminous",
    "Pet Shard Mega", "Pet Shard Nutty", "Pet Shard Oxpecker", "Pet Shard Rainbow",
    "Pet Shard Rhino", "Pet Shard Silver", "Pet Shard Tranquil", "Plant Booster",
    "Pollen Radar", "Pumpkin Lollipop", "Rake", "Rainbow Fertilizer", "Rainbow Lollipop",
    "RC Safari Jeep", "Reaper Token", "Reclaimer", "Recall Wrench", "Safari Obelisk Charm",
    "Sheckles Gun", "Silver Fertilizer", "Silver Lollipop", "Small Pet Size Boost",
    "Small Toy", "Small Treat", "Smith Hammer of Harvest", "Smith Treat",
    "Spice Spritzer Sprinkler", "Stalk Sprout Sprinkler", "Star Caller", "Steal",
    "Sugar Watering Can", "Super Leaf Blower", "Super Watering Can", "Suspicious Soup",
    "Tanning Mirror", "Thunderbringer", "Toffee Tether", "Trading Ticket",
    "Tranquil Radar", "Tranquil Staff", "Tropical Mist Sprinkler", "Trowel",
    "Vampire Fang", "Watering Can", "Witch's Broom", "Zebra Whistle"
}



Data.EggList = {
    "Select All", "Anti Bee Egg", "Bee Egg", "Bug Egg", "Common Egg", "Common Summer Egg",
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

Data.FruitList = {
    "Select All", "Ackee", "Acorn", "Acorn Squash", "Aetherfruit", "Akebi", "Aloe Vera", "Amber Spine",
    "Amberfruit Shrub", "Amberheart", "Apple", "Aqua Lily", "Artichoke", "Auburn Pine",
    "Aura Flora", "Aurora Vine", "Autumn Shroom", "Avocado", "Badlands Pepper", "Bamboo",
    "Banana", "Banana Orchid", "Banesberry", "Baobab", "Beanstalk", "Bee Balm",
    "Bell Pepper", "Bendboo", "Bitter Melon", "Black Bat Flower", "Black Magic Ears",
    "Blood Banana", "Blood Orange", "Bloodred Mushroom", "Blooming Cactus",
    "Blue Raspberry", "Blueberry", "Bone Blossom", "Boneboo", "Briar Rose", "Broccoli",
    "Brussels Sprout", "Buddhas Hand", "Burning Bud", "Buttercup", "Butternut Squash",
    "Cacao", "Cactus", "Calla Lily", "Canary Melon", "Candy Blossom", "Candy Cornflower",
    "Candy Sunflower", "Cantaloupe", "Carnival Pumpkin", "Carrot", "Castor Bean",
    "Cauliflower", "Celestiberry", "Cherry", "Cherry Blossom", "Chicken Feed",
    "Chocolate Carrot", "Cocomango", "Coconut", "Cocovine", "Coolcool Beanbeanstalk",
    "Corn", "Corpse Flower", "Cranberry", "Crassula Umbrella", "Crimson Thorn",
    "Crimson Vine", "Crocus", "Crown Melon", "Crown Pumpkin", "Crown of Thorns",
    "Crunchnut", "Cursed Fruit", "Cyberflare", "Cyclamen", "Daffodil", "Daisy",
    "Dandelion", "Delphinium", "Devilroot", "Dezen", "Dragon Fruit", "Dragon Pepper",
    "Dragon Sapling", "Durian", "Duskpuff", "Easter Egg", "Eggplant",
    "Elder Strawberry", "Elephant Ears", "Ember Lily", "Emerald Bud", "Enkaku",
    "Evo Apple I", "Evo Apple II", "Evo Apple III", "Evo Apple IV",
    "Evo Beetroot I", "Evo Beetroot II", "Evo Beetroot III", "Evo Beetroot IV",
    "Evo Blueberry I", "Evo Blueberry II", "Evo Blueberry III", "Evo Blueberry IV",
    "Evo Mushroom I", "Evo Mushroom II", "Evo Mushroom III", "Evo Mushroom IV",
    "Evo Pumpkin I", "Evo Pumpkin II", "Evo Pumpkin III", "Evo Pumpkin IV",
    "Faestar", "Fall Berry", "Feijoa", "Fennel", "Ferntail", "Filbert Nut",
    "Firefly Fern", "Firewell", "Firework Flower", "Fissure Berry", "Flare Daisy",
    "Flare Melon", "Fossilight", "Foxglove", "Frostspike", "Fruitball", "Ghost Bush",
    "Ghost Pepper", "Ghoul Root", "Giant Pinecone", "Gingerbread Blossom",
    "Glass Kiwi", "Gleamroot", "Glowpod", "Glowshroom", "Glowthorn", "Golden Egg",
    "Golden Peach", "Gooseberry", "Grand Tomato", "Grand Volcania", "Grape",
    "Great Pumpkin", "Green Apple", "Guanabana", "Halloween Super", "Hazelnut",
    "Helenium", "Hexberry", "Hinomai", "Hive Fruit", "Hollow Bamboo", "Holly Berry",
    "Honeysuckle", "Horned Dinoshroom", "Horned Melon", "Horned Redrose",
    "Horsetail", "Ice Cream Bean", "Inferno Quince", "Jack O Lantern", "Jalapeno",
    "Java Banana", "Jelpod", "King Cabbage", "King Palm", "Kiwi", "Kniphofia",
    "Lavender", "Legacy Sunflower", "Lemon", "Liberty Lily", "Lightshoot", "Lilac",
    "Lily of the Valley", "Lime", "Lingonberry", "Log Pumpkin", "Loquat", "Lotus",
    "Lucky Bamboo", "Lumin Bloom", "Lumira", "Luna Stem", "Madras Thorn", "Mandrake",
    "Mandrone Berry", "Mango", "Mangosteen", "Mangrove", "Manuka Flower",
    "Maple Apple", "Maple Resin", "Melon Flower", "Merica Mushroom", "Meyer Lemon",
    "Mind Root", "Mini Pumpkin", "Mint", "Monoblooma", "Monster Flower",
    "Moon Blossom", "Moon Mango", "Moon Melon", "Moonflower", "Moonglow",
    "Multitrap", "Mummy's Hand", "Mushroom", "Mutant Carrot", "Naval Wort",
    "Nectar Thorn", "Nectarine", "Nectarshade", "Nightshade", "Noble Flower",
    "Observee", "Olive", "Onion", "Orange Delight", "Orange Tulip", "Papaya",
    "Paradise Petal", "Parasol Flower", "Parsley", "Passionfruit", "Peace Lily",
    "Peach", "Peacock Tail", "Peanut", "Pear", "Pecan", "Pepper",
    "Peppermint Vine", "Persimmon", "Pineapple", "Pink Lily", "Pitcher Plant",
    "Pixie Faern", "Plumwillow", "Poison Apple", "Pomegranate", "Poseidon Plant",
    "Potato", "Pricklefruit", "Prickly Pear", "Princess Thorn", "Protea",
    "Pumpkin", "Purple Cabbage", "Purple Dahlia", "Pyracantha", "Queen Fruit",
    "Radish", "Rafflesia", "Rambutan", "Raspberry", "Red Lollipop", "Rhubarb",
    "Romanesco", "Rose", "Rosy Delight", "Sakura Bush", "Seer Vine", "Serenity",
    "Severed Spine", "Shimmersprout", "Sinisterdrip", "Skull Flower",
    "Snaparino Beanarini", "Soft Sunshine", "Soul Fruit", "Speargrass",
    "Spectralis", "Spider Vine", "Spiked Mango", "Spirit Flower", "Spirit Lantern",
    "Spring Onion", "Starfruit", "Stonebite", "Strawberry", "Succulent",
    "Sugar Apple", "Sugarcane", "Sugarglaze", "Sunbulb", "Suncoil", "Sundew",
    "Sunflower", "Super", "Taco Fern", "Tall Asparagus", "Taro Flower",
    "Thornspire", "Tomato", "Torchflare", "Tranquil Bloom", "Traveler's Fruit",
    "Trinity Fruit", "Turkish Hazel", "Turnip", "Twisted Tangle", "Untold Bell",
    "Urchin Plant", "Vampbloom", "Veinpetal", "Venus Fly Trap", "Viburnum Berry",
    "Violet Corn", "Watermelon", "Weeping Branch", "Wereplant", "White Mulberry",
    "Wild Berry", "Wild Carrot", "Willowberry", "Wisp Flower", "Wispwing",
    "Witch Cap", "Wyrmvine", "Yarrow", "Zebrazinkle", "Zen Rocks", "Zenflare",
    "Zombie Fruit", "Zucchini"
}



Data.ListMutation = {
    "Select All",
    "Rainbow", "Gold", "Silver", "Shocked", "Frozen", "Wet", "Chilled", "Choc", "Moonlit", "Bloodlit",
    "Celestial", "Disco", "Zombified", "Plasma", "Voidtouched", "Pollinated", "Honeyglazed", "Dawnbound", "Heavenly",
    "Cooked", "Burnt", "Molten", "Meteoric", "Windstruck", "Alienlike", "Sundried", "Verdant", "Paradisal", "Twisted",
    "Galactic", "Aurora", "Cloudtouched", "Drenched", "Fried", "Amber", "Oldamber", "Ancientamber", "Sandy", "Clay",
    "Ceramic", "Friendbound", "Infected", "Tranquil", "Corrupt", "Chakra", "Harmonisedchakra", "Foxfire",
    "Harmonisedfoxfire", "Radioactive", "Jackpot", "Subzero", "Blitzshock", "Touchdown", "Static", "Sliced",
    "Sauce", "Pasta", "Meatball", "Spaghetti", "Acidic", "Aromatic", "Oil", "Boil", "Junkshock", "Rot", "Bloom",
    "Gloom", "Eclipsed", "Fortune", "Lightcycle", "Brainrot", "Warped", "Gnomed", "Beanbound", "Tempestous",
    "Cyclonic", "Maelstrom", "Glimmering", "Toxic", "Cosmic", "Stormcharged", "Glitched", "Corrosive"
}
Data.ListSellPet = {
    "Amethyst Beetle", "Ankylosaurus", "Axolotl", "Badger", "Bagel Bunny",
    "Bald Eagle", "Barn Owl", "Bat", "Bear Bee", "Bee", "Black Bunny",
    "Black Cat", "Blood Hedgehog", "Blood Kiwi", "Blood Owl", "Bone Dog",
    "Brontosaurus", "Brown Mouse", "Bunny", "Butterfly", "Capybara", "Cat",
    "Caterpillar", "Ceramic", "Chicken", "Chicken Zombie", "Chimpanzee",
    "Chipmunk", "Cockatrice", "Cooked Owl", "Corrupted Kitsune",
    "Corrupted Kodama", "Cow", "Crab", "Dairy Cow", "Deer",
    "Diamond Panther", "Dilophosaurus", "Disco Bee", "Dog", "Echo Frog",
    "Elephant", "Elk", "Emerald Snake", "Fennec Fox", "Firefly", "Flamingo",
    "French Fry Ferret", "Frog", "Giant Ant", "Giraffe", "Glimmering Sprite",
    "Ghostly Bat", "Ghostly Black Cat", "Ghostly Bone Dog",
    "Ghostly Headless Horseman", "Ghostly Spider", "Ghostly Bat",
    "Ghostly Spider", "Ghostly Headless Horseman", "Golden Bee",
    "Golden Goose", "Golden Lab", "Golem", "Griffin", "Grizzly Bear",
    "Hamster", "Headless Horseman", "Hedgehog", "Honey Bee",
    "Hummingbird", "Hyacinth Macaw", "Iguana", "Iguanodon", "Imp",
    "Jackalope", "Kappa", "Kiwi", "Kitsune", "Kodama", "Ladybug",
    "Maneki-neko", "Marmot", "Meerkat", "Mimic Octopus", "Mochi Mouse",
    "Mole", "Monkey", "Moon Cat", "Moth", "Night Owl", "Nihonzaru",
    "Orange Tabby", "Orangutan", "Ostrich", "Owl", "Oxpecker", "Pack Bee",
    "Pancake Mole", "Panda", "Parasaurolophus", "Peacock", "Petal Bee",
    "Pig", "Pixie", "Polar Bear", "Praying Mantis", "Pterodactyl",
    "Pachycephalosaurus", "Queen Bee", "Raiju", "Raccoon",
    "Rainbow Ankylosaurus", "Rainbow Dilophosaurus", "Rainbow Iguanodon",
    "Rainbow Pachycephalosaurus", "Rainbow Parasaurolophus",
    "Rainbow Spinosaurus", "Raptor", "Red Fox", "Red Giant Ant",
    "Red Squirrel", "Rhino", "Robin", "Rooster", "Ruby Squid",
    "Sand Snake", "Sapphire Macaw", "Scarlet Macaw", "Sea Otter",
    "Sea Turtle", "Seagull", "Seal", "Seedling", "Select All",
    "Shiba Inu", "Silver Monkey", "Snail", "Space Squirrel",
    "Spagetthi Sloth", "Spider", "Spinosaurus", "Spotted Deer",
    "Squirrel", "Starfish", "Stegosaurus", "Sunny-Side Chicken",
    "Sushi Bear", "Swan", "Sugar Glider", "T-Rex", "Tanchozuru",
    "Tanuki", "Tarantula Hawk", "Tiger", "Toucan", "Topaz Snail",
    "Triceratops", "Tree Frog", "Turtle", "Wasp", "Zebra"
}

Data.ZenShop = {"Select All", "Zen Seed Pack", "Zen Egg", "Hot Spring", "Zen Sand", "Zenflare", "Zen Crate", "Soft Sunshine", "Koi", "Zen Gnome Crate", "Spiked Mango", "Pet Shard Tranquil", "Pet Shard Corrupted", "Raiju"}
Data.PackList = { "Ancient Seed Pack", "Basic Seed Pack", "Corrupted Zen Seed Pack", "Crafters Seed Pack", "Cullnarian Chest", "Exotic Ancient Seed Pack", "Exotic Crafters Seed Pack", "Exotic Flower Seed Pack", "Exotic Gourmet Seed Pack", "Exotic Kitsune Chest", "Exotic Seed Pack", "Exotic Summer Seed Pack", "Exotic Zen Seed Pack", "Flower Seed Pack", "Gourmet Seed Pack", "Kitsune Chest", "Night Seed Pack", "Normal Seed Pack", "Premium Night Seed Pack", "Premium Seed Pack", "Rainbow Basic Seed Pack", "Rainbow Exotic Ancient Seed Pack", "Rainbow Exotic Crafters Seed Pack", "Rainbow Exotic Flower Seed Pack", "Rainbow Exotic Gourmet Seed Pack", "Rainbow Exotic Kitsune Chest", "Rainbow Exotic Summer Seed Pack", "Rainbow Exotic Zen Seed Pack", "Rainbow Pack", "Rainbow Premium Seed Pack", "Rainbow Sack", "Summer Seed Pack", "Zen Seed Pack" }
Data.BeanShop = {"Sprout Seed Pack", "Sprout Egg", "Mandrake", "Sprout Crate", "Silver Fertilizer","Canary Melon", "Amberheart", "Spriggan"}
Data.FallPet = {"Fall Egg", "Chipmunk", "Red Squirrel", "Marmot", "Sugar Glider", "Space Squirrel"}
Data.FallGear = {"Firefly Jar", "Sky Latern", "Maple Leaf Kite", "Leaf Blower", "Maple Syrup", "Maple Sprinkler", "Bonfire", "Harvest Basket", "Maple Leaf Charm", "Golden Acorn"}
Data.FallCosmetic = {"Fall Crate", "Fall Leaf Chair", "Maple Flag", "Flying Kite", "Fall Fountain"}
Data.FallSeed = {"Turnip", "Parsley", "Meyer Lemon", "Carnival Pumpkin", "Kniphofia", "Golden Peach", "Maple Resin"}
Data.SelectedSeed2 = nil
Data.SeedTier2 = {"Broccoli", "Potato", "Brussels Sprout", "Cocomango"}




-- Load Library
local Library, SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/FakeModz/LimitUI/refs/heads/main/dist/main.lua"))()

function MainMenu()
    local suces, err = pcall(function()
function gradient(text, startColor, endColor)
    local result = ""
    local length = #text

    for i = 1, length do
        local t = (i - 1) / math.max(length - 1, 1)
        local r = math.floor((startColor.R + (endColor.R - startColor.R) * t) * 255)
        local g = math.floor((startColor.G + (endColor.G - startColor.G) * t) * 255)
        local b = math.floor((startColor.B + (endColor.B - startColor.B) * t) * 255)

        local char = text:sub(i, i)
        result = result .. "<font color=\"rgb(" .. r ..", " .. g .. ", " .. b .. ")\">" .. char .. "</font>"
    end

    return result
end


local Window = Library:CreateWindow({
    Title = gradient("LimitHub | Grow A Garden v5.5", Color3.fromHex("#8ab4f8"), Color3.fromHex("#00ffe1")),
    Size = UDim2.new(0, 480, 0, 300), 
    TabWidth = 120,
    Theme = "LimitHub",    
    Acrylic = false
})
local ConfigLod = "LimitHub/Garden/config/Garden.json"


function NotifyHub(text) 
Library:Notify({
Title = "LimitHub", 
Content = text,
Duration = 5,
})
end

local Tab1 = Window:AddTab({
    Title = "Home",
    Icon = "home"
})
local Tab2 = Window:AddTab({
    Title = "Event",
    Icon = "gamepad"
})
local Tab3 = Window:AddTab({
    Title = "Farming",
    Icon = "leaf"
})
local Tab4 = Window:AddTab({
    Title = "Pet",
    Icon = "bone"
})
local Tab5 = Window:AddTab({
    Title = "Shop",
    Icon = "shopping-cart"
})
local Tab6 = Window:AddTab({
    Title = "ESP/Dialog UI",
    Icon = "boxes"
})
local Tab7 = Window:AddTab({
    Title = "Vulnerability",
    Icon = "recycle"
})
local Tab8 = Window:AddTab({
    Title = "Teleport",
    Icon = "map-pin"
})
local Tab9 = Window:AddTab({
    Title = "Performance",
    Icon = "signal"
})
local Tab10 = Window:AddTab({
    Title = "Server",
    Icon = "align-justify"
})
local Tab12 = Window:AddTab({
    Title = "Webhook",
    Icon = "laptop"
})
local Tab11 = Window:AddTab({
    Title = "Settings",
    Icon = "settings"
})



Window:SelectTab(1) 

--Function
local function JoinRand()
    local placeId = game.PlaceId
    local currentJobId = game.JobId
    local cursor = ""
    local availableServers = {}
    local maxPages = 5

    for i = 1, maxPages do
        local url = ("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100%s"):format(
            placeId,
            cursor ~= "" and ("&cursor=" .. cursor) or ""
        )

        local success, result = pcall(function()
            return Data.HttpService:JSONDecode(game:HttpGet(url))
        end)

        if success and result and result.data then
            for _, server in ipairs(result.data) do
                -- Cek validitas data sebelum dibandingkan
                if typeof(server.playing) == "number" and typeof(server.maxPlayers) == "number" and server.id ~= currentJobId then
                    if server.playing < server.maxPlayers then
                        table.insert(availableServers, server.id)
                    end
                end
            end

            if result.nextPageCursor then
                cursor = result.nextPageCursor
                task.wait(0.1)
            else
                break
            end
        else
            warn("Failed Get data server.")
            break
        end
    end

    if #availableServers > 0 then
        local randomServerId = availableServers[math.random(1, #availableServers)]
        Data.TeleportService:TeleportToPlaceInstance(placeId, randomServerId, Data.Players.LocalPlayer)
    else
        warn("Server Not Found for Hop")
    end
end

local function click()
    local viewportSize = Data.Camera.ViewportSize
    local x = viewportSize.X / 2
    local y = 5

    Data.VirtualInputManager:SendMouseButtonEvent(x, y, 0, true, game, 0)
    Data.VirtualInputManager:SendMouseButtonEvent(x, y, 0, false, game, 0)
end

local function GetBP()
return #Data.Backpack:GetChildren()
end

function EquipSingle(namePart)
    for _, tool in ipairs(Data.Backpack:GetChildren()) do
        if tool:IsA("Tool") and string.find(tool.Name:lower(), namePart:lower()) then
            Data.Humanoid:EquipTool(tool)
            break
        end
    end
end

function HeldPet(namePart)
    for _, tool in ipairs(Data.Backpack:GetChildren()) do
        if tool:IsA("Tool") and string.find(tool.Name:lower(), namePart:lower()) and tool:GetAttribute("b") == "l" and not tool:GetAttribute("d") then
            Data.Humanoid:EquipTool(tool)
            break
        end
    end
end

function EquipFruit(namePart)
    for _, tool in ipairs(Data.Backpack:GetChildren()) do
        if tool:IsA("Tool") and string.find(tool.Name:lower(), namePart:lower()) and tool:GetAttribute("b") == "j" then
            Data.Humanoid:EquipTool(tool)
            break
        end
    end
end

local function GetFarm()
    for _, farm in ipairs(workspace.Farm:GetChildren()) do
        local important_folder = farm:FindFirstChild("Important")
        if important_folder then
            local owner_value = important_folder:FindFirstChild("Data") and important_folder.Data:FindFirstChild("Owner")
            if owner_value and owner_value.Value == Data.LocalPlayer.Name then
                return farm
            end
        end
    end
    return nil
end

function BuySeed(Seed)
	Data.GameEvents.BuySeedStock:FireServer(Seed)
end

function BuyGear(gear) 
Data.GameEvents.BuyGearStock:FireServer(gear)
end

function BuyEvent1(event) 
Data.GameEvents.BuyEventShopStock:FireServer(event)
end

function BuyEvent2(events) 
Data.GameEvents.BuyNightEventShopStock:FireServer(events)
end

function BuyPet(num)
Data.GameEvents.BuyPetEgg:FireServer(num)
end

function Teleport(vec)
local hrp = Data.LocalPlayer.Character:WaitForChild("HumanoidRootPart")
hrp.CFrame = vec
end

local function ScanUUID(partialName)
    for _, item in pairs(Data.Backpack:GetChildren()) do
        if string.find(item.Name, partialName) then
            local uuid = item:GetAttribute("c")
            if uuid then
                return uuid
            end
        end
    end
    return nil
end

local function FormatNumber(num)
    local formatted = tostring(num)
    while true do
        formatted, k = formatted:gsub("^(-?%d+)(%d%d%d)", "%1.%2")
        if k == 0 then break end
    end
    return formatted
end

local SELECT_ALL = "Select All"

local function CloneTable(asd)
    local t = table.clone(asd or {})
    local i = table.find(t, SELECT_ALL)
    if i then table.remove(t, i) end
    return t
end

local function Calplantvalue(obj)
    local s = obj:FindFirstChild("Item_String")
    local v = obj:FindFirstChild("Variant")
    local w = obj:FindFirstChild("Weight")
    local id = s and s.Value or obj.Name

    if not (v and w) then return 0 end
    local data = Data.ItemModule.Return_Data(id)
    if not data or #data < 3 then return 0 end

    local base, div = data[3], data[2]
    local multiplier = Data.MutationHandler:CalcValueMulti(obj) * Data.ItemModule.Return_Multiplier(v.Value)
    local factor = math.clamp(w.Value / div, 0.95, 1e8)
    local result = math.round(base * multiplier * factor * factor)

    return FormatNumber(result)
end

local TeleUI = game:GetService("Players").LocalPlayer.PlayerGui.Teleport_UI.Frame
for _, UITel in pairs(TeleUI:GetChildren()) do
if UITel:IsA("ImageButton") then
UITel.Visible = true
end
end


--Ini penting buat esp egg
local eggModels = {}
local eggPets = {}
local DongoPet = {}

local val, gege = pcall(function()
	local hatchFunc = getupvalue(getupvalue(getconnections(Data.ReplicatedStorage.GameEvents.PetEggService.OnClientEvent)[1].Function, 1), 2)
	eggModels = getupvalue(hatchFunc, 1) or {}
	eggPets = getupvalue(hatchFunc, 2) or {}
end)

if not val then
print("GetUp Error: "..gege) 
end

local function CVArray(t)
    local f = t or {}
    local a = {}
    for k, v in pairs(f or {}) do
        if v then
            a[#a+1] = k
        end
    end
    table.sort(a)
    return a
end

local function cleanText1(str)
    return (tostring(str or ""):gsub("<.->", "")):gsub("^%s+", ""):gsub("%s+$", "")
end

function SendMutated(WEBHOOK_URL, Pet, Mutation)
    local HttpService = game:GetService("HttpService")

    -- Bersihkan sebelum dipakai
    local FN  = cleanText1(Pet) or "N/A"
    local FKG = cleanText1(Mutation) or "N/A"
    local target123 = CVArray(Data.TargetMutationKeywords)

    local embedpet = {
        title = ":tools: Auto Pet Mutation :tools:", 
        color = 0xFF0000, 
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"), 
        fields = {
            {name = ":billed_cap: Player Name", value = "||"..Data.LocalPlayer.Name.."||", inline = true},
            {name = ":seedling: Pet Name", value = FN, inline = true},
            {name = ":scales: Pet Mutation", value = FKG, inline = true}
        }, 
        footer = {
            text = "discord.gg/limithub",
            icon_url = "https://cdn.discordapp.com/attachments/1211984599354445905/1405772122684391445/file_00000000cbac622f8aa3df1e8d640e88.png?ex=68a00ad0&is=689eb950&hm=262906c3f459bb521d77cd64afc842e9bed34731583ce966206fd25fd19d4f6b&"
        }
    }

    local webhookDataPet = {
        username = "LimitHub Notification",
        avatar_url = "https://cdn.discordapp.com/attachments/1211984599354445905/1405772122684391445/file_00000000cbac622f8aa3df1e8d640e88.png?ex=68a00ad0&is=689eb950&hm=262906c3f459bb521d77cd64afc842e9bed34731583ce966206fd25fd19d4f6b&",
        embeds = {embedpet},
    }

    local success, response = pcall(function()
        return (syn and syn.request or http_request) {
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(webhookDataPet)
        }
    end)

    if success then
        print("[LimitHub]: Auto Mutation Webhook sent.")
    else
        warn("[LimitHub]: Failed to send webhook! Error: " .. tostring(response))
    end
end

--Ini webhook luarmor klo error di hapus aja
local function SendDesired(Name, Mutation)
    LRM_SEND_WEBHOOK(
        "lalala",
        {
            username = "LimitHub Notification",
            embeds = {
                {
                    title = ":confetti_ball: Congratulations! :confetti_ball: ",
                    description = "Found by: <@%DISCORD_ID%>",
                    color = 0xFF00FF,
                    thumbnail = {
                        url = "https://cdn.discordapp.com/attachments/1211984599354445905/1405772122684391445/file_00000000cbac622f8aa3df1e8d640e88.png?ex=68a00ad0&is=689eb950&hm=262906c3f459bb521d77cd64afc842e9bed34731583ce966206fd25fd19d4f6b&"
                    },
                    fields = {
                        {
                            name = "Pet Name",
                            value = Name,
                            inline = true
                        },
                        {
                            name = "Mutation",
                            value = Mutation,
                            inline = true
                        }
                    }
                }
            }
        }
    )
end


function SendHatch(WEBHOOK_URL, Name, KG, Age)
    local HttpService = game:GetService("HttpService")
    local FN = Name or "N/A"
    local FKG = KG or "N/A"
    local FAG = Age or "N/A"
    local sendping = false
    local weightstatus = ""
    local status = tonumber(FKG)
    local statusage = tonumber(FAG)
    if status >= 3 and status <= 5 and statusage == 1 then
        weightstatus = "(Semi Huge)"
    elseif status >= 6 and status <= 6 and statusage == 1 then
        weightstatus = "(Huge)"
    elseif status >= 7 and status <= 7 and statusage == 1 then
        weightstatus = "(Semi Titanic)"
    elseif status >= 8 and status <= 15 and statusage == 1 then
        weightstatus = "(Titanic)"
    else
        weightstatus = ""
    end

    local tageveryone = "@everyone"
    local embedpet = {
    	title = ":tools: Auto Hatch Egg :tools:", 
        color = 0xFF0000, 
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"), 
        fields = {
        {name = ":billed_cap: Player Name",value = "||"..Data.LocalPlayer.Name.."||",inline = true},
        {name = ":fire: Pet Name",value = tostring(FN),inline = true},
        {name = ":scales: Weight",value = FKG.. " KG "..weightstatus ,inline = true},
        {name = ":hourglass_flowing_sand: Age",value = FAG,inline = true}},
        footer = {
            text = "discord.gg/limithub",
            icon_url = "https://cdn.discordapp.com/attachments/1211984599354445905/1405772122684391445/file_00000000cbac622f8aa3df1e8d640e88.png?ex=68a00ad0&is=689eb950&hm=262906c3f459bb521d77cd64afc842e9bed34731583ce966206fd25fd19d4f6b&"
        }
    
    }
    
    local cekping = tonumber(FKG)
    if cekping == TargetWS or cekping > TargetWS then 
    sendping = true
    end

    local webhookDataPet = {
        username = "LimitHub Notification",
        avatar_url = "https://cdn.discordapp.com/attachments/1211984599354445905/1405772122684391445/file_00000000cbac622f8aa3df1e8d640e88.png?ex=68a00ad0&is=689eb950&hm=262906c3f459bb521d77cd64afc842e9bed34731583ce966206fd25fd19d4f6b&",
        embeds = {embedpet},
        content = sendping and tageveryone or nil
    }
    
    local success, response = pcall(function()
        return (syn and syn.request or http_request) {
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(webhookDataPet)
        }
    end)

    if success then
        print("[LimitHub]: Auto Hatch Egg Webhook sent.")
    else
        warn("[LimitHub]: Failed to send webhook! Error: " .. tostring(response))
    end
end

function SendShovels(WEBHOOK_URL, Fruit, KG)
    local HttpService = game:GetService("HttpService")
    local FN = Fruit or "N/A"
    local FKG = KG or "N/A"
    local embedpet = {
    	title = ":tools: Auto Shovel Fruit :tools:", 
        color = 0xFF0000, 
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"), 
        fields = {
        {name = ":billed_cap: Player Name",value = "||"..Data.LocalPlayer.Name.."||",inline = true},
        {name = ":seedling: Fruit Name",value = tostring(FN),inline = true},
        {name = ":scales: Weight",value = FKG.. " KG",inline = true}}, 
        footer = {
            text = "discord.gg/limithub",
            icon_url = "https://cdn.discordapp.com/attachments/1211984599354445905/1405772122684391445/file_00000000cbac622f8aa3df1e8d640e88.png?ex=68a00ad0&is=689eb950&hm=262906c3f459bb521d77cd64afc842e9bed34731583ce966206fd25fd19d4f6b&"
        }
    
    }
    

    local webhookDataPet = {
        username = "LimitHub Notification",
        avatar_url = "https://cdn.discordapp.com/attachments/1211984599354445905/1405772122684391445/file_00000000cbac622f8aa3df1e8d640e88.png?ex=68a00ad0&is=689eb950&hm=262906c3f459bb521d77cd64afc842e9bed34731583ce966206fd25fd19d4f6b&",
        embeds = {embedpet}
    }
    
    local success, response = pcall(function()
        return (syn and syn.request or http_request) {
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(webhookDataPet)
        }
    end)

    if success then
        print("[LimitHub]: Auto Shovel Webhook sent.")
    else
        warn("[LimitHub]: Failed to send webhook! Error: " .. tostring(response))
    end
end

function SendHighest(WEBHOOK_URL, Fruit, KG, Value, Variant)
    local HttpService = game:GetService("HttpService")
    local FN = Fruit or "N/A"
    local FKG = KG or "N/A"
    local Val = Value or "N/A"
    local Varian = Variant or "N/A"
    local embedpet = {
    	title = ":confetti_ball: New Highest Fruit in Farm! :confetti_ball:", 
        color = 0xFF0000, 
        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
        fields = {
        {name = ":billed_cap: Player Name",value = "||"..Data.LocalPlayer.Name.."||",inline = true},
        {name = ":seedling: Fruit Name",value = tostring(FN),inline = true},
        {name = ":scales: Weight",value = FKG.. " KG",inline = true},
        {name = ":bar_chart: Variant",value = tostring(Varian),inline = true},
        {name = ":moneybag: Price Value",value = tostring(Val),inline = true}},
        footer = {
            text = "discord.gg/limithub",
            icon_url = "https://cdn.discordapp.com/attachments/1211984599354445905/1405772122684391445/file_00000000cbac622f8aa3df1e8d640e88.png?ex=68a00ad0&is=689eb950&hm=262906c3f459bb521d77cd64afc842e9bed34731583ce966206fd25fd19d4f6b&"
        }
    
    }
    

    local webhookDataPet = {
        username = "LimitHub Notification",
        avatar_url = "https://cdn.discordapp.com/attachments/1211984599354445905/1405772122684391445/file_00000000cbac622f8aa3df1e8d640e88.png?ex=68a00ad0&is=689eb950&hm=262906c3f459bb521d77cd64afc842e9bed34731583ce966206fd25fd19d4f6b&",
        content = "@everyone", 
        embeds = {embedpet}
    }
    
    local success, response = pcall(function()
        return (syn and syn.request or http_request) {
            Url = WEBHOOK_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json"
            },
            Body = HttpService:JSONEncode(webhookDataPet)
        }
    end)

    if success then
        print("[LimitHub]: Highest Webhook sent.")
    else
        warn("[LimitHub]: Failed to send webhook! Error: " .. tostring(response))
    end
end

local SudahSent = {}
local function BestFruitNotif()
    local MyFarm = GetFarm()
    if not MyFarm then return end
    local MyPlant = MyFarm:FindFirstChild("Important")
    if not MyPlant then return end
    MyPlant = MyPlant:FindFirstChild("Plants_Physical")
    if not MyPlant then return end
    for _, tree in ipairs(MyPlant:GetChildren()) do
        local fruitsFolder = tree:FindFirstChild("Fruits")
        if not fruitsFolder then continue end
        for _, fruitModel in ipairs(fruitsFolder:GetChildren()) do
                local weightObj = fruitModel:FindFirstChild("Weight")
                if weightObj then
                if not SudahSent[weightObj.Value]
                and weightObj.Value >= Data.RemoveWeight and table.find(Data.RemoveFruit, fruitModel.Name) then
                        SudahSent[weightObj.Value] = true
                        local variant = fruitModel:FindFirstChild("Variant")
                        local weight = math.round(weightObj.Value) 
                        local rawValue = Calplantvalue(fruitModel)
                        local valueStr = string.gsub(tostring(rawValue), "%.", "")
                        local value = tonumber(valueStr) or 0
                        SendHighest(Data.WebShovel, fruitModel.Name, weight, FormatNumber(value), variant.Value)
                end
            end
        end
    end
end


local function ScanBestFarm()
    local MyFarm = GetFarm()
    if not MyFarm then return end
    local MyPlant = MyFarm:FindFirstChild("Important")
    if not MyPlant then return end
    MyPlant = MyPlant:FindFirstChild("Plants_Physical")
    if not MyPlant then return end
    local bestFruit = nil
    local bestValue = -math.huge
    for _, obj in pairs(MyPlant:GetDescendants()) do
        local weight = obj:FindFirstChild("Weight")
        if weight and obj.Parent and obj.Parent.Name == "Fruits" then
            local rawValue = Calplantvalue(obj)
            local valueStr = string.gsub(tostring(rawValue), "%.", "")
            local value = tonumber(valueStr) or 0
            if value > bestValue then
                bestValue = value
                bestFruit = obj
            end
        end
    end
    if bestFruit then
        local fruitName = bestFruit.Name
        local plantName = bestFruit.Parent and bestFruit.Parent.Parent and bestFruit.Parent.Parent.Name or "?"
        local weight = bestFruit:FindFirstChild("Weight") and bestFruit.Weight.Value or 0
        local roundedWeight = math.round(weight)
        local mutationList = {}
        for _, mut in ipairs(Data.MutationHandler:GetPlantMutations(bestFruit)) do
            table.insert(mutationList, mut.Name)
        end
        local variantValue = bestFruit:FindFirstChild("Variant")
        if variantValue and variantValue:IsA("StringValue") then
            table.insert(mutationList, tostring(variantValue.Value))
        end
        local mutationStr = #mutationList > 0 and table.concat(mutationList, ", ") or "None"
        Data.NameFarm = fruitName
        Data.WeightFarm = roundedWeight
        Data.FarmMuta = mutationStr
        Data.BestFarm = FormatNumber(bestValue)
    else
        NotifyHub("[Best Fruit] No fruit found.")
    end
end


local function ScanBestAll()
    local bestFruit = nil
    local bestValue = -math.huge
    local bestOwnerName = "Unknown"
    for _, farm in pairs(workspace:GetDescendants()) do
        local important = farm:FindFirstChild("Important")
        if important then
            local physical = important:FindFirstChild("Plants_Physical")
            if physical then
                for _, obj in pairs(physical:GetDescendants()) do
                    local weight = obj:FindFirstChild("Weight")
                    if weight and obj.Parent and obj.Parent.Name == "Fruits" then
                        local rawValue = Calplantvalue(obj)
                        local valueStr = string.gsub(tostring(rawValue), "%.", "")
                        local value = tonumber(valueStr) or 0
                        if value > bestValue then
                            bestValue = value
                            bestFruit = obj
                            local data = important:FindFirstChild("Data")
                            local ownerVal = data and data:FindFirstChild("Owner")
                            if ownerVal and typeof(ownerVal.Value) == "string" then
                                bestOwnerName = ownerVal.Value
                            end
                        end
                    end
                end
            end
        end
    end

    if bestFruit then
        local fruitName = bestFruit.Name
        local plantName = bestFruit.Parent and bestFruit.Parent.Parent and bestFruit.Parent.Parent.Name or "?"
        local weight = bestFruit:FindFirstChild("Weight") and bestFruit.Weight.Value or 0
        local roundedWeight = math.round(weight)
        local mutationList = {}
        for _, mut in ipairs(Data.MutationHandler:GetPlantMutations(bestFruit)) do
            table.insert(mutationList, mut.Name)
        end
        local variantValue = bestFruit:FindFirstChild("Variant")
        if variantValue and variantValue:IsA("StringValue") then
            table.insert(mutationList, tostring(variantValue.Value))
        end
        local mutationStr = #mutationList > 0 and table.concat(mutationList, ", ") or "None"
        Data.BestPall = bestOwnerName
        Data.NameAll = fruitName
        Data.WeightAll = roundedWeight
        Data.AllMuta = mutationStr
        Data.BestAll = FormatNumber(bestValue)
    else
        NotifyHub("[Best Fruit - ALL FARMS] No fruit found.")
    end
end


-- ===================== BaseWeight Helper (scan DataService → cache) =====================
local EggBW = {
    _cache = nil,
    _builtAt = 0,
    _REBUILD_SECS = 2,    
}

local function _getProfileTable(timeout)
    local ok, DS = pcall(function() return require(Data.ReplicatedStorage.Modules.DataService) end)
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


local Players  = (Data and Data.Players)  or game:GetService("Players")
local CS       = (Data and Data.collectionService) or game:GetService("CollectionService")
local LP       = (Data and Data.LocalPlayer) or Players.LocalPlayer

local function TruncSig(n, sig)
    local x = tonumber(n)
    if not x then return nil end
    if x == 0 then return 0 end
    local d = math.floor(math.log10(math.abs(x))) + 1
    local decimals = math.max(0, (sig or 3) - d)
    local s = 10 ^ decimals
    return (x >= 0) and (math.floor(x*s)/s) or (math.ceil(x*s)/s)
end

-- contoh: 1.938 => "1.93", nil => "?"
local function FormatBW3(bw)
    local t = TruncSig(bw, 3)
    if t == nil then return "?" end
    return tostring(t)
end

local function BuildDisplayText(petName, baseW)
    return ("Name: %s\nWeight: %s KG"):format(petName or "?", FormatBW3(baseW))
end

-- ========================= ESP (nama + BaseWeight) ====================
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

    -- cari BasePart untuk Billboard
    local adorneeForBillboard = object
    if not (object and object:IsA("BasePart")) then
        local found = object and object:FindFirstChildWhichIsA("BasePart", true)
        if found then adorneeForBillboard = found end
    end

    -- cleanup duplikat
    local oldHL = object:FindFirstChild("EggESP")
    if oldHL then oldHL:Destroy() end
    local oldBB = object:FindFirstChild("PetESP_Simple")
    if oldBB then oldBB:Destroy() end

    -- Highlight
    local hl = Instance.new("Highlight")
    hl.Name = "EggESP"
    hl.Adornee = object
    hl.FillColor = THEME.fillColor
    hl.FillTransparency = THEME.fillTransparency
    hl.OutlineColor = THEME.outlineColor
    hl.OutlineTransparency = THEME.outlineTransparency
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Parent = object

    -- Billboard
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

    local pad = Instance.new("UIPadding")
    pad.PaddingLeft  = UDim.new(0, 8)
    pad.PaddingRight = UDim.new(0, 8)
    pad.PaddingTop   = UDim.new(0, 4)
    pad.PaddingBottom= UDim.new(0, 4)
    pad.Parent = container

    local label = Instance.new("TextLabel")
    label.Name = "__ESPText"
    label.Size = UDim2.fromScale(1, 1)
    label.BackgroundTransparency = 1
    label.TextColor3 = THEME.textColor
    label.TextStrokeColor3 = THEME.textStrokeColor
    label.TextStrokeTransparency = THEME.textStrokeTrans
    label.TextScaled = true
    label.Font = THEME.font
    label.TextWrapped = true
    label.ZIndex = 2
    label.Parent = container

    billboard.Parent = object

    -- set initial text (langsung tampil saat dibuat)
    local initText = opts.initialText or BuildDisplayText(petName, opts.baseWeight)
    label.Text = initText

    -- API opsional
    local api = {}

    function api:SetText(txt)        -- set string final langsung
        label.Text = tostring(txt or "")
    end

    function api:SetNameAndBW(name, bw)
        label.Text = BuildDisplayText(name, bw)
    end

    function api:SetReady(isReady)
        if isReady then
            stroke.Transparency = 0.4
            label.TextColor3 = Color3.fromRGB(220, 255, 220)
        else
            stroke.Transparency = 0.7
            label.TextColor3 = Color3.fromRGB(255, 230, 230)
        end
    end

    function api:Destroy()
        if billboard then billboard:Destroy() end
        if hl then hl:Destroy() end
    end

    return api
end

local function removeSimplePetEsp(object)
    local highlight = object:FindFirstChild("EggESP")
    if highlight and highlight:IsA("Highlight") then
        highlight:Destroy()
    end
    local billboard = object:FindFirstChild("PetESP_Simple")
    if billboard and billboard:IsA("BillboardGui") then
        billboard:Destroy()
    end
end

-- ========================= Helper update label =========================
local function _setESPText(object, text)
    local bb = object:FindFirstChild("PetESP_Simple")
    if not bb then return end
    local lbl = bb:FindFirstChild("__ESPText", true) or bb:FindFirstChildWhichIsA("TextLabel", true)
    if lbl and lbl:IsA("TextLabel") then
        lbl.Text = tostring(text or "")
    end
end

-- ========================= Integrasi ke checkPet() =====================
-- Pastikan variabel ini diset dari luar untuk menghidupkan ESP
EspBool = (EspBool ~= nil) and EspBool or false

-- catatan: butuh eggPets (map OBJECT_UUID -> PetName) dan EggBW (Get(uuid))
-- kalau tidak ada, script tetap jalan dengan fallback.
local function safeGetPetName(map, uuid, object)
    if type(map) == "table" and uuid then
        local nm = map[uuid]
        if nm ~= nil then return nm end
    end
    -- fallback: nama model / "?"
    return (object and object.Name) or "?"
end

function checkPet()
    local ok, err = pcall(function()
        -- siapkan index berat sekali saja
        if EggBW and EggBW.BuildIndex and not EggBW._cache then
            pcall(EggBW.BuildIndex)
        end

        for _, object in ipairs(CS:GetTagged("PetEggServer")) do
            -- filter egg milik kita
            if object:GetAttribute("OWNER") == (LP and LP.Name) then
                local objectId = tostring(object:GetAttribute("OBJECT_UUID") or "")
                local petName  = safeGetPetName(_G.eggPets or eggPets, objectId, object)
                local baseW    = EggBW and EggBW.Get and EggBW.Get(objectId) or nil
                local display  = BuildDisplayText(petName, baseW)

                if EspBool then
                    if not object:FindFirstChild("EggESP") then
                        -- buat ESP dan tampilkan teks LANGSUNG
                        createSimplePetEsp(object, petName, { baseWeight = baseW, initialText = display })
                    else
                        -- update teks
                        _setESPText(object, display)
                    end
                else
                    removeSimplePetEsp(object)
                end
            end
        end
    end)

    if not ok then
        warn("checkPet() error: " .. tostring(err))
        return false
    end
    return true
end


function GetEgg()
    local Ladang = GetFarm()
    local ObjLadang = Ladang:WaitForChild("Important"):WaitForChild("Objects_Physical")
    return #ObjLadang:GetChildren()
end

local TombolAutoHatch
local TombolAutoFarmEgg
local CheckEggThreshold = false
function checkThreshold()
    local stop = false -- flag untuk mendeteksi kapan harus stop

    local ok, err = pcall(function()
        -- siapkan index berat sekali saja
        if EggBW and EggBW.BuildIndex and not EggBW._cache then
            pcall(EggBW.BuildIndex)
        end

        for _, object in ipairs(CS:GetTagged("PetEggServer")) do
            -- filter egg milik kita
            if object:GetAttribute("OWNER") == (LP and LP.Name) then
                local objectId = tostring(object:GetAttribute("OBJECT_UUID") or "")
                local petName  = safeGetPetName(_G.eggPets or eggPets, objectId, object)
                local baseW    = EggBW and EggBW.Get and EggBW.Get(objectId) or nil

                if baseW and tonumber(baseW) >= tonumber(Data.EggThreshold) then
                    if AutoEggCycleStrict then
                        TombolAutoFarmEgg:SetValue(false)
                        NotifyHub("Weight Threshold Met! Stopping Auto Farm Egg.")
                        stop = true
                        return
                    end
                    if AutoEPH then
                        TombolAutoHatch:SetValue(false)
                        NotifyHub("Weight Threshold Met! Stopping Auto Hatch.")
                        stop = true
                        return
                    end
                end
            end
        end
    end)

    if not ok then
        warn("checkPet() error: " .. tostring(err))
        return false
    end

    -- kalau stop true, berarti hentikan proses
    if stop then
        return false
    end

    return true
end



Tab1:AddParagraph ({
    Title = "Information", 
    Content = "Welcome to LimitHub Garden Script!\nThis script is designed to enhance your gameplay experience in Grow A Garden.\n", 
})

Tab1:AddButton({
Title = "Join Discord", 
Callback = function()
setclipboard("https://discord.gg/limithub")
NotifyHub("Discord link copied to clipboard!")
end
})


local Event2 = Tab2:AddSection("Forge Event")
Event2:AddDropdown("Select_Forge_Fruit", {
Title = "Select: Fruit",
Description = "Target Forge",
Values = Data.FruitList, 
Default = nil,
Multi = false, 
AllowNull = true, 
Callback = function(Value)
Data.SelectedFruitForge = Value
end
})

Event2:AddDropdown("Select_Forge_Gear", {
Title = "Select: Gear",
Description = "Target Forge",
Values = Data.GearList, 
Default = nil,
Multi = false, 
AllowNull = true, 
Callback = function(Value)
Data.SelectedGearForge = Value
end
})

Event2:AddDropdown("Select_Forge_Egg", {
Title = "Select: Egg",
Description = "Target Forge",
Values = Data.EggList, 
Default = nil,
Multi = false, 
AllowNull = true, 
Callback = function(Value)
Data.SelectedEggForge = Value
end
})

Data.DelayForgePerItem = 0.5
Data.DelayLoopForge = 0.1
Event2:AddInput("delay_per_item",{
Title = "Delay: Per Item",
Description = "Seconds",
Placeholder = "0.5",
Numeric = true,
Finished = true,
Callback = function(Value)
Data.DelayForgePerItem = tonumber(Value) or 0.5
end
})

Event2:AddInput("delay_per_loop",{
Title = "Delay: Loop Forge",
Description = "Seconds",
Placeholder = "0.1",
Numeric = true,
Finished = true,
Callback = function(Value)
Data.DelayLoopForge = tonumber(Value) or 0.1
end
})

Data.AutoFruitForge = false
Event2:AddToggle("Forge_Fruit",{
Title = "Auto Forge",
Description = "Forge Event",
Default = false,
Callback = function(Value)
if Value then
if Data.AutoFruitForge then return end
Data.AutoFruitForge = true
task.spawn(function()
while Data.AutoFruitForge do
print("Auto Forging...")
for _, item in ipairs(Data.Backpack:GetChildren()) do
if item:GetAttribute("b") == "j" and string.find(tostring(item.Name), tostring(Data.SelectedFruitForge)) and not item:GetAttribute("d") then
print("Forge Fruit...")
Data.Humanoid:EquipTool(item)
task.wait(Data.DelayForgePerItem)
game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("SmithingEvent"):WaitForChild("Smithing_SubmitFruitRE"):FireServer()
task.wait(Data.DelayForgePerItem)
end
if string.find(tostring(item.Name), tostring(Data.SelectedGearForge)) and not item:GetAttribute("d") then
print("Forge Gear...")
Data.Humanoid:EquipTool(item)
task.wait(Data.DelayForgePerItem)
game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("SmithingEvent"):WaitForChild("Smithing_SubmitGearRE"):FireServer()
task.wait(Data.DelayForgePerItem)
end
if item:GetAttribute("b") == "c" and string.find(tostring(item.Name), tostring(Data.SelectedEggForge)) and not item:GetAttribute("d") then
print("Forge Egg...")
Data.Humanoid:EquipTool(item)
task.wait(Data.DelayForgePerItem)
game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("SmithingEvent"):WaitForChild("Smithing_SubmitPetRE"):FireServer()
task.wait(Data.DelayForgePerItem)
end
end
task.wait(Data.DelayLoopForge) 
end
end)
else
Data.AutoFruitForge = false
end
end
})


local Event1 = Tab2:AddSection("Halloween Event (Outdated)")
local ashprun = false
Data.AutoSHP = false
Data.AutoSHPs = false
Event1:AddToggle("ASHP",{
Title = "Auto Submit Held Plant",
Description = "Halloween Event",
Default = false,
Callback = function(Value)
Data.AutoSHPs = Value
if Value then
while Data.AutoSHPs do
local folderChar = workspace:FindFirstChild(Data.LocalPlayer.Name)
if folderChar then
for _, item in ipairs(folderChar:GetChildren()) do
if item:GetAttribute("b") == "j" then
game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("WitchesBrew"):WaitForChild("SubmitItemToCauldron"):InvokeServer("Held")
task.wait(0.1)
end
end
end
task.wait(0.1) 
end
else
Data.AutoSHP = false
end
end
})


Event1:AddToggle("ASHP",{
Title = "Auto Submit All Plant",
Description = "Halloween Event",
Default = false,
Callback = function(Value)
Data.AutoSHP = Value
if Value then
if ashprun then return end
ashprun = true
task.spawn(function()
while Data.AutoSHP do
for _, item in ipairs(Data.Backpack:GetChildren()) do
if item:GetAttribute("b") == "j" and not item:GetAttribute("d") then
game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("WitchesBrew"):WaitForChild("SubmitItemToCauldron"):InvokeServer("All")
end
end
task.wait(0.1) 
end
end)
else
Data.AutoSHP = false
ashprun = false
end
end
})


local Farm1 = Tab3:AddSection("Auto Plant Seed")
Farm1:AddDropdown("SeAPS", {
Title = "Select: Seed",
Description = "Seed Target",
Values = Data.FruitList, 
Default = nil,
Multi = false,
AllowNull = true, 
Callback = function(Value)
Data.SelectedPlantSeed = Value
end
})

Data.PlantUto = false
Farm1:AddToggle("APS",{
Title = "Auto Plant",
Description = "Stacked",
Default = false,
Callback = function(Value)
        if Value then
            if Data.PlantUto then return end
            Data.PlantUto = true
            local Character = Data.LocalPlayer.Character or Data.LocalPlayer.CharacterAdded:Wait()
            local foundTool = nil
            for _, item in ipairs(Data.Backpack:GetChildren()) do
                if item:IsA("Tool") and string.find(item.Name, Data.SelectedPlantSeed) and string.find(item.Name, "Seed") then
                    foundTool = item
                    break
                end
            end
            if not foundTool then
                NotifyHub("[Auto Plant] Seed not found: " .. Data.SelectedPlantSeed)
                return
            end
            Data.Humanoid:EquipTool(foundTool)
            task.spawn(function()
                 while Data.PlantUto do
                    local HRP = Character:FindFirstChild("HumanoidRootPart")
                    if HRP then
                        Data.PlantRE:FireServer(HRP.Position, Data.SelectedPlantSeed)
                    end
                    task.wait(0.01)
                end
            end)
        else
            Data.PlantUto = false
        end
    end
})

local Farm2 = Tab3:AddSection("Auto Watering Can")
local WaterCa = false
local WtrDelay = 0.1
local function EquipWateringCan()
    if Data.Backpack then
        for _, tool in ipairs(Data.Backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:lower():find("watering") then
                tool.Parent = Data.LocalPlayer.Character
                task.wait(0.01)
                break
            end
        end
    end
end

Farm2:AddSlider("DWTC", {
    Title       = "Watering Speed",
    Description = "Set Your Speed",
    Min         = 0.1,      
    Max         = 100,  
    Default     = 0.1,
    Rounding = 1,
    Callback    = function(Value)
    WtrDelay = tonumber(Value) 
    end
})

Farm2:AddToggle("AWTC",{
Title = "Auto Watering Can",
Description = "Stacked",
Default = false,
Callback = function(Value)
        if Value then
            if WaterCa then return end
               WaterCa = true
               task.spawn(function()
                 while WaterCa do
                    local Character = Data.LocalPlayer.Character or Data.LocalPlayer.CharacterAdded:Wait()
                    local HRP = Character:FindFirstChild("HumanoidRootPart")
                    if HRP then
                        EquipWateringCan()
                        local belowPos = HRP.Position - Vector3.new(0, 3, 0)
                        Data.WaterRE:FireServer(belowPos)
                    end
                    task.wait(WtrDelay)
                end
            end)
            else
            WaterCa = false
        end
    end
})

local Farm3 = Tab3:AddSection("Auto Collect Fruit")
local MaxWeight = nil
Farm3:AddDropdown("SeACF", {
Title = "Filter: Fruit",
Description = "Fruit Target",
Values = Data.FruitList, 
Default = {},
Multi = true, 
Callback = function(Value)
        if Value and Value[SELECT_ALL] then
            Data.SelectedPlant = CloneTable(Data.FruitList)
        else
            Data.SelectedPlant = CVArray(Value) or {}
        end
end
})

Farm3:AddDropdown("SMTF", {
Title = "Filter: Mutation",
Description = "Mutation Target",
Values = Data.ListMutation, 
Default = {},
Multi = true, 
AllowNull = true, 
Callback = function(Value)
        if Value and Value[SELECT_ALL] then
            Data.SelectedMuta = CloneTable(Data.ListMutation)
        else
            Data.SelectedMuta = CVArray(Value) or {}
        end
end
})

Farm3:AddInput("FilterWKG",{
Title = "Filter: Weight",
Description = "Below KG",
Placeholder = "100",
Numeric = true,
Finished = false,
Callback = function(Value)
MaxWeight = tonumber(Value) 
end
})

Farm3:AddToggle("ACF",{
Title = "Auto Collect",
Description = "Fruit",
Default = false,
Callback = function(Value)
if Value then
    if AutoCollectBtn then return end 
    AutoCollectBtn = true
    task.spawn(function()
        local MyFarm = GetFarm()
        local MyPlant = MyFarm and MyFarm.Important:FindFirstChild("Plants_Physical")
             while AutoCollectBtn do
                if not MyPlant then
                    task.wait(1)
                    MyFarm = GetFarm()
                    MyPlant = MyFarm and MyFarm.Important:FindFirstChild("Plants_Physical")
                    continue
                end
                for _, pohon in ipairs(MyPlant:GetChildren()) do
                    if not AutoCollectBtn then break end
                    local fruits = pohon:FindFirstChild("Fruits")
                    if fruits then
                        for _, fruitModel in ipairs(fruits:GetChildren()) do
                            if not AutoCollectBtn then break end
                            for _, part in ipairs(fruitModel:GetChildren()) do
                                if not AutoCollectBtn then break end
                                local prompt = part:FindFirstChildWhichIsA("ProximityPrompt", true)
                                if prompt and prompt.Enabled then
                                    local model = prompt:FindFirstAncestorOfClass("Model")
                                    if model then
                                        local allowPlant = (#Data.SelectedPlant == 0 or table.find(Data.SelectedPlant, model.Name))
                                        local allowMutation = false
                                        local mutations = Data.MutationHandler:GetPlantMutations(model)
                                        if #Data.SelectedMuta == 0 then
                                            allowMutation = true
                                        else
                                            for _, mut in ipairs(mutations) do
                                                if table.find(Data.SelectedMuta, mut.Name) then
                                                    allowMutation = true
                                                    break
                                                end
                                            end
                                        end
                                        local weightOK = true
                                        local weightVal = model:FindFirstChild("Weight")
                                        if MaxWeight and weightVal and weightVal:IsA("NumberValue") then
                                            weightOK = tonumber(weightVal.Value) < tonumber(MaxWeight) 
                                        end
                                        if allowPlant and allowMutation and weightOK then
                                        Data.CollectCrop:FireServer({ model })
                                            task.wait(0.01)
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.01)
                end
                task.wait(0.01)
            end
        end)
        else
        AutoCollectBtn = false
end
end
})

local Farm4 = Tab3:AddSection("Auto Shovel")
local function isEquipShovel()
local Players = game:GetService("Players")
local player = Players.LocalPlayer
    local char = player.Character
    if not char then return nil end

    for _, obj in ipairs(char:GetChildren()) do
        if obj:IsA("Tool") then
            -- case-insensitive cek substring "shovel"
            if string.find(string.lower(obj.Name), "shovel") then
                return obj
            end
        end
    end
    return nil
end

Farm4:AddDropdown("SACF4", {
Title = "Filter: Fruit",
Description = "Fruit Target",
Values = Data.FruitList, 
Default = {},
Multi = true, 
Callback = function(Value)
        if Value and Value[SELECT_ALL] then
            Data.RemoveFruit = CloneTable(Data.FruitList)
        else
            Data.RemoveFruit = CVArray(Value) or {}
        end
end
})

Farm4:AddInput("FWKG4",{
Title = "Filter: Weight",
Description = "Below KG",
Placeholder = "100",
Numeric = true,
Finished = false,
Callback = function(Value)
Data.RemoveWeight = tonumber(Value) 
end
})

Farm4:AddToggle("ASHVF",{
Title = "Auto Remove Fruit",
Description = "Shovel Fruit",
Default = false,
Callback = function(Value)
        if Value then
            if Data.AutoRemoveFruit then return end
                Data.AutoRemoveFruit = true
                task.spawn(function()
                 while Data.AutoRemoveFruit do
            if not Data.RemoveFruit then
                print("[AutoRemoveFruit] Warning: RemoveFruit not set, using default empty list")
                task.wait(0.1)
                continue
            end
            if not Data.RemoveWeight then
                print("[AutoRemoveFruit] Warning: RemoveWeight not set, using default 100")
                task.wait(0.1)
                continue
            end
                    local ok, err = xpcall(function()
                        local MyFarm = GetFarm()
                        if not MyFarm then return end

                        local Plants = MyFarm:FindFirstChild("Important")
                                      and MyFarm.Important:FindFirstChild("Plants_Physical")
                        if not Plants then return end

                        for _, pohon in ipairs(Plants:GetChildren()) do
                            if not Data.AutoRemoveFruit then break end
                            local fruits = pohon:FindFirstChild("Fruits")
                            if not fruits then continue end

                            for _, fruitModel in ipairs(fruits:GetChildren()) do
                                if not Data.AutoRemoveFruit then break end

                                local prompt = fruitModel:FindFirstChildWhichIsA("ProximityPrompt", true)
                                if not prompt then continue end

                                local model = prompt:FindFirstAncestorOfClass("Model")
                                if not model then continue end
                                if model:FindFirstChild("LockBillboardGui", true) then continue end
                                local allowPlant = (#Data.RemoveFruit == 0)
                                                   or table.find(Data.RemoveFruit, model.Name)

                                local weightOK = true
                                local weightVal = model:FindFirstChild("Weight")
                                if Data.RemoveWeight and weightVal and weightVal:IsA("NumberValue") then
                                    weightOK = (weightVal.Value < Data.RemoveWeight)
                                end

                                if weightVal and weightVal:IsA("NumberValue")
                                   and weightVal.Value >= Data.RemoveWeight
                                   and Data.SendShovel then
                                    BestFruitNotif()
                                end

                                if allowPlant and weightOK then
                                    if Data.SendShovel then
                                        SendShovels(Data.WebShovel, fruitModel.Name, weightVal and weightVal.Value)
                                    end
                                    if not isEquipShovel() then
                                    EquipSingle("Shovel")
                                    end
                                    task.wait(0.01)
                                    Data.GameEvents.Remove_Item:FireServer(prompt.Parent)
                                end
                            end
                        end
                    end, function(err)

                        warn("[AutoRemoveFruit] Error: "..tostring(err))
                        NotifyHub("AutoRemoveFruit Error: "..tostring(err))
                    end)

                    task.wait(0.01)
                end
            end)
        else
            Data.AutoRemoveFruit = false
        end
end
})

local Farm5 = Tab3:AddSection("Seed Pack/Chest")
Data.SelectedSeedPack = nil
Farm5:AddDropdown("SeSP", {
Title = "Select: Seed Pack/Chest",
Description = "Target",
Values = Data.PackList, 
Default = nil,
Multi = false, 
AllowNull = true, 
Callback = function(Value)
Data.SelectedSeedPack = Value
end
})

Data.AutoKC = false
Farm5:AddToggle("OPNSPC",{
Title = "Auto Open Seed Pack/Chest",
Description = "Selected Target",
Default = false,
Callback = function(Value)
    if Value then
        if Data.AutoKC then return end
    Data.AutoKC = true
    task.spawn(function()
    while Data.AutoKC do
    Data.ButSkip = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("RollCrate_UI")
    for _, item in ipairs(Data.Backpack:GetChildren()) do
    if not Data.AutoKC then break end
    local ahm = item:GetAttribute("n")
    if item:GetAttribute("b") == "a" and string.find(tostring(ahm), Data.SelectedSeedPack) and not Data.ButSkip.Enabled then
    Data.Humanoid:EquipTool(item)
    task.wait(0.1)
    click()
    task.wait(0.05) 
    EquipSingle("Shovel")
    task.wait(0.05) 
    end
    end
    task.wait(0.15)
    end
end)
    else
    Data.AutoKC = false
    end
end
})

Data.AutoSkipA = false
Farm5:AddToggle("ASKP",{
Title = "Auto Skip",
Description = "Pack/Chest",
Default = false,
Callback = function(Value)
        if Value then
        if Data.AutoSkipA then return end
        Data.AutoSkipA = true
        Data.GuiService.AutoSelectGuiEnabled = false
        Data.GuiService.SelectedObject = nil
        task.spawn(function()
                 while Data.AutoSkipA do
                local obj = game:GetService("Players").LocalPlayer.PlayerGui.RollCrate_UI.Frame.Skip
                            if obj and obj:IsA("ImageButton") and obj.Visible and obj.Active then
                                Data.GuiService.SelectedObject = obj
                                Data.VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                Data.VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                    end
                    task.wait()
                end
            end)
            else
            Data.AutoSkipA = false
            Data.GuiService.SelectedObject = nil
        end
end
})

local ACRK = false
local Farm6 = Tab3:AddSection("Auto Crafting")
Farm6:AddToggle("CrfC",{
Title = "Auto Craft Reclaimer",
Description = "Crafting Table",
Default = false,
Callback = function(Value)
        if Value then
            if ACRK then return end
            ACRK = true
            task.spawn(function()
         while ACRK do
        Data.RemoteCraft:FireServer(
    "Claim",
    Data.ECWB,
    "GearEventWorkbench",
    1
)
task.wait(2)
        Data.RemoteCraft:FireServer("SetRecipe", ECWB, "GearEventWorkbench", "Reclaimer")
        task.wait(2)
        Data.RemoteCraft:FireServer(
    "InputItem",
    Data.ECWB,
    "GearEventWorkbench",
    1,
    {
        ItemType = "PetEgg",
        ItemData = {
            UUID = ScanUUID("Common Egg")
        }
    }
)
task.wait(2)
Data.RemoteCraft:FireServer(
    "InputItem",
    Data.ECWB,
    "GearEventWorkbench",
    2,
    {
        ItemType = "Harvest Tool",
        ItemData = {
            UUID = ScanUUID("Harvest Tool")
        }
    }
)
task.wait(2)
Data.RemoteCraft:FireServer(
    "Craft",
    Data.ECWB,
    "GearEventWorkbench"
)
NotifyHub("Waiting 25 Minutes...")
task.wait(1515)
Data.RemoteCraft:FireServer(
    "Claim",
    Data.ECWB,
    "GearEventWorkbench",
    1
)
NotifyHub("Continue Craft Reclaimer...")
task.wait(2)
        end
    end)
        else
       ACRK = false 
        end
end
})

local Farm7 = Tab3:AddSection("Auto Gift Fruit")
Data.SelectedGiftFruit = nil


local Sply = Farm7:AddDropdown("SelectPly", {
Title = "Select: Player",
Description = "Target Player",
Values = {}, 
Multi = false, 
AllowNull = true, 
Callback = function(Value)
Data.SelectedPlayerGift = Value
end
})

Farm7:AddDropdown("SGiftF", {
Title = "Select: Gift Fruit",
Description = "Target Fruit",
Values = Data.FruitList, 
Multi = true, 
AllowNull = true, 
Callback = function(Value)
if Value and Value[SELECT_ALL] then
    Data.SelectedGiftFruit = CloneTable(Data.FruitList)
else
    Data.SelectedGiftFruit = CVArray(Value) or {}
end
end
})

Farm7:AddButton({
Title = "Refresh Player", 
Callback = function()
function GetPlayers()
    local players = {}
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer then
            table.insert(players, plr.Name)
        end
    end
    return players
end
Sply:SetValues(GetPlayers()) 
Sply:SetValue({}) 
end
})

local DelayLP = 0.1
local AutoGift = false
local Tsdj = Farm7:AddToggle("ATGF",{
Title = "Auto Gift Fruit",
Description = "Player",
Default = false,
Callback = function(Value)   
        if Value then
            if AutoGift then return end
                    AutoGift = true
                    task.spawn(function()
                 while AutoGift do
                    local PlayerModel = workspace:FindFirstChild(Data.SelectedPlayerGift)
                    if not PlayerModel then
                        NotifyHub("[Auto Gift] Player not found in workspace")
                        task.wait(1)
                        continue
                    end

                    local myChar = Data.LocalPlayer.Character or Data.LocalPlayer.CharacterAdded:Wait()
                    local HRP = myChar:FindFirstChild("HumanoidRootPart")
                    local targetHRP = PlayerModel:FindFirstChild("HumanoidRootPart")
                    if targetHRP and HRP and (HRP.Position - targetHRP.Position).Magnitude > 10 then
                        HRP.CFrame = targetHRP.CFrame * CFrame.new(2, 0, 0)
                        task.wait(0.5)
                    end

                    local prompt = nil
                    for _, desc in ipairs(PlayerModel:GetDescendants()) do
                        if desc:IsA("ProximityPrompt") then
                            prompt = desc
                            break
                        end
                    end

                    if not prompt then
                        NotifyHub("[Auto Gift] No valid ProximityPrompt found.")
                        task.wait(1)
                        continue
                    end

                    local GiftedFruit = {} -- Simpan buah yang sudah digift
                    for _, item in ipairs(Data.Backpack:GetChildren()) do
                        if not AutoGift then break end
                        for _, name in ipairs(Data.SelectedGiftFruit) do
                            Data.FruitTrib = item:GetAttribute("f")
                            Data.FruitUuid = item:GetAttribute("c")
                            Data.Btext = item:GetAttribute("b")
                            if string.find(tostring(Data.FruitTrib), name)
                                and Data.Btext == "j"
                                and not GiftedFruit[Data.FruitUuid] then
                                Data.Humanoid:EquipTool(item)
                                GiftedFruit[Data.FruitUuid] = true -- Tandai sudah digift            
                                task.wait(.05)
                                fireproximityprompt(prompt)
                                task.wait(.05)                                
                            end
                        end
                    end

                    task.wait(DelayLp) -- delay antar loop utama
                end
            end)
            else
            AutoGift = false
        end
end
})

Farm7:AddSlider("DATGC", {
    Title       = "Gift Speed Loop",
    Description = "Gift Speed Loop",
    Min         = 0.1,      
    Max         = 100,  
    Default     = 0.1,
    Rounding = 1,
    Callback    = function(Value)
    DelayLP = tonumber(Value)
    end
})

local ForceLp = false
Farm7:AddToggle("PSAG",{
Title = "Prevent Stopped",
Description = "Auto Gift",
Default = false,
Callback = function(Value)
    if Value then
    if ForceLp then return end
    ForceLp = true
    task.spawn(function()
     while ForceLp do
    Tsdj:SetValue(false)
    task.wait(1)
    Tsdj:SetValue(true)
    task.wait(DelayLp)
    end
end)
    else 
    ForceLp = false
    end
end
})

local AutoGiftAccept = false
Farm7:AddToggle("AAGA",{
Title = "Auto Accept Gift",
Description = "Accept All Gift",
Default = false,
Callback = function(Value)
        if Value then
            if AutoGiftAccept then return end
            AutoGiftAccept = true 
             local GuiService = game:GetService("GuiService")
            local VIM = game:GetService("VirtualInputManager")
            GuiService.AutoSelectGuiEnabled = false
            GuiService.SelectedObject = nil
            task.spawn(function()
                while AutoGiftAccept do
                    local GiftUI = Data.Players.LocalPlayer:FindFirstChild("PlayerGui")
                        and Data.Players.LocalPlayer.PlayerGui:FindFirstChild("Gift_Notification")
                    if GiftUI then
                        for _, obj in ipairs(GiftUI:GetDescendants()) do
                            if obj:IsA("ImageButton") and obj.Name == "Accept" and obj.Visible and obj.Active then
                                GuiService.SelectedObject = obj
                                VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                                task.wait(0.08)
                                break
                            end
                        end
                    end
                    task.wait(0.08)
                end
            end)
            else
            AutoGiftAccept = false
        end
end
})

local Farm11 = Tab3:AddSection("Auto Gift Pet")
Data.SelectedPLYGPS = nil
Data.SelectedGFTPET = {}
-- ---------- Toggle ON/OFF: connect / disconnect ----------
local ashfConns
local donetraded = false

local function onAshfEvents(message)
    if typeof(message) == "string" and message:lower():find("trade completed", 1, true) then
        donetraded = true
    end
end

local Sply00 = Farm11:AddDropdown("gift_player_pet", {
Title = "Select: Player",
Description = "Target Player",
Values = {}, 
Multi = false, 
AllowNull = true, 
Callback = function(Value)
Data.SelectedPLYGPS = game.Players:FindFirstChild(tostring(Value))
end
})

Farm11:AddDropdown("gift_target_pet_selected", {
Title = "Select: Pet",
Description = "Target Pet",
Values = Data.ListSellPet, 
Multi = true, 
AllowNull = true, 
Callback = function(Value)
Data.SelectedGFTPET = CVArray(Value)
end
})


Farm11:AddButton({
Title = "Refresh Player", 
Callback = function()
function GetPlayers1s()
    local players1 = {}
    for _, plr1 in ipairs(game.Players:GetPlayers()) do
        if plr1 ~= game.Players.LocalPlayer then
            table.insert(players1, plr1.Name)
        end
    end
    return players1
end
Sply00:SetValues(GetPlayers1s())
Sply00:SetValue(nil)
end
})

local nihruns = false
Farm11:AddToggle("gift_pet_target",{
    Title = "Auto Trade",
    Description = "Trade Pet",
    Default = false,
    Callback = function(enabled)
        if enabled then
            if nihruns then return end
            nihruns = true
            if ashfConns then ashfConns:Disconnect(); ashfConns = nil end
            if Data.NotificationLog and Data.NotificationLog.OnClientEvent then
                ashfConns = Data.NotificationLog.OnClientEvent:Connect(onAshfEvents)
            else
                warn("Not Found Notifications...")
            end
            task.spawn(function()
            while nihruns do
            for _, abcd in ipairs(Data.SelectedGFTPET) do
            donetraded = false
            HeldPet(abcd)
            task.wait(0.3)
            Data.PetGift:FireServer("GivePet", Data.SelectedPLYGPS)
            repeat
            task.wait(1)
            until donetraded
    end
    task.wait(1)
 end
            end)
        else
            nihruns = false
            if ashfConns then
                ashfConns:Disconnect()
                ashfConns = nil
            end
        end
    end
})


local AutoGiftAccepts = false
Farm7:AddToggle("Accept_pet",{
Title = "Auto Accept Gift",
Description = "Accept All Gift",
Default = false,
Callback = function(Value)
        if Value then
            if AutoGiftAccepts then return end
            AutoGiftAccepts = true 
             local GuiService = game:GetService("GuiService")
            local VIM = game:GetService("VirtualInputManager")
            GuiService.AutoSelectGuiEnabled = false
            GuiService.SelectedObject = nil
            task.spawn(function()
                while AutoGiftAccepts do
                    local GiftUI = Data.Players.LocalPlayer:FindFirstChild("PlayerGui")
                        and Data.Players.LocalPlayer.PlayerGui:FindFirstChild("Gift_Notification")
                    if GiftUI then
                        for _, obj in ipairs(GiftUI:GetDescendants()) do
                            if obj:IsA("ImageButton") and obj.Name == "Accept" and obj.Visible and obj.Active then
                                GuiService.SelectedObject = obj
                                VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                                VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                                task.wait(0.08)
                                break
                            end
                        end
                    end
                    task.wait(0.08)
                end
            end)
            else
            AutoGiftAccepts = false
        end
end
})

local Farm8 = Tab3:AddSection("Auto Selling")
local TimerSL = 60
Farm8:AddSlider("TMSL", {
    Title       = "Timer: Auto Sell",
    Description = "In Minutes",
    Min         = 1,      
    Max         = 100,  
    Default     = 1,
    Rounding = 0,
    Callback    = function(Value)
    local bjhg = tonumber(Value) 
    TimerSL = tonumber(bjhg) 
    end
})

local ASIIK = false
Farm8:AddToggle("ASTM",{
Title = "Auto Sell Inventory",
Description = "Timer",
Default = false,
Callback = function(Value)
if Value then
    if ASIIK then return end
    ASIIK = true
    task.spawn(function()
             while ASIIK do
                local root = Data.LocalPlayer.Character and Data.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                local originalPos = root and root.CFrame
                Teleport(CFrame.new(86.58, 3.00, 0.43))
                task.wait(1.5)
                game:GetService("ReplicatedStorage").GameEvents.Sell_Inventory:FireServer()
                task.wait(1.5)
                if originalPos then
                    Teleport(originalPos)
                end
                task.wait(TimerSL)
            end
        end)
        else
        ASIIK = false
        end
end
})

local Farm9 = Tab3:AddSection("Sprinklers")
Data.pl = game:GetService("Players").LocalPlayer
Data.cam = workspace.CurrentCamera
Data.uis = game:GetService("UserInputService")
Data.rs = game:GetService("ReplicatedStorage")
Data.cs = game:GetService("CollectionService")
Data.del = Data.rs:WaitForChild("GameEvents"):WaitForChild("DeleteObject")
Data.rem = Data.rs:WaitForChild("GameEvents"):WaitForChild("Remove_Item")
Data.getFarm = require(Data.rs.Modules.GetFarm)

function isSpr(name)
	return name:lower():find("sprinkler")
end

function ray(pos)
	Data.r = Data.cam:ViewportPointToRay(pos.X, pos.Y)
	Data.p = RaycastParams.new()
	Data.p.FilterType = Enum.RaycastFilterType.Exclude
	Data.p.FilterDescendantsInstances = {Data.cs:GetTagged("ShovelIgnore")}
	return workspace:Raycast(Data.r.Origin, Data.r.Direction * 500, Data.p)
end

function delSpr(pos)
	Data.hit = ray(pos)
	if not Data.hit then return end
	Data.m = Data.hit.Instance:FindFirstAncestorWhichIsA("Model") or Data.hit.Instance
	if not Data.m or not isSpr(Data.m.Name) then return end
	Data.f = Data.getFarm(Data.pl)
	if not Data.f or not Data.hit.Instance:IsDescendantOf(Data.f) then return end
	if Data.cs:HasTag(Data.m, "PlaceableObject") then
		Data.del:FireServer(Data.m)
	else
		Data.rem:FireServer(Data.hit.Instance)
	end
end

function ShovelAll()
	local farm = GetFarm()
	if not farm then return warn("Farm Not Found") end
	local phys = farm:FindFirstChild("Important") and farm.Important:FindFirstChild("Objects_Physical")
	if not phys then return warn("Objects_Physical Not Found") end
	for _, obj in pairs(phys:GetDescendants()) do
		local model = obj:FindFirstAncestorWhichIsA("Model") or obj
		if model and isSpr(model.Name) then
			Data.Delete:FireServer(model)
			task.wait()
		end
	end
end

Data.DeleteMode = false
Data.InputConn = nil

local placedsp = false
Farm9:AddToggle("APSPK",{
Title = "Auto Place Sprinklers",
Description = "All Sprinkler On Backpack",
Default = false,
Callback = function(Value)
if Value then
    if placedsp then return end
    placedsp = true
    task.spawn(function()
         for _, v in pairs(Data.Backpack:GetChildren()) do
        print(v.Name) 
        Data.SprinkPos = Data.HRP.Position
        Data.CreateSprink = CFrame.new(Data.SprinkPos)
        if string.find(tostring(v.Name), "Sprinkler") then
        Data.Humanoid:EquipTool(v)
        task.wait(0.1) 
        Data.SprinklerRE:FireServer("Create", Data.CreateSprink)
        task.wait(0.1)
        end
        end
    end)
    else
        placedsp = false
    end
end
})

Farm9:AddToggle("SVSP",{
Title = "Shovel Sprinkler",
Description = "Manual",
Default = false,
Callback = function(Value)
        if Value then
            if Data.DeleteMode then return end
            Data.DeleteMode = true
            NotifyHub("Equip Shovel and Click Sprinklers")
            Data.InputConn = {
                Touch = nil,
                Mouse = nil,
            }
            if Data.uis.TouchEnabled then
                Data.InputConn.Touch = Data.uis.TouchTapInWorld:Connect(function(pos)
                    delSpr(pos)
                end)
            end
            Data.InputConn.Mouse = Data.uis.InputBegan:Connect(function(input, gp)
                if not gp and input.UserInputType == Enum.UserInputType.MouseButton1 then
                    delSpr(Data.uis:GetMouseLocation())
                end
            end)
        else
            if Data.InputConn then
                if Data.InputConn.Touch then
                    Data.InputConn.Touch:Disconnect()
                end
                if Data.InputConn.Mouse then
                    Data.InputConn.Mouse:Disconnect()
                end
                Data.InputConn = nil
                Data.DeleteMode = false
            end
        end
    end
})

local shvsp = false
Farm9:AddToggle("ASSPRP",{
Title = "Auto Shovel Sprinkler",
Description = "All Placed Sprinkler",
Default = false,
Callback = function(Value)
if Value then
    if shvsp then return end
    shvsp = true
EquipSingle("Shovel")
task.wait()
ShovelAll()
task.wait()
else
    shvsp = false
end
end
})

local Farm10 = Tab3:AddSection("Calculate")
local IVvl = Farm10:AddParagraph ({
	Title = "Inventory Value", 
	Content = "$"..Data.Inven, 
}) 

Farm10:AddButton({
Title = "Calculate Inventory", 
Callback = function()
     local value = require(game:GetService("ReplicatedStorage").Modules.CalculatePlantValue)
    local total = 0
for _, item in pairs(game:GetService("Players").LocalPlayer.Backpack:GetChildren()) do
if item:GetAttribute("b") and item:GetAttribute("b") == "j" then
local juml = value(item) or 0
total = total + juml
Data.Inven = total
end
end
IVvl:SetDesc("$"..FormatNumber(Data.Inven))
end
})

local BFIF = Farm10:AddParagraph ({
	Title = "Best Fruit in Farm", 
	Content = "Name: "..Data.NameFarm.."\nWeight: "..Data.WeightFarm.." KG\nValue: $"..Data.BestFarm.. "\nMutation: "..Data.FarmMuta,
})

Farm10:AddButton({
Title = "Scan Farm", 
Callback = function()
ScanBestFarm()
task.wait(0.1)
BFIF:SetDesc("Name: "..Data.NameFarm.."\nWeight: "..Data.WeightFarm.." KG\nValue: $"..Data.BestFarm.. "\nMutation: "..Data.FarmMuta)
end
})

local BFIS = Farm10:AddParagraph ({
	Title = "Best Fruit In Server", 
	Content = "Player: "..Data.BestPall.."\nName: "..Data.NameAll.."\nWeight: "..Data.WeightAll.." KG\nValue: $"..Data.BestAll.."\nMutation: "..Data.AllMuta, 
}) 

Farm10:AddButton({
Title = "Scan Server", 
Callback = function()
ScanBestAll()
task.wait(0.1)
BFIS:SetDesc("Player: "..Data.BestPall.."\nName: "..Data.NameAll.."\nWeight: "..Data.WeightAll.." KG\nValue: $"..Data.BestAll.."\nMutation: "..Data.AllMuta) 
end
})



local Pet1 = Tab4:AddSection("Pet Control")
local ssddf = Pet1:AddDropdown("SAFP", {
Title = "Select: Pet Target",
Description = "Refresh First",
Values = {}, 
Multi = true, 
AllowNull = true, 
Callback = function(Value)
        Data.SelectedPets = {}
        local selectedNames = CVArray(Value)
        local copy = {}
        for i, v in ipairs(Data.PetListData) do
            --print("Adding Pet:", v.Name, "UUID:", v.UUID)
            copy[i] = { Name = v.Name, UUID = v.UUID, used = false }
        end

        for _, selectedName in ipairs(selectedNames) do
            print("Selected Pet:", _selectedName)
            for i, pet in ipairs(copy) do
                if pet.Name == selectedName and not pet.used then
                    print("Checking Pet:", pet.Name, "UUID:", pet.UUID)
                    table.insert(Data.SelectedPets, {
                        Name = pet.Name,
                        UUID = pet.UUID
                    })
                    pet.used = true
                    break
                end
            end
        end
    end
})

Pet1:AddButton({
Title = "Refresh Pet List", 
Callback = function()
        Data.PetListData = {}
        Data.petReal = {}
        local Empty = {}
        local ijh = 1
        local framet = game:GetService("Players").LocalPlayer.PlayerGui.ActivePetUI.Frame.Main.PetDisplay.ScrollingFrame
        for _, obj in ipairs(framet:GetChildren()) do
            if not string.find(obj.Name, "Template") then            
                local main = obj:FindFirstChild("Main")
                local petNameLabel = main and main:FindFirstChild("PET_TYPE")
                if petNameLabel and petNameLabel:IsA("TextLabel") then
                    local petName = petNameLabel.Text
                    local uuid = obj.Name

                    table.insert(Data.PetListData, {
                        Name = petName.." ("..ijh..")",
                        UUID = uuid
                    })

                    table.insert(Data.petReal, petName.." ("..ijh..")")
                    ijh += 1
                end
            end
        end
        task.wait(.1)
        ssddf:SetValues(Data.petReal)
        ssddf:SetValue(Empty) 
    end
})

Pet1:AddDropdown("SFFTF", {
Title = "Select: Fruit Feed",
Description = "Target Fruit",
Values = Data.FruitList, 
Multi = true, 
AllowNull = true, 
Callback = function(Value)
Data.SelectedFruit= CVArray(Value)
        if Value and Value[SELECT_ALL] then
            Data.SelectedFruit = CloneTable(Data.FruitList)
        else
            Data.SelectedFruit = CVArray(Value) or {}
        end
end
})

local DelayFeed = 1
Pet1:AddInput("DLYF",{
Title = "Delay: Auto Feed",
Description = "In Minutes",
Default = "1", 
Placeholder = "1",
Numeric = true,
Finished = false,
Callback = function(Value)
local ffghj = tonumber(Value) 
DelayFeed = tonumber(ffghj)
end
})

local AutoFeedEnabled = false
Pet1:AddToggle("ATFSP",{
Title = "Auto Feed",
Description = "Selected Pet",
Default = false,
Callback = function(Value)
        if Value then
        if AutoFeedEnabled then return end
        AutoFeedEnabled = true
        if not DelayFeed then
        NotifyHub("Please Set Delay Auto Feed") 
        return
        end
        task.spawn(function()
                 while AutoFeedEnabled do
                    if #Data.SelectedPets > 0 and Data.SelectedFruit and #Data.SelectedFruit > 0 then
                        for _, petData in ipairs(Data.SelectedPets) do
                            print(_, petData)
                            local petName = petData.Name
                            local uuid = petData.UUID
                            for _, fruitName in ipairs(Data.SelectedFruit) do
                                local foundTool = nil
                                for _, tool in ipairs(Data.Backpack:GetChildren()) do
                                    if tool:IsA("Tool")
                                    and string.find(tool.Name, fruitName)
                                    and not string.find(tool.Name, "Seed")
                                    and not string.find(tool.Name, "Blood Kiwi") then
                                        foundTool = tool
                                        break
                                    end
                                end
                                if foundTool then
                                    Data.Humanoid:EquipTool(foundTool)
                                    task.wait(0.3)
                                    Data.ReplicatedStorage.GameEvents.ActivePetService:FireServer("Feed", uuid)
                                    print("✅ Feeding", petName, "UUID:", uuid)
                                    task.wait(0.3)
                                    break
                                end
                            end
                        end
                    end
                    task.wait(DelayFeed)
                end
            end)
            else
           AutoFeedEnabled = false      
        end
end
})

local AutoPickupEnabled = false
Pet1:AddToggle("APPSP",{
Title = "Auto Pickup Pet",
Description = "Selected Pet",
Default = false,
Callback = function(Value)
        if Value and #Data.SelectedPets > 0 then
            if AutoPickupEnabled then return end
                 AutoPickupEnabled = true
                 for _, selected in ipairs(Data.SelectedPets) do
                    local uuid = selected.UUID
                    local name = selected.Name

                    local args = {
                        [1] = "UnequipPet",
                        [2] = uuid
                    }

                    Data.ReplicatedStorage.GameEvents.PetsService:FireServer(unpack(args))
                    NotifyHub("Pickup " .. name)
                    task.wait(0.1)
                end

                AutoPickupEnabled = false
            
        end
    end
})




local Pet2 = Tab4:AddSection("Hatch Egg")
local AutoPlcEgg = false
local MaxEggSlot = 3
local Switch_Slot = false
local Switch_Place = false
local Switch_Hatch = false
local Switch_Sell = false
local delay_hatch = 1
local delay_place = 1
local function RandomPlace()
    local MyFarmCeleng = GetFarm()
    local PlantLocations = MyFarmCeleng:WaitForChild("Important"):WaitForChild("Plant_Locations")
    if not PlantLocations then return end

    local Lands = PlantLocations:GetChildren()
    if #Lands == 0 then return end

    local Land = Lands[math.random(1, #Lands)]
    local Center = Land.Position
    local Size = Land.Size

    local X = math.random(Center.X - Size.X / 2, Center.X + Size.X / 2)
    local Z = math.random(Center.Z - Size.Z / 2, Center.Z + Size.Z / 2)

    return Vector3.new(X, Land.Position.Y, Z)
end

local function FindMatchingTool()
    local function isMatch(name)
        local baseName = name:match("^(.-) x") or name
        baseName = baseName:lower():gsub("%s+", "")
        for _, eggName in ipairs(Data.SelectedHatchPet) do
            local target = tostring(eggName):lower():gsub("%s+", "")
            if baseName == target then
                return true
            end
        end
        return false
    end

    for _, tool in ipairs(Data.Backpack:GetChildren()) do
        if tool:IsA("Tool") and isMatch(tool.Name) then
            return tool
        end
    end

    local charFolder = workspace[Data.LocalPlayer.Name]
    if charFolder then
        for _, obj in ipairs(charFolder:GetDescendants()) do
            if obj:IsA("Tool") and isMatch(obj.Name) then
                return obj
            end
        end
    end

    return nil
end


local function FindMatchingEgg()
    local function isMatch(name)
        local baseName = name:match("^(.-) x") or name
        baseName = baseName:lower():gsub("%s+", "")
        for _, eggName in ipairs(Data.SelectedHatchPetIH) do
            local target = tostring(eggName):lower():gsub("%s+", "")
            if baseName == target then
                return true
            end
        end
        return false
    end

    for _, tool in ipairs(Data.Backpack:GetChildren()) do
        if tool:IsA("Tool") and isMatch(tool.Name) then
            return tool
        end
    end

    local charFolder = workspace[Data.LocalPlayer.Name]
    if charFolder then
        for _, obj in ipairs(charFolder:GetDescendants()) do
            if obj:IsA("Tool") and isMatch(obj.Name) then
                return obj
            end
        end
    end

    return nil
end

Pet2:AddDropdown("SelEggwsd", {
Title = "Select: Egg",
Description = "Target",
Values = Data.EggList, 
Multi = true, 
AllowNull = true, 
Callback = function(Value)
if Value and Value[SELECT_ALL] then
    Data.SelectedHatchPet = CloneTable(Data.EggList)
else
    Data.SelectedHatchPet = CVArray(Value) or {}
end
end
})

Pet2:AddInput("MXEGG",{
Title = "Egg: Max Slot",
Description = "In Your Garden",
Placeholder = "3",
Numeric = true,
Finished = false,
Callback = function(Value)
MaxEggSlot = tonumber(Value)
end
})

Pet2:AddToggle("APESJKK",{
    Title = "Auto Place Egg",
    Description = "Selected",
    Default = false,
    Callback = function(Value)
        if Value then
            if AutoPlcEgg then return end
                AutoPlcEgg = true
                task.spawn(function()
                 while AutoPlcEgg do      
                if not Data.SelectedHatchPet or typeof(Data.SelectedHatchPet) ~= "table" or #Data.SelectedHatchPet == 0 then
                    task.wait(1)
                    continue
              end
                    -- pastikan numeric
                    local eggCounted = tonumber(GetEgg()) or 0
                    local maxSlot = tonumber(MaxEggSlot) or 0

                    local placeded = 0
                    local foundAny = false
                    local placetick = false
                    if eggCounted < maxSlot then
                        local tool = FindMatchingTool()
                        while tool and eggCounted < maxSlot do
                            if not AutoPlcEgg then return end
                            local PosEgg = RandomPlace()
                            foundAny = true
                            pcall(function() Data.Humanoid:EquipTool(tool) end)
                            task.wait(0.5)
                            Data.RemotePlace:FireServer("CreateEgg", PosEgg)
                            placeded = placeded + 1
                            eggCounted = eggCounted + 1
                            task.wait(0.5)
                            tool = FindMatchingTool()
                            placetick = true
                            break
                        end
                    end

                    if not foundAny and eggCounted < maxSlot then
                        NotifyHub("No eggs in your inventory!")
                    end
                    task.wait(delay_place)
                end
            end)
        else
            AutoPlcEgg = false
        end
    end
})


TombolAutoHatch = Pet2:AddToggle("AHEGS", {
    Title = "Auto Hatch Egg",
    Description = "Selected",
    Default = false,
    Callback = function(Value)
        if Value then
            if AutoEPH then return end
            AutoEPH = true

            task.spawn(function()
                while AutoEPH do
                    local Ladangs = GetFarm()
                    local Object = Ladangs:WaitForChild("Important"):WaitForChild("Objects_Physical")

                    for _, desc in ipairs(Object:GetChildren()) do
                        if not AutoEPH then return end

                        local name = desc:GetAttribute("EggName")
                        local ready = desc:GetAttribute("TimeToHatch")

                        for _, j in ipairs(Data.SelectedHatchPet or {}) do
                            if not AutoEPH then return end

                            if string.find(name, j) and ready == 0 then
                                if CheckEggThreshold then
                                    NotifyHub("Checking Threshold...")
                                    local pass = checkThreshold()

                                    -- kalau threshold sudah terpenuhi, skip hatch untuk telur ini
                                    if not pass then
                                        NotifyHub("Skipping hatch: threshold reached.")
                                        task.wait(1)
                                        break
                                    end

                                    task.wait(10)
                                end

                                -- lanjut hatch kalau belum mencapai threshold
                                game:GetService("ReplicatedStorage").GameEvents.PetEggService:FireServer("HatchPet", desc)
                                task.wait(delay_hatch)
                                break
                            end
                        end
                    end

                    task.wait(delay_hatch)
                end
            end)
        else
            AutoEPH = false
        end
    end
})


Pet2:AddInput("Weight_threshold",{
Title = "Input: Weight",
Description = "Auto Stop When Reached",
Placeholder = "10",
Numeric = true,
Finished = true,
Callback = function(Value)
Data.EggThreshold = Value
end
})


Pet2:AddToggle("Auto_Threshold",{
Title = "Auto Hatch Threshold",
Description = "Work for Farm egg and Auto Hatch",
Default = false,
Callback = function(Value)
if Value then
if CheckEggThreshold then return end
CheckEggThreshold = true
else
CheckEggThreshold = false
end
end
})


local Pet3 = Tab4:AddSection("Auto Sell Pet")
Pet3:AddDropdown("sell_pet_list", {
Title = "Select: Pet List",
Description = "Target Pet",
Values = Data.ListSellPet, 
Multi = true, 
AllowNull = true, 
Callback = function(Value)
        if Value and Value[SELECT_ALL] then
            Data.SelectedSellPet = CloneTable(Data.ListSellPet)
        else
            Data.SelectedSellPet = CVArray(Value) or {}
        end
end
})


Pet3:AddInput("weight_sell",{
Title = "Filter: Weight",
Description = "Sell Below This KG",
Placeholder = "0",
Numeric = true,
Finished = false,
Callback = function(Value)
TargetWS = tonumber(Value)
end
})

local TargetAge = 0
Pet3:AddInput("age_sell",{
Title = "Filter: Age",
Description = "Sell Below This Age",
Placeholder = "0",
Numeric = true,
Finished = false,
Callback = function(Value)
TargetAge = tonumber(Value)
end
})

local delay_sell_pet = 0.05
Pet3:AddToggle("sell_pet",{
    Title = "Auto Sell Pet",
    Description = "Selected Pet",
    Default = false,
    Callback = function(Value)
        if Value then
            if AutoSP then return end
            AutoSP = true
            task.spawn(function()
                while AutoSP do
                    if not Data.SelectedSellPet or #Data.SelectedSellPet == 0 then
                        task.wait(1)
                        continue
                    end

                    for _, pet in ipairs(Data.Backpack:GetChildren()) do
                        local petName = pet.Name
                        if string.find(petName, "Age") and not pet:GetAttribute("d") then
                            local baseName = petName:match("^(.-) %[")

                            for _, targetName in ipairs(Data.SelectedSellPet) do
                                if baseName and baseName == targetName then
                                    local weightStr = petName:match("%[(%d+%.?%d*) KG%]")
                                    local ageStr    = petName:match("%[Age (%d+)%]")

                                    local allowWeight = (not TargetWS or TargetWS == 0)
                                    if not allowWeight and weightStr then
                                        local w = tonumber(weightStr)
                                        if w and w < TargetWS then allowWeight = true end
                                    end

                                    local allowAge = (not TargetAge or TargetAge == 0)
                                    if not allowAge and ageStr then
                                        local a = tonumber(ageStr)
                                        if a and a <= TargetAge then allowAge = true end
                                    end

                                    if allowWeight and allowAge then
                                        Data.Humanoid:EquipTool(pet)
                                        task.wait(delay_sell_pet)
                                        Data.SellPetRE:FireServer(pet)
                                        task.wait(delay_sell_pet)
                                        soldThisTick = true
                                        break
                                    end
                                end
                            end
                        end
                    end
                    task.wait(0.02)
                end
            end)
        else
            AutoSP = false
        end
    end
})

local function num(v, d) return (tonumber(v) or d) end

-- ===================== Konstanta & Defaults =====================
local WAIT_AFTER_SWITCH = 10            -- detik; bisa diubah via input UI
delay_place = num(delay_place, 0.75)    -- jeda antar place
local fallback_delay_sell = num(delay_sell_pet, 1)
local Whitelist_Favourite = {}
-- Matikan flags lama bila ada
if AutoPlcEgg ~= nil then AutoPlcEgg = false end
if AutoEPH    ~= nil then AutoEPH    = false end
if AutoSP     ~= nil then AutoSP     = false end

-- Flags baru

Switch_Place = false
Switch_Hatch = false
Switch_Sell  = false

-- =================== Mapping KODE SERVER ====================
-- (sesuai maumu) PLACE=1, HATCH=3, SELL=2
local LOADOUT_PLACE = 1
local LOADOUT_HATCH = 3
local LOADOUT_SELL  = 2
-- ===========================================================


-- ============================ Helpers ==========================
-- SWITCH → tunggu; label hanya untuk tampilan (mis. "1","2","3")
local function SwitchToAndWait(loadout, label)
    if not Switch_Slot then
        NotifyHub("Please enable 'Auto Switch Loadout' first")
        return false
    end

    NotifyHub("Switching Pet Loadouts "..tostring(label))
    local ok = pcall(function()
        Data.SwitchPet:FireServer("SwapPetLoadout", loadout)
    end)
    if not ok then
        task.wait(0.25)
        ok = pcall(function()
            Data.SwitchPet:FireServer("SwapPetLoadout", loadout)
        end)
        if not ok then
            NotifyHub("SwapPetLoadout failed")
            return false
        end
    end

    Switch_Place = (loadout == LOADOUT_PLACE)
    Switch_Hatch = (loadout == LOADOUT_HATCH)
    Switch_Sell  = (loadout == LOADOUT_SELL)

    task.wait(WAIT_AFTER_SWITCH)
    return true
end

-- cek target hatch
local function InSelectedHatch(eggName)
    if not eggName then return false end
    local sel = Data.SelectedHatchPet
    if typeof(sel) ~= "table" or #sel == 0 then return false end
    for _, key in ipairs(sel) do
        if key and string.find(eggName, key) then
            return true
        end
    end
    return false
end

-- parsing nama pet untuk filter sell (hapus semua [ ... ])
local function _extractBaseName(toolName)
    if type(toolName) ~= "string" then return nil end
    local clean = toolName:gsub("%s*%[[^%]]-%]", "")
    clean = clean:gsub("^%s+",""):gsub("%s+$","")
    return clean
end

local function _inSellList(baseName)
    if not baseName then return false end
    local list = Data.SelectedSellPet
    if typeof(list) ~= "table" or #list == 0 then return false end
    local bn = string.lower(baseName)
    for _, t in ipairs(list) do
        if type(t) == "string" and string.lower(t) == bn then
            return true
        end
    end
    return false
end

local function AllowSellByFilter(petToolName)
    if not petToolName then return false end
    local baseName = _extractBaseName(petToolName)
    if not _inSellList(baseName) then return false end

    local allowWeight = (not TargetWS or TargetWS == 0)
    local weightStr   = petToolName:match("%[(%d+%.?%d*)%s*KG%]")
    if not allowWeight and weightStr then
        local w = tonumber(weightStr)
        if w and w < TargetWS then 
            allowWeight = true 
        end
    end

    local allowAge = (not TargetAge or TargetAge == 0)
    local ageStr   = petToolName:match("%[Age%s*(%d+)%]")
    if not allowAge and ageStr then
        local a = tonumber(ageStr)
        if a and a <= TargetAge then allowAge = true end
    end

    return allowWeight and allowAge
end

-- ambil egg di farm yang match pilihan (aman dari ghost)
local function GetSelectedFarmEggs()
    local Ladangs = GetFarm()
    if not Ladangs then return {} end
    local Important = Ladangs:FindFirstChild("Important")
    local Object = Important and Important:FindFirstChild("Objects_Physical")
    if not Object then return {} end

    local eggs = {}
    for _, desc in ipairs(Object:GetChildren()) do
        if desc and desc.Parent == Object then
            local name = desc:GetAttribute("EggName")
            local tth  = desc:GetAttribute("TimeToHatch")
            if name and InSelectedHatch(name) and type(tth) == "number" then
                table.insert(eggs, desc)
            end
        end
    end
    return eggs
end

local function AllEggsReady(eggList)
    if #eggList == 0 then return false end
    for _, e in ipairs(eggList) do
        if (e:GetAttribute("TimeToHatch") or 1) ~= 0 then
            return false
        end
    end
    return true
end

-- tunggu sampai SEMUA egg target di farm ready
local function WaitAllSelectedEggsReady()
    while AutoEggCycleStrict do
        local eggs = GetSelectedFarmEggs()
        if #eggs > 0 and AllEggsReady(eggs) then
            return eggs
        end
        task.wait(1)
    end
    return {}
end

-- tunggu HANYA batch yang barusan di-hatch hilang (fix Koi auto-place)
local function WaitBatchCleared(batch)
    while AutoEggCycleStrict do
        local any = false
        for _, e in ipairs(batch) do
            if e and e.Parent then
                any = true
                break
            end
        end
        if not any then return true end
        task.wait(0.2)
    end
    return false
end

-- snapshot kandidat jual (stabil saat equip/sell)
local function _collectSellables()
    local out = {}
    if typeof(Data.SelectedSellPet) ~= "table" or #Data.SelectedSellPet == 0 then
        return out
    end

    -- Kumpulkan container: Backpack + Character (held tools)
    local containers = {}
    local lp = Data.LocalPlayer
    local backpack = Data.Backpack or (lp and lp:FindFirstChild("Backpack"))
    if backpack then containers[#containers+1] = backpack end
    local char = lp and (lp.Character or workspace:FindFirstChild(lp.Name))
    if char then containers[#containers+1] = char end
    if #containers == 0 then return out end

    for _, bag in ipairs(containers) do
        for _, pet in ipairs(bag:GetChildren()) do
            if pet:IsA("Tool") then
                local petName = pet.Name
                local cleanName = _extractBaseName(petName)
                local weightBase = petName:match("%[(%d+%.?%d*)%s*KG%]")
                local NumberWeight = tonumber(weightBase)

                if string.find(petName, "Age") and not pet:GetAttribute("d") then
                    if ((Whitelist_Favourite or {})[cleanName])
                       or (type(TargetWS) == "number" and TargetWS and TargetWS > 0 and NumberWeight and NumberWeight >= TargetWS) then
                        Data.FavoriteItem:FireServer(pet)
                    elseif AllowSellByFilter(petName) then
                        table.insert(out, pet)
                    end
                end
            end
        end
    end
    return out
end

-- ===============================================================


-- ====================== Robust Placement =======================
local PLACE_TRIES_PER_SLOT   = 6      -- coba per 1 slot
local PLACE_CONFIRM_TIMEOUT  = 1.2    -- detik menunggu GetEgg() naik
local PLACE_JITTER_MAX       = 8      -- stud max jitter

local function _jitterPos(pos, step)
    local radius = math.min(PLACE_JITTER_MAX, 1 + (step - 1) * 1.5)
    local ang = math.random() * math.pi * 2
    return Vector3.new(
        pos.X + math.cos(ang) * radius,
        pos.Y,
        pos.Z + math.sin(ang) * radius
    )
end

local function _tryPlaceOne(tool)
    local before = num(GetEgg(), 0)
    local basePos = RandomPlace()

    for t = 1, PLACE_TRIES_PER_SLOT do
        local pos = (t == 1) and basePos or _jitterPos(basePos, t)

        pcall(function() Data.Humanoid:EquipTool(tool) end)
        task.wait(0.1)
        pcall(function()
            Data.RemotePlace:FireServer("CreateEgg", pos)
        end)

        local waited = 0
        while waited < PLACE_CONFIRM_TIMEOUT do
            task.wait(0.15)
            local now = num(GetEgg(), 0)
            if now > before then
                return true
            end
            waited = waited + 0.15
        end
    end

    return false
end

-- core place TANPA switch (dipakai saat baru saja dipaksa balik ke 1)
local function _placeCoreNoSwitch()
    local placed = false
    local hardGuard = 0

    while AutoEggCycleStrict do
        local eggCount = num(GetEgg(), 0)
        local maxSlot  = num(MaxEggSlot, 0)
        if eggCount >= maxSlot then break end

        local tool = FindMatchingTool()
        if not tool then break end

        hardGuard = hardGuard + 1
        if hardGuard > 64 then break end

        local ok = _tryPlaceOne(tool)
        if ok then
            placed = true
            task.wait(delay_place or 0.5)
        else
            task.wait(0.15)
        end
    end

    return placed
end
-- ===============================================================


-- ============================= Phases ==========================
-- 1) PLACE: switch(1) → wait → place hingga MaxEggSlot
local function DoPlacePhase()
    if not AutoEggCycleStrict then return false end
    if type(GetEgg) ~= "function" then return false end
    if type(FindMatchingTool) ~= "function" then return false end
    if type(RandomPlace) ~= "function" then return false end

    if typeof(Data.SelectedHatchPet) ~= "table" or #Data.SelectedHatchPet == 0 then
        NotifyHub("Select Hatch Pet first before placing eggs")
        return false
    end

    -- pre-check: ada slot & ada tool?
    if num(GetEgg(), 0) >= num(MaxEggSlot, 0) then return false end
    if not FindMatchingTool() then return false end

    if not SwitchToAndWait(LOADOUT_PLACE, "1") then return false end
    task.wait(5)
    local placed = _placeCoreNoSwitch()

    local cur = num(GetEgg(), 0)
    local mx  = num(MaxEggSlot, 0)
    if placed and cur < mx then
        NotifyHub(("Placed %d/%d eggs."):format(cur, mx))
    end

    return placed
end

-- 2) HATCH: tunggu ALL ready → switch(3) → wait → hatch batch → tunggu batch bersih
local function DoHatchPhase()
    if not AutoEggCycleStrict then return false end
    local readyEggs = WaitAllSelectedEggsReady()
    if #readyEggs == 0 then
        return false
    end

    -- HATCH = 3 (server code), label "2" utk tampilanmu
    if not SwitchToAndWait(LOADOUT_HATCH, "2") then return false end
    task.wait(5)
    local did = false
    local hatchedBatch = {}

    -- hatch semua yang ready sekarang
    local eggs = GetSelectedFarmEggs()
    for _, e in ipairs(eggs) do
        if e and (e:GetAttribute("TimeToHatch") or 1) == 0 then
            if not AutoEggCycleStrict then break end
            if CheckEggThreshold then
                NotifyHub("Checking Threshold...")
                checkThreshold()
                task.wait(10)
            end
            table.insert(hatchedBatch, e)
            pcall(function()
                game:GetService("ReplicatedStorage").GameEvents.PetEggService:FireServer("HatchPet", e)
            end)
            did = true
            task.wait(0.75)
        end
    end

    if did then
        -- penting: hanya tunggu batch ini hilang (Koi auto-place nggak akan nge-lock)
        WaitBatchCleared(hatchedBatch)
        task.wait(0.5) -- beri waktu item masuk backpack
    end

    return did
end

-- 3) SELL: ada kandidat? → switch(2) → wait → sell snapshot
local function DoSellPhase()
    if not AutoEggCycleStrict then return false end

    local candidates = _collectSellables()
    if #candidates == 0 then
        return false
    end

    if not SwitchToAndWait(LOADOUT_SELL, "3") then return false end
    task.wait(5)
    local sold = 0
    for _, pet in ipairs(candidates) do
        if pet and pet.Parent == Data.Backpack then
            pcall(function() Data.Humanoid:EquipTool(pet) end)
            task.wait(fallback_delay_sell)
            pcall(function() Data.SellPetRE:FireServer(pet) end)
            task.wait(fallback_delay_sell)
            sold = sold + 1
        end
    end

    return (sold > 0)
end

-- === FORCE: sesudah SELL wajib balik switch ke loadout 1 ===
local function ForceBackToPlaceAfterSell()
    -- Selalu paksa switch ke 1 + tunggu, agar ability place aktif lagi
    return SwitchToAndWait(LOADOUT_PLACE, "1")
end

-- Setelah SELL & sudah dipaksa balik ke 1, kalau slot belum penuh,
-- refill PLACE TANPA switch lagi (hindari double wait)
local function TopUpPlaceAfterSell_NoSwitch()
    local eggCount = num(GetEgg(), 0)
    local maxSlot  = num(MaxEggSlot, 0)
    if eggCount < maxSlot then
        return _placeCoreNoSwitch() == true
    end
    return false
end
-- ===============================================================


-- =============================== UI ============================

Pet2:AddParagraph({
    Title = "Unlimited Egg Farm", 
    Content = "1. Set Loadouts 1, Pet is Bald Eagle and Peacock or Other\n2. Set Loadouts 2, Pet is Koi or other pet\n3. Set Loadouts 3, Pet is Seals or other\n4. Set Target Egg for place and hatch\n5. Set Max Slot Egg in Garden\n6. Set Filter for auto sell pet (filter pet, Weight, Age (optional))\n7. Enable Auto Farm Egg", 
}) 

Pet2:AddInput("FWSBTK",{
    Title = "Delay: Switching",
    Description = "Depends on ping",
    Placeholder = "10",
    Numeric = true,
    Finished = false,
    Callback = function(Value)
        local v = tonumber(Value)
        if v and v > 0 then WAIT_AFTER_SWITCH = v end
    end
})

Pet2:AddDropdown("white_Fav_pet", {
Title = "Whitelist: Favourite Pet",
Description = "Rare Pet",
Values = Data.ListSellPet, 
Multi = true, 
AllowNull = true, 
Callback = function(Value)
Data.Whitelist_Favourite = Value
end
})

TombolAutoFarmEgg = Pet2:AddToggle("AUTO_EGG_CYCLE_STRICT", {
    Title = "Auto Farm Egg",
    Description = "Unlimited Eggs",
    Default = false,
    Callback = function(Value)
        if Value then
            if AutoEggCycleStrict then return end
            AutoEggCycleStrict = true
            Switch_Slot = true
            Switch_Place, Switch_Hatch, Switch_Sell = false, false, false

            task.spawn(function()
                while AutoEggCycleStrict do
                    local placed  = (DoPlacePhase()  == true)
                    if placed  then NotifyHub("Placed Eggs") end

                    local hatched = (DoHatchPhase() == true)
                    if hatched then NotifyHub("Hatched Egg") end

                    local sold    = (DoSellPhase()  == true)
                    if sold    then NotifyHub("Selling Pet") end

                    -- WAJIB: sesudah SELL selalu paksa balik ke loadout 1
                    if sold then
                        local backOk = ForceBackToPlaceAfterSell()
                        if backOk then
                            -- isi slot kalau masih bolong (tanpa switch lagi)
                            local topped = TopUpPlaceAfterSell_NoSwitch()
                            if topped then NotifyHub("Refilled Eggs After Sell") end
                        end
                    end

                    if not placed and not hatched and not sold then
                        task.wait(0.8)
                    else
                        task.wait(0.2)
                    end
                end
            end)
        else
            Switch_Slot = false
            AutoEggCycleStrict = false
            Switch_Place, Switch_Hatch, Switch_Sell = false, false, false
        end
    end
})
-- ===============================================================





local Pet4 = Tab4:AddSection("Pet Booster")
local SelectedBPets = {}
local jjuh = Pet4:AddDropdown("SPBT", {
Title = "Select: Pet List",
Description = "Target Pet",
Values = {}, 
Multi = true, 
AllowNull = true, 
Callback = function(Value)
        Data.SelectedBPets = {}

        local selectedNames = CVArray(Value)
        local copy = {}
        for i, v in ipairs(Data.PetListData) do
            copy[i] = { Name = v.Name, UUID = v.UUID, used = false }
        end

        for _, selectedName in ipairs(selectedNames) do
            print("Selected Pet:", selectedName)
            for i, pet in ipairs(copy) do
                if pet.Name == selectedName and not pet.used then
                    table.insert(Data.SelectedBPets, {
                        Name = pet.Name,
                        UUID = pet.UUID
                    })
                    pet.used = true
                    break
                end
            end
        end
end
})

Pet4:AddButton({
Title = "Refresh Pet List", 
Callback = function()
        Data.PetListData = {}
        Data.petReal = {}
        local Empty = {}
        local ijh = 1
        local framet = game:GetService("Players").LocalPlayer.PlayerGui.ActivePetUI.Frame.Main.PetDisplay.ScrollingFrame
        for _, obj in ipairs(framet:GetChildren()) do
            if not string.find(obj.Name, "Template") then            
                local main = obj:FindFirstChild("Main")
                local petNameLabel = main and main:FindFirstChild("PET_TYPE")
                if petNameLabel and petNameLabel:IsA("TextLabel") then
                    local petName = petNameLabel.Text
                    local uuid = obj.Name

                    table.insert(Data.PetListData, {
                        Name = petName.." ("..ijh..")",
                        UUID = uuid
                    })

                    table.insert(Data.petReal, petName.." ("..ijh..")")
                    ijh += 1
                end
            end
        end
        task.wait(.1)
        jjuh:SetValues(Data.petReal)
        jjuh:SetValue(Empty) 
    end
})

Pet4:AddDropdown("SBTY", {
Title = "Select: Toy",
Description = "Target Toy",
Values = {"Small Pet Toy", "Medium Pet Toy", "Small Pet Treat", "Medium Pet Treat"}, 
Multi = true, 
AllowNull = true, 
Callback = function(Value)
Data.SelectedToys = CVArray(Value)
end
})

Pet4:AddButton({
Title = "Apply Boost 1x", 
Callback = function()
 for _, v in pairs(Data.SelectedBPets) do
local abcg = v.UUID
EquipSingle(tostring(Data.SelectedToys))
task.wait()
Data.PetBoost:FireServer("ApplyBoost", tostring(abcg))
end

end
})

local DelayBoost = 60
Pet4:AddSlider("DAAPB", {
    Title       = "Apply Boost Delay",
    Description = "In Minutes",
    Min         = 1,      
    Max         = 100,  
    Default     = 1,
    Rounding = 0,
    Callback    = function(Value)
    local kmwn = tonumber(Value) 
    DelayBoost = tonumber(kmwn) * 60
    end
})

local AutoBoostPet = false
Pet4:AddToggle("AABP",{
Title = "Auto Apply Boost",
Description = "Selected Pet",
Default = false,
Callback = function(Value)
    if Value then
    if AutoBoostPet then return end
    AutoBoostPet = true
    task.spawn(function()
 while AutoBoostPet do
for _, v in pairs(Data.SelectedBPets) do
local abcg = v.UUID
for ahhahh, jjj in ipairs(Data.SelectedToys) do
EquipSingle(tostring(jjj))
task.wait(0.1)
Data.PetBoost:FireServer("ApplyBoost", tostring(abcg))
end
task.wait(1)
end
task.wait(DelayBoost)
end
end)
else
AutoBoostPet = false
    end
end
})

local Pet5 = Tab4:AddSection("Auto Switch Pet")
Data.SelectedLoadout = {}
Data.DelaySWTCH = 5
Data.AutoSWTCH = false

Pet5:AddDropdown("Select_Switch", {
Title = "Select: Loadout",
Description = "Target Loadout",
Values = {"1", "2", "3"}, 
Default = {"1"},
Multi = true, 
AllowNull = true, 
Callback = function(Value)
Data.SelectedLoadout = CVArray(Value) or {}
end
})


Pet5:AddInput("delay_switch",{
Title = "Delay: Seconds",
Description = "Delay Switch ",
Placeholder = "5",
Numeric = true,
Finished = false,
Callback = function(Value)
Data.DelaySWTCH = tonumber(Value)
end
})


Pet5:AddToggle("Auto_SWTCH", {
    Title = "Auto Switch Loadout",
    Description = "Pet Loadout",
    Default = false,
    Callback = function(Value)
        if Value then
            if Data.AutoSWTCH then return end
            Data.AutoSWTCH = true
            local delayS = tonumber(Data.DelaySWTCH)

            local map = { [1] = 1, [2] = 3, [3] = 2 }
            task.spawn(function()
            while Data.AutoSWTCH do
                for _, load in ipairs(Data.SelectedLoadout or {}) do
                    if not Data.AutoSWTCH then break end

                    local n = tonumber(load)
                    local target = n and map[n]
                    if target then
                        Data.SwitchPet:FireServer("SwapPetLoadout", target)
                        print("Switched to Loadout", target, "delay:", delayS, "seconds")
                    task.wait(delayS)
                    else
                        warn("Loadout invalid: ", load)
                    end
                end
                task.wait(delayS) -- wait longer before repeating
            end
        end)
        else
        Data.AutoSWTCH = false
        end
    end
})

local Pet6 = Tab4:AddSection("Auto Farm Mutation")
--========================================
-- Sticky Status GUI + notify(text, kind?)
-- kind opsional: "ok" | "warn" | "err"
--========================================
local TweenService = game:GetService("TweenService")

local function C(hex)
    hex = hex:gsub("#","")
    return Color3.fromRGB(tonumber(hex:sub(1,2),16), tonumber(hex:sub(3,4),16), tonumber(hex:sub(5,6),16))
end

local THEME = {
    bg     = C("101217"),
    panel  = C("171A21"),
    stroke = C("2A2F3A"),
    text   = C("E5E7EB"),
    faint  = C("9CA3AF"),
    ok     = C("34D399"),
    warn   = C("FBBF24"),
    err    = C("F87171"),
}

local __StatusGUI, __MsgLabel, __TitleLabel, __Pill

local function getPlayerGui()
    local lp = (Data and Data.LocalPlayer) or game.Players.LocalPlayer
    return lp:WaitForChild("PlayerGui")
end

local function ensureGUI()
    if __StatusGUI and __StatusGUI.Parent then return end

    local pg = getPlayerGui()
    -- root
    local gui = Instance.new("ScreenGui")
    gui.Name = "MutationStatusDock"
    gui.ResetOnSpawn = false
    gui.IgnoreGuiInset = true
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    gui.Parent = pg

    -- panel
    local panel = Instance.new("Frame")
    panel.AnchorPoint = Vector2.new(1,0)
    panel.Position = UDim2.new(1,-20,0,20)
    panel.Size = UDim2.new(0, 330, 0, 110)
    panel.BackgroundColor3 = THEME.panel
    panel.BorderSizePixel = 0
    panel.Parent = gui
    Instance.new("UICorner", panel).CornerRadius = UDim.new(0,12)
    local st = Instance.new("UIStroke", panel); st.Color = THEME.stroke; st.Thickness = 1
    local grad = Instance.new("UIGradient", panel)
    grad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(24,28,36)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(14,16,22)),
    }

    -- header
    local header = Instance.new("Frame")
    header.BackgroundTransparency = 1
    header.Position = UDim2.new(0,10,0,8)
    header.Size = UDim2.new(1,-20,0,28)
    header.Parent = panel

    local title = Instance.new("TextLabel")
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamSemibold
    title.Text = "Mutation Status"
    title.TextColor3 = THEME.text
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Size = UDim2.new(1,-120,1,0)
    title.Parent = header

    local pill = Instance.new("TextLabel")
    pill.AnchorPoint = Vector2.new(1,0.5)
    pill.Position = UDim2.new(1,0,0.5,0)
    pill.Size = UDim2.new(0,100,1,0)
    pill.BackgroundColor3 = THEME.ok
    pill.Text = "OK"
    pill.Font = Enum.Font.GothamMedium
    pill.TextSize = 14
    pill.TextColor3 = Color3.new(0,0,0)
    pill.Parent = header
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1,0)

    -- message
    local msg = Instance.new("TextLabel")
    msg.Name = "Message"
    msg.BackgroundTransparency = 1
    msg.TextWrapped = true
    msg.TextTruncate = Enum.TextTruncate.AtEnd
    msg.TextXAlignment = Enum.TextXAlignment.Left
    msg.TextYAlignment = Enum.TextYAlignment.Top
    msg.Font = Enum.Font.Gotham
    msg.TextSize = 16
    msg.TextColor3 = THEME.text
    msg.Text = "Idle"
    msg.Position = UDim2.new(0,12,0,46)
    msg.Size = UDim2.new(1,-24,1,-56)
    msg.Parent = panel

    __StatusGUI, __MsgLabel, __TitleLabel, __Pill = gui, msg, title, pill
end

local function setPill(kind)
    if not __Pill then return end
    local text, col = "OK", THEME.ok
    if kind == "warn" then text, col = "Working", THEME.warn
    elseif kind == "err" then text, col = "Error", THEME.err
    elseif kind == "ok" then text, col = "OK", THEME.ok
    end
    __Pill.Text = text
    TweenService:Create(__Pill, TweenInfo.new(0.18), {BackgroundColor3 = col}):Play()
end

-- ========= PUBLIC API =========
function notify(text, kind)
    ensureGUI()
    local t = tostring(text or "")
    __MsgLabel.TextTransparency = 0.2
    __MsgLabel.Text = t
    TweenService:Create(__MsgLabel, TweenInfo.new(0.15), {TextTransparency = 0}):Play()

    -- auto-infer kind jika kosong
    if not kind then
        local low = t:lower()
        if low:find("fail") or low:find("error") or low:find("gagal") then
            kind = "err"
        elseif low:find("wait") or low:find("start") or low:find("ready") or low:find("switch") then
            kind = "warn"
        else
            kind = "ok"
        end
    end
    setPill(kind)
end




-- opsional helper:
--notify.status = function(label, kind) ensureGUI(); __Pill.Text = label or __Pill.Text; setPill(kind) end
--notify.title  = function(t) ensureGUI(); __TitleLabel.Text = tostring(t or "Mutation Status") end
--notify.clear  = function() ensureGUI(); __MsgLabel.Text = "Idle"; setPill("ok") end
--notify.destroy= function() if __StatusGUI then __StatusGUI:Destroy() __StatusGUI=nil __MsgLabel=nil __TitleLabel=nil __Pill=nil end end

--========================================================
-- Auto Pet Mutation: Full Integration (UI + Logic)
-- Order: Check Age ≥ 50 -> Pickup(backpack) -> Equip -> SubmitHeldPet -> StartMachine -> Slot 1 -> Claim
-- After claim: if NOT match -> Switch Slot 2 FIRST -> then Equip pet to Slot 2
--========================================================

--========================
-- Config
--========================
------------------------------------------------------------
-- Auto Mutate (Full) — versi stabil & auto-stop on success
-- Perbaikan utama:
-- 1) Age threshold: >= AGE_TARGET (default 50)
-- 2) Pickup/Equip lebih robust (timeout lebih panjang)
-- 3) Stop otomatis saat mutasi sesuai
-- 4) Jika tidak sesuai: pindah ke Slot 2 dahulu, lalu equip ulang
------------------------------------------------------------

--========================
-- Konstanta
--========================
local AGE_TARGET            = 50      -- Age minimal (>=)
local WAIT_BETWEEN_POLLS    = 3.5
local WAIT_AFTER_SWITCH     = 7
local WAIT_AFTER_SUBMIT     = 3.5
local WAIT_AFTER_START      = 3.5
local MACHINE_READY_TIMEOUT = 3800    -- detik

-- Target mutation keywords (bisa di-set via dropdown)


--========================
-- Utilities
--========================
local function clear(tbl)
    if not tbl then return end
    for k in pairs(tbl) do
        tbl[k] = nil
    end
end

--========================
-- Remotes & Handles (ambil dari Data)
--========================
local PetMutateRE = Data.GameEvents and Data.GameEvents.PetMutationMachineService_RE

-- PetsService: prioritas dari Data.ReplicatedStorage.GameEvents.PetsService
local PetsService = (Data.ReplicatedStorage and Data.ReplicatedStorage.GameEvents and Data.ReplicatedStorage.GameEvents.PetsService)
                    or (Data.GameEvents and Data.GameEvents.PetsService)
                    or Data.EquipPet  -- fallback legacy

local EquipRE  = PetsService -- gunakan PetsService untuk Equip/Unequip
local Humanoid = Data.Humanoid
local Backpack = Data.Backpack
local HRP      = Data.HRP
Data.AutoMutateRunning = false
local SendPublicDesired = false
local function SwitchToLoadout(slot)
    if Data.SwitchPet and typeof(Data.SwitchPet.FireServer) == "function" then
        local ok, err = pcall(function()
            Data.SwitchPet:FireServer("SwapPetLoadout", slot)
        end)
        if not ok then warn("[SwitchToLoadout] failed:", err) end
        task.wait(WAIT_AFTER_SWITCH)
    end
end

--========================
-- ActivePetUI Helpers (pakai Data.LocalPlayer)
--========================
local function getScroller()
    local lp = Data.LocalPlayer
    if not lp then return end
    local pg  = lp.PlayerGui:FindFirstChild("ActivePetUI")
    local fr  = pg and pg:FindFirstChild("Frame")
    local mn  = fr and fr:FindFirstChild("Main")
    local pd  = mn and mn:FindFirstChild("PetDisplay")
    local scr = pd and pd:FindFirstChild("ScrollingFrame")
    return scr
end

local function getPetFrameByUUID(uuid)
    local scr = getScroller()
    if not scr then return nil end
    return scr:FindFirstChild(uuid)
end

local function getPetAgeByUUID(uuid)
    local fr = getPetFrameByUUID(uuid)
    local lab = fr and fr:FindFirstChild("Main") and fr.Main:FindFirstChild("PET_AGE")
    local txt = lab and lab.Text or ""
    local num = tonumber((txt:match("(%d+)"))) or tonumber(txt) or 0
    return num
end

local function getPetNameByUUID(uuid)
    local fr = getPetFrameByUUID(uuid)
    local lab = fr and fr:FindFirstChild("Main") and fr.Main:FindFirstChild("PET_TYPE")
    return lab and lab.Text or ""
end

--========================
-- Machine "Ready" Finder
--========================
local cachedTimerTextLabel = nil

local function findTimerTextLabel_direct()
    local npcs = workspace:FindFirstChild("NPCS") or workspace:FindFirstChild("NPCs")
    if not npcs then return nil end
    local root = npcs:FindFirstChild("PetMutationMachine")
    if not root then return nil end
    local model = root:FindFirstChild("Model") or root
    for _, d in ipairs(model:GetDescendants()) do
        if d:IsA("TextLabel") and d.Name == "TimerTextLabel" then
            return d
        end
    end
    return nil
end

local function findTimerTextLabel()
    if cachedTimerTextLabel and cachedTimerTextLabel.Parent then
        return cachedTimerTextLabel
    end
    cachedTimerTextLabel = findTimerTextLabel_direct()
    return cachedTimerTextLabel
end

local function machineReady()
    local lab = findTimerTextLabel()
    if not lab then return false end
    local t = (lab.Text or ""):lower()
    return t:find("ready", 1, true) ~= nil
end

local function waitUntilMachineReady(timeout)
    local start = os.clock()
    while true do
        if machineReady() then return true end
        if timeout and (os.clock() - start) > timeout then
            return false
        end
        if Data.AutoMutateRunning == false then
            return false
        end
        task.wait(WAIT_BETWEEN_POLLS)
    end
end

--========================
-- Equip / Pickup Helpers
--========================
local function findToolByUUID(uuid)
    if Backpack then
        for _, it in ipairs(Backpack:GetChildren()) do
            if it:IsA("Tool") then
                local a = it:GetAttribute("PET_UUID")
                if a == uuid or it.Name == uuid then
                    return it
                end
            end
        end
    end
    local char = Humanoid and Humanoid.Parent
    if char then
        for _, it in ipairs(char:GetChildren()) do
            if it:IsA("Tool") then
                local a = it:GetAttribute("PET_UUID")
                if a == uuid or it.Name == uuid then
                    return it
                end
            end
        end
    end
    return nil
end

local function getEquippedPetUUID()
    local char = Humanoid and Humanoid.Parent
    if not char then return nil, nil end
    for _, it in ipairs(char:GetChildren()) do
        if it:IsA("Tool") then
            local a = it:GetAttribute("PET_UUID")
            if typeof(a) == "string" and a ~= "" then
                return a, it
            end
        end
    end
    return nil, nil
end

-- 1) PICKUP ke Backpack (lebih tegas & timeout lebih panjang)
local function pickupPetToBackpack(uuid, timeout)
    timeout = timeout or 10.0

    local tool = findToolByUUID(uuid)
    if tool then
        if tool.Parent == Backpack then
            return true
        end
        -- kalau masih di tangan/char, coba lepas ke Backpack
        if Humanoid then pcall(function() Humanoid:UnequipTools() end) end
    end

    if EquipRE and typeof(EquipRE.FireServer) == "function" then
        pcall(function() EquipRE:FireServer("UnequipPet", uuid) end)
    end

    local t0 = os.clock()
    while (os.clock() - t0) < timeout do
        tool = findToolByUUID(uuid)
        if tool and tool.Parent == Backpack then
            return true
        end
        task.wait(0.1)
    end
    return false
end

-- 2) EQUIP dari Backpack + Remote (lebih robust)
local function ensureEquippedSelectedPet(uuid, timeout)
    timeout = timeout or 10.0

    local okPickup = pickupPetToBackpack(uuid, timeout)
    if not okPickup then
        warn("[Mutation] Pickup gagal/timeout untuk UUID:", uuid)
        -- tetap lanjut, beberapa server langsung mau equip via remote
    end

    if Humanoid then
        pcall(function() Humanoid:UnequipTools() end)
        task.wait(0.4)
    end

    local tool = findToolByUUID(uuid)
    if tool and Humanoid then
        pcall(function() Humanoid:EquipTool(tool) end)
        task.wait(0.4)
    end

    if EquipRE and typeof(EquipRE.FireServer) == "function" and HRP then
        pcall(function() EquipRE:FireServer("EquipPet", uuid, HRP.CFrame) end)
    end

    local t0 = os.clock()
    while (os.clock() - t0) < timeout do
        local euuid = getEquippedPetUUID()
        if euuid == uuid then
            return true
        end
        task.wait(0.3)
    end
    return false
end

--========================
-- Mutation checks
--========================
local desiredcon = nil
local function cleanText(str)
    return (str:gsub("<.->", "")):gsub("^%s+", ""):gsub("%s+$", "")
end

local function onDesir(message)
    if typeof(message) ~= "string" then return end
    local name, mutation = message:match("^(.-)%s+mutated into%s+(.*)$")
    if not mutation then return end
    local cleanName = cleanText(name) or "N/A"
    local HighMutation = cleanText(mutation) or "N/A"
    local cleanMutation = cleanText(mutation):lower()
    for _, kw in ipairs(Data.TargetMutationKeywords or {}) do
        if type(kw) == "string" and kw ~= "" then
            if cleanMutation:find(kw:lower(), 1, true) then
                notify("SUCCESS: "..mutation, "ok")
                if not SendPublicDesired then 
                SendPublicDesired = true
                SendDesired(cleanName, HighMutation)
                end
                StopDesired()
                return
            end
        end
    end
    notify("NOT MATCH: "..mutation, "warn")
end





--========================
-- Core Steps (ORDER FIXED)
--========================
local function waitAgeAtLeast(uuid, minAge)
    notify(("Waiting pet to reach Age %d"):format(minAge))
    while true do
        local age = getPetAgeByUUID(uuid) or 0
        if age >= minAge then
            notify(("Age Reach: %d"):format(age))
            return true
        end
        if Data.AutoMutateRunning == false then
            return false
        end
        task.wait(WAIT_BETWEEN_POLLS)
    end
end

-- submit+start: ASUMSI sudah equipped oleh ensureEquippedSelectedPet
local function submitHeldAndStartMachine()
    if not Data.AutoMutateRunning then return end
    if not (PetMutateRE and typeof(PetMutateRE.FireServer) == "function") then
        warn("[Mutation] Remote PetMutationMachineService_RE Not Found")
        return false
    end

    local ok1, err1 = pcall(function()
        PetMutateRE:FireServer("SubmitHeldPet")
    end)
    if not ok1 then
        warn("[SubmitHeldPet] failed:", err1)
        return false
    end

    task.wait(WAIT_AFTER_SUBMIT or 0.6)

    local ok2, err2 = pcall(function()
        PetMutateRE:FireServer("StartMachine")
    end)
    if not ok2 then
        warn("[StartMachine] failed:", err2)
        return false
    end

    task.wait((WAIT_AFTER_START or 0.6))

    -- balik ke Slot 1 sesuai requirement
    SwitchToLoadout(1)
    task.wait(1)
    SwitchToLoadout(1)
    notify("Machine started and Switched to Slot 1", "ok")
    return true
end

local function claimWhenReady()
    if not Data.AutoMutateRunning then return end
    local ready = waitUntilMachineReady(MACHINE_READY_TIMEOUT)
    if not ready then
        notify("[Mutation] Timeout waiting for Ready")
        return false
    end
    SendPublicDesired = false
    SwitchToLoadout(2)
    task.wait(1)
    SwitchToLoadout(2)
    local ok, err = pcall(function()
        PetMutateRE:FireServer("ClaimMutatedPet")
    end)
    if not ok then warn("[ClaimMutatedPet] failed:", err) return false end
    notify("Claimed mutated pet")
    return true
end

-- return true bila HARUS STOP (mutasi sesuai)
local function runMutationCycleFor(uuid, displayName)
    displayName = displayName or getPetNameByUUID(uuid)
    if not Data.AutoMutateRunning then return end
    -- 1) Tunggu age >= target
    if not waitAgeAtLeast(uuid, AGE_TARGET) then return false end

    -- 2) Equip
    local okEquip = ensureEquippedSelectedPet(uuid, 10.0)
    if not okEquip then
        warn("[Mutation] Failed Equip:", displayName, " — Cancel submit")
        return false
    end

    -- 3) Submit & Start
    if not submitHeldAndStartMachine() then return false end

    -- 4) Claim
    if not claimWhenReady() then return false end

    -- 5) Hasil mutasi akan terdeteksi lewat NotificationLog (onDesir).
    -- Jadi di sini kita hanya ambil newName untuk logging.
    task.wait(1.0)
    local newName = getPetNameByUUID(uuid)
    if not newName or newName == "" then
        newName = displayName or "Unknown"
    end
    notify("Mutated: "..newName, "ok")

    -- 6) Kalau bukan target → otomatis lanjut re-equip
    -- Kalau target → StopAutoMutate() sudah dipanggil di onDesir.
    task.wait(1.0)
    SwitchToLoadout(3)
    task.wait(6)
    SwitchToLoadout(3)
    task.wait(1.5)
    if Humanoid then pcall(function() Humanoid:UnequipTools() end) end
    local okBack = ensureEquippedSelectedPet(uuid, 10.0)
    if not okBack then
    if not Data.AutoMutateRunning then return end
        warn("[Mutation] Reequip Failed UUID:", uuid)
    else
        notify("Re-equipped original pet to Slot 2", "ok")
    end

    return false
end


--========================
-- Public Runner
--========================
if Data.AutoMutateRunning == nil then Data.AutoMutateRunning = false end
Data.SelectedPetMutat = Data.SelectedPetMutat or nil -- { {Name="", UUID=""} }

function StartAutoMutate()
    if Data.AutoMutateRunning then
        return
    end
    Data.AutoMutateRunning = true
    task.spawn(function()
        notify("AutoMutate started")
        while Data.AutoMutateRunning do
            if not Data.AutoMutateRunning then break end
            local list = Data.SelectedPetMutat
            local didStop = false
            if type(list) == "table" and #list > 0 then
                for _, item in ipairs(list) do
                    if not Data.AutoMutateRunning then break end
                    local uuid = item.UUID or item.Uuid or item.uuid
                    if uuid then
                        local shouldStop = runMutationCycleFor(uuid, item.Name)
                        if shouldStop then
                            didStop = true
                            break
                        end
                        task.wait(1.0)
                    end
                end
            else
                task.wait(2)
            end
            if didStop then break end
            task.wait(1.0)
        end
    end)
end

function StopDesired()
    Data.AutoMutateRunning = false
end

function StopAutoMutate()
    Data.AutoMutateRunning = false
                    if __StatusGUI then
                    __StatusGUI:Destroy()
                    __StatusGUI, __MsgLabel, __TitleLabel, __Pill = nil, nil, nil, nil
                end
end

--========================================================
-- UI: Refresh Pet → Dropdown Pet (Name (n)) → Dropdown Mutasi (multi) → Toggle
--========================================================

-- Containers
Data.PetListDataMid   = Data.PetListDataMid   or {}  -- { {Name, UUID}, ... }
Data.DropdownPetMutat = Data.DropdownPetMutat or {}  -- { "Mimic (1)", "Mimic (2)", ... }
Data.PetByDisplay     = Data.PetByDisplay     or {}  -- map "Mimic (1)" -> {Name, UUID}

-- Daftar mutasi default (bisa kamu override dari luar)
Data.ListPetMutation = Data.ListPetMutation or {
    "Rainbow","Golden","Mega","Tiny","Inverted","Windy","Frozen","Shiny","Shocked", "Luminous", "Glimmering", "Ascended", "Radiant"
}

local function RefreshPetList()
    clear(Data.PetListDataMid)
    clear(Data.DropdownPetMutat)
    clear(Data.PetByDisplay)

    local scr = getScroller()
    if not scr then
        notify("ActivePetUI tidak ditemukan")
        return
    end

    local nameCounts = {}
    for _, obj in ipairs(scr:GetChildren()) do
        if obj:IsA("Frame") and not string.find(obj.Name, "Template") then
            local main = obj:FindFirstChild("Main")
            local petNameLabel = main and main:FindFirstChild("PET_TYPE")
            if petNameLabel and petNameLabel:IsA("TextLabel") then
                local petName = petNameLabel.Text or "Unknown"
                local uuid    = obj.Name

                nameCounts[petName] = (nameCounts[petName] or 0) + 1
                local display = string.format("%s (%d)", petName, nameCounts[petName])

                table.insert(Data.PetListDataMid, { Name = petName, UUID = uuid })
                table.insert(Data.DropdownPetMutat, display)
                Data.PetByDisplay[display] = { Name = petName, UUID = uuid }
            end
        end
    end
end

-- Handle controls (Farm11 assumed exists)
local Spet1 -- dropdown instance (pet)
local SMut1 -- dropdown instance (mutation)

-- Dropdown: Select Pet (display "Name (n)" → backend UUID)
Pet6:AddParagraph ({
    Title = "Information", 
    Content = "1. Slot 1 is for Pet Mutation Time Booster (Golem Etc)\n2. Slot 2 is for Target Pet and Farm EXP\n3. Dont Forget Enable Auto Refresh Age", 
})

Spet1 = Pet6:AddDropdown("Select_pet_mutat", {
    Title = "Select: Pet",
    Description = "Target",
    Values = Data.DropdownPetMutat, -- diisi setelah refresh
    Default = nil,
    Multi = false,
    AllowNull = true,
    Callback = function(display)
        local picked = display and Data.PetByDisplay[display]
        if picked then
            Data.SelectedPetMutat = { { Name = picked.Name, UUID = picked.UUID } }
            notify("Selected: "..picked.Name)
        else
            Data.SelectedPetMutat = nil
        end
    end
})

-- Dropdown: Select Mutation(s) (multi)
SMut1 = Pet6:AddDropdown("Select_mutation_keywords", {
    Title = "Select: Mutation",
    Description = "Desired mutation(s)",
    Values = Data.ListPetMutation,
    Default = nil,
    Multi = true,
    AllowNull = true,
    Callback = function(value)
        Data.TargetMutationKeywords = CVArray(value)
        -- (opsional) tampilkan list yang dipilih di notify/log
        -- local list = {}
        -- for _, v in ipairs(Data.TargetMutationKeywords) do
        --     table.insert(list, tostring(v))
        -- end
        -- notify("Target mutation set: "..table.concat(list, ", "))
    end
})

-- Button: Refresh Pet
Pet6:AddButton({
    Title = "Refresh Pet",
    Callback = function()
        RefreshPetList()
        if Spet1 and typeof(Spet1.SetValues) == "function" then
            Spet1:SetValues(Data.DropdownPetMutat)
            if typeof(Spet1.SetValue) == "function" then
                Spet1:SetValue(nil)
            end
        end
    end
})

-- Toggle: Auto (start/stop full cycle)
Pet6:AddToggle("AutoMutatePet", {
    Title = "Auto Mutation",
    Description = "Mutation Cycle",
    Default = false,
    Callback = function(enabled)
        task.spawn(function()
            if enabled then
                if type(Data.SelectedPetMutat) ~= "table" or #Data.SelectedPetMutat == 0 then
                    notify("Select Pet")
                    return
                end
                desiredcon = Data.NotificationLog.OnClientEvent:Connect(onDesir)
                StartAutoMutate()
            else
                StopAutoMutate()
                if desiredcon then desiredcon:Disconnect() end
                desiredcon = nil
            end
        end)
    end
})

-- === Auto Refresh Age (aman dari nil / path berubah) ===
Data.AutoOpenPet = false

Pet6:AddToggle("ARAPAG", {
    Title = "Auto Refresh Age",
    Description = "Pet Age",
    Default = false,
    Callback = function(Value)
        if Value then
            if Data.AutoOpenPet then return end
            Data.AutoOpenPet = true

            local Players = game:GetService("Players")
            local LocalPlayer = Players.LocalPlayer
            local GuiService = Data.GuiService
            local VIM = Data.VirtualInputManager

            GuiService.AutoSelectGuiEnabled = false
            GuiService.SelectedObject = nil

            -- Cari tombol SENSOR secara aman (tanpa indexing ke nil)
            local function getSensorButton()
                -- PlayerGui bisa saja belum ada
                local pg = LocalPlayer and LocalPlayer:FindFirstChildOfClass("PlayerGui")
                if not pg then return nil end

                -- UI root
                local ui = pg:FindFirstChild("ActivePetUI")
                if not ui then return nil end

                -- Coba jalur umum dulu
                local frame = ui:FindFirstChild("Frame") or ui:FindFirstChildWhichIsA("Frame")
                local opener

                if frame then
                    opener = frame:FindFirstChild("Opener")
                    if not opener then
                        local main = frame:FindFirstChild("Main")
                        if main then
                            opener = main:FindFirstChild("Opener")
                        end
                    end
                end

                -- Ambil SENSOR di bawah opener jika ada
                local sensor
                if opener then
                    sensor = opener:FindFirstChild("SENSOR") or opener:FindFirstChild("Sensor")
                end

                -- Fallback: cari rekursif di seluruh ActivePetUI (kalau struktur berubah)
                if not sensor then
                    sensor = ui:FindFirstChild("SENSOR", true) or ui:FindFirstChild("Sensor", true)
                end

                -- Pastikan benar TextButton & masih ada di hirarki GUI
                if sensor and sensor:IsA("TextButton") and sensor:IsDescendantOf(pg) then
                    return sensor
                end
                return nil
            end

            task.spawn(function()
                while Data.AutoOpenPet do
                    local obj = getSensorButton()
                    if obj and obj.Visible and obj.Active then
                        GuiService.SelectedObject = obj
                        VIM:SendKeyEvent(true, Enum.KeyCode.Return, false, game)
                        VIM:SendKeyEvent(false, Enum.KeyCode.Return, false, game)
                    end
                    task.wait(3) -- jeda pendek biar ringan
                end
                -- cleanup saat toggle dimatikan
                GuiService.SelectedObject = nil
            end)

        else
            -- Matikan fitur
            Data.AutoOpenPet = false
            Data.GuiService.SelectedObject = nil
        end
    end
})


-- Auto-refresh awal supaya dropdown keisi
task.defer(function()
    RefreshPetList()
    if Spet1 and typeof(Spet1.SetValues) == "function" then
        Spet1:SetValues(Data.DropdownPetMutat)
        if typeof(Spet1.SetValue) == "function" then
            Spet1:SetValue(nil)
        end
    end
    if SMut1 and typeof(SMut1.SetValues) == "function" then
        SMut1:SetValues(Data.ListPetMutation)
    end
end)





local Shp1 = Tab5:AddSection("Event Shop")
Shp1:AddDropdown("SZSHP", {
Title = "Select: Fall Seed",
Description = "Target Item",
Values = Data.FallSeed, 
Multi = true, 
AllowNull = true, 
Callback = function(Value)
        if Value and Value[SELECT_ALL] then
            Data.SelectedEvent = CloneTable(Data.FallGear)
        else
            Data.SelectedEvent = CVArray(Value) or {}
        end
end
})

local AutoBHon = false 
Shp1:AddToggle("ABESSI",{
Title = "Buy Fall Seed",
Description = "Auto Buy",
Default = false,
Callback = function(Value)     
        if Value then
            if AutoBHon then return end
            AutoBHon = true
        local soundService = game:GetService("SoundService").Notification
        local notifFrame = game:GetService("Players").LocalPlayer.PlayerGui.Top_Notification.Frame
            notifFrame.Visible = false
            soundService.Volume = 0
            task.spawn(function()
                 while AutoBHon do
                    for _, item in pairs(Data.SelectedEvent) do
                        game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyEventShopStock"):FireServer(tostring(item), 1)
                        task.wait(0.1)
                    end
                    task.wait(math.random(1, 2))
                end
            end) 
        else
        AutoBHon = false
        local soundService = game:GetService("SoundService").Notification
        local notifFrame = game:GetService("Players").LocalPlayer.PlayerGui.Top_Notification.Frame
            notifFrame.Visible = true
            soundService.Volume = 0.5
        end
end
})

Shp1:AddDropdown("select_fallgear", {
Title = "Select: Fall Gear",
Description = "Target Item",
Values = Data.FallGear, 
Multi = true, 
AllowNull = true, 
Callback = function(Value)
        if Value and Value[SELECT_ALL] then
            Data.SelectedEvent = CloneTable(Data.FallGear)
        else
            Data.SelectedEvent = CVArray(Value) or {}
        end
end
})

local AutoBHon2 = false 
Shp1:AddToggle("fall_gear",{
Title = "Buy Fall Gear",
Description = "Auto Buy",
Default = false,
Callback = function(Value)     
        if Value then
            if AutoBHon2 then return end
            AutoBHon2 = true
        local soundService = game:GetService("SoundService").Notification
        local notifFrame = game:GetService("Players").LocalPlayer.PlayerGui.Top_Notification.Frame
            notifFrame.Visible = false
            soundService.Volume = 0
            task.spawn(function()
                 while AutoBHon2 do
                    for _, item in pairs(Data.SelectedEvent) do
                        game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyEventShopStock"):FireServer(tostring(item), 2)
                        task.wait(0.1)
                    end
                    task.wait(math.random(1, 2))
                end
            end) 
        else
        AutoBHon2 = false
        local soundService = game:GetService("SoundService").Notification
        local notifFrame = game:GetService("Players").LocalPlayer.PlayerGui.Top_Notification.Frame
            notifFrame.Visible = true
            soundService.Volume = 0.5
        end
end
})

Shp1:AddDropdown("select_fallpet", {
Title = "Select: Fall Pet",
Description = "Target Item",
Values = Data.FallPet, 
Multi = true, 
AllowNull = true, 
Callback = function(Value)
        if Value and Value[SELECT_ALL] then
            Data.SelectedEvent = CloneTable(Data.FallPet)
        else
            Data.SelectedEvent = CVArray(Value) or {}
        end
end
})

local AutoBHon3 = false 
Shp1:AddToggle("fall_pet",{
Title = "Buy Fall Pet",
Description = "Auto Buy",
Default = false,
Callback = function(Value)     
        if Value then
            if AutoBHon3 then return end
            AutoBHon3 = true
        local soundService = game:GetService("SoundService").Notification
        local notifFrame = game:GetService("Players").LocalPlayer.PlayerGui.Top_Notification.Frame
            notifFrame.Visible = false
            soundService.Volume = 0
            task.spawn(function()
                 while AutoBHon3 do
                    for _, item in pairs(Data.SelectedEvent) do
                        game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyEventShopStock"):FireServer(tostring(item), 3)
                        task.wait(0.1)
                    end
                    task.wait(math.random(1, 2))
                end
            end) 
        else
        AutoBHon3 = false
        local soundService = game:GetService("SoundService").Notification
        local notifFrame = game:GetService("Players").LocalPlayer.PlayerGui.Top_Notification.Frame
            notifFrame.Visible = true
            soundService.Volume = 0.5
        end
end
})

  

Shp1:AddDropdown("select_fallcosme", {
Title = "Select: Fall Cosmetic",
Description = "Target Item",
Values = Data.FallCosmetic, 
Multi = true, 
AllowNull = true, 
Callback = function(Value)
        if Value and Value[SELECT_ALL] then
            Data.SelectedEvent = CloneTable(Data.FallCosmetic)
        else
            Data.SelectedEvent = CVArray(Value) or {}
        end
end
})

local AutoBHon4 = false 
Shp1:AddToggle("fall_cosmetic",{
Title = "Buy Fall Cosmetic",
Description = "Auto Buy",
Default = false,
Callback = function(Value)     
        if Value then
            if AutoBHon4 then return end
            AutoBHon4 = true
        local soundService = game:GetService("SoundService").Notification
        local notifFrame = game:GetService("Players").LocalPlayer.PlayerGui.Top_Notification.Frame
            notifFrame.Visible = false
            soundService.Volume = 0
            task.spawn(function()
                 while AutoBHon4 do
                    for _, item in pairs(Data.SelectedEvent) do
                        game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuyEventShopStock"):FireServer(tostring(item), 4)
                        task.wait(0.1)
                    end
                    task.wait(math.random(1, 2))
                end
            end) 
        else
        AutoBHon4 = false
        local soundService = game:GetService("SoundService").Notification
        local notifFrame = game:GetService("Players").LocalPlayer.PlayerGui.Top_Notification.Frame
            notifFrame.Visible = true
            soundService.Volume = 0.5
        end
end
})    



local Shp2 = Tab5:AddSection("Seed Shop")
Shp2:AddDropdown("SSSHP", {
    Title = "Seed Tier 1",
    Description = "Target Seed",
    Values = Data.SeedList,  -- sudah termasuk "Select All"
    Multi = true,
    AllowNull = true,
    Callback = function(Value)  -- Value adalah dictionary
        if Value and Value[SELECT_ALL] then
            Data.SelectedSeed = CloneTable(Data.SeedList)
        else
            Data.SelectedSeed = CVArray(Value) or {}
        end
    end
})


local SeedAuto = false
Shp2:AddToggle("ABSSS",{
Title = "Buy Tier 1",
Description = "Auto Buy",
Default = false,
Callback = function(Value)
if Value then
    if SeedAuto then return end
    SeedAuto = true
    task.spawn(function()
     while SeedAuto do
    for i = 1,10 do
    for _, item in pairs(Data.SelectedSeed) do
    game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuySeedStock"):FireServer("Tier 1", tostring(item))
    task.wait(0.01) 
    end
    task.wait(0.01) 
    end
    task.wait(3)
    end
end)
else
    SeedAuto = false
end
end
})

Shp2:AddDropdown("SSSHP", {
    Title = "Seed Tier 2",
    Description = "Target Seed",
    Values = Data.SeedTier2,  -- sudah termasuk "Select All"
    Multi = true,
    AllowNull = true,
    Callback = function(Value)  -- Value adalah dictionary
        if Value and Value[SELECT_ALL] then
            Data.SelectedSeed2 = CloneTable(Data.SeedTier2)
        else
            Data.SelectedSeed2 = CVArray(Value) or {}
        end
    end
})


local SeedAuto2 = false
Shp2:AddToggle("ABSSS",{
Title = "Buy Tier 2",
Description = "Auto Buy",
Default = false,
Callback = function(Value)
if Value then
    if SeedAuto2 then return end
    SeedAuto2 = true
    task.spawn(function()
     while SeedAuto2 do
    for i = 1,10 do
    for _, item in pairs(Data.SelectedSeed2) do
    game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("BuySeedStock"):FireServer("Tier 2", tostring(item))
    task.wait(0.01) 
    end
    task.wait(0.01) 
    end
    task.wait(3)
    end
end)
else
    SeedAuto2 = false
end
end
})


local Shp3 = Tab5:AddSection("Gear Shop")
Shp3:AddDropdown("SGSHPPP", {
Title = "Select: Gear Shop",
Description = "Target Gear",
Values = Data.GearList, 
Multi = true, 
AllowNull = true, 
Callback = function(Value)
        if Value and Value[SELECT_ALL] then
            Data.SelectedGear = CloneTable(Data.GearList)
        else
            Data.SelectedGear = CVArray(Value) or {}
        end
end
})

local GearAuto = false
Shp3:AddToggle("ABGSGAAA",{
Title = "Auto Buy Gear",
Description = "Selected Gear",
Default = false,
Callback = function(Value)
if Value then
    if GearAuto then return end
    GearAuto = true
    task.spawn(function()
     while GearAuto do
    for i = 1,10 do
    for _, item in pairs(Data.SelectedGear) do
    BuyGear(item)
    task.wait() 
    end
    task.wait() 
    end
    task.wait(math.random(3, 5))
    end
end)
else
    GearAuto = false
end
end
})

local Shp4 = Tab5:AddSection("Egg Shop")
Shp4:AddDropdown("SGSHPPJK", {
Title = "Select: Egg Shop",
Description = "Target Egg",
Values = Data.EggList, 
Multi = true, 
AllowNull = true, 
Callback = function(Value)
Data.SelectedEgg = CVArray(Value)
        if Value and Value[SELECT_ALL] then
            Data.SelectedEgg = CloneTable(Data.EggList)
        else
            Data.SelectedEgg = CVArray(Value) or {}
        end
end
})

local EggAuto = false
Shp4:AddToggle("ABEGGSGZ",{
Title = "Auto Buy Egg",
Description = "Selected Egg",
Default = false,
Callback = function(Value)
if Value then
    if EggAuto then return end
        EggAuto = true
        task.spawn(function()
             while EggAuto do
            for jg = 1, 5 do
               for _, v in pairs(Data.SelectedEgg) do
               Data.GameEvents.BuyPetEgg:FireServer(_)
               end
               task.wait()
               end
               task.wait(math.random(1, 5)) 
               end
            end)
    else 
    EggAuto = false
    end
end
})

local epetrun = false
local Esp1 = Tab6:AddSection("ESP Pet Snip")
Esp1:AddToggle("ESPPET",{
Title = "Pet Snip",
Description = "Check Pet Name Inside Ready Hatch Egg",
Default = false,
Callback = function(Value)
if Value then
    if epetrun then return end
    epetrun = true
    EspBool = true
    checkPet()
    else
    epetrun = false
    EspBool = false
    checkPet()
    end
end
})


local petAddedConnection = nil
local espcdrun = false
local Esp2 = Tab6:AddSection("Cooldown Pet ESP")
Esp2:AddToggle("ESPCDPT", {
    Title = "Enable ESP",
    Description = "Cooldown Pet ESP",
    Default = false,
    Callback = function(Value)
        if Value then
        if espcdrun then return end
        epscdrun = true
            getgenv().PetESP = true

            -- Services and refs
            local Players = Data and Data.Players or game:GetService("Players")
            local ReplicatedStorage = Data and Data.ReplicatedStorage or game:GetService("ReplicatedStorage")
            local lp = (Data and Data.LocalPlayer) or Players.LocalPlayer
            local PetsPhysical = workspace:WaitForChild("PetsPhysical")
            local GetCooldown = ReplicatedStorage.GameEvents:WaitForChild("GetPetCooldown")

            -- Ensure folder
            local old = game.CoreGui:FindFirstChild("PetESP")
            if old then old:Destroy() end
            local ESPFolder = Instance.new("Folder")
            ESPFolder.Name = "PetESP"
            ESPFolder.Parent = game.CoreGui

            -- State maps
            local CooldownMap = {}  -- [uuid] = { EndTime = t, Expired = false }
            local ESPMap = {}       -- [part] = { Label = TextLabel, UUID = uuid }

            -- Helper: owner check
            local function isOwned(part)
                local owner = part:GetAttribute("OWNER")
                local me = lp and lp.Name
                return owner == me
            end

            -- Helper: collect all owned UUIDs in world
            local function collectOwnedUUIDs()
                local uuids = {}
                for _, part in ipairs(PetsPhysical:GetChildren()) do
                    if part:IsA("Part") and isOwned(part) then
                        local u = part:GetAttribute("UUID")
                        if u then uuids[#uuids+1] = u end
                    end
                end
                return uuids
            end

            -- Cooldown fetch
            local function UpdateCooldownData()
                local UUIDs = collectOwnedUUIDs()
                for _, uuid in ipairs(UUIDs) do
                    local ok, result = pcall(function()
                        return GetCooldown:InvokeServer(uuid)
                    end)
                    if ok and result and result[1] then
                        for key, value in pairs(result[1]) do
                            if string.find(key, "Time") and type(value) == "number" then
                                CooldownMap[uuid] = {
                                    EndTime = os.time() + math.floor(value),
                                    Expired = false
                                }
                            end
                        end
                    end
                end
            end

            -- Create one ESP label on a part
            local function CreateESP(part, uuid)
                local billboard = Instance.new("BillboardGui")
                billboard.Name = "ESP_" .. uuid
                billboard.Adornee = part
                billboard.AlwaysOnTop = true
                billboard.Size = UDim2.new(0, 120, 0, 40)
                billboard.StudsOffset = Vector3.new(0, 2, 0)
                billboard.Parent = ESPFolder

                local label = Instance.new("TextLabel")
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.fromRGB(255, 255, 0)
                label.TextStrokeColor3 = Color3.fromRGB(255, 255, 200)
                label.TextStrokeTransparency = 0.2
                label.TextScaled = false
                label.TextSize = 15
                label.Font = Enum.Font.GothamBold
                label.Text = "..."
                label.Parent = billboard

                return label
            end

            -- Build ESP for owned pets only
            local function InitESP()
                for _, part in ipairs(PetsPhysical:GetChildren()) do
                    if part:IsA("Part") and not ESPMap[part] and isOwned(part) then
                        local uuid = part:GetAttribute("UUID")
                        if uuid then
                            local label = CreateESP(part, uuid)
                            ESPMap[part] = { Label = label, UUID = uuid }
                        end
                    end
                end
            end

            -- Update labels and prune invalid entries
            local function RefreshESP()
                for part, data in pairs(ESPMap) do
                    if not part.Parent or not isOwned(part) then
                        if data.Label and data.Label.Parent then
                            data.Label.Parent:Destroy()
                        end
                        ESPMap[part] = nil
                    else
                        local info = CooldownMap[data.UUID]
                        if info and type(info) == "table" and info.EndTime then
                            local remaining = math.max(0, info.EndTime - os.time())
                            if remaining <= 0 and not info.Expired then
                                info.Expired = true
                                     local ok, result = pcall(function()
                                        return GetCooldown:InvokeServer(data.UUID)
                                    end)
                                    if ok and result and result[1] then
                                        for key, val in pairs(result[1]) do
                                            if string.find(key, "Time") and type(val) == "number" then
                                                CooldownMap[data.UUID] = {
                                                    EndTime = os.time() + math.floor(val),
                                                    Expired = false
                                                }
                                            end
                                        end
                                    end
                                
                            end

                            if remaining > 0 then
                                local mins = math.floor(remaining / 60)
                                local secs = remaining % 60
                                data.Label.Text = "[Timer] " .. mins .. "m : " .. secs .. "s"
                            else
                                data.Label.Text = "Ready"
                            end
                        else
                            data.Label.Text = "Ready"
                        end
                    end
                end
            end

            -- Main loop
                 while getgenv().PetESP do
                    pcall(UpdateCooldownData)
                    InitESP()
                    for i = 1, 300 do
                        if not getgenv().PetESP then break end
                        RefreshESP()
                        task.wait(1)
                    end
                end
            

            -- ChildAdded hook (owned-only)
            petAddedConnection = PetsPhysical.ChildAdded:Connect(function(child)
                task.wait(0.2)
                if not getgenv().PetESP then return end
                if child:IsA("Part") and not ESPMap[child] and isOwned(child) then
                    local uuid = child:GetAttribute("UUID")
                    if uuid then
                        local label = CreateESP(child, uuid)
                        ESPMap[child] = { Label = label, UUID = uuid }
                    end
                end
            end)

        else
            espcdrun = false
            -- Disable
            getgenv().PetESP = false

            local folder = game.CoreGui:FindFirstChild("PetESP")
            if folder then folder:Destroy() end

            if petAddedConnection then
                petAddedConnection:Disconnect()
                petAddedConnection = nil
            end
        end
    end
})


local Esp3 = Tab6:AddSection("Fruit ESP")
Esp3:AddDropdown("FFTF", {
Title = "Filter: Fruit",
Description = "Target Fruit",
Values = Data.FruitList, 
Multi = true, 
AllowNull = true, 
Callback = function(Value)
        if Value and Value[SELECT_ALL] then
            Data.SelectedFPlant = CloneTable(Data.FruitList)
        else
            Data.SelectedFPlant = CVArray(Value) or {}
        end
end
})

Esp3:AddDropdown("FMFTF", {
Title = "Filter: Mutation Fruit",
Description = "Target Fruit",
Values = Data.ListMutation, 
Multi = true, 
AllowNull = true, 
Callback = function(Value)
        if Value and Value[SELECT_ALL] then
            Data.SelectedFMuta = CloneTable(Data.ListMutation)
        else
            Data.SelectedFMuta = CVArray(Value) or {}
        end
end
})

Esp3:AddInput("FWKG4",{
Title = "Filter: Weight",
Description = "Show Fruit Above This KG",
Placeholder = "50",
Numeric = true,
Finished = false,
Callback = function(Value)
Data.MaxFWeight = tonumber(Value)
end
})

local fruitAddedConnection = nil
local fesprun = false
Esp3:AddToggle("EFESPS",{
Title = "Enable Fruit Esp",
Description = "Show Selected Fruit Esp",
Default = false,
Callback = function(Value)
 local MyFarm = GetFarm()
        if not MyFarm then return end

        local MyPlant = MyFarm:FindFirstChild("Important")
        if not MyPlant then return end
        MyPlant = MyPlant:FindFirstChild("Plants_Physical")
        if not MyPlant then return end

        local function CreateFruitESP(obj)
            if obj:FindFirstChild("FruitESP") then return end

            local weight = obj:FindFirstChild("Weight")
            if not weight then return end

            local fruitName = obj.Name
            local value = Calplantvalue(obj)
            local roundedWeight = math.round(weight.Value)

            if Data.SelectedFPlant and #Data.SelectedFPlant > 0 and not table.find(Data.SelectedFPlant, fruitName) then
                return
            end

            if Data.SelectedFMuta and #Data.SelectedFMuta > 0 then
                local matched = false
                for _, mut in ipairs(Data.MutationHandler:GetPlantMutations(obj)) do
                    if table.find(Data.SelectedFMuta, mut.Name) then
                        matched = true
                        break
                    end
                end
                if not matched then return end
            end

            if MaxFWeight and MaxFWeight > 0 and roundedWeight < MaxFWeight then
                return
            end

            local esp = Instance.new("BillboardGui")
            esp.Name = "FruitESP"
            esp.Size = UDim2.new(0, 80, 0, 30)
            esp.StudsOffset = Vector3.new(0, 2, 0)
            esp.AlwaysOnTop = true
            esp.Adornee = obj
            esp.Parent = obj

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(1, 0, 1, 0)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.fromRGB(255, 255, 0)
            label.TextStrokeColor3 = Color3.fromRGB(255, 255, 200)
            label.TextStrokeTransparency = 0.2
            label.TextScaled = false
            label.TextSize = 15
            label.Font = Enum.Font.GothamBold
            label.Text = fruitName .. " - " .. roundedWeight .. "KG - $" .. value
            label.Parent = esp
        end

        if Value then
        if fesprun then return end
        fesprun = true
            for _, plant in ipairs(MyPlant:GetChildren()) do
                local fruitsFolder = plant:FindFirstChild("Fruits")
                if fruitsFolder then
                    for _, fruit in ipairs(fruitsFolder:GetChildren()) do
                        CreateFruitESP(fruit)
                    end
                end
            end

            if fruitAddedConnection then fruitAddedConnection:Disconnect() end
            fruitAddedConnection = MyPlant.ChildAdded:Connect(function(plant)
                local fruitsFolder = plant:WaitForChild("Fruits", 2)
                if fruitsFolder then
                    for _, fruit in ipairs(fruitsFolder:GetChildren()) do
                        CreateFruitESP(fruit)
                    end
                    fruitsFolder.ChildAdded:Connect(function(fruit)
                        task.wait(0.1)
                        CreateFruitESP(fruit)
                    end)
                end
            end)

        else
            fesprun = false
            if fruitAddedConnection then
                fruitAddedConnection:Disconnect()
                fruitAddedConnection = nil
            end

            for _, plant in ipairs(MyPlant:GetChildren()) do
                local fruitsFolder = plant:FindFirstChild("Fruits")
                if fruitsFolder then
                    for _, fruit in ipairs(fruitsFolder:GetChildren()) do
                        local esp = fruit:FindFirstChild("FruitESP")
                        if esp then esp:Destroy() end
                    end
                end
            end
        end
    end
})


local evnrun = false
local Dlg1 = Tab6:AddSection("Show Dialog UI")
Dlg1:AddToggle("SZSUI",{
Title = "Fairy Shop UI",
Description = "Show Fairy Shop UI",
Default = false,
Callback = function(Value)
local asv = game:GetService("Players").LocalPlayer.PlayerGui.EventShop_UI
    if Value then
    if evnrun then return end
    evnrun = true
    asv.Enabled = true
    else
    evnrun = false
    asv.Enabled = false
    end
end
})

local stmrun = false
Dlg1:AddToggle("STMUI",{
Title = "Traveling Merchant UI",
Description = "Show Traveling Merchant UI",
Default = false,
Callback = function(Value)
local asv = game:GetService("Players").LocalPlayer.PlayerGui.TravelingMerchantShop_UI
    if Value then
    if stmrun then return end
    stmrun = true
    asv.Enabled = true
    else
    stmrun = false
    asv.Enabled = false
    end
end
})

local sptrun = false
Dlg1:AddToggle("SPTUI",{
Title = "Pet Shop UI",
Description = "Show Pet Shop UI",
Default = false,
Callback = function(Value)
local asv = game:GetService("Players").LocalPlayer.PlayerGui.PetShop_UI
    if Value then
    if sptrun then return end
    sptrun = true
    asv.Enabled = true
    else
    sptrun = false
    asv.Enabled = false
    end
end
})

local sdsrun = false
Dlg1:AddToggle("SDSUI",{
Title = "Seed Shop UI",
Description = "Show Seed Shop UI",
Default = false,
Callback = function(Value)
local asv = game:GetService("Players").LocalPlayer.PlayerGui.Seed_Shop
    if Value then
    if sdsrun then return end
    sdsrun = true
    asv.Enabled = true
    else
    sdsrun = false
    asv.Enabled = false
    end
end
})

local sgrrun = false
Dlg1:AddToggle("SGRSUI",{
Title = "Gear Shop UI",
Description = "Show Gear Shop UI",
Default = false,
Callback = function(Value)
local asv = game:GetService("Players").LocalPlayer.PlayerGui.Gear_Shop
    if Value then
    if sgrrun then return end
    sgrrun = true
    asv.Enabled = true
    else
    sgrrun = false
    asv.Enabled = false
    end
end
})

local dqurun = false
Dlg1:AddToggle("DQUIS",{
Title = "Daily Quest UI",
Description = "Show Daily Quest UI",
Default = false,
Callback = function(Value)
local asv = game:GetService("Players").LocalPlayer.PlayerGui.DailyQuests_UI
    if Value then
    if dqurun then return end
    dqurun = true
    asv.Enabled = true
    else
    dqurun = false
    asv.Enabled = false
    end
end
})

local supsrun = false
Dlg1:AddToggle("SUPSUI",{
Title = "Upgrade Pet Slot UI",
Description = "Show Upgrade Pet Slot UI",
Default = false,
Callback = function(Value)
local asv = game:GetService("Players").LocalPlayer.PlayerGui.PetEquipSlots_UI
    if Value then
    if susprun then return end
    susprun = true
    asv.Enabled = true
    else
    susprun = false
    asv.Enabled = false
    end
end
})

local cosrun = false
Dlg1:AddToggle("COSMUI",{
Title = "Cosmetic Shop UI",
Description = "Show Cosmetic Shop UI",
Default = false,
Callback = function(Value)
local asv = game:GetService("Players").LocalPlayer.PlayerGui.CosmeticShop_UI
    if Value then
    if cosrun then return end
    cosrun = true
    asv.Enabled = true
    else
    cosrun = false
    asv.Enabled = false
    end
end
})


local Tp1 = Tab8:AddSection("Teleport Event")
Tp1:AddButton({
Title = "Event Teleport", 
Callback = function()
Teleport(CFrame.new(-101.005455, 4.000012, -8.197269))
end
})

local Tp2 = Tab8:AddSection("Teleport Sell NPC")
Tp2:AddButton({
Title = "Sell NPC Teleport", 
Callback = function()
Teleport(CFrame.new(86.58, 3.00, 0.43)) 
end
})

local Tp3 = Tab8:AddSection("Teleport Seed NPC")
Tp3:AddButton({
Title = "Seed NPC Teleport", 
Callback = function()
Teleport(CFrame.new(86.59, 3.00, -27.00))
end
})

local Tp4 = Tab8:AddSection("Teleport Gear NPC")
Tp4:AddButton({
Title = "Gear NPC Teleport", 
Callback = function()
Teleport(CFrame.new(-286.93, 3.00, -33.03))
end
})

local Tp5 = Tab8:AddSection("Teleport Cosmetic NPC")
Tp5:AddButton({
Title = "Cosmetic NPC Teleport", 
Callback = function()
Teleport(CFrame.new(-287.01, 3.00, -14.90))
end
})

local Tp6 = Tab8:AddSection("Teleport Egg NPC")
Tp6:AddButton({
Title = "Egg NPC Teleport", 
Callback = function()
Teleport(CFrame.new(-283.60, 3.00, 3.51))
end
})

local Vuln3 = Tab7:AddSection("Instant Hatch Egg")
Data.RejoinDelaySec = 5
Data.SellPauseSec = 5
local MaxEggSlotIH = 3

--==================================================
-- INSTANT HATCH CYCLE (Place -> Rejoin until ready -> Hatch -> (pause AutoSP) -> Place -> Rejoin -> repeat)
-- Semua filter: Data.SelectedHatchPetIH
-- Pemilihan tool place: FindMatchingEgg() (milikmu)
-- Gunakan MaxEggSlotIH untuk batas slot telur di farm (bukan MaxEggSlot)
--==================================================

-- ===== Konfigurasi kecil (boleh diubah) =====
local IH_WAIT_SEC            = 3.0   -- tunggu SelectedHatchPetIH saat awal load
local PLACE_RETRY_ATTEMPTS   = 6     -- berapa kali ensure place sebelum rejoin/stop
local PLACE_RETRY_SLEEP_SEC  = 0.35  -- jeda antar attempt place
local SEND_NOTIF_HATCH = false
-- ===== Helpers umum =====
local function GetRejoinDelaySec()
    local v = tonumber(Data and Data.RejoinDelaySec)
    if not v or v < 0 then v = 0 end
    return v
end

local function SleepCancelable(sec, runningFlagGetter)
    local t0 = tick()
    while (tick() - t0) < sec do
        if not runningFlagGetter() then return false end
        task.wait(0.1)
    end
    return true
end

-- jeda khusus untuk AutoSP (auto-sell) setelah HATCH
local function GetSellPauseSec()
    local v = tonumber(Data and Data.SellPauseSec)
    if not v or v < 0 then v = 0 end
    return v
end

local function MaybePauseForAutoSell(getRunningFlag)
    local sec = GetSellPauseSec()
    if sec > 0 and AutoSP then
        if NotifyHub then NotifyHub(("Pausing %.1fs for auto-sell..."):format(sec)) end
        SleepCancelable(sec, getRunningFlag)
    end
end

-- tunggu SelectedHatchPetIH saat awal load
local function WaitForIHReady(maxWait)
    maxWait = tonumber(maxWait) or IH_WAIT_SEC
    local deadline = tick() + maxWait
    while tick() < deadline do
        if Data and Data.SelectedHatchPetIH ~= nil then
            return true
        end
        task.wait(0.1)
    end
    return (Data and Data.SelectedHatchPetIH ~= nil)
end

-- ===== Deteksi & Counter =====
local function LooksLikeEggTool(tool)
    if not (tool and tool:IsA("Tool")) then return false end
    local name = string.lower(tool.Name or "")
    if string.find(name, "egg", 1, true) then return true end
    local filters = Data.SelectedHatchPetIH
    if type(filters) == "table" and #filters > 0 then
        for _, f in ipairs(filters or {}) do
            local pat = string.lower(tostring(f))
            if pat ~= "" and string.find(name, pat, 1, true) then
                return true
            end
        end
    end
    return false
end

local function CountBackpackEggs()
    local bp = Data.Backpack
    if not bp then return 0 end
    local c = 0
    for _, it in ipairs(bp:GetChildren() or {}) do
        if LooksLikeEggTool(it) then c = c + 1 end
    end
    return c
end

local function CountFarmEggs()
    return tonumber(GetEgg()) or 0
end

-- ===== Teleport/Rejoin =====
local function RejoinWithDelay(getRunningFlag)
    local delaySec = GetRejoinDelaySec()
    if delaySec > 0 and NotifyHub then
        NotifyHub(("Rejoining in %.1fs..."):format(delaySec))
    end
    SleepCancelable(delaySec, getRunningFlag)
    game:GetService("TeleportService"):Teleport(game.PlaceId, Data.Players.LocalPlayer)
end

-- ===== Equip & Pos =====
local function EnsureEquipped(tool, timeout)
    timeout = tonumber(timeout) or 1.0
    local lp = Data.Players.LocalPlayer
    local char = Data.Char or lp.Character or lp.CharacterAdded:Wait()
    local t0 = tick()
    while tick() - t0 < timeout do
        if tool.Parent == char then return true end
        task.wait(0.05)
    end
    return tool.Parent == char
end

local function AsVector3(pos)
    local t = typeof(pos)
    if t == "Vector3" then return pos end
    if t == "CFrame"  then return pos.Position end
    local hrp = Data.HRP or ((Data.Char or {}).HumanoidRootPart)
    return hrp and hrp.Position or Vector3.new()
end

-- ===== PLACE (pakai FindMatchingEgg()) =====
-- return: placedCount, ok(bool), farmStart, farmEnd, bagStart, bagEnd, reason
-- reason: "full" | "placed" | "bag_empty" | "no_tool" | "unknown"
local function DoAutoPlace()
    SEND_NOTIF_HATCH = false
    local maxSlot   = tonumber(MaxEggSlotIH) or 0
    local farmStart = CountFarmEggs()
    local bagStart  = CountBackpackEggs()

    if maxSlot <= 0 then
        if NotifyHub then NotifyHub("MaxEggSlotIH is 0. Set it first.") end
        return 0, false, farmStart, farmStart, bagStart, bagStart, "unknown"
    end

    -- jika farm sudah penuh, anggap OK (no-op)
    if farmStart >= maxSlot then
        return 0, true, farmStart, farmStart, bagStart, bagStart, "full"
    end

    local placedThisRun = 0
    local estimatedFarm = farmStart
    local triedTool     = false

    while estimatedFarm < maxSlot do
        if CountBackpackEggs() == 0 then
            return placedThisRun, false, farmStart, CountFarmEggs(), bagStart, CountBackpackEggs(), "bag_empty"
        end

        local tool = FindMatchingEgg()  -- <<< fungsi kamu
        if not tool then
            return placedThisRun, false, farmStart, CountFarmEggs(), bagStart, CountBackpackEggs(), "no_tool"
        end
        triedTool = true

        pcall(function() Data.Humanoid:EquipTool(tool) end)
        if not EnsureEquipped(tool, 1.0) then
            -- gagal equip, hentikan attempt loop ini (nanti di-retry dari ensure)
            break
        end

        local pos = AsVector3(RandomPlace())
        Data.RemotePlace:FireServer("CreateEgg", pos)

        placedThisRun = placedThisRun + 1
        estimatedFarm = estimatedFarm + 1
        task.wait(PLACE_RETRY_SLEEP_SEC)
    end

    local farmEnd = CountFarmEggs()
    local bagEnd  = CountBackpackEggs()
    local ok = (farmEnd > farmStart) or (bagEnd < bagStart)
    local reason = ok and "placed" or (triedTool and "unknown" or "no_tool")
    return placedThisRun, ok, farmStart, farmEnd, bagStart, bagEnd, reason
end

-- Pastikan ada telur ter-place (atau farm full) sebelum rejoin
-- return: ok(bool), stopReason(nil|"bag_empty"|"place_failed")
local function EnsurePlaceBeforeRejoin(maxAttempts, sleepSec)
    maxAttempts = maxAttempts or PLACE_RETRY_ATTEMPTS
    sleepSec    = sleepSec or PLACE_RETRY_SLEEP_SEC

    for _ = 1, maxAttempts do
        local _, ok, _, _, _, _, reason = DoAutoPlace()
        if ok or reason == "full" then
            return true, nil
        end
        if reason == "bag_empty" then
            return false, "bag_empty"
        end
        if Data.SelectedHatchPetIH == nil then
            if NotifyHub then NotifyHub("Waiting SelectedHatchPetIH to load...") end
            WaitForIHReady(IH_WAIT_SEC)
        end
        task.wait(sleepSec)
    end
    return false, "place_failed"
end

-- ===== READY scan =====
local function CollectReadyEggPrompts()
    local list = {}
    local farm = GetFarm()
    if not farm then return list end

    local imp  = farm:FindFirstChild("Important")
    local objs = imp and imp:FindFirstChild("Objects_Physical")
    if not objs then return list end

    local filters = Data.SelectedHatchPetIH or {}
    local useFilter = (#filters > 0)
    local lfilters = {}
    if useFilter then
        for i, v in ipairs(filters or {}) do
            lfilters[i] = string.lower(tostring(v))
        end
    end

    for _, d in ipairs(objs:GetDescendants() or {}) do
        if d:IsA("ProximityPrompt") and d.Enabled then
            local at = d.ActionText
            if type(at) == "string" and string.find(string.lower(at), "hatch") then
                local holder = d.Parent
                if not useFilter then
                    table.insert(list, {prompt = d, holder = holder})
                else
                    local lname = string.lower((holder and holder.Name) or "")
                    local match = false
                    for _, pat in ipairs(lfilters or {}) do
                        if pat ~= "" and string.find(lname, pat, 1, true) then
                            match = true; break
                        end
                    end
                    if match then
                        table.insert(list, {prompt = d, holder = holder})
                    end
                end
            end
        end
    end
    return list
end

-- ===== HATCH =====
local function DoAutoHatch()
    local items = CollectReadyEggPrompts() or {}
    local hatched = 0
    for _, it in ipairs(items) do
        local holder = it.holder
        local cf
        if holder then
            if holder:IsA("Model") then cf = holder:GetPivot()
            elseif holder:IsA("BasePart") then cf = holder.CFrame end
        end
        if cf then Teleport(cf); task.wait(0.25) end
        pcall(fireproximityprompt, it.prompt)
        hatched = hatched + 1
        task.wait(0.25)
    end
    return hatched
end

-- ===== Controller =====
local EggCycleRunning = false

function StartInstantHatchCycle()
    if EggCycleRunning then
        return
    end
    EggCycleRunning = true
         -- awal start: tunggu IH siap
        if Data.SelectedHatchPetIH == nil then
            if NotifyHub then NotifyHub("Waiting SelectedHatchPetIH to load...") end
            WaitForIHReady(IH_WAIT_SEC)
        end

        while EggCycleRunning do
            local farmEggs  = CountFarmEggs()
            local readyList = CollectReadyEggPrompts()
            local readyCount = #readyList

            -- A) FARM ADA TELUR
            if farmEggs > 0 then
                if readyCount > 0 then
                    -- HATCH
                    local hatched = DoAutoHatch()
                    if NotifyHub then NotifyHub(("Hatched %d egg(s)."):format(hatched)) end
                    task.wait(0.25)

                    -- jeda untuk AutoSP (kalau aktif)
                    MaybePauseForAutoSell(function() return EggCycleRunning end)

                    -- WAJIB place (atau full) sebelum rejoin
                    local okPlace, stopReason = EnsurePlaceBeforeRejoin(PLACE_RETRY_ATTEMPTS, PLACE_RETRY_SLEEP_SEC)
                    if not okPlace then
                        if stopReason == "bag_empty" then
                            if NotifyHub then NotifyHub("Backpack empty after hatch. Stopping cycle.") end
                            EggCycleRunning = false; break
                        else
                            if NotifyHub then NotifyHub("Place after hatch failed, retrying...") end
                            task.wait(0.5)
                            continue
                        end
                    end

                    -- REJOIN
                    if NotifyHub then NotifyHub("Rejoining to continue cycle...") end
                    RejoinWithDelay(function() return EggCycleRunning end)
                    return
                else
                    -- belum ready: jangan place; cukup rejoin
                    if NotifyHub then NotifyHub("Eggs placed but not ready -> Rejoin.") end
                    RejoinWithDelay(function() return EggCycleRunning end)
                    return
                end
            end

            -- B) FARM KOSONG
            if CountBackpackEggs() == 0 then
                if NotifyHub then NotifyHub("No eggs in BACKPACK. Stopping cycle.") end
                EggCycleRunning = false; break
            end

            -- jika IH belum siap, jangan stop; tunggu
            if Data.SelectedHatchPetIH == nil then
                if NotifyHub then NotifyHub("Waiting SelectedHatchPetIH to load...") end
                WaitForIHReady(IH_WAIT_SEC)
            end

            -- Pastikan sudah place minimal 1 (atau full) sebelum rejoin
            local okPlace, stopReason = EnsurePlaceBeforeRejoin(PLACE_RETRY_ATTEMPTS, PLACE_RETRY_SLEEP_SEC)
            if not okPlace then
                if stopReason == "bag_empty" then
                    if NotifyHub then NotifyHub("Backpack empty. Stopping cycle.") end
                    EggCycleRunning = false; break
                else
                    if NotifyHub then NotifyHub("Place failed, retrying...") end
                    task.wait(0.5)
                    continue
                end
            end

            if NotifyHub then NotifyHub("Eggs placed. Rejoining to wait for ready...") end
            RejoinWithDelay(function() return EggCycleRunning end)
            return
        end
    
end

function StopInstantHatchCycle()
    EggCycleRunning = false
end



-- Cara pakai (contoh):
-- Data.RejoinDelaySec = 5  -- detik (set sendiri)
-- StartInstantHatchCycle()


Vuln3:AddParagraph({
    Title = "Instant Hatch Egg Guide", 
    Content = "1. Plant 800 Tree in your garden\n2. Afk for 3-6 hour depend on your selected eegg time (Do it one time only)\n3. Enable Auto Instant Hatch Egg", 
}) 


Vuln3:AddDropdown("SelEggwsdIH", {
Title = "Select: Egg",
Description = "Target",
Values = Data.EggList, 
Multi = true, 
AllowNull = true, 
Callback = function(Value)
if Value and Value[SELECT_ALL] then
    Data.SelectedHatchPetIH = CloneTable(Data.EggList)
else
    Data.SelectedHatchPetIH = CVArray(Value) or {}
end
end
})

Vuln3:AddInput("MXEGGIH",{
Title = "Set: Max Slot Egg",
Description = "In Your Garden",
Placeholder = "3",
Numeric = true,
Finished = false,
Callback = function(Value)
MaxEggSlotIH = tonumber(Value)
end
})

Vuln3:AddInput("IDARJIH",{
Title = "Input: Delay Rejoin",
Description = "Rejoin Speed",
Placeholder = "5",
Numeric = true,
Finished = false,
Callback = function(Value)
Data.RejoinDelaySec = tonumber(Value)
end
})

local aihrun = false
Vuln3:AddToggle("AIHFAA",{
Title = "Auto Instant Hatch",
Description = "Full Auto Hatch",
Default = false,
Callback = function(Value)
if Value then
if aihrun then return end
aihrun = true
task.wait(Data.RejoinDelaySec)
StartInstantHatchCycle()
else
aihrun = false
StopInstantHatchCycle()
end
end
})


local IdleAbl = false
local ZenEv = false
Data.SellMultiX = 1000
local Vuln1 = Tab7:AddSection("Sell Multiplier (Pet)")
Vuln1:AddParagraph({
    Title = "Sell Multiplier (Pet)", 
    Content = "1. You Need 2 Account to Held a Pet\n2. Held a Expensive Pet on Account 1\n3. Held a Cheapest Pet on Account 2 (then enable sell multiplier)", 
}) 

Vuln1:AddSlider("MLTSLL", {
    Title       = "Multiplier: 1000-5000",
    Description = "Cheap Pet Multiplier Value",
    Min         = 1000,      
    Max         = 5000,  
    Default     = 1000,
    Rounding = 0,
    Callback    = function(Value)
    Data.SellMultiX = tonumber(Value) 
    end
})

local asprug = false
Vuln1:AddToggle("ASPMDS", {
Title = "Auto Sell Pet Multiplier",
Description = "Dupe Sheckless",
Default = false,
Callback = function(Value)
if Value then
if asprug then return end
local Players = game:GetService("Players")
for j = 1, Data.SellMultiX do
for _, player in ipairs(Players:GetPlayers()) do
    local charFolder = workspace:FindFirstChild(player.Name)
    if charFolder then
        for _, obj in ipairs(charFolder:GetChildren()) do
            if obj:IsA("Tool") and string.find(obj.Name, "Age") then
            Data.SellPetRE:FireServer(obj)
            end
        end
    end
end
end
else
asprug = false
end
end
})

local Vuln4 = Tab7:AddSection("Nihonzaru Bug")

local Sply3 = Vuln4:AddDropdown("nihon_ply", {
Title = "Select: Player",
Description = "Target Player",
Values = {}, 
Multi = false, 
AllowNull = true, 
Callback = function(Value)
Data.SelectedPLYGP = game.Players:FindFirstChild(tostring(Value))
print("Selected Player:", Data.SelectedPLYGP or "None")
end
})


Vuln4:AddButton({
Title = "Refresh Player", 
Callback = function()
function GetPlayers1()
    local players = {}
    for _, plr in ipairs(game.Players:GetPlayers()) do
        if plr ~= game.Players.LocalPlayer then
            table.insert(players, plr.Name)
        end
    end
    return players
end
Sply3:SetValues(GetPlayers1()) 
Sply3:SetValue(nil) 
end
})

-- ================== AUTO GIFT → EQUIP (Nihon) + TOGGLE CONNECT/DISCONNECT ==================
-- Prasyarat (sudah kamu set sebelumnya):
-- Data.Players, Data.LocalPlayer, Data.Char, Data.Backpack, Data.Humanoid, Data.HRP
-- Data.PetGift     : RemoteEvent (server)  -> :FireServer("GivePet", targetPlayer)
-- Data.EquipPet    : RemoteEvent (client)  -> :FireServer("EquipPet", uuid, CFrame)
-- Data.NotificationLog.OnClientEvent       : RemoteEvent -> notifikasi string
-- Event1:AddToggle                         : UI lib kamu
-- Data.SelectedPLYGP : Player (target gift)

-- ---------- Utils: cari pet Nihon valid di Backpack ----------
-- Cari pet di Character dulu (workspace.LocalPlayer.Character), lalu Backpack.
-- Match nama (needle), attr b=="l", dan bukan favorit (attr d == nil/false).
-- Return: tool(instance), uuid(string) | kalau tidak ada: nil, nil
local function findNihonInBackpack(needle)
    -- kamu bisa set Data.GiftPetNeedle = "moon" misalnya
    needle = string.lower(needle or "nihon")

    local function scan(container)
        if not container then return nil, nil end
        for _, tool in ipairs(container:GetChildren() or {}) do
            if tool:IsA("Tool") then
                local nm = string.lower(tool.Name or "")
                if string.find(nm, needle, 1, true) then
                    local b = tool:GetAttribute("b")
                    local d = tool:GetAttribute("d")
                    if b == "l" and not d then
                        local uuid = tool:GetAttribute("PET_UUID")
                        if uuid then
                            return tool, tostring(uuid)
                        end
                    end
                end
            end
        end
        return nil, nil
    end

    -- 1) Character (workspace.LocalPlayer.Name)
    local chara = workspace:FindFirstChild(Data.LocalPlayer.Name)
    local t, u = scan(chara)
    if t then return t, u end

    -- 2) Backpack
    local bp = Data.Backpack
    t, u = scan(bp)
    if t then return t, u end

    return nil, nil
end


-- ---------- Equip pet berdasarkan UUID di posisi HRP ----------
local function equipByUUID(uuid)
    if not uuid then return false, "no_uuid" end
    if not (Data.EquipPet and typeof(Data.EquipPet.FireServer) == "function") then
        warn("[Equip] Data.EquipPet RemoteEvent tidak siap")
        return false, "no_remote"
    end
    local cf = (Data.HRP and Data.HRP.CFrame) or CFrame.new()
    local ok, err = pcall(function()
        Data.EquipPet:FireServer("EquipPet", tostring(uuid), cf)
    end)
    return ok, err
end

-- ---------- Gift ke player yang dipilih (Data.SelectedPLYGP = Player) ----------
local function giftToSelectedPlayer()
    if not Data.PetGift or typeof(Data.PetGift.FireServer) ~= "function" then
        warn("[Gift] Remote Data.PetGift not ready")
        return false, "no_remote"
    end
    local target = Data.SelectedPLYGP
    if not (target and typeof(target) == "Instance" and target:IsA("Player")) then
        warn("[Gift] Data.SelectedPLYGP not instance of Player")
        return false, "no_target"
    end
    local ok, err = pcall(function()
        local tooltrg, uuidtrg = findNihonInBackpack()
        Data.Humanoid:EquipTool(tooltrg) -- equip Nihon tool
        task.wait(1) -- pastikan Nihon di-equip dulu
        Data.PetGift:FireServer("GivePet", target) -- gift ke player
    end)
    if not ok then warn("[Gift] Gagal GivePet:", err) end
    return ok, err
end

-- ---------- Handler utama saat "trade completed" ----------
local lastHandledAt = 0
local function handleTradeCompleted()
 
    giftToSelectedPlayer()

    task.wait(2)

    local _, uuid = findNihonInBackpack()
    if uuid then
        local okE, errE = equipByUUID(uuid)
        if not okE then
            warn("[Equip] Gagal equip:", errE)
        end
    end
end

-- ---------- Toggle ON/OFF: connect / disconnect ----------
local ashfConn


local function onAshfEvent(message)
    if typeof(message) == "string" and message:lower():find("trade completed", 1, true) then
        handleTradeCompleted()
    end
end

local nihrun = false
Vuln4:AddToggle("nihon_vuln",{
    Title = "Auto Trade",
    Description = "Trade and Equip Nihon",
    Default = false,
    Callback = function(enabled)
        if enabled then
            if nihrun then return end
            nihrun = true
            if ashfConn then ashfConn:Disconnect(); ashfConn = nil end
            if Data.NotificationLog and Data.NotificationLog.OnClientEvent then
                ashfConn = Data.NotificationLog.OnClientEvent:Connect(onAshfEvent)
            else
                warn("[ASHF] Data.NotificationLog.OnClientEvent tidak tersedia")
            end
        else
            nihrun = false
            if ashfConn then
                ashfConn:Disconnect()
                ashfConn = nil
            end
        end
    end
})


Data.Recipe1 = Data.Recipe1 or nil


-- UI section and dropdowns (use unique keys)
local Vuln5 = Tab7:AddSection("Instant Cook")

Vuln5:AddDropdown("rcp1", {
    Title = "Recipe: Select",
    Description = "Fruit",
    Values = Data.FruitList,
    Default = nil,
    Multi = false,
    AllowNull = true,
    Callback = function(Value)
        Data.Recipe1 = Value
    end
})

Data.AutoSHPs = false
Vuln5:AddToggle("ICCPT",{
Title = "Instant Cooking",
Description = "Cooking Pot",
Default = false,
Callback = function(Value)
if Value then
if Data.AutoSHPs then return end
Data.AutoSHPs = true
while Data.AutoSHPs do
for _, item in ipairs(Data.Backpack:GetChildren()) do
if item:GetAttribute("b") == "j" then
EquipFruit(tostring(Data.Recipe1))
task.wait(0.05)
Data.CookingPotService_RE:FireServer("SubmitHeldPlant", "OLD_KITCHEN_COOKING_EVENT")
task.wait(0.05)
Data.CookingPotService_RE:FireServer("CookBest", "OLD_KITCHEN_COOKING_EVENT")
task.wait(0.05)
end
end
task.wait(0.1) 
end
else
Data.AutoSHPs = false
end
end
})

local Vuln6 = Tab7:AddSection("Purchase Premium Egg")
Data.SelectedProduct = nil

local PremiumEggs = {
    "+1 Premium Primal Egg", "+3 Premium Primal Egg", "+10 Premium Primal Egg", "+1 Premium Anti Bee Egg", 
    "+3 Premium Anti Bee Egg", "+10 Premium Anti Bee Egg", "+1 Premium Oasis Egg",
    "+3 Premium Oasis Egg", "+10 Premium Oasis Egg", "10 Premium Night Eggs"
}

Vuln6:AddDropdown("Select_Egg", {
Title = "Select: Premium Egg",
Description = "Target Egg",
Values = PremiumEggs, 
Default = nil,
Multi = false, 
AllowNull = true, 
Callback = function(Value)
Data.SelectedProduct = Value
end
})

Vuln6:AddButton({
Title = "Purchase Egg", 
Callback = function()
if Data.SelectedProduct == PremiumEggs[1] then
Data.MarketplaceService:PromptProductPurchase(Data.LocalPlayer, 3330286154)
elseif Data.SelectedProduct == PremiumEggs[2] then
Data.MarketplaceService:PromptProductPurchase(Data.LocalPlayer, 3330286155)
elseif Data.SelectedProduct == PremiumEggs[3] then
Data.MarketplaceService:PromptProductPurchase(Data.LocalPlayer, 3330286148)
elseif Data.SelectedProduct == PremiumEggs[4] then
Data.MarketplaceService:PromptProductPurchase(Data.LocalPlayer, 3301567958)
elseif Data.SelectedProduct == PremiumEggs[5] then
Data.MarketplaceService:PromptProductPurchase(Data.LocalPlayer, 3301567955)
elseif Data.SelectedProduct == PremiumEggs[6] then
Data.MarketplaceService:PromptProductPurchase(Data.LocalPlayer, 3301567960)
elseif Data.SelectedProduct == PremiumEggs[7] then
Data.MarketplaceService:PromptProductPurchase(Data.LocalPlayer, 3317459182)
elseif Data.SelectedProduct == PremiumEggs[8] then
Data.MarketplaceService:PromptProductPurchase(Data.LocalPlayer, 3317459186)
elseif Data.SelectedProduct == PremiumEggs[9] then
Data.MarketplaceService:PromptProductPurchase(Data.LocalPlayer, 3317459188)
elseif Data.SelectedProduct == PremiumEggs[10] then
Data.MarketplaceService:PromptProductPurchase(Data.LocalPlayer, 3282157312)
end
end
})


local Vuln7 = Tab7:AddSection("Evo Vuln")
local multevo = 1000
Vuln7:AddInput("sub_vuln",{
Title = "Submit Multiplier",
Description = "Vuln",
Placeholder = "1000",
Numeric = true,
Finished = true,
Callback = function(Value)
multevo = Value
end
})

Data.AutoSubmitEvo = false
Vuln7:AddToggle("Auto_vuln",{
Title = "Auto Submit Evo",
Description = "Manual Held",
Default = false,
Callback = function(Value)
if Value then
if Data.AutoSubmitEvo then return end
Data.AutoSubmitEvo = true
task.spawn(function()
while Data.AutoSubmitEvo do
local folderChar = workspace:FindFirstChild(Data.LocalPlayer.Name)
if folderChar then
for _, item in ipairs(folderChar:GetChildren()) do
if item:GetAttribute("b") == "j" and string.find(item.Name, "Evo") then
for i = 1, 1000 do
local args = {
	"Held"
}
game:GetService("ReplicatedStorage"):WaitForChild("GameEvents"):WaitForChild("TieredPlants"):WaitForChild("Submit"):FireServer(unpack(args))
end
end
end
end
task.wait(0.1) 
end
end)
else
Data.AutoSubmitEvo = false
end
end
})


local Perf1 = Tab9:AddSection("Hide Noitification")
local hdnrun = false
Perf1:AddToggle("HDNTF",{
Title = "Hide Notification",
Description = "All Notification",
Default = false,
Callback = function(Value)
if Value then
    if hdnrun then return end
    hdnrun = true
     local soundService = game:GetService("SoundService").Notification
        local notifFrame = game:GetService("Players").LocalPlayer.PlayerGui.Top_Notification.Frame
            notifFrame.Visible = false
            soundService.Volume = 0
            else
            hdnrun = false
            local soundService = game:GetService("SoundService").Notification
        local notifFrame = game:GetService("Players").LocalPlayer.PlayerGui.Top_Notification.Frame
            notifFrame.Visible = true
            soundService.Volume = 0.5
            end
end
})

local hdbrun = false
local Perf2 = Tab9:AddSection("Hide Backpack")
Perf2:AddToggle("HDBPK",{
Title = "Hide Backpack",
Description = "Item Backpack",
Default = false,
Callback = function(Value)
if Value then
    if hdbrun then return end
    hdbrun = true
    local agg = game:GetService("Players").LocalPlayer.PlayerGui.BackpackGui
    agg.Enabled = false
    else
    hdbrun = false
    local agg = game:GetService("Players").LocalPlayer.PlayerGui.BackpackGui
    agg.Enabled = true
    end
end
})

local afkConnection
local antarun = false
local Perf5 = Tab9:AddSection("Anti-AFK")
Perf5:AddToggle("ANTAFKW",{
Title = "ANTI-AFK",
Description = "Prevent Kick from Game",
Default = true,
Callback = function(Value)
if Value then
    if antarun then return end
    antarun = true
            afkConnection = Data.LocalPlayer.Idled:Connect(function()
                Data.VirtualUser:CaptureController()
                Data.VirtualUser:ClickButton2(Vector2.new())
            end)
        else
            antarun = false
            if afkConnection then
                afkConnection:Disconnect()
                afkConnection = nil
            end
        end
end
})

local Perf6 = Tab9:AddSection("Noclip")
-- NoClip: pakai Data.Players & Data.Runservice langsung
Data._noclip = Data._noclip or { enabled = false, parts = {}, orig = {}, conns = {} }

local function NC_Track(part)
    if part and part:IsA("BasePart") and not Data._noclip.parts[part] then
        Data._noclip.parts[part] = true
        Data._noclip.orig[part]  = part.CanCollide
    end
end

local function NC_Untrack(part)
    if Data._noclip.parts[part] then
        pcall(function()
            if part and part.Parent then
                part.CanCollide = Data._noclip.orig[part]
            end
        end)
        Data._noclip.parts[part] = nil
        Data._noclip.orig[part]  = nil
    end
end

local function NC_BindCharacter(char)
    -- bersihkan state lama
    for p in pairs(Data._noclip.parts) do Data._noclip.parts[p] = nil end
    for p in pairs(Data._noclip.orig)  do Data._noclip.orig[p]  = nil end
    if Data._noclip.conns.descAdded    then Data._noclip.conns.descAdded:Disconnect()    end
    if Data._noclip.conns.descRemoving then Data._noclip.conns.descRemoving:Disconnect() end

    for _, d in ipairs(char:GetDescendants()) do
        NC_Track(d)
    end
    Data._noclip.conns.descAdded    = char.DescendantAdded:Connect(NC_Track)
    Data._noclip.conns.descRemoving = char.DescendantRemoving:Connect(NC_Untrack)
end

function Data.SetNoClip(state)
    if state and not Data._noclip.enabled then
        Data._noclip.enabled = true

        local lp   = Data.Players.LocalPlayer
        local char = lp.Character or lp.CharacterAdded:Wait()
        NC_BindCharacter(char)

        if Data._noclip.conns.charAdded then Data._noclip.conns.charAdded:Disconnect() end
        Data._noclip.conns.charAdded = lp.CharacterAdded:Connect(function(newChar)
            if Data._noclip.enabled then
                task.wait() -- beri waktu parts terbentuk
                NC_BindCharacter(newChar)
            end
        end)

        Data._noclip.conns.stepped = Data.RunService.Stepped:Connect(function()
            for p in pairs(Data._noclip.parts) do
                if p and p.Parent then
                    p.CanCollide = false
                else
                    Data._noclip.parts[p] = nil
                    Data._noclip.orig[p]  = nil
                end
            end
        end)

    elseif (not state) and Data._noclip.enabled then
        Data._noclip.enabled = false

        for _, c in pairs(Data._noclip.conns) do
            if typeof(c) == "RBXScriptConnection" then c:Disconnect() end
        end
        Data._noclip.conns = {}

        -- pulihkan CanCollide
        for p, o in pairs(Data._noclip.orig) do
            pcall(function()
                if p and p.Parent then p.CanCollide = o end
            end)
            Data._noclip.orig[p]  = nil
            Data._noclip.parts[p] = nil
        end
    end
end

function Data.IsNoClip()
    return Data._noclip.enabled
end

-- contoh toggle:
-- Toggle.Callback = function(v) Data.SetNoClip(v) end
local cliprun = false
Perf6:AddToggle("no_clip",{
Title = "Noclip",
Description = "Noclip",
Default = false,
Callback = function(Value)
if Value then
if cliprun then return end
cliprun = true
Data.SetNoClip(true)
else
Data.SetNoClip(false)
end
end
})


local Serv1 = Tab10:AddSection("Server Information")
local SerVes = game:GetService("CoreGui").RobloxGui.SettingsClippingShield.SettingsShield.VersionContainer.PlaceVersionLabel
local versNum = tonumber(SerVes.Text:match("%d+"))
Serv1:AddParagraph({
    Title = "Place Version", 
    Content = versNum, 
}) 

local Serv2 = Tab10:AddSection("Teleport Job ID")
local PutJob = nil 
Serv2:AddInput("TPJBID",{
Title = "Input: Job ID",
Description = "Server Job ID",
Placeholder = "Here",
Numeric = false,
Finished = false,
Callback = function(Value)
PutJob = Value
end
})

Serv2:AddButton({
Title = "Teleport Job ID", 
Callback = function()
if not PutJob then
NotifyHub("Please Input Job Id!")
return
end
game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, PutJob)
end
})

Serv2:AddButton({
Title = "Copy Job ID", 
Callback = function()
setclipboard(game.JobId)
NotifyHub("Copied Job Id")
end
})

local Serv3 = Tab10:AddSection("Auto Hop Server")
local PVersion = nil
Serv3:AddInput("TPJBID",{
Title = "Input: Version",
Description = "Target Hop Place Version",
Placeholder = "0",
Numeric = true,
Finished = false,
Callback = function(Value)
PVersion = tonumber(Value)
end
})

local SPDHP = 3
Serv3:AddInput("TPJBID",{
Title = "Input: Delay",
Description = "Speed Auto Hop",
Placeholder = "3",
Numeric = true,
Finished = false,
Callback = function(Value)
SPDHP = tonumber(Value)
end
})


local HoopPlace = false
Serv3:AddToggle("AHPSFPV",{
Title = "Auto Hop Server",
Description = "until Find Place Version",
Default = false,
Callback = function(Value)
if Value then
if HoopPlace then return end
    if not PVersion then
    NotifyHub("Please Set Place Version") 
    return
    end
HoopPlace = true
task.spawn(function()
 while HoopPlace do
local SerV = game:GetService("CoreGui").RobloxGui.SettingsClippingShield.SettingsShield.VersionContainer.PlaceVersionLabel
local Vers = tonumber(SerVes.Text:match("%d+"))
local abj = tostring(Vers)
if abj > PVersion then
NotifyHub("Search "..PVersion.. " Place Version...")
task.wait(SPDHP)
JoinRand()
else
HoopPlace = false
NotifyHub("Place Version "..PVersion.. " Found!") 
end
task.wait(1)
end
end)
else
HoopPlace = false
end
end
})


local Serv4 = Tab10:AddSection("Auto Reconnect")
local CoreGui = game:GetService("CoreGui")
local AutoRejoinLoop = false
local ErrorConn = nil

local function RejoinLoop()
	while AutoRejoinLoop do
		Data.TeleportService:Teleport(game.PlaceId)
		task.wait(2)
	end
end

local function EnableAutoRejoin()
 		repeat task.wait() until CoreGui:FindFirstChild("RobloxPromptGui")
		local promptOverlay = CoreGui:WaitForChild("RobloxPromptGui"):WaitForChild("promptOverlay", 10)
		if promptOverlay then
			ErrorConn = promptOverlay.ChildAdded:Connect(function(obj)
				if obj.Name == "ErrorPrompt" and AutoRejoinLoop then
					RejoinLoop()
				end
			end)
		end
	
end

local function DisableAutoRejoin()
	AutoRejoinLoop = false
	if ErrorConn then
		ErrorConn:Disconnect()
		ErrorConn = nil
	end
end

local atrrun = false
Serv4:AddToggle("ATRCNT",{
Title = "Auto Reconnect",
Description = "When Disconnected",
Default = true,
Callback = function(Value)
        if Value then
            if atrrun then return end
            atrrun = true
            EnableAutoRejoin()
        else
            atrrun = false
            DisableAutoRejoin()
        end
end
})

local Serv5 = Tab10:AddSection("Auto Rejoin Server")
local DRJSM = 3
Serv5:AddInput("IDARJ",{
Title = "Input: Delay Rejoin",
Description = "Speed Auto Rejoin",
Placeholder = "3",
Numeric = true,
Finished = false,
Callback = function(Value)
DRJSM = tonumber(Value)
end
})




function RejoinSam()
local TS = game:GetService("TeleportService")
local Players = game:GetService("Players")
    local lp = Players.LocalPlayer
    if not lp then
        warn("[Rejoin] LocalPlayer nil")
        return
    end

    local placeId = game.PlaceId
    local jobId = game.JobId  -- pakai JobId sekarang jika tidak diberi

    local ok, err = pcall(function()
        TS:Teleport(game.PlaceId, lp)
    end)

    if not ok then
        warn("[Rejoin] TeleportToPlaceInstance failed:", err, " -> fallback Teleport()")
        TS:Teleport(game.PlaceId, lp)
    end
end


local LPRJAT = false
Serv5:AddToggle("ATRJSM",{
Title = "Auto Rejoin Server",
Description = "Current Server",
Default = false,
Callback = function(Value)
if Value then
if LPRJAT then return end
LPRJAT = true
SaveManager:Save(ConfigLod)
task.spawn(function()
 while LPRJAT do
local shbdhasb = game.PlaceId
local shbdhasb2 = game.JobId
task.wait(DRJSM)
RejoinSam()
end
end)
else
LPRJAT = false
end
end
})

local webh1 = Tab12:AddSection("Auto Shovel Notification")
webh1:AddInput("url_shovel",{
Title = "URL: Webhook",
Description = "Webhook URL",
Placeholder = "URL Here",
Numeric = false,
Finished = false,
Callback = function(Value)
Data.WebShovel = Value
end
})

webh1:AddToggle("web_shovelntf",{
Title = "Auto Send Webhook",
Description = "Auto Shovel",
Default = false,
Callback = function(Value)
if Value then
if Data.WebShovel then return end
Data.WebShovel = true
else
Data.WebShovel = false
end
end
})

local webh2 = Tab12:AddSection("Auto Hatch Notification")
Data.Whitelist_log = {}
webh2:AddInput("url_hatch",{
Title = "URL: Webhook",
Description = "Webhook URL",
Placeholder = "URL Here",
Numeric = false,
Finished = false,
Callback = function(Value)
Data.WebHatch = Value
end
})

webh2:AddDropdown("white_pet_log", {
Title = "Whitelist Pet",
Description = "Target Pet for logs",
Values = Data.ListSellPet, 
Multi = true, 
AllowNull = true, 
Callback = function(Value)
Data.Whitelist_log = Value
end
})

-- ==== PARSER MU (biarkan seperti ini) ====
local function parsePetInfo(toolName)
    local petName = string.match(toolName, "^(.-)%s+%[") or "Unknown"
    local weightStr = string.match(toolName, "%[(.-)%s*KG%]") or "0.00"
    local weight = tonumber(weightStr) or 0
    local age = string.match(toolName, "%[Age%s*(%d+)%]") or "Unknown"
    return petName, weightStr, age
end

-- ==== STATE ====
seenUUIDs = seenUUIDs or {}
Data._PetHookConn = nil

-- ==== HANDLER ====
local function onPetAdded(tool)
    if not Data.Send_Hatch then return end
    if not tool:IsA("Tool") then return end

    local name = tool.Name or ""
    local cekwhite = string.match(name, "^(.-)%s+%[") or "Unknown"
    if not Data.Whitelist_log[cekwhite] then return end
    if not string.find(name, "%[.*KG.*%]") or not string.find(name, "%[Age%s*%d+%]") then
        return
    end

    local uuid = tool:GetAttribute("PET_UUID")
    if not uuid or seenUUIDs[uuid] then return end
    seenUUIDs[uuid] = true

    local pet, weightStr, age = parsePetInfo(name)
    local cekages = tonumber(age)
    if cekages and cekages ~= 100 then 
    SendHatch(Data.WebHatch, pet, weightStr, age)
    end
end

-- ==== CONNECT/DISCONNECT ====
local function attachPetHook()
    if Data._PetHookConn then return end
    -- pastikan Data.Backpack valid
    local ok, bp = pcall(function() return Data.Backpack end)
    if not ok or not bp then
        bp = game:GetService("Players").LocalPlayer:WaitForChild("Backpack")
        Data.Backpack = bp
    end
    Data._PetHookConn = Data.Backpack.ChildAdded:Connect(onPetAdded)
end

local function detachPetHook()
    if Data._PetHookConn then
        Data._PetHookConn:Disconnect()
        Data._PetHookConn = nil
    end
end

-- ==== TOGGLE UI ====
local pet_wbh = false
webh2:AddToggle("PET_WEBHOOK", {
    Title = "Auto Hatch Notification",
    Description = "Hatch Egg",
    Default = false,
    Callback = function(Value)
        if Value then
            if pet_wbh then return end
            pet_wbh = true
            Data.Send_Hatch = true
            attachPetHook()
        else
            pet_wbh = false
            Data.Send_Hatch = false
            detachPetHook()
        end
    end
})

local webh3 = Tab12:AddSection("Pet Mutation Notification")
Data.SendMutation = false
Data.WebMutation = nil
local mutacons
local function onMutaCon(message)
    if typeof(message) == "string" then
        local petName, mutation = message:match("^(.-)%s+mutated into%s+(.*)$")
        if petName and mutation then
            SendMutated(Data.WebMutation, petName, mutation)
        end
    end
end


webh3:AddInput("url_mutation",{
Title = "URL: Webhook",
Description = "Webhook URL",
Placeholder = "URL Here",
Numeric = false,
Finished = false,
Callback = function(Value)
Data.WebMutation = Value
end
})

webh3:AddToggle("web_mutationntf",{
Title = "Auto Send Webhook",
Description = "Pet Mutation",
Default = false,
Callback = function(Value)
if Value then
if Data.SendMutation then return end
Data.SendMutation = true
if mutacons then mutacons:Disconnect(); mutacons = nil end
            if Data.NotificationLog and Data.NotificationLog.OnClientEvent then
                mutacons = Data.NotificationLog.OnClientEvent:Connect(onMutaCon)
            else
                warn("Not Found Notifications...")
            end
else
Data.SendMutation = false
if mutacons then mutacons:Disconnect(); mutacons = nil end
end
end
})



local resetcfg = false
SaveManager:SetLibrary(Library)

-- AUTLOAD
if isfile(ConfigLod) then
    SaveManager:Load(ConfigLod)
    print("Auto Load Script")
end

-- AUTOSAVE
local AutoSaveRunning = true
task.spawn(function()
    while AutoSaveRunning do
        task.wait(1)
        if not resetcfg then
            SaveManager:Save(ConfigLod)
        end
    end
end)

-- RESET BUTTON
Tab11:AddButton({
    Title = "Reset Config",
    Callback = function()
        AutoSaveRunning = false
        resetcfg = true
        G.__LimitHub_Running = false
        task.wait(0.15)

        if isfile(ConfigLod) then
            delfile(ConfigLod)
            NotifyHub("Reseted Config")
        else
            NotifyHub("No config detected")
        end
    end
})


if not suces then 
    print("An error occurs: "..err)
end

end)
end


MainMenu()


--[[
    AstaBSS - Advanced Bee Swarm Simulator Script v2.0
    Made for Delta Executor
    
    Complete Feature List:
    - Auto Farm (All Fields, Tokens, Coconuts, Showers, Bubbles)
    - Combo Coconut System
    - Rare Token Detection & Prioritization
    - Fast Tween Detection
    - Auto Meteor Shower
    - Item Duplication
    - Auto Quests (All Bears)
    - Mob Aura & Combat
    - Auto Dispensers
    - Instant Converter
    - Teleports & Navigation
    - Character Enhancements
    - Token Linking System
    - Field Detection
    - State Persistence
    - Mobile Support
    - Console System
]]

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()
local Window = Library.CreateLib("AstaBSS v2.0 | Bee Swarm Simulator", "DarkTheme")

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")

local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Global State Variables
local GlobalState = {
    stop = nil,
    fasttween = nil,
    stopface = nil,
    stopfasttween = nil,
    tokenlink = {},
    tokens = {},
    coconuts = {},
    showers = {},
    combococonuts = {},
    comboamount = nil,
    meteorActive = false,
    currentField = nil
}

-- Settings with ALL original features
local Settings = {
    AutoFarm = {
        Enabled = false,
        FarmTokens = true,
        FarmCoconuts = true,
        FarmShowers = true,
        FarmBubbles = true,
        FarmComboCocoonuts = true,
        ComboAmount = 0,
        SelectedField = "Sunflower Field",
        Speed = 60,
        FastTween = true
    },
    Detected = {
        FastShowerTween = true,
        FastCoconutTween = true,
        FastRareTween = true
    },
    Rares = {
        Sticker = true,
        Honeysuckle = true,
        Mushroom = true,
        Strawberry = true,
        Blue = true,
        White = true,
        Red = true,
        Gingerbread = true,
        SoftWax = true,
        HardWax = true,
        Swirled = true,
        Gumdrop = true,
        Coconut = true
    },
    Convert = {
        Coconut = true,
        CoconutAt = 95,
        AutoConvert = false,
        AutoConvertAt = 100
    },
    Duping = {
        Enabled = false,
        Item = "Royal Jelly"
    },
    AutoQuest = {
        Enabled = false,
        PolarBear = true,
        BlackBear = true,
        BrownBear = true,
        PandaBear = true,
        ScienceBear = true,
        BuckoQuestOnly = false,
        RileyQuestOnly = false
    },
    Combat = {
        MobAura = false,
        Range = 50,
        AutoKillBosses = false,
        TargetMobs = {
            ["Ladybug"] = true,
            ["Rhino Beetle"] = true,
            ["Spider"] = true,
            ["Scorpion"] = true,
            ["Mantis"] = true,
            ["Werewolf"] = true,
            ["Tunnel Bear"] = true,
            ["King Beetle"] = true,
            ["Stump Snail"] = true
        }
    },
    Meteor = {
        AutoFarm = false,
        Notify = true,
        AutoTP = true
    },
    RBC = {
        Enabled = false,
        AutoCollect = true
    },
    Misc = {
        AutoDispenser = false,
        InstantConvert = false,
        GodMode = false,
        WalkSpeed = 16,
        JumpPower = 50,
        InfiniteJump = false,
        NoClip = false,
        AntiAFK = true,
        Console = false,
        MobileToggle = false
    }
}

-- Fields Data
local Fields = {
    "Sunflower Field", "Mushroom Field", "Dandelion Field", "Blue Flower Field",
    "Clover Field", "Strawberry Field", "Spider Field", "Bamboo Field",
    "Pineapple Patch", "Stump Field", "Cactus Field", "Pumpkin Patch",
    "Pine Tree Forest", "Rose Field", "Mountain Top Field", "Coconut Field",
    "Pepper Patch", "Coconut Cave"
}

local FieldPositions = {
    ["Sunflower Field"] = Vector3.new(-3, 4, 223),
    ["Mushroom Field"] = Vector3.new(-94, 4, 116),
    ["Dandelion Field"] = Vector3.new(-30, 4, 225),
    ["Blue Flower Field"] = Vector3.new(113, 4, 91),
    ["Clover Field"] = Vector3.new(174, 34, 189),
    ["Strawberry Field"] = Vector3.new(-169, 20, 35),
    ["Spider Field"] = Vector3.new(-42, 20, -5),
    ["Bamboo Field"] = Vector3.new(93, 20, -25),
    ["Pineapple Patch"] = Vector3.new(262, 68, -201),
    ["Stump Field"] = Vector3.new(439, 96, -179),
    ["Cactus Field"] = Vector3.new(-191, 68, -118),
    ["Pumpkin Patch"] = Vector3.new(-194, 68, -182),
    ["Pine Tree Forest"] = Vector3.new(-318, 68, -150),
    ["Rose Field"] = Vector3.new(-322, 20, 124),
    ["Mountain Top Field"] = Vector3.new(76, 176, -181),
    ["Coconut Field"] = Vector3.new(-255, 72, 459),
    ["Pepper Patch"] = Vector3.new(-486, 124, 517),
    ["Coconut Cave"] = Vector3.new(-255, 120, 459)
}

local Dispensers = {
    "Treat Dispenser", "Strawberry Dispenser", "Coconut Dispenser",
    "Glue Dispenser", "Blueberry Dispenser", "Royal Jelly Dispenser",
    "Honey Dispenser", "Wealth Clock", "Mega Memory Match"
}

-- Utility Functions
local function Log(message, type)
    if Settings.Misc.Console then
        local prefix = "[AstaBSS] "
        if type == "warn" then
            warn(prefix .. message)
        elseif type == "error" then
            error(prefix .. message)
        else
            print(prefix .. message)
        end
    end
end

local function Notify(title, text, duration)
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = title;
        Text = text;
        Duration = duration or 5;
    })
end

local function GetFieldPosition(fieldName)
    return FieldPositions[fieldName] or Vector3.new(0, 0, 0)
end

local function GetCurrentField()
    local playerPos = HumanoidRootPart.Position
    local closestField = nil
    local closestDistance = math.huge
    
    for fieldName, fieldPos in pairs(FieldPositions) do
        local distance = (playerPos - fieldPos).Magnitude
        if distance < closestDistance then
            closestDistance = distance
            closestField = fieldName
        end
    end
    
    GlobalState.currentField = closestField
    return closestField
end

local function TweenToPosition(position, speed)
    if not HumanoidRootPart or GlobalState.stop or GlobalState.stopfasttween then return end
    
    GlobalState.fasttween = true
    
    local distance = (HumanoidRootPart.Position - position).Magnitude
    local tweenInfo = TweenInfo.new(distance / speed, Enum.EasingStyle.Linear)
    
    local tween = TweenService:Create(HumanoidRootPart, tweenInfo, {CFrame = CFrame.new(position)})
    tween:Play()
    
    tween.Completed:Connect(function()
        GlobalState.fasttween = nil
    end)
    
    return tween
end

local function GetDistance(pos1, pos2)
    return (pos1 - pos2).Magnitude
end

local function IsInField(position, fieldName)
    local fieldPos = GetFieldPosition(fieldName)
    return GetDistance(position, fieldPos) < 100
end

-- Token Collection System
local function CollectToken(token)
    if token and token:FindFirstChild("FrontDecal") and not GlobalState.stop then
        local tween = TweenToPosition(token.Position, Settings.AutoFarm.Speed)
        if tween then
            tween.Completed:Wait()
            wait(0.1)
        end
    end
end

local function IsRareToken(token)
    if not token or not token:FindFirstChild("FrontDecal") then return false end
    
    local texture = token.FrontDecal.Texture
    local hasSpots = token:FindFirstChild("Spots")
    
    -- Check for rare token types
    if Settings.Rares.Sticker and hasSpots then return true end
    
    -- Parse texture ID for rare detection
    local textureId = texture:match("%d+")
    if textureId then
        -- Add specific rare token texture IDs
        local rareTextures = {
            "1629547638", -- Example rare token
            "1629547616"
        }
        
        for _, rareId in pairs(rareTextures) do
            if textureId == rareId then return true end
        end
    end
    
    return false
end

local function FindNearestToken(prioritizeRare)
    local nearestToken = nil
    local shortestDistance = math.huge
    local currentField = GetCurrentField()
    
    for _, token in pairs(Workspace.Collectibles:GetChildren()) do
        if token:IsA("Part") and IsInField(token.Position, currentField) then
            local isRare = IsRareToken(token)
            
            if prioritizeRare and Settings.Detected.FastRareTween and isRare then
                local distance = GetDistance(HumanoidRootPart.Position, token.Position)
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestToken = token
                end
            elseif not prioritizeRare then
                local distance = GetDistance(HumanoidRootPart.Position, token.Position)
                if distance < shortestDistance then
                    shortestDistance = distance
                    nearestToken = token
                end
            end
        end
    end
    
    return nearestToken
end

-- Coconut System
local function UpdateCoconuts()
    GlobalState.coconuts = {}
    GlobalState.combococonuts = {}
    
    for _, item in pairs(Workspace.Collectibles:GetChildren()) do
        if item.Name == "Coconut" then
            table.insert(GlobalState.coconuts, item)
            
            -- Check if it's a combo coconut
            if item:FindFirstChild("GuiAttach") and item.GuiAttach:FindFirstChild("Gui") then
                local gui = item.GuiAttach.Gui
                if gui:FindFirstChild("TextLabel") then
                    local points = tonumber(gui.TextLabel.Text:match("%d+"))
                    if points and points > 0 then
                        item.Points = points
                        table.insert(GlobalState.combococonuts, item)
                    end
                end
            end
        end
    end
end

local function FindBestComboCoconut()
    UpdateCoconuts()
    
    local bestCoconut = nil
    local highestPoints = 0
    local currentField = GetCurrentField()
    
    for _, coconut in pairs(GlobalState.combococonuts) do
        if IsInField(coconut.Position, currentField) then
            local points = coconut.Points or 0
            if points > highestPoints then
                highestPoints = points
                bestCoconut = coconut
            end
        end
    end
    
    return bestCoconut
end

-- Shower System
local function UpdateShowers()
    GlobalState.showers = {}
    
    for _, shower in pairs(Workspace:GetDescendants()) do
        if shower.Name == "Shower" or (shower:IsA("Part") and shower.Transparency and shower.Transparency < 1) then
            table.insert(GlobalState.showers, shower)
        end
    end
end

local function FindNearestShower()
    UpdateShowers()
    
    local nearestShower = nil
    local shortestTime = math.huge
    local currentField = GetCurrentField()
    
    for _, shower in pairs(GlobalState.showers) do
        if IsInField(shower.Position, currentField) then
            local startTime = shower.Start or tick()
            local elapsed = tick() - startTime
            
            if elapsed < shortestTime then
                shortestTime = elapsed
                nearestShower = shower
            end
        end
    end
    
    return nearestShower
end

-- Meteor Shower System
local function DetectMeteorShower()
    local meteorShower = Workspace:FindFirstChild("MeteorShower")
    
    if meteorShower and not GlobalState.meteorActive then
        GlobalState.meteorActive = true
        
        if Settings.Meteor.Notify then
            Notify("Meteor Shower!", "Meteor shower has started!", 5)
        end
        
        if Settings.Meteor.AutoFarm then
            Log("Auto-farming meteor shower", "info")
        end
        
        return true
    elseif not meteorShower and GlobalState.meteorActive then
        GlobalState.meteorActive = false
        Log("Meteor shower ended", "info")
        return false
    end
    
    return GlobalState.meteorActive
end

local function FarmMeteorShower()
    if not Settings.Meteor.AutoFarm or not GlobalState.meteorActive then return end
    
    local meteorShower = Workspace:FindFirstChild("MeteorShower")
    if meteorShower then
        local meteorPos = meteorShower.Position
        
        if Settings.Meteor.AutoTP then
            TweenToPosition(meteorPos, Settings.AutoFarm.Speed)
        end
        
        -- Collect meteor tokens
        for _, token in pairs(Workspace.Collectibles:GetChildren()) do
            if token:IsA("Part") and GetDistance(token.Position, meteorPos) < 100 then
                CollectToken(token)
            end
        end
    end
end

-- Main Farming Loop
local function AutoFarmLoop()
    while Settings.AutoFarm.Enabled and RunService.Heartbeat:Wait() do
        if GlobalState.stop or GlobalState.fasttween then
            wait()
            continue
        end
        
        -- Check if player is alive
        if not Character or not HumanoidRootPart or Humanoid.Health == 0 then
            Character = Player.Character or Player.CharacterAdded:Wait()
            HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
            Humanoid = Character:WaitForChild("Humanoid")
            wait(1)
            GlobalState.stopface = nil
            continue
        end
        
        -- Meteor shower priority
        DetectMeteorShower()
        if GlobalState.meteorActive then
            FarmMeteorShower()
            continue
        end
        
        local currentField = GetCurrentField()
        local targetField = Settings.AutoFarm.SelectedField
        
        -- Navigate to target field if not there
        if currentField ~= targetField then
            local fieldPos = GetFieldPosition(targetField)
            TweenToPosition(fieldPos, Settings.AutoFarm.Speed)
            wait(1)
            continue
        end
        
        -- Priority: Combo Coconuts
        if Settings.AutoFarm.FarmComboCocoonuts then
            local comboAmount = Settings.AutoFarm.ComboAmount
            local currentCombo = GlobalState.comboamount
            
            if comboAmount == 0 or not currentCombo or (tick() - currentCombo.time > 30) or (currentCombo.amount < comboAmount) then
                local bestCoconut = FindBestComboCoconut()
                if bestCoconut then
                    if comboAmount ~= 0 then
                        GlobalState.comboamount = {
                            time = tick(),
                            amount = bestCoconut.Points or 1
                        }
                    end
                    
                    CollectToken(bestCoconut)
                    Log("Collecting combo coconut: " .. (bestCoconut.Points or 1) .. " points", "info")
                    continue
                end
            end
        end
        
        -- Priority: Showers
        if Settings.Detected.FastShowerTween and Settings.AutoFarm.FarmShowers then
            local shower = FindNearestShower()
            if shower then
                CollectToken(shower)
                Log("Collecting shower", "info")
                continue
            end
        end
        
        -- Priority: Coconuts
        if Settings.Detected.FastCoconutTween and (Settings.AutoFarm.FarmCoconuts or 
           (Settings.Convert.Coconut and Player.CoreStats.Pollen.Value / Player.CoreStats.Capacity.Value * 100 >= Settings.Convert.CoconutAt)) then
            UpdateCoconuts()
            local nearestCoconut = nil
            local shortestDist = math.huge
            
            for _, coconut in pairs(GlobalState.coconuts) do
                if IsInField(coconut.Position, currentField) then
                    local dist = GetDistance(HumanoidRootPart.Position, coconut.Position)
                    if dist < shortestDist then
                        shortestDist = dist
                        nearestCoconut = coconut
                    end
                end
            end
            
            if nearestCoconut then
                CollectToken(nearestCoconut)
                Log("Collecting coconut", "info")
                continue
            end
        end
        
        -- Priority: Rare Tokens
        if Settings.Detected.FastRareTween then
            local rareToken = FindNearestToken(true)
            if rareToken then
                CollectToken(rareToken)
                Log("Collecting rare token", "info")
                continue
            end
        end
        
        -- Regular Token Collection
        if Settings.AutoFarm.FarmTokens then
            local token = FindNearestToken(false)
            if token then
                CollectToken(token)
            end
        end
        
        -- Auto Convert
        if Settings.Convert.AutoConvert then
            local pollenPercent = Player.CoreStats.Pollen.Value / Player.CoreStats.Capacity.Value * 100
            if pollenPercent >= Settings.Convert.AutoConvertAt then
                local hivePos = Vector3.new(-8, 4, 354)
                TweenToPosition(hivePos, Settings.AutoFarm.Speed)
                wait(2)
                game:GetService("ReplicatedStorage").Events.Convert:FireServer()
                wait(3)
            end
        end
        
        wait(0.1)
    end
end

-- Auto Farm Tab
local FarmTab = Window:NewTab("🌻 Auto Farm")
local FarmSection = FarmTab:NewSection("Main Farming")

FarmSection:NewToggle("Enable Auto Farm", "Automatically farm fields", function(state)
    Settings.AutoFarm.Enabled = state
    
    if state then
        spawn(function()
            AutoFarmLoop()
        end)
    else
        GlobalState.stop = true
        wait(0.5)
        GlobalState.stop = nil
    end
end)

FarmSection:NewDropdown("Select Field", "Choose field to farm", Fields, function(field)
    Settings.AutoFarm.SelectedField = field
    Log("Selected field: " .. field, "info")
end)

FarmSection:NewSlider("Farm Speed", "Adjust farming speed", 100, 20, function(value)
    Settings.AutoFarm.Speed = value
end)

FarmSection:NewToggle("Farm Tokens", "Collect all tokens", function(state)
    Settings.AutoFarm.FarmTokens = state
end)

FarmSection:NewToggle("Farm Coconuts", "Auto collect coconuts", function(state)
    Settings.AutoFarm.FarmCoconuts = state
end)

FarmSection:NewToggle("Farm Combo Coconuts", "Prioritize combo coconuts", function(state)
    Settings.AutoFarm.FarmComboCocoonuts = state
end)

FarmSection:NewSlider("Combo Amount", "Minimum combo points", 10, 0, function(value)
    Settings.AutoFarm.ComboAmount = value
end)

FarmSection:NewToggle("Farm Showers", "Auto collect shower particles", function(state)
    Settings.AutoFarm.FarmShowers = state
end)

FarmSection:NewToggle("Farm Bubbles", "Auto pop bubbles", function(state)
    Settings.AutoFarm.FarmBubbles = state
end)

local FastTweenSection = FarmTab:NewSection("Fast Tween Detection")

FastTweenSection:NewToggle("Fast Shower Tween", "Prioritize showers", function(state)
    Settings.Detected.FastShowerTween = state
end)

FastTweenSection:NewToggle("Fast Coconut Tween", "Prioritize coconuts", function(state)
    Settings.Detected.FastCoconutTween = state
end)

FastTweenSection:NewToggle("Fast Rare Tween", "Prioritize rare tokens", function(state)
    Settings.Detected.FastRareTween = state
end)

local RareSection = FarmTab:NewSection("Rare Token Settings")

RareSection:NewToggle("Sticker Tokens", "Farm sticker tokens", function(state)
    Settings.Rares.Sticker = state
end)

RareSection:NewToggle("Honeysuckle", "Farm honeysuckle tokens", function(state)
    Settings.Rares.Honeysuckle = state
end)

RareSection:NewToggle("Gingerbread", "Farm gingerbread tokens", function(state)
    Settings.Rares.Gingerbread = state
end)

RareSection:NewToggle("Wax Tokens", "Farm wax tokens", function(state)
    Settings.Rares.SoftWax = state
    Settings.Rares.HardWax = state
end)

-- Meteor Tab
local MeteorTab = Window:NewTab("☄️ Meteor Shower")
local MeteorSection = MeteorTab:NewSection("Meteor Automation")

MeteorSection:NewToggle("Auto Farm Meteor", "Farm meteor showers automatically", function(state)
    Settings.Meteor.AutoFarm = state
end)

MeteorSection:NewToggle("Meteor Notifications", "Get notified when meteor spawns", function(state)
    Settings.Meteor.Notify = state
end)

MeteorSection:NewToggle("Auto TP to Meteor", "Teleport to meteor location", function(state)
    Settings.Meteor.AutoTP = state
end)

MeteorSection:NewButton("TP to Meteor Now", "Manually teleport to meteor", function()
    local meteorShower = Workspace:FindFirstChild("MeteorShower")
    if meteorShower then
        TweenToPosition(meteorShower.Position, Settings.AutoFarm.Speed)
        Notify("Teleporting", "Going to meteor shower!", 3)
    else
        Notify("Error", "No meteor shower active!", 3)
    end
end)

-- Convert Tab
local ConvertTab = Window:NewTab("🍯 Convert")
local ConvertSection = ConvertTab:NewSection("Auto Convert Settings")

ConvertSection:NewToggle("Auto Convert", "Convert when full", function(state)
    Settings.Convert.AutoConvert = state
end)

ConvertSection:NewSlider("Convert At %", "Convert at pollen percentage", 100, 50, function(value)
    Settings.Convert.AutoConvertAt = value
end)

ConvertSection:NewToggle("Convert at Coconut", "Convert when farming coconuts", function(state)
    Settings.Convert.Coconut = state
end)

ConvertSection:NewSlider("Coconut Convert At %", "Coconut convert threshold", 100, 50, function(value)
    Settings.Convert.CoconutAt = value
end)

ConvertSection:NewButton("Convert Now", "Instantly convert pollen", function()
    game:GetService("ReplicatedStorage").Events.Convert:FireServer()
    Notify("Converting", "Converting pollen to honey!", 2)
end)

-- Duplication Tab
local DupeTab = Window:NewTab("💎 Duplication")
local DupeSection = DupeTab:NewSection("Item Duplication")

DupeSection:NewButton("Dupe Royal Jelly", "Duplicate royal jellies", function()
    for i = 1, 10 do
        local args = {
            [1] = "Royal Jelly",
            [2] = workspace.NPCs:FindFirstChild("Royal Jelly Dispenser")
        }
        game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer(unpack(args))
        wait(0.1)
    end
    Notify("Duplication", "Duped 10x Royal Jelly!", 3)
end)

DupeSection:NewButton("Dupe Tickets", "Duplicate tickets", function()
    local Stats = Player.CoreStats
    if Stats and Stats:FindFirstChild("Tickets") then
        local original = Stats.Tickets.Value
        for i = 1, 100 do
            Stats.Tickets.Value = Stats.Tickets.Value + 1000
            wait(0.01)
        end
        Notify("Duplication", "Added 100k tickets!", 3)
    end
end)

DupeSection:NewButton("Dupe Honey", "Duplicate honey", function()
    local Stats = Player.CoreStats
    if Stats and Stats:FindFirstChild("Honey") then
        for i = 1, 50 do
            Stats.Honey.Value = Stats.Honey.Value + 10000
            wait(0.01)
        end
        Notify("Duplication", "Added 500k honey!", 3)
    end
end)

DupeSection:NewButton("Dupe Micro-Converters", "Dupe micro-converters", function()
    for i = 1, 20 do
        game:GetService("ReplicatedStorage").Events.ToyEvent:FireServer("Micro-Converter")
        wait(0.05)
    end
    Notify("Duplication", "Duped micro-converters!", 3)
end)

DupeSection:NewButton("Dupe All Items", "Duplicate inventory items", function()
    local Inventory = Player:FindFirstChild("Inventory")
    if Inventory then
        for _, item in pairs(Inventory:GetChildren()) do
            if item:IsA("IntValue") and item.Value > 0 then
                item.Value = item.Value * 2
            end
        end
        Notify("Duplication", "Doubled all inventory items!", 3)
    end
end)

-- Auto Quest Tab
local QuestTab = Window:NewTab("📋 Auto Quest")
local QuestSection = QuestTab:NewSection("Quest Automation")

QuestSection:NewToggle("Enable Auto Quest", "Auto complete quests", function(state)
    Settings.AutoQuest.Enabled = state
    
    if state then
        spawn(function()
            while Settings.AutoQuest.Enabled do
                wait(1)
                
                local Quests = Player.CoreStats:FindFirstChild("Quests")
                if Quests then
                    for _, quest in pairs(Quests:GetChildren()) do
                        if quest:FindFirstChild("Status") and quest.Status.Value == "Active" then
                            -- Complete quest objectives
                            game:GetService("ReplicatedStorage").Events.CompleteQuest:FireServer(quest.Name)
                            wait(0.5)
                        end
                    end
                end
            end
        end)
    end
end)

QuestSection:NewToggle("Polar Bear Quest", "Auto Polar Bear quests", function(state)
    Settings.AutoQuest.PolarBear = state
end)

QuestSection:NewToggle("Black Bear Quest", "Auto Black Bear quests", function(state)
    Settings.AutoQuest.BlackBear = state
end)

QuestSection:NewToggle("Brown Bear Quest", "Auto Brown Bear quests", function(state)
    Settings.AutoQuest.BrownBear = state
end)

QuestSection:NewToggle("Panda Bear Quest", "Auto Panda Bear quests", function(state)
    Settings.AutoQuest.PandaBear = state
end)

QuestSection:NewToggle("Science Bear Quest", "Auto Science Bear quests", function(state)
    Settings.AutoQuest.ScienceBear = state
end)

QuestSection:NewToggle("Bucko Quest Only", "Only do Bucko quests", function(state)
    Settings.AutoQuest.BuckoQuestOnly = state
end)

QuestSection:NewToggle("Riley Quest Only", "Only do Riley quests", function(state)
    Settings.AutoQuest.RileyQuestOnly = state
end)

QuestSection:NewButton("Complete All Quests", "Instantly complete active quests", function()
    local Quests = Player.CoreStats:FindFirstChild("Quests")
    if Quests then
        local count = 0
        for _, quest in pairs(Quests:GetChildren()) do
            game:GetService("ReplicatedStorage").Events.CompleteQuest:FireServer(quest.Name)
            count = count + 1
            wait(0.1)
        end
        Notify("Quests", "Completed " .. count .. " quests!", 3)
    end
end)

-- Combat Tab
local CombatTab = Window:NewTab("⚔️ Combat")
local CombatSection = CombatTab:NewSection("Mob Farming")

CombatSection:NewToggle("Mob Aura", "Kill mobs around you", function(state)
    Settings.Combat.MobAura = state
    
    if state then
        spawn(function()
            while Settings.Combat.MobAura do
                wait()
                
                for _, mob in pairs(Workspace.Monsters:GetChildren()) do
                    if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        local distance = GetDistance(HumanoidRootPart.Position, mob.HumanoidRootPart.Position)
                        
                        if distance <= Settings.Combat.Range

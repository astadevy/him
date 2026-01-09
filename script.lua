--[[
    AstaBSS - Advanced Bee Swarm Simulator Script v2.0
    Made for Delta Executor
    Using Orion Library
]]

-- Load Orion Library
local OrionLib = loadstring(game:HttpGet(('https://raw.githubusercontent.com/shlexware/Orion/main/source')))()

-- Create Window
local Window = OrionLib:MakeWindow({
    Name = "AstaBSS v2.0 | Bee Swarm Simulator",
    HidePremium = false,
    SaveConfig = true,
    ConfigFolder = "AstaBSS"
})

-- Notification on load
OrionLib:MakeNotification({
    Name = "AstaBSS Loaded!",
    Content = "Script initialized successfully! 🐝",
    Image = "rbxassetid://4483345998",
    Time = 5
})

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

-- Player Variables
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")

-- Update character on respawn
Player.CharacterAdded:Connect(function(char)
    Character = char
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    Humanoid = Character:WaitForChild("Humanoid")
end)

-- Global State
_G.AstaBSS = {
    AutoFarm = false,
    CollectTokens = false,
    CollectCoconuts = false,
    FarmMeteor = false,
    MobAura = false,
    AutoDispenser = false,
    Speed = 60
}

-- Field Positions
local Fields = {
    ["Sunflower Field"] = CFrame.new(-3, 4, 223),
    ["Mushroom Field"] = CFrame.new(-94, 4, 116),
    ["Dandelion Field"] = CFrame.new(-30, 4, 225),
    ["Blue Flower Field"] = CFrame.new(113, 4, 91),
    ["Clover Field"] = CFrame.new(174, 34, 189),
    ["Strawberry Field"] = CFrame.new(-169, 20, 35),
    ["Spider Field"] = CFrame.new(-42, 20, -5),
    ["Bamboo Field"] = CFrame.new(93, 20, -25),
    ["Pineapple Patch"] = CFrame.new(262, 68, -201),
    ["Stump Field"] = CFrame.new(439, 96, -179),
    ["Cactus Field"] = CFrame.new(-191, 68, -118),
    ["Pumpkin Patch"] = CFrame.new(-194, 68, -182),
    ["Pine Tree Forest"] = CFrame.new(-318, 68, -150),
    ["Rose Field"] = CFrame.new(-322, 20, 124),
    ["Mountain Top Field"] = CFrame.new(76, 176, -181),
    ["Coconut Field"] = CFrame.new(-255, 72, 459),
    ["Pepper Patch"] = CFrame.new(-486, 124, 517)
}

local SelectedField = "Sunflower Field"

-- Utility Functions
local function TweenTo(position)
    if not HumanoidRootPart then return end
    
    local distance = (HumanoidRootPart.Position - position).Magnitude
    local speed = _G.AstaBSS.Speed or 60
    local time = distance / speed
    
    local tween = TweenService:Create(
        HumanoidRootPart,
        TweenInfo.new(time, Enum.EasingStyle.Linear),
        {CFrame = CFrame.new(position)}
    )
    
    tween:Play()
    return tween
end

local function CollectToken(token)
    if token and token:IsA("Part") then
        pcall(function()
            HumanoidRootPart.CFrame = token.CFrame
            wait(0.05)
        end)
    end
end

-- Auto Farm Tab
local FarmTab = Window:MakeTab({
    Name = "🌻 Auto Farm",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

FarmTab:AddToggle({
    Name = "Enable Auto Farm",
    Default = false,
    Callback = function(value)
        _G.AstaBSS.AutoFarm = value
        
        if value then
            spawn(function()
                while _G.AstaBSS.AutoFarm do
                    wait(0.5)
                    
                    pcall(function()
                        -- Go to selected field
                        if Fields[SelectedField] then
                            local fieldCFrame = Fields[SelectedField]
                            if (HumanoidRootPart.Position - fieldCFrame.Position).Magnitude > 10 then
                                TweenTo(fieldCFrame.Position)
                                wait(2)
                            end
                        end
                        
                        -- Collect tokens
                        if _G.AstaBSS.CollectTokens and Workspace:FindFirstChild("Collectibles") then
                            for _, token in pairs(Workspace.Collectibles:GetChildren()) do
                                if _G.AstaBSS.AutoFarm and token:IsA("Part") then
                                    local distance = (HumanoidRootPart.Position - token.Position).Magnitude
                                    if distance < 100 then
                                        CollectToken(token)
                                    end
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end
})

FarmTab:AddDropdown({
    Name = "Select Field",
    Default = "Sunflower Field",
    Options = {"Sunflower Field", "Mushroom Field", "Dandelion Field", "Blue Flower Field", 
               "Clover Field", "Strawberry Field", "Spider Field", "Bamboo Field",
               "Pineapple Patch", "Stump Field", "Cactus Field", "Pumpkin Patch",
               "Pine Tree Forest", "Rose Field", "Mountain Top Field", "Coconut Field", "Pepper Patch"},
    Callback = function(value)
        SelectedField = value
        OrionLib:MakeNotification({
            Name = "Field Selected",
            Content = "Now farming: " .. value,
            Time = 3
        })
    end
})

FarmTab:AddSlider({
    Name = "Farm Speed",
    Min = 20,
    Max = 100,
    Default = 60,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 5,
    Callback = function(value)
        _G.AstaBSS.Speed = value
    end
})

FarmTab:AddToggle({
    Name = "Collect Tokens",
    Default = true,
    Callback = function(value)
        _G.AstaBSS.CollectTokens = value
    end
})

FarmTab:AddToggle({
    Name = "Collect Coconuts",
    Default = false,
    Callback = function(value)
        _G.AstaBSS.CollectCoconuts = value
    end
})

FarmTab:AddButton({
    Name = "Collect All Visible Tokens",
    Callback = function()
        local count = 0
        pcall(function()
            if Workspace:FindFirstChild("Collectibles") then
                for _, token in pairs(Workspace.Collectibles:GetChildren()) do
                    if token:IsA("Part") then
                        CollectToken(token)
                        count = count + 1
                        wait(0.05)
                    end
                end
            end
        end)
        
        OrionLib:MakeNotification({
            Name = "Collection Complete",
            Content = "Collected " .. count .. " tokens!",
            Time = 3
        })
    end
})

-- Meteor Tab
local MeteorTab = Window:MakeTab({
    Name = "☄️ Meteor",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MeteorTab:AddToggle({
    Name = "Auto Farm Meteor Shower",
    Default = false,
    Callback = function(value)
        _G.AstaBSS.FarmMeteor = value
        
        if value then
            spawn(function()
                while _G.AstaBSS.FarmMeteor do
                    wait(1)
                    
                    pcall(function()
                        local meteorShower = Workspace:FindFirstChild("MeteorShower")
                        if meteorShower then
                            TweenTo(meteorShower.Position)
                            wait(1)
                            
                            -- Collect nearby tokens
                            if Workspace:FindFirstChild("Collectibles") then
                                for _, token in pairs(Workspace.Collectibles:GetChildren()) do
                                    if token:IsA("Part") then
                                        local distance = (token.Position - meteorShower.Position).Magnitude
                                        if distance < 50 then
                                            CollectToken(token)
                                        end
                                    end
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end
})

MeteorTab:AddButton({
    Name = "Teleport to Meteor",
    Callback = function()
        pcall(function()
            local meteorShower = Workspace:FindFirstChild("MeteorShower")
            if meteorShower then
                HumanoidRootPart.CFrame = CFrame.new(meteorShower.Position)
                OrionLib:MakeNotification({
                    Name = "Teleported",
                    Content = "Teleported to Meteor Shower!",
                    Time = 3
                })
            else
                OrionLib:MakeNotification({
                    Name = "Error",
                    Content = "No meteor shower active!",
                    Time = 3
                })
            end
        end)
    end
})

-- Combat Tab
local CombatTab = Window:MakeTab({
    Name = "⚔️ Combat",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

CombatTab:AddToggle({
    Name = "Mob Aura",
    Default = false,
    Callback = function(value)
        _G.AstaBSS.MobAura = value
        
        if value then
            spawn(function()
                while _G.AstaBSS.MobAura do
                    wait(0.1)
                    
                    pcall(function()
                        if Workspace:FindFirstChild("Monsters") then
                            for _, mob in pairs(Workspace.Monsters:GetChildren()) do
                                if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                                    if mob:FindFirstChild("HumanoidRootPart") then
                                        local distance = (HumanoidRootPart.Position - mob.HumanoidRootPart.Position).Magnitude
                                        if distance < 50 then
                                            -- Damage mob (you'll need to find the correct remote)
                                            mob.Humanoid.Health = 0
                                        end
                                    end
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end
})

CombatTab:AddButton({
    Name = "Kill All Mobs",
    Callback = function()
        local count = 0
        pcall(function()
            if Workspace:FindFirstChild("Monsters") then
                for _, mob in pairs(Workspace.Monsters:GetChildren()) do
                    if mob:FindFirstChild("Humanoid") then
                        mob.Humanoid.Health = 0
                        count = count + 1
                    end
                end
            end
        end)
        
        OrionLib:MakeNotification({
            Name = "Combat",
            Content = "Killed " .. count .. " mobs!",
            Time = 3
        })
    end
})

-- Misc Tab
local MiscTab = Window:MakeTab({
    Name = "⚙️ Misc",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

MiscTab:AddToggle({
    Name = "Auto Dispensers",
    Default = false,
    Callback = function(value)
        _G.AstaBSS.AutoDispenser = value
        
        if value then
            spawn(function()
                while _G.AstaBSS.AutoDispenser do
                    wait(60)
                    
                    pcall(function()
                        local dispensers = {
                            "Treat Dispenser",
                            "Strawberry Dispenser", 
                            "Coconut Dispenser",
                            "Glue Dispenser",
                            "Blueberry Dispenser",
                            "Royal Jelly Dispenser"
                        }
                        
                        for _, dispenser in pairs(dispensers) do
                            if ReplicatedStorage:FindFirstChild("Events") then
                                local toyEvent = ReplicatedStorage.Events:FindFirstChild("ToyEvent")
                                if toyEvent then
                                    toyEvent:FireServer(dispenser)
                                    wait(0.5)
                                end
                            end
                        end
                    end)
                end
            end)
        end
    end
})

MiscTab:AddSlider({
    Name = "Walk Speed",
    Min = 16,
    Max = 200,
    Default = 16,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 5,
    Callback = function(value)
        pcall(function()
            Humanoid.WalkSpeed = value
        end)
    end
})

MiscTab:AddSlider({
    Name = "Jump Power",
    Min = 50,
    Max = 200,
    Default = 50,
    Color = Color3.fromRGB(255, 255, 255),
    Increment = 5,
    Callback = function(value)
        pcall(function()
            Humanoid.JumpPower = value
        end)
    end
})

MiscTab:AddToggle({
    Name = "God Mode",
    Default = false,
    Callback = function(value)
        pcall(function()
            if value then
                Humanoid.MaxHealth = math.huge
                Humanoid.Health = math.huge
            else
                Humanoid.MaxHealth = 100
                Humanoid.Health = 100
            end
        end)
    end
})

MiscTab:AddButton({
    Name = "Remove Fog",
    Callback = function()
        pcall(function()
            game:GetService("Lighting").FogEnd = 100000
            OrionLib:MakeNotification({
                Name = "Visual",
                Content = "Fog removed!",
                Time = 2
            })
        end)
    end
})

MiscTab:AddButton({
    Name = "Full Bright",
    Callback = function()
        pcall(function()
            local lighting = game:GetService("Lighting")
            lighting.Brightness = 2
            lighting.ClockTime = 14
            lighting.GlobalShadows = false
            lighting.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
            
            OrionLib:MakeNotification({
                Name = "Visual",
                Content = "Full bright enabled!",
                Time = 2
            })
        end)
    end
})

-- Teleport Tab
local TeleportTab = Window:MakeTab({
    Name = "📍 Teleports",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

local Teleports = {
    ["Hive"] = CFrame.new(-8, 4, 354),
    ["Blue HQ"] = CFrame.new(290, 5, 91),
    ["Red HQ"] = CFrame.new(-328, 21, 244),
    ["Pro Shop"] = CFrame.new(165, 69, -161),
    ["Mountain Top"] = CFrame.new(76, 176, -181),
    ["Black Bear"] = CFrame.new(-258, 5, 299),
    ["Brown Bear"] = CFrame.new(289, 46, 236),
    ["Panda Bear"] = CFrame.new(106, 35, 50),
    ["Polar Bear"] = CFrame.new(-106, 119, -77),
    ["Science Bear"] = CFrame.new(267, 103, 20),
    ["Ant Challenge"] = CFrame.new(91, 32, 492),
    ["Stick Bug"] = CFrame.new(202, 40, -34),
    ["Wind Shrine"] = CFrame.new(-415, 96, 519)
}

for name, cframe in pairs(Teleports) do
    TeleportTab:AddButton({
        Name = name,
        Callback = function()
            pcall(function()
                HumanoidRootPart.CFrame = cframe
                OrionLib:MakeNotification({
                    Name = "Teleported",
                    Content = "Teleported to " .. name,
                    Time = 2
                })
            end)
        end
    })
end

-- Credits Tab
local CreditsTab = Window:MakeTab({
    Name = "ℹ️ Info",
    Icon = "rbxassetid://4483345998",
    PremiumOnly = false
})

CreditsTab:AddParagraph("AstaBSS v2.0","Advanced Bee Swarm Simulator Script for Delta Executor")
CreditsTab:AddParagraph("Features","• Auto Farm with Token Collection\n• Meteor Shower Farming\n• Mob Aura\n• Auto Dispensers\n• Character Mods\n• Quick Teleports")

-- Initialize
OrionLib:Init()

print("[AstaBSS] Script loaded successfully!")
print("[AstaBSS] Version 2.0")
print("[AstaBSS] Using Orion Library")

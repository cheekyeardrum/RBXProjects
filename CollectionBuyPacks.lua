-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window
local Window = Rayfield:CreateWindow({
   Name = "Auto-Buy GUI",
   LoadingTitle = "Auto Buyer",
   LoadingSubtitle = "by You",
   ConfigurationSaving = {Enabled = true, FolderName = "AutoBuy", FileName = "Config"},
   Discord = {Enabled = false},
   KeySystem = false
})

-- Services
local Player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local vu = game:GetService("VirtualUser")

local brks = RS:WaitForChild("Remotes"):WaitForChild("InfoFunction")
local packs = {"Starter Pack","Electric Pack","Twins Pack","Blood Pack","Toxic Pack","Circuit Pack","Grass Pack","Rock Pack","Waterfall Pack","Volcano Pack"}
local tools = {"BuyPSATool 6","BuyPSATool 7"}

-- Sound
local s = Instance.new("Sound", workspace)
s.SoundId = "rbxassetid://9118828692"
s.Volume = 1.2

-- Tabs
local MainTab = Window:CreateTab("Main", 4483362458)

-- Packs Button
local PacksStatus = MainTab:CreateLabel("Packs Status: Idle")
local PacksProgressBG = Instance.new("Frame")
PacksProgressBG.BackgroundColor3 = Color3.fromRGB(40,40,40)
PacksProgressBG.BorderSizePixel = 0
PacksProgressBG.Size = UDim2.new(1,0,0,20)
PacksProgressBG.Position = UDim2.new(0,0,0,0)
PacksProgressBG.Parent = MainTab.ElementHolder

local PacksProgressBar = Instance.new("Frame")
PacksProgressBar.BackgroundColor3 = Color3.fromRGB(50,200,50)
PacksProgressBar.BorderSizePixel = 0
PacksProgressBar.Size = UDim2.new(0,0,1,0)
PacksProgressBar.Position = UDim2.new(0,0,0,0)
PacksProgressBar.Parent = PacksProgressBG
PacksProgressBar.ZIndex = PacksProgressBG.ZIndex + 1

local function UpdatePacksProgress(percent)
    PacksProgressBar.Size = UDim2.new(percent,0,1,0)
end

local function BuyPacksLoop()
    task.spawn(function()
        while true do
            PacksStatus:Set("Packs Status: Buying...")
            for _,v in ipairs(packs) do
                for i=1,20 do
                    pcall(function() brks:InvokeServer("BuyBoosterPack",v) end)
                    s:Play()
                    task.wait(0.05)
                end
            end
            -- 5 min countdown with progress bar
            for i = 0,300 do
                UpdatePacksProgress(i/300)
                PacksStatus:Set("Packs Status: Waiting... ("..(300-i).."s)")
                task.wait(1)
            end
            UpdatePacksProgress(0)
        end
    end)
end

MainTab:CreateButton({
    Name = "Start Pack Auto-Buy (5 min)",
    Callback = function()
        BuyPacksLoop()
    end
})

-- Tools Button
local ToolsStatus = MainTab:CreateLabel("Tools Status: Idle")
local ToolsProgressBG = Instance.new("Frame")
ToolsProgressBG.BackgroundColor3 = Color3.fromRGB(40,40,40)
ToolsProgressBG.BorderSizePixel = 0
ToolsProgressBG.Size = UDim2.new(1,0,0,20)
ToolsProgressBG.Position = UDim2.new(0,0,0,30)
ToolsProgressBG.Parent = MainTab.ElementHolder

local ToolsProgressBar = Instance.new("Frame")
ToolsProgressBar.BackgroundColor3 = Color3.fromRGB(50,200,50)
ToolsProgressBar.BorderSizePixel = 0
ToolsProgressBar.Size = UDim2.new(0,0,1,0)
ToolsProgressBar.Position = UDim2.new(0,0,0,0)
ToolsProgressBar.Parent = ToolsProgressBG
ToolsProgressBar.ZIndex = ToolsProgressBG.ZIndex + 1

local function UpdateToolsProgress(percent)
    ToolsProgressBar.Size = UDim2.new(percent,0,1,0)
end

local function BuyToolsLoop()
    task.spawn(function()
        while true do
            ToolsStatus:Set("Tools Status: Buying...")
            for _,v in ipairs(tools) do
                for i=1,20 do
                    pcall(function() brks:InvokeServer("BuyPSATool",v) end)
                    s:Play()
                    task.wait(0.05)
                end
            end
            -- 5 min countdown with progress bar
            for i = 0,300 do
                UpdateToolsProgress(i/300)
                ToolsStatus:Set("Tools Status: Waiting... ("..(300-i).."s)")
                task.wait(1)
            end
            UpdateToolsProgress(0)
        end
    end)
end

MainTab:CreateButton({
    Name = "Start Tools Auto-Buy (5 min)",
    Callback = function()
        BuyToolsLoop()
    end
})

-- Anti-AFK
Player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(0.1)
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)


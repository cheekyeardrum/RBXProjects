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

-- ===== PACKS =====
local packsRunning = false
local packsStatus = MainTab:CreateLabel("Packs Status: Idle")

local packsProgressBG = Instance.new("Frame")
packsProgressBG.BackgroundColor3 = Color3.fromRGB(40,40,40)
packsProgressBG.BorderSizePixel = 0
packsProgressBG.Size = UDim2.new(1,0,0,20)
packsProgressBG.Position = UDim2.new(0,0,0,0)
packsProgressBG.Parent = MainTab.ElementHolder

local packsProgressBar = Instance.new("Frame")
packsProgressBar.BackgroundColor3 = Color3.fromRGB(50,200,50)
packsProgressBar.BorderSizePixel = 0
packsProgressBar.Size = UDim2.new(0,0,1,0)
packsProgressBar.Position = UDim2.new(0,0,0,0)
packsProgressBar.Parent = packsProgressBG
packsProgressBar.ZIndex = packsProgressBG.ZIndex + 1

local function updatePacksProgress(percent)
    packsProgressBar.Size = UDim2.new(percent,0,1,0)
end

local function packsLoop()
    task.spawn(function()
        while packsRunning do
            packsStatus:Set("Packs Status: Buying...")
            for _,v in ipairs(packs) do
                for i=1,20 do
                    pcall(function() brks:InvokeServer("BuyBoosterPack",v) end)
                    s:Play()
                    task.wait(0.05)
                end
            end
            -- countdown 5 mins
            for i=0,300 do
                if not packsRunning then break end
                updatePacksProgress(i/300)
                packsStatus:Set("Packs Status: Waiting... ("..(300-i).."s)")
                task.wait(1)
            end
            updatePacksProgress(0)
        end
        packsStatus:Set("Packs Status: Idle")
        updatePacksProgress(0)
    end)
end

local packsBtn = MainTab:CreateButton({
    Name = "Start Pack Auto-Buy (5 min)",
    Callback = function()
        packsRunning = not packsRunning
        if packsRunning then
            packsBtn:ChangeText("Stop Pack Auto-Buy")
            packsLoop()
        else
            packsBtn:ChangeText("Start Pack Auto-Buy (5 min)")
        end
    end
})

-- ===== TOOLS =====
local toolsRunning = false
local toolsStatus = MainTab:CreateLabel("Tools Status: Idle")

local toolsProgressBG = Instance.new("Frame")
toolsProgressBG.BackgroundColor3 = Color3.fromRGB(40,40,40)
toolsProgressBG.BorderSizePixel = 0
toolsProgressBG.Size = UDim2.new(1,0,0,20)
toolsProgressBG.Position = UDim2.new(0,0,0,30)
toolsProgressBG.Parent = MainTab.ElementHolder

local toolsProgressBar = Instance.new("Frame")
toolsProgressBar.BackgroundColor3 = Color3.fromRGB(50,200,50)
toolsProgressBar.BorderSizePixel = 0
toolsProgressBar.Size = UDim2.new(0,0,1,0)
toolsProgressBar.Position = UDim2.new(0,0,0,0)
toolsProgressBar.Parent = toolsProgressBG
toolsProgressBar.ZIndex = toolsProgressBG.ZIndex + 1

local function updateToolsProgress(percent)
    toolsProgressBar.Size = UDim2.new(percent,0,1,0)
end

local function toolsLoop()
    task.spawn(function()
        while toolsRunning do
            toolsStatus:Set("Tools Status: Buying...")
            for _,v in ipairs(tools) do
                for i=1,20 do
                    pcall(function() brks:InvokeServer("BuyPSATool",v) end)
                    s:Play()
                    task.wait(0.05)
                end
            end
            -- countdown 5 mins
            for i=0,300 do
                if not toolsRunning then break end
                updateToolsProgress(i/300)
                toolsStatus:Set("Tools Status: Waiting... ("..(300-i).."s)")
                task.wait(1)
            end
            updateToolsProgress(0)
        end
        toolsStatus:Set("Tools Status: Idle")
        updateToolsProgress(0)
    end)
end

local toolsBtn = MainTab:CreateButton({
    Name = "Start Tools Auto-Buy (5 min)",
    Callback = function()
        toolsRunning = not toolsRunning
        if toolsRunning then
            toolsBtn:ChangeText("Stop Tools Auto-Buy")
            toolsLoop()
        else
            toolsBtn:ChangeText("Start Tools Auto-Buy (5 min)")
        end
    end
})

-- Anti-AFK
Player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(0.1)
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

end)




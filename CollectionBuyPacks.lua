-- Load Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Create Window
local Window = Rayfield:CreateWindow({
   Name = "Auto-Buy GUI",
   LoadingTitle = "Auto Buyer",
   LoadingSubtitle = "by You",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "AutoBuy",
      FileName = "Config"
   },
   Discord = {
      Enabled = false,
      Invite = "",
      RememberJoins = false
   },
   KeySystem = false
})

-- Services
local Player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local vu = game:GetService("VirtualUser")

local brks = RS:WaitForChild("Remotes"):WaitForChild("InfoFunction")
local packs = {"Starter Pack","Electric Pack","Twins Pack","Blood Pack","Toxic Pack","Circuit Pack","Grass Pack","Rock Pack","Waterfall Pack","Volcano Pack"}
local tools = {"BuyPSATool 6","BuyPSATool 7"}

-- Variables
local toggle = false
local interval = 300

-- Tabs
local MainTab = Window:CreateTab("Main", 4483362458)

-- Toggle
local AutoBuyToggle = MainTab:CreateToggle({
   Name = "Enable Auto-Buy",
   CurrentValue = false,
   Flag = "AutoBuyToggle",
   Callback = function(Value)
       toggle = Value
   end,
})

-- Slider
local IntervalSlider = MainTab:CreateSlider({
   Name = "Interval (seconds)",
   Range = {60, 600},
   Increment = 10,
   Suffix = "s",
   CurrentValue = 300,
   Flag = "IntervalSlider",
   Callback = function(Value)
       interval = Value
   end,
})

-- Sound
local s = Instance.new("Sound", workspace)
s.SoundId = "rbxassetid://9118828692"
s.Volume = 1.2

-- Auto-Buy Loop
task.spawn(function()
    while true do
        if toggle then
            for _,v in ipairs(packs) do
                for i=1,20 do
                    pcall(function() brks:InvokeServer("BuyBoosterPack",v) end)
                    s:Play()
                    task.wait(0.05)
                end
            end
            for _,v in ipairs(tools) do
                for i=1,20 do
                    pcall(function() brks:InvokeServer("BuyPSATool",v) end)
                    s:Play()
                    task.wait(0.05)
                end
            end

            -- Progress "bar" via notifications
            local st = tick()
            repeat
                local percent = math.floor(((tick()-st)/interval)*100)
                Rayfield:Notify({
                   Title = "Auto-Buy Waiting",
                   Content = tostring(percent).."% complete",
                   Duration = 1
                })
                task.wait(1)
            until tick()-st >= interval
        else
            task.wait(1)
        end
    end
end)

-- Anti-AFK
Player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(0.1)
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

-- Auto-Buy GUI + Slider + Anti-AFK
-- Paste this into a file called "autobuy.lua" in your GitHub repo

local Player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local vu = game:GetService("VirtualUser")

-- Remote
local brks = RS:WaitForChild("Remotes"):WaitForChild("InfoFunction")

-- Packs & Tools to Auto-Buy
local packs = {
    "Starter Pack","Electric Pack","Twins Pack","Blood Pack",
    "Toxic Pack","Circuit Pack","Grass Pack","Rock Pack",
    "Waterfall Pack","Volcano Pack"
}
local tools = {"BuyPSATool 6","BuyPSATool 7"}

-- GUI
local sg = Instance.new("ScreenGui", Player.PlayerGui)
sg.Name = "MiniGUI"
local f = Instance.new("Frame", sg)
f.Size = UDim2.new(0,140,0,30)
f.Position = UDim2.new(0,50,0,50)
f.BackgroundColor3 = Color3.fromRGB(25,25,25)
Instance.new("UICorner", f).CornerRadius = UDim.new(0,8)

-- Toggle Button
local toggle = true
local btn = Instance.new("TextButton", f)
btn.Size = UDim2.new(1,0,1,0)
btn.BackgroundColor3 = Color3.fromRGB(100,50,50)
btn.Text = "Buy Auto"
btn.Font = Enum.Font.SourceSans
btn.TextSize = 14
btn.TextColor3 = Color3.new(1,1,1)

-- Slider Indicator
local slider = Instance.new("Frame", btn)
slider.Size = UDim2.new(0.1,0,0.5,0)
slider.Position = UDim2.new(0.85,0,0.25,0)
slider.BackgroundColor3 = Color3.fromRGB(50,200,50)
Instance.new("UICorner", slider).CornerRadius = UDim.new(0,6)

btn.MouseButton1Click:Connect(function()
    toggle = not toggle
    TweenService:Create(slider, TweenInfo.new(0.2), {
        Position = toggle and UDim2.new(0.85,0,0.25,0) or UDim2.new(0.7,0,0.25,0)
    }):Play()
    slider.BackgroundColor3 = toggle and Color3.fromRGB(50,200,50) or Color3.fromRGB(200,50,50)
end)

-- Progress Bar
local barbg = Instance.new("Frame", f)
barbg.Size = UDim2.new(0.9,0,0.15,0)
barbg.Position = UDim2.new(0.05,0,0.82,0)
barbg.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", barbg).CornerRadius = UDim.new(0,5)
local bar = Instance.new("Frame", barbg)
bar.Size = UDim2.new(0,0,1,0)
bar.BackgroundColor3 = Color3.fromRGB(100,200,100)
Instance.new("UICorner", bar).CornerRadius = UDim.new(0,5)

-- Sound Effect
local s = Instance.new("Sound", workspace)
s.SoundId = "rbxassetid://9118828692"
s.Volume = 1.2

-- Auto-Buy Loop
task.spawn(function()
    local interval = 300 -- seconds (5 minutes)
    while true do
        if toggle then
            bar.Size = UDim2.new(0,0,1,0)
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
            local st = tick()
            repeat
                bar.Size = UDim2.new(math.clamp((tick()-st)/interval,0,1),0,1,0)
                RunService.RenderStepped:Wait()
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

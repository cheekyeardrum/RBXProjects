-- Services
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local vu = game:GetService("VirtualUser")

local Player = Players.LocalPlayer
local brks = RS:WaitForChild("Remotes"):WaitForChild("InfoFunction")

-- Packs and Tools
local packs = {"Starter Pack","Electric Pack","Twins Pack","Blood Pack","Toxic Pack","Circuit Pack","Grass Pack","Rock Pack","Waterfall Pack","Volcano Pack"}
local tools = {6, 7} -- numeric IDs from logger

-- Flags
local packsToggle = false
local toolsToggle = false

-- GUI
local sg = Instance.new("ScreenGui", Player.PlayerGui)
sg.Name = "AutoBuyGUI"

-- Draggable frame
local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 220, 0, 130)
mainFrame.Position = UDim2.new(0,50,0,50)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true

-- Title
local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1,0,0,25)
title.Position = UDim2.new(0,0,0,0)
title.Text = "Auto Buy GUI"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(35,35,35)
title.BorderSizePixel = 0
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

-- Helper to create button + progress bar inside mainFrame
local function createButton(name, yPosition)
    local f = Instance.new("Frame", mainFrame)
    f.Size = UDim2.new(0, 200, 0, 50)
    f.Position = UDim2.new(0,10,0,yPosition)
    f.BackgroundColor3 = Color3.fromRGB(40,40,40)
    f.BorderSizePixel = 0

    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(1,0,0.6,0)
    btn.Position = UDim2.new(0,0,0,0)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)

    local barBg = Instance.new("Frame", f)
    barBg.Size = UDim2.new(0.95,0,0.3,0)
    barBg.Position = UDim2.new(0.025,0,0.65,0)
    barBg.BackgroundColor3 = Color3.fromRGB(60,60,60)
    local bar = Instance.new("Frame", barBg)
    bar.Size = UDim2.new(0,0,1,0)
    bar.BackgroundColor3 = Color3.fromRGB(100,200,100)

    return btn, bar
end

-- Buttons stacked neatly
local packsBtn, packsBar = createButton("Auto Buy Packs (5 min)", 30)
local toolsBtn, toolsBar = createButton("Auto Buy Tools (5 min)", 80)

-- Safe loop function with progress bar
local function startLoop(toggleFlagVar, interval, action, bar)
    task.spawn(function()
        while toggleFlagVar do
            action()
            local st = tick()
            repeat
                local progress = math.clamp((tick()-st)/interval,0,1)
                bar.Size = UDim2.new(progress,0,1,0)
                RunService.RenderStepped:Wait()
            until tick()-st >= interval or not toggleFlagVar
            bar.Size = UDim2.new(0,0,1,0)
        end
    end)
end

-- Packs Button
packsBtn.MouseButton1Click:Connect(function()
    packsToggle = not packsToggle
    if packsToggle then
        startLoop(packsToggle, 300, function()
            for _, packName in ipairs(packs) do
                for i = 1, 20 do
                    pcall(function()
                        brks:InvokeServer("BuyBoosterPack", packName)
                    end)
                    task.wait(0.05)
                end
            end
        end, packsBar)
    end
end)

-- Tools Button
toolsBtn.MouseButton1Click:Connect(function()
    toolsToggle = not toolsToggle
    if toolsToggle then
        startLoop(toolsToggle, 300, function()
            for _, toolID in ipairs(tools) do
                for i = 1, 20 do
                    pcall(function()
                        brks:InvokeServer("BuyPSATool", toolID)
                    end)
                    task.wait(0.05)
                end
            end
        end, toolsBar)
    end
end)

-- Anti-AFK
Player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(0.1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

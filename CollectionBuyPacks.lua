-- Services
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local vu = game:GetService("VirtualUser")

local Player = Players.LocalPlayer
local brks = RS:WaitForChild("Remotes"):WaitForChild("InfoFunction")

-- Packs and Tools
local packs = {"Starter Pack","Electric Pack","Twins Pack","Blood Pack","Toxic Pack","Circuit Pack","Grass Pack","Rock Pack","Waterfall Pack","Volcano Pack"}
local tools = {6, 7} -- numeric IDs from logger

-- Flags
local packsToggle = false
local toolsToggle = false
local cashToggle = false

-- GUI
local sg = Instance.new("ScreenGui", Player.PlayerGui)
sg.Name = "AutoBuyGUI"

-- Helper to create button + progress bar
local function createButton(name, position)
    local f = Instance.new("Frame", sg)
    f.Size = UDim2.new(0, 200, 0, 50)
    f.Position = position
    f.BackgroundColor3 = Color3.fromRGB(25,25,25)
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
    barBg.BackgroundColor3 = Color3.fromRGB(40,40,40)
    local bar = Instance.new("Frame", barBg)
    bar.Size = UDim2.new(0,0,1,0)
    bar.BackgroundColor3 = Color3.fromRGB(100,200,100)

    return btn, bar
end

-- Buttons
local packsBtn, packsBar = createButton("Auto Buy Packs (5 min)", UDim2.new(0,50,0,50))
local toolsBtn, toolsBar = createButton("Auto Buy Tools (5 min)", UDim2.new(0,50,0,120))
local cashBtn, cashBar = createButton("Auto Claim Cash (fast)", UDim2.new(0,50,0,190))

-- Safe loop function with progress bar
local function startLoop(toggleFlag, interval, action, bar)
    task.spawn(function()
        while toggleFlag() do
            action()
            local st = tick()
            repeat
                local progress = math.clamp((tick()-st)/interval,0,1)
                bar.Size = UDim2.new(progress,0,1,0)
                RunService.RenderStepped:Wait()
            until tick()-st >= interval or not toggleFlag()
            bar.Size = UDim2.new(0,0,1,0)
        end
    end)
end

-- Packs Button
packsBtn.MouseButton1Click:Connect(function()
    packsToggle = not packsToggle
    if packsToggle then
        startLoop(function() return packsToggle end, 300, function()
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
        startLoop(function() return toolsToggle end, 300, function()
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

-- Cash Button
cashBtn.MouseButton1Click:Connect(function()
    cashToggle = not cashToggle
    if cashToggle then
        startLoop(function() return cashToggle end, 1, function() -- very fast loop
            for _, cash in ipairs(Workspace:WaitForChild("CashFolder"):GetChildren()) do
                local cashTable = cash:FindFirstChild("ClaimData") -- adjust name if different
                if cashTable and cashTable.Value then
                    pcall(function()
                        brks:InvokeServer("ClaimCash", cashTable.Value)
                    end)
                end
            end
        end, cashBar)
    end
end)

-- Anti-AFK
Player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(0.1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

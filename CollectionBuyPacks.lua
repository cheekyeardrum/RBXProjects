-- ✅ Improved Delta-Safe Auto-Buy + Continuous Auto-Open Packs GUI (with adjustable settings)

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local vu = game:GetService("VirtualUser")

local Player = Players.LocalPlayer
local brks = RS:WaitForChild("Remotes"):WaitForChild("InfoFunction")
local InventoryModule = require(RS.Modules:WaitForChild("InventoryModule"))

-- Packs and Tools
local packs = {"Starter Pack","Electric Pack","Twins Pack","Blood Pack","Toxic Pack","Circuit Pack","Grass Pack","Rock Pack","Waterfall Pack","Volcano Pack"}
local tools = {6,7} -- numeric IDs from logger

-- Flags
local packsToggle = false
local toolsToggle = false
local autoCollect = false
local autoOpenToggle = false
local beachToggle = false

-- Adjustable Settings
local packsAtOnce = 3
local cooldownSeconds = 3
local beachCooldown = 600 -- 10 mins default
local beachClicks = 100

-- Helper: find pack in hotbar/backpack
local function findPack(packName)
    local hotbar = Player.PlayerGui.Inventory.HOTBAR
    local bag = Player.PlayerGui.Inventory.BAG
    for i = 1, 10 do
        local slot = hotbar:FindFirstChild("SLOT"..i)
        if slot and slot:FindFirstChild("ItemTemplate") and slot.ItemTemplate:GetAttribute("Name") == packName then
            return slot.ItemTemplate
        end
    end
    for _, item in ipairs(bag:GetChildren()) do
        if item:GetAttribute("Name") == packName then
            return item
        end
    end
    return nil
end

local function equipAndOpen(packName)
    local item = findPack(packName)
    if item then
        InventoryModule.ToggleEquip(item)
        local success, err = pcall(function()
            brks:InvokeServer("OpenBoosterPack", packName, packsAtOnce)
        end)
        if success then
            print("[PackLogger] Opened", packsAtOnce, packName)
        else
            warn("[PackLogger] Failed to open", packName, err)
        end
        task.wait(cooldownSeconds)
    end
end

-- GUI
local sg = Instance.new("ScreenGui", Player.PlayerGui)
sg.Name = "AutoBuyOpenGUI"

local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 260, 0, 350)
mainFrame.Position = UDim2.new(0,50,0,50)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.BorderSizePixel = 0

local title = Instance.new("TextLabel", mainFrame)
title.Size = UDim2.new(1,0,0,25)
title.Position = UDim2.new(0,0,0,0)
title.Text = "Auto Buy + Open GUI"
title.TextColor3 = Color3.new(1,1,1)
title.BackgroundColor3 = Color3.fromRGB(35,35,35)
title.BorderSizePixel = 0
title.Font = Enum.Font.SourceSansBold
title.TextSize = 18

-- Draggable
do
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    title.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then update(dragInput) end
    end)
end

-- Helper to create button + progress bar
local function createButton(name, yPos)
    local f = Instance.new("Frame", mainFrame)
    f.Size = UDim2.new(0, 240, 0, 50)
    f.Position = UDim2.new(0,10,0,yPos)
    f.BackgroundColor3 = Color3.fromRGB(40,40,40)
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

-- Create buttons
local packsBtn, packsBar = createButton("Auto Buy Packs", 30)
local toolsBtn, toolsBar = createButton("Auto Buy Tools", 80)
local autoOpenBtn, autoOpenBar = createButton("Auto Open Packs", 130)
local beachBtn, beachBar = createButton("Beach Event Pack", 180)

-- Adjustable settings GUI
local packsBox = Instance.new("TextBox", mainFrame)
packsBox.Size = UDim2.new(0, 100, 0, 25)
packsBox.Position = UDim2.new(0, 10, 0, 230)
packsBox.PlaceholderText = "Packs per batch"
packsBox.Text = tostring(packsAtOnce)
packsBox.ClearTextOnFocus = false
packsBox.FocusLost:Connect(function()
    local val = tonumber(packsBox.Text)
    if val and val > 0 then packsAtOnce = val end
end)

local cooldownBox = Instance.new("TextBox", mainFrame)
cooldownBox.Size = UDim2.new(0, 100, 0, 25)
cooldownBox.Position = UDim2.new(0, 130, 0, 230)
cooldownBox.PlaceholderText = "Cooldown (s)"
cooldownBox.Text = tostring(cooldownSeconds)
cooldownBox.ClearTextOnFocus = false
cooldownBox.FocusLost:Connect(function()
    local val = tonumber(cooldownBox.Text)
    if val and val >= 0 then cooldownSeconds = val end
end)

-- Loop helper
local function startLoop(flagGetter, interval, action, bar)
    task.spawn(function()
        while flagGetter() do
            action()
            local st = tick()
            repeat
                local progress = math.clamp((tick()-st)/interval,0,1)
                bar.Size = UDim2.new(progress,0,1,0)
                RunService.RenderStepped:Wait()
            until tick()-st >= interval or not flagGetter()
            bar.Size = UDim2.new(0,0,1,0)
        end
    end)
end

-- Auto Buy Packs
packsBtn.MouseButton1Click:Connect(function()
    packsToggle = not packsToggle
    packsBtn.Text = packsToggle and "Auto Buy Packs ON" or "Auto Buy Packs"
    if packsToggle then
        startLoop(function() return packsToggle end, 300, function()
            for _, packName in ipairs(packs) do
                for i = 1, 20 do
                    pcall(function() brks:InvokeServer("BuyBoosterPack", packName) end)
                    task.wait(0.05)
                end
            end
        end, packsBar)
    end
end)

-- Auto Buy Tools
toolsBtn.MouseButton1Click:Connect(function()
    toolsToggle = not toolsToggle
    toolsBtn.Text = toolsToggle and "Auto Buy Tools ON" or "Auto Buy Tools (5 min)"
    if toolsToggle then
        startLoop(function() return toolsToggle end, 300, function()
            for _, toolID in ipairs(tools) do
                for i = 1, 20 do
                    pcall(function() brks:InvokeServer("BuyPSATool", toolID) end)
                    task.wait(0.05)
                end
            end
        end, toolsBar)
    end
end)

-- Auto Open Packs
autoOpenBtn.MouseButton1Click:Connect(function()
    autoOpenToggle = not autoOpenToggle
    autoOpenBtn.Text = autoOpenToggle and "Auto Open ON" or "Auto Open Packs"
    if autoOpenToggle then
        startLoop(function() return autoOpenToggle end, cooldownSeconds, function()
            for _, packName in ipairs(packs) do
                if not autoOpenToggle then break end
                pcall(function()
                    for i = 1, packsAtOnce do
                        equipAndOpen(packName)
                    end
                end)
            end
        end, autoOpenBar)
    end
end)

-- Beach Event Pack
local beachPP = workspace:WaitForChild("Beach Event"):WaitForChild("Main"):WaitForChild("Main"):WaitForChild("ProximityPoint")
beachBtn.MouseButton1Click:Connect(function()
    beachToggle = not beachToggle
    beachBtn.Text = beachToggle and "Beach Event ON" or "Beach Event Pack"
    if beachToggle then
        startLoop(function() return beachToggle end, beachCooldown, function()
            for i = 1, beachClicks do
                pcall(function()
                    local pp = beachPP:FindFirstChildOfClass("ProximityPrompt")
                    if pp then
                        pp:InputHoldBegin()
                        pp:InputHoldEnd()
                    end
                end)
            end
        end, beachBar)
    end
end)

-- Anti-AFK
Player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(0.1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

print("✅ Improved Auto Buy + Open GUI loaded with adjustable settings!")

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

-- Draggable main frame
local mainFrame = Instance.new("Frame", sg)
mainFrame.Size = UDim2.new(0, 220, 0, 300)
mainFrame.Position = UDim2.new(0,50,0,50)
mainFrame.BackgroundColor3 = Color3.fromRGB(25,25,25)
mainFrame.BorderSizePixel = 0

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

-- Manual dragging
do
    local dragging = false
    local dragInput, dragStart, startPos

    local function update(input)
        local delta = input.Position - dragStart
        mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
                                       startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    title.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = mainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    title.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging and dragInput then
            update(dragInput)
        end
    end)
end

-- Helper to create button + progress bar
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

-- Buttons
local packsBtn, packsBar = createButton("Auto Buy Packs (5 min)", 30)
local toolsBtn, toolsBar = createButton("Auto Buy Tools (5 min)", 80)

-- View Packs button
local viewPacksBtn = Instance.new("TextButton", mainFrame)
viewPacksBtn.Size = UDim2.new(1,0,0,25)
viewPacksBtn.Position = UDim2.new(0,0,0,140)
viewPacksBtn.Text = "View Packs"
viewPacksBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
viewPacksBtn.TextColor3 = Color3.new(1,1,1)

-- Open Packs button
local openPacksBtn = Instance.new("TextButton", mainFrame)
openPacksBtn.Size = UDim2.new(1,0,0,25)
openPacksBtn.Position = UDim2.new(0,0,0,170)
openPacksBtn.Text = "Open All Packs"
openPacksBtn.BackgroundColor3 = Color3.fromRGB(70,70,70)
openPacksBtn.TextColor3 = Color3.new(1,1,1)

-- Frame to display pack counts
local packsListFrame = Instance.new("ScrollingFrame", mainFrame)
packsListFrame.Size = UDim2.new(1, -20, 0, 100)
packsListFrame.Position = UDim2.new(0, 10, 0, 200)
packsListFrame.BackgroundColor3 = Color3.fromRGB(40,40,40)
packsListFrame.BorderSizePixel = 0
packsListFrame.CanvasSize = UDim2.new(0,0,0,0)
packsListFrame.Visible = false

local uiLayout = Instance.new("UIListLayout", packsListFrame)
uiLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiLayout.Padding = UDim.new(0,2)

-- Function to populate pack list
local function listPacks()
    -- Clear previous items
    for _, child in ipairs(packsListFrame:GetChildren()) do
        if child:IsA("TextLabel") then child:Destroy() end
    end

    local backpack = Player:WaitForChild("Backpack")
    for _, item in ipairs(backpack:GetChildren()) do
        if type(item.Name) == "string" and item.Name:find("Pack") then
            local count = 1
            local amountObj = item:FindFirstChild("Amount") or item:FindFirstChild("Quantity")
            if amountObj and (amountObj:IsA("IntValue") or amountObj:IsA("NumberValue")) then
                count = amountObj.Value
            end
            local attr = item:GetAttribute("Amount") or item:GetAttribute("Quantity")
            if attr then count = attr end

            local label = Instance.new("TextLabel", packsListFrame)
            label.Size = UDim2.new(1,0,0,20)
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.new(1,1,1)
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Text = item.Name.." x"..count
        end
    end

    -- Update scroll area
    local totalHeight = #packsListFrame:GetChildren() * 22
    packsListFrame.CanvasSize = UDim2.new(0,0,0,totalHeight)
end

viewPacksBtn.MouseButton1Click:Connect(function()
    packsListFrame.Visible = not packsListFrame.Visible
    if packsListFrame.Visible then
        listPacks()
    end
end)

-- Function to open all packs in batches of 3
openPacksBtn.MouseButton1Click:Connect(function()
    local backpack = Player:WaitForChild("Backpack")

    for _, item in ipairs(backpack:GetChildren()) do
        if type(item.Name) == "string" and item.Name:find("Pack") then
            -- Get total quantity of this pack
            local count = 1
            local amountObj = item:FindFirstChild("Amount") or item:FindFirstChild("Quantity")
            if amountObj and (amountObj:IsA("IntValue") or amountObj:IsA("NumberValue")) then
                count = amountObj.Value
            end
            local attr = item:GetAttribute("Amount") or item:GetAttribute("Quantity")
            if attr then count = attr end

            -- Open in batches of 3
            while count > 0 do
                local toOpen = math.min(3, count)
                pcall(function()
                    brks:InvokeServer("OpenBoosterPack", item.Name, toOpen)
                end)
                count = count - toOpen
                task.wait(0.1)
            end
        end
    end
end)

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

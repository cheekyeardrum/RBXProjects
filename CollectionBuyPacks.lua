-- Services
local Player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local vu = game:GetService("VirtualUser")

local brks = RS:WaitForChild("Remotes"):WaitForChild("InfoFunction")
local packs = {"Starter Pack","Electric Pack","Twins Pack","Blood Pack","Toxic Pack","Circuit Pack","Grass Pack","Rock Pack","Waterfall Pack","Volcano Pack"}
local tools = {"BuyPSATool 6","BuyPSATool 7"}

local s = Instance.new("Sound", workspace)
s.SoundId = "rbxassetid://9118828692"
s.Volume = 1.2

-- ===== GUI =====
local screen = Instance.new("ScreenGui", Player:WaitForChild("PlayerGui"))
screen.Name = "AutoBuyGUI"

local frame = Instance.new("Frame", screen)
frame.Size = UDim2.new(0, 300, 0, 180)
frame.Position = UDim2.new(0,50,0,50)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.BorderSizePixel = 0

local function createButton(name, positionY)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 280, 0, 40)
    btn.Position = UDim2.new(0, 10, 0, positionY)
    btn.BackgroundColor3 = Color3.fromRGB(70,70,70)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255,255,255)
    btn.TextSize = 18
    return btn
end

local function createStatusLabel(text, positionY)
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0, 280, 0, 20)
    label.Position = UDim2.new(0, 10, 0, positionY)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(255,255,255)
    label.TextSize = 16
    label.TextXAlignment = Enum.TextXAlignment.Left
    return label
end

local function createProgressBar(positionY)
    local bg = Instance.new("Frame", frame)
    bg.Size = UDim2.new(0, 280, 0, 15)
    bg.Position = UDim2.new(0,10,0,positionY)
    bg.BackgroundColor3 = Color3.fromRGB(50,50,50)

    local bar = Instance.new("Frame", bg)
    bar.Size = UDim2.new(0,0,1,0)
    bar.BackgroundColor3 = Color3.fromRGB(50,200,50)
    return bar
end

-- Packs
local packsBtn = createButton("Start Pack Auto-Buy", 10)
local packsLabel = createStatusLabel("Idle", 55)
local packsBar = createProgressBar(75)
local packsRunning = false

-- Tools
local toolsBtn = createButton("Start Tools Auto-Buy", 105)
local toolsLabel = createStatusLabel("Idle", 150)
local toolsBar = createProgressBar(170)
local toolsRunning = false

-- ===== FUNCTIONS =====
local function buyLoop(list, label, bar, runningFlag)
    task.spawn(function()
        while runningFlag do
            label.Text = "Buying..."
            for _,v in ipairs(list) do
                for i=1,20 do
                    pcall(function() brks:InvokeServer(list==packs and "BuyBoosterPack" or "BuyPSATool", v) end)
                    s:Play()
                    task.wait(0.05)
                end
            end
            for i=0,300 do -- 5 minutes
                if not runningFlag then break end
                bar.Size = UDim2.new(i/300,0,1,0)
                label.Text = "Waiting... ("..(300-i).."s)"
                task.wait(1)
            end
            bar.Size = UDim2.new(0,0,1,0)
        end
        label.Text = "Idle"
        bar.Size = UDim2.new(0,0,1,0)
    end)
end

-- ===== BUTTON CALLBACKS =====
packsBtn.MouseButton1Click:Connect(function()
    packsRunning = not packsRunning
    packsBtn.Text = packsRunning and "Stop Pack Auto-Buy" or "Start Pack Auto-Buy"
    if packsRunning then buyLoop(packs, packsLabel, packsBar, packsRunning) end
end)

toolsBtn.MouseButton1Click:Connect(function()
    toolsRunning = not toolsRunning
    toolsBtn.Text = toolsRunning and "Stop Tools Auto-Buy" or "Start Tools Auto-Buy"
    if toolsRunning then buyLoop(tools, toolsLabel, toolsBar, toolsRunning) end
end)

-- ===== Anti-AFK =====
Player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(0.1)
    vu:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

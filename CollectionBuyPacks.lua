-- Auto-Buy Script (FluxLib Edition) + Live Countdown + Anti-AFK
-- Save this file as "autobuy.lua" in your GitHub repo

-- // Services
local Player = game.Players.LocalPlayer
local RS = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local vu = game:GetService("VirtualUser")

-- // Remote
local brks = RS:WaitForChild("Remotes"):WaitForChild("InfoFunction")

-- // Packs & Tools
local packs = {
    "Starter Pack","Electric Pack","Twins Pack","Blood Pack",
    "Toxic Pack","Circuit Pack","Grass Pack","Rock Pack",
    "Waterfall Pack","Volcano Pack"
}
local tools = {"BuyPSATool 6","BuyPSATool 7"}

-- // State
local toggle = true
local interval = 300 -- default interval (seconds)
local status = "Idle"

-- // Sound Effect
local s = Instance.new("Sound", workspace)
s.SoundId = "rbxassetid://9118828692"
s.Volume = 1.2

-- // FluxLib
local Flux = loadstring(game:HttpGet("https://raw.githubusercontent.com/FluxTeam/FluxLib/main/fluxlib.lua"))()
local win = Flux:Window("Auto-Buy Script", "FluxLib Edition", Color3.fromRGB(255, 110, 48), Enum.KeyCode.LeftControl)
local tab = win:Tab("Main", "http://www.roblox.com/asset/?id=6023426915")

-- Toggle
tab:Toggle("Auto Buy", true, function(t)
    toggle = t
end)

-- Slider
tab:Slider("Interval (sec)", 60, 600, interval, function(v)
    interval = v
end)

-- Button (force one full buy cycle immediately)
tab:Button("Buy Once", function()
    status = "Buying..."
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
    status = "Waiting..."
end)

-- Status Label (with countdown)
local statusLabel = tab:Label("Status: " .. status)

local function updateStatus(text)
    statusLabel:Set("Status: " .. text)
end

-- // Auto-Buy Loop
task.spawn(function()
    while true do
        if toggle then
            status = "Buying..."
            updateStatus(status)

            -- Buy Packs
            for _,v in ipairs(packs) do
                for i=1,20 do
                    pcall(function() brks:InvokeServer("BuyBoosterPack",v) end)
                    s:Play()
                    task.wait(0.05)
                end
            end
            -- Buy Tools
            for _,v in ipairs(tools) do
                for i=1,20 do
                    pcall(function() brks:InvokeServer("BuyPSATool",v) end)
                    s:Play()
                    task.wait(0.05)
                end
            end

            -- Countdown until next cycle
            for i = interval, 1, -1 do
                if not toggle then break end
                updateStatus("Waiting... (" .. i .. "s)")
                task.wait(1)
            end
        else
            updateStatus("Paused")
            task.wait(1)
        end
    end
end)

-- // Anti-AFK
Player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
    task.wait(0.1)
    vu:Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)


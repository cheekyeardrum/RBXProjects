-- CheekyUi.lua
-- Complete UI Library for Roblox

local CheekyUi = {}

-- Default colors
_G.Primary = Color3.fromRGB(35, 35, 35)
_G.Dark = Color3.fromRGB(25, 25, 25)
_G.Third = Color3.fromRGB(85, 170, 255)

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local Mouse = Player:GetMouse()
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Utility function to create rounded corners
local function CreateRounded(frame, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius)
    corner.Parent = frame
end

-- Remove old UI
pcall(function()
    CoreGui:FindFirstChild("CheekyUi") and CoreGui:FindFirstChild("CheekyUi"):Destroy()
end)

-- Window creation
function CheekyUi:Window(opts)
    opts = opts or {}
    local Window = Instance.new("ScreenGui")
    Window.Name = "CheekyUi"
    Window.Parent = CoreGui
    Window.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = opts.Size or UDim2.new(0, 500, 0, 320)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    MainFrame.BackgroundColor3 = _G.Primary
    MainFrame.BackgroundTransparency = 0.05
    CreateRounded(MainFrame, 6)
    MainFrame.Parent = Window

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Size = UDim2.new(1, -10, 0, 30)
    Title.Position = UDim2.new(0, 5, 0, 5)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.Cartoon
    Title.Text = opts.SubTitle or "Cheeky UI"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 16
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = MainFrame

    local TabContainer = Instance.new("Frame")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, 0, 1, -40)
    TabContainer.Position = UDim2.new(0, 0, 0, 35)
    TabContainer.BackgroundTransparency = 1
    TabContainer.Parent = MainFrame

    local TabButtons = Instance.new("Frame")
    TabButtons.Name = "TabButtons"
    TabButtons.Size = UDim2.new(0, opts.TabWidth or 140, 1, 0)
    TabButtons.BackgroundTransparency = 1
    TabButtons.Parent = TabContainer

    local Pages = Instance.new("Frame")
    Pages.Name = "Pages"
    Pages.Size = UDim2.new(1, -(opts.TabWidth or 140), 1, 0)
    Pages.Position = UDim2.new(0, opts.TabWidth or 140, 0, 0)
    Pages.BackgroundTransparency = 1
    Pages.Parent = TabContainer

    local Tabs = {}
    function Tabs:Tab(name)
        local tabBtn = Instance.new("TextButton")
        tabBtn.Size = UDim2.new(1, -10, 0, 30)
        tabBtn.Position = UDim2.new(0, 5, 0, (#TabButtons:GetChildren()) * 35)
        tabBtn.BackgroundColor3 = _G.Dark
        tabBtn.Text = name
        tabBtn.Font = Enum.Font.Cartoon
        tabBtn.TextSize = 14
        tabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
        tabBtn.Parent = TabButtons
        CreateRounded(tabBtn, 5)

        local Page = Instance.new("Frame")
        Page.Size = UDim2.new(1, 0, 1, 0)
        Page.BackgroundTransparency = 1
        Page.Visible = false
        Page.Parent = Pages

        -- Show first tab by default
        if #Pages:GetChildren() == 0 then
            Page.Visible = true
        end

        tabBtn.MouseButton1Click:Connect(function()
            for _, p in pairs(Pages:GetChildren()) do
                p.Visible = false
            end
            Page.Visible = true
        end)

        local mainElements = {}

        -- Button
        function mainElements:Button(text, callback)
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, -10, 0, 30)
            btn.Position = UDim2.new(0, 5, 0, #Page:GetChildren() * 35)
            btn.BackgroundColor3 = _G.Dark
            btn.Text = text
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.Cartoon
            btn.TextSize = 14
            btn.Parent = Page
            CreateRounded(btn, 5)
            btn.MouseButton1Click:Connect(callback)
        end

        -- Label
        function mainElements:Label(text)
            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -10, 0, 20)
            lbl.Position = UDim2.new(0, 5, 0, #Page:GetChildren() * 25)
            lbl.BackgroundTransparency = 1
            lbl.Text = text
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            lbl.Font = Enum.Font.Cartoon
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = Page
        end

        -- Toggle
        function mainElements:Toggle(text, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -10, 0, 25)
            frame.Position = UDim2.new(0, 5, 0, #Page:GetChildren() * 30)
            frame.BackgroundTransparency = 1
            frame.Parent = Page

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundColor3 = _G.Dark
            btn.Text = text.." : "..tostring(default)
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.Cartoon
            btn.TextSize = 14
            btn.Parent = frame
            CreateRounded(btn, 5)

            local state = default
            btn.MouseButton1Click:Connect(function()
                state = not state
                btn.Text = text.." : "..tostring(state)
                callback(state)
            end)
        end

        -- Slider
        function mainElements:Slider(text, min, max, default, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -10, 0, 25)
            frame.Position = UDim2.new(0, 5, 0, #Page:GetChildren() * 30)
            frame.BackgroundTransparency = 1
            frame.Parent = Page

            local lbl = Instance.new("TextLabel")
            lbl.Size = UDim2.new(1, -10, 0, 15)
            lbl.Position = UDim2.new(0, 0, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = text.." : "..tostring(default)
            lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
            lbl.Font = Enum.Font.Cartoon
            lbl.TextSize = 14
            lbl.TextXAlignment = Enum.TextXAlignment.Left
            lbl.Parent = frame

            local bar = Instance.new("Frame")
            bar.Size = UDim2.new(1, 0, 0, 10)
            bar.Position = UDim2.new(0, 0, 0, 15)
            bar.BackgroundColor3 = _G.Dark
            bar.Parent = frame
            CreateRounded(bar, 5)

            local fill = Instance.new("Frame")
            fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
            fill.BackgroundColor3 = _G.Third
            fill.Parent = bar
            CreateRounded(fill, 5)

            local dragging = false
            bar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = true
                end
            end)
            bar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    dragging = false
                end
            end)
            UserInputService.InputChanged:Connect(function(input)
                if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    local relative = math.clamp((Mouse.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X, 0, 1)
                    fill.Size = UDim2.new(relative, 0, 1, 0)
                    local value = math.floor(min + (max - min) * relative)
                    lbl.Text = text.." : "..tostring(value)
                    callback(value)
                end
            end)
        end

        -- Textbox
        function mainElements:Textbox(text, callback)
            local box = Instance.new("TextBox")
            box.Size = UDim2.new(1, -10, 0, 25)
            box.Position = UDim2.new(0, 5, 0, #Page:GetChildren() * 30)
            box.BackgroundColor3 = _G.Dark
            box.Text = text
            box.TextColor3 = Color3.fromRGB(255, 255, 255)
            box.Font = Enum.Font.Cartoon
            box.TextSize = 14
            box.ClearTextOnFocus = false
            box.Parent = Page
            CreateRounded(box, 5)
            box.FocusLost:Connect(function(enter)
                if enter then
                    callback(box.Text)
                end
            end)
        end

        -- Dropdown
        function mainElements:Dropdown(text, options, callback)
            local frame = Instance.new("Frame")
            frame.Size = UDim2.new(1, -10, 0, 25)
            frame.Position = UDim2.new(0, 5, 0, #Page:GetChildren() * 30)
            frame.BackgroundTransparency = 1
            frame.Parent = Page

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 1, 0)
            btn.BackgroundColor3 = _G.Dark
            btn.Text = text.." : "..options[1]
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.Font = Enum.Font.Cartoon
            btn.TextSize = 14
            btn.Parent = frame
            CreateRounded(btn, 5)

            local open = false
            local dropFrame = Instance.new("Frame")
            dropFrame.Size = UDim2.new(1, 0, 0, #options*25)
            dropFrame.Position = UDim2.new(0, 0, 1, 0)
            dropFrame.BackgroundColor3 = _G.Dark
            dropFrame.Visible = false
            dropFrame.Parent = frame
            CreateRounded(dropFrame, 5)

            for i, opt in ipairs(options) do
                local optBtn = Instance.new("TextButton")
                optBtn.Size = UDim2.new(1, 0, 0, 25)
                optBtn.Position = UDim2.new(0, 0, 0, (i-1)*25)
                optBtn.BackgroundColor3 = _G.Dark
                optBtn.Text = opt
                optBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                optBtn.Font = Enum.Font.Cartoon
                optBtn.TextSize = 14
                optBtn.Parent = dropFrame
                optBtn.MouseButton1Click:Connect(function()
                    btn.Text = text.." : "..opt
                    dropFrame.Visible = false
                    open = false
                    callback(opt)
                end)
            end

            btn.MouseButton1Click:Connect(function()
                open = not open
                dropFrame.Visible = open
            end)
        end

        -- Separator
        function mainElements:Separator(text)
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, -10, 0, 1)
            line.Position = UDim2.new(0, 5, 0, #Page:GetChildren() * 15)
            line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            line.BackgroundTransparency = 0.5
            line.Parent = Page

            if text then
                local lbl = Instance.new("TextLabel")
                lbl.Size = UDim2.new(1, -10, 0, 15)
                lbl.Position = UDim2.new(0, 5, 0, #Page:GetChildren() * 15)
                lbl.BackgroundTransparency = 1
                lbl.Text = text
                lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
                lbl.Font = Enum.Font.Cartoon
                lbl.TextSize = 14
                lbl.TextXAlignment = Enum.TextXAlignment.Left
                lbl.Parent = Page
            end
        end

        -- Line
        function mainElements:Line()
            local line = Instance.new("Frame")
            line.Size = UDim2.new(1, -10, 0, 2)
            line.Position = UDim2.new(0, 5, 0, #Page:GetChildren() * 20)
            line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            line.BackgroundTransparency = 0.5
            line.Parent = Page
        end

        return mainElements
    end

    return Tabs
end

return CheekyUi

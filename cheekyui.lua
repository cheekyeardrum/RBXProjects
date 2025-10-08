-- CheekyUi Library (Complete Version)
-- Fully working, fixed and ready for use

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local CheekyUi = {}
local Player = Players.LocalPlayer

-- Default colors
_G.Primary = _G.Primary or Color3.fromRGB(30, 30, 30)
_G.Third = _G.Third or Color3.fromRGB(80, 80, 80)
_G.Dark = _G.Dark or Color3.fromRGB(15, 15, 15)

-- Main frame
local MainFrame = Instance.new("ScreenGui")
MainFrame.Name = "CheekyUi"
MainFrame.Parent = Player:WaitForChild("PlayerGui")
MainFrame.ResetOnSpawn = false

local MainFramePage = Instance.new("Frame")
MainFramePage.Name = "MainFramePage"
MainFramePage.Size = UDim2.new(0, 300, 0, 400)
MainFramePage.Position = UDim2.new(0.5, -150, 0.5, -200)
MainFramePage.BackgroundColor3 = _G.Primary
MainFramePage.ClipsDescendants = true
MainFramePage.Parent = MainFrame

local function CreateRounded(inst, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	corner.Parent = inst
end

local main = {}

-- ==========================
-- BUTTON
-- ==========================
function main:Button(text, callback)
	local Button = Instance.new("TextButton")
	Button.Size = UDim2.new(1, -10, 0, 35)
	Button.Position = UDim2.new(0, 5, 0, #MainFramePage:GetChildren()*40)
	Button.BackgroundColor3 = _G.Third
	Button.Text = text
	Button.Font = Enum.Font.GothamBold
	Button.TextSize = 14
	Button.TextColor3 = Color3.fromRGB(255, 255, 255)
	Button.Parent = MainFramePage
	CreateRounded(Button, 5)

	Button.MouseButton1Click:Connect(function()
		pcall(callback)
	end)
end

-- ==========================
-- TOGGLE
-- ==========================
function main:Toggle(text, config, desc, callback)
	config = config or false
	local toggled = config

	local Button = Instance.new("Frame")
	Button.Size = UDim2.new(1, -10, 0, 35)
	Button.Position = UDim2.new(0, 5, 0, #MainFramePage:GetChildren()*40)
	Button.BackgroundTransparency = 1
	Button.Parent = MainFramePage

	local Title = Instance.new("TextLabel")
	Title.Text = text
	Title.Size = UDim2.new(0.7, 0, 1, 0)
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 14
	Title.TextColor3 = Color3.fromRGB(255,255,255)
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Button

	if desc then
		local Desc = Instance.new("TextLabel")
		Desc.Text = desc
		Desc.Size = UDim2.new(0.7, 0, 1, 0)
		Desc.Position = UDim2.new(0, 0, 0, 18)
		Desc.BackgroundTransparency = 1
		Desc.Font = Enum.Font.Gotham
		Desc.TextSize = 11
		Desc.TextColor3 = Color3.fromRGB(180,180,180)
		Desc.TextXAlignment = Enum.TextXAlignment.Left
		Desc.Parent = Button
	end

	local ToggleFrame = Instance.new("Frame")
	ToggleFrame.Size = UDim2.new(0, 35, 0, 20)
	ToggleFrame.Position = UDim2.new(1, -40, 0, 7)
	ToggleFrame.BackgroundColor3 = _G.Dark
	ToggleFrame.Parent = Button
	CreateRounded(ToggleFrame, 10)

	local Circle = Instance.new("Frame")
	Circle.Size = UDim2.new(0, 14, 0, 14)
	Circle.Position = UDim2.new(0, 3, 0, 3)
	Circle.BackgroundColor3 = Color3.fromRGB(255,255,255)
	Circle.Parent = ToggleFrame
	CreateRounded(Circle, 10)

	local function UpdateToggle(state)
		if state then
			Circle:TweenPosition(UDim2.new(0, 18, 0, 3), "Out", "Sine", 0.2, true)
			ToggleFrame.BackgroundColor3 = _G.Third
		else
			Circle:TweenPosition(UDim2.new(0, 3, 0, 3), "Out", "Sine", 0.2, true)
			ToggleFrame.BackgroundColor3 = _G.Dark
		end
	end

	ToggleFrame.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			toggled = not toggled
			UpdateToggle(toggled)
			pcall(callback, toggled)
		end
	end)

	UpdateToggle(toggled)
	if toggled then
		pcall(callback, toggled)
	end
end

-- ==========================
-- DROPDOWN
-- ==========================
function main:Dropdown(text, options, default, callback)
	local Drop = Instance.new("Frame")
	Drop.Size = UDim2.new(1, -10, 0, 35)
	Drop.Position = UDim2.new(0, 5, 0, #MainFramePage:GetChildren()*40)
	Drop.BackgroundColor3 = _G.Third
	Drop.Parent = MainFramePage
	CreateRounded(Drop, 5)

	local Title = Instance.new("TextLabel")
	Title.Text = text
	Title.Size = UDim2.new(0.6, 0, 1, 0)
	Title.BackgroundTransparency = 1
	Title.Font = Enum.Font.GothamBold
	Title.TextSize = 14
	Title.TextColor3 = Color3.fromRGB(255,255,255)
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Drop

	local Current = Instance.new("TextLabel")
	Current.Text = default or options[1]
	Current.Size = UDim2.new(0.3, 0, 1, 0)
	Current.Position = UDim2.new(0.7, 0, 0, 0)
	Current.BackgroundTransparency = 1
	Current.Font = Enum.Font.GothamBold
	Current.TextSize = 14
	Current.TextColor3 = Color3.fromRGB(255,255,255)
	Current.TextXAlignment = Enum.TextXAlignment.Right
	Current.Parent = Drop

	local DropFrame = Instance.new("Frame")
	DropFrame.Size = UDim2.new(1, 0, 0, 0)
	DropFrame.Position = UDim2.new(0,0,1,0)
	DropFrame.BackgroundColor3 = _G.Dark
	DropFrame.ClipsDescendants = true
	DropFrame.Parent = Drop
	CreateRounded(DropFrame, 5)

	local Open = false
	Drop.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			Open = not Open
			local goal = {Size = Open and UDim2.new(1,0,#options*30,0) or UDim2.new(1,0,0,0)}
			TweenService:Create(DropFrame, TweenInfo.new(0.2), goal):Play()
		end
	end)

	for i, v in pairs(options) do
		local Option = Instance.new("TextButton")
		Option.Size = UDim2.new(1, 0, 0, 30)
		Option.Position = UDim2.new(0,0,(i-1)*30,0)
		Option.Text = v
		Option.BackgroundTransparency = 1
		Option.TextColor3 = Color3.fromRGB(255,255,255)
		Option.Font = Enum.Font.Gotham
		Option.TextSize = 14
		Option.Parent = DropFrame

		Option.MouseButton1Click:Connect(function()
			Current.Text = v
			pcall(callback, v)
			Open = false
			TweenService:Create(DropFrame, TweenInfo.new(0.2), {Size=UDim2.new(1,0,0,0)}):Play()
		end)
	end
end

-- ==========================
-- SLIDER
-- ==========================
function main:Slider(text, min, max, default, callback)
	local SliderFrame = Instance.new("Frame")
	SliderFrame.Size = UDim2.new(1, -10, 0, 35)
	SliderFrame.Position = UDim2.new(0, 5, 0, #MainFramePage:GetChildren()*40)
	SliderFrame.BackgroundColor3 = _G.Third
	SliderFrame.Parent = MainFramePage
	CreateRounded(SliderFrame, 5)

	local Label = Instance.new("TextLabel")
	Label.Text = text.." : "..tostring(default)
	Label.Size = UDim2.new(1,0,0,15)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.GothamBold
	Label.TextSize = 14
	Label.TextColor3 = Color3.fromRGB(255,255,255)
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = SliderFrame

	local Bar = Instance.new("Frame")
	Bar.Size = UDim2.new(1, -10, 0, 10)
	Bar.Position = UDim2.new(0,5,0,20)
	Bar.BackgroundColor3 = _G.Dark
	Bar.Parent = SliderFrame
	CreateRounded(Bar, 5)

	local Handle = Instance.new("Frame")
	Handle.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
	Handle.BackgroundColor3 = _G.Primary
	Handle.Parent = Bar
	CreateRounded(Handle, 5)

	local dragging = false
	local function update(input)
		local relative = math.clamp((input.Position.X - Bar.AbsolutePosition.X)/Bar.AbsoluteSize.X,0,1)
		Handle.Size = UDim2.new(relative,0,1,0)
		local val = math.floor(min + (max-min)*relative)
		Label.Text = text.." : "..val
		pcall(callback, val)
	end

	Bar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = true
			update(input)
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			update(input)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragging = false
		end
	end)
end

-- ==========================
-- TEXTBOX
-- ==========================
function main:Textbox(text, placeholder, callback)
	local Box = Instance.new("Frame")
	Box.Size = UDim2.new(1, -10, 0, 35)
	Box.Position = UDim2.new(0, 5, 0, #MainFramePage:GetChildren()*40)
	Box.BackgroundColor3 = _G.Third
	Box.Parent = MainFramePage
	CreateRounded(Box, 5)

	local Label = Instance.new("TextLabel")
	Label.Text = text
	Label.Size = UDim2.new(0.4, 0,1,0)
	Label.BackgroundTransparency = 1
	Label.Font = Enum.Font.GothamBold
	Label.TextSize = 14
	Label.TextColor3 = Color3.fromRGB(255,255,255)
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Box

	local Textbox = Instance.new("TextBox")
	Textbox.PlaceholderText = placeholder or ""
	Textbox.Text = ""
	Textbox.Size = UDim2.new(0.55, 0,1,0)
	Textbox.Position = UDim2.new(0.45,0,0,0)
	Textbox.BackgroundTransparency = 1
	Textbox.Font = Enum.Font.Gotham
	Textbox.TextSize = 14
	Textbox.TextColor3 = Color3.fromRGB(255,255,255)
	Textbox.TextXAlignment = Enum.TextXAlignment.Left
	Textbox.Parent = Box

	Textbox.FocusLost:Connect(function()
		pcall(callback, Textbox.Text)
	end)
end

-- ==========================
-- LABEL
-- ==========================
function main:Label(text)
	local Label = Instance.new("TextLabel")
	Label.Size = UDim2.new(1, -10, 0, 25)
	Label.Position = UDim2.new(0,5,0,#MainFramePage:GetChildren()*30)
	Label.BackgroundTransparency = 1
	Label.Text = text
	Label.Font = Enum.Font.GothamBold
	Label.TextSize = 14
	Label.TextColor3 = Color3.fromRGB(255,255,255)
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = MainFramePage
end

-- ==========================
-- SEPERATOR
-- ==========================
function main:Seperator(text)
	local Sep = Instance.new("Frame")
	Sep.Size = UDim2.new(1, -10, 0, 25)
	Sep.Position = UDim2.new(0,5,0,#MainFramePage:GetChildren()*30)
	Sep.BackgroundTransparency = 1
	Sep.Parent = MainFramePage

	local Line = Instance.new("Frame")
	Line.Size = UDim2.new(1,0,0,1)
	Line.Position = UDim2.new(0,0,0.5,0)
	Line.BackgroundColor3 = _G.Dark
	Line.Parent = Sep

	local Label = Instance.new("TextLabel")
	Label.Text = text
	Label.Size = UDim2.new(1,0,1,0)
	Label.BackgroundTransparency = 1
	Label.TextColor3 = Color3.fromRGB(200,200,200)
	Label.Font = Enum.Font.GothamBold
	Label.TextSize = 12
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = Sep
end

-- ==========================
-- LINE
-- ==========================
function main:Line()
	local Line = Instance.new("Frame")
	Line.Size = UDim2.new(1, -10, 0, 2)
	Line.Position = UDim2.new(0,5,0,#MainFramePage:GetChildren()*25)
	Line.BackgroundColor3 = _G.Dark
	Line.Parent = MainFramePage
end

return main

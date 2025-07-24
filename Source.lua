-- MiniGui Library with Get Key Button
local MiniGui = {}

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LP = Players.LocalPlayer

function MiniGui.Create(titleText, keyRequired, getKeyUrl)
	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "MiniGui"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.Parent = LP:WaitForChild("PlayerGui")

	local Main = Instance.new("Frame")
	Main.Size = UDim2.new(0, 240, 0, 40)
	Main.Position = UDim2.new(0.5, -120, 0.5, -100)
	Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Main.BorderSizePixel = 0
	Main.Active = true
	Main.Draggable = true
	Main.Parent = ScreenGui

	local UICorner = Instance.new("UICorner", Main)
	UICorner.CornerRadius = UDim.new(0, 6)

	local Title = Instance.new("TextLabel")
	Title.Text = titleText or "Mini GUI"
	Title.Font = Enum.Font.GothamBold
	Title.TextColor3 = Color3.new(1,1,1)
	Title.TextSize = 14
	Title.BackgroundTransparency = 1
	Title.Size = UDim2.new(1, -50, 1, 0)
	Title.Position = UDim2.new(0, 5, 0, 0)
	Title.TextXAlignment = Enum.TextXAlignment.Left
	Title.Parent = Main

	local MinBtn = Instance.new("TextButton")
	MinBtn.Text = "-"
	MinBtn.Size = UDim2.new(0, 30, 1, 0)
	MinBtn.Position = UDim2.new(1, -35, 0, 0)
	MinBtn.BackgroundColor3 = Color3.fromRGB(50,50,50)
	MinBtn.TextColor3 = Color3.new(1,1,1)
	MinBtn.Font = Enum.Font.GothamBold
	MinBtn.TextSize = 18
	MinBtn.Parent = Main
	Instance.new("UICorner", MinBtn).CornerRadius = UDim.new(0,6)

	local Container = Instance.new("Frame")
	Container.Name = "Container"
	Container.Position = UDim2.new(0, 0, 1, 0)
	Container.Size = UDim2.new(1, 0, 0, 0)
	Container.BackgroundTransparency = 1
	Container.ClipsDescendants = true
	Container.Parent = Main

	local List = Instance.new("UIListLayout", Container)
	List.Padding = UDim.new(0, 5)

	local open = true
	MinBtn.MouseButton1Click:Connect(function()
		open = not open
		Container.Size = open and UDim2.new(1, 0, 0, List.AbsoluteContentSize.Y) or UDim2.new(1, 0, 0, 0)
	end)

	List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		if open then
			Container.Size = UDim2.new(1, 0, 0, List.AbsoluteContentSize.Y)
		end
	end)

	-- Key system
	if keyRequired then
		ScreenGui.Enabled = false

		local KeyPrompt = Instance.new("TextBox")
		KeyPrompt.PlaceholderText = "Enter Key..."
		KeyPrompt.Text = ""
		KeyPrompt.Size = UDim2.new(0, 200, 0, 30)
		KeyPrompt.Position = UDim2.new(0.5, -100, 0.5, 40)
		KeyPrompt.BackgroundColor3 = Color3.fromRGB(40,40,40)
		KeyPrompt.TextColor3 = Color3.new(1,1,1)
		KeyPrompt.Font = Enum.Font.Gotham
		KeyPrompt.TextSize = 14
		KeyPrompt.Parent = ScreenGui
		Instance.new("UICorner", KeyPrompt).CornerRadius = UDim.new(0, 6)

		local GetKeyBtn = Instance.new("TextButton")
		GetKeyBtn.Text = "Get Key"
		GetKeyBtn.Size = UDim2.new(0, 200, 0, 28)
		GetKeyBtn.Position = UDim2.new(0.5, -100, 0.5, 80)
		GetKeyBtn.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
		GetKeyBtn.TextColor3 = Color3.new(1,1,1)
		GetKeyBtn.Font = Enum.Font.Gotham
		GetKeyBtn.TextSize = 13
		GetKeyBtn.Parent = ScreenGui
		Instance.new("UICorner", GetKeyBtn).CornerRadius = UDim.new(0, 6)

		GetKeyBtn.MouseButton1Click:Connect(function()
			if getKeyUrl then
				setclipboard(getKeyUrl)
				game:GetService("StarterGui"):SetCore("ChatMakeSystemMessage", {
					Text = "Copied Get Key link to clipboard!";
					Color = Color3.fromRGB(0, 200, 255);
				})
			end
		end)

		KeyPrompt.FocusLost:Connect(function(enter)
			if enter and KeyPrompt.Text == keyRequired then
				ScreenGui.Enabled = true
				KeyPrompt:Destroy()
				GetKeyBtn:Destroy()
			else
				KeyPrompt.Text = ""
				KeyPrompt.PlaceholderText = "Wrong Key!"
			end
		end)
	end

	return {
		AddButton = function(text, callback)
			local Btn = Instance.new("TextButton")
			Btn.Size = UDim2.new(1, -10, 0, 26)
			Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
			Btn.TextColor3 = Color3.new(1, 1, 1)
			Btn.Text = text or "Button"
			Btn.Font = Enum.Font.Gotham
			Btn.TextSize = 13
			Btn.BorderSizePixel = 0
			Btn.Parent = Container
			Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

			Btn.MouseButton1Click:Connect(function()
				if callback then pcall(callback) end
			end)
		end,

		AddToggle = function(text, default, callback)
			local state = default or false

			local Btn = Instance.new("TextButton")
			Btn.Size = UDim2.new(1, -10, 0, 26)
			Btn.BackgroundColor3 = state and Color3.fromRGB(0, 200, 0) or Color3.fromRGB(200, 0, 0)
			Btn.TextColor3 = Color3.new(1, 1, 1)
			Btn.Text = (text or "Toggle") .. ": " .. (state and "ON" or "OFF")
			Btn.Font = Enum.Font.Gotham
			Btn.TextSize = 13
			Btn.BorderSizePixel = 0
			Btn.Parent = Container
			Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

			local function update()
				Btn.Text = text .. ": " .. (state and "ON" or "OFF")
				Btn.BackgroundColor3 = state and Color3.fromRGB(0,200,0) or Color3.fromRGB(200,0,0)
				if callback then pcall(callback, state) end
			end

			Btn.MouseButton1Click:Connect(function()
				state = not state
				update()
			end)

			update()
		end
	}
end

return MiniGui

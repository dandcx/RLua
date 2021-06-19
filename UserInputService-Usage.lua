--[[
  Author: Dandcx
  
  Put this script in StarterGui
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")

local player = Players.LocalPlayer
local mouse = player:GetMouse()

local function CreateUI() -- Remove this is you already have the UI
	local UI = Instance.new("ScreenGui")
	local Frame_UI = Instance.new("Frame")
	local Status_UI = Instance.new("TextLabel")
	local MouseLabel_UI = Instance.new("ImageLabel")
	local ButtonFrame = Instance.new("Frame")
	local ButtonImage = Instance.new("ImageLabel")
	local ButtonText = Instance.new("TextLabel")
	local ButtonKey = Instance.new("TextLabel")

	UI.Name = "MainGui"
	UI.Parent = player:WaitForChild("PlayerGui")
	UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	Frame_UI.Parent = UI
	Frame_UI.AnchorPoint = Vector2.new(1, 1)
	Frame_UI.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame_UI.BackgroundTransparency = 1.000
	Frame_UI.Position = UDim2.new(1, 0, 1, 0)
	Frame_UI.Size = UDim2.new(0.2, 0, 0.3, 0)

	Status_UI.Name = "Status"
	Status_UI.Parent = UI
	Status_UI.AnchorPoint = Vector2.new(0.5, 0)
	Status_UI.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Status_UI.BackgroundTransparency = 1.000
	Status_UI.Position = UDim2.new(0.5, 0, 0.8, 0)
	Status_UI.Size = UDim2.new(0, 200, 0, 30)
	Status_UI.Font = Enum.Font.SourceSansSemibold
	Status_UI.Text = "Currently using"
	Status_UI.TextColor3 = Color3.fromRGB(255, 255, 255)
	Status_UI.TextSize = 24.000

	MouseLabel_UI.Name = "MouseLabel"
	MouseLabel_UI.Parent = UI
	MouseLabel_UI.AnchorPoint = Vector2.new(0.5, 0.5)
	MouseLabel_UI.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	MouseLabel_UI.BackgroundTransparency = 1.000
	MouseLabel_UI.Position = UDim2.new(0.5, 0, 0.5, 0)
	MouseLabel_UI.Size = UDim2.new(0, 10, 0, 10)
	MouseLabel_UI.Visible = false
	MouseLabel_UI.Image = "http://www.roblox.com/asset/?id=344616690"

	ButtonFrame.Name = "ButtonFrame"
	ButtonFrame.Parent = script
	ButtonFrame.Parent = game.StarterGui.MainGui.LocalScript
	ButtonFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ButtonFrame.BackgroundTransparency = 1.000
	ButtonFrame.Size = UDim2.new(1, 0, 0.2, 0)
	ButtonFrame:SetAttribute('Order', 1)

	ButtonImage.Name = "ButtonImage"
	ButtonImage.Parent = ButtonFrame
	ButtonImage.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ButtonImage.BackgroundTransparency = 1.000
	ButtonImage.Size = UDim2.new(0.2, 0, 1, 0)
	ButtonImage.Image = "rbxasset://textures/MouseLockedCursor.png"
	ButtonImage.ImageColor3 = Color3.fromRGB(107, 107, 107)
	ButtonImage.ScaleType = Enum.ScaleType.Fit

	ButtonText.Name = "ButtonText"
	ButtonText.Parent = ButtonFrame
	ButtonText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ButtonText.BackgroundTransparency = 1.000
	ButtonText.Position = UDim2.new(0.2, 0, 0, 0)
	ButtonText.Size = UDim2.new(0.8, 0, 1, 0)
	ButtonText.Font = Enum.Font.SourceSansSemibold
	ButtonText.Text = "Mouse left click"
	ButtonText.TextColor3 = Color3.fromRGB(255, 255, 255)
	ButtonText.TextSize = 24.000

	ButtonKey.Name = "ButtonKey"
	ButtonKey.Parent = ButtonFrame
	ButtonKey.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ButtonKey.BackgroundTransparency = 1.000
	ButtonKey.Size = UDim2.new(0.2, 0, 1, 0)
	ButtonKey.Font = Enum.Font.SourceSansSemibold
	ButtonKey.Text = "A"
	ButtonKey.TextColor3 = Color3.fromRGB(255, 255, 255)
	ButtonKey.TextSize = 24.000
	ButtonKey.TextWrapped = true

	return UI, Frame_UI, ButtonFrame, Status_UI
end

local UI, Frame, ButtonFrame, Status = CreateUI()

script.Parent = UI

local Images = {
	['Mouse'] = 'http://www.roblox.com/asset/?id=6671926216',
	['Key'] = 'http://www.roblox.com/asset/?id=6672164480',
	['Menu'] = 'http://www.roblox.com/asset/?id=6672435861'
}

local count = 0

local function getKey(str)
	local key = tostring(str):split('Enum.KeyCode.')[2]
	if key and key ~= 'Unknown' then
		return key
	end
end

local function UpdateUI(text, button, image)
	for i, v in pairs(Frame:GetChildren()) do
		local order = v:GetAttribute('Order')
		v:TweenPosition(UDim2.new(0,0,order*0.2,0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 1, true)
		v:SetAttribute('Order', order + 1)
		for i, ui in  pairs(v:GetChildren()) do
			if not ui:IsA('ImageLabel') then
				TweenService:Create(ui, TweenInfo.new(1), {TextTransparency = order/10}):Play()
			else
				TweenService:Create(ui, TweenInfo.new(1), {ImageTransparency = order/10}):Play()
			end
		end
		if order > 10 then
			v:Destroy()
		end
	end
	count += 1
	local new_ui = ButtonFrame:Clone()
	new_ui.Position = UDim2.new(1,0,0,0)
	new_ui.Parent = Frame
	new_ui:TweenPosition(UDim2.new(0,0,0,0), Enum.EasingDirection.Out, Enum.EasingStyle.Sine, 1, true)
	new_ui.Name = 'ButtonFrame'..tostring(count)
	new_ui.Visible = true
	new_ui.ButtonText.Text = text
	new_ui.ButtonKey.Text = button
	new_ui.ButtonImage.Image = Images[image]
	for i, ui in  pairs(new_ui:GetChildren()) do
		if not ui:IsA('ImageLabel') then
			delay(10, function()
				TweenService:Create(ui, TweenInfo.new(1), {TextTransparency = 1}):Play()
				wait(1)
			end)
		else
			delay(10, function()
				TweenService:Create(ui, TweenInfo.new(1), {ImageTransparency = 1}):Play()
				wait(1)
			end)
		end
	end
	wait(11)
	new_ui:Destroy()
end

local function InputBegan(input,gpe)
	if not gpe then
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			script:SetAttribute('ButtonInUse', 'Left Mouse')
			UpdateUI('Left Mouse clicked','','Mouse')
		elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
			script:SetAttribute('ButtonInUse', 'Right Mouse')
			UpdateUI('Right Mouse clicked','','Mouse')
		elseif input.KeyCode then
			local key = getKey(input.KeyCode)
			if key then
				script:SetAttribute('ButtonInUse', key)
				UpdateUI(key..' Button pressed',key,'Key')
			end
		end
	end
end

local function InputEnded(input, gpe)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		script:SetAttribute('ButtonInUse', nil)
	elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
		script:SetAttribute('ButtonInUse', nil)
	elseif input.KeyCode then
		local key = getKey(input.KeyCode)
		if key and key == script:GetAttribute('ButtonInUse') then
			script:SetAttribute('ButtonInUse', nil)
		end
	end
end

local function InUseButtonChanged()
	local attribute = script:GetAttribute('ButtonInUse')
	if attribute then
		Status.Text = 'Currently using '..attribute
		TweenService:Create(Status, TweenInfo.new(.2), {TextColor3 = Color3.fromRGB(85, 255, 127)}):Play()
	else
		Status.Text = 'Nothing in use'
		TweenService:Create(Status, TweenInfo.new(.2), {TextColor3 = Color3.fromRGB(170,0,0)}):Play()
	end
end

local function MenuOpened()
	script:SetAttribute('ButtonInUse', 'Menu')
	UpdateUI('Menu Opened', '', 'Menu')
end

local function MenuClosed()
	script:SetAttribute('ButtonInUse', nil)
	UpdateUI('Menu Closed', '', 'Menu')
end

script:GetAttributeChangedSignal('ButtonInUse'):Connect(InUseButtonChanged)

UserInputService.InputBegan:Connect(InputBegan)

UserInputService.InputEnded:Connect(InputEnded)

GuiService.MenuOpened:Connect(MenuOpened)

GuiService.MenuClosed:Connect(MenuClosed)

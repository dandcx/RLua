local Players = game:GetService('Players')
local UserInputService = game:GetService('UserInputService')
local TweenService = game:GetService('TweenService')
local RunService = game:GetService('RunService')
local Info = TweenInfo.new()

local Player = Players.LocalPlayer
local mouse = Player:GetMouse()

local AvatarModule = require(script.AvatarModule) -- 7078852592

local SelectedPlayers = {}

local CurrentlyTracking = nil

local function CreateUI()
	local LocalPlayersGui = Instance.new("ScreenGui")
	local SelectedPlayers = Instance.new("Frame")
	local StatusLabel = Instance.new("TextLabel")
	local UIListLayout = Instance.new("UIListLayout")

	--Properties:

	LocalPlayersGui.Name = "LocalPlayersGui"
	LocalPlayersGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

	SelectedPlayers.Name = "SelectedPlayers"
	SelectedPlayers.Parent = LocalPlayersGui
	SelectedPlayers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	SelectedPlayers.BackgroundTransparency = 1.000
	SelectedPlayers.Size = UDim2.new(0, 300, 0, 80)

	UIListLayout.Parent = SelectedPlayers
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 2)
	
	StatusLabel.Name = "StatusLabel"
	StatusLabel.Parent = LocalPlayersGui
	StatusLabel.AnchorPoint = Vector2.new(0.5, 0)
	StatusLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	StatusLabel.BackgroundTransparency = 1.000
	StatusLabel.Position = UDim2.new(0.5, 0, 0.8, 0)
	StatusLabel.Size = UDim2.new(0, 100, 0, 20)
	StatusLabel.Font = Enum.Font.Code
	StatusLabel.Text = "nil"
	StatusLabel.TextColor3 = Color3.fromRGB(255,255,255)
	StatusLabel.TextSize = 12
	StatusLabel.TextTransparency = 0.500
	local Leave = TweenService:Create(StatusLabel, Info, {TextTransparency = 0.5})
	local Enter = TweenService:Create(StatusLabel, Info, {TextTransparency = 0})
	
	StatusLabel.MouseEnter:Connect(function()
		Enter:Play()
	end)
	
	StatusLabel.MouseLeave:Connect(function()
		Leave:Play()
	end)	
	
	LocalPlayersGui.Parent = script

	return LocalPlayersGui, SelectedPlayers, StatusLabel
end

local UI, SelectedPlayersFrame_UI, StatusLabel_UI = CreateUI()

local function CreatePlayerFrame(player)

	local t = {}
	
	local Character = player.Character
	local Humanoid = Character:WaitForChild('Humanoid')

	local PlayerFrame = Instance.new("Frame")
	local Avatar = Instance.new("ViewportFrame")
	local UICorner = Instance.new("UICorner")
	local HealthBar = Instance.new("Frame")
	local Frame = Instance.new("Frame")
	local DestroyButton = Instance.new("ImageButton")
	local TrackButton = Instance.new("ImageButton")
	local TrackingLabel = Instance.new("TextLabel")
	local DisplayName = Instance.new("TextLabel")
	local Username = Instance.new("TextLabel")

	PlayerFrame.Name = player.Name..'Frame'
	PlayerFrame.Parent = SelectedPlayersFrame_UI
	PlayerFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	PlayerFrame.BackgroundTransparency = 1.000
	PlayerFrame.Size = UDim2.new(1, 0, 1, 0)

	Avatar.BackgroundTransparency = 0.500
	Avatar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Avatar.Name = "Avatar"
	Avatar.Parent = PlayerFrame
	Avatar.Position = UDim2.new(0, 5, 0, 5)
	Avatar.Size = UDim2.fromOffset(70,70)
	local AvatarFrame = AvatarModule:Create(player, Avatar)
	local AvatarChar = AvatarFrame.char

	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = Avatar

	HealthBar.Name = "HealthBar"
	HealthBar.Parent = PlayerFrame
	HealthBar.AnchorPoint = Vector2.new(0, 0.5)
	HealthBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HealthBar.BackgroundTransparency = 0.500
	HealthBar.BorderSizePixel = 0
	HealthBar.Position = UDim2.new(0, 100, 0.75, 0)
	HealthBar.Size = UDim2.new(0.5, 0, 0.1, 0)

	Frame.Parent = HealthBar
	Frame.BackgroundColor3 = Color3.fromRGB(170, 0, 0)
	Frame.BorderSizePixel = 0
	Frame.Size = UDim2.new(Humanoid.Health/Humanoid.MaxHealth, 0, 1, 0)

	local function ChangeHealthBarSize(health)
		TweenService:Create(Frame, Info, {Size = UDim2.fromScale(health, 1)}):Play() 
	end

	DestroyButton.Name = "DestroyButton"
	DestroyButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DestroyButton.BackgroundTransparency = 1.000
	DestroyButton.AnchorPoint = Vector2.new(1,0)
	DestroyButton.Position = UDim2.new(1, 0, 0, 0)
	DestroyButton.Size = UDim2.new(0, 30, 0, 30)
	DestroyButton.Image = "rbxassetid://7078969418"
	DestroyButton.ImageTransparency = 0.5
	DestroyButton.Visible = false
	DestroyButton.Parent = PlayerFrame
	
	TrackButton.Name = "TrackButton"
	TrackButton.AnchorPoint = Vector2.new(1, 0)
	TrackButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TrackButton.BackgroundTransparency = 1.000
	TrackButton.Position = UDim2.new(1, 0, 0, 40)
	TrackButton.Size = UDim2.new(0, 30, 0, 30)
	TrackButton.Image = "rbxassetid://7079204859"
	TrackButton.ImageTransparency = 0.500
	TrackButton.Visible = false
	TrackButton.Parent = PlayerFrame

	TrackingLabel.Name = "TrackingLabel"
	TrackingLabel.AnchorPoint = Vector2.new(0, 1)
	TrackingLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TrackingLabel.BackgroundTransparency = 1.000
	TrackingLabel.Position = UDim2.new(0, 70, 1, 0)
	TrackingLabel.Size = UDim2.new(0, 100, 0, 20)
	TrackingLabel.Font = Enum.Font.Nunito
	TrackingLabel.Text = "Tracking"
	TrackingLabel.TextColor3 = Color3.fromRGB(0, 170, 255)
	TrackingLabel.TextSize = 14.000
	TrackingLabel.TextXAlignment = Enum.TextXAlignment.Left
	TrackingLabel.TextYAlignment = Enum.TextYAlignment.Bottom
	TrackingLabel.Visible = false
	TrackingLabel.Parent = PlayerFrame

	DisplayName.Name = "DisplayName"
	DisplayName.Parent = PlayerFrame
	DisplayName.AnchorPoint = Vector2.new(0, 0.5)
	DisplayName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	DisplayName.BackgroundTransparency = 1.000
	DisplayName.Position = UDim2.new(0, 100, 0.25, 0)
	DisplayName.Size = UDim2.new(0.5, 0, 0, 30)
	DisplayName.Font = Enum.Font.Nunito
	DisplayName.Text = player.DisplayName
	DisplayName.TextColor3 = Color3.fromRGB(255, 255, 255)
	DisplayName.TextSize = 20.000
	DisplayName.TextTransparency = 0.3
	DisplayName.TextXAlignment = Enum.TextXAlignment.Left

	Username.Name = "Username"
	Username.Parent = DisplayName
	Username.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Username.BackgroundTransparency = 1.000
	Username.Position = UDim2.new(0, 0, 1, 0)
	Username.Size = UDim2.new(0.5, 0, 0, 10)
	Username.Font = Enum.Font.Nunito
	Username.Text = '@'..player.Name
	Username.TextColor3 = Color3.fromRGB(141, 141, 141)
	Username.TextSize = 14.000
	Username.TextTransparency = 0.3
	Username.TextXAlignment = Enum.TextXAlignment.Left
	
	
	local Events = {}

	local function ConnectEvents()
		DisconnectEvents(Events)
		table.insert(Events,
			Character.DescendantAdded:Connect(function(child)
				wait()
				if child and child.Parent then
					child:Clone().Parent = AvatarChar:FindFirstChild(child.Parent.Name, true)
				end
			end))
		table.insert(Events,Character.DescendantRemoving:Connect(function(child)
			wait()
			if child then
				local d = AvatarChar:FindFirstChild(child.Name, true)
				if d then 
					d:Destroy() 
				end
			end
		end))
		table.insert(Events, Humanoid.HealthChanged:Connect(function()
			ChangeHealthBarSize(Humanoid.Health/Humanoid.MaxHealth)
		end))
	end

	function DisconnectEvents(t)
		for i, v in pairs(t) do
			v:Disconnect()
		end
		table.clear(t)
	end

	local function UpdateChar()
		AvatarChar:Destroy()
		AvatarFrame = AvatarModule:Create(player, Avatar)
		AvatarChar = AvatarFrame.char
	end

	local BindingEvent = player.CharacterAdded:Connect(function(c)
		DisconnectEvents(Events)
		ChangeHealthBarSize(0)
		Character = c
		Humanoid = c:WaitForChild('Humanoid')
		ChangeHealthBarSize(1)
		UpdateChar()
		ConnectEvents()
	end)

	t.PlayerFrame = PlayerFrame
	t.Player = player

	function t:Destroy()
		DisconnectEvents(Events)
		BindingEvent:Disconnect()
		PlayerFrame:Destroy()
		return
	end

	PlayerFrame.MouseEnter:Connect(function()
		PlayerFrame.Size = UDim2.new(1,10,1,10)
		DestroyButton.Visible = true
		TrackButton.Visible = true
	end)

	PlayerFrame.MouseLeave:Connect(function()
		PlayerFrame.Size = UDim2.new(1,0,1,0)
		DestroyButton.Visible = false
		TrackButton.Visible = false
	end)
	
	local DestroyEnter = TweenService:Create(DestroyButton, Info, {ImageColor3 = Color3.fromRGB(255,70,70)})
	local DestroyLeave = TweenService:Create(DestroyButton, Info, {ImageColor3 = Color3.fromRGB(255,255,255)})
	local TrackStart = TweenService:Create(TrackButton, Info, {ImageColor3 = Color3.fromRGB(85, 170, 255)})
	local TrackEnd = TweenService:Create(TrackButton, Info, {ImageColor3 = Color3.fromRGB(255,255,255)})
		
	DestroyButton.MouseEnter:Connect(function()
		DestroyEnter:Play()
	end)

	DestroyButton.MouseLeave:Connect(function()
		DestroyLeave:Play()
	end)

	DestroyButton.MouseButton1Click:Connect(function()
		SelectPlayer(player, false)
	end)
	
	TrackButton.MouseButton1Click:Connect(function()
		if CurrentlyTracking == player then
			CurrentlyTracking = nil
			TrackingLabel.Visible = false
			TrackEnd:Play()
		else
			TrackPlayer(player)
			TrackingLabel.Visible = true
			TrackStart:Play()
		end
	end)

	ConnectEvents()

	PlayerFrame.Parent = SelectedPlayersFrame_UI
	
	return t
end

function FindFrame(t, arg)
	for i, v in pairs(t) do
		if arg:IsA('Frame') and v.PlayerFrame == arg then
			return v, i
		elseif arg:IsA('Player') and v.Player == arg then
			return v, i
		end
	end
end

function SetStatus(status)
	spawn(function()
		assert(status and tostring(status), 'Invalid arguements for function SetStatus')
		local t = string.split(status, '')
		StatusLabel_UI.Text = ''
		local changed = false		
		for i, l in pairs(t) do
			if i == 1 or (t[i-1] and string.split(StatusLabel_UI.Text, '')[#StatusLabel_UI.Text] == t[i-1]) then
				StatusLabel_UI.Text ..= l
			end
			wait()
		end
		local e = StatusLabel_UI:GetPropertyChangedSignal('Text'):Connect(function()
			changed = true
		end)
		delay(3, function()
			if changed == false then
				StatusLabel_UI.Text = ''
				e:Disconnect()
			end
		end)
	end)
end

function TrackPlayer(player)
	local t = {}
	CurrentlyTracking = player
	local Part = Instance.new('Part')
	local Character = player
	Part.Anchored = true
	Part.CanCollide = false
	Part.Size = Vector3.new(0.2,0.2,2)
	Part.Material = Enum.Material.ForceField
	Part.Transparency = 0
	Part.Parent = workspace
	local TrackingEvent = RunService.RenderStepped:Connect(function()
		if not CurrentlyTracking or CurrentlyTracking ~= player then
			t:Stop()
			return
		end
		if not CurrentlyTracking or not Player.Character or not Player.Character:FindFirstChild('Head') or not CurrentlyTracking.Character or not CurrentlyTracking.Character:FindFirstChild('Head') then Part.Transparency = 1 return end
		Part.CFrame = CFrame.lookAt(Player.Character.Head.Position+Vector3.new(0,3,0), player.Character.Head.Position)
	end)
	function t:Stop()
		TrackingEvent:Disconnect()
		Part:Destroy()
		local PlayerFrame = FindFrame(SelectedPlayers, player)['PlayerFrame']
		if t then
			PlayerFrame.TrackingLabel.Visible = false
			PlayerFrame.TrackButton.ImageColor3 = Color3.fromRGB(255,255,255)
		end
		SetStatus('Stopped tracking '..player.Name)
	end
	SetStatus('Tracking '..player.Name)
	return t
end

function SelectPlayer(player, bool)
	if bool == false then -- Remove player
		local PlayerFrame_UI = SelectedPlayersFrame_UI:FindFirstChild(player.Name..'Frame')
		if PlayerFrame_UI then
			local PlayerFrame, index = FindFrame(SelectedPlayers, PlayerFrame_UI)
			if PlayerFrame then
				PlayerFrame:Destroy()
				table.remove(SelectedPlayers, index)
				SetStatus('Removed '..player.Name)
			end
		end
	else -- Insert player
		local PlayerFrame = CreatePlayerFrame(player)
		table.insert(SelectedPlayers, PlayerFrame)
		SetStatus('Added '..player.Name)
	end
end

local function KeyPress(input, gpe)
	if not input or gpe then return end
	if input.KeyCode == Enum.KeyCode.F and mouse.Target then
		local player = Players:GetPlayerFromCharacter(mouse.Target.Parent)
		if player then
			if not FindFrame(SelectedPlayers, player) then
				SelectPlayer(player, true)
			end
		end
	end
	return
end

UserInputService.InputBegan:Connect(KeyPress)

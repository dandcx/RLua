local Players = game:GetService('Players')
local UserInputService = game:GetService('UserInputService')
local RunService = game:GetService('RunService')

local Player = Players.LocalPlayer

local Settings = {
	DefaultSize = Vector3.new(1,1,1),
	BigSize = Vector3.new(5,5,5)
}

local Enabled = false

local Events = {}

local function DisconnectEvents()
	for i, v in pairs(Events) do
		v:Disconnect()
	end
	table.clear(Events)
end

local function GetNotSameTeamList(team)
	local t = {}
	for i, player in pairs(Players:GetPlayers()) do
		if player.Team ~= team then
			table.insert(t, player)
		end
	end
	return t
end

local function SizeHead(player, size)
	local char = player.Character
	if char then
		local head = char:FindFirstChild('Head')
		if head and head.Size ~= size then
			print('Changed '..player.Name.."'s head size")
			head.Size = size
		end
	end
end

local function KeyPress(input, gpe)
	if not input or gpe then return end
	if input.KeyCode == Enum.KeyCode.E then
		Enabled = not Enabled
		if Enabled then
			for i, player in pairs(GetNotSameTeamList(Player.Team)) do
				SizeHead(player, Settings.BigSize)
			end
		else
			for i, player in pairs(Players:GetPlayers()) do
				SizeHead(player, Settings.DefaultSize)
			end
		end
		print('Enabled set to '..tostring(Enabled))
	elseif input.KeyCode == Enum.KeyCode.P then
		print('Destroying..')
		Enabled = false
		DisconnectEvents()
		for i, v in pairs(Players:GetPlayers()) do
			SizeHead(v, Settings.DefaultSize)
		end
		--script:Destroy()
	end
end

local function PlayerAdded(player)
	print(player.Name..' has joined')
	table.insert(Events, player.CharacterAdded:Connect(function()
		wait()
		print(player.Name.."'s character added")
		if player.Team ~= Player.Team and Enabled then
			SizeHead(player, Settings.BigSize)
		end
	end))
	table.insert(Events, player:GetPropertyChangedSignal('Team'):Connect(function()
		wait()
		print(player.Name.."'s team changed")
		if player.Team ~= Player.Team then
			if Enabled then
				SizeHead(player, Settings.BigSize)
			else
				SizeHead(player, Settings.DefaultSize)
			end
		else
			SizeHead(player, Settings.DefaultSize)
		end
	end))
end

for i, player in pairs(Players:GetPlayers()) do
	PlayerAdded(player)
end

table.insert(Events, Players.PlayerAdded:Connect(PlayerAdded))
table.insert(Events, UserInputService.InputBegan:Connect(KeyPress))

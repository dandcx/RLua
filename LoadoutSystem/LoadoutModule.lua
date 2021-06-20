local Players = game:GetService('Players')

local MiscStorage = game:GetService('ServerStorage'):WaitForChild('MiscStorage')

local TeamInfo = MiscStorage:WaitForChild('TeamInfo')
local Config = require(MiscStorage:WaitForChild('Config'))

local Loadout = {}

function Loadout:Setup()
	Players.CharacterAutoLoads = false
	game:GetService('StarterPlayer').LoadCharacterAppearance = false
	script.Name = 'LoadoutModule'
end

local function GetTeamRank(player, module, TeamGroupId)
	if not TeamGroupId then
		return module.Ranks[1]
	end
	local TeamRank = player:GetRankInGroup(TeamGroupId)
	for index, rank in pairs(module.Ranks) do
		if TeamRank and TeamRank == rank.RankId then
			return rank
		end
	end
end

local function GetAccessoriesFromRank(TeamRank)
	local t = {}
	for i, v in pairs(TeamRank.Uniform.Accessories) do
		if tonumber(v) then 
			table.insert(t, v)
			print(v)
		end
	end
	local str = table.concat(t,', ')
	return str
end

local function ToggleTK(tool, bool)
	for index, value in pairs(tool:GetDescendants()) do
		if value:IsA('BoolValue') and string.find(string.lower(value.Name), 'tk') then
			value.Value = bool
		else
			for name, attribte in pairs(value:GetAttributes()) do
				if string.find(string.lower(name), 'tk') then
					print(name)
					value:SetAttribute(name, bool)
				end
			end
		end
	end
end

local function GiveTools(player, tools, TK)
	player.Backpack:ClearAllChildren()
	for i, v in pairs(tools) do
		local tool = Config.ToolStorage:FindFirstChild(v)
		if not tool or not tool:IsA('Tool') then continue end
		local newtool = tool:Clone()
		newtool.Parent = player.Backpack
		coroutine.wrap(ToggleTK)(newtool, TK)
	end
end

local function GiveAccessories(char, accessories)
	local Humanoid = char:WaitForChild('Humanoid')
	for i, v in pairs(accessories) do
		local hat = Config.AccessoryStorage:FindFirstChild(v)
		if hat and not char:FindFirstChild(hat.Name) then
			print(hat)
			Humanoid:AddAccessory(hat:Clone())
		end
	end
end

local function RemoveAccessories(humanoid)
	for i, v in pairs(humanoid:GetAccessories()) do
		v:Destroy()
	end
end

local function CreateHumanoidDescription(player, TeamRank)
	local Description = Players:GetHumanoidDescriptionFromUserId(player.UserId)
	Description.Shirt = TeamRank.Uniform.Shirt
	Description.Pants = TeamRank.Uniform.Pants
	Description.GraphicTShirt = 0
	Description.BackAccessory = ''
	Description.FaceAccessory = ''
	Description.FrontAccessory = ''
	Description.HairAccessory = ''
	Description.HatAccessory = GetAccessoriesFromRank(TeamRank)
	Description.NeckAccessory = ''
	Description.ShouldersAccessory = ''
	Description.WaistAccessory = ''
	Description.Head = 0
	Description.LeftArm = 0
	Description.LeftLeg = 0
	Description.RightArm = 0
	Description.RightLeg = 0
	Description.Torso = 0
	Description.ClimbAnimation = 0
	Description.FallAnimation = 0
	Description.IdleAnimation = 0
	Description.JumpAnimation = 0
	Description.RunAnimation = 0
	Description.SwimAnimation = 0
	Description.WalkAnimation = 0
	return Description
end

local function GetSubGroupRank(player, obj)
	if obj:FindFirstChildOfClass('ModuleScript') then
		for _, sub_obj in pairs(obj:GetChildren()) do
			local sub_mod = require(sub_obj)
			if not sub_mod.GroupId and not sub_mod.Ranks then continue end
			local TeamRank = GetTeamRank(player, sub_mod, sub_mod.TeamGroupId)
			if TeamRank then
				return TeamRank
			end
		end
	end
end

function Loadout:GetRankInfo(player)
	assert(player and player:IsA('Player'), 'Invalid arguements of Player to function GetRankInfo')

	local PlayerInfo = {}

	for i, obj in pairs(TeamInfo:GetChildren()) do
		if not obj or not obj:IsA('ModuleScript')  then continue end
		local module = require(obj)
		if not module.Ranks then continue end
		local TeamRank = GetSubGroupRank(player, obj) or GetTeamRank(player, module, module.GroupId)
		if not TeamRank then continue end
		local index = obj.Name
		PlayerInfo[index] = {}
		PlayerInfo[index].Description = CreateHumanoidDescription(player, TeamRank)
		PlayerInfo[index].RankInfo = TeamRank
	end

	return PlayerInfo
end

function Loadout:LoadCharacterAppearance(player, PlayerInfo, pos)
	assert(player and PlayerInfo, 'Invalid parameters for function LoadCharacterAppearance')
	if not player.Team or not (PlayerInfo[player.Team.Name] or PlayerInfo['Others']) then return end
	local Rank = PlayerInfo[player.Team.Name] or PlayerInfo['Others']
	player:LoadCharacterWithHumanoidDescription(Rank.Description)
	local char = player.Character
	if pos then
		char:SetPrimaryPartCFrame(CFrame.new(pos))
		local ff = char:FindFirstChild('ForceField')
		if ff then
			ff:Destroy()
		end
	end
	coroutine.wrap(GiveAccessories)(char, Rank.RankInfo.Uniform.Accessories)
	coroutine.wrap(GiveTools)(player, Rank.RankInfo.Tools, Rank.RankInfo.TK)
	return char
end

return Loadout

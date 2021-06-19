local TweenService = game:GetService('TweenService')

local module = {}

local function GenChar(char)
	if not char then return end
	char.Archivable = true
	local hum = char:WaitForChild('Humanoid')
	local hrp = char:WaitForChild('HumanoidRootPart')
	local c = char:Clone()
	char.Archivable = false
	for i,v in pairs(c:GetDescendants()) do
		if v:IsA('LocalScript') or v:IsA('Script') then
			v.Disabled = true
			v:Destroy()
		end
	end
	c.Parent = script
	c:WaitForChild('Humanoid').DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	c.PrimaryPart = c:WaitForChild('HumanoidRootPart')
	return c
end

function module:Create(player, ViewportFrame, LightEnabled)
	if not player or (player and not player:IsA('Player')) then warn('1st arguement missing; targetted player instance') return end
	local viewport = ViewportFrame or Instance.new('ViewportFrame')
	local character = player.Character or player.CharacterAdded:Wait()
	local camera = viewport:FindFirstChildOfClass('Camera') or Instance.new('Camera', viewport)
	local char = GenChar(character)
	
	char:SetPrimaryPartCFrame(CFrame.new(0,-2,5))
	camera.CFrame = char.Head.CFrame * CFrame.new(1,.3,-5) 
	camera.CFrame = CFrame.lookAt(camera.CFrame.Position, char.Head.Position)
	camera.FieldOfView = 20
	viewport.CurrentCamera = camera
	char.Parent = viewport
	
	local a = {
		char = char,
		camera = camera,
	}
	
	function a:TweenCameraCFrame(cframe, tweeninfo)
		local tween = TweenService:Create(camera, (tweeninfo or TweenInfo.new(1)), {CFrame = CFrame.lookAt(cframe.Position, char.Head.Position)})
		tween:Play()
		return tween
	end
	
	setmetatable(a, {__index = viewport})
	
	return a
end

return module

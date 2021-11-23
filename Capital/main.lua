-- Made by Dandcx
-- Just to make currency stuff a bit easier

-- feel free to edit but dont resell pls

-- typing

type func = typeof(function() end) -- type function, roblox needs to fix

type capital = { -- set type so i can type this ez
	Owner : Player,
	Value : number,
	Changed : RBXScriptSignal,

	add : func,
	sub : func,
	set : func,
	get : func,
	destroy : func
}

-- services

local Players = game:GetService('Players')

-- datastore

local DataSaver = require(script.Parent:WaitForChild('DataSaver'))
local CapitalStore = DataSaver:GetDataStore('CapitalStore')

-- module

local Capital = {}

Capital.Stores = {}

Capital.IsSetup = Capital.IsSetup or false

-- creates a userdata for holding the data (thought it looked cool)

function Capital.draw(owner : Player, value : number) : capital
	-- containers
	local capital : capital = newproxy(true)
	local proxy = {}
	local meta = getmetatable(capital)
	
	-- events
	local Changed = Instance.new('BindableEvent')
	
	-- internal properties
	proxy.Owner = owner
	proxy.Value = value
	
	-- internal events
	proxy.Changed = Changed.Event
	
	-- internal methods
	function proxy.add(n : number) 
		if type(n) == 'number' then
			proxy.Value += n
			if n ~= 0 then
				Changed:Fire(proxy.Value)
			end
			return proxy.Value
		end
	end
	function proxy.sub(n)
		if type(n) == 'number' then
			proxy.Value -= n 
			if n ~= 0 then
				Changed:Fire(proxy.Value)
			end
			return proxy.Value
		end
	end
	function proxy.set(n)
		if type(n) == 'number' then
			proxy.Value = n
			if n ~= proxy.Value then
				Changed:Fire(proxy.Value)
			end
			return proxy.Value
		end
	end
	function proxy.get() -- kinda useless
		return capital.Value
	end
	function proxy.destroy() -- i dont want this function but theres no other way tbh
		Changed:Destroy()
		table.clear(proxy)
		table.remove(Capital.Stores, owner.UserId)
	end
	
	-- metatable
	meta.__tostring = function(t)
		return t.Value
	end
	meta.__index = proxy
	meta.__metatable = 'This metatable is locked'

	do -- math meta
		
		-- i could make this so using operators on a capital value will actually change the value
		
		-- but that might be annoying
		
		-- i wish they'd add a __tonumber method instead of doing all of this
		
		meta.__add = function(t, v) -- annoying stuff
			if type(t) == 'number' then
				return t + v.Value
			else
				return t.Value + v
			end
		end
		meta.__sub = function(t, v)
			if type(t) == 'number' then
				return t - v.Value
			else
				return t.Value - v
			end
		end
		meta.__mul = function(t, v)
			if type(t) == 'number' then
				return t * v.Value
			else
				return t.Value * v
			end
		end
		meta.__div = function(t, v)
			if type(t) == 'number' then
				return t / v.Value
			else
				return t.Value / v
			end
		end
		meta.__mod = function(t, v)
			if type(t) == 'number' then
				return t % v.Value
			else
				return t.Value % v
			end
		end
		meta.__pow = function(t, v)
			if type(t) == 'number' then
				return t ^ v.Value
			else
				return t.Value ^ v
			end
		end
		meta.__div = function(t, v)
			if type(t) == 'number' then
				return t / v.Value
			else
				return t.Value / v
			end
		end
		meta.__eq = function(t, v)
			if type(t) == 'number' then
				return t == v.Value
			else
				return t.Value == v
			end
		end
		meta.__len = function(t)
			return t.Value
		end
		
		-- i would add __le and __lt but they hurt my head
	end
	
	-- storing
	Capital.Stores[owner.UserId] = capital
	
	return capital
end

-- creates a new capital and saves

function Capital.new(player : Player) : capital
	-- creates new capital
	local capital = Capital.draw(player, 0)
	
	-- saves value
	CapitalStore:SetValue(player.UserId, capital.Value)
	return capital
end

-- to get the player's capital

function Capital.get(player : Player) : capital
	local value = CapitalStore:GetValue(player.UserId)
	-- get capital value
	
	if value then
		-- if saved draw a capital
		return Capital.draw(player, value)
	else
		-- if not saved create new one
		return Capital.new(player)
	end
end

-- i want a better way for this but roblox is strict on garbage collection

function Capital.clear(capital : capital)
	capital.destroy() 
end

-- so it saves when the player rejoins

Players.PlayerRemoving:Connect(function(player)
	local capital = Capital.Stores[player.UserId]
	if capital then-- if a player has an in game capital
		CapitalStore:SetValue(player.UserId, capital.Value) -- save
		Capital.clear(capital) -- remove from server
	end
end)

Capital.IsSetup = true -- not too sure why i have this

return Capital

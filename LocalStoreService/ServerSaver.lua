local DataSaver = require(7544582036) -- is save, check here https://www.roblox.com/library/7975007062/

local ClientSaver = {}

ClientSaver.DataStores = ClientSaver.DataStores or {}
ClientSaver.MemoryStores = ClientSaver.MemoryStores or {}

local Functions = {
	['DataStore'] = function(index)
		local store = ClientSaver.DataStores[index] or DataSaver:GetDataStore(index)
		if store then
			if not ClientSaver.DataStores[index] then
				ClientSaver.DataStores[index] = store
			end
			return true, 'Successfully got datastore.'
		else
			return false, 'Failed to get datastore.'
		end
	end,
	['DataSet'] = function(index, key, value)
		local store = ClientSaver.DataStores[index]
		if store then
			local success = store:SetValue(key, value)
			if success then
				return true, success, 'Successfully set data to '..tostring(key)
			else
				return false, nil, 'Failed to set data to '..tostring(key)
			end
		else
			return nil, nil, 'Failed to get datastore'
		end
	end,
	['DataGet'] = function(index, key)
		local store = ClientSaver.DataStores[index]
		if store then
			local data = store:GetValue(key)
			if data then
				return true, data, 'Successfully got data for '..tostring(key)
			else
				return false, nil, 'Failed to get data for '..tostring(key)
			end
		else
			return nil, nil, 'Failed to get datastore'
		end
	end,
	['MemoryStore'] = function(index)
		local store = ClientSaver.MemoryStores[index] or DataSaver:GetMemoryStore(index)
		if store then
			if ClientSaver.MemoryStores[index] then
				ClientSaver.MemoryStores[index] = store
			end
			return true, 'Successfully got player data.'
		else
			return false, 'Failed to get player data.'
		end
	end,
	['MemoryRead'] = function(index, count)
		local store = ClientSaver.MemoryStores[index]
		if store then
			local data, id = store:ReadValue(count or 1, false, 1)
			if data then
				return true, {data, id}, 'Successfully got data.'
			else
				return false, nil, 'Failed to get data.'
			end
		else
			return nil, nil, 'Failed to get memorystore.'
		end
	end,
	['MemoryAdd'] = function(index, value, experation)
		local store = ClientSaver.MemoryStores[index]
		if store then
			local data = store:AddValue(value, math.clamp(experation, 0, 86400))
			if data then
				return true, data, 'Successfully added data.'
			else
				return false, nil, 'Failed to add data.'
			end
		else
			return nil, nil, 'Failed to get memorystore.'
		end
	end,
	['MemoryRemove'] = function(index, id)
		local store = ClientSaver.MemoryStores[index]
		if store then
			local data = store:RemoveValue(id)
			if data then
				return true, data, 'Successfully removed data.'
			else
				return false, nil, 'Failed to remove data.'
			end
		else
			return nil, nil, 'Failed to get memorystore.'
		end
	end, 
}

local req_counts = {}
local count_cooldown = 0.5
local max_count = 3
local req_cooldown = 0.01
local latest_reqs = {}

local function RecvReq(player, action, ...)
	local index = player.UserId
	if not req_counts[index] then
		req_counts[index] = 0
	end
	local req_count = req_counts[index]
	local last_req = latest_reqs[index]
	local current_req = tick()
	req_counts[index] += 1
	latest_reqs[index] = current_req
	delay(count_cooldown, function()
		req_counts[index] -= 1
	end)
	if not last_req or tick() - last_req > req_cooldown and req_count < max_count then
		local actional = Functions[action]
		if actional then
			return actional('PlayerStore_'..player.UserId, ...)
		else
			return false, nil, 'Incorrect action inputted; '..action
		end
	else
		return false, nil, player.Name..':'..player.UserId..' on cooldown'
	end
end

local Remote = game:GetService('ReplicatedStorage'):WaitForChild('LocalStoreService'):WaitForChild('LSRemote')
Remote.OnServerInvoke = RecvReq

return ClientSaver

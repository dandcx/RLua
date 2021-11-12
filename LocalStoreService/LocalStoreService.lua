local Store = game:GetService('DataStoreService')

local Remote = script:FindFirstChild('LSRemote') or Store:WaitForChild('LSRemote')

local LocalStore = {}

local req_count = 0
local count_cooldown = 0.5
local max_count = 3
local latest_req = 0
local req_cooldown = 0.01
local tpast

local function Request(...)
	local current_req = tick()
	tpast = current_req - latest_req
	latest_req = current_req
	if tpast > req_cooldown or req_count >= max_count then
		local success, data, msg = Remote:InvokeServer(...)
		req_count += 1
		delay(count_cooldown, function()
			req_count -= 1
		end)
		if success then
			return data
		else
			warn(msg)
			return 
		end
	else
		warn('Data request cooldown; '..tostring(req_cooldown-tpast))
		return 
	end
end

function LocalStore:RequestDataStore()
	local Success = Request('DataStore')
	if Success then
		local DataStore = {}
		function DataStore:RequestSet(key, value)
			return Request('DataSet', key, value)
		end

		function DataStore:RequestGet(key)
			return Request('DataGet', key)
		end
		return DataStore
	end
end

function LocalStore:RequestMemoryStore()
	local Success = Request('MemoryStore')
	if Success then
		local MemoryStore = {}
		function MemoryStore:RequestRead(count)
			Request('MemoryRead', count)
		end
		function MemoryStore:RequestAd(value, experation)
			Request('MemoryAdd', value, experation)
		end
		function MemoryStore:RequestRemoveValue(id)
			Request('MemoryRemove', id)
		end
		return MemoryStore
	end
end

Remote.Parent = Store

return LocalStore

--[[ 
	Turn a lua table into variables to execute in a string.
	DISCLAIMER: FUNCTIONS ARE NOT SUPPORTED ONLY GLOBAL FUNCTIONS LIKE 'print()', 'require()' etc. ARE SINCE LUA DOESN'T ALLOW FUNCTIONS TO BE CONVERTED TO STRINGS
]]

local fLoader = {}

function concat(t, i)
	local s = ''
	for i, v in pairs(t) do
		if i == 1 then continue end
		s ..= tostring(v)
	end
	return s
end


function formatvalue(a)
	if type(a) == 'string' then
		return '"'..tostring(a)..'"'
	elseif type(a) == 'number' or type(a) == 'boolean' then
		return tostring(a)
	elseif type(a) == 'table' then
		local s = '{'
		for i, v in pairs(a) do
			s..= '\n	['..formatvalue(i)..'] = '..formatvalue(v)..','
		end
		s..= '\n}'
		print(s)
		return tostring(s)
	elseif typeof(a) == 'Instance' then
		return 'game.'..tostring(a:GetFullName())
	end
end

function formatcode(s, vars)
	local c = '-- Loaded by fLoader\n\n--//Variables//--\n'
	for i, v in pairs(vars) do
		c..= string.gsub(string.gsub('local var = value', 'var', i), 'value', formatvalue(v))..' \n'
	end
	c..= '\n--//Code//--\n'
	c..= s
	c..= '\n\n -- Made by Dandcx'
	print(c)
	return c
end

function fLoader:Load(code, args)
	return loadstring(formatcode(code, args))
end

-- Example

local Code = 'print("Thanks for using fLoader "..tostring(player))\nprint("Made and developed by "..game:GetService("Players"):GetNameFromUserIdAsync(121363098))'

local Variables = {
	['player'] = game:GetService('Players').LocalPlayer or game:GetService('Players'):FindFirstChildOfClass('Player') or ''
}

fLoader:Load(Code, Variables)()

return fLoader

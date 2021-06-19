-- Check if a file is in RLua or base Lua

local function CheckForRLua()
  if game then
    return true
  else
    return false
  end
end

return CheckForRLua

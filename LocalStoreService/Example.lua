local LocalStoreService = require(game:GetService('ReplicatedStorage'):WaitForChild('LocalStoreService'))

local LocalStore = LocalStoreService:RequestDataStore()

LocalStore:RequestSet('key', 'value')

LocalStore:RequestGet('key')

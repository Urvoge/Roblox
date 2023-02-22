--// Urvoge Was Here <3 \\--


--[[

	Changelog:
		02/22/23, 5:18 PM:
			> Started rewrite
			
		02/22/23, 5:26 PM:
			> Added client events
			> Added RequestTeleport()
			
		02/22/23, 5:51 PM:
			> Polished code
			> Fixed bugs

--]]


local Client = {}; do

	--// Variables
	local Event = {}; do Event.__index = Event end

	Client.Player = game.Players.LocalPlayer
	Client.Character = Client.Player.Character or Client.Player.CharacterAdded:Wait()

	Client.WalkSpeed = false
	Client.JumpPower = false

	Client.Events = { 'CharacterAdded', 'HealthChanged', 'Jumped', 'Seated', 'Died' }

	--// Functions
	function Client.new(Character)
		local Humanoid = Character:WaitForChild('Humanoid')

		Client.Character = Character
		Humanoid.WalkSpeed = Client.WalkSpeed and Client.WalkSpeed or Humanoid.WalkSpeed
		Humanoid.JumpPower = Client.JumpPower and Client.JumpPower or Humanoid.JumpPower

		Humanoid:GetPropertyChangedSignal('WalkSpeed'):Connect(function() if Client.WalkSpeed and Humanoid.WalkSpeed ~= Client.WalkSpeed then Humanoid.WalkSpeed = Client.WalkSpeed end end)
		Humanoid:GetPropertyChangedSignal('JumpPower'):Connect(function() if Client.JumpPower and Humanoid.JumpPower ~= Client.JumpPower then Humanoid.JumpPower = Client.JumpPower end end)
	end

	function Client.RequestTeleport(Position, Callback) --> <Position> CFrame, Vector
		local RootPart = Client.Character:FindFirstChild('HumanoidRootPart')
		Callback = Callback or function() end

		if (RootPart) then
			RootPart.CFrame = typeof(Position) == 'CFrame' and Position or CFrame.new(Position)

			Callback(true)
			return
		end

		Callback(false)
	end
	
	
	
	function Client.CreateEventListener(EventName, Callback, Count)
		if not table.find(Client.Events, EventName) then return false, 'Invalid event' end

		Callback = Callback and Callback or function() end
		Count = Count and Count or math.huge

		local OldCallback = Callback
		local Data = { Event = nil, Calls = 0, Connections = { } }

		local Humanoid = Client.Character:FindFirstChild('Humanoid')

		Callback = function(...)
			local Arguments = { ... }

			Data.Calls += 1

			if Data.Event and Data.Calls >= (Count + 1) then
				Callback = nil
				
				if Data.Event then Data.Event:Disconnect() end
				
				for _, Connection in next, Data.Connections do
					Connection:Disconnect()
				end
				
				return
			end
			
			return OldCallback(table.unpack(Arguments))
		end

		local function StartTracking(Character, Ignore)
			if EventName == 'CharacterAdded' and not Ignore then
				Callback(Character)
			elseif EventName == 'HealthChanged' then
				table.insert(Data.Connections, Humanoid.HealthChanged:Connect(Callback))
			elseif EventName == 'Jumped' then
				table.insert(Data.Connections, Humanoid.Jumping:Connect(function(Active) if (Active) then Callback() end end))
			elseif EventName == 'Seated' then
				table.insert(Data.Connections, Humanoid.Seated:Connect(Callback))
			elseif EventName == 'Died' then
				table.insert(Data.Connections, Humanoid.Died:Connect(Callback))
			end
		end

		Data.Event = Client.Player.CharacterAdded:Connect(StartTracking)
		StartTracking(Client.Character, true)

		return setmetatable(Data, Event)
	end

	function Event:Disconnect()
		return self.Event:Disconnect()
	end
	
	Client.new(Client.Character)
	Client.Player.CharacterAdded:Connect(Client.new)

	return Client
end

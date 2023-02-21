-->> Client:AddEventListener(Event, Callback, Count <optional>) -> returns Event
-->> Event:Disconnect() -> Disconnects listener
-->>
-->> CharacterAdded     -> Arguments: None
-->> HealthChanged  	-> Arguments: <float> Health
-->> Jumped         	-> Arguments: None
-->> Seated		-> Arguments: <bool> Active, <BasePart> Seat
-->> Died		-> Arguments: None


local Client = {}; do
    local Event = {}
    Event.__index = Event
	
	-- Variables
	Client.Player = game:GetService("Players").LocalPlayer
	Client.Character = (Client.Player.Character or Client.Player.CharacterAdded:Wait())
	
	Client.WalkSpeed = 16
	Client.JumpPower = 50
	
	Client.Events = {"CharacterAdded", "HealthChanged", "Jumped", "Seated", "Died"}
	
	-- Function
	function Client.new(Character)
		local Humanoid = Character:WaitForChild("Humanoid")
		
		Client.Character = Character
		
		Humanoid.WalkSpeed = Client.WalkSpeed
		Humanoid.JumpPower = Client.JumpPower
		
		Humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function() Humanoid.WalkSpeed = Client.WalkSpeed end)
		Humanoid:GetPropertyChangedSignal("JumpPower"):Connect(function() Humanoid.JumpPower = Client.JumpPower end)
	end

	function Client:Teleport(Position)
		local Root = Client:GetCharacterInstance("HumanoidRootPart")
		Position = typeof(Position) == "Vector3" and CFrame.new(Position) or Position

		assert(Root, "Client.Teleport: Client doesn't have a RootPart")

		Root.CFrame = Position
	end

	function Client:GetCharacterInstance(Object, Player)
		Player = (Player and game.Players[Player] or Client.Player)

		assert(Player, "Client.GetCharacterInstance: Invalid Player")

		if (Player.Character) then
			return Player.Character:FindFirstChild(Object)
		end

		return nil
	end

    function Client:AddEventListener(__Event, Callback, Count)
		assert(table.find(Client.Events, __Event), "Client.AddEventListener: Invalid Event.")
		Callback = (Callback or function() return end)

		local OldCallback = Callback
		local Meta = {Event = nil, Calls = 0}

		Callback = function(...)
			Meta.Calls += 1

			if (Count) and (Meta.Calls >= (Count + 1)) then
				if (Meta.Event) then Meta.Event:Disconnect() end

				return
			end
			
			return OldCallback(...)
		end

		local Character = Client.Character
		local Humanoid = Character:WaitForChild("Humanoid")

		local function Initiate(Character, IsOld)
			local Humanoid = Character:WaitForChild("Humanoid")

			if (__Event == "CharacterAdded") and (not IsOld) then
				Callback()
			elseif (__Event == "HealthChanged") then
				Humanoid.HealthChanged:Connect(Callback)
			elseif (__Event == "Jumped") then
				Humanoid.Jumping:Connect(function(Active) if (Active) then Callback() end end)
			elseif (__Event == "Seated") then
				Humanoid.Seated:Connect(Callback)
			elseif (__Event == "Died") then
				Humanoid.Died:Connect(Callback)
			end
		end

		Initiate(Character, true)
		local CharacterAddedEvent = Client.Player.CharacterAdded:Connect(Initiate)

		Meta.Event = CharacterAddedEvent
		return setmetatable(Meta, Event)
    end

	function Event:Disconnect()
		self.Event:Disconnect()
	end

	-- Initiation
	Client.new(Client.Character)
	Client.Player.CharacterAdded:Connect(Client.new)

	return Client
end

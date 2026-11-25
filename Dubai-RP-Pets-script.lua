local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local event = ReplicatedStorage:WaitForChild("StealOutfit")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "OutfitStealer"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 320, 0, 170)
frame.Position = UDim2.new(0.5, -160, 0.5, -85)
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 40)
title.Text = "👕 Outfit Stealer"
title.TextScaled = true
title.BackgroundTransparency = 1
title.Parent = frame

local textbox = Instance.new("TextBox")
textbox.Size = UDim2.new(0.85, 0, 0, 40)
textbox.Position = UDim2.new(0.075, 0, 0, 50)
textbox.PlaceholderText = "Enter username..."
textbox.Text = ""
textbox.TextScaled = true
textbox.Parent = frame

local button = Instance.new("TextButton")
button.Size = UDim2.new(0.85, 0, 0, 40)
button.Position = UDim2.new(0.075, 0, 0, 100)
button.Text = "STEAL OUTFIT"
button.TextScaled = true
button.Parent = frame

local status = Instance.new("TextLabel")
status.Size = UDim2.new(1, 0, 0, 25)
status.Position = UDim2.new(0, 0, 1, -25)
status.BackgroundTransparency = 1
status.TextScaled = true
status.Text = ""
status.Parent = frame

button.MouseButton1Click:Connect(function()
	local username = textbox.Text

	if username == "" then
		status.Text = "Enter a username!"
		return
	end

	status.Text = "Copying outfit..."
	event:FireServer(username)
end)

event.OnClientEvent:Connect(function(success, message)
	status.Text = message
end)
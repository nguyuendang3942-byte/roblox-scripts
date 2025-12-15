task.wait(1)

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player.PlayerGui)

local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromScale(0.3, 0.1)
btn.Position = UDim2.fromScale(0.35, 0.4)
btn.Text = "FLY ON / OFF"
btn.TextScaled = true

btn.MouseButton1Click:Connect(function()
	print("Bấm nút Fly")
end)

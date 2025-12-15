task.wait(1)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")

-- GUI
local gui = Instance.new("ScreenGui", player.PlayerGui)
local btn = Instance.new("TextButton", gui)
btn.Size = UDim2.fromScale(0.3, 0.1)
btn.Position = UDim2.fromScale(0.35, 0.4)
btn.Text = "FLY: OFF"
btn.TextScaled = true

-- Fly vars
local flying = false
local bv, bg, conn
local speed = 50

local function startFly()
	bv = Instance.new("BodyVelocity", hrp)
	bv.MaxForce = Vector3.new(1e5,1e5,1e5)

	bg = Instance.new("BodyGyro", hrp)
	bg.MaxTorque = Vector3.new(1e5,1e5,1e5)

	conn = RunService.RenderStepped:Connect(function()
		local cam = workspace.CurrentCamera
		local move = Vector3.zero
		if UIS:IsKeyDown(Enum.KeyCode.W) then move += cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.S) then move -= cam.CFrame.LookVector end
		if UIS:IsKeyDown(Enum.KeyCode.A) then move -= cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.D) then move += cam.CFrame.RightVector end
		if UIS:IsKeyDown(Enum.KeyCode.Space) then move += Vector3.new(0,1,0) end
		if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then move -= Vector3.new(0,1,0) end
		if move.Magnitude > 0 then
			bv.Velocity = move.Unit * speed
		else
			bv.Velocity = Vector3.zero
		end
		bg.CFrame = cam.CFrame
	end)
end

local function stopFly()
	if conn then conn:Disconnect() end
	if bv then bv:Destroy() end
	if bg then bg:Destroy() end
end

btn.MouseButton1Click:Connect(function()
	flying = not flying
	if flying then
		btn.Text = "FLY: ON"
		startFly()
	else
		btn.Text = "FLY: OFF"
		stopFly()
	end
end)

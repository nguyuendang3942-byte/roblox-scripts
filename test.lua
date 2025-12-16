--// FULL TOOL GUI
task.wait(1)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

--// GUI
local gui = Instance.new("ScreenGui", lp.PlayerGui)
gui.Name = "MainGUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.3, 0.5)
frame.Position = UDim2.fromScale(0.05, 0.25)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
frame.Active = true
frame.Draggable = true

local function makeBtn(text, y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(0.9, 0.1)
	b.Position = UDim2.fromScale(0.05, y)
	b.Text = text
	b.TextScaled = true
	return b
end

--// FLY
local fly = false
local bv, bg, flyConn

local flyBtn = makeBtn("FLY: OFF", 0.05)
flyBtn.MouseButton1Click:Connect(function()
	fly = not fly
	flyBtn.Text = fly and "FLY: ON" or "FLY: OFF"

	if fly then
		bv = Instance.new("BodyVelocity", hrp)
		bv.MaxForce = Vector3.new(1e5,1e5,1e5)

		bg = Instance.new("BodyGyro", hrp)
		bg.MaxTorque = Vector3.new(1e5,1e5,1e5)

		flyConn = RunService.RenderStepped:Connect(function()
			local cam = workspace.CurrentCamera
			local dir = Vector3.zero
			if UIS:IsKeyDown(Enum.KeyCode.W) then dir += cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then dir -= cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then dir -= cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then dir += cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.Space) then dir += Vector3.new(0,1,0) end
			if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then dir -= Vector3.new(0,1,0) end

			bv.Velocity = dir.Magnitude > 0 and dir.Unit * 50 or Vector3.zero
			bg.CFrame = cam.CFrame
		end)
	else
		if flyConn then flyConn:Disconnect() end
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end)

--// NOCLIP
local noclip = false
local noclipBtn = makeBtn("NOCLIP: OFF", 0.17)

noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = noclip and "NOCLIP: ON" or "NOCLIP: OFF"
end)

RunService.Stepped:Connect(function()
	if noclip and char then
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide = false end
		end
	end
end)

--// ESP (NAME)
local esp = false
local espBtn = makeBtn("ESP NAME: OFF", 0.29)

local function addESP(p)
	if p.Character and p.Character:FindFirstChild("Head") and not p.Character.Head:FindFirstChild("ESP") then
		local bill = Instance.new("BillboardGui", p.Character.Head)
		bill.Name = "ESP"
		bill.Size = UDim2.new(0,100,0,40)
		bill.AlwaysOnTop = true

		local txt = Instance.new("TextLabel", bill)
		txt.Size = UDim2.fromScale(1,1)
		txt.BackgroundTransparency = 1
		txt.Text = p.Name
		txt.TextColor3 = Color3.new(1,0,0)
		txt.TextScaled = true
	end
end

espBtn.MouseButton1Click:Connect(function()
	esp = not esp
	espBtn.Text = esp and "ESP NAME: ON" or "ESP NAME: OFF"

	for _,p in pairs(Players:GetPlayers()) do
		if p ~= lp and p.Character then
			if esp then
				addESP(p)
			elseif p.Character.Head:FindFirstChild("ESP") then
				p.Character.Head.ESP:Destroy()
			end
		end
	end
end)

--// HEADSIT
local headSitBtn = makeBtn("HEADSIT PLAYER", 0.41)

headSitBtn.MouseButton1Click:Connect(function()
	local name = tostring(game:GetService("UserInputService"):GetFocusedTextBox() and "")
	for _,p in pairs(Players:GetPlayers()) do
		if p.Name:lower():find(name:lower()) and p.Character then
			hrp.CFrame = p.Character.Head.CFrame * CFrame.new(0,1,0)
		end
	end
end)

--// FLOAT
local float = false
local floatBtn = makeBtn("FLOAT: OFF", 0.53)

floatBtn.MouseButton1Click:Connect(function()
	float = not float
	floatBtn.Text = float and "FLOAT: ON" or "FLOAT: OFF"
	hum:ChangeState(float and Enum.HumanoidStateType.Physics or Enum.HumanoidStateType.GettingUp)
end)

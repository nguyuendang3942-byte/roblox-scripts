--// PC MENU SCRIPT
task.wait(1)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")

local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

-- GUI
local gui = Instance.new("ScreenGui", lp.PlayerGui)
gui.Name = "PCMenu"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.32, 0.55)
frame.Position = UDim2.fromScale(0.05, 0.22)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true

Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.fromScale(1,0.1)
title.Text = "Cao Bình Minh"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.BackgroundTransparency = 1

local function btn(text,y)
	local b = Instance.new("TextButton", frame)
	b.Size = UDim2.fromScale(0.9,0.085)
	b.Position = UDim2.fromScale(0.05,y)
	b.Text = text
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(50,50,50)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	return b
end

UIS.InputBegan:Connect(function(i,g)
	if not g and i.KeyCode == Enum.KeyCode.R then
		frame.Visible = not frame.Visible
	end
end)

-- FLY
local fly, bv, bg, flyConn = false
local flyBtn = btn("FLY: OFF",0.12)

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
			local d = Vector3.zero
			if UIS:IsKeyDown(Enum.KeyCode.W) then d += cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.S) then d -= cam.CFrame.LookVector end
			if UIS:IsKeyDown(Enum.KeyCode.A) then d -= cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.D) then d += cam.CFrame.RightVector end
			if UIS:IsKeyDown(Enum.KeyCode.Space) then d += Vector3.new(0,1,0) end
			if UIS:IsKeyDown(Enum.KeyCode.LeftControl) then d -= Vector3.new(0,1,0) end
			bv.Velocity = d.Magnitude>0 and d.Unit*55 or Vector3.zero
			bg.CFrame = cam.CFrame
		end)
	else
		if flyConn then flyConn:Disconnect() end
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end)

-- NOCLIP
local noclip=false
local noclipBtn = btn("NOCLIP: OFF",0.22)

noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = noclip and "NOCLIP: ON" or "NOCLIP: OFF"
end)

RunService.Stepped:Connect(function()
	if noclip then
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then v.CanCollide=false end
		end
	end
end)

-- ESP NAME
local esp=false
local espBtn = btn("ESP NAME: OFF",0.32)

local function espAdd(p)
	if p.Character and p.Character:FindFirstChild("Head") and not p.Character.Head:FindFirstChild("ESP") then
		local b=Instance.new("BillboardGui",p.Character.Head)
		b.Name="ESP"
		b.Size=UDim2.new(0,100,0,40)
		b.AlwaysOnTop=true
		local t=Instance.new("TextLabel",b)
		t.Size=UDim2.fromScale(1,1)
		t.BackgroundTransparency=1
		t.Text=p.Name
		t.TextColor3=Color3.new(1,0,0)
		t.TextScaled=true
	end
end

espBtn.MouseButton1Click:Connect(function()
	esp=not esp
	espBtn.Text=esp and "ESP NAME: ON" or "ESP NAME: OFF"
	for _,p in pairs(Players:GetPlayers()) do
		if p~=lp then
			if esp then espAdd(p)
			elseif p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("ESP") then
				p.Character.Head.ESP:Destroy()
			end
		end
	end
end)

-- FLOAT UP / DOWN
local float=false
local floatBtn = btn("FLOAT: OFF",0.42)

floatBtn.MouseButton1Click:Connect(function()
	float=not float
	floatBtn.Text=float and "FLOAT: ON" or "FLOAT: OFF"
	hum:ChangeState(float and Enum.HumanoidStateType.Physics or Enum.HumanoidStateType.GettingUp)
end)

-- TELEPORT TO RANDOM PLAYER
local tpBtn = btn("TELEPORT PLAYER",0.52)
tpBtn.MouseButton1Click:Connect(function()
	local plrs=Players:GetPlayers()
	local p=plrs[math.random(1,#plrs)]
	if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
		hrp.CFrame=p.Character.HumanoidRootPart.CFrame*CFrame.new(0,0,2)
	end
end)

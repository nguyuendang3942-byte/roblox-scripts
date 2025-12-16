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

-- WALKFLING (FLING NGƯỜI KHÁC)
local walkFling = false
local wfBtn = btn("WALKFLING: OFF", 0.62)
local wfConn

wfBtn.MouseButton1Click:Connect(function()
	walkFling = not walkFling
	wfBtn.Text = walkFling and "WALKFLING: ON" or "WALKFLING: OFF"

	if walkFling then
		wfConn = RunService.Heartbeat:Connect(function()
			for _,p in pairs(Players:GetPlayers()) do
				if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					local targetHRP = p.Character.HumanoidRootPart
					if (hrp.Position - targetHRP.Position).Magnitude < 7 then
						local bv = Instance.new("BodyVelocity")
						bv.Velocity = (targetHRP.Position - hrp.Position).Unit * 300 + Vector3.new(0,200,0)
						bv.MaxForce = Vector3.new(1e5,1e5,1e5)
						bv.Parent = targetHRP
						game:GetService("Debris"):AddItem(bv,0.15)
					end
				end
			end
		end)
	else
		if wfConn then wfConn:Disconnect() end
	end
end)

-- SPEED
local speedOn = false
local speedBtn = btn("SPEED: OFF", 0.72)

speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	speedBtn.Text = speedOn and "SPEED: ON" or "SPEED: OFF"
	hum.WalkSpeed = speedOn and 80 or 16
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

-- FLOAT + DI CHUYỂN (WASD + Q/E)
local float = false
local floatBtn = btn("FLOAT: OFF", 0.42)

local bv
local floatConn

floatBtn.MouseButton1Click:Connect(function()
	float = not float
	floatBtn.Text = float and "FLOAT: ON" or "FLOAT: OFF"

	if float then
		hum.PlatformStand = true

		bv = Instance.new("BodyVelocity")
		bv.MaxForce = Vector3.new(1e5, 1e5, 1e5)
		bv.Velocity = Vector3.zero
		bv.Parent = hrp

		floatConn = RunService.RenderStepped:Connect(function()
			local cam = workspace.CurrentCamera
			local move = Vector3.zero

			if UIS:IsKeyDown(Enum.KeyCode.W) then
				move += cam.CFrame.LookVector
			end
			if UIS:IsKeyDown(Enum.KeyCode.S) then
				move -= cam.CFrame.LookVector
			end
			if UIS:IsKeyDown(Enum.KeyCode.A) then
				move -= cam.CFrame.RightVector
			end
			if UIS:IsKeyDown(Enum.KeyCode.D) then
				move += cam.CFrame.RightVector
			end

			local y = 0
			if UIS:IsKeyDown(Enum.KeyCode.E) then
				y = 25      -- lên
			elseif UIS:IsKeyDown(Enum.KeyCode.Q) then
				y = -25     -- xuống
			end

			if move.Magnitude > 0 then
				move = move.Unit * 35 -- tốc độ di chuyển ngang
			end

			bv.Velocity = Vector3.new(move.X, y, move.Z)
		end)
	else
		hum.PlatformStand = false
		if floatConn then floatConn:Disconnect() end
		if bv then bv:Destroy() end
	end
end)


-- TELEPORT THEO TÊN
local tpBox = Instance.new("TextBox", frame)
tpBox.Size = UDim2.fromScale(0.9, 0.07)
tpBox.Position = UDim2.fromScale(0.05, 0.52)
tpBox.PlaceholderText = "Nhập tên player..."
tpBox.Text = ""
tpBox.TextScaled = true
tpBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
tpBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", tpBox).CornerRadius = UDim.new(0,10)

local tpBtn = btn("TELEPORT", 0.60)

tpBtn.MouseButton1Click:Connect(function()
	local name = tpBox.Text:lower()
	for _,p in pairs(Players:GetPlayers()) do
		if p ~= lp and p.Name:lower():find(name) then
			if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				hrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
				break
			end
		end
	end
end)

-- ANTI LAG
local antilag = false
local antilagBtn = btn("ANTILAG: OFF", 0.82)

antilagBtn.MouseButton1Click:Connect(function()
	antilag = not antilag
	antilagBtn.Text = antilag and "ANTILAG: ON" or "ANTILAG: OFF"

	for _,v in pairs(workspace:GetDescendants()) do
		if v:IsA("BasePart") then
			v.Material = Enum.Material.Plastic
			v.Reflectance = 0
		elseif v:IsA("Decal") or v:IsA("Texture") then
			v.Transparency = antilag and 1 or 0
		elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
			v.Enabled = not antilag
		end
	end

	if antilag then
		settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
	end
end)

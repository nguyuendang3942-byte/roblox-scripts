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
local gui = Instance.new("ScreenGui")
gui.Name = "PCMenu"
gui.Parent = lp.PlayerGui

-- FRAME CHÍNH
local frame = Instance.new("Frame")
frame.Parent = gui
frame.Size = UDim2.fromScale(0.32, 0.55)
frame.Position = UDim2.fromScale(0.05, 0.22)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

-- SCROLL
local scroll = Instance.new("ScrollingFrame")
scroll.Parent = frame
scroll.Size = UDim2.fromScale(1,1)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0

-- LIST LAYOUT (QUAN TRỌNG)
local layout = Instance.new("UIListLayout")
layout.Parent = scroll
layout.Padding = UDim.new(0, 8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
layout.VerticalAlignment = Enum.VerticalAlignment.Top

-- AUTO RESIZE SCROLL
layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 20)
end)

-- TITLE
local title = Instance.new("TextLabel")
title.Parent = scroll
title.Size = UDim2.fromScale(1, 0.1)
title.Text = "Cao Bình Minh"
title.TextColor3 = Color3.new(1,1,1)
title.TextScaled = true
title.BackgroundTransparency = 1

-- BUTTON FUNCTION (ĐÚNG)
local function btn(text)
	local b = Instance.new("TextButton")
	b.Parent = scroll
	b.Size = UDim2.fromScale(0.9,0.085)
	b.Text = text
	b.TextScaled = true
	b.BackgroundColor3 = Color3.fromRGB(50,50,50)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	return b
end

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

-- SPEED (CHẠY NHANH)
local speedOn = false
local speedBtn = btn("SPEED: OFF", 0.72)

local NORMAL_SPEED = 16   -- tốc độ mặc định
local FAST_SPEED = 80     -- tốc độ khi bật speed

speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	speedBtn.Text = speedOn and "SPEED: ON" or "SPEED: OFF"

	if speedOn then
		hum.WalkSpeed = FAST_SPEED
	else
		hum.WalkSpeed = NORMAL_SPEED
	end
end)

-- KILL AURA (AUTO ATTACK TOOL)
local killAura = false
local kaBtn = btn("KILL AURA: OFF")
local kaConn
local ATTACK_RANGE = 12

local function getTool()
	for _,v in pairs(char:GetChildren()) do
		if v:IsA("Tool") then
			return v
		end
	end
end

kaBtn.MouseButton1Click:Connect(function()
	killAura = not killAura
	kaBtn.Text = killAura and "KILL AURA: ON" or "KILL AURA: OFF"

	if killAura then
		kaConn = RunService.Heartbeat:Connect(function()
			local tool = getTool()
			if not tool then return end

			for _,p in pairs(Players:GetPlayers()) do
				if p ~= lp and p.Character and p.Character:FindFirstChild("Humanoid") and p.Character:FindFirstChild("HumanoidRootPart") then
					local th = p.Character.Humanoid
					local thrp = p.Character.HumanoidRootPart

					if th.Health > 0 and (hrp.Position - thrp.Position).Magnitude <= ATTACK_RANGE then
						tool:Activate() -- GỌI ĐÁNH
					end
				end
			end
		end)
	else
		if kaConn then kaConn:Disconnect() end
	end
end)

-- GOD MODE (AUTO HEAL)
local god = false
local godBtn = btn("GOD MODE: OFF", 0.88)
local godConn

godBtn.MouseButton1Click:Connect(function()
	god = not god
	godBtn.Text = god and "GOD MODE: ON" or "GOD MODE: OFF"

	if god then
		hum.MaxHealth = math.huge
		hum.Health = hum.MaxHealth

		godConn = hum.HealthChanged:Connect(function()
			if god and hum.Health < hum.MaxHealth then
				hum.Health = hum.MaxHealth
			end
		end)
	else
		if godConn then godConn:Disconnect() end
		hum.MaxHealth = 100
		hum.Health = 100
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
				y = 18      -- lên
			elseif UIS:IsKeyDown(Enum.KeyCode.Q) then
				y = -18     -- xuống
			end

			if move.Magnitude > 0 then
				move = move.Unit * 25 -- tốc độ di chuyển ngang
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

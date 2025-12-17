--// PC MENU HUB - FIX FULL
task.wait(1)

-- SERVICES
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

-- PLAYER
local lp = Players.LocalPlayer
local char = lp.Character or lp.CharacterAdded:Wait()
local hum = char:WaitForChild("Humanoid")
local hrp = char:WaitForChild("HumanoidRootPart")

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "PCMenuHub"
gui.ResetOnSpawn = false
gui.Parent = lp.PlayerGui

-- FRAME
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.fromScale(0.32, 0.55)
frame.Position = UDim2.fromScale(0.05, 0.22)
frame.BackgroundColor3 = Color3.fromRGB(20,20,20)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,16)

-- SCROLL
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.fromScale(1,1)
scroll.CanvasSize = UDim2.new(0,0,0,0)
scroll.ScrollBarThickness = 6
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.AutomaticCanvasSize = Enum.AutomaticSize.None

-- LAYOUT
local layout = Instance.new("UIListLayout", scroll)
layout.Padding = UDim.new(0,8)
layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	scroll.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 20)
end)

-- HEADER
local header = Instance.new("TextLabel", scroll)
header.Size = UDim2.new(1,-12,0,45)
header.BackgroundColor3 = Color3.fromRGB(30,30,30)
header.Text = "Cao Bình Minh Hub"
header.TextColor3 = Color3.new(1,1,1)
header.Font = Enum.Font.GothamBold
header.TextSize = 20
Instance.new("UICorner", header).CornerRadius = UDim.new(0,12)

-- BUTTON FUNC
local function newButton(text)
	local b = Instance.new("TextButton", scroll)
	b.Size = UDim2.fromScale(0.9,0.085)
	b.Text = text
	b.TextSize = 18
	b.BackgroundColor3 = Color3.fromRGB(50,50,50)
	b.TextColor3 = Color3.new(1,1,1)
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
	return b
end

--------------------------------------------------
-- TOGGLE MENU (R)
--------------------------------------------------
local open = true
UIS.InputBegan:Connect(function(input, g)
	if g or UIS:GetFocusedTextBox() then return end
	if input.KeyCode == Enum.KeyCode.R then
		open = not open
		TweenService:Create(
			frame,
			TweenInfo.new(0.25, Enum.EasingStyle.Quint),
			{Size = open and UDim2.fromScale(0.32,0.55) or UDim2.fromScale(0,0)}
		):Play()
	end
end)

--------------------------------------------------
-- FLY
--------------------------------------------------
local fly = false
local flyBtn = newButton("FLY : OFF")
local bv, bg, flyConn

flyBtn.MouseButton1Click:Connect(function()
	fly = not fly
	flyBtn.Text = fly and "FLY : ON" or "FLY : OFF"

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

			bv.Velocity = dir.Magnitude > 0 and dir.Unit * 60 or Vector3.zero
			bg.CFrame = cam.CFrame
		end)
	else
		if flyConn then flyConn:Disconnect() end
		if bv then bv:Destroy() end
		if bg then bg:Destroy() end
	end
end)

--------------------------------------------------
-- SPEED
--------------------------------------------------
local speedOn = false
local speedBtn = newButton("SPEED : OFF")

speedBtn.MouseButton1Click:Connect(function()
	speedOn = not speedOn
	speedBtn.Text = speedOn and "SPEED : ON" or "SPEED : OFF"
	hum.WalkSpeed = speedOn and 60 or 16
end)

--------------------------------------------------
-- NOCLIP
--------------------------------------------------
local noclip = false
local noclipBtn = newButton("NOCLIP : OFF")

noclipBtn.MouseButton1Click:Connect(function()
	noclip = not noclip
	noclipBtn.Text = noclip and "NOCLIP : ON" or "NOCLIP : OFF"
end)

RunService.Stepped:Connect(function()
	if noclip then
		for _,v in pairs(char:GetDescendants()) do
			if v:IsA("BasePart") then
				v.CanCollide = false
			end
		end
	end
end)

--------------------------------------------------
-- ESP NAME
--------------------------------------------------
local esp = false
local espBtn = newButton("ESP NAME : OFF")

local function addESP(p)
	if p.Character and p.Character:FindFirstChild("Head") and not p.Character.Head:FindFirstChild("ESP") then
		local bb = Instance.new("BillboardGui", p.Character.Head)
		bb.Name = "ESP"
		bb.Size = UDim2.new(0,100,0,40)
		bb.AlwaysOnTop = true

		local t = Instance.new("TextLabel", bb)
		t.Size = UDim2.fromScale(1,1)
		t.BackgroundTransparency = 1
		t.Text = p.Name
		t.TextColor3 = Color3.new(1,0,0)
		t.TextScaled = true
	end
end

espBtn.MouseButton1Click:Connect(function()
	esp = not esp
	espBtn.Text = esp and "ESP NAME : ON" or "ESP NAME : OFF"

	for _,p in pairs(Players:GetPlayers()) do
		if p ~= lp then
			if esp then
				addESP(p)
			elseif p.Character and p.Character:FindFirstChild("Head") and p.Character.Head:FindFirstChild("ESP") then
				p.Character.Head.ESP:Destroy()
			end
		end
	end
end)

-- WALKFLING (ĐẾN GẦN LÀ BAY)
local walkFling = false
local wfBtn = newButton("WALK FLING : OFF")

local wfConn
local FLING_RANGE = 9     -- khoảng cách kích hoạt
local FLING_POWER = 350  -- lực fling

wfBtn.MouseButton1Click:Connect(function()
	walkFling = not walkFling
	wfBtn.Text = walkFling and "WALK FLING : ON" or "WALK FLING : OFF"

	if walkFling then
		wfConn = RunService.Heartbeat:Connect(function()
			for _,p in pairs(Players:GetPlayers()) do
				if p ~= lp and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
					local thrp = p.Character.HumanoidRootPart

					if (hrp.Position - thrp.Position).Magnitude <= FLING_RANGE then
						local bv = Instance.new("BodyVelocity")
						bv.Velocity =
							(hrp.CFrame.LookVector * FLING_POWER)
							+ Vector3.new(0, FLING_POWER / 1.5, 0)

						bv.MaxForce = Vector3.new(1e5,1e5,1e5)
						bv.Parent = thrp
						game:GetService("Debris"):AddItem(bv, 0.15)
					end
				end
			end
		end)
	else
		if wfConn then
			wfConn:Disconnect()
			wfConn = nil
		end
	end
end)

-- TELEPORT THEO TÊN
local tpBox = Instance.new("TextBox", scroll)
tpBox.Size = UDim2.fromScale(0.9, 0.075)
tpBox.PlaceholderText = "Nhập tên player..."
tpBox.Text = ""
tpBox.TextSize = 16
tpBox.BackgroundColor3 = Color3.fromRGB(45,45,45)
tpBox.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", tpBox).CornerRadius = UDim.new(0,10)

local tpBtn = newButton("TELEPORT")

tpBtn.MouseButton1Click:Connect(function()
	local name = tpBox.Text:lower()
	if name == "" then return end

	for _,p in pairs(Players:GetPlayers()) do
		if p ~= lp and p.Name:lower():find(name) then
			if p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
				hrp.CFrame = p.Character.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
				break
			end
		end
	end
end)

-- ANTI LAG
local antilag = false
local antilagBtn = newButton("ANTI LAG : OFF")

antilagBtn.MouseButton1Click:Connect(function()
	antilag = not antilag
	antilagBtn.Text = antilag and "ANTI LAG : ON" or "ANTI LAG : OFF"

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

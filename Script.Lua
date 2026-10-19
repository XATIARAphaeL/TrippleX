do
	local env = (getgenv and getgenv()) or _G
	if env.TrippleXUnload then pcall(env.TrippleXUnload) end
end

do
	local TweenService = game:GetService("TweenService")
	local ok, parent = pcall(function() return gethui and gethui() end)
	if not (ok and parent) then parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end
	local gui = Instance.new("ScreenGui")
	gui.Name, gui.IgnoreGuiInset, gui.ResetOnSpawn, gui.DisplayOrder = "TrippleXSplash", true, false, 100000
	gui.Parent = parent
	local bg = Instance.new("Frame")
	bg.Size, bg.BackgroundColor3, bg.BorderSizePixel, bg.Active = UDim2.fromScale(1, 1), Color3.fromRGB(9, 9, 13), 0, true
	bg.Parent = gui
	local logo = Instance.new("ImageLabel")
	logo.Image, logo.BackgroundTransparency, logo.ImageTransparency = "rbxassetid://113614047568331", 1, 1
	logo.AnchorPoint, logo.Position, logo.Size = Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.4), UDim2.fromOffset(230, 230)
	logo.Parent = bg
	local scale = Instance.new("UIScale")
	scale.Parent = logo
	local title = Instance.new("TextLabel")
	title.BackgroundTransparency, title.Text, title.Font, title.TextSize = 1, "TrippleX Hub", Enum.Font.GothamBold, 30
	title.TextColor3, title.TextTransparency = Color3.fromRGB(240, 240, 246), 1
	title.AnchorPoint, title.Position, title.Size = Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.62), UDim2.fromOffset(400, 40)
	title.Parent = bg
	local sub = Instance.new("TextLabel")
	sub.BackgroundTransparency, sub.Text, sub.Font, sub.TextSize = 1, "The Veil  |  Loading...", Enum.Font.GothamMedium, 14
	sub.TextColor3, sub.TextTransparency = Color3.fromRGB(150, 150, 168), 1
	sub.AnchorPoint, sub.Position, sub.Size = Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.67), UDim2.fromOffset(400, 20)
	sub.Parent = bg
	local track = Instance.new("Frame")
	track.AnchorPoint, track.Position, track.Size = Vector2.new(0.5, 0.5), UDim2.fromScale(0.5, 0.73), UDim2.fromOffset(280, 4)
	track.BackgroundColor3, track.BackgroundTransparency, track.BorderSizePixel = Color3.fromRGB(36, 36, 46), 1, 0
	track.Parent = bg
	local trackCorner = Instance.new("UICorner")
	trackCorner.CornerRadius = UDim.new(0, 2)
	trackCorner.Parent = track
	local fill = Instance.new("Frame")
	fill.Size, fill.BackgroundColor3, fill.BackgroundTransparency, fill.BorderSizePixel = UDim2.fromScale(0, 1), Color3.fromRGB(235, 30, 40), 1, 0
	fill.Parent = track
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(0, 2)
	fillCorner.Parent = fill
	local function tw(o, t, props, style, dir) return TweenService:Create(o, TweenInfo.new(t, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props) end
	task.spawn(function()
		tw(logo, 0.7, { ImageTransparency = 0 }):Play()
		tw(title, 0.7, { TextTransparency = 0 }):Play()
		tw(sub, 0.7, { TextTransparency = 0 }):Play()
		tw(track, 0.7, { BackgroundTransparency = 0 }):Play()
		fill.BackgroundTransparency = 0
		tw(fill, 4.6, { Size = UDim2.fromScale(1, 1) }, Enum.EasingStyle.Linear):Play()
		local pulse = TweenService:Create(scale, TweenInfo.new(1.1, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { Scale = 1.07 })
		pulse:Play()
		task.wait(5)
		pulse:Cancel()
		local fade = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		TweenService:Create(bg, fade, { BackgroundTransparency = 1 }):Play()
		TweenService:Create(logo, fade, { ImageTransparency = 1 }):Play()
		TweenService:Create(title, fade, { TextTransparency = 1 }):Play()
		TweenService:Create(sub, fade, { TextTransparency = 1 }):Play()
		TweenService:Create(track, fade, { BackgroundTransparency = 1 }):Play()
		TweenService:Create(fill, fade, { BackgroundTransparency = 1 }):Play()
		task.wait(0.7)
		gui:Destroy()
	end)
end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local LP = Players.LocalPlayer

local HUB = "TrippleX Hub"
local Options = Fluent.Options
local function unloaded() return Fluent.Unloaded == true end

local TEXT, SUB, ACC = Color3.fromRGB(236, 236, 244), Color3.fromRGB(144, 144, 162), Color3.fromRGB(150, 110, 255)
local FONT, BOLD = Enum.Font.GothamMedium, Enum.Font.GothamBold
local function new(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do o[k] = v end
	o.Parent = parent
	return o
end
local function corner(o, r) return new("UICorner", { CornerRadius = UDim.new(0, r or 6) }, o) end
local function stroke(p, c) return new("UIStroke", { Color = c, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, p) end
local function lbl(parent, text, size, color, align, font)
	return new("TextLabel", { BackgroundTransparency = 1, Text = text, Font = font or FONT, TextSize = size or 14, TextColor3 = color or TEXT, TextXAlignment = align or Enum.TextXAlignment.Left, BorderSizePixel = 0 }, parent)
end
local function tween(o, t, props) TweenService:Create(o, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play() end
local function guiParent()
	local ok, h = pcall(function() return gethui and gethui() end)
	if ok and h then return h end
	return LP:WaitForChild("PlayerGui")
end

local Remotes = ReplicatedStorage:WaitForChild("Remotes", 15)
local function R(n) return Remotes and Remotes:FindFirstChild(n) end
local InteractPromptEvent, TeleportToWaypoint = R("InteractPromptEvent"), R("TeleportToWaypoint")

local State = {
	Target = nil, TargetSince = 0, Healing = false, Fleeing = false, Selling = false, Buying = false, Casting = false,
	LootUntil = 0, Blacklist = {}, Status = "Idle", Parts = {}, PartsAt = 0,
}
local function opt(n, d)
	local o = Options[n]
	if o == nil or o.Value == nil then return d end
	return o.Value
end
local RANGE = {}
local function optN(n, d)
	local v = tonumber(opt(n, d)) or d
	local r = RANGE[n]
	if r then v = math.clamp(v, r[1], r[2]) end
	return v
end
local function setOpt(n, v)
	local o = Options[n]
	if o then pcall(function() o:SetValue(v) end) end
end
local function notify(t, title) pcall(function() Fluent:Notify({ Title = title or HUB, Content = t, Duration = 3.5 }) end) end

local function getChar() return LP.Character end
local function getHum() local c = getChar(); return c and c:FindFirstChildOfClass("Humanoid") end
local function getHRP() local c = getChar(); return c and c:FindFirstChild("HumanoidRootPart") end
local function alive() local h, r = getHum(), getHRP(); return h ~= nil and r ~= nil and h.Health > 0 end
local function hpPct() local h = getHum(); if not h then return 100 end; return h.Health / math.max(h.MaxHealth, 1) * 100 end
local function inMenu() return LP:GetAttribute("InMainMenu") == true end
local function farmOn() return opt("AutoFarm", false) == true end
local function lstat(n) local f = LP:FindFirstChild("leaderstats"); local v = f and f:FindFirstChild(n); return v and tonumber(v.Value) or 0 end

local function selectedSet(name)
	local set, any, o = {}, false, Options[name]
	if o and type(o.Value) == "table" then
		for k, v in pairs(o.Value) do
			if v == true then set[k] = true; any = true
			elseif type(k) == "number" and type(v) == "string" then set[v] = true; any = true end
		end
	end
	return set, any
end
local function csv(raw)
	local l = {}
	for tok in string.gmatch(string.lower(raw or ""), "[^,]+") do
		tok = tok:match("^%s*(.-)%s*$")
		if tok ~= "" then l[#l + 1] = tok end
	end
	return l
end
local function nameHas(name, list)
	local l = string.lower(name)
	for _, k in ipairs(list) do if string.find(l, k, 1, true) then return true end end
	return false
end
local function playerNear(pos, r)
	for _, pl in ipairs(Players:GetPlayers()) do
		local hr = pl ~= LP and pl.Character and pl.Character:FindFirstChild("HumanoidRootPart")
		if hr and (hr.Position - pos).Magnitude <= r then return true end
	end
	return false
end
local function commas(n)
	local s = tostring(math.floor(math.abs(tonumber(n) or 0))):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
	return s
end
local function clock(s)
	s = math.floor(s)
	return ("%02d:%02d:%02d"):format(s // 3600, s % 3600 // 60, s % 60)
end

local Mover = { Goal = nil, Cur = 0 }
local function zeroVel()
	local h = getHRP()
	if h then h.AssemblyLinearVelocity = Vector3.zero; h.AssemblyAngularVelocity = Vector3.zero end
end
local function setGoal(cf) Mover.Goal = cf end
local function stopMove() Mover.Goal = nil; Mover.Cur = 0; zeroVel() end

local moveConn = RunService.Heartbeat:Connect(function(dt)
	local goal = Mover.Goal
	if unloaded() or not goal then Mover.Cur = 0; return end
	local hrp = getHRP()
	if not hrp or not alive() then return end
	local speed = math.max(optN("TweenSpeed", 140), 10)
	local smooth = math.clamp(optN("Smoothness", 0.6), 0.05, 1)
	Mover.Cur = math.min(Mover.Cur + speed * 5 * dt, speed)
	local d = goal.Position - hrp.Position
	local dist = d.Magnitude
	local glide = dist * (1 - math.exp(-dt * (36 - 30 * smooth)))
	local move = math.min(Mover.Cur * dt, glide)
	local pos = (dist < 0.05) and goal.Position or (hrp.Position + d.Unit * math.min(move, dist))
	hrp.CFrame = CFrame.new(pos) * hrp.CFrame.Rotation:Lerp(goal.Rotation, math.clamp(dt * 14, 0, 1))
	hrp.AssemblyLinearVelocity, hrp.AssemblyAngularVelocity = Vector3.zero, Vector3.zero
end)

local function goTo(cf, maxT, cond)
	setGoal(cf)
	local t0 = os.clock()
	while not unloaded() and alive() and os.clock() - t0 < (maxT or 20) do
		local hrp = getHRP()
		if hrp and (hrp.Position - cf.Position).Magnitude < 3 then break end
		if cond and not cond() then break end
		task.wait(0.03)
	end
end

local Platform
local function refreshParts()
	table.clear(State.Parts)
	local c = getChar()
	if c then for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then State.Parts[#State.Parts + 1] = p end end end
	State.PartsAt = os.clock()
end
local stepConn = RunService.Stepped:Connect(function()
	if unloaded() then
		if Platform then Platform:Destroy(); Platform = nil end
		return
	end
	local hrp, hum = getHRP(), getHum()
	local want = opt("SafePlatform", true) and (farmOn() or State.Selling or State.Buying or State.Fleeing)
	if hrp and hum and hum.Health > 0 and want then
		if not Platform then
			Platform = Instance.new("Part")
			Platform.Size, Platform.Anchored, Platform.CanTouch, Platform.Transparency, Platform.Locked = Vector3.new(16, 1, 16), true, false, 1, true
		end
		Platform.Parent = workspace.CurrentCamera or workspace
		local off = hum.RigType == Enum.HumanoidRigType.R6 and (hrp.Size.Y / 2 + 2) or (hrp.Size.Y / 2 + hum.HipHeight)
		Platform.CFrame = CFrame.new(hrp.Position.X, hrp.Position.Y - off - 0.55, hrp.Position.Z)
	elseif Platform and Platform.Parent then
		Platform.Parent = nil
	end
	if opt("Noclip", true) and farmOn() then
		if os.clock() - State.PartsAt > 1 then refreshParts() end
		for _, p in ipairs(State.Parts) do if p.Parent and p.CanCollide then p.CanCollide = false end end
	end
end)

local function isPlayerModel(m) return Players:GetPlayerFromCharacter(m) ~= nil end
local function mobAlive(m)
	if not m or not m.Parent then return false end
	local h = m:FindFirstChildOfClass("Humanoid")
	return h ~= nil and m:FindFirstChild("HumanoidRootPart") ~= nil and h.Health > 0
end
local KnownMobs = {}
local function getMobNames()
	local f = workspace:FindFirstChild("Monsters")
	if f then for _, m in ipairs(f:GetChildren()) do if m:IsA("Model") and not isPlayerModel(m) then KnownMobs[m.Name] = true end end end
	local n = {}
	for k in pairs(KnownMobs) do n[#n + 1] = k end
	table.sort(n)
	return n
end
local function farmMode() return string.sub(tostring(opt("FarmMode", "1. Closest")), 1, 1) end

local function prioInfo()
	local set = selectedSet("PriorityMobs")
	return { typed = csv(opt("PriorityTyped", "")), set = set }
end
local function prioRank(name, info)
	info = info or prioInfo()
	local l = string.lower(name)
	for i, k in ipairs(info.typed) do if string.find(l, k, 1, true) then return i end end
	if info.set[name] then return #info.typed + 1 end
	return math.huge
end
local SAME = "Same As Normal"
local function magicMode(target)
	if target and target.Parent then
		local pm = opt("PriorityMagicMode", SAME)
		if pm ~= SAME and prioRank(target.Name) < math.huge then return pm end
	end
	return opt("MagicMode", "Off")
end
local function hasPriority() local i = prioInfo(); return #i.typed > 0 or next(i.set) ~= nil end
local function isPriority(m) return m ~= nil and m.Parent ~= nil and prioRank(m.Name) < math.huge end

local function pickTarget()
	local folder, hrp = workspace:FindFirstChild("Monsters"), getHRP()
	if not folder or not hrp then return nil end
	local wp = farmMode() == "2" and State.WpCenter
	local origin = wp or hrp.Position
	local set, any = selectedSet("MobSelect")
	local blocked = csv(opt("NeverAttack", "Training Dummy, Runner"))
	local now, mode = os.clock(), opt("TargetMode", "Closest")
	local range = wp and (State.WpRange or optN("WpRadius", 500)) or optN("MobRange", 3000)
	local skipBoss, bossHP = opt("SkipBosses", false), optN("BossHP", 3000)
	local prio = prioInfo()
	local list, dmin = {}, math.huge
	for _, m in ipairs(folder:GetChildren()) do
		if m:IsA("Model") and not isPlayerModel(m) and mobAlive(m) then
			local h, bl = m:FindFirstChildOfClass("Humanoid"), State.Blacklist[m]
			if (not bl or bl <= now) and ((not any) or set[m.Name]) and not nameHas(m.Name, blocked) and not (skipBoss and h.MaxHealth >= bossHP) then
				local p = m.HumanoidRootPart.Position
				local d = (p - hrp.Position).Magnitude
				if (p - origin).Magnitude <= range then
					list[#list + 1] = { m = m, d = d, h = h, p = p, rank = prioRank(m.Name, prio) }
					dmin = math.min(dmin, d)
				end
			end
		end
	end
	local function best(skipContested)
		local b, bs = nil, math.huge
		for _, c in ipairs(list) do
			if (mode == "Closest" or c.rank < math.huge or c.d <= dmin + 120) and not (skipContested and playerNear(c.p, optN("ContestRadius", 50))) then
				local s = c.d
				if mode == "Lowest HP" then s = c.h.Health + c.d * 0.01
				elseif mode == "Highest HP" then s = -c.h.Health + c.d * 0.01 end
				s = s + ((c.rank == math.huge) and 1e12 or c.rank * 1e8)
				if s < bs then b, bs = c.m, s end
			end
		end
		return b
	end
	return (opt("AvoidContest", true) and best(true)) or best(false)
end

local function attackCF(mob)
	local r = mob.HumanoidRootPart
	local mode, h, d = opt("PosMode", "Behind"), optN("HeightOffset", 3), optN("DistOffset", 4)
	if magicMode(mob) == "Magic Only" then d = optN("MagicDist", 20) end
	local pos
	if mode == "Above" then pos = r.Position + Vector3.new(0, h + 4, 0)
	elseif mode == "Front" then pos = (r.CFrame * CFrame.new(0, h, -d)).Position
	else pos = (r.CFrame * CFrame.new(0, h, d)).Position end
	return CFrame.lookAt(pos, r.Position)
end

local function allTools()
	local l, bp, c = {}, LP:FindFirstChildOfClass("Backpack"), getChar()
	if bp then for _, t in ipairs(bp:GetChildren()) do if t:IsA("Tool") then l[#l + 1] = t end end end
	if c then for _, t in ipairs(c:GetChildren()) do if t:IsA("Tool") then l[#l + 1] = t end end end
	return l
end
local function flagTrue(t, n) local v = t:FindFirstChild(n); return v ~= nil and v:IsA("BoolValue") and v.Value == true end
local function isSword(t) return flagTrue(t, "IsSword") end
local function isCast(t) return flagTrue(t, "IsCastWeapon") end
local function stat(t, n, d)
	local v = t:FindFirstChild("Values")
	v = v and v:FindFirstChild("Stats")
	v = v and v:FindFirstChild(n)
	return (v and v.Value) or d
end
local AUTO_SWORD, AUTO_STAFF = "Auto (Best Damage)", "Auto (All Staffs)"

local function chosenSword()
	local pick, best, bd = opt("WeaponPick", AUTO_SWORD), nil, -1
	for _, t in ipairs(allTools()) do
		if isSword(t) and (pick == AUTO_SWORD or t.Name == pick) then
			local d = stat(t, "BaseDamage", 0)
			if d > bd then best, bd = t, d end
		end
	end
	if not best and pick ~= AUTO_SWORD then
		for _, t in ipairs(allTools()) do
			if isSword(t) and stat(t, "BaseDamage", 0) > bd then best, bd = t, stat(t, "BaseDamage", 0) end
		end
	end
	return best
end

local function weaponRule(mobName)
	local l = string.lower(mobName)
	for entry in string.gmatch(opt("WeaponRules", ""), "[^,]+") do
		local m, w = entry:match("^%s*(.-)%s*=%s*(.-)%s*$")
		if m and w and m ~= "" and w ~= "" and string.find(l, string.lower(m), 1, true) then return string.lower(w) end
	end
end
local function swordNamed(kw, exact)
	local best, bd = nil, -1
	for _, t in ipairs(allTools()) do
		if isSword(t) and ((exact and t.Name == kw) or (not exact and string.find(string.lower(t.Name), kw, 1, true))) then
			local d = stat(t, "BaseDamage", 0)
			if d > bd then best, bd = t, d end
		end
	end
	return best
end

local function swordFor(target)
	if target and target.Parent then
		local w = weaponRule(target.Name)
		if w then local sw = swordNamed(w, false); if sw then return sw end end
		if isPriority(target) then
			local pw = opt("PriorityWeapon", AUTO_SWORD)
			if pw ~= AUTO_SWORD then local sw = swordNamed(pw, true); if sw then return sw end end
		end
	end
	return chosenSword()
end
local function staffs(target)
	local pick, out = opt("MagicPick", AUTO_STAFF), {}
	if target and isPriority(target) then
		local pp = opt("PriorityMagic", SAME)
		if pp ~= SAME then pick = pp end
	end
	for _, t in ipairs(allTools()) do if isCast(t) and (pick == AUTO_STAFF or t.Name == pick) then out[#out + 1] = t end end
	return out
end
local function equipped() local c = getChar(); return c and c:FindFirstChildOfClass("Tool") end
local function findTool(kw)
	kw = string.lower(kw)
	for _, t in ipairs(allTools()) do if string.find(string.lower(t.Name), kw, 1, true) then return t end end
end
local function equip(t) local h = getHum(); if h and t and t.Parent then pcall(function() h:EquipTool(t) end) end end
local function countTools(kw)
	local n = 0
	kw = string.lower(kw)
	for _, t in ipairs(allTools()) do if string.find(string.lower(t.Name), kw, 1, true) then n += 1 end end
	return n
end
local function refreshDropdown(name, list)
	local o = Options[name]
	if not o then return end
	local prev = o.Value
	pcall(function() o:SetValues(list) end)
	pcall(function() o:SetValue(table.find(list, prev) and prev or list[1]) end)
end
local function refreshWeapons()
	local sw, st, seenS, seenT = { AUTO_SWORD }, { AUTO_STAFF }, {}, {}
	local pst = { SAME, AUTO_STAFF }
	for _, t in ipairs(allTools()) do
		if isSword(t) and not seenS[t.Name] then seenS[t.Name] = true; sw[#sw + 1] = t.Name end
		if isCast(t) and not seenT[t.Name] then seenT[t.Name] = true; st[#st + 1] = t.Name; pst[#pst + 1] = t.Name end
	end
	refreshDropdown("WeaponPick", sw)
	refreshDropdown("PriorityWeapon", sw)
	refreshDropdown("MagicPick", st)
	refreshDropdown("PriorityMagic", pst)
end
local function castAt(tool, t)
	local hrp, part = getHRP(), t:FindFirstChild("HumanoidRootPart")
	if not (hrp and part) then return end
	local tp = part.Position
	if opt("AimMode", "Predict") == "Predict" then tp += part.AssemblyLinearVelocity * math.clamp((tp - hrp.Position).Magnitude / 80, 0, 0.6) end
	local ev = R(tool:GetAttribute("ConsumableRemote") or "ConsumableEvent")
	if ev then ev:FireServer(tool.Name, CFrame.lookAt(hrp.Position + Vector3.new(0, 1, 0), tp)) else tool:Activate() end
end

local RARITIES = { "Common", "Uncommon", "Rare", "Epic", "Legendary", "Mythic", "Elite", "Divine" }
local function dropPivot(d) local ok, cf = pcall(function() return d:GetPivot() end); return ok and cf or nil end
local function isPickup(d) return d.Parent and d:FindFirstChild("IsInteractable") and d:FindFirstChild("Argument") and d.Argument:IsA("StringValue") end
local function isSilver(d) local a = d:FindFirstChild("Argument"); return a ~= nil and a.Value == "PickupSilver" end
local function rarityOK(d)
	local set, any = selectedSet("DropRarity")
	if not any then return true end
	local r = d:GetAttribute("Rarity")
	if r == nil then local sv = d:FindFirstChild("Rarity"); r = sv and sv.Value or "Common" end
	return set[r] == true
end
local bag, capLabel = { t = 0, n = 0, cap = 150 }, nil
local function bagInfo()
	if os.clock() - bag.t < 0.4 then return bag.n, bag.cap end
	if not capLabel or not capLabel.Parent then
		local pg = LP:FindFirstChild("PlayerGui")
		capLabel = pg and pg:FindFirstChild("CapacityTextLabel", true)
	end
	local cap = capLabel and tonumber(string.match(capLabel.Text or "", "/%s*(%d+)")) or (150 + (tonumber(LP:GetAttribute("InventorySlotBonus")) or 0))
	bag.t, bag.n, bag.cap = os.clock(), #allTools(), cap
	return bag.n, cap
end
local function bagFull() local n, c = bagInfo(); return n >= c end

local Chests, ChestCD = {}, {}
local function trackChest(i)
	if i.Name == "Argument" and i:IsA("StringValue") and i.Value == "OpenChest" and i.Parent then Chests[i.Parent] = true end
end
task.spawn(function()
	local sys = workspace:WaitForChild("Systems", 20)
	if sys then for _, d in ipairs(sys:GetDescendants()) do trackChest(d) end end
	local drops = workspace:FindFirstChild("Drops")
	if drops then for _, d in ipairs(drops:GetDescendants()) do trackChest(d) end end
	workspace.DescendantAdded:Connect(function(i) if i.Name == "Argument" then task.defer(trackChest, i) end end)
end)
local function getPart(i)
	if i:IsA("BasePart") then return i end
	if i:IsA("Model") then return i.PrimaryPart or i:FindFirstChild("Main") or i:FindFirstChild("Handle") or i:FindFirstChildWhichIsA("BasePart", true) end
end

local function nextLoot()
	local hrp = getHRP()
	if not hrp then return nil end
	local full, maxR, pos = bagFull(), optN("DropRange", 400), hrp.Position
	local best, bd = nil, math.huge
	local ap = csv(opt("AlwaysPick", "Potion, Event, Star Fruit"))
	local folder = workspace:FindFirstChild("Drops")
	if folder then
		for _, d in ipairs(folder:GetChildren()) do
			if isPickup(d) and (isSilver(d) or (not full and (rarityOK(d) or nameHas(d.Name, ap)))) then
				local cf = dropPivot(d)
				local dist = cf and (cf.Position - pos).Magnitude or math.huge
				if dist < bd and dist <= maxR then best, bd = d, dist end
			end
		end
	end
	if opt("AutoChest", true) and not full then
		for c in pairs(Chests) do
			if not c.Parent then Chests[c] = nil
			elseif (ChestCD[c] or 0) < os.clock() then
				local p = getPart(c)
				local dist = p and (p.Position - pos).Magnitude or math.huge
				if dist < bd and dist <= maxR then best, bd = c, dist end
			end
		end
	end
	return best
end
local function lootActive() return farmOn() and opt("AutoPickup", true) end
local function collectLoot(x)
	if not InteractPromptEvent then return end
	local chest = x:FindFirstChild("Argument") and x.Argument.Value == "OpenChest"
	local silver, t0 = isSilver(x), os.clock()
	State.Status = (chest and "Opening chest: " or "Pickup: ") .. x.Name
	while x.Parent and alive() and lootActive() and os.clock() - t0 < (chest and 12 or 5) do
		if not chest and not silver and bagFull() then break end
		local cf = chest and (getPart(x) and getPart(x).CFrame) or dropPivot(x)
		if not cf then break end
		cf = cf * CFrame.new(0, chest and 3 or 2, 0)
		if (getHRP().Position - cf.Position).Magnitude > 6 then
			goTo(cf, 15, lootActive)
		else
			stopMove()
			getHRP().CFrame = cf
			local arg = x:FindFirstChild("Argument")
			pcall(function() InteractPromptEvent:FireServer(arg and arg.Value or "OpenChest", x) end)
			task.wait(chest and 0.35 or 0.2)
			if chest then break end
		end
	end
	if chest then ChestCD[x] = os.clock() + 45 end
	stopMove()
end

local function toolRarity(t)
	local v = t:FindFirstChild("Rarity")
	return (v and v:IsA("StringValue") and v.Value) or t:GetAttribute("Rarity") or "Common"
end
local function sellRun()
	if State.Selling or State.Buying then return 0 end
	local ev = R("SellItemsEvent")
	local rset, any = selectedSet("SellRarity")
	local bp = LP:FindFirstChildOfClass("Backpack")
	if not (ev and any and bp) then return 0 end
	State.Selling = true
	local n = 0
	pcall(function()
		local home
		if opt("SellGoMerchant", false) then
			local npcs = workspace:FindFirstChild("NPCs")
			local m = npcs and npcs:FindFirstChild("Clement, Merchant")
			local p = m and m:FindFirstChild("DialogPart")
			local hrp = getHRP()
			if p and hrp then
				home = hrp.CFrame
				State.Status = "Selling: going to merchant"
				goTo(p.CFrame * CFrame.new(0, 0, 4), 60, function() return not unloaded() end)
			end
		end
		local keep, list = csv(opt("SellKeepNames", "Bag, Key")), {}
		for _, t in ipairs(bp:GetChildren()) do

			if t:IsA("Tool") and not isSword(t) and not isCast(t) and not t:FindFirstChild("IsAccessory") and not t:GetAttribute("Favorited")
				and not t:FindFirstChild("CannotBeDropped") and not t:GetAttribute("ConsumableRemote") and t:FindFirstChild("SellPrice")
				and not nameHas(t.Name, keep) and rset[toolRarity(t)] then
				list[#list + 1] = t
			end
		end
		State.Status = "Selling..."
		for i = 1, #list, 15 do
			if unloaded() then break end
			local batch = {}
			for j = i, math.min(i + 14, #list) do batch[#batch + 1] = list[j] end
			pcall(function() ev:FireServer(batch) end)
			task.wait(0.6)
		end
		n = #list
		if home and alive() then goTo(home, 60, function() return not unloaded() end) end
	end)
	State.Selling = false
	stopMove()
	return n
end
task.spawn(function()
	while not unloaded() do
		task.wait(math.max(optN("SellInterval", 45), 5))
		if opt("AutoSell", false) and alive() and not inMenu() and not State.Healing then sellRun() end
	end
end)

local Catalog = {}
local RequestShopCatalog, UpdateShopCatalog = R("RequestShopCatalog"), R("UpdateShopCatalog")
if UpdateShopCatalog then
	UpdateShopCatalog.OnClientEvent:Connect(function(id, data)
		if type(id) == "string" and type(data) == "table" and type(data.entries) == "table" then Catalog.id, Catalog.data = id, data end
	end)
end
local function buyPotions()
	if State.Selling or State.Buying or not RequestShopCatalog then return 0 end
	State.Buying = true
	local bought = 0
	pcall(function()
		local shopName, npcs = opt("ShopNPC", "Calvin, Potion Specialist"), workspace:FindFirstChild("NPCs")
		local npc = npcs and npcs:FindFirstChild(shopName)
		local part = npc and (npc:FindFirstChild("DialogPart") or npc:FindFirstChild("HumanoidRootPart"))
		local hrp = getHRP()
		local home = hrp and hrp.CFrame
		if part and hrp then
			State.Status = "Shop: going to " .. shopName
			goTo(part.CFrame * CFrame.new(0, 0, 4), 60, function() return not unloaded() end)
		end
		Catalog.data = nil
		RequestShopCatalog:FireServer(shopName)
		local t0 = os.clock()
		while not Catalog.data and os.clock() - t0 < 5 do task.wait(0.1) end
		local d = Catalog.data
		local remote = d and R(d.channel)
		if remote then
			State.Status = "Shop: buying potions"
			for _, w in ipairs({ { opt("PotionName", "Health Potion"), optN("BuyHealthTo", 10) }, { "Sanity Potion", optN("BuySanityTo", 5) } }) do
				local need = w[2] - countTools(w[1])
				for _, e in ipairs(d.entries) do
					local label = string.lower(tostring(e.name or e.key))
					if need > 0 and not e.sold and e.key ~= nil and not e.costItem and string.find(label, string.lower(w[1]), 1, true) and (tonumber(e.price) or 0) <= optN("MaxBuyPrice", 5000) then
						for _ = 1, need do
							pcall(function() remote:FireServer(e.key) end)
							bought += 1
							task.wait(0.4)
						end
						need = 0
					end
				end
			end
		end
		pcall(function() LP.PlayerGui.ShopGui.Enabled = false end)
		if home and alive() then goTo(home, 60, function() return not unloaded() end) end
	end)
	State.Buying = false
	stopMove()
	return bought
end

local ClaimDailyReward, DailyRewardsSync = R("ClaimDailyReward"), R("DailyRewardsSync")
local function claimDaily()
	local p = State.Daily
	if not (ClaimDailyReward and type(p) == "table" and type(p.Days) == "table") then return 0 end
	local n = 0
	for i = 1, 7 do
		local d = p.Days[i]
		if d and d.State == "Claim" then
			pcall(function() ClaimDailyReward:FireServer(i) end)
			n += 1
			task.wait(0.8)
		end
	end
	return n
end
if DailyRewardsSync then
	DailyRewardsSync.OnClientEvent:Connect(function(p)
		State.Daily = p
		if not unloaded() and opt("AutoDaily", true) then task.delay(1.5, claimDaily) end
	end)
end

local espRoot = Instance.new("Folder")
espRoot.Name = "TX_ESP"
if not pcall(function() espRoot.Parent = (gethui and gethui()) or game:GetService("CoreGui") end) or not espRoot.Parent then
	espRoot.Parent = LP:WaitForChild("PlayerGui")
end
local espCache = {}
local function espRemove(i) local e = espCache[i]; if e then e.gui:Destroy(); espCache[i] = nil end end
local function espSet(i, adornee, color, text)
	local e = espCache[i]
	if not (e and e.gui.Adornee == adornee) then
		espRemove(i)
		local g = new("BillboardGui", { Adornee = adornee, AlwaysOnTop = true, Size = UDim2.fromOffset(160, 34), StudsOffset = Vector3.new(0, 3, 0), MaxDistance = 1e5 }, espRoot)
		e = { gui = g, label = new("TextLabel", { BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Font = FONT, TextSize = 13, TextStrokeTransparency = 0.3 }, g) }
		espCache[i] = e
	end
	e.label.TextColor3, e.label.Text = color, text
end
task.spawn(function()
	while not unloaded() do
		task.wait(0.5)
		local hrp, wantP, wantM, wantI = getHRP(), opt("ESPPlayers", false), opt("ESPMobs", false), opt("ESPItems", false)
		if not (wantP or wantM or wantI) or not hrp then
			for i in pairs(espCache) do espRemove(i) end
		else
			local range, seen = optN("ESPRange", 600), {}
			local function add(i, part, color, label)
				local d = part and (part.Position - hrp.Position).Magnitude or math.huge
				if d <= range then seen[i] = true; espSet(i, part, color, ("%s\n%dm"):format(label, d)) end
			end
			if wantP then
				for _, pl in ipairs(Players:GetPlayers()) do
					local c = pl ~= LP and pl.Character
					local h = c and c:FindFirstChildOfClass("Humanoid")
					if h then add(pl, c:FindFirstChild("HumanoidRootPart"), Color3.fromRGB(90, 200, 255), ("%s [%d HP]"):format(pl.Name, h.Health)) end
				end
			end
			local mf, df = workspace:FindFirstChild("Monsters"), workspace:FindFirstChild("Drops")
			if wantM and mf then
				for _, m in ipairs(mf:GetChildren()) do
					if m:IsA("Model") and mobAlive(m) and not isPlayerModel(m) then
						local col = isPriority(m) and Color3.fromRGB(255, 200, 60) or Color3.fromRGB(255, 80, 80)
						add(m, m.HumanoidRootPart, col, ("%s [%d HP]"):format(m.Name, m:FindFirstChildOfClass("Humanoid").Health))
					end
				end
			end
			if wantI then
				if df then for _, d in ipairs(df:GetChildren()) do if isPickup(d) then add(d, getPart(d), ACC, ("%s [%s]"):format(d.Name, d:GetAttribute("Rarity") or "Common")) end end end
				for c in pairs(Chests) do if c.Parent then add(c, getPart(c), Color3.fromRGB(255, 220, 60), c.Name .. " [Chest]") end end
			end
			for i in pairs(espCache) do if not seen[i] or not i.Parent then espRemove(i) end end
		end
	end
	for i in pairs(espCache) do espRemove(i) end
	espRoot:Destroy()
end)

local Mods = { speed = nil }
local hbConn = RunService.Heartbeat:Connect(function()
	local hum = getHum()
	if unloaded() or not hum or hum.Health <= 0 then return end
	if opt("SpeedHack", false) then
		Mods.speed = Mods.speed or hum.WalkSpeed
		hum.WalkSpeed = optN("SpeedValue", 32)
	elseif Mods.speed then
		hum.WalkSpeed = Mods.speed
		Mods.speed = nil
	end
	if opt("AntiRagdoll", true) then
		local st = hum:GetState()
		if st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then hum:ChangeState(Enum.HumanoidStateType.GettingUp) end
		local hrp = getHRP()
		if hrp and hrp.Anchored then hrp.Anchored = false end
	end
end)
local jumpConn = UIS.JumpRequest:Connect(function()
	if opt("InfJump", false) then local h = getHum(); if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end end
end)
local idleConn = LP.Idled:Connect(function()
	if opt("AntiAFK", true) then pcall(function() VirtualUser:CaptureController(); VirtualUser:ClickButton2(Vector2.new()) end) end
end)
LP.CharacterAdded:Connect(function() Mods.speed = nil; State.PartsAt = 0; Mover.Goal = nil end)

local WAYPOINTS = {
	{ "Glade", "The Glade" }, { "Sky", "Sky's Reach" }, { "Echohold", "Echohold" }, { "Ironkeep", "Ironkeep" }, { "Crypt", "The Weeping Crypt" },
	{ "Scorch", "The Scorch Basin" }, { "Shimmer", "The Shimmering Sanctum" }, { "Cyst", "The Cyst" }, { "Lone", "The Lone Pillar" },
	{ "Fissure", "The Unstable Fissure" }, { "Aetherglow", "Aetherglow" }, { "TheTwentyShelves", "The Twenty Shelves" }, { "CampZero", "Camp Zero" },
	{ "Colosseum", "The Colosseum" }, { "Manor", "Manor" }, { "Pale", "The Pale" }, { "Belltower", "Belltower" },
}
local wpKey, wpNames = {}, {}
for _, w in ipairs(WAYPOINTS) do wpKey[w[2]] = w[1]; wpNames[#wpNames + 1] = w[2] end
local WP_SPOTS = { ["The Weeping Crypt"] = Vector3.new(-1515.40259, 94.6138229, -1730.42505) }

local function tpWaypoint(name)
	local key, hrp = wpKey[name], getHRP()
	if not (key and hrp and TeleportToWaypoint) then return false end
	local p0, t0 = hrp.Position, os.clock()
	pcall(function() TeleportToWaypoint:FireServer(key) end)
	while os.clock() - t0 < 6 and alive() and not unloaded() do
		task.wait(0.2)
		local h = getHRP()
		if h and (h.Position - p0).Magnitude > 30 then break end
	end
	task.wait(0.6)
	local h, spot = getHRP(), WP_SPOTS[name]
	if h and spot then h.CFrame = CFrame.new(spot + Vector3.new(0, 3, 0)); zeroVel() end
	return true
end

local function ensureWaypoint()
	if farmMode() ~= "2" then State.WpCenter = nil; return true end
	local name = opt("FarmWaypoint", wpNames[1])
	local key, hrp = wpKey[name], getHRP()
	if not (key and hrp and TeleportToWaypoint) then return true end
	local rad, c = WP_SPOTS[name] and optN("SpotRadius", 150) or optN("WpRadius", 500), State.WpCenter
	State.WpRange = rad
	local d = c and (hrp.Position - c) or Vector3.zero
	if (not c or State.WpKey ~= key or Vector3.new(d.X, 0, d.Z).Magnitude > rad + 150) and os.clock() - (State.WpAt or 0) > 8 then
		State.WpAt, State.Status = os.clock(), "Teleport: " .. name
		stopMove()
		tpWaypoint(name)
		local h = getHRP()
		if h then State.WpCenter, State.WpKey = WP_SPOTS[name] or h.Position, key end
		return false
	end
	return State.WpCenter ~= nil and State.WpKey == key
end

local function stopAll()
	setOpt("AutoFarm", false)
	setOpt("AutoSell", false)
	State.Target, State.Fleeing, State.LootUntil, State.Status = nil, false, 0, "Idle"
	stopMove()
end

local Black, Tracker, origFPS = { On = false }, { t0 = os.clock(), silver0 = lstat("Silver"), kills0 = lstat("Kills") }, nil
local function resetStats() Tracker.t0, Tracker.silver0, Tracker.kills0 = os.clock(), lstat("Silver"), lstat("Kills") end

local isl = new("ScreenGui", { Name = "TrippleXIsland", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 150 }, guiParent())
local pill = new("TextButton", { AnchorPoint = Vector2.new(.5, 0), Position = UDim2.new(.5, 0, 0, 6), Size = UDim2.fromOffset(250, 34), BackgroundColor3 = Color3.new(0, 0, 0), Text = "", AutoButtonColor = false, ClipsDescendants = true }, isl)
corner(pill, 17); stroke(pill, Color3.fromRGB(45, 45, 52))
local dot = new("Frame", { Size = UDim2.fromOffset(8, 8), Position = UDim2.fromOffset(14, 13), BorderSizePixel = 0 }, pill)
corner(dot, 4)
local isTop = lbl(pill, HUB, 13, TEXT)
isTop.Position, isTop.Size, isTop.TextTruncate = UDim2.fromOffset(30, 0), UDim2.new(1, -40, 0, 34), Enum.TextTruncate.AtEnd
local isBody = lbl(pill, "", 13, SUB)
isBody.Position, isBody.Size, isBody.TextYAlignment = UDim2.fromOffset(16, 40), UDim2.new(1, -32, 0, 64), Enum.TextYAlignment.Top
local isBtn = new("TextButton", { Text = "Black Screen", Font = BOLD, TextSize = 13, TextColor3 = TEXT, BackgroundColor3 = Color3.fromRGB(28, 28, 34), AutoButtonColor = false, Position = UDim2.fromOffset(16, 108), Size = UDim2.new(1, -32, 0, 26) }, pill)
corner(isBtn, 13)
local islOpen = false
pill.MouseButton1Click:Connect(function()
	islOpen = not islOpen
	tween(pill, .3, { Size = islOpen and UDim2.fromOffset(math.min(340, ((workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X) or 400) - 20), 146) or UDim2.fromOffset(250, 34) })
end)

local bsGui = new("ScreenGui", { Name = "TrippleXBlack", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 90, Enabled = false }, guiParent())
local bsFrame = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Active = true }, bsGui)
local bsTime = lbl(bsFrame, "00:00:00", 60, TEXT, Enum.TextXAlignment.Center, BOLD)
bsTime.AnchorPoint, bsTime.Position, bsTime.Size = Vector2.new(.5, .5), UDim2.fromScale(.5, .38), UDim2.fromOffset(600, 80)
local bsInfo = lbl(bsFrame, "", 18, ACC, Enum.TextXAlignment.Center)
bsInfo.AnchorPoint, bsInfo.Position, bsInfo.Size, bsInfo.TextYAlignment = Vector2.new(.5, 0), UDim2.fromScale(.5, .45), UDim2.fromOffset(700, 140), Enum.TextYAlignment.Top

local function setBlack(on)
	on = on and true or false
	if on == Black.On then return end
	Black.On, bsGui.Enabled = on, on
	pcall(function() RunService:Set3dRenderingEnabled(not on) end)
	if on then
		if getfpscap and origFPS == nil then pcall(function() origFPS = getfpscap() end) end
		if setfpscap then pcall(setfpscap, optN("BlackFPS", 20)) end
	else
		if setfpscap then pcall(setfpscap, origFPS or 60) end
		origFPS = nil
	end
	isBtn.Text = on and "Close Black Screen" or "Black Screen"
end
isBtn.MouseButton1Click:Connect(function() setBlack(not Black.On) end)
local bsClose = new("TextButton", { AnchorPoint = Vector2.new(.5, 1), Position = UDim2.new(.5, 0, 1, -40), Size = UDim2.fromOffset(150, 38), BackgroundColor3 = Color3.fromRGB(30, 30, 40), Text = "Close", Font = BOLD, TextSize = 14, TextColor3 = TEXT, AutoButtonColor = true }, bsFrame)
corner(bsClose, 10)
bsClose.MouseButton1Click:Connect(function() setBlack(false) end)

task.spawn(function()
	while not unloaded() do
		task.wait(0.5)
		local e = os.clock() - Tracker.t0
		local hrs, silver, k = math.max(e / 3600, 1 / 3600), lstat("Silver"), lstat("Kills")
		local n, cap = bagInfo()
		isl.Enabled = opt("ShowIsland", true) == true
		isTop.Text = ("%s  %s"):format(State.Status, clock(e))
		dot.BackgroundColor3 = farmOn() and ACC or Color3.fromRGB(110, 110, 118)
		local body = ("Silver %s (+%s/h)\nKills %s (%s/h)\nBag %d / %d"):format(
			commas(silver), commas(math.max(silver - Tracker.silver0, 0) / hrs), commas(k), commas(math.max(k - Tracker.kills0, 0) / hrs), n, cap)
		isBody.Text = body
		if Black.On then bsTime.Text, bsInfo.Text = clock(e), State.Status .. "\n" .. body end
	end
end)

local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled
local viewport = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or Vector2.new(1280, 720)
local Window = Fluent:CreateWindow({
	Title = HUB,
	SubTitle = "v4  |  The Veil",
	TabWidth = isMobile and 105 or 160,
	Size = UDim2.fromOffset(math.clamp(viewport.X - 40, 320, 640), math.clamp(viewport.Y - 40, 260, 520)),
	Acrylic = not isMobile,
	Theme = "Dark",
	MinimizeKey = Enum.KeyCode.LeftControl,
})
local Tabs = {
	Farm = Window:AddTab({ Title = "Auto Farm", Icon = "swords" }),
	Weap = Window:AddTab({ Title = "Weapons", Icon = "sword" }),
	Loot = Window:AddTab({ Title = "Loot & Shop", Icon = "package" }),
	Combat = Window:AddTab({ Title = "Combat", Icon = "heart" }),
	Vis = Window:AddTab({ Title = "Visuals", Icon = "eye" }),
	Misc = Window:AddTab({ Title = "Misc", Icon = "wrench" }),
	Settings = Window:AddTab({ Title = "Settings", Icon = "settings" }),
}

local IGN = { "AutoFarm" }
local function tog(S, id, title, def, cb)
	return S:AddToggle(id, { Title = title, Default = def or false, Callback = cb })
end

local function sld(S, id, title, def, min, max, rnd)
	RANGE[id] = { min, max }
	local boxId = id .. "_Box"
	IGN[#IGN + 1] = boxId
	local lock = false
	local slider = S:AddSlider(id, { Title = title, Default = def, Min = min, Max = max, Rounding = rnd or 0 })
	local box = S:AddInput(boxId, {
		Title = title .. " (type)", Default = tostring(def), Placeholder = tostring(def), Numeric = false, Finished = true,
		Callback = function(v)
			if lock then return end
			local n = tonumber(v)
			if n then
				lock = true
				pcall(function() slider:SetValue(math.clamp(n, min, max)) end)
				lock = false
			end
		end,
	})
	slider:OnChanged(function(v)
		if lock then return end
		lock = true
		pcall(function() box:SetValue(tostring(v)) end)
		lock = false
	end)
	return slider
end
local function ddn(S, id, title, values, def, multi)
	local d = def
	if not multi and type(def) == "string" then d = table.find(values, def) or 1 end
	return S:AddDropdown(id, { Title = title, Values = values, Multi = multi or false, Default = d })
end
local function inp(S, id, title, def)
	return S:AddInput(id, { Title = title, Default = tostring(def), Placeholder = tostring(def), Numeric = false, Finished = false })
end
local function btn(S, title, cb) S:AddButton({ Title = title, Callback = cb }) end

local PRESETS = {
	Safe = { HealPercent = 55, FleePercent = 30, ResumePercent = 85, SkipBosses = true },
	Balanced = { HealPercent = 40, FleePercent = 20, ResumePercent = 70, SkipBosses = false },
	Fast = { HealPercent = 30, FleePercent = 15, ResumePercent = 60, SkipBosses = false },
}
local function applyPreset(n) for k, v in pairs(PRESETS[n] or PRESETS.Balanced) do setOpt(k, v) end end

local StatusP, BagP

do
	local s = Tabs.Farm:AddSection("Auto Farm")
	StatusP = s:AddParagraph({ Title = "Status", Content = "Idle" })
	tog(s, "AutoFarm", "Auto Farm Mobs", false, function(v)
		if not v then State.Target, State.LootUntil, State.Status = nil, 0, "Idle"; stopMove() end
	end)
	tog(s, "AutoAttack", "Auto Attack", true)
	tog(s, "AutoEquip", "Auto Equip Weapon", true)
	tog(s, "StickToTarget", "Stick To Target", true)
	sld(s, "StuckTimeout", "Skip Target After (s)", 40, 10, 120)

	local q = Tabs.Farm:AddSection("Quick Start")
	ddn(q, "Preset", "Preset", { "Safe", "Balanced", "Fast" }, "Balanced")
	btn(q, "Quick Start", function()
		applyPreset(opt("Preset", "Balanced"))
		for _, k in ipairs({ "AutoFarm", "AutoAttack", "AutoEquip", "AutoPickup", "AutoChest", "AutoHeal" }) do setOpt(k, true) end
		notify("Quick Start: ON")
	end)
	btn(q, "Apply Preset Only", function() applyPreset(opt("Preset", "Balanced")); notify("Preset applied") end)
	btn(q, "Stop All", stopAll)

	local fm = Tabs.Farm:AddSection("Farm Mode")
	ddn(fm, "FarmMode", "Mode", { "1. Closest", "2. Waypoint" }, "1. Closest")
	ddn(fm, "FarmWaypoint", "Waypoint (mode 2)", wpNames, wpNames[1])
	sld(fm, "WpRadius", "Radius Around Waypoint", 500, 100, 3000)
	sld(fm, "SpotRadius", "Crypt Spot Radius", 150, 50, 500)

	local tg = Tabs.Farm:AddSection("Targeting")
	ddn(tg, "MobSelect", "Target Mobs (empty = all)", getMobNames(), {}, true)
	ddn(tg, "TargetMode", "Sort By", { "Closest", "Lowest HP", "Highest HP" }, "Closest")
	tog(tg, "AvoidContest", "Avoid Mobs Others Fight", true)
	sld(tg, "ContestRadius", "Contest Radius", 50, 10, 150)
	inp(tg, "NeverAttack", "Never Attack (comma)", "Training Dummy, Runner")
	sld(tg, "MobRange", "Max Range", 3000, 100, 10000)
	tog(tg, "SkipBosses", "Skip Bosses", false)
	sld(tg, "BossHP", "Boss = Max HP >=", 3000, 300, 50000)

	local pr = Tabs.Farm:AddSection("Priority Mobs")
	ddn(pr, "PriorityMobs", "Priority Mobs", getMobNames(), {}, true)
	inp(pr, "PriorityTyped", "Priority Names (typed, comma, left = first)", "")
	ddn(pr, "PriorityWeapon", "Weapon For Priority Mobs", { AUTO_SWORD }, AUTO_SWORD)
	ddn(pr, "PriorityMagicMode", "Magic Mode For Priority Mobs", { SAME, "Off", "Mix (Sword + Magic)", "Magic Only" }, SAME)
	ddn(pr, "PriorityMagic", "Magic Weapon For Priority Mobs", { SAME, AUTO_STAFF }, SAME)
	tog(pr, "PrioSwitch", "Switch To Priority Mob Mid-Fight", true)
	btn(pr, "Refresh Mob + Weapon Lists", function()
		local names = getMobNames()
		for _, id in ipairs({ "MobSelect", "PriorityMobs" }) do
			local o = Options[id]
			if o then
				local keep = o.Value
				pcall(function() o:SetValues(names) end)
				pcall(function() o:SetValue(keep) end)
			end
		end
		refreshWeapons()
		notify("Lists refreshed")
	end)

	local ps = Tabs.Farm:AddSection("Movement")
	ddn(ps, "PosMode", "Attack Position", { "Behind", "Front", "Above" }, "Behind")
	sld(ps, "HeightOffset", "Height", 3, -5, 50)
	sld(ps, "DistOffset", "Distance", 4, 1, 15)
	sld(ps, "TweenSpeed", "Move Speed (studs/s)", 140, 20, 600)
	sld(ps, "Smoothness", "Smoothness", 0.6, 0.1, 1, 2)
	tog(ps, "Noclip", "Noclip While Farming", true)
	tog(ps, "SafePlatform", "Safe Platform", true)

	local r = Tabs.Farm:AddSection("Reliability")
	tog(r, "AutoRejoin", "Auto Rejoin On Disconnect", true)
end

do
	local w = Tabs.Weap:AddSection("Sword / Melee")
	ddn(w, "WeaponPick", "Weapon", { AUTO_SWORD }, AUTO_SWORD)
	inp(w, "WeaponRules", "Weapon Rules (Mob=Weapon, comma)", "")
	sld(w, "AttackRange", "Attack Range", 20, 5, 40)
	btn(w, "Refresh Weapon List", function() refreshWeapons(); notify("Weapon list refreshed") end)

	local a = Tabs.Weap:AddSection("Abilities (R T V Y U)")
	tog(a, "AutoAbilities", "Auto Abilities", true)
	sld(a, "AbilityRange", "Use Within (studs)", 25, 5, 80)
	for _, k in ipairs({ "R", "T", "V", "Y", "U" }) do tog(a, "Ability" .. k, "Use " .. k, true) end

	local m = Tabs.Weap:AddSection("Magic Staff")
	ddn(m, "MagicMode", "Magic Mode", { "Off", "Mix (Sword + Magic)", "Magic Only" }, "Off")
	ddn(m, "MagicPick", "Staff", { AUTO_STAFF }, AUTO_STAFF)
	ddn(m, "AimMode", "Aim Mode", { "Predict", "Target" }, "Predict")
	sld(m, "CastRange", "Cast Range", 60, 10, 150)
	sld(m, "CastDelay", "Cast Delay (s)", 1.2, 0.2, 5, 1)
	sld(m, "EquipWait", "Equip Wait (s)", 0.12, 0.05, 0.5, 2)
	sld(m, "MagicDist", "Magic Only Distance", 20, 8, 60)
end

do
	local p = Tabs.Loot:AddSection("Pickup")
	tog(p, "AutoPickup", "Auto Pickup Drops", true)
	tog(p, "AutoChest", "Auto Open Chests", true)
	ddn(p, "DropRarity", "Rarity (empty = all)", RARITIES, {}, true)
	inp(p, "AlwaysPick", "Always Pick Up (names)", "Potion, Event, Star Fruit")
	sld(p, "DropRange", "Pickup Range", 400, 20, 3000)
	tog(p, "LootWait", "Wait For Loot After Kill", true)
	sld(p, "LootWaitTime", "Wait After Mob (s)", 4, 1, 20)
	sld(p, "BossLootWait", "Wait After Boss (s)", 12, 3, 40)

	local b = Tabs.Loot:AddSection("Bag")
	BagP = b:AddParagraph({ Title = "Bag", Content = "..." })

	local s = Tabs.Loot:AddSection("Auto Sell")
	tog(s, "AutoSell", "Auto Sell", false)
	tog(s, "SellOnFull", "Sell When Bag Full", true)
	tog(s, "SellGoMerchant", "Walk To Merchant First", false)
	ddn(s, "SellRarity", "Sell Rarity (none = sell nothing)", RARITIES, { "Common" }, true)
	inp(s, "SellKeepNames", "Never Sell (names)", "Bag, Key")
	sld(s, "SellInterval", "Sell Every (s)", 45, 5, 300)
	btn(s, "Sell Now", function() task.spawn(function() notify(("Sold %d item(s)"):format(sellRun())) end) end)

	local sh = Tabs.Loot:AddSection("Potion Shop")
	tog(sh, "AutoBuy", "Auto Buy Potions", false)
	inp(sh, "ShopNPC", "Shop NPC", "Calvin, Potion Specialist")
	sld(sh, "BuyBelow", "Restock When Below", 3, 1, 30)
	sld(sh, "BuyHealthTo", "Health Potions To Keep", 10, 1, 60)
	sld(sh, "BuySanityTo", "Sanity Potions To Keep", 5, 0, 40)
	sld(sh, "MaxBuyPrice", "Max Price Per Item", 5000, 10, 100000)
	btn(sh, "Buy Potions Now", function() task.spawn(function() notify(("Bought %d item(s)"):format(buyPotions())) end) end)
end

do
	local h = Tabs.Combat:AddSection("Healing")
	tog(h, "AutoHeal", "Auto Heal (Potion)", true)
	inp(h, "PotionName", "Potion Name", "Health Potion")
	sld(h, "HealPercent", "Heal Below HP %", 40, 5, 95)
	tog(h, "SafeFlee", "Flee When HP Low", true)
	sld(h, "FleePercent", "Flee Below HP %", 20, 5, 60)
	sld(h, "ResumePercent", "Resume Above HP %", 70, 30, 100)
	sld(h, "FleeHeight", "Flee Height", 60, 20, 200)

	local sn = Tabs.Combat:AddSection("Sanity")
	tog(sn, "AutoSanity", "Auto Sanity Potion", true)
	sld(sn, "SanityBelow", "Drink Below Sanity", 40, 5, 95)
end

do
	local e = Tabs.Vis:AddSection("ESP")
	tog(e, "ESPPlayers", "Players", false)
	tog(e, "ESPMobs", "Mobs", false)
	tog(e, "ESPItems", "Items & Chests", false)
	sld(e, "ESPRange", "Max Distance", 600, 50, 5000)
end

do
	local m = Tabs.Misc:AddSection("Player")
	tog(m, "AntiAFK", "Anti-AFK", true)
	tog(m, "AntiRagdoll", "Anti Ragdoll", true)
	tog(m, "SpeedHack", "Speed Hack", false)
	sld(m, "SpeedValue", "Speed", 32, 16, 150)
	tog(m, "InfJump", "Infinite Jump", false)
	tog(m, "AutoDaily", "Auto Claim Daily Reward", true)
	btn(m, "Claim Daily Now", function() task.spawn(function() notify(("Claimed %d reward(s)"):format(claimDaily())) end) end)

	local t = Tabs.Misc:AddSection("Teleport")
	ddn(t, "WaypointSelect", "Waypoint", wpNames, wpNames[1])
	btn(t, "Teleport", function() task.spawn(tpWaypoint, opt("WaypointSelect", wpNames[1])) end)
	btn(t, "Stop Movement", stopMove)

	local bs = Tabs.Misc:AddSection("AFK / Black Screen")
	btn(bs, "Black Screen (End)", function() setBlack(not Black.On) end)
	sld(bs, "BlackFPS", "FPS Cap In Black Screen", 20, 5, 60)
	tog(bs, "ShowIsland", "Show Dynamic Island", true)
	tog(bs, "ShowMobileButtons", "Mobile Buttons (Menu / Stop / Black)", isMobile)
	btn(bs, "Reset Timer / Profit", resetStats)
end

do
	local k = Tabs.Settings:AddSection("Menu")
	k:AddParagraph({ Title = "Hotkeys", Content = "Hide / Show: Left Ctrl or the Menu button\nStop All: Delete or the Stop button\nBlack Screen: End or the Black button" })
	btn(k, "Unload Script", function() Fluent:Destroy() end)

	SaveManager:SetLibrary(Fluent)
	InterfaceManager:SetLibrary(Fluent)
	SaveManager:IgnoreThemeSettings()
	SaveManager:SetIgnoreIndexes(IGN)
	InterfaceManager:SetFolder("TrippleXHub")
	SaveManager:SetFolder("TrippleXHub/" .. tostring(game.PlaceId))
	InterfaceManager:BuildInterfaceSection(Tabs.Settings)
	SaveManager:BuildConfigSection(Tabs.Settings)
end

local function toggleUI()
	if not pcall(function() Window:Minimize() end) then
		pcall(function() Fluent.GUI.Enabled = not Fluent.GUI.Enabled end)
	end
end
local mgui = new("ScreenGui", { Name = "TrippleXMobile", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 149 }, guiParent())
local mb = new("Frame", { Size = UDim2.fromOffset(58, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.new(0, 8, 0.28, 0), BackgroundTransparency = 1 }, mgui)
new("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, mb)
local function mbtn(text, order, cb)
	local b = new("TextButton", { Size = UDim2.fromOffset(58, 40), BackgroundColor3 = Color3.fromRGB(16, 16, 22), BackgroundTransparency = 0.1, Text = text, Font = BOLD, TextSize = 13, TextColor3 = TEXT, AutoButtonColor = true, LayoutOrder = order }, mb)
	corner(b, 10)
	stroke(b, Color3.fromRGB(110, 70, 200))
	b.MouseButton1Click:Connect(cb)
end
mbtn("Menu", 1, toggleUI)
mbtn("Stop", 2, stopAll)
mbtn("Black", 3, function() setBlack(not Black.On) end)
task.spawn(function()
	while not unloaded() do
		mgui.Enabled = opt("ShowMobileButtons", isMobile) == true
		task.wait(0.5)
	end
end)

UIS.InputBegan:Connect(function(i, gp)
	if gp or unloaded() then return end
	if i.KeyCode == Enum.KeyCode.Delete then stopAll()
	elseif i.KeyCode == Enum.KeyCode.End then setBlack(not Black.On) end
end)

task.spawn(function()
	local lastS, lastB, lastM, lastW = nil, nil, "", ""
	local tick = 0
	while not unloaded() do
		task.wait(0.5)
		tick += 1
		if State.Status ~= lastS then
			lastS = State.Status
			pcall(function() StatusP:SetDesc(lastS) end)
		end
		local n, c = bagInfo()
		local txt = ("%d / %d%s"):format(n, c, n >= c and "  (FULL)" or "")
		if txt ~= lastB then
			lastB = txt
			pcall(function() BagP:SetDesc(txt) end)
		end
		if tick % 6 == 0 then
			local names = getMobNames()
			local key = table.concat(names, "|")
			if key ~= lastM then
				lastM = key
				for _, id in ipairs({ "MobSelect", "PriorityMobs" }) do
					local o = Options[id]
					if o then
						local keep = o.Value
						pcall(function() o:SetValues(names) end)
						pcall(function() o:SetValue(keep) end)
					end
				end
			end
			local wk = {}
			for _, t in ipairs(allTools()) do if isSword(t) or isCast(t) then wk[#wk + 1] = t.Name end end
			table.sort(wk)
			local wkey = table.concat(wk, "|")
			if wkey ~= lastW then lastW = wkey; refreshWeapons() end
		end
	end
end)

task.spawn(function()
	while not unloaded() do
		task.wait(0.5)
		if opt("AutoEquip", true) and farmOn() and alive() and not State.Healing and not State.Casting and magicMode(State.Target) ~= "Magic Only" then
			local want = swordFor(State.Target)
			if want and equipped() ~= want then equip(want) end
		end
	end
end)

task.spawn(function()
	while not unloaded() do
		local delay = 0.1
		if opt("AutoAttack", true) and farmOn() and alive() and not State.Healing and not State.Selling and not State.Casting and magicMode(State.Target) ~= "Magic Only" then
			local tool, t = equipped(), State.Target
			if tool and isSword(tool) and mobAlive(t) and (getHRP().Position - t.HumanoidRootPart.Position).Magnitude <= optN("AttackRange", 20) then
				pcall(function() tool:Activate() end)
				delay = math.max(stat(tool, "AttackCooldown", 0.5), 0.1)
			end
		end
		task.wait(delay)
	end
end)

local CastCD = {}
task.spawn(function()
	while not unloaded() do
		task.wait(0.1)
		local t, hrp = State.Target, getHRP()
		local mode = magicMode(t)
		if mode ~= "Off" and farmOn() and alive() and not State.Healing and not State.Selling and not State.Fleeing and hrp and mobAlive(t)
			and (t.HumanoidRootPart.Position - hrp.Position).Magnitude <= optN("CastRange", 60) then
			for _, tool in ipairs(staffs(t)) do
				if (CastCD[tool] or 0) <= os.clock() then
					CastCD[tool] = os.clock() + optN("CastDelay", 1.2)
					State.Casting = true
					pcall(function()
						if equipped() ~= tool then equip(tool); task.wait(optN("EquipWait", 0.12)) end
						if mobAlive(t) then castAt(tool, t) end
						task.wait(0.12)
						if mode ~= "Magic Only" then equip(swordFor(State.Target)) end
					end)
					State.Casting = false
					break
				end
			end
		end
	end
end)

local function sanity()
	local c = getChar()
	local v = c and c:FindFirstChild("Values")
	v = v and v:FindFirstChild("Sanity")
	return v and tonumber(v.Value) or 100
end
local function drink(kw)
	local potion = findTool(kw)
	if not potion then return false end
	local prev = equipped()
	State.Healing = true
	equip(potion)
	task.wait(0.15)
	pcall(function() potion:Activate() end)
	task.wait(0.8)
	if prev and prev.Parent then equip(prev) end
	State.Healing = false
	return true
end
task.spawn(function()
	while not unloaded() do
		task.wait(0.4)
		if alive() and not State.Healing and not State.Buying then
			if opt("AutoHeal", true) and hpPct() < optN("HealPercent", 40) then
				if not drink(opt("PotionName", "Health Potion")) then task.wait(2) end
			elseif opt("AutoSanity", true) and sanity() < optN("SanityBelow", 40) then
				if not drink("Sanity Potion") then task.wait(5) end
			end
		end
	end
end)

task.spawn(function()
	while not unloaded() do
		task.wait(20)
		if opt("AutoBuy", false) and alive() and not inMenu() and not State.Healing and not State.Selling then
			local below = optN("BuyBelow", 3)
			if countTools(opt("PotionName", "Health Potion")) < below or (optN("BuySanityTo", 5) > 0 and countTools("Sanity Potion") < math.min(below, optN("BuySanityTo", 5))) then
				if buyPotions() == 0 then task.wait(120) end
			end
		end
	end
end)

local AbilityCD = {}
do
	local ev = R("AbilityCooldownEvent")
	if ev then ev.OnClientEvent:Connect(function(k, d) AbilityCD[k] = d end) end
end
task.spawn(function()
	while not unloaded() do
		task.wait(0.2)
		local t, tool, hrp = State.Target, equipped(), getHRP()
		if opt("AutoAbilities", true) and farmOn() and alive() and not State.Healing and not State.Selling and not State.Fleeing and not State.Casting
			and tool and isSword(tool) and hrp and mobAlive(t) then
			local tp = t.HumanoidRootPart.Position
			if (tp - hrp.Position).Magnitude <= optN("AbilityRange", 25) then
				for _, k in ipairs({ "R", "T", "V", "Y", "U" }) do
					local cd = AbilityCD[k]
					local ready = (not cd) or ((cd.duration or 0) <= workspace:GetServerTimeNow() - (cd.startTime or 0))
					local ev = opt("Ability" .. k, true) and ready and R(k .. "AbilityEvent")
					if ev then
						pcall(function() ev:FireServer(tool, CFrame.lookAt(hrp.Position, tp)) end)
						AbilityCD[k] = { duration = 1, startTime = workspace:GetServerTimeNow() }
						task.wait(0.15)
					end
				end
			end
		end
	end
end)

local rejoining = false
local function rejoin()
	if rejoining or not opt("AutoRejoin", true) then return end
	rejoining = true
	task.spawn(function()
		for _ = 1, 8 do
			pcall(function() TeleportService:Teleport(game.PlaceId, LP) end)
			task.wait(8)
		end
		rejoining = false
	end)
end
GuiService.ErrorMessageChanged:Connect(function(msg) if msg and msg ~= "" then task.wait(1.5); rejoin() end end)
task.spawn(function()
	pcall(function()
		local ov = game:GetService("CoreGui"):WaitForChild("RobloxPromptGui", 10):WaitForChild("promptOverlay", 10)
		ov.ChildAdded:Connect(function(c) if c.Name == "ErrorPrompt" then task.wait(1.5); rejoin() end end)
	end)
end)

local cachedDrop, nextScan = nil, 0
local function farmStep()
	if State.Selling or State.Buying then return end
	if not farmOn() then
		State.Target, State.Fleeing, State.LootUntil, cachedDrop = nil, false, 0, nil
		if Mover.Goal then stopMove() end
		task.wait(0.3)
		return
	end
	if not alive() or inMenu() then
		State.Target = nil
		State.Status = "Waiting for character..."
		stopMove()
		task.wait(1)
		return
	end

	if opt("SafeFlee", true) and hpPct() < optN("FleePercent", 20) then State.Fleeing = true end
	if State.Fleeing then
		State.Status = "Fleeing (low HP)"
		local hrp = getHRP()
		State.FleeY = State.FleeY or (hrp.Position.Y + optN("FleeHeight", 60))
		setGoal(CFrame.new(hrp.Position.X, State.FleeY, hrp.Position.Z))
		if hpPct() >= optN("ResumePercent", 70) then State.Fleeing, State.FleeY = false, nil end
		return
	end
	State.FleeY = nil
	if not ensureWaypoint() then return end

	if bagFull() then
		State.LootUntil = 0
		if opt("AutoSell", false) and opt("SellOnFull", true) and os.clock() - (State.LastFullSell or 0) > 30 then
			State.LastFullSell = os.clock()
			task.spawn(sellRun)
			return
		end
	end

	local prev = State.Target
	if prev and not mobAlive(prev) then
		State.Target = nil
		if opt("AutoPickup", true) and opt("LootWait", true) and not bagFull() then
			State.LootUntil = os.clock() + (State.TargetBoss and optN("BossLootWait", 12) or optN("LootWaitTime", 4))
		end
	end

	if opt("AutoPickup", true) then
		local inWin = os.clock() < State.LootUntil
		if inWin or os.clock() >= nextScan then
			cachedDrop = nextLoot()
			nextScan = os.clock() + (inWin and 0.2 or 0.5)
		end
		if cachedDrop and cachedDrop.Parent then
			collectLoot(cachedDrop)
			cachedDrop, nextScan = nil, 0
			if inWin then State.LootUntil = math.max(State.LootUntil, os.clock() + 2.5) end
			return
		elseif inWin then
			State.Status = ("Waiting for loot (%.0fs)"):format(State.LootUntil - os.clock())
			if State.TargetPos then setGoal(CFrame.new(State.TargetPos + Vector3.new(0, 3, 0))) end
			return
		end
	else
		cachedDrop, State.LootUntil = nil, 0
	end

	local t = State.Target
	if not mobAlive(t) then
		t = pickTarget()
		State.Target, State.TargetSince = t, os.clock()
		if t then
			State.TargetBoss = t:FindFirstChildOfClass("Humanoid").MaxHealth >= optN("BossHP", 3000)
		else
			State.Status = "No mobs found - waiting"
			stopMove()
			task.wait(0.3)
			return
		end
	end

	if opt("PrioSwitch", true) and not isPriority(t) and os.clock() - (State.PrioAt or 0) > 1 and hasPriority() then
		State.PrioAt = os.clock()
		local pm = pickTarget()
		if pm and pm ~= t and isPriority(pm) then
			t = pm
			State.Target, State.TargetSince = pm, os.clock()
			State.TargetBoss = pm:FindFirstChildOfClass("Humanoid").MaxHealth >= optN("BossHP", 3000)
		end
	end
	State.Status = ("Farming: %s [HP %d%%]"):format(t.Name, hpPct())
	if not opt("StickToTarget", true) and os.clock() - State.TargetSince > optN("StuckTimeout", 40) then
		State.Blacklist[t] = os.clock() + 60
		State.Target = nil
	else
		State.TargetPos = t.HumanoidRootPart.Position
		setGoal(attackCF(t))
	end
end

task.spawn(function()
	while not unloaded() do
		RunService.Heartbeat:Wait()
		local ok, err = pcall(farmStep)
		if not ok then
			warn("[TrippleX Hub] loop error (recovered): " .. tostring(err))
			State.Target, State.Casting = nil, false
			pcall(stopMove)
			task.wait(1)
		end
	end
end)

do
	local env = (getgenv and getgenv()) or _G
	env.TrippleXUnload = function() pcall(function() Fluent:Destroy() end) end
end
task.spawn(function()
	while not unloaded() do task.wait(0.5) end
	pcall(stopMove)
	moveConn:Disconnect(); stepConn:Disconnect(); hbConn:Disconnect(); jumpConn:Disconnect(); idleConn:Disconnect()
	local hum = getHum()
	if hum and Mods.speed then hum.WalkSpeed = Mods.speed end
	if Platform then Platform:Destroy() end
	pcall(function()
		RunService:Set3dRenderingEnabled(true)
		if setfpscap then setfpscap(origFPS or 60) end
		isl:Destroy()
		bsGui:Destroy()
		mgui:Destroy()
	end)
	pcall(function() Lighting.GlobalShadows = true; settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic end)
end)

Window:SelectTab(1)
notify("Loaded. Go to Auto Farm > Quick Start")
SaveManager:LoadAutoloadConfig()
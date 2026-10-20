do
	local env = (getgenv and getgenv()) or _G
	if env.TrippleXUnload then pcall(env.TrippleXUnload) end
	if env.TrippleXSplash and env.TrippleXSplash.Done then pcall(env.TrippleXSplash.Done) end
end


-- หน้าโหลด: นิ่ง ๆ แค่ fade
do
	local TweenService = game:GetService("TweenService")
	local ok, parent = pcall(function() return gethui and gethui() end)
	if not (ok and parent) then parent = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui") end

	local RED = Color3.fromRGB(235, 30, 40)
	local MIN_SHOW, FAILSAFE = 12, 30
	local LOGO = "rbxassetid://113614047568331"
	local alive, finishing = true, false

	local function mk(class, props, par)
		local o = Instance.new(class)
		for k, v in pairs(props) do o[k] = v end
		o.Parent = par
		return o
	end

	local gui = mk("ScreenGui", { Name = "TrippleXSplash", IgnoreGuiInset = true, ResetOnSpawn = false, DisplayOrder = 100000 }, parent)
	local root = mk("CanvasGroup", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Active = true, GroupTransparency = 1 }, gui)
	mk("ImageLabel", {
		Image = LOGO, BackgroundTransparency = 1, AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, -20),
		Size = UDim2.fromOffset(170, 170), ScaleType = Enum.ScaleType.Fit,
	}, root)
	local status = mk("TextLabel", {
		BackgroundTransparency = 1, Text = "Starting...", Font = Enum.Font.GothamMedium, TextSize = 15, TextColor3 = RED,
		AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.new(0.5, 0, 0.5, 110), Size = UDim2.fromOffset(460, 22),
	}, root)

	local function fadeStatus(text)
		if not alive then return end
		TweenService:Create(status, TweenInfo.new(0.12), { TextTransparency = 1 }):Play()
		task.delay(0.12, function()
			if not alive then return end
			status.Text = text
			TweenService:Create(status, TweenInfo.new(0.2), { TextTransparency = 0 }):Play()
		end)
	end

	local t0 = os.clock()
	local api = {}
	function api.Status(text) fadeStatus(tostring(text)) end
	function api.Done()
		if finishing then return end
		finishing = true
		task.spawn(function()
			local wait = MIN_SHOW - (os.clock() - t0)
			if wait > 0 then task.wait(wait) end
			fadeStatus("Ready")
			task.wait(0.35)
			TweenService:Create(root, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { GroupTransparency = 1 }):Play()
			task.wait(0.65)
			alive = false
			gui:Destroy()
		end)
	end
	local env = (getgenv and getgenv()) or _G
	env.TrippleXSplash = api

	TweenService:Create(root, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { GroupTransparency = 0 }):Play()
	task.delay(FAILSAFE, function() if alive then api.Done() end end)
end
do local e = (getgenv and getgenv()) or _G; e.TrippleXSay = function(t) if e.TrippleXSplash then e.TrippleXSplash.Status(t) end end end


;(((getgenv and getgenv()) or _G).TrippleXSay)("Building UI library...")

----------------------------------------------------------------------
-- TXUI  -  custom UI library (Xenon style, PC + mobile)
----------------------------------------------------------------------
local Lib = (function()
local Players = game:GetService("Players")
local TS = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local TextService = game:GetService("TextService")
local LP = Players.LocalPlayer

local Lib = { Flags = {} }

local T = {
	Main = Color3.fromRGB(18, 18, 18),
	Bar = Color3.fromRGB(16, 16, 20),
	Content = Color3.fromRGB(12, 14, 18),
	Card = Color3.fromRGB(21, 22, 27),
	Field = Color3.fromRGB(16, 17, 22),
	Popup = Color3.fromRGB(22, 23, 28),
	Stroke = Color3.fromRGB(40, 42, 50),
	Hover = Color3.fromRGB(30, 31, 38),
	Text = Color3.fromRGB(240, 240, 245),
	Sub = Color3.fromRGB(125, 127, 138),
	Accent = Color3.fromRGB(88, 98, 214),
	Off = Color3.fromRGB(70, 72, 84),
}
local F = { Reg = Enum.Font.BuilderSans, Med = Enum.Font.BuilderSansMedium, Bold = Enum.Font.BuilderSansBold }
local WHITE = Color3.new(1, 1, 1)
local AX, AY = Enum.TextXAlignment, Enum.AutomaticSize.Y

Lib.Icons = {
	boxes = { "rbxassetid://16898612819", Vector2.new(196, 771), Vector2.new(48, 48) },
	["chevron-down"] = { "rbxassetid://16898612819", Vector2.new(196, 918), Vector2.new(48, 48) },
	["chevron-up"] = { "rbxassetid://16898612819", Vector2.new(710, 918), Vector2.new(48, 48) },
	database = { "rbxassetid://16898613044", Vector2.new(710, 869), Vector2.new(48, 48) },
	server = { "rbxassetid://16898613777", Vector2.new(771, 0), Vector2.new(48, 48) },
	star = { "rbxassetid://16898613777", Vector2.new(967, 147), Vector2.new(48, 48) },
	["audio-lines"] = { "rbxassetid://16898612629", Vector2.new(355, 967), Vector2.new(48, 48) },
	["align-justify"] = { "rbxassetid://16898612629", Vector2.new(563, 820), Vector2.new(48, 48) },
	list = { "rbxassetid://16898613509", Vector2.new(869, 808), Vector2.new(48, 48) },
	eye = { "rbxassetid://3926307971", Vector2.new(44, 444), Vector2.new(36, 36) },
	cart = { "rbxassetid://3926305904", Vector2.new(200, 4), Vector2.new(24, 24) },
	bottom = { "rbxassetid://3926305904", Vector2.new(124, 524), Vector2.new(36, 36) },
	widgets = { "rbxassetid://3926307971", Vector2.new(644, 404), Vector2.new(36, 36) },
	save = { "rbxassetid://3926307971", Vector2.new(684, 404), Vector2.new(36, 36) },
}
local function setIcon(img, icon)
	if type(icon) == "string" and Lib.Icons[icon] then icon = Lib.Icons[icon] end
	if type(icon) == "table" then
		img.Image, img.ImageRectOffset, img.ImageRectSize = icon[1], icon[2], icon[3]
	elseif icon then
		img.Image = type(icon) == "number" and ("rbxassetid://" .. icon) or icon
	end
end

local function New(class, p, ch)
	local o = Instance.new(class)
	local parent
	for k, v in pairs(p or {}) do
		if k == "Parent" then parent = v else o[k] = v end
	end
	for _, c in ipairs(ch or {}) do c.Parent = o end
	o.Parent = parent
	return o
end
local function def(class, d)
	return function(p, ch)
		local t = table.clone(d)
		for k, v in pairs(p or {}) do t[k] = v end
		return New(class, t, ch)
	end
end
local Frame = def("Frame", { BorderSizePixel = 0, BackgroundColor3 = T.Card })
local Label = def("TextLabel", { BackgroundTransparency = 1, BorderSizePixel = 0, Font = F.Med, TextColor3 = T.Text, TextSize = 14, TextXAlignment = AX.Left, Text = "" })
local Button = def("TextButton", { BackgroundTransparency = 1, BorderSizePixel = 0, Text = "", AutoButtonColor = false, Font = F.Med, TextColor3 = T.Text, TextSize = 14 })
local Image = def("ImageLabel", { BackgroundTransparency = 1, BorderSizePixel = 0 })
local function Corner(p, r) return New("UICorner", { CornerRadius = UDim.new(0, r), Parent = p }) end
local function Stroke(p, c, t) return New("UIStroke", { Color = c or T.Stroke, Thickness = t or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border, Parent = p }) end
local function List(p, pad, dir) return New("UIListLayout", { Padding = UDim.new(0, pad or 0), SortOrder = Enum.SortOrder.LayoutOrder, FillDirection = dir or Enum.FillDirection.Vertical, Parent = p }) end
local function Pad(p, l, t, r, b) return New("UIPadding", { PaddingLeft = UDim.new(0, l), PaddingTop = UDim.new(0, t), PaddingRight = UDim.new(0, r or l), PaddingBottom = UDim.new(0, b or t), Parent = p }) end
local function tw(o, time, props, style, dir)
	local t = TS:Create(o, TweenInfo.new(time, style or Enum.EasingStyle.Quint, dir or Enum.EasingDirection.Out), props)
	t:Play()
	return t
end
local function hover(b, target, on, off)
	b.MouseEnter:Connect(function() tw(target, .15, on) end)
	b.MouseLeave:Connect(function() tw(target, .15, off) end)
end
local function isPress(i) return i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch end
local function isMove(i) return i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch end
local function guiParent()
	local ok, h = pcall(function() return gethui and gethui() end)
	if ok and h then return h end
	return LP:WaitForChild("PlayerGui")
end
local function textW(text, size, font)
	return TextService:GetTextSize(text, size, font, Vector2.new(1e4, 1e4)).X
end
local function mask(n)
	if #n <= 4 then return n end
	return n:sub(1, 2) .. string.rep("•", #n - 4) .. n:sub(-2)
end
local function Magnifier(parent, pos)
	local f = Frame({ BackgroundTransparency = 1, Size = UDim2.fromOffset(14, 14), Position = pos, AnchorPoint = Vector2.new(0, .5), Parent = parent })
	local c = Frame({ BackgroundTransparency = 1, Size = UDim2.fromOffset(9, 9), Parent = f })
	Corner(c, 5); Stroke(c, T.Sub, 1.5)
	Frame({ BackgroundColor3 = T.Sub, Size = UDim2.fromOffset(5, 1.5), Position = UDim2.fromOffset(8, 11), Rotation = 45, Parent = f })
end

function Lib:Window(o)
	o = o or {}
	local self = {}
	local win = self
	self.Unloaded = false
	self.Listening = false
	self.ToggleKey = o.ToggleKey or Enum.KeyCode.RightShift
	function self:SetToggleKey(k) if k then self.ToggleKey = k end end
	local accent = o.Accent or T.Accent
	local conns, destroyCbs = {}, {}
	local function conn(c) table.insert(conns, c); return c end
	function self:OnDestroy(fn) table.insert(destroyCbs, fn) end

	local cam = workspace.CurrentCamera
	local vp = cam and cam.ViewportSize or Vector2.new(1280, 720)
	local narrow = vp.X < 720
	local compact = vp.Y < 480
	self.Narrow = narrow
	local TOP = compact and 52 or 62
	local SB = narrow and 210 or 239

	local gui = New("ScreenGui", { Name = o.Name or "TXUI", ResetOnSpawn = false, IgnoreGuiInset = true, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100 })
	gui.Parent = guiParent()
	self.Gui = gui

	local size = Vector2.new(math.min(o.Size and o.Size.X or 897, vp.X - (narrow and 12 or 30)), math.min(o.Size and o.Size.Y or 515, vp.Y - (compact and 12 or 30)))

	local function closeDD()
		local d = win._dd
		if d then win._dd = nil; d.close() end
	end
	self.CloseDropdown = closeDD

	local main = New("CanvasGroup", {
		Name = "Main", BackgroundColor3 = T.Main, BorderSizePixel = 0, AnchorPoint = Vector2.new(.5, .5),
		Position = UDim2.new(.5, 0, .5, 0), Size = UDim2.fromOffset(size.X, size.Y), ZIndex = 1, Parent = gui,
	})
	Corner(main, 14); Stroke(main, T.Stroke)
	local scale = New("UIScale", { Parent = main })

	-------- top bar
	local top = Frame({ Name = "TopBar", BackgroundColor3 = T.Bar, Size = UDim2.new(1, 0, 0, TOP), ZIndex = 2, Parent = main })
	Frame({ BackgroundColor3 = T.Stroke, Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1), ZIndex = 3, Parent = top })
	local lg = compact and 32 or 40
	local logo = Image({ Size = UDim2.fromOffset(lg, lg), Position = UDim2.new(0, 14, .5, 0), AnchorPoint = Vector2.new(0, .5), ZIndex = 3, Parent = top })
	setIcon(logo, o.Icon)
	if not narrow then
		Label({ Text = o.Title or "TXUI", Font = F.Bold, TextSize = 17, Position = UDim2.new(0, 62, .5, -19), Size = UDim2.new(0, 170, 0, 20), TextTruncate = Enum.TextTruncate.AtEnd, ZIndex = 3, Parent = top })
		Label({ Text = o.Subtitle or "", Font = F.Reg, TextSize = 13, TextColor3 = T.Sub, Position = UDim2.new(0, 62, .5, 1), Size = UDim2.new(0, 170, 0, 18), ZIndex = 3, Parent = top })
	end

	local tbX = narrow and 56 or 252
	local tbtn = Button({ Size = UDim2.fromOffset(34, 34), AnchorPoint = Vector2.new(0, .5), Position = UDim2.new(0, tbX - 2, .5, 0), ZIndex = 3, Parent = top })
	local box = Frame({ BackgroundTransparency = 1, Size = UDim2.fromOffset(16, 14), AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), Parent = tbtn })
	Corner(box, 3); local boxStroke = Stroke(box, T.Sub, 1.5)
	Frame({ BackgroundColor3 = T.Sub, Size = UDim2.fromOffset(1.5, 14), Position = UDim2.fromOffset(5, -1), Parent = box })
	hover(tbtn, boxStroke, { Color = WHITE }, { Color = T.Sub })
	Frame({ BackgroundColor3 = T.Stroke, Size = UDim2.fromOffset(1, 18), AnchorPoint = Vector2.new(0, .5), Position = UDim2.new(0, tbX + 40, .5, 0), ZIndex = 3, Parent = top })
	local crumbs = Frame({ BackgroundTransparency = 1, Size = UDim2.new(0, 0, 1, 0), AutomaticSize = Enum.AutomaticSize.X, Position = UDim2.new(0, tbX + 54, 0, 0), ZIndex = 3, Parent = top })
	List(crumbs, 8, Enum.FillDirection.Horizontal).VerticalAlignment = Enum.VerticalAlignment.Center
	local catL = Label({ Font = F.Reg, TextColor3 = T.Sub, Size = UDim2.new(0, 0, 0, 20), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 1, Parent = crumbs })
	local arrL = Label({ Text = ">", Font = F.Reg, TextColor3 = T.Sub, Size = UDim2.new(0, 0, 0, 20), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 2, Parent = crumbs })
	local tabL = Label({ Font = F.Bold, Size = UDim2.new(0, 0, 0, 20), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 3, Parent = crumbs })

	local function dot(color, x, name)
		local b = Button({ Name = name, Size = UDim2.fromOffset(24, TOP), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, x, 0, 0), ZIndex = 5, Parent = top })
		local d = Frame({ BackgroundColor3 = color, Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), Parent = b })
		Corner(d, 7)
		hover(b, d, { BackgroundColor3 = color:Lerp(WHITE, .25) }, { BackgroundColor3 = color })
		return b
	end
	local bClose = dot(Color3.fromRGB(237, 76, 70), -8, "Close")
	local bMin = dot(Color3.fromRGB(255, 189, 46), -32, "Minimize")
	local bFull = dot(Color3.fromRGB(40, 200, 64), -56, "Fullscreen")

	local dragging, dStart, dPos = false, nil, nil
	conn(top.InputBegan:Connect(function(i)
		if isPress(i) then dragging, dStart, dPos = true, i.Position, main.Position; closeDD() end
	end))
	conn(UIS.InputChanged:Connect(function(i)
		if dragging and isMove(i) then
			local d = i.Position - dStart
			main.Position = UDim2.new(dPos.X.Scale, dPos.X.Offset + d.X, dPos.Y.Scale, dPos.Y.Offset + d.Y)
		end
	end))
	conn(UIS.InputEnded:Connect(function(i) if isPress(i) then dragging = false end end))

	-------- sidebar / content
	local sidebar = Frame({
		Name = "SideBar", BackgroundColor3 = T.Bar, Size = UDim2.new(0, SB, 1, -TOP), Position = UDim2.new(0, narrow and -SB or 0, 0, TOP),
		ClipsDescendants = true, ZIndex = narrow and 30 or 1, Parent = main,
	})
	local holder = Frame({ BackgroundTransparency = 1, Size = UDim2.new(0, SB, 1, 0), Parent = sidebar })
	Frame({ BackgroundColor3 = T.Stroke, Size = UDim2.new(0, 1, 1, 0), Position = UDim2.new(1, -1, 0, 0), Parent = holder })
	local side = New("ScrollingFrame", {
		BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.new(1, 0, 1, -64), ScrollBarThickness = 0,
		AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), Parent = holder,
	})
	Pad(side, 12, 8, 13, 8); List(side, 4)

	local content = Frame({
		Name = "Content", BackgroundColor3 = T.Content, Size = narrow and UDim2.new(1, 0, 1, -TOP) or UDim2.new(1, -SB, 1, -TOP),
		Position = UDim2.new(0, narrow and 0 or SB, 0, TOP), ClipsDescendants = true, Parent = main,
	})
	local scrim = Button({ BackgroundTransparency = 1, BackgroundColor3 = Color3.new(0, 0, 0), Size = UDim2.new(1, 0, 1, -TOP), Position = UDim2.new(0, 0, 0, TOP), Visible = false, ZIndex = 20, Parent = main })

	if o.User ~= false then
		local prof = Frame({ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 64), Position = UDim2.new(0, 0, 1, -64), Parent = holder })
		Frame({ BackgroundColor3 = T.Stroke, Size = UDim2.new(1, -1, 0, 1), Parent = prof })
		local av = Image({ BackgroundTransparency = 0, BackgroundColor3 = T.Hover, Size = UDim2.fromOffset(36, 36), Position = UDim2.new(0, 16, .5, 0), AnchorPoint = Vector2.new(0, .5), Parent = prof })
		Corner(av, 18)
		task.spawn(function()
			local ok, img = pcall(Players.GetUserThumbnailAsync, Players, LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
			if ok then av.Image = img end
		end)
		Label({ Text = o.HideName == false and LP.Name or mask(LP.Name), TextSize = 14, Position = UDim2.new(0, 62, 0, 0), Size = UDim2.new(1, -110, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd, Parent = prof })
		for k, n in ipairs({ "chevron-up", "chevron-down" }) do
			local a = Image({ Size = UDim2.fromOffset(10, 10), ImageColor3 = T.Sub, Position = UDim2.new(1, -30, .5, k == 1 and -11 or 1), Parent = prof })
			setIcon(a, n)
		end
	end

	local sbOpen = not narrow
	function self:SetSidebar(v)
		sbOpen = v; closeDD()
		if narrow then
			scrim.Visible = true
			tw(scrim, .25, { BackgroundTransparency = v and .45 or 1 }).Completed:Connect(function() if not sbOpen then scrim.Visible = false end end)
			tw(sidebar, .3, { Position = UDim2.new(0, v and 0 or -SB, 0, TOP) })
		else
			local w = v and SB or 0
			tw(sidebar, .35, { Size = UDim2.new(0, w, 1, -TOP) })
			tw(content, .35, { Position = UDim2.new(0, w, 0, TOP), Size = UDim2.new(1, -w, 1, -TOP) })
		end
	end
	tbtn.MouseButton1Click:Connect(function() self:SetSidebar(not sbOpen) end)
	scrim.MouseButton1Click:Connect(function() if sbOpen then self:SetSidebar(false) end end)

	-------- tabs
	local tabs, cur, order, curCat = {}, nil, 0, nil

	function self:Category(name)
		order += 1; curCat = name
		Label({ Text = name, Font = F.Bold, TextSize = 12, TextColor3 = T.Sub, TextYAlignment = Enum.TextYAlignment.Bottom, Size = UDim2.new(1, 0, 0, 30), LayoutOrder = order, Parent = side }, { New("UIPadding", { PaddingLeft = UDim.new(0, 6), PaddingBottom = UDim.new(0, 4) }) })
	end

	function self:Select(tab)
		if cur == tab then return end
		closeDD()
		if cur then cur.Page.Visible = false; tw(cur.Btn, .2, { BackgroundTransparency = 1 }) end
		cur = tab
		tab.Page.Position = UDim2.new(0, 0, 0, 10); tab.Page.Visible = true
		tw(tab.Page, .35, { Position = UDim2.new() })
		tw(tab.Btn, .2, { BackgroundTransparency = 0 })
		local showCat = tab.Cat ~= nil and not narrow
		catL.Text = tab.Cat or ""; catL.Visible = showCat; arrL.Visible = showCat
		tabL.Text = tab.Name
	end

	function self:Tab(t)
		order += 1
		local tab = { Name = t.Name, Cat = t.Category or curCat, Sections = 0 }
		local btn = Button({ BackgroundTransparency = 1, BackgroundColor3 = T.Hover, Size = UDim2.new(1, 0, 0, narrow and 44 or 40), LayoutOrder = order, Parent = side })
		Corner(btn, 9)
		local ic = Frame({ BackgroundColor3 = t.Color or accent, Size = UDim2.fromOffset(28, 28), AnchorPoint = Vector2.new(0, .5), Position = UDim2.new(0, 8, .5, 0), Parent = btn })
		Corner(ic, 8)
		local img = Image({ Size = UDim2.fromOffset(16, 16), AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), ImageColor3 = WHITE, ScaleType = Enum.ScaleType.Fit, Parent = ic })
		setIcon(img, t.Icon)
		Label({ Text = t.Name, TextSize = 15, Position = UDim2.new(0, 46, 0, 0), Size = UDim2.new(1, -50, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd, Parent = btn })
		btn.MouseEnter:Connect(function() if cur ~= tab then tw(btn, .15, { BackgroundTransparency = .6 }) end end)
		btn.MouseLeave:Connect(function() if cur ~= tab then tw(btn, .15, { BackgroundTransparency = 1 }) end end)
		btn.MouseButton1Click:Connect(function()
			self:Select(tab)
			if narrow then self:SetSidebar(false) end
		end)

		local page = New("ScrollingFrame", {
			BackgroundTransparency = 1, BorderSizePixel = 0, Size = UDim2.fromScale(1, 1), Visible = false,
			ScrollBarThickness = 3, ScrollBarImageColor3 = Color3.fromRGB(70, 72, 84), ScrollingDirection = Enum.ScrollingDirection.Y,
			AutomaticCanvasSize = Enum.AutomaticSize.Y, CanvasSize = UDim2.new(), Parent = content,
		})
		if narrow then Pad(page, 10, 12, 12, 16) else Pad(page, 16, 16, 20, 20) end
		List(page, 18)
		page:GetPropertyChangedSignal("CanvasPosition"):Connect(closeDD)
		tab.Btn, tab.Page = btn, page
		table.insert(tabs, tab)

		------------------------------------------------ sections
		function tab:Section(s)
			s = s or {}
			tab.Sections += 1
			local sec = {}
			local root = Frame({ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = AY, LayoutOrder = tab.Sections, Parent = page })
			List(root, 10)
			local head = Button({ Size = UDim2.new(1, 0, 0, 38), LayoutOrder = 1, Parent = root })
			local hic = Frame({ BackgroundColor3 = s.Color or accent, Size = UDim2.fromOffset(34, 34), AnchorPoint = Vector2.new(0, .5), Position = UDim2.new(0, 0, .5, 0), Parent = head })
			Corner(hic, 9)
			local himg = Image({ Size = UDim2.fromOffset(18, 18), AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(.5, .5), ImageColor3 = WHITE, Parent = hic })
			setIcon(himg, s.Icon)
			Label({ Text = s.Title or "Section", Font = F.Bold, TextSize = 15, Position = UDim2.new(0, 46, 0, 1), Size = UDim2.new(1, -90, 0, 19), TextTruncate = Enum.TextTruncate.AtEnd, Parent = head })
			Label({ Text = s.Desc or "", Font = F.Reg, TextSize = 13, TextColor3 = T.Sub, Position = UDim2.new(0, 46, 0, 20), Size = UDim2.new(1, -90, 0, 17), TextTruncate = Enum.TextTruncate.AtEnd, Parent = head })
			local chev = Image({ Size = UDim2.fromOffset(16, 16), ImageColor3 = T.Sub, AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -4, .5, 0), Visible = s.Collapsible == true, Parent = head })
			setIcon(chev, "chevron-down")

			local isOpen = s.Open ~= false
			local body = Frame({ BackgroundColor3 = T.Card, Size = UDim2.new(1, 0, 0, 0), ClipsDescendants = true, Visible = isOpen, LayoutOrder = 2, Parent = root })
			Corner(body, 11); Stroke(body)
			local rows = Frame({ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = AY, Parent = body })
			List(rows, 0)
			if not isOpen then chev.Rotation = -90 end

			local token, animating = 0, false
			rows:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				if isOpen and not animating then body.Size = UDim2.new(1, 0, 0, rows.AbsoluteSize.Y) end
			end)
			function sec:SetOpen(v)
				if v == isOpen then return end
				closeDD()
				isOpen = v; token += 1; animating = true
				local my = token
				if v then
					body.Visible = true
					tw(body, .3, { Size = UDim2.new(1, 0, 0, rows.AbsoluteSize.Y) }).Completed:Connect(function()
						if my == token then animating = false; body.Size = UDim2.new(1, 0, 0, rows.AbsoluteSize.Y) end
					end)
				else
					tw(body, .3, { Size = UDim2.new(1, 0, 0, 0) }).Completed:Connect(function()
						if my == token then animating = false; body.Visible = false end
					end)
				end
				tw(chev, .3, { Rotation = v and 0 or -90 })
			end
			if s.Collapsible then head.MouseButton1Click:Connect(function() sec:SetOpen(not isOpen) end) end

			-- row factory: title + wrapped description on the left, control on the right
			-- (on narrow screens wide controls are stacked below the text)
			local ord = 0
			local function sep()
				ord += 1
				if ord > 1 then Frame({ BackgroundColor3 = T.Stroke, BackgroundTransparency = .35, Size = UDim2.new(1, 0, 0, 1), LayoutOrder = ord * 2 - 1, Parent = rows }) end
			end
			local function row(title, desc, rightW, canStack)
				sep()
				local hasDesc = desc ~= nil and desc ~= ""
				local r = Frame({ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = AY, LayoutOrder = ord * 2, Parent = rows })
				New("UISizeConstraint", { MinSize = Vector2.new(0, hasDesc and 54 or 46), Parent = r })
				local stacked = narrow and canStack and (rightW or 0) > 110
				local bodyF = Frame({ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = AY, Parent = r })
				Pad(bodyF, 14, hasDesc and 10 or 14)
				List(bodyF, 8)
				local tb = Frame({ BackgroundTransparency = 1, Size = UDim2.new(1, stacked and 0 or -((rightW or 100) + 10), 0, 0), AutomaticSize = AY, LayoutOrder = 1, Parent = bodyF })
				List(tb, 2)
				local tl = Label({ Text = title or "", Size = UDim2.new(1, 0, 0, 18), TextTruncate = Enum.TextTruncate.AtEnd, LayoutOrder = 1, Parent = tb })
				local dl
				if hasDesc then
					dl = Label({ Text = desc, Font = F.Reg, TextSize = 13, TextColor3 = T.Sub, TextWrapped = true, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = AY, LayoutOrder = 2, Parent = tb })
				end
				return { r = r, body = bodyF, stacked = stacked, title = tl, desc = dl, hasDesc = hasDesc }
			end
			local function mount(ri, ctrl, w, h)
				if ri.stacked then
					ctrl.LayoutOrder = 2
					ctrl.Size = UDim2.new(1, 0, 0, h)
					ctrl.Parent = ri.body
				else
					ctrl.AnchorPoint = Vector2.new(1, .5)
					ctrl.Position = UDim2.new(1, -14, .5, 0)
					ctrl.Size = UDim2.fromOffset(w, h)
					ctrl.Parent = ri.r
				end
			end
			local function flag(o2, obj)
				obj.SetValue = obj.SetValue or obj.Set
				if obj.Refresh then obj.SetValues = function(this, list) this:Refresh(list, true) end end
				if o2.Flag then Lib.Flags[o2.Flag] = obj end
			end

			---------------- Toggle
			function sec:Toggle(o2)
				local ri = row(o2.Title, o2.Desc, 60)
				local sw = Button({ BackgroundTransparency = 0, BackgroundColor3 = T.Off })
				Corner(sw, 11)
				local knob = Frame({ BackgroundColor3 = WHITE, Size = UDim2.fromOffset(18, 18), AnchorPoint = Vector2.new(0, .5), Position = UDim2.new(0, 2, .5, 0), Parent = sw })
				Corner(knob, 9)
				mount(ri, sw, 38, 22)
				local obj = { Value = false }
				function obj:Set(v, silent)
					v = v and true or false
					obj.Value = v
					tw(sw, .2, { BackgroundColor3 = v and accent or T.Off })
					tw(knob, .25, { Position = v and UDim2.new(1, -20, .5, 0) or UDim2.new(0, 2, .5, 0) }, Enum.EasingStyle.Back)
					if not silent and o2.Callback then task.spawn(o2.Callback, v) end
				end
				function obj:Get() return obj.Value end
				sw.MouseButton1Click:Connect(function() obj:Set(not obj.Value) end)
				obj.Default = o2.Default or false
				obj:Set(o2.Default or false, true)
				flag(o2, obj)
				return obj
			end

			---------------- Info
			function sec:Info(o2)
				local ri = row(o2.Title, o2.Desc, narrow and 140 or 200)
				local v = Label({ Text = tostring(o2.Value or ""), Font = F.Med, TextColor3 = T.Sub, TextXAlignment = AX.Right, TextTruncate = Enum.TextTruncate.AtEnd })
				mount(ri, v, narrow and 140 or 200, 20)
				local obj = {}
				function obj:Set(t) v.Text = tostring(t) end
				function obj:Get() return v.Text end
				flag(o2, obj)
				return obj
			end

			---------------- Paragraph
			function sec:Paragraph(o2)
				sep()
				local r = Frame({ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = AY, LayoutOrder = ord * 2, Parent = rows })
				Pad(r, 14, 12); List(r, 4)
				local pt = Label({ Text = o2.Title or "", Size = UDim2.new(1, 0, 0, 18), LayoutOrder = 1, Parent = r })
				local c = Label({ Text = o2.Content or "", Font = F.Reg, TextSize = 13, TextColor3 = T.Sub, TextWrapped = true, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = AY, LayoutOrder = 2, Parent = r })
				return { Set = function(_, t) c.Text = t end, SetDesc = function(_, t) c.Text = t end, SetTitle = function(_, t) pt.Text = t end }
			end

			---------------- Button
			function sec:Button(o2)
				local w = o2.Width or 90
				local ri = row(o2.Title, o2.Desc, w + 14)
				local b = Button({ BackgroundTransparency = 0, BackgroundColor3 = accent, Text = o2.Text or "Click", Font = F.Med, TextSize = 14 })
				Corner(b, 8)
				hover(b, b, { BackgroundColor3 = accent:Lerp(WHITE, .15) }, { BackgroundColor3 = accent })
				local sc = New("UIScale", { Parent = b })
				b.MouseButton1Down:Connect(function() tw(sc, .1, { Scale = .94 }) end)
				b.MouseButton1Up:Connect(function() tw(sc, .2, { Scale = 1 }, Enum.EasingStyle.Back) end)
				b.MouseLeave:Connect(function() tw(sc, .2, { Scale = 1 }) end)
				b.MouseButton1Click:Connect(function() if o2.Callback then task.spawn(o2.Callback) end end)
				mount(ri, b, w, 32)
				return { SetText = function(_, t) b.Text = t end }
			end

			---------------- Slider (tap the number to type a value)
			function sec:Slider(o2)
				local min, max = o2.Min or 0, o2.Max or 100
				local inc = o2.Increment or (o2.Rounding and 10 ^ -o2.Rounding) or 1
				local dec = #((tostring(inc):match("%.(%d+)")) or "")
				local ri = row(o2.Title, o2.Desc, 110)
				local val = New("TextBox", {
					BackgroundTransparency = 1, Font = F.Med, TextSize = 14, TextColor3 = T.Sub, TextXAlignment = AX.Right, ClearTextOnFocus = false,
					AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -14, 0, ri.hasDesc and 10 or 14), Size = UDim2.fromOffset(96, 18), Text = "", Parent = ri.r,
				})
				local hit = Button({ Size = UDim2.new(1, 0, 0, 22), LayoutOrder = 2, Parent = ri.body })
				local bar = Frame({ BackgroundColor3 = T.Off, Size = UDim2.new(1, 0, 0, 6), AnchorPoint = Vector2.new(0, .5), Position = UDim2.new(0, 0, .5, 0), Parent = hit })
				Corner(bar, 3)
				local fill = Frame({ BackgroundColor3 = accent, Size = UDim2.fromScale(0, 1), Parent = bar })
				Corner(fill, 3)
				local knob = Frame({ BackgroundColor3 = WHITE, Size = UDim2.fromOffset(14, 14), AnchorPoint = Vector2.new(.5, .5), Position = UDim2.fromScale(0, .5), Parent = bar })
				Corner(knob, 7)
				local obj = { Value = min }
				function obj:Set(v, silent)
					v = math.clamp(math.floor(v / inc + .5) * inc, min, max)
					v = tonumber(string.format("%." .. dec .. "f", v))
					obj.Value = v
					local a = (v - min) / (max - min)
					tw(fill, .08, { Size = UDim2.fromScale(a, 1) }); tw(knob, .08, { Position = UDim2.fromScale(a, .5) })
					if not val:IsFocused() then val.Text = tostring(v) .. (o2.Suffix or "") end
					if not silent and o2.Callback then task.spawn(o2.Callback, v) end
				end
				function obj:Get() return obj.Value end
				val.Focused:Connect(function() val.Text = tostring(obj.Value); val.TextColor3 = T.Text end)
				val.FocusLost:Connect(function()
					val.TextColor3 = T.Sub
					local n = tonumber(val.Text:match("-?%d+%.?%d*"))
					obj:Set(n or obj.Value)
					val.Text = tostring(obj.Value) .. (o2.Suffix or "")
				end)
				local drag = false
				local function upd(x) obj:Set(min + (max - min) * math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)) end
				hit.InputBegan:Connect(function(i)
					if isPress(i) then
						drag = true; page.ScrollingEnabled = false
						upd(i.Position.X); tw(knob, .15, { Size = UDim2.fromOffset(17, 17) })
					end
				end)
				conn(UIS.InputChanged:Connect(function(i) if drag and isMove(i) then upd(i.Position.X) end end))
				conn(UIS.InputEnded:Connect(function(i)
					if drag and isPress(i) then drag = false; page.ScrollingEnabled = true; tw(knob, .15, { Size = UDim2.fromOffset(14, 14) }) end
				end))
				obj.Default = o2.Default or min
				obj:Set(o2.Default or min, true)
				flag(o2, obj)
				return obj
			end

			---------------- Input
			function sec:Input(o2)
				local w = o2.Width or 170
				local ri = row(o2.Title, o2.Desc, w + 14, true)
				local fr = Frame({ BackgroundColor3 = T.Field })
				Corner(fr, 8)
				local st = Stroke(fr)
				local tb = New("TextBox", {
					BackgroundTransparency = 1, Size = UDim2.new(1, -20, 1, 0), Position = UDim2.new(0, 10, 0, 0), Font = F.Med, TextSize = 14,
					TextColor3 = T.Text, PlaceholderText = o2.Placeholder or "", PlaceholderColor3 = T.Sub, Text = o2.Default or "",
					ClearTextOnFocus = false, TextXAlignment = AX.Left, Parent = fr,
				})
				mount(ri, fr, w, 32)
				tb.Focused:Connect(function() tw(st, .15, { Color = accent }) end)
				tb.FocusLost:Connect(function()
					tw(st, .15, { Color = T.Stroke })
					if o2.Callback then task.spawn(o2.Callback, tb.Text) end
				end)
				local obj = { Value = o2.Default or "", Default = o2.Default or "" }
				tb:GetPropertyChangedSignal("Text"):Connect(function() obj.Value = tb.Text end)
				function obj:Set(t) tb.Text = tostring(t) end
				function obj:Get() return obj.Value end
				flag(o2, obj)
				return obj
			end

			---------------- Keybind
			function sec:Keybind(o2)
				local ri = row(o2.Title, o2.Desc, 120)
				local kb = Button({ BackgroundTransparency = 0, BackgroundColor3 = T.Field, Font = F.Med, TextSize = 13, TextColor3 = T.Text })
				Corner(kb, 8)
				local st = Stroke(kb)
				mount(ri, kb, 100, 30)
				local obj = { Value = nil, State = false }
				local listening = false
				function obj:Set(k)
					if type(k) == "string" then
						local ok, v = pcall(function() return Enum.KeyCode[k] end)
						k = ok and v or nil
					end
					obj.Value = k
					kb.Text = k and k.Name or "None"
					kb.TextColor3 = k and T.Text or T.Sub
				end
				function obj:Get() return obj.Value end
				kb.MouseButton1Click:Connect(function()
					listening = true; win.Listening = true
					kb.Text = "..."; tw(st, .15, { Color = accent })
				end)
				conn(UIS.InputBegan:Connect(function(i, gp)
					if listening then
						if i.UserInputType == Enum.UserInputType.Keyboard then
							listening = false
							task.delay(.1, function() win.Listening = false end)
							tw(st, .15, { Color = T.Stroke })
							local k = i.KeyCode
							if k == Enum.KeyCode.Escape or k == Enum.KeyCode.Backspace then obj:Set(nil) else obj:Set(k) end
							if o2.Changed then task.spawn(o2.Changed, obj.Value) end
						end
						return
					end
					if gp or not obj.Value or i.KeyCode ~= obj.Value or UIS:GetFocusedTextBox() then return end
					if o2.Callback then task.spawn(o2.Callback) end
				end))
				obj.Default = o2.Default
				obj:Set(o2.Default)
				flag(o2, obj)
				return obj
			end

			---------------- Dropdown (single / multi, searchable)
			function sec:Dropdown(o2)
				local multi = o2.Multi
				local opts = {}
				local function norm(list)
					opts = {}
					for _, v in ipairs(list) do
						if type(v) == "table" then table.insert(opts, { Text = v.Text or v.Name, Icon = v.Icon or v.Image })
						else table.insert(opts, { Text = tostring(v) }) end
					end
				end
				norm(o2.Options or {})
				local sel, single = {}, nil
				local function toList(v)
					if type(v) == "string" then return { v } end
					if type(v) == "table" then return v end
					return {}
				end
				if multi then for _, d in ipairs(toList(o2.Default)) do sel[d] = true end else single = o2.Default end

				local bw = o2.Width or (multi and 230 or 210)
				local ri = row(o2.Title, o2.Desc, bw + 14, true)
				local btn = Button({ BackgroundTransparency = 0, BackgroundColor3 = T.Field })
				Corner(btn, 9)
				local st = Stroke(btn)
				local txt = Label({ Position = UDim2.new(0, 12, 0, 0), Size = UDim2.new(1, multi and -112 or -42, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd, Parent = btn })
				local arrow = Image({ Size = UDim2.fromOffset(16, 16), ImageColor3 = T.Sub, AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -10, .5, 0), Parent = btn })
				setIcon(arrow, "chevron-down")
				local badge, badgeT, xbtn
				if multi then
					badge = Frame({ BackgroundColor3 = Color3.fromRGB(38, 40, 50), Size = UDim2.fromOffset(26, 18), AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -62, .5, 0), Parent = btn })
					Corner(badge, 9)
					badgeT = Label({ Font = F.Med, TextSize = 12, TextXAlignment = AX.Center, TextColor3 = T.Sub, Size = UDim2.fromScale(1, 1), Parent = badge })
					xbtn = Button({ Text = "×", TextSize = 18, TextColor3 = T.Sub, Size = UDim2.fromOffset(24, 24), AnchorPoint = Vector2.new(1, .5), Position = UDim2.new(1, -32, .5, 0), Parent = btn })
				end
				mount(ri, btn, bw, 34)

				local obj = { Value = nil, Default = (multi and table.clone(toList(o2.Default)) or o2.Default) }
				local function chosen()
					local t = {}
					for _, op in ipairs(opts) do if sel[op.Text] then table.insert(t, op.Text) end end
					return t
				end
				local function display()
					if multi then
						local l = chosen()
						txt.Text = #l == 0 and (o2.Placeholder or "None") or table.concat(l, ", ")
						txt.TextColor3 = #l == 0 and T.Sub or T.Text
						badgeT.Text = tostring(#l); badge.Visible = #l > 0; xbtn.Visible = #l > 0
						obj.Value = l
					else
						txt.Text = single or o2.Placeholder or "Select"
						txt.TextColor3 = single and T.Text or T.Sub
						obj.Value = single
					end
				end
				local refreshChecks = function() end
				local function fire() display(); refreshChecks(); if o2.Callback then task.spawn(o2.Callback, obj.Value) end end
				function obj:Get() return obj.Value end
				function obj:Set(v, silent)
					if multi then sel = {}; for _, d in ipairs(toList(v)) do sel[d] = true end else single = v end
					if silent then display(); refreshChecks() else fire() end
				end
				function obj:Refresh(list, keep)
					norm(list)
					if not keep then sel, single = {}, nil end
					display()
				end
				if multi then xbtn.MouseButton1Click:Connect(function() sel = {}; fire() end) end

				local function open()
					closeDD()
					local myOpts = opts
					local blocker = Button({ Size = UDim2.fromScale(1, 1), ZIndex = 40, Parent = gui })
					local vps = gui.AbsoluteSize
					local w = math.min(math.max(btn.AbsoluteSize.X, 240), vps.X - 16)
					local pop = Frame({ BackgroundColor3 = T.Popup, Size = UDim2.fromOffset(w, 0), ClipsDescendants = true, ZIndex = 41, Parent = gui })
					Corner(pop, 11); Stroke(pop, T.Stroke)

					local sbx = Frame({ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 40), Parent = pop })
					Magnifier(sbx, UDim2.new(0, 14, .5, 0))
					local sb = New("TextBox", {
						BackgroundTransparency = 1, Size = UDim2.new(1, -44, 1, 0), Position = UDim2.new(0, 36, 0, 0), Font = F.Med, TextSize = 14, TextColor3 = T.Text,
						PlaceholderText = "Search", PlaceholderColor3 = T.Sub, Text = "", ClearTextOnFocus = false, TextXAlignment = AX.Left, Parent = sbx,
					})
					Frame({ BackgroundColor3 = T.Stroke, Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 0, 40), Parent = pop })
					local lst = New("ScrollingFrame", {
						BackgroundTransparency = 1, BorderSizePixel = 0, Position = UDim2.new(0, 0, 0, 41), Size = UDim2.new(1, 0, 1, -41), ScrollBarThickness = 3,
						ScrollBarImageColor3 = Color3.fromRGB(70, 72, 84), AutomaticCanvasSize = AY, CanvasSize = UDim2.new(), Parent = pop,
					})
					Pad(lst, 6, 6, 6, 6); List(lst, 2)
					local empty = Label({ Text = "No results", Font = F.Reg, TextColor3 = T.Sub, TextXAlignment = AX.Center, Size = UDim2.new(1, 0, 0, 30), Visible = false, LayoutOrder = 9999, Parent = lst })

					local items, checks = {}, {}
					local function makeItem(text, iconV, order2, isAll)
						local it = Button({ Size = UDim2.new(1, 0, 0, narrow and 36 or 30), BackgroundTransparency = 1, BackgroundColor3 = T.Hover, LayoutOrder = order2, Parent = lst })
						Corner(it, 7)
						local x = 10
						if iconV then
							local im = Image({ Size = UDim2.fromOffset(20, 20), AnchorPoint = Vector2.new(0, .5), Position = UDim2.new(0, 8, .5, 0), ImageColor3 = isAll and T.Sub or WHITE, Parent = it })
							setIcon(im, iconV); Corner(im, 5); x = 36
						end
						Label({ Text = text, TextSize = 14, Position = UDim2.new(0, x, 0, 0), Size = UDim2.new(1, -x - 30, 1, 0), TextTruncate = Enum.TextTruncate.AtEnd, Parent = it })
						local ck = Label({ Text = "✓", TextSize = 15, TextXAlignment = AX.Center, Size = UDim2.new(0, 24, 1, 0), AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -6, 0, 0), Visible = false, Parent = it })
						it.MouseEnter:Connect(function() tw(it, .12, { BackgroundTransparency = .35 }) end)
						it.MouseLeave:Connect(function() tw(it, .12, { BackgroundTransparency = 1 }) end)
						return it, ck
					end

					local allIt
					if multi then
						local it, ck = makeItem("Select all", "list", 0, true)
						allIt = it
						it.MouseButton1Click:Connect(function()
							local all = #chosen() == #myOpts
							sel = {}
							if not all then for _, op in ipairs(myOpts) do sel[op.Text] = true end end
							fire()
						end)
						checks[0] = ck
					end
					for k, op in ipairs(myOpts) do
						local it, ck = makeItem(op.Text, op.Icon, k)
						items[k] = it; checks[k] = ck
						it.MouseButton1Click:Connect(function()
							if multi then
								if sel[op.Text] then sel[op.Text] = nil else sel[op.Text] = true end
								fire()
							else
								single = op.Text
								fire(); closeDD()
							end
						end)
					end
					refreshChecks = function()
						for k, op in ipairs(myOpts) do
							if checks[k] then
								if multi then checks[k].Visible = sel[op.Text] == true else checks[k].Visible = (single == op.Text) end
							end
						end
						if multi and checks[0] then checks[0].Visible = #chosen() == #myOpts and #myOpts > 0 end
					end
					refreshChecks()

					local rowH = narrow and 38 or 32
					local function targetH()
						local vis = 0
						local q = sb.Text:lower()
						for k, op in ipairs(myOpts) do
							local show = q == "" or op.Text:lower():find(q, 1, true) ~= nil
							items[k].Visible = show
							if show then vis += 1 end
						end
						if allIt then allIt.Visible = sb.Text == "" end
						local count = vis + ((allIt and sb.Text == "") and 1 or 0)
						empty.Visible = vis == 0
						local listH = vis == 0 and 42 or math.min(count * rowH + 10, 7 * rowH + 10)
						return 41 + listH
					end

					local ap, as = btn.AbsolutePosition, btn.AbsoluteSize
					local H = targetH()
					local below, above = vps.Y - (ap.Y + as.Y) - 14, ap.Y - 14
					local up = H > below and above > below
					H = math.min(H, up and above or below)
					pop.AnchorPoint = Vector2.new(0, up and 1 or 0)
					pop.Position = UDim2.fromOffset(math.clamp(ap.X + as.X - w, 8, vps.X - w - 8), up and (ap.Y - 6) or (ap.Y + as.Y + 6))
					local function setH(h) tw(pop, .2, { Size = UDim2.fromOffset(w, math.min(h, up and above or below)) }) end
					setH(H)
					tw(arrow, .25, { Rotation = 180 }); tw(st, .2, { Color = accent })
					sb:GetPropertyChangedSignal("Text"):Connect(function() setH(targetH()) end)

					local closed = false
					local function close()
						if closed then return end
						closed = true
						refreshChecks = function() end
						blocker:Destroy()
						tw(arrow, .25, { Rotation = 0 }); tw(st, .2, { Color = T.Stroke })
						tw(pop, .18, { Size = UDim2.fromOffset(w, 0) }).Completed:Connect(function() pop:Destroy() end)
					end
					blocker.MouseButton1Click:Connect(closeDD)
					win._dd = { btn = btn, close = close }
				end
				btn.MouseButton1Click:Connect(function()
					if win._dd and win._dd.btn == btn then closeDD() else open() end
				end)
				hover(btn, btn, { BackgroundColor3 = Color3.fromRGB(22, 23, 29) }, { BackgroundColor3 = T.Field })
				display()
				flag(o2, obj)
				return obj
			end

			return sec
		end

		if not cur then self:Select(tab) end
		return tab
	end

	-------- fallback toasts (bottom right)
	local toasts = Frame({ BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 1), Position = UDim2.new(1, -16, 1, -16), Size = UDim2.new(0, math.min(300, vp.X - 32), 1, -40), ZIndex = 90, Parent = gui })
	List(toasts, 8).VerticalAlignment = Enum.VerticalAlignment.Bottom
	local function toast(n)
		local h = Frame({ BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = AY, Parent = toasts })
		local card = Frame({ BackgroundColor3 = T.Bar, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = AY, Position = UDim2.new(1.2, 0, 0, 0), Parent = h })
		Corner(card, 12); Stroke(card); Pad(card, 14, 12); List(card, 4)
		Label({ Text = n.Title or "", Font = F.Bold, TextSize = 15, Size = UDim2.new(1, 0, 0, 18), LayoutOrder = 1, Parent = card })
		Label({ Text = n.Content or "", Font = F.Reg, TextSize = 13, TextColor3 = T.Sub, TextWrapped = true, Size = UDim2.new(1, 0, 0, 0), AutomaticSize = AY, LayoutOrder = 2, Parent = card })
		tw(card, .45, { Position = UDim2.new() }, Enum.EasingStyle.Back)
		task.delay(n.Duration or 4, function()
			if not card.Parent then return end
			tw(card, .35, { Position = UDim2.new(1.2, 0, 0, 0) }).Completed:Wait()
			h:Destroy()
		end)
	end

	-------- dynamic island (tap = open / close the window)
	local island = { Visible = true }
	if o.Island ~= false then
		local W0, H0 = 190, 38
		local ib = Button({
			Name = "Island", BackgroundTransparency = 0, BackgroundColor3 = Color3.fromRGB(8, 8, 10), AnchorPoint = Vector2.new(.5, 0),
			Position = UDim2.new(.5, 0, 0, 10), Size = UDim2.fromOffset(W0, H0), ClipsDescendants = true, ZIndex = 100, Parent = gui,
		})
		local icorner = Corner(ib, 19)
		Stroke(ib, Color3.fromRGB(36, 36, 44))
		local il = Image({ Size = UDim2.fromOffset(22, 22), Position = UDim2.new(0, 10, 0, 8), Parent = ib })
		setIcon(il, o.Icon)
		local title = Label({ Text = o.IslandTitle or o.Title or "TXUI", Font = F.Bold, TextSize = 14, Position = UDim2.new(0, 40, 0, 0), Size = UDim2.new(1, -80, 0, H0), TextTruncate = Enum.TextTruncate.AtEnd, Parent = ib })
		local dotf = Frame({ BackgroundColor3 = Color3.fromRGB(60, 60, 70), Size = UDim2.fromOffset(8, 8), Position = UDim2.new(1, -20, 0, 15), Parent = ib })
		Corner(dotf, 4)
		local nt = Label({ Font = F.Bold, TextSize = 14, TextTransparency = 1, Position = UDim2.new(0, 16, 0, 40), Size = UDim2.new(1, -32, 0, 18), TextTruncate = Enum.TextTruncate.AtEnd, Parent = ib })
		local nd = Label({ Font = F.Reg, TextSize = 13, TextColor3 = T.Sub, TextTransparency = 1, Position = UDim2.new(0, 16, 0, 58), Size = UDim2.new(1, -32, 0, 16), TextTruncate = Enum.TextTruncate.AtEnd, Parent = ib })

		local curW = W0
		local function fit()
			curW = math.max(150, textW(title.Text, 14, F.Bold) + 84)
			tw(ib, .4, { Size = UDim2.fromOffset(curW, H0) }, Enum.EasingStyle.Back)
		end
		fit()

		local sg = Frame({ BackgroundTransparency = 1, AnchorPoint = Vector2.new(.5, 0), Position = UDim2.new(.5, 0, 0, 54), Size = UDim2.fromOffset(260, 28), ZIndex = 99, Parent = gui })
		local sl = Label({ Font = F.Bold, TextSize = 15, TextXAlignment = AX.Center, TextTransparency = 1, TextStrokeTransparency = 1, TextStrokeColor3 = Color3.new(), Size = UDim2.new(1, 0, 0, 20), ZIndex = 99, Parent = sg })
		local bar = Frame({ BackgroundColor3 = Color3.fromRGB(255, 170, 40), BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 3), Position = UDim2.new(0, 0, 0, 22), ZIndex = 99, Parent = sg })
		Corner(bar, 2)
		New("UIGradient", { Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(.2, 0), NumberSequenceKeypoint.new(.8, 0), NumberSequenceKeypoint.new(1, 1) }), Parent = bar })

		function island:SetTitle(t) title.Text = t; fit() end
		function island:SetDot(c) tw(dotf, .3, { BackgroundColor3 = c }) end
		local lastStatus
		function island:SetStatus(text, color)
			if text == lastStatus then return end
			lastStatus = text
			if not text or text == "" then
				tw(sl, .3, { TextTransparency = 1, TextStrokeTransparency = 1 }); tw(bar, .3, { BackgroundTransparency = 1 })
				return
			end
			sl.Text = text
			sg.Size = UDim2.fromOffset(math.min(textW(text, 15, F.Bold) + 90, vp.X - 20), 28)
			bar.BackgroundColor3 = color or Color3.fromRGB(255, 170, 40)
			tw(sl, .3, { TextTransparency = 0, TextStrokeTransparency = .6 }); tw(bar, .3, { BackgroundTransparency = 0 })
		end
		function island:SetVisible(v)
			island.Visible = v and true or false
			ib.Visible = island.Visible
			sg.Visible = island.Visible
		end
		function island:Bounce()
			tw(ib, .15, { Size = UDim2.fromOffset(curW + 22, H0 + 6) }).Completed:Connect(function()
				tw(ib, .45, { Size = UDim2.fromOffset(curW, H0) }, Enum.EasingStyle.Back)
			end)
		end

		local queue, running = {}, false
		local function run()
			if running then return end
			running = true
			task.spawn(function()
				while #queue > 0 do
					local n = table.remove(queue, 1)
					nt.Text, nd.Text = n.Title or "", n.Content or ""
					local w = math.min(math.max(300, math.max(textW(nt.Text, 14, F.Bold), textW(nd.Text, 13, F.Reg)) + 60), vp.X - 20)
					tw(ib, .5, { Size = UDim2.fromOffset(w, 84) }, Enum.EasingStyle.Back); tw(icorner, .5, { CornerRadius = UDim.new(0, 28) })
					task.wait(.15)
					tw(nt, .3, { TextTransparency = 0 }); tw(nd, .3, { TextTransparency = 0 })
					task.wait(n.Duration or 3)
					tw(nt, .2, { TextTransparency = 1 }); tw(nd, .2, { TextTransparency = 1 })
					task.wait(.1)
					tw(ib, .45, { Size = UDim2.fromOffset(curW, H0) }, Enum.EasingStyle.Quint); tw(icorner, .45, { CornerRadius = UDim.new(0, 19) })
					task.wait(.5)
				end
				running = false
			end)
		end
		function island:Notify(n) table.insert(queue, n); run() end
		ib.MouseButton1Click:Connect(function() self:Toggle() end)
		ib.MouseEnter:Connect(function() if not running then tw(ib, .25, { Size = UDim2.fromOffset(curW + 10, H0 + 2) }) end end)
		ib.MouseLeave:Connect(function() if not running then tw(ib, .25, { Size = UDim2.fromOffset(curW, H0) }) end end)
	else
		island.Visible = false
		for _, k in ipairs({ "SetTitle", "SetDot", "SetStatus", "SetVisible", "Bounce", "Notify" }) do island[k] = function() end end
	end
	self.Island = island

	function self:Notify(n)
		if island.Visible then island:Notify(n) else toast(n) end
	end

	-------- show / hide / fullscreen / destroy
	local visible, minPos, fsPos, full = true, nil, nil, false
	function self:SetVisible(v)
		if v == visible then return end
		visible = v; closeDD()
		if not v then
			minPos = main.Position
			tw(main, .4, { Position = UDim2.new(.5, 0, 0, 30), GroupTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
			tw(scale, .4, { Scale = .1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
			task.delay(.42, function() if not visible then main.Visible = false end end)
			island:Bounce()
		else
			main.Visible = true
			tw(main, .5, { Position = minPos or UDim2.fromScale(.5, .5), GroupTransparency = 0 })
			tw(scale, .5, { Scale = 1 }, Enum.EasingStyle.Back)
		end
	end
	function self:Minimize() self:SetVisible(false) end
	function self:Toggle() self:SetVisible(not visible) end
	function self:ToggleFullscreen()
		if not visible then return end
		full = not full; closeDD()
		if full then
			fsPos = main.Position
			tw(main, .45, { Size = UDim2.new(1, -24, 1, -24), Position = UDim2.new(.5, 0, .5, 0) })
		else
			tw(main, .45, { Size = UDim2.fromOffset(size.X, size.Y), Position = fsPos or UDim2.fromScale(.5, .5) })
		end
	end
	function self:Destroy()
		if self.Unloaded then return end
		self.Unloaded = true
		closeDD()
		for _, f in ipairs(destroyCbs) do pcall(f) end
		for _, c in ipairs(conns) do c:Disconnect() end
		gui:Destroy()
	end
	bClose.MouseButton1Click:Connect(function() self:Destroy() end)
	bMin.MouseButton1Click:Connect(function() self:Minimize() end)
	bFull.MouseButton1Click:Connect(function() self:ToggleFullscreen() end)
	conn(UIS.InputBegan:Connect(function(i, gp)
		if not gp and not self.Listening and i.KeyCode == self.ToggleKey then self:Toggle() end
	end))

	scale.Scale = .85; main.GroupTransparency = 1
	tw(scale, .5, { Scale = 1 }, Enum.EasingStyle.Back); tw(main, .4, { GroupTransparency = 0 })

	return self
end

return Lib
end)()

;(((getgenv and getgenv()) or _G).TrippleXSay)("Connecting remotes...")

----------------------------------------------------------------------
-- Hub
----------------------------------------------------------------------
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local Lighting = game:GetService("Lighting")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

local HUB = "TrippleX Hub"
local LOGO = "rbxassetid://113614047568331"
local Options = Lib.Flags
local Win
local function unloaded() return Win ~= nil and Win.Unloaded == true end

local TEXT, SUB, ACC = Color3.fromRGB(236, 236, 244), Color3.fromRGB(125, 127, 138), Color3.fromRGB(88, 98, 214)
local FONT, BOLD = Enum.Font.BuilderSansMedium, Enum.Font.BuilderSansBold
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
local function notify(t, title) if Win then pcall(function() Win:Notify({ Title = title or HUB, Content = t, Duration = 3.5 }) end) end end

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

----------------------------------------------------------------------
-- Black screen (Disable 3D Render)  - layout like the Xenon AFK screen
----------------------------------------------------------------------
local GREEN = Color3.fromRGB(80, 220, 120)
local bsGui = new("ScreenGui", { Name = "TrippleXBlack", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 200, Enabled = false }, guiParent())
local bsFrame = new("Frame", { Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.new(0, 0, 0), BorderSizePixel = 0, Active = true }, bsGui)
new("ImageLabel", { Image = LOGO, BackgroundTransparency = 1, AnchorPoint = Vector2.new(.5, .5), Position = UDim2.new(.5, 0, .5, -140), Size = UDim2.fromOffset(100, 100), ScaleType = Enum.ScaleType.Fit }, bsFrame)
local bsTime = lbl(bsFrame, "00:00:00", 54, TEXT, Enum.TextXAlignment.Center, BOLD)
bsTime.AnchorPoint, bsTime.Position, bsTime.Size = Vector2.new(.5, .5), UDim2.new(.5, 0, .5, -58), UDim2.fromOffset(500, 64)
local bsRow = new("Frame", { AnchorPoint = Vector2.new(.5, .5), Position = UDim2.new(.5, 0, .5, -12), Size = UDim2.new(0, 0, 0, 24), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1 }, bsFrame)
new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 10), VerticalAlignment = Enum.VerticalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder }, bsRow)
local bsOnline = new("TextLabel", {
	Text = "●  Online", Font = BOLD, TextSize = 12, TextColor3 = GREEN, BackgroundColor3 = Color3.fromRGB(14, 36, 22), BorderSizePixel = 0,
	Size = UDim2.new(0, 0, 0, 24), AutomaticSize = Enum.AutomaticSize.X, LayoutOrder = 1,
}, bsRow)
corner(bsOnline, 12); stroke(bsOnline, Color3.fromRGB(28, 90, 52))
new("UIPadding", { PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) }, bsOnline)
local bsDur = lbl(bsRow, "0m 0s", 13, SUB)
bsDur.Size, bsDur.AutomaticSize, bsDur.LayoutOrder = UDim2.new(0, 0, 0, 24), Enum.AutomaticSize.X, 2
new("Frame", { AnchorPoint = Vector2.new(.5, .5), Position = UDim2.new(.5, 0, .5, 28), Size = UDim2.new(0, math.min(520, (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X or 600) - 40), 0, 1), BackgroundColor3 = Color3.fromRGB(34, 34, 40), BorderSizePixel = 0 }, bsFrame)
local bsCols = new("Frame", { AnchorPoint = Vector2.new(.5, 0), Position = UDim2.new(.5, 0, .5, 44), Size = UDim2.new(0, 0, 0, 56), AutomaticSize = Enum.AutomaticSize.X, BackgroundTransparency = 1 }, bsFrame)
new("UIListLayout", { FillDirection = Enum.FillDirection.Horizontal, Padding = UDim.new(0, 34), HorizontalAlignment = Enum.HorizontalAlignment.Center, SortOrder = Enum.SortOrder.LayoutOrder }, bsCols)
local bsVals = {}
for k, name in ipairs({ "Silver", "Kills", "Bag" }) do
	local col = new("Frame", { Size = UDim2.fromOffset(110, 56), BackgroundTransparency = 1, LayoutOrder = k }, bsCols)
	local v = lbl(col, "0", 22, k == 1 and GREEN or TEXT, Enum.TextXAlignment.Center, BOLD)
	v.Size = UDim2.new(1, 0, 0, 28)
	local l = lbl(col, name, 12, SUB, Enum.TextXAlignment.Center)
	l.Position, l.Size = UDim2.fromOffset(0, 32), UDim2.new(1, 0, 0, 18)
	bsVals[name] = v
end
local bsInfo = lbl(bsFrame, "", 14, SUB, Enum.TextXAlignment.Center)
bsInfo.AnchorPoint, bsInfo.Position, bsInfo.Size, bsInfo.TextTruncate = Vector2.new(.5, .5), UDim2.new(.5, 0, .5, 128), UDim2.fromOffset(500, 22), Enum.TextTruncate.AtEnd
local bsClose = new("TextButton", {
	Text = "Close", Font = FONT, TextSize = 15, TextColor3 = TEXT, BackgroundColor3 = Color3.fromRGB(26, 26, 30), AutoButtonColor = true,
	AnchorPoint = Vector2.new(.5, .5), Position = UDim2.new(.5, 0, .5, 176), Size = UDim2.fromOffset(150, 40),
}, bsFrame)
corner(bsClose, 10); stroke(bsClose, Color3.fromRGB(48, 48, 56))

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
end
bsClose.MouseButton1Click:Connect(function() setBlack(false) end)
local lastTap = 0
bsFrame.InputBegan:Connect(function(i)
	if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
		if os.clock() - lastTap < 0.45 then setBlack(false) end
		lastTap = os.clock()
	end
end)

----------------------------------------------------------------------
-- Stats card (floating, draggable)
----------------------------------------------------------------------
local stGui = new("ScreenGui", { Name = "TrippleXStats", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 148, Enabled = false }, guiParent())
local stCard = new("Frame", {
	Position = UDim2.new(0, 14, 0.5, -130), Size = UDim2.fromOffset(280, 0), AutomaticSize = Enum.AutomaticSize.Y,
	BackgroundColor3 = Color3.fromRGB(16, 13, 15), BorderSizePixel = 0,
}, stGui)
corner(stCard, 14); stroke(stCard, Color3.fromRGB(70, 30, 38))
new("UIPadding", { PaddingLeft = UDim.new(0, 18), PaddingRight = UDim.new(0, 18), PaddingTop = UDim.new(0, 16), PaddingBottom = UDim.new(0, 16) }, stCard)
new("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, stCard)
local stHead = lbl(stCard, "FARM / THE VEIL", 12, SUB, nil, BOLD)
stHead.Size, stHead.LayoutOrder = UDim2.new(1, -24, 0, 16), 1
local stX = new("TextButton", { Text = "×", Font = BOLD, TextSize = 20, TextColor3 = SUB, BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, 6, 0, -8), Size = UDim2.fromOffset(28, 28), ZIndex = 3 }, stCard)
local stTime = lbl(stCard, "00:00:00", 34, TEXT, nil, BOLD)
stTime.Size, stTime.LayoutOrder = UDim2.new(1, 0, 0, 40), 2
local stSub = lbl(stCard, "TIME IN SERVER", 11, SUB)
stSub.Size, stSub.LayoutOrder = UDim2.new(1, 0, 0, 14), 3
local stRows = {}
for k, name in ipairs({ "Silver", "Silver / hour", "Kills", "Kills / hour", "Bag" }) do
	local r = new("Frame", { Size = UDim2.new(1, 0, 0, 22), BackgroundTransparency = 1, LayoutOrder = 3 + k }, stCard)
	local l = lbl(r, name, 14, SUB)
	l.Size = UDim2.new(.5, 0, 1, 0)
	local v = lbl(r, "-", 14, TEXT, Enum.TextXAlignment.Right, BOLD)
	v.Size, v.Position = UDim2.new(.5, 0, 1, 0), UDim2.new(.5, 0, 0, 0)
	stRows[name] = v
end
local stBtn = new("TextButton", { Text = "Disable 3D Render", Font = FONT, TextSize = 14, TextColor3 = TEXT, BackgroundColor3 = Color3.fromRGB(52, 24, 30), AutoButtonColor = true, Size = UDim2.new(1, 0, 0, 38), LayoutOrder = 20 }, stCard)
corner(stBtn, 10); stroke(stBtn, Color3.fromRGB(86, 36, 44))
stBtn.MouseButton1Click:Connect(function() setBlack(true) end)
do
	local drag, ds, sp = false, nil, nil
	stCard.InputBegan:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag, ds, sp = true, i.Position, stCard.Position end
	end)
	UIS.InputChanged:Connect(function(i)
		if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - ds
			stCard.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
		end
	end)
	UIS.InputEnded:Connect(function(i)
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end
	end)
end
stX.MouseButton1Click:Connect(function() setOpt("ShowStats", false) end)

;(((getgenv and getgenv()) or _G).TrippleXSay)("Building interface...")
local isMobile = UIS.TouchEnabled and not UIS.KeyboardEnabled

Win = Lib:Window({
	Name = "TrippleXUI",
	Title = HUB .. " v5",
	IslandTitle = HUB,
	Subtitle = "The Veil",
	Icon = LOGO,
	Size = Vector2.new(897, 515),
	ToggleKey = Enum.KeyCode.LeftControl,
})
local Island = Win.Island

local CL = {
	blue = Color3.fromRGB(30, 130, 255), purple = Color3.fromRGB(150, 80, 230), orange = Color3.fromRGB(240, 150, 20),
	green = Color3.fromRGB(40, 190, 90), red = Color3.fromRGB(230, 70, 80), teal = Color3.fromRGB(30, 180, 190),
	pink = Color3.fromRGB(230, 80, 150), gray = Color3.fromRGB(110, 115, 130), indigo = Color3.fromRGB(88, 98, 214),
}
local function sec(tab, title, desc, icon, color) return tab:Section({ Title = title, Desc = desc, Icon = icon, Color = color, Collapsible = false }) end
local function tog(S, id, title, def, cb, desc) return S:Toggle({ Flag = id, Title = title, Desc = desc, Default = def or false, Callback = cb }) end
local function sld(S, id, title, def, min, max, rnd, desc)
	RANGE[id] = { min, max }
	return S:Slider({ Flag = id, Title = title, Desc = desc, Default = def, Min = min, Max = max, Rounding = rnd or 0 })
end
local function ddn(S, id, title, values, def, multi, desc, ph)
	return S:Dropdown({ Flag = id, Title = title, Desc = desc, Options = values, Multi = multi or false, Default = def, Placeholder = ph })
end
local function inp(S, id, title, def, desc) return S:Input({ Flag = id, Title = title, Desc = desc, Default = tostring(def), Placeholder = tostring(def) }) end
local function btn(S, title, cb, desc, text, w) return S:Button({ Title = title, Desc = desc, Text = text or "Run", Width = w, Callback = cb }) end

local PRESETS = {
	Safe = { HealPercent = 55, FleePercent = 30, ResumePercent = 85, SkipBosses = true },
	Balanced = { HealPercent = 40, FleePercent = 20, ResumePercent = 70, SkipBosses = false },
	Fast = { HealPercent = 30, FleePercent = 15, ResumePercent = 60, SkipBosses = false },
}
local function applyPreset(n) for k, v in pairs(PRESETS[n] or PRESETS.Balanced) do setOpt(k, v) end end

Win:Category("Auto Farm")
local TFarm = Win:Tab({ Name = "Farming", Icon = "star", Color = CL.blue })
local TTarget = Win:Tab({ Name = "Targeting", Icon = "align-justify", Color = CL.purple })
local TLoot = Win:Tab({ Name = "Loot & Sell", Icon = "boxes", Color = CL.orange })
local TShop = Win:Tab({ Name = "Shop & Daily", Icon = "cart", Color = CL.green })
Win:Category("Combat")
local TWeap = Win:Tab({ Name = "Weapons", Icon = "list", Color = CL.red })
local THeal = Win:Tab({ Name = "Healing", Icon = "audio-lines", Color = CL.pink })
Win:Category("Navigation")
local TTravel = Win:Tab({ Name = "Travel", Icon = "align-justify", Color = CL.orange })
Win:Category("Misc")
local TVis = Win:Tab({ Name = "Visuals", Icon = "eye", Color = CL.teal })
local TPlayer = Win:Tab({ Name = "Player", Icon = "widgets", Color = CL.indigo })
local TAfk = Win:Tab({ Name = "AFK", Icon = "server", Color = CL.gray })
Win:Category("Configurations")
local TCfg = Win:Tab({ Name = "Configs", Icon = "save", Color = CL.red })
local TWin = Win:Tab({ Name = "Window", Icon = "widgets", Color = CL.indigo })

local StatusI, BagI

---------------- Farming
do
	local s = sec(TFarm, "Auto Farm", "Fights mobs, picks up loot and sells on its own.", "star", CL.blue)
	StatusI = s:Info({ Title = "Status", Value = "Idle" })
	BagI = s:Info({ Title = "Bag", Value = "..." })
	tog(s, "AutoFarm", "Enabled", false, function(v)
		if not v then State.Target, State.LootUntil, State.Status = nil, 0, "Idle"; stopMove() end
	end, "Turn auto farming on or off.")
	tog(s, "AutoAttack", "Auto Attack", true, nil, "Swings the equipped sword when a mob is in range.")
	tog(s, "AutoEquip", "Auto Equip Weapon", true, nil, "Keeps the right weapon in your hand.")
	tog(s, "StickToTarget", "Stick To Target", true, nil, "Finishes a mob before picking the next one.")
	sld(s, "StuckTimeout", "Skip Target After (s)", 40, 10, 120, 0, "Only used when Stick To Target is off.")

	local q = sec(TFarm, "Quick Start", "One tap setup.", "star", CL.purple)
	ddn(q, "Preset", "Preset", { "Safe", "Balanced", "Fast" }, "Balanced", false, "Heal / flee thresholds and boss handling.")
	btn(q, "Quick Start", function()
		applyPreset(opt("Preset", "Balanced"))
		for _, k in ipairs({ "AutoFarm", "AutoAttack", "AutoEquip", "AutoPickup", "AutoChest", "AutoHeal" }) do setOpt(k, true) end
		notify("Quick Start: ON")
	end, "Applies the preset and turns the farm on.", "Start")
	btn(q, "Apply Preset Only", function() applyPreset(opt("Preset", "Balanced")); notify("Preset applied") end, nil, "Apply")
	btn(q, "Stop All", stopAll, "Stops farming, selling and movement.", "Stop")
	btn(q, "Black Screen", function() setBlack(not Black.On) end, "Disables 3D rendering to save battery and FPS.", "Open")

	local fm = sec(TFarm, "Farm Mode", "Where to look for mobs.", "align-justify", CL.orange)
	ddn(fm, "FarmMode", "Mode", { "1. Closest", "2. Waypoint" }, "1. Closest", false, "Closest mob to you, or stay around a waypoint.")
	ddn(fm, "FarmWaypoint", "Waypoint (mode 2)", wpNames, wpNames[1])
	sld(fm, "WpRadius", "Radius Around Waypoint", 500, 100, 3000)
	sld(fm, "SpotRadius", "Crypt Spot Radius", 150, 50, 500)

	local ps = sec(TFarm, "Movement", "How the character moves while farming.", "audio-lines", CL.teal)
	ddn(ps, "PosMode", "Attack Position", { "Behind", "Front", "Above" }, "Behind")
	sld(ps, "HeightOffset", "Height", 3, -5, 50)
	sld(ps, "DistOffset", "Distance", 4, 1, 15)
	sld(ps, "TweenSpeed", "Move Speed (studs/s)", 140, 20, 600)
	sld(ps, "Smoothness", "Smoothness", 0.6, 0.1, 1, 2)
	tog(ps, "Noclip", "Noclip While Farming", true)
	tog(ps, "SafePlatform", "Safe Platform", true, nil, "Invisible floor under your feet while farming.")

	local r = sec(TFarm, "Reliability", "Stays online.", "server", CL.gray)
	tog(r, "AutoRejoin", "Auto Rejoin On Disconnect", true)
end

---------------- Targeting
do
	local tg = sec(TTarget, "Targeting", "Which mobs to attack.", "align-justify", CL.purple)
	ddn(tg, "MobSelect", "Target Mobs", getMobNames(), {}, true, "Empty = every mob.", "All mobs")
	ddn(tg, "TargetMode", "Sort By", { "Closest", "Lowest HP", "Highest HP" }, "Closest")
	tog(tg, "AvoidContest", "Avoid Mobs Others Fight", true)
	sld(tg, "ContestRadius", "Contest Radius", 50, 10, 150)
	inp(tg, "NeverAttack", "Never Attack (comma)", "Training Dummy, Runner")
	sld(tg, "MobRange", "Max Range", 3000, 100, 10000)
	tog(tg, "SkipBosses", "Skip Bosses", false)
	sld(tg, "BossHP", "Boss = Max HP >=", 3000, 300, 50000)

	local pr = sec(TTarget, "Priority Mobs", "Mobs that are hunted first.", "star", CL.pink)
	ddn(pr, "PriorityMobs", "Priority Mobs", getMobNames(), {}, true, nil, "None")
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
	end, nil, "Refresh")
end

---------------- Loot & Sell
do
	local p = sec(TLoot, "Pickup", "Collects drops and chests.", "boxes", CL.orange)
	tog(p, "AutoPickup", "Auto Pickup Drops", true)
	tog(p, "AutoChest", "Auto Open Chests", true)
	ddn(p, "DropRarity", "Rarity", RARITIES, {}, true, "Empty = every rarity.", "All")
	inp(p, "AlwaysPick", "Always Pick Up (names)", "Potion, Event, Star Fruit")
	sld(p, "DropRange", "Pickup Range", 400, 20, 3000)
	tog(p, "LootWait", "Wait For Loot After Kill", true)
	sld(p, "LootWaitTime", "Wait After Mob (s)", 4, 1, 20)
	sld(p, "BossLootWait", "Wait After Boss (s)", 12, 3, 40)

	local s = sec(TLoot, "Auto Sell", "Sells backpack items automatically.", "database", CL.green)
	tog(s, "AutoSell", "Enabled", false)
	tog(s, "SellOnFull", "Sell When Bag Full", true)
	tog(s, "SellGoMerchant", "Walk To Merchant First", false)
	ddn(s, "SellRarity", "Sell Rarity", RARITIES, { "Common" }, true, "None selected = nothing is sold.", "None")
	inp(s, "SellKeepNames", "Never Sell (names)", "Bag, Key")
	sld(s, "SellInterval", "Sell Every (s)", 45, 5, 300)
	btn(s, "Sell Now", function() task.spawn(function() notify(("Sold %d item(s)"):format(sellRun())) end) end, nil, "Sell")
end

---------------- Shop & Daily
do
	local sh = sec(TShop, "Potion Shop", "Restocks potions from a shopkeeper.", "cart", CL.green)
	tog(sh, "AutoBuy", "Enabled", false)
	inp(sh, "ShopNPC", "Shop NPC", "Calvin, Potion Specialist")
	sld(sh, "BuyBelow", "Restock When Below", 3, 1, 30)
	sld(sh, "BuyHealthTo", "Health Potions To Keep", 10, 1, 60)
	sld(sh, "BuySanityTo", "Sanity Potions To Keep", 5, 0, 40)
	sld(sh, "MaxBuyPrice", "Max Price Per Item", 5000, 10, 100000)
	btn(sh, "Buy Potions Now", function() task.spawn(function() notify(("Bought %d item(s)"):format(buyPotions())) end) end, nil, "Buy")

	local d = sec(TShop, "Daily Reward", "Claims the daily login reward.", "star", CL.orange)
	tog(d, "AutoDaily", "Auto Claim", true)
	btn(d, "Claim Daily Now", function() task.spawn(function() notify(("Claimed %d reward(s)"):format(claimDaily())) end) end, nil, "Claim")
end

---------------- Weapons
do
	local w = sec(TWeap, "Sword / Melee", "Which sword to hold.", "list", CL.red)
	ddn(w, "WeaponPick", "Weapon", { AUTO_SWORD }, AUTO_SWORD)
	inp(w, "WeaponRules", "Weapon Rules (Mob=Weapon, comma)", "")
	sld(w, "AttackRange", "Attack Range", 20, 5, 40)
	btn(w, "Refresh Weapon List", function() refreshWeapons(); notify("Weapon list refreshed") end, nil, "Refresh")

	local a = sec(TWeap, "Abilities (R T V Y U)", "Uses sword abilities in a fight.", "star", CL.purple)
	tog(a, "AutoAbilities", "Enabled", true)
	sld(a, "AbilityRange", "Use Within (studs)", 25, 5, 80)
	for _, k in ipairs({ "R", "T", "V", "Y", "U" }) do tog(a, "Ability" .. k, "Use " .. k, true) end

	local m = sec(TWeap, "Magic Staff", "Casts staffs at the target.", "audio-lines", CL.blue)
	ddn(m, "MagicMode", "Magic Mode", { "Off", "Mix (Sword + Magic)", "Magic Only" }, "Off")
	ddn(m, "MagicPick", "Staff", { AUTO_STAFF }, AUTO_STAFF)
	ddn(m, "AimMode", "Aim Mode", { "Predict", "Target" }, "Predict")
	sld(m, "CastRange", "Cast Range", 60, 10, 150)
	sld(m, "CastDelay", "Cast Delay (s)", 1.2, 0.2, 5, 1)
	sld(m, "EquipWait", "Equip Wait (s)", 0.12, 0.05, 0.5, 2)
	sld(m, "MagicDist", "Magic Only Distance", 20, 8, 60)
end

---------------- Healing
do
	local h = sec(THeal, "Auto Heal", "Drinks potions and flees when HP is low.", "audio-lines", CL.pink)
	tog(h, "AutoHeal", "Enabled", true)
	inp(h, "PotionName", "Potion Name", "Health Potion")
	sld(h, "HealPercent", "Heal Below HP %", 40, 5, 95)
	tog(h, "SafeFlee", "Flee When HP Low", true)
	sld(h, "FleePercent", "Flee Below HP %", 20, 5, 60)
	sld(h, "ResumePercent", "Resume Above HP %", 70, 30, 100)
	sld(h, "FleeHeight", "Flee Height", 60, 20, 200)

	local sn = sec(THeal, "Sanity", "Keeps your sanity up.", "star", CL.purple)
	tog(sn, "AutoSanity", "Auto Sanity Potion", true)
	sld(sn, "SanityBelow", "Drink Below Sanity", 40, 5, 95)
end

---------------- Travel
do
	local t = sec(TTravel, "Waypoints", "Teleport to a waypoint.", "align-justify", CL.orange)
	ddn(t, "WaypointSelect", "Waypoint", wpNames, wpNames[1])
	btn(t, "Teleport To Waypoint", function() task.spawn(tpWaypoint, opt("WaypointSelect", wpNames[1])) end, nil, "Teleport", 100)
	btn(t, "Stop Movement", stopMove, "Cancels any move in progress.", "Stop")
end

---------------- Visuals
do
	local e = sec(TVis, "ESP", "See players, mobs and items through walls.", "eye", CL.teal)
	tog(e, "ESPPlayers", "Players", false)
	tog(e, "ESPMobs", "Mobs", false)
	tog(e, "ESPItems", "Items & Chests", false)
	sld(e, "ESPRange", "Max Distance", 600, 50, 5000)
end

---------------- Player
do
	local m = sec(TPlayer, "Player", "Quality of life.", "widgets", CL.indigo)
	tog(m, "AntiAFK", "Anti-AFK", true)
	tog(m, "AntiRagdoll", "Anti Ragdoll", true)
	tog(m, "SpeedHack", "Speed Hack", false)
	sld(m, "SpeedValue", "Speed", 32, 16, 150)
	tog(m, "InfJump", "Infinite Jump", false)
end

---------------- AFK
do
	local bs = sec(TAfk, "Black Screen", "Saves battery and FPS while you AFK farm.", "server", CL.gray)
	btn(bs, "Black Screen", function() setBlack(not Black.On) end, "Disables 3D rendering. Close button, End key or double tap exits.", "Open")
	sld(bs, "BlackFPS", "FPS Cap In Black Screen", 20, 5, 60)
	local st = sec(TAfk, "Display", "What stays on screen.", "eye", CL.teal)
	tog(st, "ShowStats", "Stats Card", false, function(v) stGui.Enabled = v and not Black.On end, "Floating card with time, silver and kills.")
	tog(st, "ShowIsland", "Dynamic Island", true, function(v) Island:SetVisible(v and not Black.On) end, "Tap it to open or close the menu.")
	tog(st, "ShowMobileButtons", "Mobile Buttons (Menu / Stop / Black)", isMobile)
	btn(st, "Reset Timer / Profit", resetStats, nil, "Reset")
end

---------------- Configs
local CFG_DIR = "TrippleXHub"
local CFG_FILE = CFG_DIR .. "/" .. tostring(game.PlaceId) .. ".json"
local CFG_IGNORE = { AutoFarm = true }
local function saveConfig()
	if not (writefile and makefolder and isfolder) then return false end
	local data = {}
	for k, o in pairs(Options) do
		if not CFG_IGNORE[k] then
			local v = o.Value
			if typeof(v) == "EnumItem" then v = v.Name end
			local t = type(v)
			if t == "boolean" or t == "number" or t == "string" or t == "table" then data[k] = v end
		end
	end
	data._KnownMobs = (function() local n = {}; for k in pairs(KnownMobs) do n[#n + 1] = k end; return n end)()
	return pcall(function()
		if not isfolder(CFG_DIR) then makefolder(CFG_DIR) end
		writefile(CFG_FILE, HttpService:JSONEncode(data))
	end)
end
local function loadConfig()
	if not (readfile and isfile and isfile(CFG_FILE)) then return false end
	local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CFG_FILE)) end)
	if not ok or type(data) ~= "table" then return false end
	if type(data._KnownMobs) == "table" then for _, n in ipairs(data._KnownMobs) do KnownMobs[n] = true end end
	for _, id in ipairs({ "MobSelect", "PriorityMobs" }) do
		if type(data[id]) == "table" then for _, n in ipairs(data[id]) do KnownMobs[n] = true end end
	end
	local names = getMobNames()
	for _, id in ipairs({ "MobSelect", "PriorityMobs" }) do
		local o = Options[id]
		if o then pcall(function() o:SetValues(names) end) end
	end
	for k, v in pairs(data) do
		local o = Options[k]
		if o and not CFG_IGNORE[k] and o.Set then pcall(o.Set, o, v, true) end
	end
	local mk = Options.MenuKey
	if mk and mk.Value then Win:SetToggleKey(mk.Value) end
	if Options.ShowIsland then Island:SetVisible(opt("ShowIsland", true)) end
	return true
end
local function resetConfig()
	for k, o in pairs(Options) do
		if not CFG_IGNORE[k] and o.Set and o.Default ~= nil then
			local d = o.Default
			if type(d) == "table" then d = table.clone(d) end
			pcall(o.Set, o, d)
		end
	end
	Win:SetToggleKey(Enum.KeyCode.LeftControl)
	return saveConfig()
end

do
	local c = sec(TCfg, "Config", "Settings are saved per game.", "save", CL.red)
	tog(c, "AutoSaveCfg", "Auto Save", true, nil, "Saves every 30 seconds.")
	btn(c, "Save Config", function() notify(saveConfig() and "Saved" or "Save failed (executor has no writefile)") end, nil, "Save")
	btn(c, "Load Config", function() notify(loadConfig() and "Loaded" or "No config file yet") end, nil, "Load")
	btn(c, "Reset Config", function() notify(resetConfig() and "Reset to defaults" or "Reset (could not write file)") end, "Sets every option back to default.", "Reset", 90)
	btn(c, "Unload Script", function() Win:Destroy() end, "Closes the UI and stops every system.", "Unload", 90)
end

---------------- Window
do
	local k = sec(TWin, "Menu", "Open and close the script.", "widgets", CL.indigo)
	k:Keybind({ Flag = "MenuKey", Title = "Menu Key", Desc = "Hide / show the window.", Default = Enum.KeyCode.LeftControl, Changed = function(key) Win:SetToggleKey(key) end })
	k:Paragraph({ Title = "Hotkeys", Content = "Open / Close: Menu Key, the yellow dot, the Menu button, or tap the Dynamic Island\nStop All: Delete or the Stop button\nBlack Screen: End or the Black button\nExit Black Screen: End, the Close button, or double tap" })
end

-- mobile floating buttons
local mgui = new("ScreenGui", { Name = "TrippleXMobile", ResetOnSpawn = false, IgnoreGuiInset = true, DisplayOrder = 149 }, guiParent())
local mb = new("Frame", { Size = UDim2.fromOffset(58, 0), AutomaticSize = Enum.AutomaticSize.Y, Position = UDim2.new(0, 8, 0.28, 0), BackgroundTransparency = 1 }, mgui)
new("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, mb)
local function mbtn(text, order, cb)
	local b = new("TextButton", { Size = UDim2.fromOffset(58, 40), BackgroundColor3 = Color3.fromRGB(16, 16, 20), BackgroundTransparency = 0.05, Text = text, Font = BOLD, TextSize = 13, TextColor3 = TEXT, AutoButtonColor = true, LayoutOrder = order }, mb)
	corner(b, 10)
	stroke(b, Color3.fromRGB(40, 42, 50))
	b.MouseButton1Click:Connect(cb)
end
mbtn("Menu", 1, function() Win:Toggle() end)
mbtn("Stop", 2, stopAll)
mbtn("Black", 3, function() setBlack(not Black.On) end)

UIS.InputBegan:Connect(function(i, gp)
	if gp or unloaded() then return end
	if i.KeyCode == Enum.KeyCode.Delete then stopAll()
	elseif i.KeyCode == Enum.KeyCode.End then setBlack(not Black.On) end
end)

----------------------------------------------------------------------
-- background loops
----------------------------------------------------------------------
task.spawn(function()
	local lastS, lastB, lastM, lastW = nil, nil, "", ""
	local lastDot
	local tick = 0
	while not unloaded() do
		task.wait(0.5)
		tick += 1
		local e = os.clock() - Tracker.t0
		local hrs, silver, k = math.max(e / 3600, 1 / 3600), lstat("Silver"), lstat("Kills")
		local n, c = bagInfo()

		if State.Status ~= lastS then lastS = State.Status; pcall(function() StatusI:Set(lastS) end) end
		local txt = ("%d / %d%s"):format(n, c, n >= c and "  (FULL)" or "")
		if txt ~= lastB then lastB = txt; pcall(function() BagI:Set(txt) end) end

		local on = farmOn()
		pcall(function()
			Island:SetStatus(on and State.Status or nil)
			if on ~= lastDot then lastDot = on; Island:SetDot(on and Color3.fromRGB(80, 220, 120) or Color3.fromRGB(60, 60, 70)) end
		end)
		pcall(function() Island:SetVisible(opt("ShowIsland", true) == true and not Black.On) end)
		mgui.Enabled = opt("ShowMobileButtons", isMobile) == true and not Black.On
		stGui.Enabled = opt("ShowStats", false) == true and not Black.On

		if Black.On then
			bsTime.Text = clock(e)
			bsDur.Text = ("%dm %ds"):format(math.floor(e / 60), math.floor(e % 60))
			bsVals.Silver.Text, bsVals.Kills.Text, bsVals.Bag.Text = commas(silver), commas(k), ("%d/%d"):format(n, c)
			bsInfo.Text = State.Status
		elseif stGui.Enabled then
			stTime.Text = clock(e)
			stRows["Silver"].Text = commas(silver)
			stRows["Silver / hour"].Text = commas(math.max(silver - Tracker.silver0, 0) / hrs)
			stRows["Kills"].Text = commas(k)
			stRows["Kills / hour"].Text = commas(math.max(k - Tracker.kills0, 0) / hrs)
			stRows["Bag"].Text = ("%d / %d"):format(n, c)
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
		task.wait(30)
		if opt("AutoSaveCfg", true) then saveConfig() end
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
	env.TrippleXUnload = function() if Win and not Win.Unloaded then pcall(function() Win:Destroy() end) end end
end
Win:OnDestroy(function()
	pcall(stopMove)
	moveConn:Disconnect(); stepConn:Disconnect(); hbConn:Disconnect(); jumpConn:Disconnect(); idleConn:Disconnect()
	local hum = getHum()
	if hum and Mods.speed then hum.WalkSpeed = Mods.speed end
	if Platform then Platform:Destroy() end
	pcall(function()
		RunService:Set3dRenderingEnabled(true)
		if setfpscap then setfpscap(origFPS or 60) end
		bsGui:Destroy()
		stGui:Destroy()
		mgui:Destroy()
	end)
	pcall(function() Lighting.GlobalShadows = true; settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic end)
end)

;(((getgenv and getgenv()) or _G).TrippleXSay)("Loading saved config...")
loadConfig()
do local _e = (getgenv and getgenv()) or _G
if _e.TrippleXSplash then _e.TrippleXSplash.Done() end end
notify("Loaded. Go to Farming > Quick Start")
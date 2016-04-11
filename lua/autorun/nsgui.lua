local function Add(f)
	if SERVER then AddCSLuaFile(f) end
	if CLIENT then include(f) end
end

local function AddLUA(fo)
	for _,f in pairs(file.Find(fo.."/*.lua", "LUA")) do
		Add(fo .. "/" .. f)
	end
end

Add("nsgui/nsgui.lua")
Add("nsgui/skinbase.lua")

AddLUA("nsgui/traits")
AddLUA("nsgui/skins")
AddLUA("nsgui/comps")

if SERVER then return end

function nsgui.TestComp(compName)
	local fr = vgui.Create("NSFrame")
	fr:SetSize(530, 500)
	fr:Center()
	fr:SetTitle("Component demonstration: " .. compName)

	local comp = fr:Add(compName)
	comp:Dock(FILL)

	-- This is needed for resizing to still work
	comp:DockMargin(0, 0, 10, 10)

	fr:MakePopup()

	return comp
end

function nsgui.Example(skin)
	local fr = vgui.Create("NSFrame")
	fr:SetSize(530, 500)
	fr:Center()
	fr:SetTitle("Hello world")
	fr:SetIcon("icon16/bomb.png")

	if skin then fr:SetSkin(skin) end

	local tbl = fr:Add("NSTable")
	tbl:Dock(FILL)

	-- This is needed for resizing to still work
	tbl:DockMargin(0, 0, 10, 10)

	tbl:Top():SetPadding(15)

	local function createComp(cls, h, fn)
		local cell = tbl:Add(vgui.Create(cls)):SetExpandedX(true):Fill():SetHeight(h)
		fn(cell:GetComponent())

		if cell:GetComponent().IsEnabled then
			local disabledcell = tbl:Add(vgui.Create(cls)):SetExpandedX(true):Fill():SetHeight(h)
			disabledcell:GetComponent():SetEnabled(false)
			fn(disabledcell:GetComponent())
		else
			-- Add null cell
			tbl:Add()
		end

		tbl:Row():SetMarginTop(10)
	end

	createComp("NSLabel", 25, function(comp)
		comp:SetText("I am a label!")
	end)

	createComp("NSButton", 30, function(comp)
		comp:SetText("Click me!")
		comp:AddHook("OnRelease", "Action", function() chat.AddText("Clicked!") end)
	end)

	createComp("NSTextEntry", 30, function(comp)
		comp:SetText("Hello world")
	end)

	createComp("NSTextArea", 90, function(comp)
		comp:SetText("Lorem\nIpsum")
	end)

	createComp("NSBinder", 30, function(comp)
		comp:SetBinding(bit.bor(nsgui.keymod.CTRL, KEY_LEFT))
	end)

	local checkbox = vgui.Create("NSCheckbox")
	checkbox:SetSize(20, 20)
	tbl:Add(checkbox):Left()

	fr:MakePopup()

	NSGUIExampleFrame = fr
end

concommand.Add("nsgui.Example", function(ply, cmd, args)
	nsgui.Example(args[1])
end)

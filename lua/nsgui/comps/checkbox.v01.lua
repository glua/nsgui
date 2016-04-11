local PANEL = {}

AccessorFunc(PANEL, "_value", "Value")

function PANEL:Init()
	self:SetMouseInputEnabled(true)

	self:SetCursor("hand")
	self:SetValue(false)

	self:AddHook("OnStateChanged", "SetCursor", function(_, b)
		self:SetCursor(b and "hand" or "no")
	end)

	self:AddHook("OnRelease", "SetValue", function()
		self:SetValue(not self:GetValue())
	end)
end

nsgui.skin.HookPaint(PANEL, "PaintCheckbox")

nsgui.trait.Import(PANEL, "mouseinput")
nsgui.trait.Import(PANEL, "state")

nsgui.Register("NSCheckbox", PANEL, "Panel")

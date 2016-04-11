local PANEL = {}

AccessorFunc(PANEL, "_textcolor", "TextColor")
AccessorFunc(PANEL, "_color", "Color")

-- We override TextEntry's Font accessors. "Default" font is set in skins
AccessorFunc(PANEL, "_font", "Font")

function PANEL:Init()
	self:SetAllowNonAsciiCharacters(true)
	self:SetMultiline(true)

	self:AddHook("OnStateChanged", "DisableInput", function(_, b)
		self:SetKeyboardInputEnabled(b)
		self:SetMouseInputEnabled(b)
	end)

	self:SetCursor("beam")
end

nsgui.skin.HookPaint(PANEL, "PaintTextEntry", true)

nsgui.trait.Import(PANEL, "state")
nsgui.trait.Import(PANEL, "editable")

nsgui.Register("NSTextArea", PANEL, "TextEntry")

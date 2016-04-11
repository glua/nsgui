local PANEL = {}

AccessorFunc(PANEL, "_textcolor", "TextColor")
AccessorFunc(PANEL, "_color", "Color")

-- We override TextEntry's Font accessors. "Default" font is set in skins
AccessorFunc(PANEL, "_font", "Font")

function PANEL:Init()
	self:SetAllowNonAsciiCharacters(true)

	self:AddHook("OnStateChanged", "DisableInput", function(_, b)
		self:SetKeyboardInputEnabled(b)
		self:SetMouseInputEnabled(b)
	end)

	self:SetCursor("beam")
end

function PANEL:SetMultiline(b)
	error("Error: trying to set 'NSTextEntry' multilined. Use 'NSTextArea' instead, which is multiline by default.")
end

nsgui.skin.HookPaint(PANEL, "PaintTextEntry", true)

nsgui.trait.Import(PANEL, "state")
nsgui.trait.Import(PANEL, "editable")

nsgui.Register("NSTextEntry", PANEL, "TextEntry")

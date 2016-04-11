local PANEL = {}

nsgui.Accessor(PANEL, "_text", "Text")
nsgui.Accessor(PANEL, "_textcolor", "TextColor")
nsgui.Accessor(PANEL, "_color", "Color")
nsgui.Accessor(PANEL, "_font", "Font")

-- Override content alignment, otherwise there is no getter for it
nsgui.Accessor(PANEL, "_contentAlignment", "ContentAlignment", FORCE_NUMBER, 4)

-- Add some helper methods for content alignment
function PANEL:Center() self:SetContentAlignment(5) end
function PANEL:Left() self:SetContentAlignment(4) end
function PANEL:Right() self:SetContentAlignment(6) end
function PANEL:Top() self:SetContentAlignment(8) end
function PANEL:Bottom() self:SetContentAlignment(2) end

function PANEL:SizeToContents()
	-- TODO HARD CODED AAAAAAAAAAAAAAA
	surface.SetFont(self:GetFont() or "Roboto 16")
	self:SetSize(surface.GetTextSize(self:GetText()))
end

nsgui.skin.HookPaint(PANEL, "PaintLabel")

nsgui.Register("NSLabel", PANEL, "Panel")

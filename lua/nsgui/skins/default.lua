local SKIN = {}

--
-- Fonts
--

surface.CreateFont("Roboto 16", {
	size = 16,
	font = "Roboto",
})

surface.CreateFont("Roboto 24", {
	size = 24,
	font = "Roboto",
})

SKIN.FrameHeaderFont = "Roboto 16"
SKIN.Font = "Roboto 16"

SKIN.Color_LabelForeground = Color(51, 51, 51)

SKIN.Color_FrameSizableHandle = Color(127, 127, 127)

SKIN.Color_ButtonBackground = Color(236, 236, 236)
SKIN.Color_ButtonBackgroundDisabled = Color(236, 236, 236)
SKIN.Color_ButtonOutline = Color(0, 0, 0, 100)
SKIN.Color_ButtonForeground = Color(51, 51, 51)
SKIN.Color_ButtonForegroundDisabled = Color(191, 191, 191)

SKIN.Color_TextEntryBackground = Color(236, 236, 236)
SKIN.Color_TextEntryOutline = Color(0, 0, 0, 100)
SKIN.Color_TextEntryForeground = Color(51, 51, 51)
SKIN.Color_TextEntryForegroundDisabled = Color(191, 191, 191)
SKIN.Color_TextEntryForegroundHighlighted = Color(107, 185, 240)
SKIN.Font_TextEntry = SKIN.Font

--
-- Main Frame
--

function SKIN:FrameDockPadding(panel, w, h)
	return 0, 32, 0, 0
end

function SKIN:FrameDragBounds(panel, w, h)
	return 0, 0, w, 32
end

function SKIN:FrameCloseButtonBounds(panel, w, h)
	return w - 48, 0, 48, 32
end

function SKIN:PaintFrameHeader(panel, w, h)
	surface.SetDrawColor(0,0,0,200)
	surface.DrawRect ( 0, 0, w, 32 )

	surface.SetFont"Roboto 16"
	surface.SetTextColor(255, 255, 255)
	local textw, texth = surface.GetTextSize(panel:GetTitle())

	if panel:GetIcon() then
		surface.SetMaterial(panel:GetIcon())
		surface.SetDrawColor(255, 255, 255)
		surface.DrawTexturedRect(0+32/2-16/2, 32/2-16/2, 16, 16)

		surface.SetTextPos(16+((2+32/2-16/2)*2), 32/2-texth/2)
	else
		surface.SetTextPos((0+32/2-16/2), 32/2-texth/2)
	end
	
	surface.DrawText(panel:GetTitle())
end

function SKIN:PaintFrame(panel, w, h)
	self:PaintFrameHeader(panel, w, h )

	surface.SetDrawColor(255,255,255)
	surface.DrawRect(0, 32 + 0, w, h - 32)

	self:PaintFrameSizableHandle(panel, w-0, h-0)
end

function SKIN:PaintFrameSizableHandle(panel, w, h)
	surface.SetDrawColor(self.Color_FrameSizableHandle)

	local padding = 3
	surface.DrawLine(w-padding, h-6, w-6, h-padding)
	surface.DrawLine(w-padding, h-10, w-10, h-padding)
	surface.DrawLine(w-padding, h-14, w-14, h-padding)
end

--
-- Main Frame Button
--

function SKIN:PaintFrameCloseButton(panel, w, h)
	surface.SetDrawColor(255, 75, 75, panel.Hovered and 255 or 0)
	surface.DrawRect(0,0,w,h)
	
	surface.SetTextColor ( 255, 255, 255 )
	surface.SetFont "Roboto 16"
	local textw, texth = surface.GetTextSize ( panel:GetText ( ) )

	surface.SetTextPos ( w / 2 - textw / 2, h / 2 - texth / 2 )
	surface.DrawText ( panel:GetText ( ) )
end

--
-- Button
--

function SKIN:PaintButton(panel, w, h)
	local bgclr = panel:GetColor() or self.Color_ButtonBackground
	local fgclr = panel:GetTextColor() or self.Color_ButtonForeground

	if not panel:IsEnabled() then
		bgclr = self.Color_ButtonBackgroundDisabled
		fgclr = self.Color_ButtonForegroundDisabled
	elseif panel:IsDepressed() then
		local h, s, v = ColorToHSV(bgclr)
		bgclr = HSVToColor(h, s, math.Clamp(v - 0.1, 0, 1))
	elseif panel:GetHovered() then
		local h, s, v = ColorToHSV(bgclr)
		bgclr = HSVToColor(h, s, math.Clamp(v - 0.05, 0, 1))
	end

	surface.SetDrawColor(bgclr)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(self.Color_ButtonOutline)
	surface.DrawOutlinedRect(0, 0, w, h)

	draw.SimpleText(panel:GetText(), panel:GetFont() or self.Font, w/2, h/2, fgclr, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
end

--
-- Label
--

function SKIN:GetAlignedLabelPos(panel, tw, th, w, h)
	local alignment = panel:GetContentAlignment()

	local midx, midy = w/2 - tw/2, h/2 - th/2
	local left, top = 0, 0
	local right, bot = w - tw, h - th

	if alignment == 7 then -- NW
		return left, top
	elseif alignment == 8 then -- N
		return midx, top
	elseif alignment == 9 then -- NE
		return right, top
	elseif alignment == 4 then -- W
		return left, midy
	elseif alignment == 5 then -- CENTER
		return midx, midy
	elseif alignment == 6 then -- E
		return right, midy
	elseif alignment == 1 then -- SW
		return left, bot
	elseif alignment == 2 then -- S
		return midx, bot
	elseif alignment == 3 then -- SE
		return right, bot
	end

	-- Invalid alignment. TODO should we error here?
	return midx, midy
end

function SKIN:PaintLabel(panel, w, h)
	local fgclr = panel:GetTextColor() or self.Color_LabelForeground
	local font = panel:GetFont() or self.Font

	surface.SetFont(font)
	local tw, th = surface.GetTextSize(panel:GetText())
	local x, y = self:GetAlignedLabelPos(panel, tw, th, w, h)

	draw.SimpleText(panel:GetText(), font, x, y, fgclr)
end

--
-- TextEntry
--

function SKIN:PaintTextEntryBackground(panel, w, h)
	surface.SetDrawColor(self.Color_TextEntryBackground)
	surface.DrawRect(0, 0, w, h)

	surface.SetDrawColor(self.Color_TextEntryOutline)
	surface.DrawOutlinedRect(0, 0, w, h)
end
function SKIN:PaintTextEntry(panel, w, h)
	self:PaintTextEntryBackground(panel, w, h)

	-- We use Source function to draw text, so we need to do this to set
	-- the font to the one we want. Set/GetFont is overridden in textentry.lua
	-- so this is okay
	panel:SetFontInternal(panel:GetFont() or self.Font_TextEntry)

	local color = panel:GetTextColor() or self.Color_TextEntryForeground

	if not panel:IsEnabled() then
		color = self.Color_TextEntryForegroundDisabled
	end

	panel:DrawTextEntryText(color, self.Color_TextEntryForegroundHighlighted, color)
end

--
-- Checkbox
--

function SKIN:PaintCheckbox(panel, w, h)
	local ticked = panel:GetValue()

	surface.SetDrawColor(ticked and Color(50, 200, 50) or self.Color_ButtonBackground)
	surface.DrawRect(2, 2, w-4, h-4)

	surface.SetDrawColor(self.Color_ButtonOutline)
	surface.DrawOutlinedRect(0, 0, w, h)
end

nsgui.skin.Register("default", SKIN)
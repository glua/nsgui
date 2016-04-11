local TRAIT = {}

-- Panels have Hovered property by default, we create an accessor for that
-- because accessors > public fields
nsgui.Accessor(TRAIT, "Hovered", "Hovered", FORCE_BOOL)
nsgui.Accessor(TRAIT, "Depressed", "Depressed", FORCE_BOOL)

function TRAIT:OnMousePressed(mousecode)
	if self.IsEnabled and not self:IsEnabled() then return end

	self:CallHook("OnPress", mousecode)

	self:SetDepressed(true)
end

function TRAIT:OnMouseReleased(mousecode)
	if self.IsEnabled and not self:IsEnabled() then return end

	self:CallHook("OnRelease", mousecode)

	if mousecode == MOUSE_LEFT and self.DoClick then self:DoClick() end
	if mousecode == MOUSE_RIGHT and self.DoRightClick then self:DoRightClick() end

	self:SetDepressed(false)
end

nsgui.trait.Register("mouseinput", TRAIT)

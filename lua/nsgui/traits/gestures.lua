TRAIT = { }

TRAIT.Dependencies = { "draggable" }

nsgui.Accessor(TRAIT, "_canfullscreen", "CanFullScreen", FORCE_BOOL)

function TRAIT:Init()
	self:SetCanFullScreen(true)

	self:AddHook("Think", "GestureThink", self.GestureThink)
end

function TRAIT:GestureThink()
	if self.Dragging then
		local x, y = self:GetParent():ScreenToLocal(gui.MousePos())

		if y < 10 and not self._NormalBounds then
			self._NormalBounds = {
				pos = {self:GetPos()},
				size = {self:GetSize()}
			}

			local parent = self:GetParent()
			local w, h
			if IsValid(parent) then
				w, h = parent:GetSize()
			else
				w, h = ScrW(), ScrH()
			end
			self:SetPos(0, 0)
			self:SetSize(w, h)

			self._OverrideDragPos = true
		elseif y > 10 and self._NormalBounds then
			self:SetPos(unpack(self._NormalBounds.pos))
			self:SetSize(unpack(self._NormalBounds.size))
			self._NormalBounds = nil

			self._OverrideDragPos = false
			self:ResetDragPosition()
		end
	end
end

nsgui.trait.Register("gestures", TRAIT)

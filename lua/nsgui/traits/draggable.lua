local TRAIT = {}

TRAIT.Dependencies = { "mouseinput" }

nsgui.Accessor(TRAIT, "_draggable", "Draggable", FORCE_BOOL)

function TRAIT:Init()
	self:SetDragBounds(0, 0, self:GetWide(), self:GetTall())

	self:AddHook("Think", "DragThink", self.DragThink)
	self:AddHook("OnPress", "DragOnPress", self.DragOnPress)
	self:AddHook("OnRelease", "DragOnRelease", self.DragOnRelease)
end

function TRAIT:SetDragBounds(x, y, w, h)
	self._DragBounds = { x = x, y = y, w = w, h = h }
end

function TRAIT:GetDragBounds()
	local d = self._DragBounds

	return d.x, d.y, d.w, d.h
end

function TRAIT:IsInBounds(x, y)
	local bx, by, bw, bh = self:GetDragBounds()

	return((x >(self.x + bx)) and(y >(self.y + by)) and(x <(self.x + bx + bw)) and(y <(self.y + by + bh)))
end

function TRAIT:DragThink()
	local mousex = math.Clamp(gui.MouseX(), 1, ScrW()-1)
	local mousey = math.Clamp(gui.MouseY(), 1, ScrH()-1)

	if self.Dragging and not self._OverrideDragPos then
		local x = mousex + self.Dragging[1]
		local y = mousey + self.Dragging[2]

		self:SetPos(x, y)
	end

	if(self.Hovered && self:GetDraggable() && self:IsInBounds(mousex, mousey)) then
		self:SetCursor("sizeall")
		self._Cursor = "sizeall"
		return
	end

	if(self._Cursor != "arrow" and(self._Cursor == "sizeall")) then
		self:SetCursor "arrow"
		self._Cursor = "arrow"
	end

end

function TRAIT:ResetDragPosition()
	self.Dragging = { self.x - gui.MouseX(), self.y - gui.MouseY() }
end

function TRAIT:DragOnPress()
	if(self:GetDraggable() && self:IsInBounds(gui.MouseX(), gui.MouseY())) then
		self:ResetDragPosition()
		self:MouseCapture(true)

		self:CallHook("DraggingStarted")
	end
end

function TRAIT:DragOnRelease()
	if self:GetDraggable() then
		self.Dragging = nil
		self:MouseCapture(false)

		self:CallHook("DraggingStopped")
	end
end

nsgui.trait.Register("draggable", TRAIT)

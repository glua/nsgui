local TRAIT = {}

TRAIT.Dependencies = { "mouseinput" }

nsgui.Accessor(TRAIT, "_sizable", "Sizable", FORCE_BOOL)
nsgui.Accessor(TRAIT, "_minwidth", "MinWidth", FORCE_NUMBER, 50)
nsgui.Accessor(TRAIT, "_minheight", "MinHeight", FORCE_NUMBER, 50)
nsgui.Accessor(TRAIT, "_maxwidth", "MaxWidth", FORCE_NUMBER)
nsgui.Accessor(TRAIT, "_maxheight", "MaxHeight", FORCE_NUMBER)

function TRAIT:Init()
	self:AddHook("Think", "SizableThink", self.SizableThink)
	self:AddHook("OnPress", "SizableOnPress", self.SizableOnPress)
	self:AddHook("OnRelease", "SizableOnRelease", self.SizableOnRelease)
end

function TRAIT:HoveringSizableEHandle()
	return gui.MouseX() > (self.x + self:GetWide() - 20)
end
function TRAIT:HoveringSizableSHandle()
	return gui.MouseY() > (self.y + self:GetTall() - 20)
end
function TRAIT:HoveringSizableSEHandle()
	return self:HoveringSizableSHandle() and self:HoveringSizableEHandle()
end

function TRAIT:SizableThink()
	local mousex = math.Clamp(gui.MouseX(), 1, ScrW()-1)
	local mousey = math.Clamp(gui.MouseY(), 1, ScrH()-1)

	if(self.Sizing) then
		local x, y
		if self.Sizing[1] then
			x = mousex - self.Sizing[1]
			x = math.Clamp(x, self:GetMinWidth(), self:GetMaxWidth() or ScrW())
			self:SetWide(x)
		end
		if self.Sizing[2] then
			y = mousey - self.Sizing[2]
			y = math.Clamp(y, self:GetMinHeight(), self:GetMaxHeight() or ScrH())
			self:SetTall(y)
		end

		if x and y then
			self:SetCursor("sizenwse")
		elseif x then
			self:SetCursor("sizewe")
		elseif y then
			self:SetCursor("sizens")
		end
		return
	end

	if self:IsSizable() then
		if self:HoveringSizableSEHandle() then
			self:SetCursor("sizenwse")
			return
		elseif self:HoveringSizableSHandle() then
			self:SetCursor("sizens")
			return
		elseif self:HoveringSizableEHandle() then
			self:SetCursor("sizewe")
			return
		end
	end

	self:SetCursor("arrow")
end

function TRAIT:SizableOnPress()
	if self:IsSizable() then
		local x, y

		if self:HoveringSizableEHandle() then
			x = gui.MouseX() - self:GetWide()
		end
		if self:HoveringSizableSHandle() then
			y = gui.MouseY() - self:GetTall()
		end

		if x or y then
			self.Sizing = { x, y }
			self:MouseCapture(true)
		end
	end
end

function TRAIT:SizableOnRelease()
	if self.Sizing then
		self.Sizing = nil
		self:MouseCapture(false)
	end
end

nsgui.trait.Register("resizable", TRAIT)

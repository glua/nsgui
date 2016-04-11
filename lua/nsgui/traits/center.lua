local TRAIT = {}

function TRAIT:Center()
	local par = self:GetParent()
	if IsValid(par) then
		self:SetPos(par:GetWide()/2 - self:GetWide()/2, par:GetTall()/2 - self:GetTall()/2)
	else
		self:SetPos(ScrW()/2 - self:GetWide()/2, ScrH()/2 - self:GetTall()/2)
	end
	
	self:InvalidateLayout(true)
end

nsgui.trait.Register("center", TRAIT)
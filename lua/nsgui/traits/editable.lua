local TRAIT = {}

function TRAIT:StartEditing()
	self:RequestFocus()
end
function TRAIT:IsEditing()
	return self == vgui.GetKeyboardFocus()
end

nsgui.trait.Register("editable", TRAIT)
-- TODO this is kind of a terrible place for these
nsgui.keymod = {}

nsgui.keymod.CTRL = bit.lshift(1, 9)
nsgui.keymod.ALT = bit.lshift(1, 10)
nsgui.keymod.SHIFT = bit.lshift(1, 11)

function nsgui.keymod.GetBaseKey(mod)
	return bit.band(mod, 0xFF)
end
function nsgui.keymod.IsCtrlDown(mod)
	return bit.band(mod, nsgui.keymod.CTRL) ~= 0
end
function nsgui.keymod.IsAltDown(mod)
	return bit.band(mod, nsgui.keymod.ALT) ~= 0
end
function nsgui.keymod.IsShiftDown(mod)
	return bit.band(mod, nsgui.keymod.SHIFT) ~= 0
end

local PANEL = {}

nsgui.Accessor(PANEL, "_binding", "Binding")
nsgui.Accessor(PANEL, "_editing", "Editing", FORCE_BOOL)

local function BindingToString(bind)
	local str = {}

	if nsgui.keymod.IsCtrlDown(bind) then str[#str+1] = "Ctrl" end
	if nsgui.keymod.IsAltDown(bind) then str[#str+1] = "Alt" end
	if nsgui.keymod.IsShiftDown(bind) then str[#str+1] = "Shift" end
	str[#str+1] = input.GetKeyName(nsgui.keymod.GetBaseKey(bind))

	return table.concat(str, " + ")
end

function PANEL:GetBindingString()
	if self:IsEditing() then
		local bind = 0
		if input.IsControlDown() then bind = bit.bor(bind, nsgui.keymod.CTRL) end
		if input.IsKeyDown(KEY_LALT) then bind = bit.bor(bind, nsgui.keymod.ALT) end
		if input.IsShiftDown() then bind = bit.bor(bind, nsgui.keymod.SHIFT) end

		return "EDIT MODE: " .. BindingToString(bind)
	end
	
	return BindingToString(self:GetBinding())
end

function PANEL:Think()
	if self:IsEditing() and input.IsKeyTrapping() then
		local code = input.CheckKeyTrapping()

		if code then
			if code ~= KEY_ESCAPE then
				self:SetBinding(code)
				self:CallHook("BindingChanged", code)
			end
			
			self:SetEditing(false)
		end
	end
end

function PANEL:DoClick()
	input.StartKeyTrapping()
	self:SetEditing(true)
end

function PANEL:GetText()
	return self:GetBindingString()
end

nsgui.Register("NSBinder", PANEL, "NSButton")

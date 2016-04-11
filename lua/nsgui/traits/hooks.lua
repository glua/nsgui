local TRAIT = {}

TRAIT.Default = true

function TRAIT:Init()
	-- Create a delegate for a Think hook. This is a hack
	-- TODO come up with something better?
	local oldthink = self.Think
	self.Think = function(self)
		self:CallHook("Think")

		if oldthink then oldthink(self) end
	end
end

function TRAIT:AddHook(name, id, fn)
	self._hooks = self._hooks or {}
	self._hooks[name] = self._hooks[name] or {}
	self._hooks[name][id] = fn
end

function TRAIT:CallHook(name, ...)
	if not self._hooks then return end

	local nmhooks = self._hooks[name]
	if not nmhooks then return end

	for _,fn in pairs(nmhooks) do
		fn(self, ...)
	end
end

nsgui.trait.Register("hooks", TRAIT)

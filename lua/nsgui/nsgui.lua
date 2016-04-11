nsgui = nsgui or {}

function nsgui.Accessor(panel, fieldname, name, forceType, default)
	local function getter(self)
		local val = self[fieldname]
		if val == nil then return default end
		return val
	end

	panel["Get" .. name] = getter

	-- If it's forced to boolean, we add additional getter prefixed with "Is"
	if forceType == FORCE_BOOL then
		panel["Is" .. name] = getter
	end

	panel["Set" .. name] = function(self, newval)
		self[fieldname] = newval

		return self -- for chaining
	end
end

nsgui.trait = nsgui.trait or {}
nsgui.trait.Traits = nsgui.trait.Traits or {}
function nsgui.trait.Register(id, tbl)
	nsgui.trait.Traits[id] = tbl
	return tbl
end

--- These keys won't be imported
local importBlackList = {"Init", "Default", "Dependencies"}
function nsgui.trait.Import(metapanel, trait)
	if metapanel._ImportedTraits and table.HasValue(metapanel._ImportedTraits, trait) then
		return -- already imported
	end

	local traitobj = nsgui.trait.Traits[trait]

	-- TODO should we report this in any way?
	if not traitobj then return end

	metapanel._ImportedTraits = metapanel._ImportedTraits or {}
	table.insert(metapanel._ImportedTraits, trait)

	local objtbl = {}

	-- Import dependencies if they're not imported yet. TODO circular dependencies?
	for k, v in pairs(traitobj.Dependencies or {}) do
		if not table.HasValue(metapanel._ImportedTraits, v) then
			nsgui.trait.Import(metapanel, v)
		end
	end

	-- Add non-blacklisted keys from trait to metapanel
	for k,v in pairs(traitobj) do
		if not table.HasValue(importBlackList, k) then
			if metapanel[k] ~= nil then
				error("Attempted to import '" .. trait .. "' to '" .. (metapanel.Name or "unknown") .. "', which failed because key '" .. k .. "' exists already")
			end
			objtbl[k] = v
		end
	end

	table.Merge(metapanel, objtbl)
end

function nsgui.Register(name, panel, inherit)
	panel.Name = name

	for k, trait in pairs(nsgui.trait.Traits) do
		if trait.Default then
			nsgui.trait.Import(panel, k)
		end
	end

	vgui.Register(name, panel, inherit)

	-- Detour panel:Init() to call trait:InitTrait() on each imported trait
	local oldInit = panel.Init
	function panel:Init()
		if oldInit then oldInit(self) end

		for _,itrait in pairs(self._ImportedTraits) do
			local traitobj = nsgui.trait.Traits[itrait]
			if traitobj.Init then
				traitobj.Init(self)
			end
		end
	end
end

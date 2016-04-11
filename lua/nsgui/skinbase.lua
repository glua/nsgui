nsgui.skin = nsgui.skin or {}
nsgui.skin.Skins = nsgui.skin.Skins or {}

local DEFAULT_SKIN = "default"

function nsgui.skin.Get(id)
	id = id or DEFAULT_SKIN
	return nsgui.skin.Skins[id]
end

function nsgui.skin.Register(id, tbl, parent)
	-- Every skin (except default) must be inherited from default
	if id ~= DEFAULT_SKIN and not parent then
		parent = DEFAULT_SKIN
	end

	if parent then
		local parentobj = nsgui.skin.Skins[parent]
		if not parentobj then
			error("Trying to register skin '" .. id .. "' with invalid parent skin '" .. parent .. "'")
		end

		setmetatable(tbl, {__index = parentobj})
	end

	nsgui.skin.Skins[id] = tbl
	return tbl
end

function nsgui.skin.PanelSkin(panel)
	local skin = panel:GetSkin()
	if type(skin) == "table" then skin = nil end
	
	local skinobj = nsgui.skin.Get(skin)
	if not skinobj then
		print("[NSGUI Warning] Skin '" .. skin .. "' not found. Reverting to 'default'")
		panel:SetSkin("default")
		skinobj = nsgui.skin.Get()
	end

	return skinobj
end


function nsgui.skin.HookPaint(metapanel, funcname, returnValue)
	metapanel.Paint = function(panel, w, h)
		local skinobj = nsgui.skin.PanelSkin(panel)

		skinobj[funcname](skinobj, panel, w, h)

		return returnValue
	end
end

function nsgui.skin.HookCall(panel, funcname)
	local skinobj = nsgui.skin.PanelSkin(panel)
		
	local w, h = panel:GetSize()

	if skinobj[funcname] then
		return skinobj[funcname](panel, panel, w, h)
	end
	
	return false
end
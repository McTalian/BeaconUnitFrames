---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---Check if a string starts with another string
---@param str string
---@param start string
---@return boolean
local function startswith(str, start)
	return string.sub(str, 1, #start) == start
end

ns.FontFlags = {
	NONE = "",
	OUTLINE = "OUTLINE",
	THICKOUTLINE = "THICKOUTLINE",
	MONOCHROME = "MONOCHROME",
}

ns.FontFlagsOptions = {
    [ns.FontFlags.NONE] = NONE,
    [ns.FontFlags.OUTLINE] = SELF_HIGHLIGHT_OUTLINE,
    [ns.FontFlags.THICKOUTLINE] = ns.L["Thick Outline"],
    [ns.FontFlags.MONOCHROME] = ns.L["Monochrome"],
}

function ns:TableToCommaSeparatedString(tbl)
	local result = {}
	for key, value in pairs(tbl) do
		if value then
			table.insert(result, key)
		end
	end
	return table.concat(result, ", ")
end

function ns.FontFlagsToString(fontFlagsTable)
    return ns:TableToCommaSeparatedString(fontFlagsTable)
end

function ns.FontObjectOptions()
    local fonts = _G.GetFonts()
    local allFonts = {}
    for k, v in pairs(fonts) do
        if type(v) == "string" then
            if startswith(v, "table") then
            -- Skip
            else
                allFonts[v] = v
            end
        end
    end
    return allFonts
end

ns.OptionsManager = {}

function ns.OptionsManager:Initialize()
    LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, ns.options)
end

---@class BUFOptions: AceConfig.OptionsTable
ns.options = {
    name = addonName,
    type = "group",
    args = {},
}

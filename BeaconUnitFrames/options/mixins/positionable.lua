---@class BUFNamespace
local ns = select(2, ...)

---@class PositionableHandler: MixinBase
---@field defaultRelativeTo string | Frame?
---@field customRelativeToOptions table<string, string>?
---@field customRelativeToSorting string[]?
---@field GetRelativeFrame fun(self: PositionableHandler): Frame
---@field SetPosition fun(self: PositionableHandler)
---@field _SetPosition fun(self: PositionableHandler, positionable: ScriptRegionResizing)

---@class Positionable: PositionableHandler
local Positionable = {}

local anchorPointOptions = {
	TOPLEFT = ns.L["TOPLEFT"],
	TOP = ns.L["TOP"],
	TOPRIGHT = ns.L["TOPRIGHT"],
	LEFT = ns.L["LEFT"],
	CENTER = ns.L["CENTER"],
	RIGHT = ns.L["RIGHT"],
	BOTTOMLEFT = ns.L["BOTTOMLEFT"],
	BOTTOM = ns.L["BOTTOM"],
	BOTTOMRIGHT = ns.L["BOTTOMRIGHT"],
}

local anchorPointSort = {
	"TOPLEFT",
	"TOP",
	"TOPRIGHT",
	"LEFT",
	"CENTER",
	"RIGHT",
	"BOTTOMLEFT",
	"BOTTOM",
	"BOTTOMRIGHT",
}

Positionable.relativeToFrames = {
	UI_PARENT = "UIParent",
	TARGET_FRAME = "TargetFrame",
	TARGET_REPUTATION_BAR = "TargetReputationBar",
	TARGET_PORTRAIT = "TargetPortrait",
	TARGET_NAME = "TargetName",
	TARGET_LEVEL = "TargetLevel",
	TARGET_HEALTH_BAR = "TargetFrameHealthBar",
	TARGET_POWER_BAR = "TargetFrameManaBar",
	-- TARGET_CAST_BAR = "TargetCastingBar",
	PLAYER_FRAME = "PlayerFrame",
	PLAYER_PORTRAIT = "PlayerPortrait",
	PLAYER_NAME = "PlayerName",
	PLAYER_HEALTH_BAR = "PlayerFrameHealthBar",
	PLAYER_POWER_BAR = "PlayerFrameManaBar",
	-- PLAYER_CAST_BAR = "PlayerCastingBar",
	FOCUS_FRAME = "FocusFrame",
	PET_FRAME = "PetFrame",
	PET_PORTRAIT = "PetPortrait",
	PET_NAME = "PetName",
	PET_HEALTH_BAR = "PetHealthBar",
	PET_POWER_BAR = "PetManaBar",
	PET_CAST_BAR = "PetCastingBarFrame",
}

Positionable.anchorRelativeToOptions = {
	[Positionable.relativeToFrames.UI_PARENT] = ns.L["UIParent"],
	[Positionable.relativeToFrames.TARGET_FRAME] = HUD_EDIT_MODE_TARGET_FRAME_LABEL,
	[Positionable.relativeToFrames.PLAYER_FRAME] = HUD_EDIT_MODE_PLAYER_FRAME_LABEL,
	[Positionable.relativeToFrames.FOCUS_FRAME] = HUD_EDIT_MODE_FOCUS_FRAME_LABEL,
	[Positionable.relativeToFrames.PET_FRAME] = HUD_EDIT_MODE_PET_FRAME_LABEL,
}

--- Helper to get the relative frame from a string key
--- @param strKey string
--- @return ScriptRegionResizing | string
function ns.GetRelativeFrame(strKey)
	if strKey == nil then
		error("Relative frame key is nil.")
		return _G.UIParent
	end
	local frames = Positionable.relativeToFrames
	if strKey == frames.UI_PARENT then
		return _G.UIParent
	elseif strKey == frames.TARGET_FRAME then
		return _G.TargetFrame
	elseif strKey == frames.TARGET_REPUTATION_BAR then
		return _G.TargetFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor
	elseif strKey == frames.TARGET_PORTRAIT then
		return _G.TargetFrame.TargetFrameContainer.Portrait
	elseif strKey == frames.TARGET_NAME then
		return _G.TargetFrame.TargetFrameContent.TargetFrameContentMain.Name
	elseif strKey == frames.TARGET_LEVEL then
		return _G.TargetFrame.TargetFrameContent.TargetFrameContentMain.LevelText
	elseif strKey == frames.TARGET_HEALTH_BAR then
		return _G.TargetFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBar
	elseif strKey == frames.TARGET_POWER_BAR then
		return _G.TargetFrame.TargetFrameContent.TargetFrameContentMain.ManaBar
	elseif strKey == frames.PLAYER_FRAME then
		return _G.PlayerFrame
	elseif strKey == frames.PLAYER_PORTRAIT then
		return _G.PlayerFrame.PlayerFrameContainer.PlayerPortrait
	elseif strKey == frames.PLAYER_NAME then
		return _G.PlayerName
	elseif strKey == frames.PLAYER_HEALTH_BAR then
		return PlayerFrame_GetHealthBar()
	elseif strKey == frames.PLAYER_POWER_BAR then
		return PlayerFrame_GetManaBar()
	elseif strKey == frames.FOCUS_FRAME then
		return _G.FocusFrame
	elseif strKey == frames.PET_FRAME then
		return _G.PetFrame
	elseif strKey == frames.PET_PORTRAIT then
		return _G.PetPortrait
	elseif strKey == frames.PET_NAME then
		return _G.PetName
	elseif strKey == frames.PET_HEALTH_BAR then
		return _G.PetFrameHealthBar
	elseif strKey == frames.PET_POWER_BAR then
		return _G.PetFrameManaBar
	elseif strKey == frames.PET_CAST_BAR then
		return _G.PetCastingBarFrame
	else
		if _G[strKey] == nil then
			error("Relative frame '" .. strKey .. "' does not exist.")
		end
	end

	-- Catch-all for other global frames
	return _G[strKey]
end

Positionable.anchorRelativeToSort = {
	"UIParent",
	"TargetFrame",
	"PlayerFrame",
	"FocusFrame",
	"PetFrame",
}

--- Add positionable options to the given options table
--- @param optionsTable table
--- @param _orderMap BUFOptionsOrder?
function ns.AddPositionableOptions(optionsTable, _orderMap)
	local orderMap = _orderMap or ns.defaultOrderMap

	optionsTable.positioning = optionsTable.positioning
		or {
			type = "header",
			name = ns.L["Positioning"],
			order = orderMap.POSITIONING_HEADER,
		}

	optionsTable.anchorPoint = {
		type = "select",
		name = ns.L["Anchor Point"],
		values = anchorPointOptions,
		sorting = anchorPointSort,
		set = "SetAnchorPoint",
		get = "GetAnchorPoint",
		order = orderMap.ANCHOR_POINT,
	}

	optionsTable.relativeTo = {
		type = "select",
		name = ns.L["Relative To"],
		desc = ns.L["RelativeToDesc"],
		values = "GetRelativeToOptions",
		sorting = "GetRelativeToSorting",
		set = "SetRelativeTo",
		get = "GetRelativeTo",
		order = orderMap.RELATIVE_TO,
	}

	optionsTable.relativePoint = {
		type = "select",
		name = ns.L["Relative Point"],
		values = anchorPointOptions,
		sorting = anchorPointSort,
		set = "SetRelativePoint",
		get = "GetRelativePoint",
		order = orderMap.RELATIVE_POINT,
	}

	optionsTable.xOffset = {
		type = "range",
		name = ns.L["X Offset"],
		min = -2000,
		softMin = -1000,
		softMax = 1000,
		max = 2000,
		step = 1,
		bigStep = 5,
		set = "SetXOffset",
		get = "GetXOffset",
		order = orderMap.X_OFFSET,
	}

	optionsTable.yOffset = {
		type = "range",
		name = ns.L["Y Offset"],
		min = -2000,
		softMin = -1000,
		softMax = 1000,
		max = 2000,
		step = 1,
		bigStep = 5,
		set = "SetYOffset",
		get = "GetYOffset",
		order = orderMap.Y_OFFSET,
	}
end

ns.Mixin(Positionable, ns.MixinBase)

---Set the anchor point
---@param info table AceConfig info table
---@param value string The anchor point name
function Positionable:SetAnchorPoint(info, value)
	self:DbSet("anchorPoint", value)
	self:SetPosition()
end

---Get the anchor point
---@param info? table AceConfig info table
---@return string|nil The anchor point name
function Positionable:GetAnchorPoint(info)
	return self:DbGet("anchorPoint")
end

---Set the relative to frame
---@param info table AceConfig info table
---@param value Frame The relative to frame
function Positionable:SetRelativeTo(info, value)
	self:DbSet("relativeTo", value)
	self:SetPosition()
end

---Get the relative to frame
---@param info? table AceConfig info table
---@return string|nil The relative to frame
function Positionable:GetRelativeTo(info)
	return self:DbGet("relativeTo")
end

---Get the relative to options
function Positionable:GetRelativeToOptions()
	if self.customRelativeToOptions then
		return self.customRelativeToOptions
	end
	return self.anchorRelativeToOptions
end

---Get the relative to sorting
function Positionable:GetRelativeToSorting()
	if self.customRelativeToOptions and self.customRelativeToSorting then
		return self.customRelativeToSorting
	end
	return self.anchorRelativeToSort
end

---Set the relative point
---@param info table AceConfig info table
---@param value string The relative point name
function Positionable:SetRelativePoint(info, value)
	self:DbSet("relativePoint", value)
	self:SetPosition()
end

---Get the relative point
---@param info? table AceConfig info table
---@return string|nil The relative point name
function Positionable:GetRelativePoint(info)
	return self:DbGet("relativePoint")
end

function Positionable:SetXOffset(info, value)
	self:DbSet("xOffset", value)
	self:SetPosition()
end

--- Get the X offset
--- @param info? table AceConfig info table
--- @return number|nil xOffset
function Positionable:GetXOffset(info)
	return self:DbGet("xOffset")
end

function Positionable:SetYOffset(info, value)
	self:DbSet("yOffset", value)
	self:SetPosition()
end

--- Get the Y offset
--- @param info? table AceConfig info table
--- @return number|nil yOffset
function Positionable:GetYOffset(info)
	return self:DbGet("yOffset")
end

---@class AnchorInfo
---@field point string
---@field relativeTo Frame
---@field relativePoint string
---@field xOffset number
---@field yOffset number

function Positionable:GetPositionAnchorInfo()
	---@type string | Frame
	local relativeTo = self:GetRelativeFrame()

	local anchorPoint = self:GetAnchorPoint() or "TOPLEFT"

	---@type string
	local relativePoint = self:GetRelativePoint() or anchorPoint

	local xOffset = self:GetXOffset() or 0
	local yOffset = self:GetYOffset() or 0
	---@type Frame

	if relativeTo == nil then
		relativeTo = self.relativeToFrames.UI_PARENT
	end

	local relFrame
	if type(relativeTo) == "string" then
		relFrame = ns.GetRelativeFrame(relativeTo)
	elseif relativeTo ~= nil then
		relFrame = relativeTo
	end

	if relFrame == nil then
		print("Positionable:GetPositionAnchorInfo: relativeTo frame is nil")
	end

	---@type AnchorInfo
	local anchorInfo = {
		point = anchorPoint,
		relativeTo = relFrame,
		relativePoint = relativePoint,
		xOffset = xOffset,
		yOffset = yOffset,
	}

	return anchorInfo
end

function Positionable:_SetPosition(positionable)
	local anchorInfo = self:GetPositionAnchorInfo()

	local anchorPoint = anchorInfo.point
	local relativeTo = anchorInfo.relativeTo
	local relativePoint = anchorInfo.relativePoint
	local xOffset = anchorInfo.xOffset
	local yOffset = anchorInfo.yOffset

	positionable:ClearAllPoints()
	if relativeTo == nil or relativePoint == nil then
		positionable:SetPoint(anchorPoint, xOffset, yOffset)
		return
	end

	positionable:SetPoint(anchorPoint, relativeTo, relativePoint, xOffset, yOffset)
end

function Positionable:_GetRelativeFrame()
	return ns.GetRelativeFrame(self:GetRelativeTo())
end

--- Can be overridden by the implementing class to provide a custom relative frame
function Positionable:GetRelativeFrame()
	return self:_GetRelativeFrame()
end

ns.Positionable = Positionable

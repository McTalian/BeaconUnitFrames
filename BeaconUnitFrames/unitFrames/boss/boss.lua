---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss: BUFFeatureModule
local BUFBoss = ns.NewFeatureModule("BUFBoss")

BUFBoss.configPath = "unitFrames.boss"

BUFBoss.relativeToFrames = {
	FRAME = "BossFrame",
	PORTRAIT = "BossPortrait",
	REPUTATION_BAR = "BossReputationBar",
	NAME = "BossName",
	LEVEL = "BossLevel",
	HEALTH = "BossFrameHealthBar",
	POWER = "BossFrameManaBar",
}

BUFBoss.customRelativeToOptions = {
	[BUFBoss.relativeToFrames.FRAME] = ns.L["BossFrame"],
	[BUFBoss.relativeToFrames.REPUTATION_BAR] = ns.L["BossReputationBar"],
	[BUFBoss.relativeToFrames.PORTRAIT] = ns.L["BossPortrait"],
	[BUFBoss.relativeToFrames.NAME] = ns.L["BossName"],
	[BUFBoss.relativeToFrames.LEVEL] = ns.L["BossLevel"],
	[BUFBoss.relativeToFrames.HEALTH] = ns.L["BossHealthBar"],
	[BUFBoss.relativeToFrames.POWER] = ns.L["BossManaBar"],
}

BUFBoss.customRelativeToSorting = {
	BUFBoss.relativeToFrames.FRAME,
	BUFBoss.relativeToFrames.REPUTATION_BAR,
	BUFBoss.relativeToFrames.PORTRAIT,
	BUFBoss.relativeToFrames.NAME,
	BUFBoss.relativeToFrames.LEVEL,
	BUFBoss.relativeToFrames.HEALTH,
	BUFBoss.relativeToFrames.POWER,
}

BUFBoss.optionsTable = {
	type = "group",
	name = ns.L["BossFrame"],
	handler = BUFBoss,
	order = ns.BUFUnitFrames.optionsOrder.BOSS,
	childGroups = "tree",
	disabled = BUFBoss.IsDisabled,
	args = {
		title = {
			type = "header",
			name = ns.L["BossFrame"],
			order = 0.001,
		},
		enable = {
			type = "toggle",
			name = ENABLE,
			set = "SetEnabled",
			disabled = false,
			get = "GetEnabled",
			order = 0.01,
		},
	},
}

---@class BUFDbSchema.UF.Boss
BUFBoss.dbDefaults = {
	enabled = true,
}

---@class BUFDbSchema.UF
ns.dbDefaults.profile.unitFrames = ns.dbDefaults.profile.unitFrames
ns.dbDefaults.profile.unitFrames.boss = BUFBoss.dbDefaults

ns.options.args.boss = BUFBoss.optionsTable

BUFBoss.optionsOrder = {
	FRAME = 1,
	PORTRAIT = 2,
	REPUTATION_BAR = 3,
	NAME = 4,
	LEVEL = 5,
	INDICATORS = 6,
	HEALTH = 7,
	POWER = 8,
	SPELL = 9,
	BUFFS = 10,
}

function BUFBoss.IsDisabled()
	return not BUFBoss:DbGet("enabled")
end

function BUFBoss:SetEnabled(info, value)
	self:DbSet("enabled", value)
	if value then
		self:RefreshConfig()
	else
		StaticPopup_Show("BUF_RELOAD_UI")
	end
end

function BUFBoss:GetEnabled(info)
	return self:DbGet("enabled")
end

-- TODO: Might move this somewhere else for other frames that are repeated clones (party, raid, etc.)
---@class BUFBossPositionable: Positionable
local BUFBossPositionable = {}

---@param parentFrame BossTargetFrameTemplate
---@return ScriptRegionResizing
function BUFBossPositionable:GetRelativeFrame(parentFrame)
	local relativeTo = self:GetRelativeTo()
	if relativeTo == BUFBoss.relativeToFrames.FRAME then
		return parentFrame
	elseif relativeTo == BUFBoss.relativeToFrames.REPUTATION_BAR then
		return parentFrame.TargetFrameContent.TargetFrameContentMain.ReputationColor
	elseif relativeTo == BUFBoss.relativeToFrames.PORTRAIT then
		return parentFrame.TargetFrameContainer.Portrait
	elseif relativeTo == BUFBoss.relativeToFrames.NAME then
		return parentFrame.TargetFrameContent.TargetFrameContentMain.Name
	elseif relativeTo == BUFBoss.relativeToFrames.LEVEL then
		return parentFrame.TargetFrameContent.TargetFrameContentMain.LevelText
	elseif relativeTo == BUFBoss.relativeToFrames.HEALTH then
		return parentFrame.TargetFrameContent.TargetFrameContentMain.HealthBarsContainer.HealthBar
	elseif relativeTo == BUFBoss.relativeToFrames.POWER then
		return parentFrame.TargetFrameContent.TargetFrameContentMain.ManaBar
	else
		error("Unknown relativeTo frame: " .. tostring(relativeTo))
	end
end

---@see Positionable.GetPositionAnchorInfo
function BUFBossPositionable:GetPositionAnchorInfo(parentFrame)
	local relFrame = self:GetRelativeFrame(parentFrame)

	local anchorPoint = self:GetAnchorPoint() or "TOPLEFT"

	---@type string
	local relativePoint = self:GetRelativePoint() or anchorPoint

	local xOffset = self:GetXOffset() or 0
	local yOffset = self:GetYOffset() or 0

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

local BUFBossInstance = {}

function BUFBossInstance:New(index)
	if index > MAX_BOSS_FRAMES then
		error("BUFBossInstance:New - index exceeds MAX_BOSS_FRAMES")
	end
	---@class BUFBossInstance
	---@field backdropFrame? BackdropTemplate
	---@field portrait? table
	---@field name? table
	---@field level? table
	---@field reputationBar? table
	---@field indicators? table
	---@field health? table
	---@field power? table
	---@field castBar? table
	local bbi = {}
	bbi.frame = _G["Boss" .. index .. "TargetFrame"]
	bbi.container = bbi.frame.TargetFrameContainer
	bbi.content = bbi.frame.TargetFrameContent
	bbi.contentMain = bbi.content.TargetFrameContentMain
	bbi.contentContextual = bbi.content.TargetFrameContentContextual
	bbi.healthBarContainer = bbi.contentMain.HealthBarsContainer
	bbi.healthBar = bbi.healthBarContainer.HealthBar
	bbi.manaBar = bbi.contentMain.ManaBar
	bbi.altPowerBar = bbi.frame.powerBarAlt

	return bbi
end

function BUFBoss:OnEnable()
	---@type BUFBossInstance[]
	self.frames = {}
	for i = 1, MAX_BOSS_FRAMES do
		table.insert(self.frames, BUFBossInstance:New(i))
	end
end

function BUFBoss:RefreshConfig()
	if not self:GetEnabled() then
		return
	end

	self.Frame:RefreshConfig()
	self.Portrait:RefreshConfig()
	self.Name:RefreshConfig()
	self.Level:RefreshConfig()
	self.Indicators:RefreshConfig()
	self.Health:RefreshConfig()
	self.Power:RefreshConfig()
	self.ReputationBar:RefreshConfig()
	self.CastBar:RefreshConfig()

	if not self.initialized then
		self.initialized = true

		local manaBars = {}
		for i, frameInstance in ipairs(self.frames) do
			self:SecureHook(frameInstance.frame, "Update", function()
				-- Be careful in here, if you do anything insecure, it could cause lua errors during combat
				self.Health.foregroundHandler:RefreshConfig()
				self.Power.foregroundHandler:RefreshConfig()
			end)

			table.insert(manaBars, frameInstance.manaBar)
		end

		self:SecureHook("UnitFrameManaBar_UpdateType", function(manaBar)
			for _, frameInstance in ipairs(self.frames) do
				if manaBar == frameInstance.manaBar then
					self.Power.foregroundHandler:RefreshConfig()
					self.Health.foregroundHandler:RefreshConfig()
					break
				end
			end
		end)
	end
end

ns.BUFUnitFrames:RegisterFrame(BUFBoss)

ns.BUFBossPositionable = BUFBossPositionable
ns.BUFBoss = BUFBoss

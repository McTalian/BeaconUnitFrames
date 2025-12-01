---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

---@class BUFPlayer.Indicators
local BUFPlayerIndicators = ns.BUFPlayer.Indicators

---@class BUFPlayer.Indicators.HitIndicator: BUFFontString
local BUFPlayerHitIndicator = {
	configPath = "unitFrames.player.hitIndicator",
}

BUFPlayerHitIndicator.optionsTable = {
	type = "group",
	handler = BUFPlayerHitIndicator,
	name = ns.L["Hit Indicator"],
	order = BUFPlayerIndicators.optionsOrder.HIT_INDICATOR,
	args = {
		enabled = {
			type = "toggle",
			name = ENABLE,
			desc = ns.L["EnablePlayerPortrait"],
			set = function(info, value)
				ns.db.profile.unitFrames.player.hitIndicator.enabled = value
				BUFPlayerHitIndicator:ShowHide()
			end,
			get = function(info)
				return ns.db.profile.unitFrames.player.hitIndicator.enabled
			end,
			order = ns.defaultOrderMap.ENABLE,
		},
	},
}

---@class BUFDbSchema.UF.Player.HitIndicator
BUFPlayerHitIndicator.dbDefaults = {
	enabled = true,
	anchorPoint = "CENTER",
	relativeTo = ns.DEFAULT,
	relativePoint = "TOPLEFT",
	xOffset = 54,
	yOffset = -50,
	useFontObjects = true,
	fontObject = "NumberFontNormalHuge",
	fontColor = { 1, 1, 1, 1 },
	fontSize = 30,
	fontFace = "Skurri",
	fontFlags = {
		[ns.FontFlags.OUTLINE] = false,
		[ns.FontFlags.THICKOUTLINE] = false,
		[ns.FontFlags.MONOCHROME] = false,
	},
	fontShadowColor = { 0, 0, 0, 1 },
	fontShadowOffsetX = 1,
	fontShadowOffsetY = -1,
}

ns.BUFFontString:ApplyMixin(BUFPlayerHitIndicator)

---@class BUFDbSchema.UF.Player
ns.dbDefaults.profile.unitFrames.player = ns.dbDefaults.profile.unitFrames.player

ns.dbDefaults.profile.unitFrames.player.hitIndicator = BUFPlayerHitIndicator.dbDefaults

ns.options.args.player.args.indicators.args.hitIndicator = BUFPlayerHitIndicator.optionsTable

function BUFPlayerHitIndicator:ToggleDemoMode()
	if not self.demoMode then
		if not BUFPlayer:IsHooked("CombatFeedback_OnUpdate") then
			print("Hooking CombatFeedback insecurely to avoid lua errors during testing.")
			print("Be sure to disable demo mode before entering combat!")
			BUFPlayer:RawHook("CombatFeedback_OnUpdate", function(frame, elapsed)
				-- NOOP
			end, true)
		end
	else
		if BUFPlayer:IsHooked("CombatFeedback_OnUpdate") then
			BUFPlayer:Unhook("CombatFeedback_OnUpdate")
		end
	end

	self:_ToggleDemoMode(self.fontString)
	if self.demoText then
		self.fontString:SetText(self.demoText)
		self.fontString:SetAlpha(1.0)
	end
end

function BUFPlayerHitIndicator:RefreshConfig()
	if not self.fontString then
		self.fontString = BUFPlayer.contentMain.HitIndicator.HitText
		self.demoText = "1234567"

		self.defaultRelativeTo = BUFPlayer.contentMain.HitIndicator
	end
	self:RefreshFontStringConfig()
	self:ShowHide()
end

function BUFPlayerHitIndicator:ShowHide()
	if ns.db.profile.unitFrames.player.hitIndicator.enabled then
		if BUFPlayer:IsHooked(self.fontString, "Hide") then
			BUFPlayer:Unhook(self.fontString, "Hide")
		end
	else
		if not BUFPlayer:IsHooked(self.fontString, "Show") then
			BUFPlayer:SecureHook(self.fontString, "Show", function()
				self.fontString:Hide()
			end)
		end
		self.fontString:Hide()
	end
end

function BUFPlayerHitIndicator:SetFont()
	self:_SetFont(self.fontString)

	if not self:GetUseFontObjects() then
		---@diagnostic disable-next-line: inject-field
		PlayerFrame.feedbackFontHeight = self:GetFontSize()
	else
		local file, height = self.fontString:GetFontObject():GetFont()
		PlayerFrame.feedbackFontHeight = height
	end
end

BUFPlayerIndicators.HitIndicator = BUFPlayerHitIndicator

---@class BUFNamespace
local ns = select(2, ...)

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Indicators
local BUFPetIndicators = ns.BUFPet.Indicators

---@class BUFPet.Indicators.HitIndicator: BUFFontString
local BUFPetHitIndicator = {
	configPath = "unitFrames.pet.hitIndicator",
}

BUFPetHitIndicator.optionsTable = {
	type = "group",
	handler = BUFPetHitIndicator,
	name = ns.L["Hit Indicator"],
	order = BUFPetIndicators.optionsOrder.HIT_INDICATOR,
	args = {
		enabled = {
			type = "toggle",
			name = ENABLE,
			desc = ns.L["EnablePlayerPortrait"],
			set = function(info, value)
				ns.db.profile.unitFrames.pet.hitIndicator.enabled = value
				BUFPetHitIndicator:ShowHide()
			end,
			get = function(info)
				return ns.db.profile.unitFrames.pet.hitIndicator.enabled
			end,
			order = ns.defaultOrderMap.ENABLE,
		},
	},
}

---@class BUFDbSchema.UF.Pet.HitIndicator
BUFPetHitIndicator.dbDefaults = {
	enabled = true,
	anchorPoint = "TOPLEFT",
	relativeTo = BUFPet.relativeToFrames.FRAME,
	relativePoint = "TOPLEFT",
	xOffset = 5,
	yOffset = -5,
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

ns.BUFFontString:ApplyMixin(BUFPetHitIndicator)

---@class BUFDbSchema.UF.Pet
ns.dbDefaults.profile.unitFrames.pet = ns.dbDefaults.profile.unitFrames.pet

ns.dbDefaults.profile.unitFrames.pet.hitIndicator = BUFPetHitIndicator.dbDefaults

ns.options.args.pet.args.indicators.args.hitIndicator = BUFPetHitIndicator.optionsTable

function BUFPetHitIndicator:ToggleDemoMode()
	if not self.demoMode then
		if not BUFPet:IsHooked("CombatFeedback_OnUpdate") then
			print("Hooking CombatFeedback insecurely to avoid lua errors during testing.")
			print("Be sure to disable demo mode before entering combat!")
			BUFPet:RawHook("CombatFeedback_OnUpdate", function(frame, elapsed)
				-- NOOP
			end, true)
		end
	else
		if BUFPet:IsHooked("CombatFeedback_OnUpdate") then
			BUFPet:Unhook("CombatFeedback_OnUpdate")
		end
	end

	self:_ToggleDemoMode(self.fontString)
	if self.demoText then
		self.fontString:SetText(self.demoText)
		self.fontString:SetAlpha(1.0)
	end
end

function BUFPetHitIndicator:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.customRelativeToOptions = BUFPET.customRelativeToOptions
		self.customRelativeToSorting = BUFPET.customRelativeToSorting

		self.fontString = PetHitIndicator
		self.demoText = "1234567"
	end
	self:RefreshFontStringConfig()
	self:ShowHide()
end

function BUFPetHitIndicator:ShowHide()
	if ns.db.profile.unitFrames.pet.hitIndicator.enabled then
		if BUFPet:IsHooked(self.fontString, "Hide") then
			BUFPet:Unhook(self.fontString, "Hide")
		end
	else
		if not BUFPet:IsHooked(self.fontString, "Show") then
			BUFPet:SecureHook(self.fontString, "Show", function()
				self.fontString:Hide()
			end)
		end
		self.fontString:Hide()
	end
end

function BUFPetHitIndicator:SetFont()
	self:_SetFont(self.fontString)

	if not self:GetUseFontObjects() then
		---@diagnostic disable-next-line: inject-field
		PlayerFrame.feedbackFontHeight = self:GetFontSize()
	else
		local file, height = self.fontString:GetFontObject():GetFont()
		PlayerFrame.feedbackFontHeight = height
	end
end

BUFPetIndicators.HitIndicator = BUFPetHitIndicator

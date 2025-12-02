---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Power
local BUFTargetPower = BUFTarget.Power

---@class BUFTarget.Power.Foreground: StatusBarTexturable, Colorable, PowerColorable
local foregroundHandler = {
	configPath = "unitFrames.target.powerBar.foreground",
}

BUFTargetPower.foregroundHandler = foregroundHandler

ns.Mixin(foregroundHandler, ns.StatusBarTexturable, ns.Colorable, ns.PowerColorable)

---@class BUFDbSchema.UF.Target.Power
ns.dbDefaults.profile.unitFrames.target.powerBar = ns.dbDefaults.profile.unitFrames.target.powerBar

ns.dbDefaults.profile.unitFrames.target.powerBar.foreground = {
	useStatusBarTexture = false,
	statusBarTexture = "Blizzard",
	useCustomColor = false,
	customColor = { 0, 0, 1, 1 },
	usePowerColor = false,
}

local foreground = {
	type = "group",
	handler = foregroundHandler,
	name = ns.L["Foreground"],
	order = BUFTargetPower.topGroupOrder.FOREGROUND,
	args = {},
}

ns.AddStatusBarTextureOptions(foreground.args)
ns.AddColorOptions(foreground.args)
ns.AddPowerColorOptions(foreground.args)

ns.options.args.target.args.powerBar.args.foreground = foreground

function foregroundHandler:RefreshConfig()
	self:RefreshStatusBarTexture()
	self:RefreshColor()

	if not self.initialized then
		self.initialized = true
	end
end

function foregroundHandler:RefreshStatusBarTexture()
	local parent = ns.BUFTarget
	local useCustomTexture = ns.db.profile.unitFrames.target.powerBar.foreground.useStatusBarTexture
	if useCustomTexture then
		local texturePath = ns.lsm:Fetch(
			ns.lsm.MediaType.STATUSBAR,
			ns.db.profile.unitFrames.target.powerBar.foreground.statusBarTexture
		)
		if not texturePath then
			texturePath = ns.lsm:Fetch(ns.lsm.MediaType.STATUSBAR, "Blizzard") or "Interface\\Buttons\\WHITE8x8"
		end
		parent.manaBar:SetStatusBarTexture(texturePath)
		parent.manaBar.ManaBarMask:Hide()
	else
		parent.manaBar:SetStatusBarTexture("UI-HUD-UnitFrame-Player-PortraitOn-Bar-Mana")
	end
end

function foregroundHandler:RefreshColor()
	local parent = ns.BUFTarget
	local useCustomColor = ns.db.profile.unitFrames.target.powerBar.foreground.useCustomColor
	local usePowerColor = ns.db.profile.unitFrames.target.powerBar.foreground.usePowerColor
	if usePowerColor then
		local powerType, powerToken, rX, gY, bZ = UnitPowerType("target")
		local info = PowerBarColor[powerToken]
		local r, g, b
		if info then
			r, g, b = info.r, info.g, info.b
		elseif not rX then
			local info = PowerBarColor[powerType]
			if info then
				r, g, b = info.r, info.g, info.b
			end
		else
			r, g, b = rX, gY, bZ
		end
		if r == nil then
			return
		end
		parent.manaBar:SetStatusBarColor(r, g, b, 1.0)
	elseif useCustomColor then
		local r, g, b, a = unpack(ns.db.profile.unitFrames.target.powerBar.foreground.customColor)
		parent.manaBar:SetStatusBarColor(r, g, b, a)
	end
end

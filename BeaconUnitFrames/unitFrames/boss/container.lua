---@class BUFNamespace
local ns = select(2, ...)

---@class BUFBoss
local BUFBoss = ns.BUFBoss

---@class BUFBoss.Container
local BUFBossContainer = {
	configPath = "unitFrames.boss.container",
}

function BUFBossContainer:RefreshConfig()
	if not self.initialized then
		self.initialized = true

		self.container = BossTargetFrameContainer
	end
end

BUFBoss.Container = BUFBossContainer

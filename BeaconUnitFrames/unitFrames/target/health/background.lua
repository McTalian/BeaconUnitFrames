-- ---@type string, table
-- local addonName, ns = ...

-- ---@class BUFNamespace
-- ns = ns

-- ---@class BUFTarget
-- local BUFTarget = ns.BUFTarget

-- ---@class BUFTarget.Health
-- local BUFTargetHealth = BUFTarget.Health

-- ---@class BUFTarget.Health.Background: BackgroundTexturable, Colorable, ClassColorable
-- local backgroundHandler = {
--     configPath = "unitFrames.target.healthBar.background",
-- }

-- BUFTargetHealth.backgroundHandler = backgroundHandler

-- ns.Mixin(backgroundHandler, ns.BackgroundTexturable, ns.Colorable, ns.ClassColorable)

-- ---@class BUFDbSchema.UF.Target.Health
-- ns.dbDefaults.profile.unitFrames.target.healthBar = ns.dbDefaults.profile.unitFrames.target.healthBar

-- ns.dbDefaults.profile.unitFrames.target.healthBar.background = {
--     useBackgroundTexture = false,
--     backgroundTexture = "None",
--     useCustomColor = false,
--     customColor = { 0, 0, 0, 0.5 },
--     useClassColor = false,
-- }

-- local backgroundOrder = {
--     USE_BACKGROUND_TEXTURE = 1,
--     BACKGROUND_TEXTURE = 2,
--     USE_CUSTOM_COLOR = 3,
--     CUSTOM_COLOR = 4,
--     CLASS_COLOR = 5,
-- }

-- local background = {
--     type = "group",
--     handler = backgroundHandler,
--     name = BACKGROUND,
--     order = BUFTargetHealth.topGroupOrder.BACKGROUND,
--     args = {}
-- }

-- ns.AddBackgroundTextureOptions(background.args, backgroundOrder)
-- ns.AddColorOptions(background.args, backgroundOrder)
-- ns.AddClassColorOptions(background.args, backgroundOrder)

-- ns.options.args.target.args.healthBar.args.background = background

-- function backgroundHandler:RefreshConfig()
--     self:RefreshBackgroundTexture()
--     self:RefreshColor()
-- end

-- function backgroundHandler:RefreshBackgroundTexture()
--     local parent = ns.BUFTarget
--     local useBackgroundTexture = ns.db.profile.unitFrames.target.healthBar.background.useBackgroundTexture
--     if useBackgroundTexture then
--         local texturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND,
--             ns.db.profile.unitFrames.target.healthBar.background.backgroundTexture)
--         if not texturePath then
--             texturePath = ns.lsm:Fetch(ns.lsm.MediaType.BACKGROUND, "Solid") or "Interface\\Buttons\\WHITE8x8"
--         end
--         parent.healthBar.Background:SetTexture(texturePath)
--         parent.healthBar.Background:Show()
--     end
-- end

-- function backgroundHandler:RefreshColor()
--     local parent = ns.BUFTarget
--     local useCustomColor = ns.db.profile.unitFrames.target.healthBar.background.useCustomColor
--     local useClassColor = ns.db.profile.unitFrames.target.healthBar.background.useClassColor
--     if useClassColor then
--         local _, class = UnitClass("player")
--         local r, g, b = GetClassColor(class)
--         parent.healthBar.Background:SetVertexColor(r, g, b, 1.0)
--     elseif useCustomColor then
--         local r, g, b, a = unpack(ns.db.profile.unitFrames.target.healthBar.background.customColor)
--         parent.healthBar.Background:SetVertexColor(r, g, b, a)
--     end
-- end

---@class BUFNamespace
local ns = select(2, ...)

---@class BUFTarget
local BUFTarget = ns.BUFTarget

---@class BUFTarget.Indicators
local BUFTargetIndicators = ns.BUFTarget.Indicators

---@class BUFTarget.Indicators.QuestIcon: BUFScaleTexture
local BUFTargetQuestIcon = {
    configPath = "unitFrames.target.questIcon",
}

BUFTargetQuestIcon.optionsTable = {
    type = "group",
    handler = BUFTargetQuestIcon,
    name = ns.L["Quest Icon"],
    order = BUFTargetIndicators.optionsOrder.QUEST_ICON,
    args = {},
}

---@class BUFDbSchema.UF.Target.QuestIcon
BUFTargetQuestIcon.dbDefaults = {
    anchorPoint = "CENTER",
    relativeTo = ns.DEFAULT,
    relativePoint = "BOTTOM",
    xOffset = -26,
    yOffset = -50,
    scale = 1.0,
}

ns.BUFScaleTexture:ApplyMixin(BUFTargetQuestIcon)

---@class BUFDbSchema.UF.Target
ns.dbDefaults.profile.unitFrames.target = ns.dbDefaults.profile.unitFrames.target
ns.dbDefaults.profile.unitFrames.target.questIcon = BUFTargetQuestIcon.dbDefaults

ns.options.args.target.args.indicators.args.questIcon = BUFTargetQuestIcon.optionsTable

function BUFTargetQuestIcon:RefreshConfig()
  if not self.texture then
      self.texture = BUFTarget.contentContextual.QuestIcon
      self.defaultRelativeTo = BUFTarget.container.Portrait
  end
  self:RefreshScaleTextureConfig()
end

BUFTargetIndicators.QuestIcon = BUFTargetQuestIcon

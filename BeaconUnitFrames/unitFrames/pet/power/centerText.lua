---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Power
local BUFPetPower = BUFPet.Power

---@class BUFPet.Power.CenterText: BUFConfigHandler, BUFFontString
local centerTextHandler = {
    configPath = "unitFrames.pet.powerBar.centerText",
}

centerTextHandler.optionsTable = {
    type = "group",
    handler = centerTextHandler,
    name = ns.L["Center Text"],
    order = BUFPetPower.topGroupOrder.CENTER_TEXT,
    args = {}
}

ns.BUFFontString:ApplyMixin(centerTextHandler)

BUFPetPower.centerTextHandler = centerTextHandler

---@class BUFDbSchema.UF.Pet.Power
ns.dbDefaults.profile.unitFrames.pet.powerBar = ns.dbDefaults.profile.unitFrames.pet.powerBar

ns.dbDefaults.profile.unitFrames.pet.powerBar.centerText = {
    anchorPoint = "CENTER",
    relativeTo = ns.DEFAULT,
    relativePoint = ns.DEFAULT,
    xOffset = 2,
    yOffset = 0,
    useFontObjects = true,
    fontObject = "TextStatusBarText",
    fontColor = { 1, 1, 1, 1 },
    fontFace = "Friz Quadrata TT",
    fontSize = 10,
    fontFlags = {
        [ns.FontFlags.OUTLINE] = false,
        [ns.FontFlags.THICKOUTLINE] = false,
        [ns.FontFlags.MONOCHROME] = false,
    },
    fontShadowColor = { 0, 0, 0, 1 },
    fontShadowOffsetX = 1,
    fontShadowOffsetY = -1,
}
ns.options.args.unitFrames.args.pet.args.powerBar.args.centerText = centerTextHandler.optionsTable

function centerTextHandler:RefreshConfig()
    if not self.fontString then
        self.fontString = PetFrameManaBarText
        self.defaultRelativeTo = PetFrameManaBar
        self.defaultAnchorPoint = "CENTER"
    end
    self:RefreshFontStringConfig()
end

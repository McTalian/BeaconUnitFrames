---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPet
local BUFPet = ns.BUFPet

---@class BUFPet.Power
local BUFPetPower = BUFPet.Power

---@class BUFPet.Power.LeftText: BUFConfigHandler, BUFFontString
local leftTextHandler = {
    configPath = "unitFrames.pet.powerBar.leftText",
}

leftTextHandler.optionsTable = {
    type = "group",
    handler = leftTextHandler,
    name = ns.L["Left Text"],
    order = BUFPetPower.topGroupOrder.LEFT_TEXT,
    args = {}
}

ns.BUFFontString:ApplyMixin(leftTextHandler)

BUFPetPower.leftTextHandler = leftTextHandler

---@class BUFDbSchema.UF.Pet.Power
ns.dbDefaults.profile.unitFrames.pet.powerBar = ns.dbDefaults.profile.unitFrames.pet.powerBar

ns.dbDefaults.profile.unitFrames.pet.powerBar.leftText = {
    anchorPoint = "LEFT",
    relativeTo = ns.DEFAULT,
    relativePoint = ns.DEFAULT,
    xOffset = 4,
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

ns.options.args.unitFrames.args.pet.args.powerBar.args.leftText = leftTextHandler.optionsTable

function leftTextHandler:RefreshConfig()
    if not self.fontString then
        self.fontString = PetFrameManaBarTextLeft
        self.defaultRelativeTo = PetFrameManaBar
        self.defaultAnchorPoint = "LEFT"
    end
    self:RefreshFontStringConfig()
end

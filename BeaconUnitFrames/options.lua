---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

ns.OptionsManager = {}

function ns.OptionsManager:Initialize()
    LibStub("AceConfig-3.0"):RegisterOptionsTable(addonName, ns.options)
end

ns.options = {
    name = addonName,
    type = "group",
    args = {
        unitFrames = {
            type = "group",
            name = UNITFRAME_LABEL,
            order = 1,
            args = {
                player = {
                    type = "group",
                    name = HUD_EDIT_MODE_PLAYER_FRAME_LABEL,
                    order = 1,
                    args = {
                        frame = {
                            type = "group",
                            name = ns.L["Frame"],
                            order = 1,
                            inline = true,
                            args = {
                                width = {
                                    type = "range",
                                    name = HUD_EDIT_MODE_SETTING_CHAT_FRAME_WIDTH,
                                    min = 1,
                                    softMin = 50,
                                    softMax = 800,
                                    max = 1000000000,
                                    step = 1,
                                    bigStep = 10,
                                    set = function(info, value)
                                        ns.db.profile.unitFrames.player.frame.width = value
                                        ns.BUFPlayer:SetFrameSize()
                                    end,
                                    get = function(info)
                                        return ns.db.profile.unitFrames.player.frame.width
                                    end,
                                    order = 1,
                                },
                                height = {
                                    type = "range",
                                    name = HUD_EDIT_MODE_SETTING_CHAT_FRAME_HEIGHT,
                                    min = 1,
                                    softMin = 50,
                                    softMax = 600,
                                    max = 1000000000,
                                    step = 1,
                                    bigStep = 10,
                                    set = function(info, value)
                                        ns.db.profile.unitFrames.player.frame.height = value
                                        ns.BUFPlayer:SetFrameSize()
                                    end,
                                    get = function(info)
                                        return ns.db.profile.unitFrames.player.frame.height
                                    end,
                                    order = 2,
                                },
                            },
                        },
                        portrait = {
                            type = "group",
                            name = ns.L["Portrait"],
                            order = 2,
                            inline = true,
                            args = {
                                enabled = {
                                    type = "toggle",
                                    name = ENABLE,
                                    desc = ns.L["EnablePlayerPortrait"],
                                    set = function(info, value)
                                        ns.db.profile.unitFrames.player.portrait.enabled = value
                                        ns.BUFPlayer:ShowHidePortrait()
                                    end,
                                    get = function(info)
                                        return ns.db.profile.unitFrames.player.portrait.enabled
                                    end,
                                    order = 1,
                                },
                            },
                        },
                        healthBar = {
                            type = "group",
                            name = HEALTH,
                            order = 3,
                            inline = true,
                            args = {
                                width = {
                                    type = "range",
                                    name = HUD_EDIT_MODE_SETTING_CHAT_FRAME_WIDTH,
                                    min = 1,
                                    softMin = 50,
                                    softMax = 800,
                                    max = 1000000000,
                                    step = 1,
                                    bigStep = 10,
                                    set = function(info, value)
                                        ns.db.profile.unitFrames.player.healthBar.width = value
                                        ns.BUFPlayer:SetHealthSize()
                                    end,
                                    get = function(info)
                                        return ns.db.profile.unitFrames.player.healthBar.width
                                    end,
                                    order = 1,
                                },
                                height = {
                                    type = "range",
                                    name = HUD_EDIT_MODE_SETTING_CHAT_FRAME_HEIGHT,
                                    min = 1,
                                    softMin = 5,
                                    softMax = 200,
                                    max = 1000000000,
                                    step = 1,
                                    bigStep = 5,
                                    set = function(info, value)
                                        ns.db.profile.unitFrames.player.healthBar.height = value
                                        ns.BUFPlayer:SetHealthSize()
                                    end,
                                    get = function(info)
                                        return ns.db.profile.unitFrames.player.healthBar.height
                                    end,
                                    order = 2,
                                },
                                xOffset = {
                                    type = "range",
                                    name = ns.L["X Offset"],
                                    min = -500,
                                    softMin = -200,
                                    softMax = 200,
                                    max = 500,
                                    step = 1,
                                    bigStep = 5,
                                    set = function(info, value)
                                        ns.db.profile.unitFrames.player.healthBar.xOffset = value
                                        ns.BUFPlayer:SetHealthPosition()
                                    end,
                                    get = function(info)
                                        return ns.db.profile.unitFrames.player.healthBar.xOffset
                                    end,
                                    order = 3,
                                },
                                yOffset = {
                                    type = "range",
                                    name = ns.L["Y Offset"],
                                    min = -500,
                                    softMin = -200,
                                    softMax = 200,
                                    max = 500,
                                    step = 1,
                                    bigStep = 5,
                                    set = function(info, value)
                                        ns.db.profile.unitFrames.player.healthBar.yOffset = value
                                        ns.BUFPlayer:SetHealthPosition()
                                    end,
                                    get = function(info)
                                        return ns.db.profile.unitFrames.player.healthBar.yOffset
                                    end,
                                    order = 4,
                                },
                            },
                        },
                        manaBar = {
                            type = "group",
                            name = MANA,
                            order = 4,
                            inline = true,
                            args = {
                                width = {
                                    type = "range",
                                    name = HUD_EDIT_MODE_SETTING_CHAT_FRAME_WIDTH,
                                    min = 1,
                                    softMin = 50,
                                    softMax = 800,
                                    max = 1000000000,
                                    step = 1,
                                    bigStep = 10,
                                    set = function(info, value)
                                        ns.db.profile.unitFrames.player.manaBar.width = value
                                        ns.BUFPlayer:SetManaSize()
                                    end,
                                    get = function(info)
                                        return ns.db.profile.unitFrames.player.manaBar.width
                                    end,
                                    order = 1,
                                },
                                height = {
                                    type = "range",
                                    name = HUD_EDIT_MODE_SETTING_CHAT_FRAME_HEIGHT,
                                    min = 1,
                                    softMin = 5,
                                    softMax = 200,
                                    max = 1000000000,
                                    step = 1,
                                    bigStep = 5,
                                    set = function(info, value)
                                        ns.db.profile.unitFrames.player.manaBar.height = value
                                        ns.BUFPlayer:SetManaSize()
                                    end,
                                    get = function(info)
                                        return ns.db.profile.unitFrames.player.manaBar.height
                                    end,
                                    order = 2,
                                },
                                xOffset = {
                                    type = "range",
                                    name = ns.L["X Offset"],
                                    min = -500,
                                    softMin = -200,
                                    softMax = 200,
                                    max = 500,
                                    step = 1,
                                    bigStep = 5,
                                    set = function(info, value)
                                        ns.db.profile.unitFrames.player.manaBar.xOffset = value
                                        ns.BUFPlayer:SetManaPosition()
                                    end,
                                    get = function(info)
                                        return ns.db.profile.unitFrames.player.manaBar.xOffset
                                    end,
                                    order = 3,
                                },
                                yOffset = {
                                    type = "range",
                                    name = ns.L["Y Offset"],
                                    min = -500,
                                    softMin = -200,
                                    softMax = 200,
                                    max = 500,
                                    step = 1,
                                    bigStep = 5,
                                    set = function(info, value)
                                        ns.db.profile.unitFrames.player.manaBar.yOffset = value
                                        ns.BUFPlayer:SetManaPosition()
                                    end,
                                    get = function(info)
                                        return ns.db.profile.unitFrames.player.manaBar.yOffset
                                    end,
                                    order = 4,
                                },
                            },
                        },
                    }
                },
            },
        },
    },
}

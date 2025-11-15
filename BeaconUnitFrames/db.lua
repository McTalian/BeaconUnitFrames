---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

ns.DbManager = {
    dbName = "BUFDB", -- Must match the TOC file
    ---@class BUFDbSchema: AceDB.Schema
    dbDefaults = {
        global = {
            lastVersionLoaded = "",
            minimap = {
                hide = true,
            }
        },
        profile = {
            unitFrames = {
                player = {
                    enabled = true,
                    frame = {
                        width = 232,
                        height = 100,
                    },

                    portrait = {
                        enabled = true,
                        xOffset = 24,
                        yOffset = -19,
                        width = 60,
                        height = 60,
                        alpha = 1.0,
                        mask = true,
                    },

                    healthBar = {
                        width = 124,
                        height = 20,
                        xOffset = 85,
                        yOffset = -40,
                    },

                    manaBar = {
                        width = 124,
                        height = 10,
                        xOffset = 85,
                        yOffset = -61,
                    }
                },
            },
        },
    }
}

function ns.DbManager:Initialize()
    ---@class BUFDB: AceDBObject-3.0, BUFDbSchema
    ns.db = LibStub("AceDB-3.0"):New(self.dbName, self.dbDefaults, true)
end

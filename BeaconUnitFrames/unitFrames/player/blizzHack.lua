---@type string, table
local _, ns = ...

---@class BUFNamespace
ns = ns

---@class BUFPlayer
local BUFPlayer = ns.BUFPlayer

-- Utility functions for secure frame handling
local BlizzHack = {}

-- Save anchor points as a table
function BlizzHack.SaveAnchor(frame, name, point, relativeTo, relativePoint, x, y)
    if not frame.savedAnchors then
        frame.savedAnchors = {}
    end
    frame.savedAnchors[name] = {point, relativeTo, relativePoint, x, y}
end

-- Wrapper for SecureHandlerSetFrameRef
function BlizzHack.SetFrameRef(frame, label, refFrame)
    return SecureHandlerSetFrameRef(frame, label, refFrame)
end

-- Delayed execution until out of combat
BlizzHack.DelayedRun = {}
function BlizzHack.DelayedRun.OutOfCombat(func, ...)
    local args = {...}
    if not InCombatLockdown() then
        func(unpack(args))
    else
        local frame = CreateFrame("Frame")
        frame:RegisterEvent("PLAYER_REGEN_ENABLED")
        frame:SetScript("OnEvent", function(self)
            func(unpack(args))
            self:UnregisterEvent("PLAYER_REGEN_ENABLED")
        end)
    end
end

-- Vehicle positioning fix implementation
function BlizzHack.SetupVehiclePositionFix()
    local P = PlayerFrame
    
    -- Create the secure handler frame
    local PlayerArtUpdater = CreateFrame("Frame", nil, nil, "SecureHandlerAttributeTemplate")
    
    -- Set frame references
    BlizzHack.SetFrameRef(PlayerArtUpdater, "PlayerFrame", ns.BUFPlayer.frame)
    BlizzHack.SetFrameRef(PlayerArtUpdater, "PlayerHealthBar", ns.BUFPlayer.healthBar)
    BlizzHack.SetFrameRef(PlayerArtUpdater, "PlayerManaBar", ns.BUFPlayer.manaBar)
    
    -- Set the attribute change handler to call your RefreshConfig methods
    PlayerArtUpdater:SetAttribute("_onattributechanged", C_Timer.After(0.2, function() BUFPlayer:RefreshConfig() end))
    
    -- Register attribute drivers
    RegisterAttributeDriver(PlayerArtUpdater, "EnterLeave", "[vehicleui][overridebar][possessbar] 1; 0")
    RegisterAttributeDriver(PlayerArtUpdater, "ShiftAlt", "[mod:shift,mod:alt]1; 0")
    
    -- Hook PlayerFrame_UpdateArt for out of combat fixes
    hooksecurefunc("PlayerFrame_UpdateArt", function()
        BlizzHack.DelayedRun.OutOfCombat(function()
            -- Call your existing RefreshConfig methods
            BUFPlayer:RefreshConfig()
        end)
    end)
end

-- Initialize the vehicle position fix when the addon loads
function BlizzHack.Initialize()
    if not BlizzHack.isInitialized then
        BlizzHack.isInitialized = true
        BlizzHack.SetupVehiclePositionFix()
    end
end

-- Store in namespace for access from other files
ns.BlizzHack = BlizzHack

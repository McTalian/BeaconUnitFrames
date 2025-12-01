---@class BUFNamespace
local ns = select(2, ...)

local anchorFrameCounter = 0

--- Mixin providing secure handler functionality
---@class BUFSecureHandler: BUFConfigHandler
local SecureHandler = {}

function SecureHandler.SecureExecute(frame, CodeSnippet, ...)
    local outSnippet = format(CodeSnippet, ...)
    SecureHandlerExecute(frame, format(CodeSnippet, ...))
end

function SecureHandler.SecureSetFrameRef(sFrame, name, frame)
    SecureHandlerSetFrameRef(sFrame, name, frame)
    SecureHandler.SecureExecute(sFrame, [[ %s = self:GetFrameRef("%s") ]], name, name)
end

--- Saves the anchor information into the given table
--- @param tableName string The name of the table to save into
--- @param anchor AnchorInfo The anchor information to save
function SecureHandler.SaveAnchor(frame, tableName, anchor)
    local relFrame = anchor.relativeTo
    local nameRef = relFrame and relFrame:GetName()

    if not nameRef then
        anchorFrameCounter = anchorFrameCounter + 1
        nameRef = "AnchorFrame" .. anchorFrameCounter
    end

    SecureHandlerSetFrameRef(frame, nameRef, relFrame)
    SecureHandler.SecureExecute(
        frame,
        [[ %s = newtable("%s", self:GetFrameRef("%s"), "%s", %d, %d) ]],
        tableName,
        anchor.point,
        nameRef,
        anchor.relativePoint,
        anchor.xOffset,
        anchor.yOffset
    )
end



ns.BUFSecureHandler = SecureHandler

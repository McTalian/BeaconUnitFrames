---@type string, table
local addonName, ns = ...

---@class BUFNamespace
ns = ns

---@class AnchorInfo
---@field point string
---@field relativeTo Frame
---@field relativePoint string
---@field xOffset number
---@field yOffset number

local anchorFrameCounter = 0

--- Mixin providing secure handler functionality
---@class BUFSecureHandler: BUFConfigHandler
local SecureHandler = {}

function SecureHandler:SecureExecute(CodeSnippet, ...)
    local outSnippet = format(CodeSnippet, ...)
    SecureHandlerExecute(self, format(CodeSnippet, ...))
end

function SecureHandler:SecureSetFrameRef(name, frame)
    SecureHandlerSetFrameRef(self, name, frame)
    self:SecureExecute([[ %s = self:GetFrameRef("%s") ]], name, name)
end

--- Saves the anchor information into the given table
--- @param tableName string The name of the table to save into
--- @param anchor AnchorInfo The anchor information to save
function SecureHandler:SaveAnchor(tableName, anchor)
    local relFrame = anchor.relativeTo
    local nameRef = relFrame and relFrame:GetName()

    if not nameRef then
        anchorFrameCounter = anchorFrameCounter + 1
        nameRef = "AnchorFrame" .. anchorFrameCounter
    end

    SecureHandlerSetFrameRef(self, nameRef, relFrame)
    self:SecureExecute(
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

---@class BUFNamespace
local ns = select(2, ...)

---@class MixinBase: BUFConfigHandler
local MixinBase = {}

Mixin(MixinBase, ns.ProfileDbBackedHandler)

ns.Mixin = Mixin
ns.MixinBase = MixinBase

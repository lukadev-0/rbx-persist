--!strict
--[[
  Persist - Simple DataStore library
]]

local Persist = require(script.Packages.Persist)

export type Store<TKey, TData> = Persist.Store<TKey, TData>
export type Session<TKey, TData> = Persist.Session<TKey, TData>

return Persist

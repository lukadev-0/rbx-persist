--!strict

local Logger = require(script.Logger)
local Session = require(script.Session)
local Store = require(script.Store)

export type Store<TKey, TData> = Store.Store<TKey, TData>
export type Session<TKey, TData> = Session.Session<TKey, TData>

--[=[
	@class Persist
	Simple data store library
]=]
local Persist = {}

--[=[
	@prop Store Store
	@within Persist
]=]
Persist.Store = Store

--[=[
	@prop Session Session
	@within Persist
]=]
Persist.Session = Session

--[=[
	@interface LogLevel
	@within Persist
	@tag Enum

	.None 0
	.Warn 1
	.Info 2
	.Debug 3

	See [Persist.setLogLevel]
]=]
Persist.LogLevel = Logger.LogLevel

--[=[
	Changes the log level, the log level defaults to [`Persist.LogLevel.Warn`](Persist#LogLevel).

	```lua
	Persist.setLogLevel(Persist.LogLevel.Info)
	```

	@param logLevel LogLevel
]=]
function Persist.setLogLevel(logLevel: number)
	Logger.logLevel = logLevel
end

return Persist

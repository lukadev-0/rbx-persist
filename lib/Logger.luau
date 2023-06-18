--!strict
local Logger = {}

local LogLevel = {
	None = 0,
	Warn = 1,
	Info = 2,
	Debug = 3,
}

Logger.LogLevel = LogLevel
Logger.logLevel = LogLevel.Warn

function Logger.debug(...: any)
	if Logger.logLevel >= LogLevel.Debug then
		print("[Persist::Debug]", ...)
	end
end

function Logger.info(...: any)
	if Logger.logLevel >= LogLevel.Info then
		print("[Persist::Info] ", ...)
	end
end

function Logger.warn(...: any)
	if Logger.logLevel >= LogLevel.Warn then
		warn("[Persist::Warn] ", ...)
	end
end

return Logger

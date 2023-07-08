--!strict
local DataStoreService = game:GetService("DataStoreService")
local HttpService = game:GetService("HttpService")

local Data = require(script.Parent.Data)
local Logger = require(script.Parent.Logger)
local Promise = require(script.Parent.Parent.Promise)
local Session = require(script.Parent.Session)
local Signal = require(script.Parent.Parent.Signal)

--[=[
	@interface StoreOptions<TKey, TData>
	@within Store
	.datastore GlobalDataStore? -- The [GlobalDataStore] to use, defaults to the data store with the name of the store
	.lockId string? -- The ID to use for locking, this should be unique per server, defaults to [Store.defaultLockId]
	.key ((key: TKey) -> string)? -- A function that takes a key and returns a string key for the data store, this is not needed if the key is a string
	.data (key: TKey) -> TData -- A function that takes a key and returns the data to store in the data store
	.default (key: TKey) -> TData -- A function that takes a key and returns the default data
	.metadata ((key: TKey) -> { [any]: any }?)? -- A function that takes a key and returns the [metadata](https://create.roblox.com/docs/scripting/data/data-stores#metadata)
	.userIds ((key: TKey) -> { number }?)? -- A function that takes a key and returns an array of user ids associated with the key
	.releaseSessionsOnClose boolean? -- Whether or not to release all sessions when the server closes, defaults to true
	.autosaveSeconds number? -- How many seconds between autosave cycles, set to -1 to disable autosaves, defaults to 30
 
	The options for the [Store]
]=]
export type StoreOptions<TKey, TData> = {
	datastore: GlobalDataStore?,
	lockId: string?,
	key: ((key: TKey) -> string)?,
	data: (key: TKey) -> TData,
	default: (key: TKey) -> TData,
	metadata: ((key: TKey) -> { [any]: any }?)?,
	userIds: ((key: TKey) -> { number }?)?,
	releaseSessionsOnClose: boolean?,
	autosaveSeconds: number?,
}

--[=[
	@class Store
	Stores a collection of data.
]=]
local Store = {}
Store.__index = Store

--[=[
	@prop defaultLockId string
	@within Store
	@tag static

	The default [Store.lockId].
	This defaults to a random GUID such as `ff97f92b48a5472d96463ecf64c32866`.
]=]
Store.defaultLockId = HttpService:GenerateGUID():lower():gsub("[^a-z0-9]", "")

--[=[
	@prop datastore GlobalDataStore
	@within Store
	The underlying data store used.
]=]

--[=[
	@prop lockId string
	@within Store
	A string that should be unique per server, this will be used for session locking.
	This defaults to [Store.defaultLockId].
]=]

--[=[
	@prop name string
	@within Store
	The name of the store.
]=]

--[=[
	@prop sessions { [string]: Session<TKey, TData> }
	@within Store
	The sessions that are loaded. The key is the [string key](Store#getKey) of the session.
]=]

--[=[
	@prop sessionReleased Signal<Session<TKey, TData>, boolean>
	@within Store
	@tag Signal
	Fired whenever a session in the store has been released.

	The [Session] that released is given as first parameter. The second parameter
	is a boolean containing whether the data was saved or not (see [Session.released]).

	```lua
	store.sessionReleased:Connect(function(session, didSave)
		print(`Session "{session.keyStr}" has been released! didSave: {didSave}`)
	end)
	```
]=]

export type Store<TKey, TData> = typeof(setmetatable(
	{} :: {
		datastore: GlobalDataStore,
		_getData: (key: TKey) -> TData,
		_getDefault: (key: TKey) -> TData,
		_getKey: ((key: TKey) -> string)?,
		_getMetadata: ((key: TKey) -> { [any]: any }?)?,
		_getUserIds: ((key: TKey) -> { number }?)?,
		lockId: string,
		name: string,
		sessions: { [string]: Session.Session<TKey, TData> },
		sessionReleased: Signal.Signal<Session.Session<TKey, TData>, boolean>,
	},
	Store
))

local isClosing = false
local storesToReleaseOnClose: { Store<any, any> } = {}
local loadPromises: { [Promise.TypedPromise<Session.Session<any, any>>]: true } = {}

game:BindToClose(function()
	Logger.info("Server closing! Saving and releasing all sessions.")

	Logger.debug("Waiting for currently running updates.")
	Promise.allSettled(loadPromises :: any):await()

	local promises = {}
	for _, store in storesToReleaseOnClose do
		for _, session: any in store.sessions do
			local ok, err = pcall(function()
				table.insert(promises, (session :: Session.Session<any, any>):release())
			end)

			if not ok then
				Logger.warn(err)
			end
		end
	end

	Logger.debug(`Releasing {#promises} sessions.`)
	Promise.allSettled(promises :: any):await()

	Logger.info("Sessions saved and released.")
end)

--[=[
	Creates a store with the given name.

	@param name -- The name of the store
	@param options -- Options for the store
]=]
function Store.new<TKey, TData>(name: string, options: StoreOptions<TKey, TData>): Store<TKey, TData>
	local self = {
		datastore = options.datastore or DataStoreService:GetDataStore(name),

		_getKey = options.key,
		_getData = options.data,
		_getDefault = options.default,
		_getMetadata = options.metadata,
		_getUserIds = options.userIds,

		lockId = options.lockId or Store.defaultLockId,
		name = name,
		sessions = {},

		sessionReleased = Signal.new(),
	}

	setmetatable(self, Store)

	if options.releaseSessionsOnClose or options.releaseSessionsOnClose == nil then
		table.insert(storesToReleaseOnClose, self)
	end

	local autosaveSeconds = options.autosaveSeconds or 30
	local function autosaveCycle()
		local sessions: { Session.Session<TKey, TData> } = {}
		for _, session in self.sessions do
			table.insert(sessions, session :: any)
		end

		local timeBetweenSaves = autosaveSeconds / (#sessions + 1)
		Logger.info(`[AUTOSAVE] (store: "{self.name}"): Saving {#sessions} sessions within {autosaveSeconds} seconds`)

		task.spawn(function()
			for _, session: any in sessions do
				if not session._hasUpdated then
					session
						:update()
						:catch(function(err)
							Logger.warn(
								`[AUTOSAVE] (store: "{self.name}", key: "{self:getKey(session.key)}"): Autosave Failed:`,
								err
							)
						end)
						:finally(function()
							session._hasUpdated = false
						end)
				else
					session._hasUpdated = false
					Logger.info(`[AUTOSAVE] (store: "{self.name}", key: "{self:getKey(session.key)}"): Skipped`)
				end

				Promise.delay(timeBetweenSaves):await()
			end
		end)

		Promise.delay(autosaveSeconds):andThenCall(autosaveCycle)
	end

	if autosaveSeconds > 0 then
		Promise.delay(autosaveSeconds):andThenCall(autosaveCycle)
	end

	return self
end

--[=[
	Gets the string key used in the datastore.

	@method getKey
	@within Store
	@param key TKey
	@return string
]=]
function Store.getKey<TKey, TData>(self: Store<TKey, TData>, key: TKey): string
	if self._getKey then
		return self._getKey(key)
	end

	assert(
		typeof(key) == "string",
		`Store '{self.name}' doesn't know how to convert value of type '{typeof(key)}' into a data store key.\n`
	)
	return key
end

--[=[
	Gets the data to store in the datastore.

	@method getData
	@within Store
	@param key TKey
	@return TData
]=]
function Store.getData<TKey, TData>(self: Store<TKey, TData>, key: TKey): TData
	return self._getData(key)
end

--[=[
	Gets the default data to store in the datastore.

	@method getDefault
	@within Store
	@param key TKey
	@return TData
]=]
function Store.getDefault<TKey, TData>(self: Store<TKey, TData>, key: TKey): TData
	return self._getDefault(key)
end

--[=[
	Gets the metadata to store in the datastore.

	@method getMetadata
	@within Store
	@param key TKey
	@return { [any]: any }?
]=]
function Store.getMetadata<TKey, TData>(self: Store<TKey, TData>, key: TKey): { [any]: any }?
	if self._getMetadata then
		return self._getMetadata(key)
	end
	return nil
end

--[=[
	Gets the user ids to store in the datastore.

	@method getUserIds
	@within Store
	@param key TKey
	@return { number }?
]=]
function Store.getUserIds<TKey, TData>(self: Store<TKey, TData>, key: TKey): { number }?
	if self._getUserIds then
		return self._getUserIds(key)
	end
	return nil
end

--[=[
	Gets an existing session using the key.

	@method getSession
	@within Store
	@param key TKey
	@return Session<TKey, TData>?
]=]
function Store.getSession<TKey, TData>(self: Store<TKey, TData>, key: TKey): Session.Session<TKey, TData>?
	return self.sessions[self:getKey(key)]
end

local LOAD_RETRY_DELAYS = { 6, 8, 10, 12, 24, 30 }

--[=[
	Attempts to load the session with the given key.

	The `onSessionLocked` parameter specifies what to do if the session is locked:

	- `"requestRelease"`: This will repeatedly try to load the session and also tells the server that locked
		the session to release the session, saving all the data and removing the lock.

	- `"steal"`: This will steal the lock, overwriting the existing lock.

	:::caution Data Loss

	Using `"steal"` might cause data loss because the other server has no chance to
	save the data!

	:::

	@method load
	@within Store
	@param key TKey -- The key to load
	@param onSessionLocked ("requestRelease" | "steal")? -- What to do if the session is locked
	@param default TData? -- The default value to use, overwrites [StoreOptions.default]
	@return Promise<Session<TData, TKey>>
]=]
function Store.load<TKey, TData>(
	self: Store<TKey, TData>,
	key: TKey,
	onSessionLocked: ("requestRelease" | "steal")?,
	default: TData?
): Promise.TypedPromise<Session.Session<TKey, TData>>
	onSessionLocked = onSessionLocked or "requestRelease"

	if isClosing then
		return Promise.reject("Cannot load store whilst server is closing!")
	end

	local keyStr = self:getKey(key)
	local logPrefix = `(store: "{self.name}", key: "{keyStr}"): `

	local function getLoadAction(rawData: Data.RawData<TData>): "lock" | "requestRelease"
		if not Data.isLocked(rawData, self.lockId) then
			Logger.debug(logPrefix .. "Data is not locked.")
			return "lock"
		end

		Logger.debug(logPrefix .. "Data is locked.")

		-- The data hasn't been updated in a long time,
		-- the server could've crashed.
		if Data.isDeadLock(rawData) then
			Logger.debug(logPrefix .. "Lock is dead.")
			return "lock"
		end

		if onSessionLocked == "requestRelease" then
			return "requestRelease"
		else
			return "lock"
		end
	end

	local function attemptLoad(): Promise.TypedPromise<
		{ retry: true } | { retry: false, data: Data.RawData<TData>, keyInfo: DataStoreKeyInfo }
	>
		local action: "lock" | "requestRelease"

		return Data.updateAsync(self.name, self.datastore, keyStr, function(rawData, keyInfo)
			if rawData == nil then
				Logger.debug(logPrefix .. "Data was nil, using default.")

				action = "lock"
				return Data.locked(if default == nil then self:getDefault(key) else default, self.lockId),
					self:getUserIds(key),
					self:getMetadata(key)
			end

			action = getLoadAction(rawData)

			local data = Data.getInnerData(rawData)
			local newData

			if action == "lock" then
				newData = Data.locked(data, self.lockId)
			elseif action == "requestRelease" then
				newData = Data.requestRelease(
					data,
					Data.getCurrentLock(rawData) :: string,
					self.lockId,
					Data.getLastSaveTime(rawData)
				)
			else
				error(`Invalid action: '{action}'\nThis is a Persist bug, please report it!`)
			end

			return newData, keyInfo:GetUserIds(), keyInfo:GetMetadata()
		end):andThen(function(data, keyInfo)
			if action == "lock" then
				Logger.debug(logPrefix .. "Locked session.")
				return { retry = false, data = data, keyInfo = keyInfo }
			elseif action == "requestRelease" then
				Logger.debug(logPrefix .. "Requesting release.")
				return { retry = true } :: any
			else
				return Promise.reject(`Invalid action: '{action}'\nThis is a Persist bug, please report it!`) :: any
			end
		end)
	end

	local function retry(times: number?): Promise.TypedPromise<Session.Session<TKey, TData>>
		times = times or 1

		return attemptLoad():andThen(function(result)
			if result.retry then
				local retryDelay = LOAD_RETRY_DELAYS[times :: number]
				Logger.debug(logPrefix .. `Retrying in {retryDelay} seconds.`)

				return Promise.delay(retryDelay)
					:andThenCall(Logger.debug, logPrefix .. "retrying")
					:andThenCall(retry, math.min((times :: number) + 1, #LOAD_RETRY_DELAYS))
			else
				return Session.new(self :: any, key, Data.getInnerData(result.data), result.keyInfo)
			end
		end)
	end

	Logger.info(logPrefix .. "Loading session.")
	return retry():tap(function(session)
		Logger.info(logPrefix .. "Loaded session.")

		self.sessions[keyStr] = session
		session.released:Once(function(didSave)
			self.sessions[keyStr] = nil
			self.sessionReleased:Fire(session, didSave)
		end)
	end)
end

return Store

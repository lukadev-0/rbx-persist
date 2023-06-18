--!strict
local Data = require(script.Parent.Data)
local Logger = require(script.Parent.Logger)
local Promise = require(script.Parent.Parent.Promise)
local Signal = require(script.Parent.Parent.Signal)

--[=[
  @class Session
  A session
]=]
local Session = {}
Session.__index = Session

--[=[
	@prop key TKey
	@within Session
	The key
]=]

--[=[
	@prop keyInfo DataStoreKeyInfo
	@within Session
	The [DataStoreKeyInfo]
]=]

--[=[
	@prop data TData
	@within Session
	The data
]=]

--[=[
	@prop isReleased boolean
	@within Session
	Whether or not the session has been released.
]=]

--[=[
	@prop isReleasing boolean
	@within Session
	Whether or not the session is currently being released.
]=]

--[=[
	@prop store Store
	@within Session
	The store
]=]

--[=[
	@prop released Signal<boolean>
	@within Session
	@tag Signal
	Fired whenever the session is released.

	The first parameter is a boolean which is `true` if the data saved, and
	`false` if the data could not be saved, this could be because the session was
	stolen by a different server.

	```lua
	session.released:Connect(function(didSave)
		print(`Session released! didSave: {didSave}`)
	end)
	```
]=]

export type Store<TKey, TData> = typeof(setmetatable(
	{} :: {
		name: string,
		lockId: string,
		datastore: GlobalDataStore,
	},
	{} :: {
		__index: {
			getKey: (self: Store<TKey, TData>, key: TKey) -> string,
			getData: (self: Store<TKey, TData>, key: TKey) -> TData,
			getUserIds: (self: Store<TKey, TData>, key: TKey) -> { number }?,
			getMetadata: (self: Store<TKey, TData>, key: TKey) -> { [any]: any }?,
		},
	}
))

export type Session<TKey, TData> = typeof(setmetatable(
	{} :: {
		key: TKey,
		keyInfo: DataStoreKeyInfo,
		data: TData,
		released: Signal.Signal<boolean>,
		store: Store<TKey, TData>,
		isReleased: boolean,
		isReleasing: boolean,
		_hasUpdated: boolean,
	},
	Session
))

--[=[
  Creates a session with the given `key` and `data`

  :::note
  You're probably looking for [Store:load]
  :::
]=]
function Session.new<TKey, TData>(store: Store<TKey, TData>, key: TKey, data: TData, keyInfo: DataStoreKeyInfo): Session<TKey, TData>
	local self = {
		store = store,
		key = key,
		keyInfo = keyInfo,
		data = data,
		released = Signal.new(),
		isReleased = false,
		isReleasing = false,
		_hasUpdated = false,
	}

	setmetatable(self, Session)
	return self
end

--[=[
	Updates the session, saving all data and updating the
	[Session.data] and [Session.keyInfo] properties.

	This will also release the session if a different server is
	requesting a release.

	This will also stop the autosave in the current autosave cycle.

	@method update
	@within Session
	@return Promise<()>
]=]
function Session.update<TKey, TData>(self: Session<TKey, TData>): Promise.TypedPromise<()>
	if self.isReleasing then
		return Promise.reject("Can't update session whilst session is being released")
	end

	if self.isReleased then
		return Promise.reject("Can't update session that is released")
	end

	local keyStr = self.store:getKey(self.key)
	local data = self.store:getData(self.key)
	local logPrefix = `(store: "{self.store.name}", key: "{keyStr}"): `

	self._hasUpdated = true

	Logger.info(logPrefix .. "Updating session.")

	local shouldRelease = false
	local didSave = false

	return Data.updateAsync(self.store.name, self.store.datastore, keyStr, function(rawData)
		if Data.isLocked(rawData, self.store.lockId) then
			Logger.warn(
				logPrefix
					.. "Data was locked whilst trying to update - data could not be saved - session has been released"
			)

			self.isReleasing = true
			shouldRelease = true

			return nil
		end

		if Data.getReleaseRequest(rawData) ~= nil and Data.getReleaseRequest(rawData) ~= self.store.lockId then
			Logger.info(logPrefix .. "A different server is requesting a release.")

			self.isReleasing = true
			shouldRelease = true
			didSave = true

			return Data.released(data), self.store:getUserIds(self.key), self.store:getMetadata(self.key)
		end

		didSave = true
		return Data.locked(data, self.store.lockId), self.store:getUserIds(self.key), self.store:getMetadata(self.key)
	end)
		:andThen(function(rawData, keyInfo)
			if rawData and keyInfo then
				self.data = Data.getInnerData(rawData)
				self.keyInfo = keyInfo
			end

			if shouldRelease then
				self.isReleased = true
				self.released:Fire(didSave)
			end

			if didSave and shouldRelease then
				Logger.info(logPrefix .. "Session updated, saved and released.")
			elseif didSave then
				Logger.info(logPrefix .. "Session updated and saved.")
			else
				Logger.warn(logPrefix .. "Session updated without saving.")
			end
		end)
		:finally(function()
			if shouldRelease then
				self.isReleasing = false
			end
		end)
end

--[=[
	Releases this session.

	@method release
	@within Session
	@return Promise<()>
]=]
function Session.release<TKey, TData>(self: Session<TKey, TData>): Promise.TypedPromise<()>
	if self.isReleasing or self.isReleased then
		return Promise.resolve()
	end

	local keyStr = self.store:getKey(self.key)
	local data = self.store:getData(self.key)
	local logPrefix = `(store: "{self.store.name}", key: "{keyStr}"): `

	Logger.info(logPrefix .. "Releasing session.")
	self.isReleasing = true

	local didSave = false
	return Data.updateAsync(self.store.name, self.store.datastore, keyStr, function(rawData)
		if Data.isLocked(rawData, self.store.lockId) then
			Logger.warn(logPrefix .. "Data was locked whilst trying to release - data could not be saved")
			return nil
		end

		didSave = true
		return Data.released(data), self.store:getUserIds(self.key), self.store:getMetadata(self.key)
	end)
		:andThen(function(rawData, keyInfo)
			self.released:Fire(didSave)
			self.isReleased = true

			if didSave then
				Logger.info(logPrefix .. "Data saved and released.")
			end

			if rawData and keyInfo then
				self.data = Data.getInnerData(rawData)
				self.keyInfo = keyInfo
			end
		end)
		:finally(function()
			self.isReleasing = false
		end)
end

return Session

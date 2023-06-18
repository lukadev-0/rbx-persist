local Promise = require(script.Parent.Parent.Promise)
local Data = {}

local DEAD_LOCK_DURATION = 30 * 60 -- 30 minutes

Data.RawDataKeys = {
	--- Contains the actual data
	Data = "d" :: "d",

	--- The last save time
	LastUpdateTime = "t" :: "t",

	--- Contains the release request
	ReleaseRequest = "r" :: "r",

	--- The [Store.lockId], if the key is locked
	Lock = "l" :: "l",
}

export type RawData<TData> = {
	d: TData,
	t: number,
	r: string?,
	l: string?,
}

function Data.isLocked<TData>(data: RawData<TData>, lock: string): boolean
	return data[Data.RawDataKeys.Lock] ~= nil and data[Data.RawDataKeys.Lock] ~= lock
end

function Data.isDeadLock<TData>(data: RawData<TData>): boolean
	return (data[Data.RawDataKeys.LastUpdateTime] + DEAD_LOCK_DURATION) < os.time()
end

function Data.getInnerData<TData>(data: RawData<TData>): TData
	return data[Data.RawDataKeys.Data]
end

function Data.getCurrentLock<TData>(data: RawData<TData>): string?
	return data[Data.RawDataKeys.Lock]
end

function Data.getReleaseRequest<TData>(data: RawData<TData>): string?
	return data[Data.RawDataKeys.ReleaseRequest]
end

function Data.getLastSaveTime<TData>(data: RawData<TData>): number
	return data[Data.RawDataKeys.LastUpdateTime]
end

function Data.updateAsync<TKey, TData>(
	storeName: string,
	datastore: GlobalDataStore,
	key: string,
	transformFunction: (data: RawData<TData>, keyInfo: DataStoreKeyInfo) -> ()
): Promise.TypedPromise<RawData<TData>, DataStoreKeyInfo>
	return Promise.new(function(resolve, reject)
		xpcall(function()
			resolve(datastore:UpdateAsync(key, function(data, keyInfo)
				return transformFunction(data, keyInfo)
			end))
		end, function(err)
			reject(`(store: "{storeName}", key: "{key}"): DataStore error: {err}`)
		end)
	end)
end

function Data.locked<TData>(data: TData, lock: string): RawData<TData>
	return {
		d = data,
		t = os.time(),
		l = lock,
	}
end

function Data.requestRelease<TData>(data: TData, currentLock: string, newLock: string, lastSaveTime: number): RawData<TData>
	return {
		d = data,
		t = lastSaveTime,
		l = currentLock,
		r = newLock,
	}
end

function Data.released<TData>(data: TData)
	return {
		d = data,
		t = os.time(),
	}
end

return Data

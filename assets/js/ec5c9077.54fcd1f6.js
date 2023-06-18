"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[289],{50967:e=>{e.exports=JSON.parse('{"functions":[{"name":"new","desc":"Creates a store with the given name.","params":[{"name":"name","desc":"The name of the store","lua_type":"string"},{"name":"options","desc":"Options for the store","lua_type":"StoreOptions<TKey, TData>"}],"returns":[{"desc":"","lua_type":"Store<TKey, TData>\\n"}],"function_type":"static","source":{"line":147,"path":"lib/Store.luau"}},{"name":"getKey","desc":"Gets the string key used in the datastore.","params":[{"name":"key","desc":"","lua_type":"TKey"}],"returns":[{"desc":"","lua_type":"string"}],"function_type":"method","source":{"line":221,"path":"lib/Store.luau"}},{"name":"getData","desc":"Gets the data to store in the datastore.","params":[{"name":"key","desc":"","lua_type":"TKey"}],"returns":[{"desc":"","lua_type":"TData"}],"function_type":"method","source":{"line":241,"path":"lib/Store.luau"}},{"name":"getDefault","desc":"Gets the default data to store in the datastore.","params":[{"name":"key","desc":"","lua_type":"TKey"}],"returns":[{"desc":"","lua_type":"TData"}],"function_type":"method","source":{"line":253,"path":"lib/Store.luau"}},{"name":"getMetadata","desc":"Gets the metadata to store in the datastore.","params":[{"name":"key","desc":"","lua_type":"TKey"}],"returns":[{"desc":"","lua_type":"{ [any]: any }?"}],"function_type":"method","source":{"line":265,"path":"lib/Store.luau"}},{"name":"getUserIds","desc":"Gets the user ids to store in the datastore.","params":[{"name":"key","desc":"","lua_type":"TKey"}],"returns":[{"desc":"","lua_type":"{ number }?"}],"function_type":"method","source":{"line":280,"path":"lib/Store.luau"}},{"name":"getSession","desc":"Gets an existing session using the key.","params":[{"name":"key","desc":"","lua_type":"TKey"}],"returns":[{"desc":"","lua_type":"Session<TKey, TData>?"}],"function_type":"method","source":{"line":295,"path":"lib/Store.luau"}},{"name":"load","desc":"Attempts to load the session with the given key.\\n\\nThe `onSessionLocked` parameter specifies what to do if the session is locked:\\n\\n- `\\"requestRelease\\"`: This will repeatedly try to load the session and also tells the server that locked\\n\\tthe session to release the session, saving all the data and removing the lock.\\n\\n- `\\"steal\\"`: This will steal the lock, overwriting the existing lock.\\n\\n:::caution Data Loss\\n\\nUsing `\\"steal\\"` might cause data loss because the other server has no chance to\\nsave the data!\\n\\n:::","params":[{"name":"key","desc":"The key to load","lua_type":"TKey"},{"name":"onSessionLocked","desc":"What to do if the session is locked","lua_type":"(\\"requestRelease\\" | \\"steal\\")?"},{"name":"default","desc":"The default value to use, overwrites [StoreOptions.default]","lua_type":"TData?"}],"returns":[{"desc":"","lua_type":"Promise<Session<TData, TKey>>"}],"function_type":"method","source":{"line":325,"path":"lib/Store.luau"}}],"properties":[{"name":"defaultLockId","desc":"The default [Store.lockId].\\nThis defaults to a random GUID such as `ff97f92b48a5472d96463ecf64c32866`.","lua_type":"string","tags":["static"],"source":{"line":53,"path":"lib/Store.luau"}},{"name":"datastore","desc":"The underlying data store used.","lua_type":"GlobalDataStore","source":{"line":60,"path":"lib/Store.luau"}},{"name":"lockId","desc":"A string that should be unique per server, this will be used for session locking.\\nThis defaults to [Store.defaultLockId].","lua_type":"string","source":{"line":67,"path":"lib/Store.luau"}},{"name":"name","desc":"The name of the store.","lua_type":"string","source":{"line":73,"path":"lib/Store.luau"}},{"name":"sessions","desc":"The sessions that are loaded. The key is the [string key](Store#getKey) of the session.","lua_type":"{ [string]: Session<TKey, TData> }","source":{"line":79,"path":"lib/Store.luau"}},{"name":"sessionReleased","desc":"Fired whenever a session in the store has been released.\\n\\nThe [Session] that released is given as first parameter. The second parameter\\nis a boolean containing whether the data was saved or not (see [Session.released]).\\n\\n```lua\\nstore.sessionReleased:Connect(function(session, didSave)\\n\\tprint(`Session \\"{session.keyStr}\\" has been released! didSave: {didSave}`)\\nend)\\n```","lua_type":"Signal<Session<TKey, TData>, boolean>","tags":["Signal"],"source":{"line":95,"path":"lib/Store.luau"}}],"types":[{"name":"StoreOptions<TKey, TData>","desc":" \\nThe options for the [Store]","fields":[{"name":"dataStore","lua_type":"GlobalDataStore?","desc":"The [GlobalDataStore] to use, defaults to the data store with the name of the store"},{"name":"lockId","lua_type":"string?","desc":"The ID to use for locking, this should be unique per server, defaults to [Store.defaultLockId]"},{"name":"key","lua_type":"((key: TKey) -> string)?","desc":"A function that takes a key and returns a string key for the data store, this is not needed if the key is a string"},{"name":"data","lua_type":"(key: TKey) -> TData","desc":"A function that takes a key and returns the data to store in the data store"},{"name":"default","lua_type":"(key: TKey) -> TData","desc":"A function that takes a key and returns the default data"},{"name":"metadata","lua_type":"((key: TKey) -> { [any]: any }?)?","desc":"A function that takes a key and returns the [metadata](https://create.roblox.com/docs/scripting/data/data-stores#metadata)"},{"name":"userIds","lua_type":"((key: TKey) -> { number }?)?","desc":"A function that takes a key and returns an array of user ids associated with the key"},{"name":"releaseSessionsOnClose","lua_type":"boolean?","desc":"Whether or not to release all sessions when the server closes, defaults to true"},{"name":"autosaveSeconds","lua_type":"number?","desc":"How many seconds between autosave cycles, set to -1 to disable autosaves, defaults to 30"}],"source":{"line":26,"path":"lib/Store.luau"}}],"name":"Store","desc":"Stores a collection of data.","source":{"line":42,"path":"lib/Store.luau"}}')}}]);
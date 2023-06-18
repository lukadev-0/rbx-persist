---
sidebar_position: 2
---

# Getting Started

:::caution

Persist is not production-ready yet, you might experience bugs and missing features!

:::

## Example Game

Here is an uncopylocked example game using Persist:
https://www.roblox.com/games/13789071125/Persist-Example-Game

## Installation

### Roblox Studio

If you're using Roblox Studio, you can install Persist by downloading the `.rbxm` file from
[the latest release](https://github.com/lukadev-0/rbx-persist/releases) and then insert it
into ServerScriptService.

### Rojo/Wally

If you're using Wally and Rojo, you can install Persist by adding the following line to your
`wally.toml`:

```toml
[dependencies]
Persist = "lukadev-0/persist@0.1.0"
```

## Basic Usage

Lets create a simple script that will put the data into leaderstats.

First, we must get the `Players` service and require the `Persist` module:

```lua
local Players = game:GetService("Players")
local Persist = require(path.to.persist)
```

Then, we must create a store, the store will allow us to load the data:

```lua
local store = Persist.Store.new("PlayerData", {
  -- ...
})
```

Persist allows anything to be a "key", a key is a unique identifier for our data.

In this case, we want the player to be the key, however, the key must be converted
into a string in order to work with datastores, so we must tell Persist how to convert
the key (a Player) into a string key.

This is done by passing a `key` function, this function takes in a key, which is a
player in this case, and returns a string

We're going to make the key `Player_` followed by the user id of the player:

```lua
local store = Persist.Store.new("PlayerData", {
  key = function(player: Player)
    return `Player_{player.UserId}`
  end,
})
```

Next, we need to add a `data` function, this will take the player and return the data
that needs to be saved.

We're going to get our data from the leaderstats:

```lua
local store = Persist.Store.new("PlayerData", {
  key = --[[ ... ]],

  data = function(player: Player)
    return {
      money = player.leaderstats.Money.Value,
    }
  end,
})
```

Next, we need to add a `default` function, this will return the default data that the
player should have.

```lua
local store = Persist.Store.new("PlayerData", {
  key = --[[ ... ]],

  data = --[[ ... ]],

  default = function()
    return {
      money = 0,
    }
  end,
})
```

Next, we'll add a `userIds` function, this function will return the user ids associated
with the key.

Here, we only have one user id, but for more complicated stuff, such as a "groups" system
you might have multiple ids.

```lua
local store = Persist.Store.new("PlayerData", {
  key = --[[ ... ]],

  data = --[[ ... ]],

  default = --[[ ... ]],

  userIds = function(player: Player)
    return { player.UserId }
  end,
})
```

Now that we have our store, we need to implement the logic that actually loads and saves the data.

We need to load the player's data whenever a player joins:

```lua
Players.PlayerAdded:Connect(function(player)
  store:load(player)
end)
```

`store:load()` returns a [Promise](https://eryn.io/roblox-lua-promise/), so we need to use `:andThen`
to get the resolved value.

```lua
Players.PlayerAdded:Connect(function(player)
  store:load(player)
    :andThen(function(session)
      -- The player might've left before the session finished loading
      if not player:IsDescendantOf(Players) then
        return session:release()
      end
    end)
end)
```

We added a check to see if the player is still in the game after the session finished loading,
we _release_ the session if they left, **otherwise that player's data cannot be loaded for 30
minutes**.

Next, we're going to listen if the session is released and then kick the player if it did, this
is because once a session is released the server can't save their data anymore.

```lua
Players.PlayerAdded:Connect(function(player)
  store:load(player)
    :andThen(function(session)
      -- ...

      session.released:Connect(function()
        player:Kick("Session was released")
      end)
    end)
end)
```

Now, we can create the leaderstats using the data in the session.

```lua
Players.PlayerAdded:Connect(function(player)
  store:load(player)
    :andThen(function(session)
      -- ...

      local money = Instance.new("NumberValue")
      money.Value = session.data.money
      money.Name = "Money"
      money.Parent = leaderstats

      leaderstats.Parent = player
    end)
end)
```

We also need to catch and handle any errors that come up, we will kick
the player and warn the error.

```lua
Players.PlayerAdded:Connect(function(player)
  store:load(player)
    :andThen(--[[ ... ]])
    :catch(function(err)
      warn(err)
      player:Kick("Data failed to load")
    end)
end)
```

Then, when the player leaves, we must release the session.

```lua
Players.PlayerRemoving:Connect(function(player)
  local session = store:getSession(player)
  if session then
    session:release()
  end
end)
```

And that's it! The leaderstats should now save.

### Finished Script

Your whole script should look like this:

```lua
local Players = game:GetService("Players")
local Persist = require(path.to.persist)

local store = Persist.Store.new("PlayerData", {
	key = function(player: Player)
		return `Player_{player.UserId}`
	end,

	data = function(player: Player)
		return {
			money = player.leaderstats.Money.Value,
		}
	end,

	default = function()
		return {
			money = 0,
		}
	end,

	userIds = function(player: Player)
		return { player.UserId }
	end,
})

Players.PlayerAdded:Connect(function(player)
	store:load(player)
		:andThen(function(session)
			-- The player might've left before the session finished loading
			if not player:IsDescendantOf(Players) then
				return session:release()
			end

			session.released:Connect(function()
				player:Kick("Session was released")
			end)

			local leaderstats = Instance.new("Folder")
			leaderstats.Name = "leaderstats"

			local money = Instance.new("NumberValue")
			money.Value = session.data.money
			money.Name = "Money"
			money.Parent = leaderstats

			leaderstats.Parent = player
		end)
		:catch(function(err)
			warn(err)
			player:Kick("Data failed to load")
		end)
end)

Players.PlayerRemoving:Connect(function(player)
	local session = store:getSession(player)
	if session then
		session:release()
	end
end)
```

"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[162],{3905:(e,n,t)=>{t.d(n,{Zo:()=>p,kt:()=>m});var a=t(67294);function r(e,n,t){return n in e?Object.defineProperty(e,n,{value:t,enumerable:!0,configurable:!0,writable:!0}):e[n]=t,e}function l(e,n){var t=Object.keys(e);if(Object.getOwnPropertySymbols){var a=Object.getOwnPropertySymbols(e);n&&(a=a.filter((function(n){return Object.getOwnPropertyDescriptor(e,n).enumerable}))),t.push.apply(t,a)}return t}function s(e){for(var n=1;n<arguments.length;n++){var t=null!=arguments[n]?arguments[n]:{};n%2?l(Object(t),!0).forEach((function(n){r(e,n,t[n])})):Object.getOwnPropertyDescriptors?Object.defineProperties(e,Object.getOwnPropertyDescriptors(t)):l(Object(t)).forEach((function(n){Object.defineProperty(e,n,Object.getOwnPropertyDescriptor(t,n))}))}return e}function o(e,n){if(null==e)return{};var t,a,r=function(e,n){if(null==e)return{};var t,a,r={},l=Object.keys(e);for(a=0;a<l.length;a++)t=l[a],n.indexOf(t)>=0||(r[t]=e[t]);return r}(e,n);if(Object.getOwnPropertySymbols){var l=Object.getOwnPropertySymbols(e);for(a=0;a<l.length;a++)t=l[a],n.indexOf(t)>=0||Object.prototype.propertyIsEnumerable.call(e,t)&&(r[t]=e[t])}return r}var i=a.createContext({}),d=function(e){var n=a.useContext(i),t=n;return e&&(t="function"==typeof e?e(n):s(s({},n),e)),t},p=function(e){var n=d(e.components);return a.createElement(i.Provider,{value:n},e.children)},u="mdxType",c={inlineCode:"code",wrapper:function(e){var n=e.children;return a.createElement(a.Fragment,{},n)}},y=a.forwardRef((function(e,n){var t=e.components,r=e.mdxType,l=e.originalType,i=e.parentName,p=o(e,["components","mdxType","originalType","parentName"]),u=d(t),y=r,m=u["".concat(i,".").concat(y)]||u[y]||c[y]||l;return t?a.createElement(m,s(s({ref:n},p),{},{components:t})):a.createElement(m,s({ref:n},p))}));function m(e,n){var t=arguments,r=n&&n.mdxType;if("string"==typeof e||r){var l=t.length,s=new Array(l);s[0]=y;var o={};for(var i in n)hasOwnProperty.call(n,i)&&(o[i]=n[i]);o.originalType=e,o[u]="string"==typeof e?e:r,s[1]=o;for(var d=2;d<l;d++)s[d]=t[d];return a.createElement.apply(null,s)}return a.createElement.apply(null,t)}y.displayName="MDXCreateElement"},99390:(e,n,t)=>{t.r(n),t.d(n,{assets:()=>i,contentTitle:()=>s,default:()=>c,frontMatter:()=>l,metadata:()=>o,toc:()=>d});var a=t(87462),r=(t(67294),t(3905));const l={sidebar_position:2},s="Getting Started",o={unversionedId:"getting-started",id:"getting-started",title:"Getting Started",description:"Persist is not production-ready yet, you might experience bugs and missing features!",source:"@site/docs/getting-started.md",sourceDirName:".",slug:"/getting-started",permalink:"/rbx-persist/docs/getting-started",draft:!1,editUrl:"https://github.com/lukadev-0/rbx-persist/edit/master/docs/getting-started.md",tags:[],version:"current",sidebarPosition:2,frontMatter:{sidebar_position:2},sidebar:"defaultSidebar",previous:{title:"Intro",permalink:"/rbx-persist/docs/intro"},next:{title:"Session Locking",permalink:"/rbx-persist/docs/session-locking"}},i={},d=[{value:"Example Game",id:"example-game",level:2},{value:"Installation",id:"installation",level:2},{value:"Roblox Studio",id:"roblox-studio",level:3},{value:"Rojo/Wally",id:"rojowally",level:3},{value:"Basic Usage",id:"basic-usage",level:2},{value:"Finished Script",id:"finished-script",level:3}],p={toc:d},u="wrapper";function c(e){let{components:n,...t}=e;return(0,r.kt)(u,(0,a.Z)({},p,t,{components:n,mdxType:"MDXLayout"}),(0,r.kt)("h1",{id:"getting-started"},"Getting Started"),(0,r.kt)("admonition",{type:"caution"},(0,r.kt)("p",{parentName:"admonition"},"Persist is not production-ready yet, you might experience bugs and missing features!")),(0,r.kt)("h2",{id:"example-game"},"Example Game"),(0,r.kt)("p",null,"Here is an uncopylocked example game using Persist:\n",(0,r.kt)("a",{parentName:"p",href:"https://www.roblox.com/games/13789071125/Persist-Example-Game"},"https://www.roblox.com/games/13789071125/Persist-Example-Game")),(0,r.kt)("h2",{id:"installation"},"Installation"),(0,r.kt)("h3",{id:"roblox-studio"},"Roblox Studio"),(0,r.kt)("p",null,"If you're using Roblox Studio, you can install Persist by downloading the ",(0,r.kt)("inlineCode",{parentName:"p"},".rbxm")," file from\n",(0,r.kt)("a",{parentName:"p",href:"https://github.com/lukadev-0/rbx-persist/releases"},"the latest release")," and then insert it\ninto ServerScriptService."),(0,r.kt)("h3",{id:"rojowally"},"Rojo/Wally"),(0,r.kt)("p",null,"If you're using Wally and Rojo, you can install Persist by adding the following line to your\n",(0,r.kt)("inlineCode",{parentName:"p"},"wally.toml"),":"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-toml"},'[dependencies]\nPersist = "lukadev-0/persist@0.1.0"\n')),(0,r.kt)("h2",{id:"basic-usage"},"Basic Usage"),(0,r.kt)("p",null,"Lets create a simple script that will put the data into leaderstats."),(0,r.kt)("p",null,"First, we must get the ",(0,r.kt)("inlineCode",{parentName:"p"},"Players")," service and require the ",(0,r.kt)("inlineCode",{parentName:"p"},"Persist")," module:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},'local Players = game:GetService("Players")\nlocal Persist = require(path.to.persist)\n')),(0,r.kt)("p",null,"Then, we must create a store, the store will allow us to load the data:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},'local store = Persist.Store.new("PlayerData", {\n  -- ...\n})\n')),(0,r.kt)("p",null,'Persist allows anything to be a "key", a key is a unique identifier for our data.'),(0,r.kt)("p",null,"In this case, we want the player to be the key, however, the key must be converted\ninto a string in order to work with datastores, so we must tell Persist how to convert\nthe key (a Player) into a string key."),(0,r.kt)("p",null,"This is done by passing a ",(0,r.kt)("inlineCode",{parentName:"p"},"key")," function, this function takes in a key, which is a\nplayer in this case, and returns a string"),(0,r.kt)("p",null,"We're going to make the key ",(0,r.kt)("inlineCode",{parentName:"p"},"Player_")," followed by the user id of the player:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},'local store = Persist.Store.new("PlayerData", {\n  key = function(player: Player)\n    return `Player_{player.UserId}`\n  end,\n})\n')),(0,r.kt)("p",null,"Next, we need to add a ",(0,r.kt)("inlineCode",{parentName:"p"},"data")," function, this will take the player and return the data\nthat needs to be saved."),(0,r.kt)("p",null,"We're going to get our data from the leaderstats:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},'local store = Persist.Store.new("PlayerData", {\n  key = --[[ ... ]],\n\n  data = function(player: Player)\n    return {\n      money = player.leaderstats.Money.Value,\n    }\n  end,\n})\n')),(0,r.kt)("p",null,"Next, we need to add a ",(0,r.kt)("inlineCode",{parentName:"p"},"default")," function, this will return the default data that the\nplayer should have."),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},'local store = Persist.Store.new("PlayerData", {\n  key = --[[ ... ]],\n\n  data = --[[ ... ]],\n\n  default = function()\n    return {\n      money = 0,\n    }\n  end,\n})\n')),(0,r.kt)("p",null,"Next, we'll add a ",(0,r.kt)("inlineCode",{parentName:"p"},"userIds")," function, this function will return the user ids associated\nwith the key."),(0,r.kt)("p",null,'Here, we only have one user id, but for more complicated stuff, such as a "groups" system\nyou might have multiple ids.'),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},'local store = Persist.Store.new("PlayerData", {\n  key = --[[ ... ]],\n\n  data = --[[ ... ]],\n\n  default = --[[ ... ]],\n\n  userIds = function(player: Player)\n    return { player.UserId }\n  end,\n})\n')),(0,r.kt)("p",null,"Now that we have our store, we need to implement the logic that actually loads and saves the data."),(0,r.kt)("p",null,"We need to load the player's data whenever a player joins:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},"Players.PlayerAdded:Connect(function(player)\n  store:load(player)\nend)\n")),(0,r.kt)("p",null,(0,r.kt)("inlineCode",{parentName:"p"},"store:load()")," returns a ",(0,r.kt)("a",{parentName:"p",href:"https://eryn.io/roblox-lua-promise/"},"Promise"),", so we need to use ",(0,r.kt)("inlineCode",{parentName:"p"},":andThen"),"\nto get the resolved value."),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},"Players.PlayerAdded:Connect(function(player)\n  store:load(player)\n    :andThen(function(session)\n      -- The player might've left before the session finished loading\n      if not player:IsDescendantOf(Players) then\n        return session:release()\n      end\n    end)\nend)\n")),(0,r.kt)("p",null,"We added a check to see if the player is still in the game after the session finished loading,\nwe ",(0,r.kt)("em",{parentName:"p"},"release")," the session if they left, ",(0,r.kt)("strong",{parentName:"p"},"otherwise that player's data cannot be loaded for 30\nminutes"),"."),(0,r.kt)("p",null,"Next, we're going to listen if the session is released and then kick the player if it did, this\nis because once a session is released the server can't save their data anymore."),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},'Players.PlayerAdded:Connect(function(player)\n  store:load(player)\n    :andThen(function(session)\n      -- ...\n\n      session.released:Connect(function()\n        player:Kick("Session was released")\n      end)\n    end)\nend)\n')),(0,r.kt)("p",null,"Now, we can create the leaderstats using the data in the session."),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},'Players.PlayerAdded:Connect(function(player)\n  store:load(player)\n    :andThen(function(session)\n      -- ...\n\n      local money = Instance.new("NumberValue")\n      money.Value = session.data.money\n      money.Name = "Money"\n      money.Parent = leaderstats\n\n      leaderstats.Parent = player\n    end)\nend)\n')),(0,r.kt)("p",null,"We also need to catch and handle any errors that come up, we will kick\nthe player and warn the error."),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},'Players.PlayerAdded:Connect(function(player)\n  store:load(player)\n    :andThen(--[[ ... ]])\n    :catch(function(err)\n      warn(err)\n      player:Kick("Data failed to load")\n    end)\nend)\n')),(0,r.kt)("p",null,"Then, when the player leaves, we must release the session."),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},"Players.PlayerRemoving:Connect(function(player)\n  local session = store:getSession(player)\n  if session then\n    session:release()\n  end\nend)\n")),(0,r.kt)("p",null,"And that's it! The leaderstats should now save."),(0,r.kt)("h3",{id:"finished-script"},"Finished Script"),(0,r.kt)("p",null,"Your whole script should look like this:"),(0,r.kt)("pre",null,(0,r.kt)("code",{parentName:"pre",className:"language-lua"},'local Players = game:GetService("Players")\nlocal Persist = require(path.to.persist)\n\nlocal store = Persist.Store.new("PlayerData", {\n    key = function(player: Player)\n        return `Player_{player.UserId}`\n    end,\n\n    data = function(player: Player)\n        return {\n            money = player.leaderstats.Money.Value,\n        }\n    end,\n\n    default = function()\n        return {\n            money = 0,\n        }\n    end,\n\n    userIds = function(player: Player)\n        return { player.UserId }\n    end,\n})\n\nPlayers.PlayerAdded:Connect(function(player)\n    store:load(player)\n        :andThen(function(session)\n            -- The player might\'ve left before the session finished loading\n            if not player:IsDescendantOf(Players) then\n                return session:release()\n            end\n\n            session.released:Connect(function()\n                player:Kick("Session was released")\n            end)\n\n            local leaderstats = Instance.new("Folder")\n            leaderstats.Name = "leaderstats"\n\n            local money = Instance.new("NumberValue")\n            money.Value = session.data.money\n            money.Name = "Money"\n            money.Parent = leaderstats\n\n            leaderstats.Parent = player\n        end)\n        :catch(function(err)\n            warn(err)\n            player:Kick("Data failed to load")\n        end)\nend)\n\nPlayers.PlayerRemoving:Connect(function(player)\n    local session = store:getSession(player)\n    if session then\n        session:release()\n    end\nend)\n')))}c.isMDXComponent=!0}}]);
Assets {
  Id: 14237971253290887057
  Name: "Chat Commands Tutorial"
  PlatformAssetType: 5
  TemplateAsset {
    ObjectBlock {
      RootId: 16770956965621346328
      Objects {
        Id: 16770956965621346328
        Name: "TemplateBundleDummy"
        Transform {
          Location {
          }
          Rotation {
          }
          Scale {
            X: 1
            Y: 1
            Z: 1
          }
        }
        Folder {
          BundleDummy {
            ReferencedAssets {
              Id: 2115394716976713347
            }
            ReferencedAssets {
              Id: 1788586702711104432
            }
          }
        }
      }
    }
    Assets {
      Id: 1788586702711104432
      Name: "CommandParser"
      PlatformAssetType: 3
      TextAsset {
        Text: "local CommandParser = {\r\n\r\n\tpermissions = require(script:GetCustomProperty(\"CommandPermissions\")),\r\n\tdata = {},\r\n\tcommands = {},\r\n\tstorageKey = \"cmdp\",\r\n\r\n\terror = {\r\n\r\n\t\tINVALID = \"Invalid command.\",\r\n\t\tINVALID_SUB_COMMAND = \"Invalid sub command.\",\r\n\t\tINVALID_PLAYER = \"Invalid player.\",\r\n\t\tINVALID_PERMISSION = \"Invalid permission.\",\r\n\t\tNO_PERMISSION = \"You do not have permission.\",\r\n\t\tINVALID_COMMAND_DATA = \"Invalid command data.\",\r\n\t\tINVALID_VALUE = \"Invalid value.\"\r\n\r\n\t}\r\n}\r\n\r\nCommandParser.HasPermission = function(sender, permission)\r\n\tif not Object.IsValid(sender) or not sender:IsA(\"Player\") then\r\n\t\treturn false\r\n\tend\r\n\r\n\tfor k, p in pairs(CommandParser.permissions) do\r\n\t\tif p.names ~= nil then\r\n\t\t\tfor i, n in ipairs(p.names) do\r\n\t\t\t\tif n == sender.name then\r\n\t\t\t\t\treturn true\r\n\t\t\t\tend\r\n\t\t\tend\r\n\t\tend\r\n\tend\r\n\r\n\tif permission.priority ~= nil and sender:GetResource(CommandParser.storageKey) >= permission.priority then\r\n\t\treturn true\r\n\tend\r\n\r\n\treturn false\r\nend\r\n\r\nCommandParser.GetPlayer = function(receiver)\r\n\treceiver = CommandParser.ParamIsValid(receiver)\r\n\r\n\tif receiver == nil then\r\n\t\treturn nil\r\n\tend\r\n\r\n\tfor i, player in ipairs(Game.GetPlayers()) do\r\n\t\tif player.name == receiver then\r\n\t\t\treturn player\r\n\t\tend\r\n\tend\r\n\r\n\treturn nil\r\nend\r\n\r\nCommandParser.SetPermission = function(player, perm)\r\n\tperm = CommandParser.GetPermission(perm)\r\n\r\n\tif perm ~= nil and perm.priority ~= nil then\r\n\t\tlocal data = Storage.GetPlayerData(player)\r\n\r\n\t\tdata[CommandParser.storageKey] = perm.priority or 0\r\n\r\n\t\tplayer:SetResource(CommandParser.storageKey, perm.priority or 0)\r\n\t\tStorage.SetPlayerData(player, data)\r\n\r\n\t\treturn true\r\n\tend\r\n\r\n\treturn false\r\nend\r\n\r\nCommandParser.RemovePermission = function(player)\r\n\tlocal data = Storage.GetPlayerData(player)\r\n\r\n\tdata[CommandParser.storageKey] = 0\r\n\r\n\tplayer:SetResource(CommandParser.storageKey, 0)\r\n\tStorage.SetPlayerData(player, data)\r\n\r\n\treturn true\r\nend\r\n\r\nCommandParser.GetPermission = function(perm)\r\n\tperm = CommandParser.ParamIsValid(perm, true)\r\n\r\n\tfor k, p in pairs(CommandParser.permissions) do\r\n\t\tif string.lower(k) == perm then\r\n\t\t\treturn p\r\n\t\tend\r\n\tend\r\n\r\n\treturn nil\r\nend\r\n\r\nCommandParser.ParamIsValid = function(param, lower)\r\n\tif param ~= nil then\r\n\t\tparam = CoreString.Trim(tostring(param) or \"\")\r\n\r\n\t\tif string.len(param) > 0 then\r\n\t\t\tif lower then\r\n\t\t\t\tparam = string.lower(param)\r\n\t\t\tend\r\n\r\n\t\t\treturn param\r\n\t\tend\r\n\tend\r\n\r\n\treturn nil\r\nend\r\n\r\nCommandParser.GetPlayerPrefix = function(player)\r\n\tlocal prefix = \"\"\r\n\r\n\tif Environment.IsServer() then\r\n\t\tlocal data = Storage.GetPlayerData(player)\r\n\t\tlocal permPriority = data[CommandParser.storageKey] or 0\r\n\r\n\t\tfor k, p in pairs(CommandParser.permissions) do\r\n\t\t\tlocal hasPerm = false\r\n\r\n\t\t\tif p.names ~= nil then\r\n\t\t\t\tfor i, n in ipairs(p.names) do\r\n\t\t\t\t\tif n == player.name then\r\n\t\t\t\t\t\thasPerm = true\r\n\t\t\t\t\t\tprefix = \"[\" .. p.name .. \"]\"\r\n\t\t\t\t\t\tbreak\r\n\t\t\t\t\tend\r\n\t\t\t\tend\r\n\t\t\tend\r\n\r\n\t\t\tif not hasPerm and p.priority ~= nil and p.priority == permPriority then\r\n\t\t\t\tprefix = \"[\" .. p.name .. \"]\"\r\n\t\t\t\thasPerm = true\r\n\t\t\t\tbreak\r\n\t\t\tend\r\n\t\tend\r\n\tend\r\n\r\n\treturn prefix\r\nend\r\n\r\nCommandParser.ParseMessage = function(speaker, params)\r\n\tlocal message = params.message\r\n\tlocal prefix = CommandParser.GetPlayerPrefix(speaker)\r\n\r\n\tparams.speakerName = prefix .. params.speakerName\r\n\r\n\tif message:sub(1, 1) == \"/\" then\r\n\t\tlocal status = {\r\n\r\n\t\t\tsuccess = false,\r\n\t\t\tsenderMessage = \"\",\r\n\t\t\treceiverMessage = nil,\r\n\t\t\treceiverPlayer = nil\r\n\r\n\t\t}\r\n\r\n\t\tlocal tokens = { CoreString.Split(message:sub(2), \" \") }\r\n\t\tlocal command = CommandParser.ParamIsValid(tokens[1])\r\n\t\tlocal theCommand = CommandParser.commands[command]\r\n\r\n\t\tif theCommand ~= nil then\r\n\t\t\tparams.message = \"\"\r\n\t\t\t\r\n\t\t\tif type(theCommand) == \"table\" then\r\n\t\t\t\tlocal subCommand = CommandParser.ParamIsValid(tokens[2])\r\n\r\n\t\t\t\tif subCommand ~= nil and theCommand[subCommand] ~= nil then\r\n\t\t\t\t\ttheCommand = theCommand[subCommand]\r\n\t\t\t\tend\r\n\t\t\tend\r\n\r\n\t\t\tif theCommand ~= nil and type(theCommand) == \"function\" then\r\n\t\t\t\ttheCommand(speaker, tokens, status)\r\n\t\t\telse\r\n\t\t\t\tstatus.senderMessage = CommandParser.error.INVALID_SUB_COMMAND\r\n\t\t\tend\r\n\t\tend\r\n\t\t\t\r\n\t\tif string.len(status.senderMessage) > 0 then\r\n\t\t\tif Environment.IsServer() then\r\n\t\t\t\tChat.BroadcastMessage(status.senderMessage, { players = speaker })\r\n\t\t\telseif Environment.IsClient() then\r\n\t\t\t\tChat.LocalMessage(status.senderMessage)\r\n\t\t\tend\r\n\t\tend\r\n\r\n\t\tif status.success and status.receiverMessage ~= nil and Object.IsValid(status.receiverPlayer) and Environment.IsServer() then\r\n\t\t\tChat.BroadcastMessage(status.receiverMessage, { players = status.receiverPlayer })\r\n\t\tend\r\n\tend\r\nend\r\n\r\nCommandParser.ReceiveMessage = function(speaker, params)\r\n\tCommandParser.ParseMessage(speaker, params)\r\nend\r\n\r\nChat.receiveMessageHook:Connect(CommandParser.ReceiveMessage)\r\n\r\nCommandParser.AddCommandData = function(key, perk)\r\n\tCommandParser.data[key] = perk\r\nend\r\n\r\nCommandParser.GetCommandData = function(key)\r\n\treturn CommandParser.data[key]\r\nend\r\n\r\nCommandParser.AddCommand = function(key, command)\r\n\tCommandParser.commands[key] = command\r\nend\r\n\r\nCommandParser.AddResource = function(player, resourceKey, storageKey, amount)\r\n\tplayer:AddResource(resourceKey, amount or 0)\r\n\r\n\tif storageKey ~= nil then\r\n\t\tlocal playerData = Storage.GetPlayerData(player)\r\n\r\n\t\tif not playerData[storageKey] then\r\n\t\t\tplayerData[storageKey] = amount\r\n\t\telse\r\n\t\t\tplayerData[storageKey] = playerData[storageKey] + amount\r\n\t\tend\r\n\r\n\t\tStorage.SetPlayerData(player, playerData)\r\n\tend\r\nend\r\n\r\nCommandParser.SetResource = function(player, resourceKey, storageKey, amount)\r\n\tplayer:SetResource(resourceKey, amount or 0)\r\n\r\n\tif storageKey ~= nil then\r\n\t\tlocal playerData = Storage.GetPlayerData(player)\r\n\r\n\t\tif not playerData[storageKey] then\r\n\t\t\tplayerData[storageKey] = amount\r\n\t\telse\r\n\t\t\tplayerData[storageKey] = amount\r\n\t\tend\r\n\r\n\t\tStorage.SetPlayerData(player, playerData)\r\n\tend\r\nend\r\n\r\nCommandParser.RemoveResource = function(player, resourceKey, storageKey, amount)\r\n\tplayer:RemoveResource(resourceKey, amount or 0)\r\n\r\n\tif storageKey ~= nil then\r\n\t\tlocal playerData = Storage.GetPlayerData(player)\r\n\t\t\r\n\t\tif not playerData[storageKey] then\r\n\t\t\tplayerData[storageKey] = amount\r\n\t\telse\r\n\t\t\tplayerData[storageKey] = playerData[storageKey] - amount\r\n\t\tend\r\n\r\n\t\tStorage.SetPlayerData(player, playerData)\r\n\tend\r\nend\r\n\r\nCommandParser.init = function()\r\n\tif Environment.IsServer() then\r\n\t\tGame.playerJoinedEvent:Connect(function(player)\r\n\t\t\tlocal data = Storage.GetPlayerData(player)\r\n\r\n\t\t\tif data[CommandParser.storageKey] ~= nil then\r\n\t\t\t\tplayer:SetResource(CommandParser.storageKey, data[CommandParser.storageKey])\r\n\t\t\tend\r\n\t\tend)\r\n\tend\r\nend\r\n\r\nCommandParser.init()\r\n\r\n-- /promote player permission\r\nCommandParser.AddCommand(\"promote\", function(sender, params, status)\r\n\tif CommandParser.HasPermission(sender, CommandParser.permissions.CREATOR) then\r\n\t\tlocal promotePlayer = CommandParser.GetPlayer(params[2])\r\n\r\n\t\tif promotePlayer ~= nil then\r\n\t\t\tif CommandParser.SetPermission(promotePlayer, params[3]) then\r\n\t\t\t\tstatus.success = true\r\n\t\t\t\tstatus.senderMessage = promotePlayer.name .. \" was successfully promoted.\"\r\n\t\t\telse\r\n\t\t\t\tstatus.senderMessage = CommandParser.error.INVALID_PERMISSION\r\n\t\t\tend\r\n\t\telse\r\n\t\t\tstatus.senderMessage = CommandParser.error.INVALID_PLAYER\r\n\t\tend\r\n\telse\r\n\t\tstatus.senderMessage = CommandParser.error.NO_PERMISSION\r\n\tend\r\nend)\r\n\r\n-- /demote player\r\nCommandParser.AddCommand(\"demote\", function(sender, params, status)\r\n\tif CommandParser.HasPermission(sender, CommandParser.permissions.CREATOR) then\r\n\t\tlocal demotePlayer = CommandParser.GetPlayer(params[2])\r\n\r\n\t\tif demotePlayer ~= nil then\r\n\t\t\tCommandParser.RemovePermission(demotePlayer)\r\n\t\t\tstatus.success = true\r\n\t\t\tstatus.senderMessage = demotePlayer.name .. \" was successfully deomoted.\"\r\n\t\telse\r\n\t\t\tstatus.senderMessage = CommandParser.error.INVALID_PLAYER\r\n\t\tend\r\n\telse\r\n\t\tstatus.senderMessage = CommandParser.error.NO_PERMISSION\r\n\tend\r\nend)\r\n\r\nreturn CommandParser"
        CustomParameters {
          Overrides {
            Name: "cs:CommandPermissions"
            AssetReference {
              Id: 2115394716976713347
            }
          }
        }
      }
      DirectlyPublished: true
    }
    Assets {
      Id: 2115394716976713347
      Name: "CommandPermissions"
      PlatformAssetType: 3
      TextAsset {
        Text: "local Permissions = {\r\n\r\n\t-- Local preview / mp add Bot1\r\n\t\r\n\tCREATOR = {\r\n\r\n\t\tnames = { \"CommanderFoo\" },\r\n\t\tname = \"Creator\"\r\n\r\n\t},\r\n\r\n\tADMIN = {\r\n\r\n\t\tpriority = 50,\r\n\t\tname = \"Admin\"\r\n\r\n\t},\r\n\r\n\tMODERATOR = {\r\n\r\n\t\tpriority = 30,\r\n\t\tname = \"Moderator\"\r\n\r\n\t}\r\n\r\n}\r\n\r\n-- Add Bot1 if the game is local for testing local\r\n-- multiplayer preview.\r\nif Environment.IsLocalGame() then\r\n\ttable.insert(Permissions.CREATOR.names, \"Bot1\")\r\nend\r\n\r\nreturn Permissions"
      }
      DirectlyPublished: true
    }
    PrimaryAssetId {
      AssetType: "None"
      AssetId: "None"
    }
  }
  Marketplace {
    Id: "25f4ec5a82dd4b299a0119b5e40cecdf"
    OwnerAccountId: "93d6eaf2514940a08c5481a4c03c1ee3"
    OwnerName: "CommanderFoo"
  }
  SerializationVersion: 101
}
IncludesAllDependencies: true

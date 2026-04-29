local function isConfigured()
  return SunBotConfig
    and SunBotConfig.ApiUrl
    and SunBotConfig.ApiUrl ~= ""
    and SunBotConfig.ApiKey
    and SunBotConfig.ApiKey ~= ""
    and SunBotConfig.ApiKey ~= "CHANGE_ME"
end

local function safeDecode(value)
  local ok, result = pcall(function()
    return json.decode(value or "{}")
  end)

  if not ok then
    print("[SunBot] Invalid JSON response from panel.")
    return nil
  end

  return result
end

local function postJson(url, payload, callback)
  if not isConfigured() then
    print("[SunBot] Bridge not configured. Set SunBotConfig.ApiKey in config.lua.")
    callback(0, nil)
    return
  end

  PerformHttpRequest(url, function(statusCode, response)
    callback(statusCode, response)
  end, "POST", json.encode(payload or {}), {
    ["Content-Type"] = "application/json",
    ["x-sunbot-key"] = SunBotConfig.ApiKey
  })
end

local function sendHeartbeat()
  postJson(SunBotConfig.ApiUrl .. "/heartbeat", {
    players = #GetPlayers(),
    framework = SunBotConfig.Framework or "standalone",
    endpoint = GetConvar("sv_hostname", "")
  }, function(statusCode, _)
    if statusCode ~= 200 then
      print("[SunBot] Heartbeat failed with status " .. tostring(statusCode))
    end
  end)
end

local function ackCommand(commandId, success, message)
  postJson(SunBotConfig.ApiUrl .. "/commands/ack", {
    id = commandId,
    success = success,
    response = message
  }, function(statusCode, _)
    if statusCode ~= 200 then
      print("[SunBot] Command ack failed with status " .. tostring(statusCode))
    end
  end)
end

local function executeSunBotCommand(command)
  local payload = command.payload or {}
  local args = payload.args or {}

  if command.name == "announce" then
    TriggerClientEvent("chat:addMessage", -1, {
      args = { "SunBot", args.message or "Annonce serveur" }
    })
    return true, "Annonce envoyee"
  end

  if command.name == "custom" then
    print("[SunBot] Custom payload received: " .. json.encode(args))
    return true, "Payload custom recu"
  end

  if command.name == "revive" then
    return false, "Hook revive a implementer selon le framework"
  end

  if command.name == "setjob" then
    return false, "Hook setjob a implementer selon le framework"
  end

  if command.name == "additem" then
    return false, "Hook additem a implementer selon le framework"
  end

  return false, "Commande inconnue"
end

local function pollCommands()
  postJson(SunBotConfig.ApiUrl .. "/commands/pull", {}, function(statusCode, response)
    if statusCode ~= 200 then
      return
    end

    local parsed = safeDecode(response)
    local command = parsed and parsed.command or nil

    if not command or not command.id then
      return
    end

    print("[SunBot] Command received: " .. tostring(command.name))

    local success, message = executeSunBotCommand(command)
    ackCommand(command.id, success, message)
  end)
end

CreateThread(function()
  while true do
    sendHeartbeat()
    Wait(30000)
  end
end)

CreateThread(function()
  while true do
    pollCommands()
    Wait(5000)
  end
end)

RegisterCommand("sunbot_test", function(source)
  print("[SunBot] Resource active.")
end, false)

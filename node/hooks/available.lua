local http = require("http")
local json = require("json")

local BASE_URL = os.getenv("SDK_NODE_MIRROR") or "https://nodejs.org/dist"

function PLUGIN:Available(ctx)
    local resp, err = http.get({ url = BASE_URL .. "/index.json" })
    if err ~= nil then
        error("Failed to fetch Node.js versions: " .. tostring(err))
    end
    if resp.status_code ~= 200 then
        error("HTTP " .. resp.status_code .. " from " .. BASE_URL)
    end

    local data = json.decode(resp.body)
    local result = {}

    for _, item in ipairs(data) do
        local version = item.version:gsub("^v", "")
        local note = ""
        if item.lts and item.lts ~= false then
            note = "LTS (" .. tostring(item.lts) .. ")"
        end
        table.insert(result, { version = version, note = note })
    end

    return result
end

local http = require("http")
local json = require("json")

local DL_URL = os.getenv("SDK_GO_MIRROR") or "https://go.dev"

function PLUGIN:Available(ctx)
    local resp, err = http.get({ url = DL_URL .. "/dl/?mode=json&include=all" })
    if err ~= nil then
        error("Failed to fetch Go versions: " .. tostring(err))
    end
    if resp.status_code ~= 200 then
        error("HTTP " .. resp.status_code)
    end

    local data = json.decode(resp.body)
    local result = {}

    for _, item in ipairs(data) do
        if item.stable then
            local version = item.version:gsub("^go", "")
            table.insert(result, { version = version })
        end
    end

    return result
end

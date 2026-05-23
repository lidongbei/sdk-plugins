local http = require("http")
local json = require("json")

local DL_URL = os.getenv("SDK_GO_MIRROR") or "https://go.dev"

local function is_local(path)
    return path:sub(1, 4) ~= "http"
end

function PLUGIN:Available(ctx)
    local result = {}

    if is_local(DL_URL) then
        -- Local mirror: read versions.json (simple array of version strings)
        -- e.g. ["1.22.0", "1.21.5", "1.20.14"]
        local resp, err = http.get({ url = DL_URL .. "/versions.json" })
        if err ~= nil then
            error("Failed to read local Go versions: " .. tostring(err))
        end
        if resp.status_code ~= 200 then
            error("versions.json not found at " .. DL_URL)
        end
        local data = json.decode(resp.body)
        for _, ver in ipairs(data) do
            table.insert(result, { version = tostring(ver) })
        end
        return result
    end

    local resp, err = http.get({ url = DL_URL .. "/dl/?mode=json&include=all" })
    if err ~= nil then
        error("Failed to fetch Go versions: " .. tostring(err))
    end
    if resp.status_code ~= 200 then
        error("HTTP " .. resp.status_code)
    end

    local data = json.decode(resp.body)

    for _, item in ipairs(data) do
        if item.stable then
            local version = item.version:gsub("^go", "")
            table.insert(result, { version = version })
        end
    end

    return result
end

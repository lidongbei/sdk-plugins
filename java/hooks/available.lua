local http = require("http")
local json = require("json")

-- Adoptium API for Eclipse Temurin builds
-- Override with: export SDK_JAVA_MIRROR=https://my-mirror/adoptium
local API_URL = os.getenv("SDK_JAVA_API") or "https://api.adoptium.net/v3"

function PLUGIN:Available(ctx)
    local result = {}
    -- Fetch LTS versions first (8, 11, 17, 21)
    local lts_versions = {"8", "11", "17", "21"}
    local all_versions = {}

    -- Get list of available feature versions
    local resp, err = http.get({ url = API_URL .. "/info/available_releases" })
    if err ~= nil then
        error("Failed to fetch Java releases: " .. tostring(err))
    end
    if resp.status_code ~= 200 then
        error("HTTP " .. resp.status_code)
    end

    local data = json.decode(resp.body)
    -- available_releases is array of feature versions (integers)
    for _, ver in ipairs(data.available_releases or {}) do
        table.insert(all_versions, tostring(ver))
    end

    -- Sort descending
    table.sort(all_versions, function(a, b)
        return tonumber(a) > tonumber(b)
    end)

    for _, feature_ver in ipairs(all_versions) do
        local is_lts = false
        for _, lts in ipairs(lts_versions) do
            if lts == feature_ver then is_lts = true; break end
        end
        table.insert(result, {
            version = feature_ver,
            note = is_lts and "LTS" or ""
        })
    end

    return result
end

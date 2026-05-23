local http = require("http")
local json = require("json")

-- Source: adoptium (default) | oracle | zulu
local SOURCE  = os.getenv("SDK_JAVA_SOURCE") or "adoptium"
local API_URL = os.getenv("SDK_JAVA_API")    or "https://api.adoptium.net/v3"

-- Oracle JDK: no public JSON API; maintain static list of current LTS/GA releases.
-- Oracle only hosts "latest" downloads for actively supported versions.
local ORACLE_VERSIONS = {
    { version = "25", note = "LTS" },
    { version = "21", note = "LTS" },
}

-- Standard Java LTS versions (used for Zulu LTS annotation)
local JAVA_LTS = { ["8"]=true, ["11"]=true, ["17"]=true, ["21"]=true, ["25"]=true }

function PLUGIN:Available(ctx)
    -- Oracle JDK source: return static curated version list
    if SOURCE == "oracle" then
        return ORACLE_VERSIONS
    end

    -- Azul Zulu: query metadata API for all available major versions
    if SOURCE == "zulu" then
        local zulu_api = API_URL or "https://api.azul.com/metadata/v1"
        local url = zulu_api .. "/zulu/packages/?java_package_type=jdk&archive_type=tar.gz&latest=true&page_size=200"
        local resp, err = http.get({ url = url })
        if err ~= nil then
            error("Failed to fetch Zulu releases: " .. tostring(err))
        end
        if resp.status_code ~= 200 then
            error("Zulu API HTTP " .. resp.status_code)
        end
        local data = json.decode(resp.body)
        local seen = {}
        local result = {}
        for _, pkg in ipairs(data) do
            local major = tostring(pkg.java_version[1])
            if not seen[major] then
                seen[major] = true
                table.insert(result, { version = major, note = JAVA_LTS[major] and "LTS" or "" })
            end
        end
        table.sort(result, function(a, b) return tonumber(a.version) > tonumber(b.version) end)
        return result
    end

    -- Adoptium / Temurin source (default)
    local result = {}
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
    local lts_set = {}
    for _, v in ipairs(data.available_lts_releases or {}) do
        lts_set[tostring(v)] = true
    end

    -- available_releases is array of feature versions (integers)
    for _, ver in ipairs(data.available_releases or {}) do
        table.insert(all_versions, tostring(ver))
    end

    -- Sort descending
    table.sort(all_versions, function(a, b)
        return tonumber(a) > tonumber(b)
    end)

    for _, feature_ver in ipairs(all_versions) do
        table.insert(result, {
            version = feature_ver,
            note = lts_set[feature_ver] and "LTS" or ""
        })
    end

    return result
end

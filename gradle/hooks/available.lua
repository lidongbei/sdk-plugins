local http = require("http")
local json = require("json")

-- Gradle releases API
-- Online: SDK_GRADLE_API = "https://services.gradle.org/versions/all"
-- Local:  SDK_GRADLE_API = "/path/to/mirror/gradle"  (reads versions.json)
local API_URL = os.getenv("SDK_GRADLE_API") or "https://services.gradle.org/versions/all"

local function is_local(url)
    return url:sub(1, 4) ~= "http" or os.getenv("SDK_FLAT_MIRROR") == "1"
end

function PLUGIN:Available(ctx)
    local result = {}

    if is_local(API_URL) then
        -- Local mirror: read versions.json (simple array of version strings)
        local resp, err = http.get({ url = API_URL .. "/versions.json" })
        if err ~= nil then
            error("Failed to read local Gradle versions: " .. tostring(err))
        end
        if resp.status_code ~= 200 then
            error("versions.json not found at " .. API_URL)
        end
        local data = json.decode(resp.body)
        for _, ver in ipairs(data) do
            table.insert(result, { version = tostring(ver) })
        end
        return result
    end

    -- Online: use services.gradle.org JSON API
    local resp, err = http.get({ url = API_URL })
    if err ~= nil then
        error("Failed to fetch Gradle versions: " .. tostring(err))
    end
    if resp.status_code ~= 200 then
        error("HTTP " .. resp.status_code)
    end

    local data = json.decode(resp.body)
    local seen = {}

    for _, item in ipairs(data) do
        if not item.snapshot and not item.nightly and not item.releaseNightly then
            local ver = item.version
            if ver and not seen[ver] then
                seen[ver] = true
                local note = (item.rcFor and item.rcFor ~= "") and ("RC for " .. item.rcFor) or ""
                table.insert(result, { version = ver, note = note })
            end
        end
    end

    return result
end

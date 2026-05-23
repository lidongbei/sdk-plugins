local http = require("http")
local json = require("json")

-- Gradle releases API
-- Override: export SDK_GRADLE_MIRROR=https://my-mirror/gradle
local API_URL = os.getenv("SDK_GRADLE_API") or "https://services.gradle.org/versions/all"

function PLUGIN:Available(ctx)
    local resp, err = http.get({ url = API_URL })
    if err ~= nil then
        error("Failed to fetch Gradle versions: " .. tostring(err))
    end
    if resp.status_code ~= 200 then
        error("HTTP " .. resp.status_code)
    end

    local data = json.decode(resp.body)
    local result = {}
    local seen = {}

    for _, item in ipairs(data) do
        -- Skip RC, milestone releases unless we want them
        if not item.snapshot and not item.nightly and not item.releaseNightly then
            local ver = item.version
            if ver and not seen[ver] then
                seen[ver] = true
                local note = item.rcFor ~= "" and ("RC for " .. item.rcFor) or ""
                table.insert(result, { version = ver, note = note })
            end
        end
    end

    return result
end

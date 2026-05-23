local http = require("http")
local html = require("html")

-- Maven release index
-- Override: export SDK_MAVEN_MIRROR=https://my-mirror/maven
local REPO_URL = os.getenv("SDK_MAVEN_MIRROR") or "https://archive.apache.org/dist/maven/maven-3"

function PLUGIN:Available(ctx)
    -- Fetch Apache archive directory listing
    local resp, err = http.get({ url = REPO_URL .. "/" })
    if err ~= nil then
        error("Failed to fetch Maven versions: " .. tostring(err))
    end
    if resp.status_code ~= 200 then
        error("HTTP " .. resp.status_code)
    end

    local doc = html.parse(resp.body)
    local result = {}
    local seen = {}

    doc:find("a"):each(function(_, el)
        local href = el:attr("href")
        if href then
            local ver = href:match("^(%d+%.%d+%.%d+)/?$")
            if ver and not seen[ver] then
                seen[ver] = true
                table.insert(result, { version = ver })
            end
        end
    end)

    -- Sort descending
    table.sort(result, function(a, b)
        return a.version > b.version
    end)

    return result
end

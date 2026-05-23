local http = require("http")
local html = require("html")

local BASE_URL = os.getenv("SDK_PYTHON_MIRROR") or "https://www.python.org"

function PLUGIN:Available(ctx)
    local resp, err = http.get({ url = BASE_URL .. "/ftp/python/" })
    if err ~= nil then
        error("Failed to fetch Python versions: " .. tostring(err))
    end
    if resp.status_code ~= 200 then
        error("HTTP " .. resp.status_code)
    end

    local doc = html.parse(resp.body)
    local result = {}
    local seen = {}

    -- Parse links like: 3.12.0/ or 3.11.5/
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

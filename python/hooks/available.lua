local http = require("http")
local html = require("html")
local json = require("json")

local BASE_URL = os.getenv("SDK_PYTHON_MIRROR") or "https://www.python.org"

local function is_flat(path)
    -- Use flat file structure when: local filesystem path OR http-server profile
    return path:sub(1, 4) ~= "http" or os.getenv("SDK_PYTHON_FLAT") == "1"
end

function PLUGIN:Available(ctx)
    local result = {}

    if is_flat(BASE_URL) then
        -- Local mirror: read versions.json (simple array of version strings)
        -- e.g. ["3.12.0", "3.11.5", "3.10.13"]
        local resp, err = http.get({ url = BASE_URL .. "/versions.json" })
        if err ~= nil then
            error("Failed to read local Python versions: " .. tostring(err))
        end
        if resp.status_code ~= 200 then
            error("versions.json not found at " .. BASE_URL)
        end
        local data = json.decode(resp.body)
        for _, ver in ipairs(data) do
            table.insert(result, { version = tostring(ver) })
        end
        return result
    end

    local resp, err = http.get({ url = BASE_URL .. "/ftp/python/" })
    if err ~= nil then
        error("Failed to fetch Python versions: " .. tostring(err))
    end
    if resp.status_code ~= 200 then
        error("HTTP " .. resp.status_code)
    end

    local doc = html.parse(resp.body)
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

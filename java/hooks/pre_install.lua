local http = require("http")
local json = require("json")

local API_URL    = os.getenv("SDK_JAVA_API")    or "https://api.adoptium.net/v3"
local MIRROR_URL = os.getenv("SDK_JAVA_MIRROR") or ""

local function is_flat(path)
    -- Use flat file structure when: local filesystem path OR http-server profile
    return path:sub(1, 4) ~= "http" or os.getenv("SDK_JAVA_FLAT") == "1"
end

function PLUGIN:PreInstall(ctx)
    local feature_version = ctx.version
    local os_type = OS_TYPE
    local arch    = ARCH_TYPE

    local os_name
    if os_type == "darwin" then
        os_name = "mac"
    elseif os_type == "linux" then
        os_name = "linux"
    elseif os_type == "windows" then
        os_name = "windows"
    else
        error("Unsupported OS: " .. tostring(os_type))
    end

    local arch_name
    if arch == "amd64" then
        arch_name = "x64"
    elseif arch == "arm64" then
        arch_name = "aarch64"
    else
        error("Unsupported arch: " .. tostring(arch))
    end

    -- flat mirror (local / http-server): download from pre-built flat dir
    if MIRROR_URL ~= "" and is_flat(MIRROR_URL) then
        local ext = (os_type == "windows") and "zip" or "tar.gz"
        local filename = string.format(
            "OpenJDK%sU-jdk_%s_%s_hotspot_latest.%s",
            feature_version, arch_name, os_name, ext
        )
        return {
            version = feature_version,
            url     = MIRROR_URL .. "/" .. filename,
        }
    end

    -- Use Adoptium API to find the exact download URL / filename
    local api_url = string.format(
        "%s/assets/latest/%s/hotspot?architecture=%s&image_type=jdk&jvm_impl=hotspot&os=%s&vendor=eclipse",
        API_URL, feature_version, arch_name, os_name
    )
    local resp, err = http.get({ url = api_url })
    if err ~= nil then
        error("Failed to query Adoptium API: " .. tostring(err))
    end
    if resp.status_code ~= 200 then
        error("Adoptium API returned HTTP " .. resp.status_code)
    end

    local data = json.decode(resp.body)
    if not data or #data == 0 then
        error("No release found for Java " .. feature_version)
    end

    local pkg      = data[1].binary.package
    local filename = pkg.name   -- e.g. OpenJDK21U-jdk_x64_linux_hotspot_21.0.11_10.tar.gz

    local url
    if MIRROR_URL ~= "" then
        -- Hierarchical HTTP mirror (e.g. Tsinghua): {mirror}/{version}/jdk/{arch}/{os}/{filename}
        url = string.format("%s/%s/jdk/%s/%s/%s",
            MIRROR_URL, feature_version, arch_name, os_name, filename)
    else
        url = pkg.link
    end

    return {
        version = feature_version,
        url     = url,
    }
end

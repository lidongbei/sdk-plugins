local http = require("http")
local json = require("json")

local API_URL = os.getenv("SDK_JAVA_API") or "https://api.adoptium.net/v3"
local MIRROR_URL = os.getenv("SDK_JAVA_MIRROR") or ""

local function is_local(path)
    return path:sub(1, 4) ~= "http"
end

function PLUGIN:PreInstall(ctx)
    local feature_version = ctx.version
    local os_type = OS_TYPE
    local arch = ARCH_TYPE

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

    local ext
    if os_type == "windows" then
        ext = "zip"
    else
        ext = "tar.gz"
    end

    -- Build Adoptium binary download URL
    local url = string.format(
        "%s/binary/latest/%s/ga/%s/%s/jdk/hotspot/normal/eclipse?project=jdk",
        API_URL, feature_version, os_name, arch_name
    )

    -- If custom mirror is set, use it directly
    if MIRROR_URL ~= "" then
        local filename = string.format(
            "OpenJDK%sU-jdk_%s_%s_hotspot_latest.%s",
            feature_version, arch_name, os_name, ext
        )
        if is_local(MIRROR_URL) then
            -- Local mirror: flat structure
            url = MIRROR_URL .. "/" .. filename
        else
            url = string.format("%s/%s/%s", MIRROR_URL, feature_version, filename)
        end
    end

    return {
        version = feature_version,
        url = url,
    }
end

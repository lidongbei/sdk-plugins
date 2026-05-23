local BASE_URL = os.getenv("SDK_PYTHON_MIRROR") or "https://www.python.org"

local function is_flat(path)
    -- Use flat file structure when: local filesystem path OR http-server profile
    return path:sub(1, 4) ~= "http" or os.getenv("SDK_PYTHON_FLAT") == "1"
end

function PLUGIN:PreInstall(ctx)
    local version = ctx.version
    local os_type = OS_TYPE
    local arch = ARCH_TYPE

    if os_type == "linux" then
        local standalone_base = os.getenv("SDK_PYTHON_STANDALONE_MIRROR")
            or "https://github.com/astral-sh/python-build-standalone/releases/download"

        local arch_name
        if arch == "amd64" then
            arch_name = "x86_64"
        elseif arch == "arm64" then
            arch_name = "aarch64"
        else
            error("Unsupported arch: " .. tostring(arch))
        end

        local tag = os.getenv("SDK_PYTHON_STANDALONE_TAG") or "20240107"
        local filename = string.format(
            "cpython-%s+%s-%s-unknown-linux-gnu-install_only.tar.gz",
            version, tag, arch_name
        )

        local url
        if is_flat(standalone_base) then
            -- Local mirror: flat structure
            url = standalone_base .. "/" .. filename
        else
            url = string.format("%s/%s/%s", standalone_base, tag, filename)
        end
        return { version = version, url = url }

    elseif os_type == "darwin" then
        local arch_name = (arch == "arm64") and "aarch64" or "x86_64"
        local tag = os.getenv("SDK_PYTHON_STANDALONE_TAG") or "20240107"
        local filename = string.format(
            "cpython-%s+%s-%s-apple-darwin-install_only.tar.gz",
            version, tag, arch_name
        )
        local standalone_base = os.getenv("SDK_PYTHON_STANDALONE_MIRROR")
            or "https://github.com/astral-sh/python-build-standalone/releases/download"

        local url
        if is_flat(standalone_base) then
            url = standalone_base .. "/" .. filename
        else
            url = string.format("%s/%s/%s", standalone_base, tag, filename)
        end
        return { version = version, url = url }

    elseif os_type == "windows" then
        local arch_name = (arch == "amd64") and "amd64" or "win32"
        local filename = string.format("python-%s-embed-%s.zip", version, arch_name)

        local url
        if is_flat(BASE_URL) then
            -- Local mirror: flat structure
            url = BASE_URL .. "/" .. filename
        else
            url = string.format("%s/ftp/python/%s/%s", BASE_URL, version, filename)
        end
        return { version = version, url = url }
    else
        error("Unsupported OS: " .. tostring(os_type))
    end
end

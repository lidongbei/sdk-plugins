local REPO_URL = os.getenv("SDK_MAVEN_MIRROR") or "https://archive.apache.org/dist/maven/maven-3"

local function is_local(path)
    return path:sub(1, 4) ~= "http"
end

function PLUGIN:PreInstall(ctx)
    local version = ctx.version

    local filename
    local url
    if OS_TYPE == "windows" then
        filename = string.format("apache-maven-%s-bin.zip", version)
    else
        filename = string.format("apache-maven-%s-bin.tar.gz", version)
    end

    if is_local(REPO_URL) then
        -- Local mirror: flat structure — files stored directly as <base>/<filename>
        url = REPO_URL .. "/" .. filename
    else
        -- e.g. https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
        url = string.format("%s/%s/binaries/%s", REPO_URL, version, filename)
    end

    return {
        version = version,
        url = url,
    }
end

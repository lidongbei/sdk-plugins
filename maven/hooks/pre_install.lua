local REPO_URL = os.getenv("SDK_MAVEN_MIRROR") or "https://archive.apache.org/dist/maven/maven-3"

function PLUGIN:PreInstall(ctx)
    local version = ctx.version
    -- e.g. https://archive.apache.org/dist/maven/maven-3/3.9.6/binaries/apache-maven-3.9.6-bin.tar.gz
    local filename = string.format("apache-maven-%s-bin.tar.gz", version)
    local url = string.format("%s/%s/binaries/%s", REPO_URL, version, filename)

    if OS_TYPE == "windows" then
        filename = string.format("apache-maven-%s-bin.zip", version)
        url = string.format("%s/%s/binaries/%s", REPO_URL, version, filename)
    end

    return {
        version = version,
        url = url,
    }
end

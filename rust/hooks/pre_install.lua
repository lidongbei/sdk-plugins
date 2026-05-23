-- Rust installs via rustup, which downloads the toolchain itself
-- This hook provides the rustup-init download URL

local BASE_URL = os.getenv("SDK_RUSTUP_MIRROR") or "https://static.rust-lang.org"
-- For Chinese users: export SDK_RUSTUP_MIRROR=https://rsproxy.cn
-- and set: export RUSTUP_DIST_SERVER=https://rsproxy.cn
--           export RUSTUP_UPDATE_ROOT=https://rsproxy.cn/rustup

function PLUGIN:PreInstall(ctx)
    local version = ctx.version  -- "stable", "beta", "nightly", or "1.75.0"
    local os_type = OS_TYPE
    local arch = ARCH_TYPE

    if os_type == "windows" then
        -- Windows: download rustup-init.exe and run it
        local arch_name = (arch == "amd64") and "x86_64" or "i686"
        local url = string.format(
            "%s/rustup/dist/%s-pc-windows-msvc/rustup-init.exe",
            BASE_URL, arch_name
        )
        return { version = version, url = url }
    else
        local os_name = (os_type == "darwin") and "apple-darwin" or "unknown-linux-gnu"
        local arch_name = (arch == "arm64") and "aarch64" or "x86_64"
        local target = string.format("%s-%s", arch_name, os_name)
        local url = string.format(
            "%s/rustup/dist/%s/rustup-init",
            BASE_URL, target
        )
        return { version = version, url = url }
    end
end

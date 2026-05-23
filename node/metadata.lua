PLUGIN = {
    name = "node",
    version = "1.0.0",
    description = "Node.js JavaScript runtime",
    updateUrl = "https://raw.githubusercontent.com/lidongbei/sdk-plugins/main/node/metadata.lua",
    homepage = "https://nodejs.org",
    minRuntimeVersion = "0.3.0",
    legacyFilenames = {".nvmrc", ".node-version"},

    -- Mirror profiles: switch with `sdk mirror use <profile> [node]`
    mirrors = {
        {
            name = "default",
            description = "Official (nodejs.org)",
            vars = { SDK_NODE_MIRROR = "https://nodejs.org/dist" }
        },
        {
            name = "china",
            description = "npmmirror CDN (China)",
            vars = { SDK_NODE_MIRROR = "https://registry.npmmirror.com/mirrors/node" }
        },
        {
            name = "tencent",
            description = "Tencent Cloud mirror",
            vars = { SDK_NODE_MIRROR = "https://mirrors.cloud.tencent.com/nodejs-release" }
        },
        {
            name = "huawei",
            description = "Huawei Cloud mirror",
            vars = { SDK_NODE_MIRROR = "https://mirrors.huaweicloud.com/nodejs" }
        },
        {
            name = "local",
            description = "Local file system mirror (/opt/sdk-mirror/node)",
            vars = { SDK_NODE_MIRROR = "/opt/sdk-mirror/node" }
        },
    }
}

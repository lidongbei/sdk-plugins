PLUGIN = {
    name = "go",
    version = "1.0.0",
    description = "Go programming language",
    updateUrl = "https://raw.githubusercontent.com/lidongbei/sdk-plugins/main/go/metadata.lua",
    homepage = "https://go.dev",
    minRuntimeVersion = "0.3.0",
    legacyFilenames = {".go-version"},

    mirrors = {
        {
            name = "default",
            description = "Official (go.dev)",
            vars = { SDK_GO_MIRROR = "https://go.dev" }
        },
        {
            name = "china",
            description = "GoLang China mirror (golang.google.cn)",
            vars = { SDK_GO_MIRROR = "https://golang.google.cn" }
        },
        {
            name = "aliyun",
            description = "Aliyun mirror",
            vars = { SDK_GO_MIRROR = "https://mirrors.aliyun.com/golang" }
        },
        {
            name = "ustc",
            description = "USTC mirror",
            vars = { SDK_GO_MIRROR = "https://mirrors.ustc.edu.cn/golang" }
        },
        {
            name = "local",
            description = "Local file system mirror (mirror.local_dir/go)",
            vars = { SDK_GO_MIRROR = "{local_dir}/go" }
        },
        {
            name = "http-server",
            description = "Local HTTP mirror server (mirror.http_server/go)",
            vars = {
                SDK_GO_MIRROR   = "{http_server}/go",
                SDK_FLAT_MIRROR = "1"
            }
        },
    }
}

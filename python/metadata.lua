PLUGIN = {
    name = "python",
    version = "1.0.0",
    description = "Python programming language",
    updateUrl = "https://raw.githubusercontent.com/lidongbei/sdk-plugins/main/python/metadata.lua",
    homepage = "https://www.python.org",
    minRuntimeVersion = "0.3.0",
    legacyFilenames = {".python-version"},

    -- Mirror profiles for python-build-standalone binaries
    mirrors = {
        {
            name = "default",
            description = "Official (python.org + GitHub releases)",
            vars = {
                SDK_PYTHON_MIRROR           = "https://www.python.org",
                SDK_PYTHON_STANDALONE_MIRROR = "https://github.com/astral-sh/python-build-standalone/releases/download"
            }
        },
        {
            name = "china",
            description = "npmmirror CDN (China) + GitHub proxy",
            vars = {
                SDK_PYTHON_MIRROR           = "https://registry.npmmirror.com/mirrors/python",
                SDK_PYTHON_STANDALONE_MIRROR = "https://ghfast.top/https://github.com/astral-sh/python-build-standalone/releases/download"
            }
        },
        {
            name = "huawei",
            description = "Huawei Cloud mirror",
            vars = {
                SDK_PYTHON_MIRROR           = "https://mirrors.huaweicloud.com/python",
                SDK_PYTHON_STANDALONE_MIRROR = "https://ghfast.top/https://github.com/astral-sh/python-build-standalone/releases/download"
            }
        },
        {
            name = "local",
            description = "Local file system mirror (mirror.local_dir/python)",
            vars = {
                SDK_PYTHON_MIRROR           = "{local_dir}/python",
                SDK_PYTHON_STANDALONE_MIRROR = "{local_dir}/python-standalone"
            }
        },
        {
            name = "http-server",
            description = "Local HTTP mirror server (mirror.http_server/python)",
            vars = {
                SDK_PYTHON_MIRROR            = "{http_server}/python",
                SDK_PYTHON_STANDALONE_MIRROR = "{http_server}/python-standalone",
                SDK_FLAT_MIRROR              = "1"
            }
        },
    }
}

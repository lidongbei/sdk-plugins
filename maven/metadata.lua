PLUGIN = {
    name = "maven",
    version = "1.0.0",
    description = "Apache Maven build tool",
    updateUrl = "https://raw.githubusercontent.com/lidongbei/sdk-plugins/main/maven/metadata.lua",
    homepage = "https://maven.apache.org",
    minRuntimeVersion = "0.3.0",
    legacyFilenames = {".mvn-version"},

    mirrors = {
        {
            name = "default",
            description = "Apache Archive (archive.apache.org)",
            vars = { SDK_MAVEN_MIRROR = "https://archive.apache.org/dist/maven/maven-3" }
        },
        {
            name = "china",
            description = "Aliyun Apache mirror",
            vars = { SDK_MAVEN_MIRROR = "https://mirrors.aliyun.com/apache/maven/maven-3" }
        },
        {
            name = "tencent",
            description = "Tencent Cloud Apache mirror",
            vars = { SDK_MAVEN_MIRROR = "https://mirrors.cloud.tencent.com/apache/maven/maven-3" }
        },
        {
            name = "huawei",
            description = "Huawei Cloud Apache mirror",
            vars = { SDK_MAVEN_MIRROR = "https://mirrors.huaweicloud.com/apache/maven/maven-3" }
        },
        {
            name = "local",
            description = "Local file system mirror (mirror.local_dir/maven)",
            vars = { SDK_MAVEN_MIRROR = "{local_dir}/maven" }
        },
    }
}

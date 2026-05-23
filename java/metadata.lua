PLUGIN = {
    name = "java",
    version = "1.0.0",
    description = "Java (Eclipse Temurin / OpenJDK)",
    updateUrl = "https://raw.githubusercontent.com/lidongbei/sdk-plugins/main/java/metadata.lua",
    homepage = "https://adoptium.net",
    minRuntimeVersion = "0.3.0",
    legacyFilenames = {".java-version"},

    mirrors = {
        {
            name = "default",
            description = "Official Adoptium API (adoptium.net)",
            vars = {
                SDK_JAVA_API    = "https://api.adoptium.net/v3",
                SDK_JAVA_MIRROR = ""
            }
        },
        {
            name = "china",
            description = "QingHua mirror",
            vars = {
                SDK_JAVA_API    = "https://api.adoptium.net/v3",
                SDK_JAVA_MIRROR = "https://mirrors.tuna.tsinghua.edu.cn/Adoptium"
            }
        },
        {
            name = "local",
            description = "Local file system mirror (mirror.local_dir/java)",
            vars = {
                SDK_JAVA_API    = "https://api.adoptium.net/v3",
                SDK_JAVA_MIRROR = "{local_dir}/java"
            }
        },
        {
            name = "http-server",
            description = "Local HTTP mirror server (mirror.http_server/java)",
            vars = {
                SDK_JAVA_API    = "https://api.adoptium.net/v3",
                SDK_JAVA_MIRROR = "{http_server}/java",
                SDK_JAVA_FLAT = "1"
            }
        },
    }
}

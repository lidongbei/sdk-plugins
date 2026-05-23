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
            description = "Huawei Cloud Temurin mirror",
            vars = {
                SDK_JAVA_API    = "https://api.adoptium.net/v3",
                SDK_JAVA_MIRROR = "https://mirrors.huaweicloud.com/java/jdk"
            }
        },
        {
            name = "tencent",
            description = "Tencent Cloud Temurin mirror",
            vars = {
                SDK_JAVA_API    = "https://api.adoptium.net/v3",
                SDK_JAVA_MIRROR = "https://mirrors.cloud.tencent.com/AdoptOpenJDK"
            }
        },
        {
            name = "local",
            description = "Local HTTP mirror",
            vars = {
                SDK_JAVA_API    = "http://localhost:8080/adoptium/v3",
                SDK_JAVA_MIRROR = "http://localhost:8080/java"
            }
        },
    }
}

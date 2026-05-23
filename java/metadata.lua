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
                SDK_JAVA_SOURCE = "adoptium",
                SDK_JAVA_API    = "https://api.adoptium.net/v3",
                SDK_JAVA_MIRROR = ""
            }
        },
        {
            name = "oracle",
            description = "Oracle JDK (download.oracle.com) — LTS versions 21 & 25, NFTC license",
            vars = {
                SDK_JAVA_SOURCE = "oracle",
                SDK_JAVA_API    = "",
                SDK_JAVA_MIRROR = ""
            }
        },
        {
            name = "zulu",
            description = "Azul Zulu JDK (azul.com) — certified OpenJDK, Java 6-25 incl. Java 8",
            vars = {
                SDK_JAVA_SOURCE = "zulu",
                SDK_JAVA_API    = "https://api.azul.com/metadata/v1",
                SDK_JAVA_MIRROR = ""
            }
        },
        {
            name = "zulu-china",
            description = "Azul Zulu JDK via Huawei mirror (mirrors.huaweicloud.com) — China accelerated, Java 6-25 incl. Java 8 on all platforms",
            vars = {
                SDK_JAVA_SOURCE = "zulu",
                SDK_JAVA_API    = "https://api.azul.com/metadata/v1",
                SDK_JAVA_MIRROR = "https://mirrors.huaweicloud.com/zulu"
            }
        },
        {
            name = "china",
            description = "QingHua mirror",
            vars = {
                SDK_JAVA_SOURCE = "adoptium",
                SDK_JAVA_API    = "https://api.adoptium.net/v3",
                SDK_JAVA_MIRROR = "https://mirrors.tuna.tsinghua.edu.cn/Adoptium"
            }
        },
        {
            name = "local",
            description = "Local file system mirror (mirror.local_dir/java)",
            vars = {
                SDK_JAVA_SOURCE = "adoptium",
                SDK_JAVA_API    = "https://api.adoptium.net/v3",
                SDK_JAVA_MIRROR = "{local_dir}/java"
            }
        },
        {
            name = "http-server",
            description = "Local HTTP mirror server (mirror.http_server/java)",
            vars = {
                SDK_JAVA_SOURCE = "adoptium",
                SDK_JAVA_API    = "https://api.adoptium.net/v3",
                SDK_JAVA_MIRROR = "{http_server}/java",
                SDK_JAVA_FLAT = "1"
            }
        },
    }
}

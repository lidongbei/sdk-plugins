# sdk-plugins

Official plugin collection for [lidongbei/sdk](https://github.com/lidongbei/sdk).  
Each plugin supports **multiple mirror profiles** that can be switched with one command.

## Plugins

| Plugin | Description | Profiles |
|--------|-------------|----------|
| [node](./node/) | Node.js runtime | default · china · tencent · huawei · local |
| [python](./python/) | Python (build-standalone) | default · china · huawei · local |
| [go](./go/) | Go language | default · china · aliyun · ustc · local |
| [java](./java/) | Java (Eclipse Temurin) | default · china · tencent · local |
| [maven](./maven/) | Apache Maven | default · china · tencent · huawei · local |
| [gradle](./gradle/) | Gradle build tool | default · china · aliyun · local |
| [rust](./rust/) | Rust toolchain (rustup) | default · china · ustc · tuna · local |

---

## Quick Start

```bash
# 1. Clone this repo
git clone https://github.com/lidongbei/sdk-plugins.git /tmp/sdk-plugins

# 2. Add the plugins you need
sdk add node    /tmp/sdk-plugins/node
sdk add python  /tmp/sdk-plugins/python
sdk add go      /tmp/sdk-plugins/go
sdk add java    /tmp/sdk-plugins/java
sdk add maven   /tmp/sdk-plugins/maven
sdk add gradle  /tmp/sdk-plugins/gradle
sdk add rust    /tmp/sdk-plugins/rust

# 3. Install a version
sdk install node@20.0.0
sdk install go@1.22.0
```

---

## Mirror Management

Every plugin defines named **mirror profiles**. Use `sdk mirror` to view and switch them.

### View current settings

```bash
sdk mirror
```

```
Mirror settings

  node  [default]
      SDK_NODE_MIRROR = https://nodejs.org/dist
  go  [default]
      SDK_GO_MIRROR = https://go.dev
  tip: Use sdk mirror use <profile> [plugin] to switch profiles
```

### List available profiles

```bash
# All plugins
sdk mirror list

# One plugin
sdk mirror list node
```

```
node:
  ✓ default    — Official (nodejs.org)
      SDK_NODE_MIRROR = https://nodejs.org/dist
    china      — npmmirror CDN (China)
      SDK_NODE_MIRROR = https://registry.npmmirror.com/mirrors/node
    tencent    — Tencent Cloud mirror
      SDK_NODE_MIRROR = https://mirrors.cloud.tencent.com/nodejs-release
    huawei     — Huawei Cloud mirror
      SDK_NODE_MIRROR = https://mirrors.huaweicloud.com/nodejs
    local      — Local HTTP mirror (http://localhost:8080/nodejs)
      SDK_NODE_MIRROR = http://localhost:8080/nodejs
```

### Switch profiles

```bash
# Switch ALL plugins to the china profile at once
sdk mirror use china

# Switch only one plugin
sdk mirror use china node
sdk mirror use aliyun go
sdk mirror use tuna rust

# Revert to official sources
sdk mirror use default
sdk mirror use default node
```

### Set a custom URL

```bash
# Override a single env var for a plugin
sdk mirror set node SDK_NODE_MIRROR https://my-intranet-mirror/nodejs
sdk mirror set go   SDK_GO_MIRROR   https://my-intranet-mirror/golang

# The profile is recorded as "custom"
sdk mirror            # → node [custom]  SDK_NODE_MIRROR = https://my-intranet-mirror/nodejs
```

### Reset overrides

```bash
sdk mirror reset node   # Remove node mirror config (reverts to default env/vars)
sdk mirror reset        # Remove all mirror configs
```

---

## Offline / Intranet Deployment

Full offline workflow combining mirror management with sdk's offline mode:

```bash
# ── On a machine with internet access ──────────────────────────────────────

# Add and install with normal mirrors
git clone https://github.com/lidongbei/sdk-plugins.git /tmp/sdk-plugins
sdk add node /tmp/sdk-plugins/node
sdk install node@20.0.0   # auto-saved to ~/.sdk/downloads/

# Copy plugin definitions + downloaded archives to intranet
rsync -av ~/.sdk/plugin/    intranet:/opt/sdk/plugin/
rsync -av ~/.sdk/downloads/ intranet:/opt/sdk/mirror/

# ── On the intranet machine ─────────────────────────────────────────────────

sdk add node /opt/sdk/plugin/node      # from local copy (no git needed)

sdk config set cache.offline true      # never hit the network
sdk config set cache.mirror_dir /opt/sdk/mirror   # look here for archives

# Or point to an internal HTTP server
sdk mirror set node SDK_NODE_MIRROR http://intranet-srv/nodejs

sdk search node       # ⚠ Offline mode — shows locally available archives
sdk install node@20.0.0
```

---

## Plugin Mirror Configuration Reference

### Node.js

| Profile | URL |
|---------|-----|
| `default` | https://nodejs.org/dist |
| `china` | https://registry.npmmirror.com/mirrors/node |
| `tencent` | https://mirrors.cloud.tencent.com/nodejs-release |
| `huawei` | https://mirrors.huaweicloud.com/nodejs |
| `local` | http://localhost:8080/nodejs |

**Env var:** `SDK_NODE_MIRROR`

### Python

Uses [python-build-standalone](https://github.com/astral-sh/python-build-standalone) prebuilt binaries.

| Profile | `SDK_PYTHON_STANDALONE_MIRROR` |
|---------|-------------------------------|
| `default` | https://github.com/astral-sh/python-build-standalone/releases/download |
| `china` | https://ghfast.top/https://github.com/astral-sh/... (GitHub proxy) |
| `huawei` | https://ghfast.top/... |
| `local` | http://localhost:8080/python-standalone |

**Additional env vars:**
- `SDK_PYTHON_MIRROR` — used for `python.org` index (version listing)
- `SDK_PYTHON_STANDALONE_TAG` — pin a release tag (e.g. `20240107`)

### Go

| Profile | URL |
|---------|-----|
| `default` | https://go.dev |
| `china` | https://golang.google.cn |
| `aliyun` | https://mirrors.aliyun.com/golang |
| `ustc` | https://mirrors.ustc.edu.cn/golang |
| `local` | http://localhost:8080/golang |

**Env var:** `SDK_GO_MIRROR`

### Java (Eclipse Temurin)

| Profile | `SDK_JAVA_API` | `SDK_JAVA_MIRROR` |
|---------|---------------|--------------------|
| `default` | https://api.adoptium.net/v3 | *(empty, uses API redirect)* |
| `china` | https://api.adoptium.net/v3 | https://mirrors.huaweicloud.com/java/jdk |
| `tencent` | https://api.adoptium.net/v3 | https://mirrors.cloud.tencent.com/AdoptOpenJDK |
| `local` | http://localhost:8080/adoptium/v3 | http://localhost:8080/java |

### Maven

| Profile | URL |
|---------|-----|
| `default` | https://archive.apache.org/dist/maven/maven-3 |
| `china` | https://mirrors.aliyun.com/apache/maven/maven-3 |
| `tencent` | https://mirrors.cloud.tencent.com/apache/maven/maven-3 |
| `huawei` | https://mirrors.huaweicloud.com/apache/maven/maven-3 |
| `local` | http://localhost:8080/maven |

**Env var:** `SDK_MAVEN_MIRROR`

### Gradle

| Profile | `SDK_GRADLE_MIRROR` |
|---------|---------------------|
| `default` | https://services.gradle.org/distributions |
| `china` | https://mirrors.cloud.tencent.com/gradle |
| `aliyun` | https://mirrors.aliyun.com/gradle |
| `local` | http://localhost:8080/gradle |

### Rust (rustup)

| Profile | URL |
|---------|-----|
| `default` | https://static.rust-lang.org |
| `china` | https://rsproxy.cn |
| `ustc` | https://mirrors.ustc.edu.cn/rust-static |
| `tuna` | https://mirrors.tuna.tsinghua.edu.cn/rustup |
| `local` | http://localhost:8080/rust |

**Env var:** `SDK_RUSTUP_MIRROR`

---

## Plugin Structure

```
<plugin-name>/
  metadata.lua          ← Plugin metadata + mirror profile definitions
  hooks/
    available.lua       ← List available versions (calls mirror API/endpoint)
    pre_install.lua     ← Return download URL for a specific version
    env_keys.lua        ← Environment variables to activate the tool
    post_install.lua    ← Post-install steps (optional; used by rust)
```

### Defining mirror profiles in your own plugin

Add a `mirrors` array to the `PLUGIN` table in `metadata.lua`:

```lua
PLUGIN = {
    name = "mytool",
    -- ...

    mirrors = {
        {
            name = "default",
            description = "Official source",
            vars = { SDK_MYTOOL_MIRROR = "https://official.example.com/downloads" }
        },
        {
            name = "china",
            description = "China CDN",
            vars = { SDK_MYTOOL_MIRROR = "https://china-cdn.example.com/downloads" }
        },
        {
            name = "local",
            description = "Local mirror",
            vars = { SDK_MYTOOL_MIRROR = "http://localhost:8080/mytool" }
        },
    }
}
```

Then in your hook files, read the env var:

```lua
-- hooks/pre_install.lua
local BASE = os.getenv("SDK_MYTOOL_MIRROR") or "https://official.example.com/downloads"

function PLUGIN:PreInstall(ctx)
    local url = string.format("%s/mytool-%s.tar.gz", BASE, ctx.version)
    return { version = ctx.version, url = url }
end
```

Users can then switch with:

```bash
sdk mirror use china mytool
sdk mirror set mytool SDK_MYTOOL_MIRROR https://my-intranet-mirror/mytool
```

---

## License

Apache-2.0

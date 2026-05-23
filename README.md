# sdk-plugins

Official plugin collection for [lidongbei/sdk](https://github.com/lidongbei/sdk).

## Plugins

| Plugin | Description |
|--------|-------------|
| [node](./node/) | Node.js runtime |
| [python](./python/) | Python runtime |
| [go](./go/) | Go language |

## Usage

```bash
# Add a plugin (from this monorepo)
git clone https://github.com/lidongbei/sdk-plugins.git /tmp/sdk-plugins
sdk add node /tmp/sdk-plugins/node
sdk add python /tmp/sdk-plugins/python
sdk add go /tmp/sdk-plugins/go

# Or add directly from individual plugin URLs (if separated)
sdk add node https://github.com/lidongbei/sdk-plugins/node
```

## Customizing Download Mirror

Set environment variables to use a custom mirror:

```bash
export SDK_NODE_MIRROR=https://my-internal-mirror/nodejs
export SDK_PYTHON_MIRROR=https://my-internal-mirror/python
export SDK_GO_MIRROR=https://my-internal-mirror/golang
```

## Plugin Structure

```
<plugin-name>/
  metadata.lua          # Plugin metadata (name, version, description)
  hooks/
    available.lua       # List available versions
    pre_install.lua     # Return download URL for a version
    env_keys.lua        # Environment variables to set
    post_install.lua    # Post-install steps (optional)
```

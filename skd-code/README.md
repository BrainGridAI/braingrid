# SKD Code

> VS Code, forked — with BrainGrid spec-driven development built in from day one.

SKD Code is a custom distribution of VS Code (based on VSCodium) with the BrainGrid
extension pre-installed, pre-configured, and tightly integrated into the shell experience.
No marketplace install. No setup. Open it and start specifying.

## Why Fork VS Code?

| VS Code + Extension | SKD Code |
|--------------------|----------|
| Install extension from marketplace | Pre-installed, zero setup |
| Manual `braingrid login` | Login prompt on first launch |
| Extension needs CLI installed | CLI bundled in app |
| Generic branding | SKD Code branding + BrainGrid activity bar |
| Telemetry to Microsoft | No telemetry (VSCodium base) |
| Open VSX marketplace | Open VSX + curated SKD extension pack |

## Architecture

```
SKD Code
├── Base: VSCodium (VS Code - Microsoft telemetry + proprietary bits)
│         github.com/VSCodium/vscodium
│
├── Bundled Extensions (pre-installed)
│   ├── braingrid/              ← this repo (vscode-extension/)
│   ├── saoudrizwan.claude-dev  ← Cline
│   └── continue.continue       ← Continue.dev
│
├── Bundled CLI
│   └── @braingrid/cli          ← ships with the app, no npm install needed
│
├── Custom Product Config
│   ├── product.json            ← SKD Code branding, app ID, update server
│   └── package.json            ← electron app metadata
│
└── Shell Integration
    └── skd                     ← CLI wrapper: `skd code .`, `skd specify "..."`
```

## Build Plan

### Phase 1 — Extension (done)
- [x] Build BrainGrid VS Code extension (`vscode-extension/`)
- [x] Activity bar sidebar with Requirements + Tasks tree views
- [x] Webview panel for specify/build UI
- [x] Status bar with live REQ detection
- [x] All commands registered + keyboard shortcuts

### Phase 2 — VSCodium Fork Setup
- [ ] Clone VSCodium: `git clone https://github.com/VSCodium/vscodium`
- [ ] Set `VSCODE_PRODUCT_NAME=SKD Code` in build env
- [ ] Set `VSCODE_QUALITY=stable`
- [ ] Customize `product.json`:
  - `nameShort`: `"SKD Code"`
  - `nameLong`: `"SKD Code"`
  - `applicationName`: `"skd-code"`
  - `dataFolderName`: `".skd-code"`
  - `win32MutexName`: `"skdcode"`
  - `licenseName`: `"MIT"`
  - `updateUrl`: point to your own release server
- [ ] Add BrainGrid logo assets to `resources/`

### Phase 3 — Bundle Extension + CLI
- [ ] Add `braingrid` extension to `vscode/extensions/` (pre-installed)
- [ ] Bundle `@braingrid/cli` binary using `pkg` or `nexe`
  - Target: `node18-linux-x64`, `node18-macos-arm64`, `node18-win-x64`
  - Output: `resources/app/braingrid-cli`
- [ ] Patch extension to use bundled CLI path as default
- [ ] Pre-install Cline + Continue via `VSCODE_GALLERY_SERVICE_URL=open-vsx.org`

### Phase 4 — First-Launch Experience
- [ ] Create `firstLaunch.ts` extension contribution
  - Detect no auth: show welcome webview with login button
  - Detect no project: prompt to init
  - Show "What is BrainGrid?" walkthrough using VS Code Walkthrough API
- [ ] Register walkthrough in `package.json` under `contributes.walkthroughs`

### Phase 5 — `skd` CLI Wrapper
```bash
skd code .             # open SKD Code in current dir
skd specify "idea"     # run braingrid specify from anywhere
skd build REQ-123      # fetch build plan
skd status             # check auth + project context
```

### Phase 6 — Distribution
- [ ] GitHub Actions build matrix: linux, macos, windows
- [ ] Auto-update server (simple GitHub Releases works)
- [ ] Download page at skdcode.dev (or subdomain of braingrid.ai)
- [ ] `.dmg` (mac), `.deb`/`.rpm`/`.AppImage` (linux), `.exe` installer (windows)

## Quick Start (Development)

```bash
# Clone VSCodium
git clone https://github.com/VSCodium/vscodium skd-code-build
cd skd-code-build

# Set product vars
export VSCODE_PRODUCT_NAME="SKD Code"
export VSCODE_APPLICATION_NAME="skd-code"

# Build (takes ~20 min first time)
./build.sh

# Extension dev: load braingrid extension in Extension Development Host
cd /path/to/braingrid/vscode-extension
npm install
npm run compile
# then in VS Code: F5 to launch Extension Development Host
```

## Product Identity

| Property | Value |
|----------|-------|
| App Name | SKD Code |
| Binary | `skd-code` |
| Config dir | `~/.skd-code` |
| Extension dir | `~/.skd-code/extensions` |
| Marketplace | Open VSX Registry |
| Update channel | github.com/BrainGridAI/skd-code/releases |

## Resources

- VSCodium build docs: https://github.com/VSCodium/vscodium/blob/master/docs/index.md
- VS Code product.json reference: https://github.com/microsoft/vscode/blob/main/product.json
- Open VSX Registry: https://open-vsx.org
- `pkg` (bundle Node CLI): https://github.com/vercel/pkg

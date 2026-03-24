# BrainGrid for VS Code — Quick Start

## 1. Install CLI + Login

```bash
npm install -g @braingrid/cli
braingrid login
braingrid init
```

## 2. Install VS Code Integration

```bash
braingrid setup vscode
```

## 3. Run Your First Command

`Ctrl+Shift+P` → **Tasks: Run Task** → **BrainGrid: Specify**

Type your idea when prompted. Done — you have a REQ-X.

## 4. Break It Down + Build

```
BrainGrid: Breakdown → REQ-1
BrainGrid: Build     → REQ-1
```

## 5. Create a Branch (enables auto-detection)

```bash
git checkout -b feature/REQ-1-my-feature
```

Now `/build` in Continue or Cline auto-detects REQ-1 — no ID needed.

## 6. Optional: Add Keyboard Shortcuts

Add to `keybindings.json` (`Ctrl+Shift+P` → Open Keyboard Shortcuts JSON):

```json
[
  { "key": "ctrl+shift+g s", "command": "workbench.action.tasks.runTask", "args": "BrainGrid: Specify" },
  { "key": "ctrl+shift+g b", "command": "workbench.action.tasks.runTask", "args": "BrainGrid: Build" }
]
```

## AI Extensions

| Extension | How BrainGrid works |
|-----------|-------------------|
| **Cline** | Reads `.clinerules` automatically — just chat naturally |
| **Continue** | Type `/specify`, `/breakdown`, `/build` in chat |

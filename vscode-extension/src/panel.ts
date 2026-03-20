import * as vscode from 'vscode';
import { BrainGridCLI } from './cli';

export class BrainGridPanel {
  static currentPanel?: BrainGridPanel;
  private readonly _panel: vscode.WebviewPanel;
  private _disposables: vscode.Disposable[] = [];

  static createOrShow(extensionUri: vscode.Uri, cli: BrainGridCLI) {
    if (BrainGridPanel.currentPanel) {
      BrainGridPanel.currentPanel._panel.reveal();
      return;
    }
    const panel = vscode.window.createWebviewPanel(
      'braingrid',
      'BrainGrid',
      vscode.ViewColumn.Beside,
      { enableScripts: true, retainContextWhenHidden: true }
    );
    BrainGridPanel.currentPanel = new BrainGridPanel(panel, extensionUri, cli);
  }

  private constructor(
    panel: vscode.WebviewPanel,
    extensionUri: vscode.Uri,
    private cli: BrainGridCLI
  ) {
    this._panel = panel;
    this._update();

    this._panel.onDidDispose(() => this.dispose(), null, this._disposables);
    this._panel.webview.onDidReceiveMessage(
      async (msg: { command: string; data?: string }) => {
        switch (msg.command) {
          case 'specify':
            await this._runAndShow('specify', msg.data ?? '');
            break;
          case 'breakdown':
            await this._runAndShow('breakdown', msg.data ?? '');
            break;
          case 'build':
            await this._runAndShow('build', msg.data ?? '');
            break;
          case 'refresh':
            await this._update();
            break;
        }
      },
      null,
      this._disposables
    );
  }

  private async _runAndShow(command: string, arg: string) {
    try {
      let result = '';
      if (command === 'specify') result = await this.cli.specify(arg);
      else if (command === 'breakdown') result = await this.cli.breakdown(arg);
      else if (command === 'build') result = await this.cli.show(arg);
      this._panel.webview.postMessage({ command: 'result', data: result });
    } catch (e: any) {
      this._panel.webview.postMessage({ command: 'error', data: e.message });
    }
  }

  private async _update() {
    const reqId = await this.cli.detectRequirementFromBranch();
    this._panel.webview.html = this._getHtml(reqId);
  }

  private _getHtml(detectedReqId: string | null): string {
    return `<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>BrainGrid</title>
  <style>
    * { box-sizing: border-box; margin: 0; padding: 0; }
    body {
      font-family: var(--vscode-font-family);
      font-size: var(--vscode-font-size);
      color: var(--vscode-foreground);
      background: var(--vscode-editor-background);
      padding: 16px;
      display: flex;
      flex-direction: column;
      gap: 16px;
      height: 100vh;
    }
    h1 { font-size: 1.1em; font-weight: 600; display: flex; align-items: center; gap: 8px; }
    .badge {
      font-size: 0.7em; font-weight: 500; padding: 2px 8px;
      background: var(--vscode-badge-background);
      color: var(--vscode-badge-foreground);
      border-radius: 100px;
    }
    .section { display: flex; flex-direction: column; gap: 6px; }
    .section label { font-size: 0.8em; font-weight: 600; text-transform: uppercase;
      letter-spacing: 0.05em; opacity: 0.6; }
    input, textarea {
      width: 100%; padding: 6px 8px;
      background: var(--vscode-input-background);
      color: var(--vscode-input-foreground);
      border: 1px solid var(--vscode-input-border, transparent);
      border-radius: 4px; font-family: inherit; font-size: inherit;
      outline: none;
    }
    input:focus, textarea:focus { border-color: var(--vscode-focusBorder); }
    textarea { min-height: 64px; resize: vertical; }
    .row { display: flex; gap: 6px; }
    button {
      flex: 1; padding: 6px 12px; cursor: pointer; border: none; border-radius: 4px;
      font-family: inherit; font-size: inherit; font-weight: 500;
      background: var(--vscode-button-background);
      color: var(--vscode-button-foreground);
      transition: opacity 0.15s;
    }
    button:hover { opacity: 0.85; }
    button.secondary {
      background: var(--vscode-button-secondaryBackground);
      color: var(--vscode-button-secondaryForeground);
    }
    #output {
      flex: 1; overflow: auto; padding: 10px;
      background: var(--vscode-terminal-background, var(--vscode-editor-background));
      border: 1px solid var(--vscode-panel-border, transparent);
      border-radius: 4px;
      font-family: var(--vscode-editor-font-family, monospace);
      font-size: 0.85em;
      white-space: pre-wrap; word-break: break-word;
    }
    .error { color: var(--vscode-errorForeground); }
    .dim { opacity: 0.5; font-style: italic; }
  </style>
</head>
<body>
  <h1>
    ⬡ BrainGrid
    ${detectedReqId ? `<span class="badge">${detectedReqId}</span>` : ''}
  </h1>

  <div class="section">
    <label>Specify — turn an idea into a requirement</label>
    <textarea id="specifyInput" placeholder="Add OAuth2 login with Google and GitHub providers..."></textarea>
    <button onclick="send('specify', document.getElementById('specifyInput').value)">Specify →</button>
  </div>

  <div class="section">
    <label>Breakdown / Build</label>
    <input id="reqInput" placeholder="REQ-123 (or leave blank to auto-detect)"
      value="${detectedReqId ?? ''}"/>
    <div class="row">
      <button class="secondary" onclick="send('breakdown', document.getElementById('reqInput').value)">Breakdown</button>
      <button onclick="send('build', document.getElementById('reqInput').value)">Build →</button>
    </div>
  </div>

  <div id="output" class="dim">Output appears here…</div>

  <script>
    const vscode = acquireVsCodeApi();
    function send(command, data) {
      document.getElementById('output').textContent = 'Running…';
      document.getElementById('output').className = 'dim';
      vscode.postMessage({ command, data });
    }
    window.addEventListener('message', e => {
      const el = document.getElementById('output');
      if (e.data.command === 'result') {
        el.textContent = e.data.data;
        el.className = '';
      } else if (e.data.command === 'error') {
        el.textContent = '⚠ ' + e.data.data;
        el.className = 'error';
      }
    });
  </script>
</body>
</html>`;
  }

  dispose() {
    BrainGridPanel.currentPanel = undefined;
    this._panel.dispose();
    this._disposables.forEach(d => d.dispose());
  }
}

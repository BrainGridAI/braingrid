import * as vscode from 'vscode';
import { BrainGridCLI } from './cli';

export class StatusBarManager {
  private item: vscode.StatusBarItem;
  private timer?: NodeJS.Timeout;

  constructor(private cli: BrainGridCLI) {
    this.item = vscode.window.createStatusBarItem(vscode.StatusBarAlignment.Left, 100);
    this.item.command = 'braingrid.openPanel';
    this.item.tooltip = 'Open BrainGrid Panel';
  }

  start(context: vscode.ExtensionContext) {
    const enabled = vscode.workspace.getConfiguration('braingrid').get('statusBar', true);
    if (!enabled) return;

    context.subscriptions.push(this.item);
    this.refresh();
    this.timer = setInterval(() => this.refresh(), 30_000);
    context.subscriptions.push({ dispose: () => clearInterval(this.timer) });
  }

  async refresh() {
    try {
      const reqId = await this.cli.detectRequirementFromBranch();
      if (reqId) {
        this.item.text = `$(circuit-board) ${reqId}`;
        this.item.backgroundColor = undefined;
      } else {
        this.item.text = `$(circuit-board) BrainGrid`;
        this.item.backgroundColor = undefined;
      }
      this.item.show();
    } catch {
      this.item.text = `$(circuit-board) BrainGrid`;
      this.item.show();
    }
  }
}

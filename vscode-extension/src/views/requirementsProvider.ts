import * as vscode from 'vscode';
import { BrainGridCLI, Requirement } from '../cli';

export class RequirementsProvider implements vscode.TreeDataProvider<RequirementItem> {
  private _onDidChangeTreeData = new vscode.EventEmitter<RequirementItem | undefined>();
  readonly onDidChangeTreeData = this._onDidChangeTreeData.event;

  constructor(private cli: BrainGridCLI) {}

  refresh() {
    this._onDidChangeTreeData.fire(undefined);
  }

  getTreeItem(element: RequirementItem): vscode.TreeItem {
    return element;
  }

  async getChildren(): Promise<RequirementItem[]> {
    try {
      const reqs = await this.cli.requirementList('json');
      return reqs.map(r => new RequirementItem(r));
    } catch {
      return [new RequirementItem({ id: '—', name: 'Run: braingrid init', status: '' })];
    }
  }
}

class RequirementItem extends vscode.TreeItem {
  constructor(req: Requirement) {
    super(`${req.id}: ${req.name}`, vscode.TreeItemCollapsibleState.None);
    this.description = req.status;
    this.tooltip = `${req.id} — ${req.status}`;
    this.contextValue = 'requirement';
    this.iconPath = new vscode.ThemeIcon(
      req.status === 'COMPLETED' ? 'pass-filled' :
      req.status === 'IN_PROGRESS' ? 'sync~spin' :
      'circle-outline'
    );
    this.command = {
      command: 'braingrid.build',
      title: 'Show Build Plan',
      arguments: [req.id],
    };
  }
}

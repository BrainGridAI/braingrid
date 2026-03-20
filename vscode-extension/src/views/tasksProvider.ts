import * as vscode from 'vscode';
import { BrainGridCLI, Task } from '../cli';

export class TasksProvider implements vscode.TreeDataProvider<TaskItem> {
  private _onDidChangeTreeData = new vscode.EventEmitter<TaskItem | undefined>();
  readonly onDidChangeTreeData = this._onDidChangeTreeData.event;
  private currentReqId: string | null = null;

  constructor(private cli: BrainGridCLI) {}

  refresh() {
    this._onDidChangeTreeData.fire(undefined);
  }

  getTreeItem(element: TaskItem): vscode.TreeItem {
    return element;
  }

  async getChildren(): Promise<TaskItem[]> {
    try {
      const reqId = await this.cli.detectRequirementFromBranch();
      this.currentReqId = reqId;
      if (!reqId) {
        return [new TaskItem({ id: '—', title: 'No requirement detected from branch', status: '' })];
      }
      const tasks = await this.cli.taskList(reqId, 'json');
      return tasks.map(t => new TaskItem(t));
    } catch {
      return [];
    }
  }
}

class TaskItem extends vscode.TreeItem {
  constructor(task: Task) {
    super(`${task.id}: ${task.title}`, vscode.TreeItemCollapsibleState.None);
    this.description = task.status;
    this.tooltip = `${task.id} — ${task.status}`;
    this.contextValue = 'task';
    this.iconPath = new vscode.ThemeIcon(
      task.status === 'COMPLETED' ? 'pass-filled' :
      task.status === 'IN_PROGRESS' ? 'sync~spin' :
      'circle-large-outline'
    );
  }
}

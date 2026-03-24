import * as vscode from 'vscode';
import { StatusBarManager } from './statusBar';
import { BrainGridCLI } from './cli';
import { RequirementsProvider } from './views/requirementsProvider';
import { TasksProvider } from './views/tasksProvider';
import { BrainGridPanel } from './panel';
import { registerCommands } from './commands';

export function activate(context: vscode.ExtensionContext) {
  const cli = new BrainGridCLI();
  const statusBar = new StatusBarManager(cli);
  const requirementsProvider = new RequirementsProvider(cli);
  const tasksProvider = new TasksProvider(cli);

  // Register sidebar tree views
  vscode.window.registerTreeDataProvider('braingrid.requirementsView', requirementsProvider);
  vscode.window.registerTreeDataProvider('braingrid.tasksView', tasksProvider);

  // Register all commands
  registerCommands(context, cli, statusBar, requirementsProvider, tasksProvider);

  // Start status bar
  statusBar.start(context);

  // Refresh tree views when git branch changes
  const gitWatcher = vscode.workspace.createFileSystemWatcher('**/.git/HEAD');
  gitWatcher.onDidChange(() => {
    requirementsProvider.refresh();
    tasksProvider.refresh();
    statusBar.refresh();
  });
  context.subscriptions.push(gitWatcher);
}

export function deactivate() {}

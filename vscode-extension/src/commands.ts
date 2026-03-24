import * as vscode from 'vscode';
import { BrainGridCLI } from './cli';
import { StatusBarManager } from './statusBar';
import { RequirementsProvider } from './views/requirementsProvider';
import { TasksProvider } from './views/tasksProvider';
import { BrainGridPanel } from './panel';

export function registerCommands(
  context: vscode.ExtensionContext,
  cli: BrainGridCLI,
  statusBar: StatusBarManager,
  requirementsProvider: RequirementsProvider,
  tasksProvider: TasksProvider
) {
  const terminal = () =>
    vscode.window.terminals.find(t => t.name === 'BrainGrid') ??
    vscode.window.createTerminal({ name: 'BrainGrid' });

  const runInTerminal = (cmd: string) => {
    const t = terminal();
    t.show(true);
    t.sendText(cmd);
  };

  const ensureInstalled = async (): Promise<boolean> => {
    if (await cli.isInstalled()) return true;
    const choice = await vscode.window.showErrorMessage(
      'BrainGrid CLI not found. Install it?',
      'Install', 'Cancel'
    );
    if (choice === 'Install') runInTerminal('npm install -g @braingrid/cli');
    return false;
  };

  // Specify
  context.subscriptions.push(
    vscode.commands.registerCommand('braingrid.specify', async () => {
      if (!await ensureInstalled()) return;
      const prompt = await vscode.window.showInputBox({
        title: 'BrainGrid: Specify',
        prompt: 'Describe your idea or feature (10–5000 characters)',
        placeHolder: 'e.g. Add OAuth2 login with Google and GitHub providers',
        ignoreFocusOut: true,
      });
      if (!prompt) return;
      runInTerminal(`braingrid specify --prompt ${JSON.stringify(prompt)}`);
      requirementsProvider.refresh();
      statusBar.refresh();
    })
  );

  // Breakdown
  context.subscriptions.push(
    vscode.commands.registerCommand('braingrid.breakdown', async () => {
      if (!await ensureInstalled()) return;
      const detected = await cli.detectRequirementFromBranch();
      const reqId = await vscode.window.showInputBox({
        title: 'BrainGrid: Breakdown',
        prompt: 'Requirement ID to break down',
        placeHolder: 'e.g. REQ-123 or 123',
        value: detected ?? '',
        ignoreFocusOut: true,
      });
      if (!reqId) return;
      runInTerminal(`braingrid requirement breakdown ${reqId}`);
      tasksProvider.refresh();
    })
  );

  // Build
  context.subscriptions.push(
    vscode.commands.registerCommand('braingrid.build', async () => {
      if (!await ensureInstalled()) return;
      const detected = await cli.detectRequirementFromBranch();
      const reqId = await vscode.window.showInputBox({
        title: 'BrainGrid: Build',
        prompt: 'Requirement ID (leave blank to auto-detect from branch)',
        placeHolder: detected ?? 'e.g. REQ-123',
        value: detected ?? '',
        ignoreFocusOut: true,
      });
      const cmd = reqId
        ? `braingrid requirement show ${reqId} --format markdown`
        : `braingrid requirement show --format markdown`;
      runInTerminal(cmd);
    })
  );

  // Requirement List
  context.subscriptions.push(
    vscode.commands.registerCommand('braingrid.requirementList', async () => {
      if (!await ensureInstalled()) return;
      runInTerminal('braingrid requirement list');
      requirementsProvider.refresh();
    })
  );

  // Task List
  context.subscriptions.push(
    vscode.commands.registerCommand('braingrid.taskList', async () => {
      if (!await ensureInstalled()) return;
      const detected = await cli.detectRequirementFromBranch();
      const reqId = await vscode.window.showInputBox({
        title: 'BrainGrid: Task List',
        prompt: 'Requirement ID',
        placeHolder: detected ?? 'e.g. REQ-123',
        value: detected ?? '',
        ignoreFocusOut: true,
      });
      if (!reqId) return;
      runInTerminal(`braingrid task list -r ${reqId}`);
      tasksProvider.refresh();
    })
  );

  // Status
  context.subscriptions.push(
    vscode.commands.registerCommand('braingrid.status', async () => {
      if (!await ensureInstalled()) return;
      runInTerminal('braingrid status');
    })
  );

  // Open Panel
  context.subscriptions.push(
    vscode.commands.registerCommand('braingrid.openPanel', () => {
      BrainGridPanel.createOrShow(context.extensionUri, cli);
    })
  );

  // Login
  context.subscriptions.push(
    vscode.commands.registerCommand('braingrid.login', async () => {
      if (!await ensureInstalled()) return;
      runInTerminal('braingrid login');
    })
  );

  // Init
  context.subscriptions.push(
    vscode.commands.registerCommand('braingrid.init', async () => {
      if (!await ensureInstalled()) return;
      runInTerminal('braingrid init');
    })
  );
}

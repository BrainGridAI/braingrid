import { execFile } from 'child_process';
import { promisify } from 'util';
import * as vscode from 'vscode';

const execFileAsync = promisify(execFile);

export interface Requirement {
  id: string;
  name: string;
  status: string;
  createdAt?: string;
}

export interface Task {
  id: string;
  title: string;
  status: string;
  requirementId?: string;
}

export class BrainGridCLI {
  private get cliPath(): string {
    return vscode.workspace.getConfiguration('braingrid').get('cliPath', 'braingrid');
  }

  private cwd(): string {
    return vscode.workspace.workspaceFolders?.[0]?.uri.fsPath ?? process.cwd();
  }

  async run(args: string[]): Promise<string> {
    const { stdout } = await execFileAsync(this.cliPath, args, {
      cwd: this.cwd(),
      env: { ...process.env },
    });
    return stdout.trim();
  }

  async isInstalled(): Promise<boolean> {
    try {
      await this.run(['--version']);
      return true;
    } catch {
      return false;
    }
  }

  async isAuthenticated(): Promise<boolean> {
    try {
      await this.run(['whoami']);
      return true;
    } catch {
      return false;
    }
  }

  async specify(prompt: string): Promise<string> {
    return this.run(['specify', '--prompt', prompt]);
  }

  async breakdown(reqId: string): Promise<string> {
    return this.run(['requirement', 'breakdown', reqId]);
  }

  async show(reqId: string, format = 'markdown'): Promise<string> {
    const args = ['requirement', 'show'];
    if (reqId) args.push(reqId);
    args.push('--format', format);
    return this.run(args);
  }

  async requirementList(format = 'json'): Promise<Requirement[]> {
    const out = await this.run(['requirement', 'list', '--format', format]);
    try {
      return JSON.parse(out);
    } catch {
      return [];
    }
  }

  async taskList(reqId: string, format = 'json'): Promise<Task[]> {
    const args = ['task', 'list'];
    if (reqId) args.push('-r', reqId);
    args.push('--format', format);
    const out = await this.run(args);
    try {
      return JSON.parse(out);
    } catch {
      return [];
    }
  }

  async status(): Promise<string> {
    return this.run(['status']);
  }

  async login(): Promise<string> {
    return this.run(['login']);
  }

  async init(): Promise<string> {
    return this.run(['init']);
  }

  async detectRequirementFromBranch(): Promise<string | null> {
    try {
      const { execFile } = require('child_process');
      const out: string = await new Promise((resolve, reject) => {
        execFile('git', ['rev-parse', '--abbrev-ref', 'HEAD'], { cwd: this.cwd() }, (err: Error | null, stdout: string) => {
          if (err) reject(err);
          else resolve(stdout.trim());
        });
      });
      const match = out.match(/(?:REQ|req)-?(\d+)/i);
      if (match) return `REQ-${match[1]}`;
      const numMatch = out.match(/(\d+)-/);
      if (numMatch) return `REQ-${numMatch[1]}`;
    } catch {}
    return null;
  }
}

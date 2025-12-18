#!/usr/bin/env python3
"""
Dashboard-System: Übersicht über alle Repos, Fortschritte, Sicherheitsstatus, Entwickler-Statistiken
"""

import os
import json
import subprocess
import sys
from datetime import datetime
from pathlib import Path
from typing import Dict, List, Optional
import requests

PROJECT_ROOT = Path(__file__).parent.parent
DASHBOARD_DATA_FILE = PROJECT_ROOT / 'dashboard_data.json'

class RepoAnalyzer:
    """Analysiert Repository-Status und Statistiken"""
    
    def __init__(self, repo_path: Path):
        self.repo_path = repo_path
        self.name = repo_path.name
    
    def get_git_stats(self) -> Dict:
        """Holt Git-Statistiken"""
        stats = {
            'name': self.name,
            'last_commit': None,
            'branch': None,
            'commits_today': 0,
            'commits_week': 0,
            'files_changed': 0,
            'status': 'unknown'
        }
        
        try:
            # Last commit
            result = subprocess.run(
                ['git', 'log', '-1', '--format=%H|%an|%ae|%s|%cd', '--date=iso'],
                cwd=self.repo_path,
                capture_output=True,
                text=True,
                timeout=5
            )
            if result.returncode == 0 and result.stdout.strip():
                parts = result.stdout.strip().split('|')
                if len(parts) >= 5:
                    stats['last_commit'] = {
                        'hash': parts[0][:8],
                        'author': parts[1],
                        'email': parts[2],
                        'message': parts[3],
                        'date': parts[4]
                    }
            
            # Current branch
            result = subprocess.run(
                ['git', 'branch', '--show-current'],
                cwd=self.repo_path,
                capture_output=True,
                text=True,
                timeout=5
            )
            if result.returncode == 0:
                stats['branch'] = result.stdout.strip()
            
            # Commits today
            result = subprocess.run(
                ['git', 'log', '--since=midnight', '--oneline'],
                cwd=self.repo_path,
                capture_output=True,
                text=True,
                timeout=5
            )
            if result.returncode == 0:
                stats['commits_today'] = len(result.stdout.strip().split('\n')) if result.stdout.strip() else 0
            
            # Commits this week
            result = subprocess.run(
                ['git', 'log', '--since=7 days ago', '--oneline'],
                cwd=self.repo_path,
                capture_output=True,
                text=True,
                timeout=5
            )
            if result.returncode == 0:
                stats['commits_week'] = len(result.stdout.strip().split('\n')) if result.stdout.strip() else 0
            
            # Files changed
            result = subprocess.run(
                ['git', 'diff', '--stat'],
                cwd=self.repo_path,
                capture_output=True,
                text=True,
                timeout=5
            )
            if result.returncode == 0:
                lines = result.stdout.strip().split('\n')
                if lines:
                    last_line = lines[-1]
                    if 'files changed' in last_line:
                        parts = last_line.split(',')
                        if len(parts) > 0:
                            stats['files_changed'] = int(parts[0].split()[0])
            
            # Status
            result = subprocess.run(
                ['git', 'status', '--porcelain'],
                cwd=self.repo_path,
                capture_output=True,
                text=True,
                timeout=5
            )
            if result.returncode == 0:
                if result.stdout.strip():
                    stats['status'] = 'modified'
                else:
                    stats['status'] = 'clean'
        
        except Exception as e:
            stats['error'] = str(e)
            stats['status'] = 'error'
        
        return stats
    
    def get_file_stats(self) -> Dict:
        """Analysiert Dateien im Repo"""
        stats = {
            'total_files': 0,
            'dart_files': 0,
            'js_files': 0,
            'py_files': 0,
            'md_files': 0,
            'total_lines': 0
        }
        
        try:
            for root, dirs, files in os.walk(self.repo_path):
                # Ignoriere build, .git, node_modules
                dirs[:] = [d for d in dirs if d not in ['.git', 'build', 'node_modules', '.dart_tool']]
                
                for file in files:
                    file_path = Path(root) / file
                    stats['total_files'] += 1
                    
                    if file.endswith('.dart'):
                        stats['dart_files'] += 1
                    elif file.endswith('.js'):
                        stats['js_files'] += 1
                    elif file.endswith('.py'):
                        stats['py_files'] += 1
                    elif file.endswith('.md'):
                        stats['md_files'] += 1
                    
                    # Count lines
                    try:
                        with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                            stats['total_lines'] += len(f.readlines())
                    except:
                        pass
        
        except Exception as e:
            stats['error'] = str(e)
        
        return stats


class SecurityAnalyzer:
    """Analysiert Sicherheitsstatus"""
    
    def __init__(self, project_root: Path):
        self.project_root = project_root
    
    def analyze(self) -> Dict:
        """Führt Sicherheitsanalyse durch"""
        issues = {
            'critical': [],
            'warnings': [],
            'info': []
        }
        
        # Prüfe auf API Keys in Code
        for root, dirs, files in os.walk(self.project_root):
            dirs[:] = [d for d in dirs if d not in ['.git', 'build', 'node_modules', '.dart_tool']]
            
            for file in files:
                if not any(file.endswith(ext) for ext in ['.dart', '.js', '.py', '.ts']):
                    continue
                
                file_path = Path(root) / file
                try:
                    with open(file_path, 'r', encoding='utf-8', errors='ignore') as f:
                        content = f.read()
                        
                        # Prüfe auf hardcoded API Keys
                        if 'api_key' in content.lower() and 'process.env' not in content and 'os.getenv' not in content:
                            if 'AIza' in content or 'sk-' in content:
                                issues['critical'].append({
                                    'file': str(file_path.relative_to(self.project_root)),
                                    'issue': 'Hardcoded API Key gefunden',
                                    'severity': 'critical'
                                })
                        
                        # Prüfe auf Passwörter
                        if 'password' in content.lower() and '=' in content:
                            if 'process.env' not in content and 'os.getenv' not in content:
                                issues['warnings'].append({
                                    'file': str(file_path.relative_to(self.project_root)),
                                    'issue': 'Mögliches hardcoded Passwort',
                                    'severity': 'warning'
                                })
                
                except:
                    pass
        
        return {
            'overall': 'good' if len(issues['critical']) == 0 else 'critical',
            'critical_count': len(issues['critical']),
            'warnings_count': len(issues['warnings']),
            'issues': issues
        }


class DeveloperStats:
    """Sammelt Entwickler-Statistiken"""
    
    def __init__(self, project_root: Path):
        self.project_root = project_root
    
    def get_stats(self) -> Dict:
        """Holt Entwickler-Statistiken aus Git"""
        dev_stats = {}
        
        try:
            # Git shortlog für alle Entwickler
            result = subprocess.run(
                ['git', 'shortlog', '-sn', '--all'],
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=10
            )
            
            if result.returncode == 0:
                for line in result.stdout.strip().split('\n'):
                    if line.strip():
                        parts = line.split('\t')
                        if len(parts) == 2:
                            commits = int(parts[0].strip())
                            name = parts[1].strip()
                            
                            if name not in dev_stats:
                                dev_stats[name] = {
                                    'commits': 0,
                                    'files_changed': 0,
                                    'repos': set()
                                }
                            
                            dev_stats[name]['commits'] += commits
            
            # Files changed per developer
            result = subprocess.run(
                ['git', 'log', '--all', '--pretty=format:%an', '--numstat'],
                cwd=self.project_root,
                capture_output=True,
                text=True,
                timeout=10
            )
            
            if result.returncode == 0:
                lines = result.stdout.strip().split('\n')
                current_dev = None
                for line in lines:
                    if '\t' not in line and line.strip():
                        current_dev = line.strip()
                    elif '\t' in line and current_dev and current_dev in dev_stats:
                        parts = line.split('\t')
                        if len(parts) >= 3:
                            try:
                                additions = int(parts[0]) if parts[0] != '-' else 0
                                deletions = int(parts[1]) if parts[1] != '-' else 0
                                dev_stats[current_dev]['files_changed'] += additions + deletions
                            except:
                                pass
            
            # Convert sets to lists for JSON
            for dev in dev_stats:
                dev_stats[dev]['repos'] = list(dev_stats[dev]['repos'])
        
        except Exception as e:
            print(f"⚠️ Fehler bei Entwickler-Statistiken: {e}")
        
        return dev_stats


class DashboardSystem:
    """Haupt-Dashboard-System"""
    
    def __init__(self):
        self.project_root = PROJECT_ROOT
        self.apps_dir = self.project_root / 'apps'
    
    def generate_dashboard(self) -> Dict:
        """Generiert vollständiges Dashboard"""
        dashboard = {
            'timestamp': datetime.now().isoformat(),
            'repos': {},
            'security': {},
            'developers': {},
            'summary': {}
        }
        
        # Analysiere alle Apps
        if self.apps_dir.exists():
            for app_dir in self.apps_dir.iterdir():
                if app_dir.is_dir() and (app_dir / '.git').exists():
                    analyzer = RepoAnalyzer(app_dir)
                    git_stats = analyzer.get_git_stats()
                    file_stats = analyzer.get_file_stats()
                    
                    dashboard['repos'][app_dir.name] = {
                        **git_stats,
                        **file_stats
                    }
        
        # Sicherheitsanalyse
        security = SecurityAnalyzer(self.project_root)
        dashboard['security'] = security.analyze()
        
        # Entwickler-Statistiken
        dev_stats = DeveloperStats(self.project_root)
        dashboard['developers'] = dev_stats.get_stats()
        
        # Summary
        total_repos = len(dashboard['repos'])
        active_repos = sum(1 for r in dashboard['repos'].values() if r.get('commits_today', 0) > 0)
        total_commits = sum(r.get('commits_week', 0) for r in dashboard['repos'].values())
        
        dashboard['summary'] = {
            'total_repos': total_repos,
            'active_repos': active_repos,
            'total_commits_week': total_commits,
            'security_status': dashboard['security']['overall'],
            'total_developers': len(dashboard['developers'])
        }
        
        return dashboard
    
    def save_dashboard(self, dashboard: Dict):
        """Speichert Dashboard-Daten"""
        try:
            with open(DASHBOARD_DATA_FILE, 'w', encoding='utf-8') as f:
                json.dump(dashboard, f, indent=2, ensure_ascii=False)
        except Exception as e:
            print(f"⚠️ Fehler beim Speichern: {e}")
    
    def print_dashboard(self, dashboard: Dict):
        """Druckt Dashboard im Terminal"""
        print("\n" + "="*80)
        print("📊 DASHBOARD - Repository Übersicht")
        print("="*80)
        print(f"\n🕐 Generiert: {datetime.now().strftime('%d.%m.%Y %H:%M:%S')}\n")
        
        print("📦 REPOSITORIES:")
        print("-" * 80)
        for repo_name, stats in dashboard['repos'].items():
            status_icon = "✅" if stats.get('status') == 'clean' else "⚠️" if stats.get('status') == 'modified' else "❌"
            print(f"{status_icon} {repo_name}")
            print(f"   Branch: {stats.get('branch', 'N/A')}")
            print(f"   Commits heute: {stats.get('commits_today', 0)}")
            print(f"   Commits diese Woche: {stats.get('commits_week', 0)}")
            if stats.get('last_commit'):
                print(f"   Letzter Commit: {stats['last_commit'].get('author', 'N/A')} - {stats['last_commit'].get('message', 'N/A')[:50]}")
            print()
        
        print("\n🔒 SICHERHEIT:")
        print("-" * 80)
        security = dashboard['security']
        security_icon = "✅" if security['overall'] == 'good' else "🔴"
        print(f"{security_icon} Status: {security['overall'].upper()}")
        print(f"   Kritische Issues: {security['critical_count']}")
        print(f"   Warnungen: {security['warnings_count']}")
        
        print("\n👥 ENTWICKLER:")
        print("-" * 80)
        for dev, stats in dashboard['developers'].items():
            print(f"• {dev}: {stats.get('commits', 0)} Commits, {stats.get('files_changed', 0)} Zeilen geändert")
        
        print("\n" + "="*80 + "\n")


if __name__ == '__main__':
    dashboard_system = DashboardSystem()
    dashboard = dashboard_system.generate_dashboard()
    dashboard_system.save_dashboard(dashboard)
    dashboard_system.print_dashboard(dashboard)
    
    # Optional: Sende an Slack
    if '--slack' in sys.argv:
        from slack_multi_user import send_dashboard_update
        repo_stats = {
            name: {
                'status': '✅ OK' if stats.get('status') == 'clean' else '⚠️ Modified',
                'last_commit': stats.get('last_commit', {}).get('date', 'N/A')[:10] if stats.get('last_commit') else 'N/A'
            }
            for name, stats in dashboard['repos'].items()
        }
        security_status = {
            'overall': dashboard['security']['overall'],
            'critical': dashboard['security']['critical_count'],
            'warnings': dashboard['security']['warnings_count']
        }
        dev_stats = {
            dev: {
                'commits': stats.get('commits', 0),
                'files_changed': stats.get('files_changed', 0)
            }
            for dev, stats in dashboard['developers'].items()
        }
        send_dashboard_update(repo_stats, security_status, dev_stats)


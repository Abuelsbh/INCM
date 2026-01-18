#!/usr/bin/env python3
"""
Script to restore files from Cursor Local History to template_2025-main 8 project
"""
import json
import os
import urllib.parse
from pathlib import Path
from collections import defaultdict

HISTORY_DIR = Path.home() / "Library/Application Support/Cursor/User/History"
TARGET_DIR = Path.home() / "Downloads/template_2025-main 8"

def find_project_files():
    """Find all entries.json files that reference template_2025-main 8"""
    project_files = defaultdict(list)
    
    for entries_file in HISTORY_DIR.rglob("entries.json"):
        try:
            with open(entries_file) as f:
                data = json.load(f)
            
            resource = data.get('resource', '')
            if 'template_2025-main' in resource and '8' in resource:
                # Decode URL
                decoded = urllib.parse.unquote(resource)
                if decoded.startswith('file://'):
                    file_path = decoded.replace('file://', '')
                    rel_path = file_path.replace(str(Path.home() / "Downloads/template_2025-main 8"), '').lstrip('/')
                    
                    entries = data.get('entries', [])
                    if entries:
                        latest_entry = entries[-1]
                        history_file = entries_file.parent / latest_entry['id']
                        if history_file.exists():
                            project_files[rel_path].append({
                                'history_file': history_file,
                                'timestamp': latest_entry.get('timestamp', 0),
                                'source': latest_entry.get('source', '')
                            })
        except Exception as e:
            continue
    
    # For each file, get the latest version
    latest_files = {}
    for rel_path, versions in project_files.items():
        latest = max(versions, key=lambda x: x['timestamp'])
        latest_files[rel_path] = latest['history_file']
    
    return latest_files

def restore_files():
    """Restore all files to the target directory"""
    files = find_project_files()
    
    print(f"Found {len(files)} files to restore")
    
    restored = 0
    for rel_path, history_file in files.items():
        target_file = TARGET_DIR / rel_path
        target_file.parent.mkdir(parents=True, exist_ok=True)
        
        try:
            # Copy file
            import shutil
            shutil.copy2(history_file, target_file)
            print(f"✓ Restored: {rel_path}")
            restored += 1
        except Exception as e:
            print(f"✗ Failed to restore {rel_path}: {e}")
    
    print(f"\nRestored {restored} out of {len(files)} files")

if __name__ == "__main__":
    restore_files()


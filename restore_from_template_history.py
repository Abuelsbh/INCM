#!/usr/bin/env python3
"""
Script to restore files from Cursor Local History (template_2025-main 8) to INCM project
"""
import json
import os
import urllib.parse
from pathlib import Path
from collections import defaultdict
import shutil

HISTORY_DIR = Path.home() / "Library/Application Support/Cursor/User/History"
SOURCE_DIR = Path.home() / "Downloads/template_2025-main 8"
TARGET_DIR = Path("/Users/m/Desktop/app/INCM")

def find_project_files():
    """Find all entries.json files that reference template_2025-main 8"""
    project_files = defaultdict(list)
    
    print("Searching Cursor Local History...")
    entries_count = 0
    
    for entries_file in HISTORY_DIR.rglob("entries.json"):
        entries_count += 1
        if entries_count % 100 == 0:
            print(f"  Scanned {entries_count} history entries...")
            
        try:
            with open(entries_file) as f:
                data = json.load(f)
            
            resource = data.get('resource', '')
            if 'template_2025-main' in resource and '8' in resource:
                # Decode URL
                decoded = urllib.parse.unquote(resource)
                if decoded.startswith('file://'):
                    file_path = decoded.replace('file://', '')
                    # Extract relative path from template_2025-main 8
                    if str(SOURCE_DIR) in file_path:
                        rel_path = file_path.replace(str(SOURCE_DIR), '').lstrip('/')
                        
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
    
    print(f"Found {len(project_files)} unique files in history")
    
    # For each file, get the latest version
    latest_files = {}
    for rel_path, versions in project_files.items():
        latest = max(versions, key=lambda x: x['timestamp'])
        latest_files[rel_path] = latest['history_file']
    
    return latest_files

def restore_files():
    """Restore all files to the INCM project"""
    files = find_project_files()
    
    if not files:
        print("\nNo files found in local history. Trying to copy from template_2025-main 8 directly...")
        return copy_from_template()
    
    print(f"\nFound {len(files)} files to restore from local history")
    
    restored = 0
    skipped = 0
    failed = 0
    
    for rel_path, history_file in files.items():
        target_file = TARGET_DIR / rel_path
        target_file.parent.mkdir(parents=True, exist_ok=True)
        
        try:
            # Copy file from history
            shutil.copy2(history_file, target_file)
            print(f"✓ Restored: {rel_path}")
            restored += 1
        except Exception as e:
            print(f"✗ Failed to restore {rel_path}: {e}")
            failed += 1
    
    print(f"\nSummary:")
    print(f"  Restored: {restored}")
    print(f"  Failed: {failed}")
    
    return restored

def copy_from_template():
    """Fallback: Copy files directly from template_2025-main 8"""
    if not SOURCE_DIR.exists():
        print(f"Source directory not found: {SOURCE_DIR}")
        return 0
    
    print(f"Copying files from {SOURCE_DIR} to {TARGET_DIR}...")
    
    restored = 0
    skipped = 0
    
    # Copy all files from template
    for root, dirs, files in os.walk(SOURCE_DIR):
        # Skip certain directories
        dirs[:] = [d for d in dirs if d not in ['.git', '__pycache__', 'node_modules', '.dart_tool']]
        
        for file in files:
            src_file = Path(root) / file
            rel_path = src_file.relative_to(SOURCE_DIR)
            target_file = TARGET_DIR / rel_path
            
            # Skip if target exists and is newer
            if target_file.exists():
                if target_file.stat().st_mtime >= src_file.stat().st_mtime:
                    skipped += 1
                    continue
            
            try:
                target_file.parent.mkdir(parents=True, exist_ok=True)
                shutil.copy2(src_file, target_file)
                print(f"✓ Copied: {rel_path}")
                restored += 1
            except Exception as e:
                print(f"✗ Failed to copy {rel_path}: {e}")
    
    print(f"\nSummary:")
    print(f"  Copied: {restored}")
    print(f"  Skipped: {skipped}")
    
    return restored

if __name__ == "__main__":
    print("=" * 60)
    print("Restoring files from template_2025-main 8 to INCM project")
    print("=" * 60)
    restore_files()

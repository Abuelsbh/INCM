#!/usr/bin/env python3
"""
Script to fix all .tr usage in Dart files by adding context parameter
"""
import re
import os
from pathlib import Path

def fix_tr_usage(file_path):
    """Fix .tr usage in a Dart file"""
    try:
        with open(file_path, 'r', encoding='utf-8') as f:
            content = f.read()
        
        original_content = content
        
        # Pattern 1: '.tr' without parentheses (needs context)
        # Replace '.tr' with '.tr(context)' but only if it's not already '.tr('
        # We need to be careful not to replace in comments or strings
        
        # First, find all .tr without context
        # Pattern: word'.tr followed by non-opening-parenthesis
        pattern = r"(\w+)'\.tr(?!\()"
        
        def replace_tr(match):
            key = match.group(1)
            # Check if we're in a build method or have context available
            # For now, just add context parameter
            return f"{key}'.tr(context)"
        
        content = re.sub(pattern, replace_tr, content)
        
        # Pattern 2: ".tr" without parentheses
        pattern2 = r'(\w+)"\.tr(?!\()'
        def replace_tr2(match):
            key = match.group(1)
            return f'{key}".tr(context)'
        
        content = re.sub(pattern2, replace_tr2, content)
        
        # Pattern 3: 'KEY'.tr in Text widgets or similar
        # This is more complex, we need to ensure context is available
        
        if content != original_content:
            with open(file_path, 'w', encoding='utf-8') as f:
                f.write(content)
            return True
        return False
    except Exception as e:
        print(f"Error processing {file_path}: {e}")
        return False

def find_dart_files_with_tr(root_dir):
    """Find all Dart files that use .tr without context"""
    dart_files = []
    for root, dirs, files in os.walk(root_dir):
        # Skip hidden directories and build directories
        dirs[:] = [d for d in dirs if not d.startswith('.') and d != 'build']
        
        for file in files:
            if file.endswith('.dart'):
                file_path = os.path.join(root, file)
                try:
                    with open(file_path, 'r', encoding='utf-8') as f:
                        content = f.read()
                        # Check if file has .tr without context
                        if re.search(r"\.tr(?!\()", content):
                            dart_files.append(file_path)
                except:
                    pass
    return dart_files

if __name__ == "__main__":
    lib_dir = "lib"
    files = find_dart_files_with_tr(lib_dir)
    print(f"Found {len(files)} files with .tr usage")
    
    fixed = 0
    for file_path in files:
        if fix_tr_usage(file_path):
            print(f"Fixed: {file_path}")
            fixed += 1
    
    print(f"\nFixed {fixed} files")

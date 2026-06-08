#!/usr/bin/env python3
import re
import subprocess
import os
import sys

def parse_binds(file_path):
    bind_pattern = re.compile(r'^\s*([a-zA-Z0-9_+]+(?:\s+[a-zA-Z0-9_\-]+=[a-zA-Z0-9_\-]+)*)\s*\{\s*(.+?)\s*;\s*\}')
    comment_pattern = re.compile(r'^\s*//\s*(.*)')
    
    with open(file_path, 'r') as f:
        lines = f.readlines()
        
    binds = []
    current_comment = []
    
    for line in lines:
        line_str = line.strip()
        if not line_str:
            current_comment = []
            continue
            
        comment_match = comment_pattern.match(line)
        if comment_match:
            comment_content = comment_match.group(1).strip()
            for prefix in ["FIXME:", "WHY:", "TODO:", "PERF:", "HACK:"]:
                if comment_content.startswith(prefix):
                    comment_content = comment_content[len(prefix):].strip()
            current_comment.append(comment_content)
            continue
            
        bind_match = bind_pattern.match(line)
        if bind_match:
            key_part = bind_match.group(1).strip()
            action_part = bind_match.group(2).strip()
            
            parts = key_part.split()
            key_name = parts[0]
            options = parts[1:]
            
            key_name = key_name.replace("XF86Audio", "Audio-").replace("XF86Mon", "Mon-")
            
            opt_str = ""
            if "allow-when-locked=true" in options:
                opt_str = " [Locked]"
                
            comment = " ".join(current_comment) if current_comment else ""
            binds.append({
                "key": key_name + opt_str,
                "action": action_part,
                "comment": comment
            })
            current_comment = []
            
    return binds

def main():
    home = os.environ.get("HOME", "/home/ngxc")
    kdl_path = os.path.join(home, ".config/niri/modules/keybinds.kdl")
    binds = parse_binds(kdl_path)
    
    binds.sort(key=lambda x: x["key"])
    
    max_k = max(len(b["key"]) for b in binds) if binds else 0
    max_a = max(len(b["action"]) for b in binds) if binds else 0
    
    lines = []
    for b in binds:
        pad_k = " " * (max_k - len(b["key"]))
        pad_a = " " * (max_a - len(b["action"]))
        if b["comment"]:
            lines.append(f"  {b['key']}{pad_k}  |  {b['action']}{pad_a}  |  {b['comment']}")
        else:
            lines.append(f"  {b['key']}{pad_k}  |  {b['action']}")
            
    rofi_input = "\n".join(lines)
    
    rofi_cmd = [
        "rofi", "-dmenu", "-i", "-p", "Niri Cheatsheet",
        "-theme-str", 'window {width: 75%; border: 2px; border-color: #d50000; background-color: #000000;} listview {lines: 15; fixed-height: false;} element-text {text-color: #f5f5f5;} element {padding: 5px 10px;}'
    ]
    
    if len(sys.argv) > 1:
        rofi_cmd.extend(["-select", sys.argv[1]])
        
    try:
        subprocess.run(rofi_cmd, input=rofi_input, text=True)
    except Exception as e:
        print(f"Error running rofi: {e}")

if __name__ == "__main__":
    main()

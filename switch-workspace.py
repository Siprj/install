#!/usr/bin/env python3

import json
import subprocess
import sys

def get_workspaces():
    process = subprocess.run(["i3-msg", "-t", "get_workspaces"], check=True, stdout=subprocess.PIPE)
    return json.loads(process.stdout)


def main():
    target_workspace_number = sys.argv[1]
    workspaces = get_workspaces()
    print(workspaces)

    target_workspace = None;

    for i in workspaces:
        if i["focused"]:
            current_workspace = i
        if i["name"] == target_workspace_number:
            target_workspace = i

    current_output = current_workspace["output"]

    print(current_workspace, current_output, target_workspace)

    if (target_workspace == None or target_workspace["output"] == current_output):
        subprocess.run(["i3-msg", "workspace", target_workspace_number], check=True)
    else:
        if target_workspace["visible"] == True:
            subprocess.run(["i3-msg", "move", "workspace", "to", "output", target_workspace["output"]], check=True)

        subprocess.run(["i3-msg", "workspace", target_workspace_number], check=True)
        subprocess.run(["i3-msg", "move", "workspace", "to", "output", current_output], check=True)
        subprocess.run(["i3-msg", "focus", "output", current_output], check=True)

if __name__ == '__main__':
    main()

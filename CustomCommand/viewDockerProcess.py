#!/usr/bin/env python3

import psutil
import argparse
import subprocess

def inspectDocker(containerId):
    cmd = ['docker', 'inspect', '--format="{{.Name}}"', containerId]
    return subprocess.run(cmd, stdout=subprocess.PIPE).stdout.decode('utf-8')

def getParentProcList(pid):
    procList = []
    # The process might be terminated or non-exist, so only add those available
    try:
        curProc = psutil.Process(pid)
        while curProc.pid != 0:
            # Add current pid to list
            procList.append(curProc)
            # Move to parent process
            curProc = psutil.Process(curProc.ppid())
    except psutil.NoSuchProcess:
        pass  # Ignore invalid process
    return procList

if __name__ == "__main__":
    # Add argument parser
    parser = argparse.ArgumentParser()
    parser.add_argument('pid', metavar='PID', type=int, help='PID of the process.')
    args = parser.parse_args()

    # Try to retrive parent processes list
    procList = getParentProcList(args.pid)
    if procList:
        dockerProc = None
        # Loop over to try to find whether it's a docker process
        for proc in procList:
            # Find the container process by several rules:
            cmdLine = proc.cmdline()
            if len(cmdLine) >= 5 and "containerd" in cmdLine[0] and "-namespace" in cmdLine and "-id" in cmdLine:
                # The -id option is followed by container ID
                idx = cmdLine.index("-id")
                containerId = cmdLine[idx+1]
                # If found, try to fetch the container's name
                inspectResult = inspectDocker(containerId)
                if inspectResult:
                    print(f"The process {args.pid} is a container process and belongs to", inspectResult.strip())
        print("Process tree:", " -> ".join([str(p.pid)+f"({p.name()})" for p in procList]))
    # Failed to retrive related info
    else:
        print(f"The PID {args.pid} does not appear in process list.")
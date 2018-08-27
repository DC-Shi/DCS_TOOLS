#!/bin/bash
# Get detail info about processes using GPU.
# It get process ID from nvidia-smi, and use ps to get detail.


# Get all process using GPU
gpu_use=$(nvidia-smi pmon  -c 1)

# Read line by line
line_id=0
while read -r curLine
do
  # First two line is header
  # We output ps header at first line
  if [[ $line_id -eq 0 ]]; then
    read -r ps_header <<< "$(ps fu)"
    printf "%s\t%s\n" "$curLine" "$ps_header"
  # line 1 is nvidia-smi header
  elif [[ $line_id -eq 1 ]]; then
    echo "$curLine"
  # line 2 or later is content
  else
    # Split current line
    read -r -a str_split <<< "$curLine"

    # Original right aligned for nvidia-smi output, we add 4 space in front for better output.
    printf "    "

    # PID is second number
    pid=${str_split[1]}
    # PID can be '-' if no process running on current GPU
    # We use regex to find whether is a number
    if [[ $pid =~ ^[0-9]+$ ]] ; then
      # Show the process info, f(ull) u(sername) h(without header)
      printf "%s\t%s\n" "$curLine" "$(ps fuh -p $pid)"
    else
      # Show directly
      echo "$curLine"
    fi
  fi

  line_id=$(($line_id+1))
done <<<"$gpu_use"


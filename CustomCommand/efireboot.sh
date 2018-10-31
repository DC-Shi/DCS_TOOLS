#!/bin/bash
# Reboot current system with current EFI entry.
# It is used for portable Linux to reboot again into current system.

# Detect efibootmgr
which efibootmgr
res=$?

if [[ $res -eq 0 ]]; then
  # Get 4 hex of current boot value
  bootcur=$(efibootmgr | grep BootCurrent | cut -d " " -f 2)
  # Change bootnext
  efibootmgr --bootnext $bootcur
  res=$?
  if [[ $res -eq 0 ]]; then
    echo "Reboot in 2 seconds"
    sleep 2
    reboot
  else
    echo "Cannot change efibootmgr bootnext entry, do you run as root?"
    exit $res
  fi
else
  echo "Cannot find efibootmgr, abort."
  exit $res
fi



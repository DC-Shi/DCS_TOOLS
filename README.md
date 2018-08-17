# DCS TOOLS
This is a series of scripts to make my Linux life easier.

# Manually modifying is needed
In order to use this well, I did not include scripts related to personal information.
- change `~/.bash_aliases` to include this bashrc
  ```bash
  export DCS_TOOLS="${HOME}/DCS_TOOLS"
  if [ -f ${DCS_TOOLS}/bashrc ]; then
    . ${DCS_TOOLS}/bashrc
  fi
  ```
- create keys for key-free ssh login. This need to modify `~/.ssh/config` to include different (site,key) pair

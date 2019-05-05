# Multiple script for running one-line commands
#
# Format notes: each option should have
# "str") #description
#

case "$1" in
  "grub2_force_uuid") # Force GRUB2 use UUID to search partition, need admin rights
    # No hint is used during the grub searches the partition
    sed -i 's/x$feature_platform_search_hint = xy/x$feature_platform_search_hint = xn/g' /boot/grub/grub.cfg
  ;;

  "users")            # Show usernames along with their process count
    ps aux|awk '{print $1}'|sort |uniq -c
  ;;
  *)
    echo "Available options:"
    # Trick to show each options
    # if finds any pattern __"???") , so this should be an option line with comments.
    cat $0 | grep -E '^\s+\".*\"\).*' | awk '{split($0, a, "\")"); printf "%s\" %s\r\n",a[1],a[2] }'
  ;;
esac

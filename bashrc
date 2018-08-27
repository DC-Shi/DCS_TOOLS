# dummy alias commands
alias haha='echo We do nothing, but print one "haha"'
# this re-direct command is to log the apt-get
alias apt-get='${DCS_TOOLS}/CustomCommand/apt-get.sh'
# let sudo would ignore alias, adding space in end
# https://askubuntu.com/questions/22037/aliases-not-available-when-using-sudo
alias sudo='sudo '

# Set hist time format, so history would remember time.
# http://man7.org/linux/man-pages/man3/strftime.3.html
export HISTTIMEFORMAT="%FT%T%z%t"

# Add custom commands to search path
export PATH=${DCS_TOOLS}/CustomCommand:$PATH

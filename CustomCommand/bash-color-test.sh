#!/bin/bash
# Written by Daochen Shi , 2018-May


# Text Colors
TXT_BOLD=$(tput bold)
TXT_NORMAL=$(tput sgr0)
TXT_K=$(tput setaf 0)
TXT_B=$(tput setaf 1)
TXT_G=$(tput setaf 2)
TXT_C=$(tput setaf 3)
TXT_R=$(tput setaf 4)
TXT_M=$(tput setaf 5)
TXT_Y=$(tput setaf 6)
TXT_W=$(tput setaf 7)
TXT_L_K=$(tput setab 0)
TXT_L_B=$(tput setab 1)
TXT_L_G=$(tput setab 2)
TXT_L_C=$(tput setab 3)
TXT_L_R=$(tput setab 4)
TXT_L_M=$(tput setab 5)
TXT_L_Y=$(tput setab 6)
TXT_L_W=$(tput setab 7)


# Ubuntu desktop shows colors with setab/setaf
# Mobaxterm shows colors with setb/setf

# Find '$ (tput' pattern, so that only matches different types
cat $0 | grep -E '\$\(tput' | cut -d '=' -f1 | while read x
do
  # Find var_name with = sign behind, this is actual in Text Colors session
  tmp=$(cat $0 | grep "$x=" | cut -d ' ' -f3)
  echo ${!x}$x ${tmp}${TXT_NORMAL}  # echo each line previously searched, and apply its type
done



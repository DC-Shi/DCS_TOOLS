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

function printColor
{
  # $1 is foreground(38) or background(48)
  # $2 is color code(0~256)
  printf "\033[%d;5;%dm %03d \033[0m" $1 $2 $2
}

function print256Color
{
  for fgbg in 38 48 ; do
    # Standard color
    for color in {0..15} ; do
      printColor $fgbg $color
      if [ $((($color + 1) % 8)) == 0 ] ; then
          echo #New line
      fi
    done

    # Color table: each subblock is 6*6, bigblock is 3row*2col
    for largeBlk in 0 72 144 ; do
    for rowStart in {16..46..6} ; do
      for col in 0 36 ; do
      for idx in {0..5} ; do
        printColor $fgbg $((largeBlk + rowStart + col + idx))
      done
      done
      echo
    done
    done

    # Gray color    
    for color in {232..255} ; do
      printColor $fgbg $color
      if [ $((($color + 1) % 8)) == 0 ] ; then
          echo #New line
      fi
    done
      
    echo #New line
  done
}

print256Color

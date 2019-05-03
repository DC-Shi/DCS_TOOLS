#!/bin/bash
# Get voltage info about embedded products.

# Get the model first
MODEL=$(lshw -class system 2>/dev/null|grep product | awk '{print $2}')

case $MODEL in
  # Jetson Nano has product name jetson-nano
  jetson-nano)
    pushd /sys/devices/50000000.host1x/546c0000.i2c/i2c-6/6-0040/iio:device0
    for item in *0*
    do
      printf "%-30s : %s\n" "${item}" "$(cat ${item})"
    done
    ;;
  # Jetson TX2 has product name quill
  quill)
    pushd /sys/devices/3160000.i2c/i2c-0/0-0042/iio:device2
    # Monitor 5V usage (VDD_5V0_IO_SYS)
    for item in *1*
    do
      printf "%-30s : %s\n" "${item}" "$(cat ${item})"
    done
    ;;
  # Others
  *)
    echo "Not supported yet."
    ;;
esac


#/bin/bash
time nice -n -20 su -c "dd if=/dev/zero of=/tmp/nice1.img bs=2000 count=1M" &  time nice -n 19 su -c "dd if=/dev/zero of=/tmp/nice2.img bs=2000 count=1M" &
#/bin/bash

time ionice -c1 -n0 su -c "dd if=/dev/zero of=/tmp/ionice1.img bs=512 count=1M" & time ionice -c2 -n7 su -c "dd if=/dev/zero of=/tmp/ionice2.img bs=512 count=1M" &
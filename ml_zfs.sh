#!/bin/sh

## customize these
disk=ada0
interval=3
pool="zroot"

# Set the variable stump_pid using one of these two lines.  Which line you use
# depends on whether you run the large StumpWM executable that bundles SBCL, or
# if you simply start SBCL and load StumpWM.  If you are using the FreeBSD
# StumpWM package, use the second line.

#stump_pid="$(pgrep -a -n stumpwm)"
stump_pid="$(pgrep -anf -U "$(id -u)" "sbcl .*(stumpwm:stumpwm)")"

# while stumpwm is still running
while kill -0 "$stump_pid" > /dev/null 2>&1; do
    io_info=$(iostat -c2 -w "$interval" -x "$disk" | \
		     awk 'NR%6==0 {print $4 " " $5}')
    set -- $io_info
    read=$( bc -e "scale=2;$1/1024" -e quit)
    write=$(bc -e "scale=2;$2/1024" -e quit)
    zfs_info="$(zpool list -Hp "$pool")"
    set -- $zfs_info
    # pool name used total free percent read write
    printf "%s %3.0f %3.0f %3.0f %3.0f %3.1f %3.1f\n"\
	   "$1" $(( $3/1024/1024/1024 )) $(( $2/1024/1024/1024 ))\
	   $(( $4/1024/1024/1024 )) "$7" "$read" "$write"
done

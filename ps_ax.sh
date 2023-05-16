#!/bin/bash
echo -e 'PID\tTTY\tSTAT\tTIME\tCOMMAND'

for i in $(ls /proc/ | grep -P "[0-9]" | sort -n)
do

    if [[ -f /proc/$i/status ]]
        then PID=$i

    # TTY
        if [[ -e /proc/"$PID"/fd/1 ]]
                then
                TTY=`ls -l /proc/"$PID"/fd/1 | awk '{print $11}' | sed 's/\/dev\///'`
                    if [ "$TTY" == "null" ]
                        then TTY='?'
                    elif [ `echo $TTY | cut -d':' -f1` == "socket" ]
                        then TTY='?'
                    fi
                else
                        TTY='?'
        fi
    
    # STAT
    STAT=`cat /proc/$PID/status | awk '/State/{print $2}'`

    #TIME
    PROCESS_STAT=($(sed -E 's/\([^)]+\)/X/' "/proc/$PID/stat"))
    PROCESS_UTIME=${PROCESS_STAT[13]}
    PROCESS_STIME=${PROCESS_STAT[14]}

    CLK_TCK=$(getconf CLK_TCK)
    let PROCESS_UTIME_SEC="$PROCESS_UTIME / $CLK_TCK"
    let PROCESS_STIME_SEC="$PROCESS_STIME / $CLK_TCK"
    let SECS="$PROCESS_UTIME_SEC + $PROCESS_STIME_SEC"
    TIME=`date -d@$SECS -u +%M:%S`

    # COMM
        COMMAND=`cat /proc/$PID/cmdline`
        if [[ -z "$COMMAND" ]]
                then
                COMMAND="[`awk '/Name/{print $2}' /proc/$PID/status`]"
        fi

        echo -e "$PID" '\t' "$TTY" '\t' "$STAT" '\t' "$TIME" '\t' "$COMMAND"
    fi
done

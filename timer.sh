alarm="$HOME/.alarm.wav"
time="$1"
start="$SECONDS"
s=1

function main(){
    while [[ $s -gt 0 ]]
    do 
    s="$((time - (SECONDS - start)))"
    echo -ne "\r       \r"
    echo -ne "\r$s seconds left"
    sleep 1
    done
    echo -e "\nGAME OVER!!!"
    play "$alarm" 2>/dev/null

    exit 0
    }
main
#timeout [OPTION] DURATION COMMAND [ARG]..
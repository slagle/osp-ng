export TMUX_SESSION=${TMUX_SESSION:-"demo"}
export TMUX_PANE=${TMUX_PANE:-"${TMUX_SESSION}:0.0"}
export TYPE_DELAY=${TYPE_DELAY:-".1"}
export SLEEP=${SLEEP:-"1.5"}

sendsleep() {
    tmux send-keys -t ${TMUX_PANE} "$@"
    sleep $SLEEP
}

send() {
    tmux send-keys -t ${TMUX_PANE} "$@"
}

enter() {
    send ENTER
}

entersleep() {
    sendsleep ENTER
}

delay() {
    sleep $(echo "$TYPE_DELAY * .$(printf %02d $(shuf -i 1-99 -n 1))" | bc -l)
}

typn() {
    while read -n1 c; do
        if [ "$c" = "" ]; then
            tmux send-keys -t ${TMUX_PANE} Space
        else
            tmux send-keys -t ${TMUX_PANE} "$c"
        fi
        delay
    done < <(echo -n "$@")
}

typ() {
    typn $@
    entersleep
}


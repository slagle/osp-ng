export TMUX_SESSION=${TMUX_SESSION:-"demo"}
export TMUX_PANE=${TMUX_PANE:-"${TMUX_SESSION}:0.0"}
export TYPE_DELAY=${TYPE_DELAY:-".1"}
export SLEEP=${SLEEP:-"1.5"}
export PRE_ENTER_SLEEP=${PRE_ENTER_SLEEP:-"1"}
export POST_ENTER_SLEEP=${POST_ENTER_SLEEP:-"1"}
export SHOW_SLEEP=${SHOW_SLEEP:-"1"}


send() {
    tmux send-keys -t ${TMUX_PANE} "$@"
}

enter() {
    send ENTER
}

entersleep() {
    enter
    sleep ${POST_ENTER_SLEEP}
}

sleepenter() {
    sleep ${PRE_ENTER_SLEEP}
    enter
}

# delay - sleep a random delay up to ${TYPE_DELAY} seconds
delay() {
    sleep $(echo "$TYPE_DELAY * .$(printf %02d $(shuf -i 1-99 -n 1))" | bc -l)
}

# typn - type (with delay) characters. do not end with enter press
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

# typend - type a command, enter
typent () {
    typn $@
    enter
}

# types - type a command, enter, sleep
types() {
    # typn - type (with delay) characters. do not end with enter press
    typn $@
    # entersleep - press enter, then sleep ${POST_ENTER_SLEEP}
    entersleep
}

# typse - type a command, sleep, enter
typse() {
    # typn - type (with delay) characters. do not end with enter press
    typn $@
    # sleepenter - sleep ${PRE_ENTER_SLEEP}, then enter press
    sleepenter
}

# typss - type a command, sleep, enter, sleep
typses() {
    # typse - type a command, sleep, enter
    typse $@
    # sleep
    sleep ${SHOW_SLEEP}
}


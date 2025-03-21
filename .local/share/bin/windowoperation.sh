#!/bin/bash
while getopts ":c:e:w:m:" opts; do
    case "${opts}" in
    c)
        class=$OPTARG
        ;;
    e)
        exec=$OPTARG
        ;;
    w)
        workspace=$OPTARG
        ;;
    m)
        mode=$OPTARG
        ;;
    esac
done

# create appointed window or hide it
if [[ ! -z $class && ! -z $exec && ! -z $workspace ]]; then
    windowInfo=$(hyprctl clients -j | jq ".[] | select(.class ==\"$class\")")
    if [ -z $windowInfo ]; then
        windowInfo=$(hyprctl clients -j | jq ".[] | select(.initialClass ==\"$class\")")
    fi

    currentWindowPosition=$(echo $windowInfo | jq '.workspace.id')
    activeWorkSpace=$(hyprctl activeworkspace -j | jq '.id')
    pid=$(echo $windowInfo | jq ".pid")

    # move to workspace where the window is located
    if [[ ! -z $pid && "$mode" == "goto" ]]; then
        hyprctl dispatch workspace $workspace

    # move to hide window workspace if the window in the active workspace
    elif [[ $currentWindowPosition -eq $activeWorkSpace ]]; then
        hyprctl dispatch movetoworkspacesilent $workspace,pid:$pid

    # move to active workspace if the window in the hide window workspace or other workspace
    elif [[ $currentWindowPosition -eq $workspace || ! -z $pid ]]; then
        hyprctl dispatch movetoworkspacesilent $activeWorkSpace,pid:$pid
        hyprctl dispatch focuswindow pid:$pid

    # The window was neither created nor exists with hide window workspace then creating it
    else
        $exec
    fi
else
    # hide or show active window for only
    stack_file="/tmp/hide_window_pid_stack.txt"
    function hide_window() {
        activewindow=$(hyprctl activewindow -j)
        # Cannot hide thie window. because the window had "float" prefix window class
        if [ $(echo $activewindow | jq '.class' | grep -ic 'float') -eq 1 ]; then
            hyprctl notify 4 10000 "rgb(ff1ea3)" "Cannot hide thie window. because the window had \"float\" prefix window class!"
            exit
        fi

        pid=$(echo $activewindow | jq '.pid')
        [[ "$pid" -eq "null" ]] && exit
        hyprctl dispatch movetoworkspacesilent 88,pid:$pid && echo $pid >>$stack_file
    }

    function show_window() {
        pid=$(tail -1 $stack_file)
        current_workspace=$(hyprctl activeworkspace -j | jq '.id')
        hyprctl dispatch movetoworkspacesilent $current_workspace,pid:$pid
        hyprctl dispatch focuswindow pid:$pid
        sed -i '$d' $stack_file
    }

    if [ ! -z $1 ]; then
        if [ "$1" == "h" ]; then
            hide_window
        else
            show_window
        fi
    fi

fi

function fzfkill --description "finds and kills a process with fzf"
    set name (ps -Aco "comm=" | nodup | fzf)

    # if no process, return 
    if test -z "$name"
        commandline -f repaint
        return
    end

    # kill each process which matches the name exactly
    set lines (string split "\n" (ps -Aco "pid,comm"))
    for line in $lines
        set line (string trim "$line")
        if test "$name" = (_parse_token $line)
            set id (string split " " $line)[1]
            kill -9 $id
        end
    end

    commandline -f repaint
end


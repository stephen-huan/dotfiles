function _tmux --description "parses tmux ls"
  set s (tmux ls)
  for line in $s
    echo (string split ":" $line)[1]
  end
end

function fzftmux --description "selects a tmux session"
  set name (_tmux | fzf)
  if test -z "$name"
    commandline -f repaint
    return
  end

  tmux attach -t "$name"
  commandline -f repaint
end


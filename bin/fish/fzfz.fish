function fzfz --description "uses z to jump directories"
  # pipe z to fzf to get a file path
  set p (_z | fzf --preview '_preview_path {}')

  # if not a directory, return
  if not test -d "$p"; or test -z "$p"
    commandline -f repaint
    return
  end

  cd $p
  # update window
  commandline -f repaint
end

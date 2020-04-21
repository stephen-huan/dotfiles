function fzfz
  # pipe z to fzf to get a file path
  set l (z | tac | fzf --preview "_preview_path (_parse_z {})")
  set p (_parse_z $l)

  # if not a directory, return
  if ! test -d "$p"
    commandline -f repaint
    return
  end

  cd $p
  # update window
  commandline -f repaint
end

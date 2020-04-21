function fzfz
  # pipe z to fzf to get a file path
  set l (z | fzf --height 40% --preview "tree -C (_parse_z {})")
  set p (_parse_z $l)

  # if not a directory, return
  test -d "$p"
  if test $status -ne 0
    commandline -f repaint
    return
  end

  cd $p
  # update window
  commandline -f repaint
end

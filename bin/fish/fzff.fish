function fzff
  # get the current token on the command line
  set t (commandline -t)
  # use fzf to get a path
  set p (string escape (pwd))
  set result (find * | fzf --query $t --preview "_preview_path "$p"/{}")

  # if not a path, return
  if ! test -e "$result"
    commandline -f repaint
    return
  end

  # erase the current token, beacuse we're going to replace it
  commandline -t ""
  # insert the result into the command line
  commandline -it -- (string escape $result)
  # update window
  commandline -f repaint
end

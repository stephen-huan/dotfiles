function fzfd --description "uses fzf to get a path"
  # get the current token on the command line
  set t (commandline -t)
  # use fzf to get a path
  set result (_z | fzf --preview '_preview_path {}' --tiebreak=index)

  # if not a path, return
  if not test -d "$result"; or test -z "$result"
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

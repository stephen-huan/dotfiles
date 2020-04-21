function fzff
  # use fzf to get a file
  set result (pwd)"/"(fzf --height 40% --preview "bat --color always --style='changes,snip' "(pwd)"/{}")

  # if not a file, return
  test -e "$result"
  if test $status -ne 0
    commandline -f repaint
    return
  end

  # insert the result into the command line
  commandline -it -- (string escape $result)
  # update window
  commandline -f repaint
end

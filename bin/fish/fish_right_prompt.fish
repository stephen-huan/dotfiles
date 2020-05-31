function fish_right_prompt --description "formats the right side of the prompt"
  set_color $fish_color_autosuggestion 2> /dev/null; or set_color 555

  set time_str $CMD_DURATION_STR
  set now_str (date "+%H:%M:%S")

  # if no command ran, default to normal right prompt (time in grey)
  if not set -q CMD_DURATION_STR; or test -z "$CMD_DURATION_STR"
    set output_str "$now_str"
  else
    set_color $fish_command_timer_color
    set output_str "[ $time_str | $now_str ]"
  end

  echo -e $output_str
  set_color normal
end


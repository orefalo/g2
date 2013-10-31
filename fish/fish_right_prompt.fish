function fish_right_prompt
  set_color $fish_color_autosuggestion[1]
  set_color green
  printf (date "+$c2%H$c0:$c2%M$c0:$c2%S")
  set_color normal
end

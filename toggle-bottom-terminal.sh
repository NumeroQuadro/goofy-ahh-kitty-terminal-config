#!/bin/sh

tab_json="$(kitten @ ls --match-tab state:focused)" || exit 0

tab="$(printf '%s' "$tab_json" | jq -c '([.[].tabs[]][0]) // empty')"
[ -n "$tab" ] || exit 0

layout="$(printf '%s' "$tab" | jq -r '.layout // empty')"

bottom_id="$(
  printf '%s' "$tab" |
    jq -r '([.windows[]? | select(((.user_vars // {})["kitty_bottom_terminal"] // "") == "1") | .id] | last) // empty'
)"

main_id="$(
  printf '%s' "$tab" |
    jq -r '([.windows[]? | select(((.user_vars // {})["kitty_bottom_terminal"] // "") != "1") | .id] | first) // empty'
)"

[ -n "$layout" ] || exit 0

if [ -z "$bottom_id" ]; then
  kitten @ goto-layout splits
  kitten @ launch \
    --location=hsplit \
    --cwd=current \
    --bias=50 \
    --title='bottom terminal' \
    --var=kitty_bottom_terminal=1
  exit 0
fi

if [ "$layout" = "stack" ]; then
  kitten @ goto-layout splits
  kitten @ focus-window --match "id:$bottom_id"
  exit 0
fi

if [ -n "$main_id" ]; then
  kitten @ focus-window --match "id:$main_id"
else
  kitten @ focus-window --match num:0
fi
kitten @ goto-layout stack

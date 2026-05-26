#!/bin/sh

id="$(
  kitten @ select-window \
    --match all \
    --title 'Pick window / pane' \
    --reactivate-prev-tab=no
)" || exit 0

[ -n "$id" ] || exit 0
kitten @ focus-window --match "id:$id"

# geometry_status - show a symbol with error/success and root/non-root information

geometry_status() {
  local root; [[ $UID = 0 || $EUID = 0 ]] && root=true || root=false
  local error; (( $GEOMETRY_LAST_STATUS )) && error=true || error=false

  local color=${GEOMETRY_STATUS_COLOR:-default}

  if ( $error ); then color=${GEOMETRY_STATUS_COLOR_ERROR:-red}; else
    ( ${GEOMETRY_STATUS_SYMBOL_COLOR_HASH:=false} ) && {
      local colors=({1..9})

      (($(echotc Co) == 256)) && colors+=({17..230})

      if (( ${+GEOMETRY_STATUS_SYMBOL_COLOR_HASH_COLORS} )); then
        colors=(${GEOMETRY_STATUS_SYMBOL_COLOR_HASH_COLORS})
      fi

      local sum=0; for c in ${(s::)^HOST}; do ((sum += $(print -f '%d' "'$c"))); done

      local index=$(($sum % ${#colors}))

      [[ "$index" -eq 0 ]] && index=1

      color=${colors[${index}]}
    }
  fi

  ( $root && $error ) && ansi $color ${GEOMETRY_STATUS_SYMBOL_ROOT_ERROR:=▽} && return
  ( $root ) && ansi $color ${GEOMETRY_STATUS_SYMBOL_ROOT:-▼} && return
  ( $error ) && ansi $color ${GEOMETRY_STATUS_SYMBOL_ERROR:-△} && return
  ansi $color ${GEOMETRY_STATUS_SYMBOL:-▲}
}

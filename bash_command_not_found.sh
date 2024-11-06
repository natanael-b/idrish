function command_not_found_handle () {
    local OLDOLDPWD="${OLDPWD}"
    local LOCAL_SETUP="${XDG_DATA_HOME}"
    local HAS_IDRIS=true

    # Local XDG_DATA_HOME fallback
    if [ "${LOCAL_SETUP}" = "" ]; then
        LOCAL_SETUP="${HOME}/.local/share"
    fi

    # Idris setup lookup
    for dir in "${LOCAL_SETUP}/idris" "/usr/local/share/idris" "/usr/share/idris" "/var/share/idris"; do
        if [ -d "${dir}" ]; then
            cd "${dir}"
            HAS_IDRIS=true
            break
        fi
    done

    # Check for iasy5.4 or lua5.4
    for exec in "/usr/local/bin/iasy5.4" "/usr/bin/iasy5.4" "/usr/local/bin/lua5.4" "/usr/bin/lua5.4"; do
        if [ -x "${exec}" ]; then
            LUA_EXEC="${exec}"
            break
        fi
    done

    # Try Idris
    if ${HAS_IDRIS} && [ -n "${LUA_EXEC}" ]; then
        local command=$("${LUA_EXEC}" idris.lua --shell-output --lang="${LANG%.*}" "${@}")
        cd "${OLDPWD}"
        export OLDPWD="${OLDOLDPWD}"
        if [ -n "$command" ]; then
            eval "$command"
            return $?
        fi
    fi

    # Default command not found if Idris fails
    if [ -x /usr/lib/command-not-found ]; then
        /usr/lib/command-not-found -- "$1";
        return $?;
    else
        if [ -x /usr/share/command-not-found/command-not-found ]; then
            /usr/share/command-not-found/command-not-found -- "$1";
            return $?;
        else
            printf "%s: command not found\n" "$1" 1>&2;
            return 127;
        fi;
    fi
}


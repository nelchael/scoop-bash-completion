#!/usr/bin/env bash

function __scopp_completion_alias_list() {
    [[ -n "${SCOOP_COMPLETION_NO_LISTS}" ]] && return
    scoop alias list | sed '1,3d' | awk '{print $1}'
}

function __scopp_completion_bucket_list() {
    [[ -n "${SCOOP_COMPLETION_NO_LISTS}" ]] && return
    scoop bucket list | sed '1,3d' | awk '{print $1}'
}

function __scopp_completion_packages_list() {
    [[ -n "${SCOOP_COMPLETION_NO_LISTS}" ]] && return
    scoop list | sed '1,4d' | awk '{print $1}'
}

function __scopp_completion_shim_list() {
    [[ -n "${SCOOP_COMPLETION_NO_LISTS}" ]] && return
    scoop shim list | sed '1,3d' | awk '{print $1}'
}

function _scoop_completion() {
    case "${COMP_WORDS[1]}" in
        alias)
            if [[ "${COMP_CWORD}" == 2 ]]; then
                COMPREPLY=($(compgen -W "add list rm -v --verbose" -- "${COMP_WORDS[${COMP_CWORD}]}"))
            elif [[ "${COMP_WORDS[2]}" == "rm" ]]; then
                COMPREPLY=($(compgen -W "$(__scopp_completion_alias_list)" -- "${COMP_WORDS[${COMP_CWORD}]}"))
            fi
            ;;
        bucket)
            if [[ "${COMP_CWORD}" == 2 ]]; then
                COMPREPLY=($(compgen -W "add list known rm" -- "${COMP_WORDS[${COMP_CWORD}]}"))
            elif [[ "${COMP_WORDS[2]}" == "rm" ]]; then
                COMPREPLY=($(compgen -W "$(__scopp_completion_bucket_list)" -- "${COMP_WORDS[${COMP_CWORD}]}"))
            fi
            ;;
        cache)
            if [[ "${COMP_CWORD}" == 2 ]]; then
                COMPREPLY=($(compgen -W "show rm" -- "${COMP_WORDS[${COMP_CWORD}]}"))
            elif [[ "${COMP_WORDS[2]}" == "rm" ]]; then
                COMPREPLY=($(compgen -W "-a --all $(scoop cache show | sed '1,4d' | awk '{print $1}')" -- "${COMP_WORDS[${COMP_CWORD}]}"))
            fi
            ;;
        cat|depends|home|info|prefix)
            if [[ "${COMP_CWORD}" == 2 ]]; then
                COMPREPLY=($(compgen -W "$(__scopp_completion_packages_list)" -- "${COMP_WORDS[${COMP_CWORD}]}"))
            fi
            ;;
        checkup|create|list|search)
            :   # Nothing to suggest here...
            ;;
        cleanup)
            COMPREPLY=($(compgen -W "-a --all -g --global -k --cache $(__scopp_completion_packages_list)" -- "${COMP_WORDS[${COMP_CWORD}]}"))
            ;;
        config)
            :   # Skipped, for now...
            ;;
        download)
            COMPREPLY=($(compgen -W "-f --force -h --no-hash-check -u --no-update-scoop -a --arch" -- "${COMP_WORDS[${COMP_CWORD}]}"))
            ;;
        export)
            COMPREPLY=($(compgen -W "-c --config" -- "${COMP_WORDS[${COMP_CWORD}]}"))
            ;;
        help)
            if [[ "${COMP_CWORD}" == 2 ]]; then
                COMPREPLY=($(compgen -W "alias bucket cache cat checkup cleanup config create depends download export hold home import info install list prefix reset search shim status unhold uninstall update virustotal which" -- "${COMP_WORDS[${COMP_CWORD}]}"))
            fi
            ;;
        hold|unhold)
            COMPREPLY=($(compgen -W "-g --global $(__scopp_completion_packages_list)" -- "${COMP_WORDS[${COMP_CWORD}]}"))
            ;;
        import)
            if [[ "${COMP_CWORD}" == 2 ]]; then
                COMPREPLY=($(compgen -o defaults -- "${COMP_WORDS[${COMP_CWORD}]}"))
            fi
            ;;
        install)
            COMPREPLY=($(compgen -W "-g --global -i --independent -k --no-cache -u --no-update-scoop -s --skip -a --arch" -- "${COMP_WORDS[${COMP_CWORD}]}"))
            ;;
        reset)
            if [[ "${COMP_CWORD}" == 2 ]]; then
                COMPREPLY=($(compgen -W "-a --all $(__scopp_completion_packages_list)" -- "${COMP_WORDS[${COMP_CWORD}]}"))
            fi
            ;;
        shim)
            if [[ "${COMP_CWORD}" == 2 ]]; then
                COMPREPLY=($(compgen -W "add rm list info alter" -- "${COMP_WORDS[${COMP_CWORD}]}"))
            elif [[ "${COMP_WORDS[2]}" == "rm" || "${COMP_WORDS[2]}" == "info" ||"${COMP_WORDS[2]}" == "list" ]]; then
                COMPREPLY=($(compgen -W "$(__scopp_completion_shim_list)" -- "${COMP_WORDS[${COMP_CWORD}]}"))
            fi
            ;;
        status)
            COMPREPLY=($(compgen -W "-l --local" -- "${COMP_WORDS[${COMP_CWORD}]}"))
            ;;
        uninstall)
            COMPREPLY=($(compgen -W "-g --global -p --purge $(__scopp_completion_packages_list)" -- "${COMP_WORDS[${COMP_CWORD}]}"))
            ;;
        update)
            COMPREPLY=($(compgen -W "-f --force -g --global -i --independent -k --no-cache -s --skip -q --quiet -a --all $(__scopp_completion_packages_list)" -- "${COMP_WORDS[${COMP_CWORD}]}"))
            ;;
        virustotal)
            COMPREPLY=($(compgen -W "-a --all -s --scan -n --no-depends -u --no-update-scoop -p --passthru $(__scopp_completion_packages_list)" -- "${COMP_WORDS[${COMP_CWORD}]}"))
            ;;
        which)
            COMPREPLY=($(compgen -W "$(__scopp_completion_shim_list)" -- "${COMP_WORDS[${COMP_CWORD}]}"))
            ;;
        *)
            COMPREPLY=($(compgen -W "alias bucket cache cat checkup cleanup config create depends download export help hold home import info install list prefix reset search shim status unhold uninstall update virustotal which" -- "${COMP_WORDS[${COMP_CWORD}]}"))
            ;;
    esac
}

complete -F _scoop_completion scoop

#!/bin/bash
# finder.sh arguments:
#   filesdir: Path to a directory on the filesystem.
#   searchstr: Text string to search within these files

function finder {
    if [[ $# -ne 2 ]]; then
        >&2 echo "ERROR: Incorrect argument count. EXPECTED='2' ACTUAL='$#'"
        >&2 echo "USAGE: finder.sh filesdir searchstr"
        return 1
    fi
    local -r filesdir="${1}"
    local -r searchstr="${2}"
    local matching_filenames
    local file_count
    local line_count

    if [[ ! -d "${filesdir}" ]]; then
        >&2 echo "ERROR: directory '${filesdir}' does not exist."
        return 1
    fi

    matching_filenames="$(grep -rlI "${searchstr}" ${filesdir/%\//}/*)"
    # Count num matching files
    file_count="$(echo -n "${matching_filenames}" | grep -c '^')"
    # Count num matching lines
    line_count=0
    for file in ${matching_filenames}
    do
        ((line_count += "$(grep "${searchstr}" "${file}" | wc -l)"))
    done

    echo "The number of files are ${file_count} and the number of matching lines are ${line_count}"
}

finder "$@"
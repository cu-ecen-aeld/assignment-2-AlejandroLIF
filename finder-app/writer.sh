#!/bin/bash
# writer.sh arguments
#   writefile: full path to a file (including filename)
#   writestr: text string to write to this file
#             (creates a new file if file does not exist)

function writer {
    if [[ $# -ne 2 ]]; then
        >&2 echo "ERROR: Incorrect argument count. EXPECTED='2' ACTUAL='$#'"
        >&2 echo "USAGE: writer.sh writefile writestr"
        return 1
    fi
    local -r writefile="${1}"
    local -r writestr="${2}"
    local directory
    local filename

    # directory + filename matching rules
    #   A trailing / signals a directory.
    #       Error: writefile must not be a directory
    #   Everything after the last / is the filename.
    #       Success.
    #   If the filename matches an existing directory name, the command fails.
    #       Error: filename matches existing directory.
    #   The directory name is everything but the filename.
    directory="$(echo "${writefile}" | grep -Po "^(\/?(?:[^\/]+\/)*)*" )"
    filename="$(echo "${writefile}" | grep -Po "([^\/]+)$" )"
    if [[ "${#filename}" -eq 0 ]]; then
        >&2 echo "ERROR: Invalid writefile. DIRECTORY='${directory}' FILENAME='${filename}'"
        return 1
    fi
    if [[ ! -d "${directory}" ]]; then
        mkdir -p "${directory}" || {
            >&2 echo "ERROR: failed to create directory '${directory}'"
            return 1
        }
    fi
    echo "${writestr}" > "${writefile}" || {
        >&2 echo "ERROR: failed to write to file '${writefile}'"
        return 1
    }
}

writer "$@"
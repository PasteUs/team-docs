#!/usr/bin/env sh

PYTHON=python

if [ which ${PYTHON} > /dev/null 2>&1 ]; then
    echo "No Python!"
else
    if [[ $(${PYTHON} -c 'import sys; print(sys.version_info[0])') == "3" ]]; then
        ${PYTHON} -m http.server 3000
    else
        ${PYTHON} -m SimpleHTTPServer 3000
    fi
fi


#! /bin/bash

set -e
set -o xtrace

source container/vars.sh

function abs_path {
    local IN_FILE="$1"

    python -c "import os; print (os.path.abspath('${IN_FILE}'))"
}

docker run -p 9099:80 -v `abs_path ./my-html`:/usr/share/nginx/html -t ${IMAGE_NAME}

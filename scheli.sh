#!/usr/bin/bash

# get variables from environment
SC_HOST=${SC_HOST:-localhost}
SLINK_HOST=${SLINK_HOST:-localhost}
DEBUG=${DEBUG:-}
INVENTORY=${INVENTORY:-inventory.xml}
INTERVAL=${INTERVAL:-30}
XRES=${XRES:-1024}
YRES=${YRES:-768}
TEMPLATE=${TEMPLATE:-"%N/%S.png"}

export SC_HOST

# run scheli
seiscomp exec scheli capture ${DEBUG} --interval ${INTERVAL} \
    --xres ${XRES} -yres ${YRES} --offline \
    -o output/${TEMPLATE} \
    -I "combined://slink/${SLINK_HOST}:18000;sdsarchive//opt/seiscomp/var/lib/archive" \
    --inventory-db ${INVENTORY}

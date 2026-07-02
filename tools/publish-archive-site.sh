#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
SITE_DIR=${SITE_DIR:-"$ROOT_DIR/standalone-site"}
ARCHIVE_DIR=${ARCHIVE_DIR:-"/home/peter/Sites/peterpolidoro/projects.peterpolidoro.net/janelia/y-arena"}

"$ROOT_DIR/tools/build-standalone-site.sh"
rsync -a --delete --exclude '/repos' "$SITE_DIR"/ "$ARCHIVE_DIR"/
"$ROOT_DIR/tools/publish-related-archives.sh"

printf 'Site written to %s\n' "$ARCHIVE_DIR"

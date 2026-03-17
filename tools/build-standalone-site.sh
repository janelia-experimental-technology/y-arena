#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")/.." && pwd)
VENV_DIR=${VENV_DIR:-"$ROOT_DIR/.venv-docs"}
SITE_DIR=${SITE_DIR:-"$ROOT_DIR/standalone-site"}

python3 -m venv "$VENV_DIR"
"$VENV_DIR/bin/python" -m pip install --upgrade pip
"$VENV_DIR/bin/python" -m pip install -r "$ROOT_DIR/requirements-docs.txt"
"$VENV_DIR/bin/python" -m mkdocs build --clean -f "$ROOT_DIR/mkdocs-standalone.yml" -d "$SITE_DIR"

touch "$SITE_DIR/.nojekyll"
printf 'Standalone site written to %s\n' "$SITE_DIR"

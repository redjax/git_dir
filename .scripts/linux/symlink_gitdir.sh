#!/usr/bin/env bash
set -euo pipefail

THIS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
GITDIR_ROOT=$(realpath -m "${THIS_DIR}/../..")

LINK_SRC="${GITDIR_ROOT}"
LINK_DEST="$HOME/git"

function usage() {
  echo ""
  echo "${0} [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  -t, --sync-target  Target/destination path where this directory will be symlinked."
  echo "  -h, --help         Print this help menu"
  echo ""
}

while [[ $# -gt 0 ]]; do
  case $1 in
    -t|--sync-target)
      if [[ -z "${2:-}" ]]; then
        echo "[ERROR] --sync-target provided, but no target path given."
        usage
        exit 1
      fi
      LINK_DEST="$2"
      shift 2
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "[ERROR] Invalid argument: $1"
      usage
      exit 1
      ;;
  esac
done

if [[ -z "${LINK_SRC}" ]]; then
  echo "[ERROR] Failed setting link source."
  exit 1
fi

if [[ -z "${LINK_DEST}" ]]; then
  echo "[ERROR] Failed setting link destination."
  exit 1
fi

## Exit if the destination already exists
if [[ -e "$LINK_DEST" ]]; then
    echo "[ERROR] Destination path already exists: $LINK_DEST"
    exit 1
fi

echo "Creating symlink:"
echo "  Source: ${LINK_SRC}"
echo "  Destination: ${LINK_DEST}"

## Create the symlink
if ! ln -s "$LINK_SRC" "$LINK_DEST" 2>&1; then
  echo ""
  echo "[ERROR] Failed creating symlink."
  echo "        Source: ${LINK_SRC}"
  echo "        Destination: ${LINK_DEST}"

  exit $?
else
  echo ""
  echo "[INFO] Symlink created: $LINK_DEST -> $LINK_SRC"
fi

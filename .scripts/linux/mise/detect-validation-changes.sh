#!/usr/bin/env bash
set -euo pipefail

##################################################
# Determines if the Mise config file has changed #
#                                                #
# Used as a pipeline check.                      #
##################################################

usage() {
  echo "Usage: $0 <base-ref> <head-ref>" >&2
}

if [[ "$#" -ne 2 ]]; then
  usage
  exit 2
fi

base_ref="$1"
head_ref="$2"

if ! repo_root="$(git rev-parse --show-toplevel)"; then
  echo "ERROR: run this script from inside the git_dir repository." >&2
  exit 1
fi

cd "$repo_root"

watched_paths=(
  ".mise.toml"
  ".containers/ci/mise.Dockerfile"
  ".scripts/linux/mise/detect-validation-changes.sh"
)

{
  echo "Checking mise validation paths:"
  printf '  %s\n' "${watched_paths[@]}"
  echo
  echo "Base ref: $base_ref"
  echo "Head ref: $head_ref"
  echo
} >&2

if changed_files="$(
  git diff \
    --name-only \
    "${base_ref}...${head_ref}" \
    -- \
    "${watched_paths[@]}"
)"; then
  if [[ -n "$changed_files" ]]; then
    {
      echo "Decision: Mise Docker validation WILL RUN."
      echo "Reason: these validation files changed:"
      echo
      printf '%s\n' "[+] $changed_files"
    } >&2

    printf 'true\n'
  else
    {
      echo "Decision: Mise Docker validation will NOT RUN."
      echo "Reason: none of the watched validation files changed."
    } >&2

    printf 'false\n'
  fi
else
  status=$?

  echo "ERROR: failed to determine changed files (exit code $status)." >&2
  exit "$status"
fi

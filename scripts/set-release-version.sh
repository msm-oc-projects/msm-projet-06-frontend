#!/usr/bin/env bash
set -euo pipefail

version="${1:?version is required}"

npm version "${version}" --no-git-tag-version

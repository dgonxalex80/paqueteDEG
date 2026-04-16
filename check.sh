#!/usr/bin/env bash
set -euo pipefail

PKG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$PKG_DIR"

PKG_NAME=$(awk -F': *' '$1=="Package"{print $2}' DESCRIPTION)
PKG_VERSION=$(awk -F': *' '$1=="Version"{print $2}' DESCRIPTION)
TARBALL="${PKG_NAME}_${PKG_VERSION}.tar.gz"

echo "==> Building ${TARBALL}"
R CMD build .

echo "==> Checking ${TARBALL}"
R CMD check --no-manual "$TARBALL"

echo "==> Done"

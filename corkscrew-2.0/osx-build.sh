#! /bin/sh

#  osx-build.sh
#  Secure Pipes
#
#  Created by Timothy Stonis on 11/12/14.
#  Copyright (c) 2014 Timothy Stonis. All rights reserved.

set -eu

if [ "${1:-}" = clean ]; then
  rm -f corkscrew
  exit 0
fi

set -- xcrun --sdk macosx clang -DHAVE_CONFIG_H -I. -std=gnu99 -O2 corkscrew.c -o corkscrew
for arch in ${ARCHS:-arm64}; do
  set -- "$@" -arch "$arch"
done
exec "$@"

#!/bin/sh

set -e

echo "===> Building eam_gl"
gleam build --target javascript

echo "===> Copying files to build/dist"
mkdir -p build/dist
cp -r src/index.html build/dist/

echo "===> Creating bundle for browser"
npm install
npm run build

echo "===> Done! Open build/dist/index.html in your browser to see the result."

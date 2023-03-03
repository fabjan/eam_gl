#!/bin/sh

echo "===> Building eam_gl"
gleam build --target javascript

echo "===> Copying files to build/dist"
mkdir -p build/dist
cp -r src/index.html build/dist/

echo "===> Creating bundle for browser"
npm install
rollup build/dev/javascript/eam_gl/eam_gl.mjs --name eam_gl --file build/dist/eam_gl.js --format iife

echo "===> Done! Open build/dist/index.html in your browser to see the result."

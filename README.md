# eam_gl

A "game" I guess.

Based on https://developer.mozilla.org/en-US/docs/Web/API/WebGL_API/By_example/Raining_rectangles

## Requirements

- [Gleam]
- [Node]
- [rollup.js]

[Gleam]: https://gleam.run
[Node]: https://nodejs.org/en/download/
[rollup.js]: https://rollupjs.org

## Quick start

```sh
./build.sh                 # Build the project
open build/dist/index.html # Play the game
```

## Details

This Gleam project targets JavaScript to leverage WebGL for interactivity.
Rollup is used to bundle the compiled javascript modules for use in a browser.

The FFI code in eam_gl_ffi.mjs is responsible for running the game loop (via
`requestAnimationFrame`). It also provides functions for mutating a WebGL
context.

The Gleam code provides game loop callbacks when it starts the game.

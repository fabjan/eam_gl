import gleam/int
import eam_gl/ffi.{GL, console_log, gl_clear, gl_clear_color}

type GameState {
  GameState(debug: DebugInfo)
}

type DebugInfo {
  DebugInfo(clicks: Int, frames: Int)
}

pub fn main() {
  let debug = DebugInfo(0, 0)
  ffi.start(GameState(debug), handle_frame, handle_click)
}

fn handle_click(state: GameState, _: GL, x: Int, y: Int) -> GameState {
  let debug = debug_click(state.debug, x, y)
  debug_log(debug)

  GameState(debug)
}

fn handle_frame(state: GameState, gl: GL) -> GameState {
  let debug = debug_frame(state.debug)
  gl_clear_color(gl, 0.0, 0.0, 0.0, 1.0)
  gl_clear(gl)
  GameState(debug)
}

fn debug_click(debug: DebugInfo, x: Int, y: Int) -> DebugInfo {
  console_log("click at " <> str(x) <> ", " <> str(y))
  DebugInfo(debug.clicks + 1, debug.frames)
}

fn debug_frame(debug: DebugInfo) -> DebugInfo {
  DebugInfo(debug.clicks, debug.frames + 1)
}

fn debug_log(debug: DebugInfo) {
  console_log(
    "clicks: " <> str(debug.clicks) <> ", frames: " <> str(debug.frames),
  )
}

fn str(i: Int) -> String {
  int.to_string(i)
}

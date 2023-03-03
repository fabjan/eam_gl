import gleam/float
import gleam/int
import gleam/option.{None, Option, Some}
import eam_gl/ffi.{
  GL, console_log, gl_buffer_dimensions, gl_clear, gl_clear_color, gl_scissor,
}

type Rectangle {
  Rectangle(x: Int, y: Int, width: Int, height: Int, velocity: Int)
}

type GameState {
  GameState(debug: DebugInfo, raining_rectangle: Option(Rectangle))
}

type DebugInfo {
  DebugInfo(clicks: Int, frames: Int)
}

pub fn main() {
  let debug = DebugInfo(0, 0)
  ffi.start(GameState(debug, None), handle_frame, handle_click)
}

fn handle_click(state: GameState, _: GL, x: Int, y: Int) -> GameState {
  let state = debug_click(state, x, y)
  debug_log(state)

  let click_hit =
    option.map(state.raining_rectangle, fn(rect) { hit(rect, x, y) })

  let state = case click_hit {
    Some(True) -> {
      console_log("hit!")
      GameState(state.debug, None)
    }
    _ -> state
  }

  state
}

fn handle_frame(state: GameState, gl: GL) -> GameState {
  let state = debug_frame(state)

  let state = spawn_rectangle_if_none(state, gl)
  let state = move_rectangle(state, gl)

  draw_rectangle_if_some(state, gl)

  state
}

fn hit(rect: Rectangle, x: Int, y: Int) -> Bool {
  let x_in = rect.x < x && x < rect.x + rect.width
  let y_in = rect.y < y && y < rect.y + rect.height
  x_in && y_in
}

fn draw_rectangle_if_some(state: GameState, gl: GL) -> Nil {
  case state.raining_rectangle {
    None -> Nil
    Some(rect) -> {
      gl_scissor(gl, rect.x, rect.y, rect.width, rect.height)
      gl_clear(gl)
    }
  }
}

fn spawn_rectangle_if_none(state: GameState, gl: GL) -> GameState {
  case state.raining_rectangle {
    Some(_) -> state
    None -> {
      let #(canvas_w, canvas_h) = gl_buffer_dimensions(gl)
      let w = int.random(100, 200)
      let h = int.random(100, 200)
      let x = int.random(0, canvas_w - w)
      let y = canvas_h
      let v = int.random(1, 7)
      let rect = Rectangle(x, y, w, h, v)

      let r = float.random(0.0, 1.0)
      let g = float.random(0.0, 1.0)
      let b = float.random(0.0, 1.0)
      // global mutable state, nice!
      gl_clear_color(gl, r, g, b, 1.0)

      GameState(state.debug, Some(rect))
    }
  }
}

fn move_rectangle(state: GameState, gl: GL) -> GameState {
  case state.raining_rectangle {
    None -> state
    Some(rect) -> {
      let #(_, canvas_h) = gl_buffer_dimensions(gl)
      let rect =
        Rectangle(
          rect.x,
          rect.y - rect.velocity,
          rect.width,
          rect.height,
          rect.velocity,
        )
      case canvas_h < 0 - rect.y {
        True -> GameState(state.debug, None)
        False -> GameState(state.debug, Some(rect))
      }
    }
  }
}

fn debug_click(state: GameState, x: Int, y: Int) -> GameState {
  let DebugInfo(clicks, frames) = state.debug
  console_log("click at " <> str(x) <> ", " <> str(y))

  GameState(DebugInfo(clicks + 1, frames), state.raining_rectangle)
}

fn debug_frame(state: GameState) -> GameState {
  let DebugInfo(clicks, frames) = state.debug
  GameState(DebugInfo(clicks, frames + 1), state.raining_rectangle)
}

fn debug_log(state: GameState) {
  let DebugInfo(clicks, frames) = state.debug
  console_log("clicks: " <> str(clicks) <> ", frames: " <> str(frames))

  case state.raining_rectangle {
    None -> console_log("no rectangle")
    Some(rect) ->
      console_log("rectangle at " <> str(rect.x) <> ", " <> str(rect.y))
  }
}

fn str(i: Int) -> String {
  int.to_string(i)
}

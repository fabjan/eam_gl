pub external type GL

pub external fn start(
  state: a,
  on_frame: fn(a, GL) -> a,
  on_click: fn(a, GL, Int, Int) -> a,
) -> GL =
  "../eam_gl_ffi" "start"

pub external fn gl_clear(gl: GL) -> Nil =
  "../eam_gl_ffi" "glClear"

pub external fn gl_clear_color(
  gl: GL,
  r: Float,
  g: Float,
  b: Float,
  a: Float,
) -> Nil =
  "../eam_gl_ffi" "glClearColor"

pub external fn gl_scissor(gl: GL, x: Int, y: Int, w: Int, h: Int) -> Nil =
  "../eam_gl_ffi" "glScissor"

pub external fn gl_buffer_dimensions(gl: GL) -> #(Int, Int) =
  "../eam_gl_ffi" "glBufferDimensions"

pub external fn console_log(s: String) -> Nil =
  "../eam_gl_ffi" "consoleLog"

pub external fn set_elem_text(selector: String, text: String) -> Nil =
  "../eam_gl_ffi" "setElemText"

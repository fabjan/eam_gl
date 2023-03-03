let userState = null; // global mutable state, my favorite
let userOnAnimationFrame = null;
let userOnClick = null;

export function consoleLog(msg) {
    console.log(msg);
}

export function setElemText(selector, text) {
  const elem = document.querySelector(selector);
  elem.innerText = text;
}

export function start(
    state,
    handleFrame,
    handleClick,
  ) {
  const canvas = document.querySelector("canvas.eam_gl");
  const gl = canvas.getContext("webgl");

  if (!gl) {
    alert("WebGL not supported");
    return null;
  }

  userState = state;
  userOnAnimationFrame = handleFrame;
  userOnClick = handleClick;

  gl.enable(gl.SCISSOR_TEST);
  canvas.addEventListener("click", (evt) => onCanvasClick(gl, evt), false);
  requestAnimationFrame(() => onAnimationFrame(gl));
}

export function glBufferDimensions(gl) {
  return [gl.drawingBufferWidth, gl.drawingBufferHeight];
}

export function glClear(gl) {
  gl.clear(gl.COLOR_BUFFER_BIT);
}

export function glScissor(gl, x, y, width, height) {
  gl.scissor(x, y, width, height);
}

export function glClearColor(gl, r, g, b, a) {
  gl.clearColor(r, g, b, a);
}

function onAnimationFrame(gl) {
  if (gl && userOnAnimationFrame) {
    userState = userOnAnimationFrame(userState, gl);
  }
  requestAnimationFrame(() => onAnimationFrame(gl));
}

function onCanvasClick(gl, evt) {
  const canvasX = evt.pageX - evt.target.offsetLeft;
  const canvasY = gl.drawingBufferHeight - (evt.pageY - evt.target.offsetTop);

  if (userOnClick) {
    userState = userOnClick(userState, gl, canvasX, canvasY);
  }
}

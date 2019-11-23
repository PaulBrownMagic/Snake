//const store = { snake: [], apple: {x: 0, y: 0}, gameover: true, tile_count: 32 }

const socket = new WebSocket('ws://localhost:8000/socket');

socket.onopen = function (e) {
    socket.send('refresh')
}

socket.onmessage = function (e) {
    const json = e.data
    if (json) {
        Object.assign(store, $.parseJSON(json))
    }
    else {
        console.log("ERROR: Bad Data")
    }
}

function move() {
    if (socket.readyState == 1) {
        socket.send("move")
    }
}

function setup(){
    store.canvas_size = Math.min(windowWidth, windowHeight-300)
    store.gameover = false
    frameRate(10)
    createCanvas(store.canvas_size, store.canvas_size)
    textAlign(CENTER)
}

function windowResized() {
    store.canvas_size = Math.min(windowWidth, windowHeight-300)
    resizeCanvas(store.canvas_size, store.canvas_size)
}

function draw() {
    if (!store.gameover) {
        move()
    }
        background("#073642")
        draw_apple()
        draw_snake()
    if (store.gameover) {
        draw_gameover()
    }
}

function draw_apple() {
    const tile_width = store.canvas_size / store.tile_count
    const x = store.apple.x * tile_width - (tile_width/2)
    const y = store.apple.y * tile_width - (tile_width/2)
    fill("red")
    ellipse(x, y, tile_width)
}

function draw_snake() {
    const tile_width = store.canvas_size / store.tile_count
    fill("green")
    for (const segment of store.snake) {
        rect(segment.x * tile_width - tile_width, segment.y * tile_width - tile_width, tile_width, tile_width)
    }
}

function draw_gameover() {
    fill(50, 0.8)
    rect(0, 0, width, height)
    fill("red")
    textSize(40)
    text("Game Over", width/2, height/4)
    textSize(30)
    text("Play again?", width/2, 3*height/4)
}

function keyPressed() {
  switch (keyCode) {
      case LEFT_ARROW:
        socket.send("left")
        break;
      case RIGHT_ARROW:
        socket.send("right")
        break;
      case UP_ARROW:
        socket.send("up")
        break;
      case DOWN_ARROW:
        socket.send("down")
        break;
      case 72: // H
        socket.send("left")
        break;
      case 76: // L
        socket.send("right")
        break;
      case 75: // K
        socket.send("up")
        break;
      case 74: // J
        socket.send("down")
        break;
  }
  return false
}

function mousePressed() {
    if (store.gameover) {
        socket.send("start")
    }
}

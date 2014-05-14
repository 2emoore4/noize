<<<<<<< HEAD
stage = new PIXI.Stage 0xECF0F1
=======
# I used PIXI.js originally because it handles sprites well
# I'll be making the transition to hook directly into webgl
stage = new PIXI.Stage 0xFFFFFF
>>>>>>> 002b45782834d74f77de995187110f5d8914ce2c

w = 630
h = 400

renderer = new PIXI.WebGLRenderer w, h, null, null, true
graphics = new PIXI.Graphics
drawing_renderer = new UTIL.renderer(graphics, w, h)

noise.seed(Math.random())

square = null
init = false
window.fish_init = () ->
    if !init
        document.getElementById("fish").appendChild renderer.view

        square = new FISH.fish()
        window.fish = square
        vec3.set(square.states["default"].scale_vec, 1, 1, 1)
        drawing_renderer.world.add(square)

        stage.addChild graphics

        setInterval render_graphics, 60
        requestAnimationFrame animate

        init = true

# runs at interval defined above. this is where all 3d stuff happens.
render_graphics = () ->
    graphics.clear()
    graphics.lineStyle 3, 0x5c6274

    drawing_renderer.render_world()

animate = () ->
    square.do_stuff()
    renderer.render stage
    requestAnimationFrame animate

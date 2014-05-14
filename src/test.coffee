stage = new PIXI.Stage 0xECF0F1

w = 630
h = 400

renderer = new PIXI.WebGLRenderer w, h, null, null, true
graphics = new PIXI.Graphics
drawing_renderer = new UTIL.renderer(graphics, w, h)
window.r = drawing_renderer

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

render_graphics = () ->
    graphics.clear()
    graphics.lineStyle 3, 0x5c6274

    drawing_renderer.render_world()

animate = () ->
    square.do_stuff()
    renderer.render stage
    requestAnimationFrame animate

stage = new PIXI.Stage 0xFFFFFF

w = 688
h = 480

renderer = new PIXI.WebGLRenderer w, h, null, null, true
graphics = new PIXI.Graphics
drawing_renderer = new UTIL.renderer(graphics, w, h)
window.r = drawing_renderer

noise.seed(Math.random())

square = null
init = () ->
    document.body.appendChild renderer.view

    square = new UTIL.geometry_2d().regular_polygon(500)
    vec3.set(square.states["default"].scale_vec, 1, 1, 1)
    square.reset_state()
    drawing_renderer.world.add(square)

    stage.addChild graphics

    setInterval render_graphics, 60
    requestAnimationFrame animate

render_graphics = () ->
    graphics.clear()
    graphics.lineStyle 3, 0x5c6274

    drawing_renderer.render_world()

animate = () ->
    square.rotate_y(0.01)
    square.rotate_x(0.01)
    renderer.render stage
    requestAnimationFrame animate

window.onkeydown = (event) ->
    console.log(event.which)
    switch event.which
        when 37
            drawing_renderer.rotate_y(0.05)
        when 38
            drawing_renderer.rotate_x(-0.05)
        when 39
            drawing_renderer.rotate_y(-0.05)
        when 40
            drawing_renderer.rotate_x(0.05)
        when 88
            drawing_renderer.translate(0, 0, 1)
        when 90
            drawing_renderer.translate(0, 0, -1)

init()

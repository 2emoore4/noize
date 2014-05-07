# I used PIXI.js originally because it handles sprites well
# I'll be making the transition to hook directly into webgl
stage = new PIXI.Stage 0xFFFFFF

w = 688
h = 480

renderer = new PIXI.WebGLRenderer w, h, null, null, true
graphics = new PIXI.Graphics
drawing_renderer = new UTIL.renderer(graphics, w, h)

noise.seed(Math.random())

square = null
init = () ->
    document.body.appendChild renderer.view

    square = new UTIL.geometry_2d().regular_polygon(10)
    # this whole state thing is necessary due to bugs. will fix.
    vec3.set(square.states["default"].scale_vec, 1, 1, 1)
    square.reset_state()
    drawing_renderer.world.add(square)

    stage.addChild graphics

    setInterval render_graphics, 60
    requestAnimationFrame update

# runs at interval defined above. this is where all 3d stuff happens.
render_graphics = () ->
    graphics.clear()
    graphics.lineStyle 3, 0x5c6274

    drawing_renderer.render_world()

# rotates polygons and draws
update = () ->
    square.rotate_y(0.01)
    square.rotate_x(0.01)
    renderer.render stage
    requestAnimationFrame update

init()

stage = new PIXI.Stage 0xFFFFFF

w = 688
h = 480

renderer = new PIXI.WebGLRenderer w, h, null, null, true
graphics = new PIXI.Graphics
drawing_renderer = new UTIL.renderer(graphics, w, h)
window.r = drawing_renderer

cube = new UTIL.geometry().cube()
cylinder = new UTIL.geometry().cylinder()
cylinder.rotate_x(Math.PI / 2)
cylinder.translate(0, 0, 2)
cube.add(cylinder)
drawing_renderer.world.add(cube)

init = () ->
    document.body.appendChild renderer.view

    init_bg()
    init_house()
    init_ground()

    stage.addChild graphics

    setInterval render_graphics, 150
    requestAnimationFrame animate

paper_current = 0
paper_textures = new Array
paper_sprite = null
init_bg = () ->
    paper_textures.push PIXI.Texture.fromImage "assets/paper0.png"
    paper_textures.push PIXI.Texture.fromImage "assets/paper1.png"
    paper_textures.push PIXI.Texture.fromImage "assets/paper2.png"
    paper_textures.push PIXI.Texture.fromImage "assets/paper3.png"

    paper_sprite = new PIXI.Sprite paper_textures[paper_current]
    stage.addChild paper_sprite

next_bg = () ->
    paper_current += 1

    if paper_current is paper_textures.length
        paper_current = 0

    paper_sprite.setTexture paper_textures[paper_current]

house = null
init_house = () ->
    house = new UTIL.geometry_2d()

    body = new UTIL.geometry_2d()
    body.vertices.push  [400, 300]
    body.vertices.push  [494, 295]
    body.vertices.push  [500, 404]
    body.vertices.push  [398, 400]
    body.vertices.push  [400, 300]
    house.add body

    roof = new UTIL.geometry_2d()
    roof.vertices.push  [400, 300]
    roof.vertices.push  [450, 250]
    roof.vertices.push  [494, 295]
    roof.vertices.push  [400, 300]
    house.add roof

    door = new UTIL.geometry_2d()
    door.vertices.push  [435, 400]
    door.vertices.push  [435, 325]
    door.vertices.push  [465, 325]
    door.vertices.push  [465, 400]
    house.add door

    drawing_renderer.world.add(house)

ground = null
init_ground = () ->
    ground = new UTIL.geometry_2d()

    ground.vertices.push([0, 400])
    ground.vertices.push([688, 405])

    drawing_renderer.world.add(ground)

render_graphics = () ->
    graphics.clear()
    graphics.lineStyle 3, 0x5c6274
    next_bg()

    cube.rotate_x(0.05)

    drawing_renderer.rotate_y(0.01)

    drawing_renderer.render_world()

animate = () ->
    renderer.render stage
    requestAnimationFrame animate

init()

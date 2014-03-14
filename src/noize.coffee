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
    body.add_vertex  [-1, 2]
    body.add_vertex  [1, 2]
    body.add_vertex  [1, 0]
    body.add_vertex  [-1, 0]
    body.add_vertex  [-1, 2]
    house.add body

    roof = new UTIL.geometry_2d()
    roof.add_vertex  [-1, 0]
    roof.add_vertex  [0, -1]
    roof.add_vertex  [1, 0]
    roof.add_vertex  [-1, 0]
    house.add roof

    door = new UTIL.geometry_2d()
    door.add_vertex  [-0.3, 2]
    door.add_vertex  [-0.3, 0.5]
    door.add_vertex  [0.3, 0.5]
    door.add_vertex  [0.3, 2]
    house.add door

    house.translate(4, 0, 0)
    drawing_renderer.world.add(house)

ground = null
init_ground = () ->
    ground = new UTIL.geometry_2d()

    ground.add_vertex([-8, 2])
    ground.add_vertex([8, 2])

    drawing_renderer.world.add(ground)

render_graphics = () ->
    graphics.clear()
    graphics.lineStyle 3, 0x5c6274
    next_bg()

    cube.rotate_x(0.05)
    house.rotate_y(0.2)

    drawing_renderer.render_world()

animate = () ->
    renderer.render stage
    requestAnimationFrame animate

init()

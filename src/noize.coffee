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
cube.translate(-4, 0, 0)
drawing_renderer.world.add(cube)

init = () ->
    document.body.appendChild renderer.view

    init_bg()
    init_house()
    init_ground()
    init_person()

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

person = null
init_person = () ->
    person = new UTIL.geometry_2d()

    r_leg = new UTIL.geometry_2d()
    r_leg.add_vertex([0, 1])
    r_leg.add_vertex([0.2, 1.5])
    r_leg.add_vertex([0.25, 1.9])
    person.add(r_leg)

    r_foot = new UTIL.geometry_2d()
    r_foot.add_vertex([0.25, 1.9])
    r_foot.add_vertex([0.4, 1.95])
    r_leg.add(r_foot)

    l_leg = new UTIL.geometry_2d()
    l_leg.add_vertex([0, 1])
    l_leg.add_vertex([0.05, 1.5])
    l_leg.add_vertex([0.1, 1.9])
    person.add(l_leg)

    l_foot = new UTIL.geometry_2d()
    l_foot.add_vertex([0.1, 1.9])
    l_foot.add_vertex([0.25, 1.95])
    l_leg.add(l_foot)

    torso = new UTIL.geometry_2d()
    torso.add_vertex([0, 1])
    torso.add_vertex([0, 0.4])
    person.add(torso)

    l_arm = new UTIL.geometry_2d()
    l_arm.add_vertex([0, 0.41])
    l_arm.add_vertex([-0.2, 0.7])
    torso.add(l_arm)

    l_fore = new UTIL.geometry_2d()
    l_fore.add_vertex([-0.2, 0.7])
    l_fore.add_vertex([-0.2, 0.9])
    l_arm.add(l_fore)

    r_arm = new UTIL.geometry_2d()
    r_arm.add_vertex([0, 0.41])
    r_arm.add_vertex([0.2, 0.7])
    torso.add(r_arm)

    r_fore = new UTIL.geometry_2d()
    r_fore.add_vertex([0.2, 0.7])
    r_fore.add_vertex([0.2, 0.9])
    r_arm.add(r_fore)

    head = new UTIL.geometry_2d()
    head.add_vertex([-0.1, 0.4])
    head.add_vertex([0.1, 0.4])
    head.add_vertex([0.1, 0.2])
    head.add_vertex([-0.1, 0.2])
    head.add_vertex([-0.1, 0.4])
    torso.add(head)

    drawing_renderer.world.add(person)

date = new Date()
render_graphics = () ->
    graphics.clear()
    graphics.lineStyle 3, 0x5c6274
    next_bg()

    drawing_renderer.render_world()

animate = () ->
    renderer.render stage
    requestAnimationFrame animate

init()

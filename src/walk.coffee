stage = new PIXI.Stage 0xFFFFFF

w = 688
h = 480

renderer = new PIXI.WebGLRenderer w, h, null, null, true
graphics = new PIXI.Graphics
drawing_renderer = new UTIL.renderer(graphics, w, h)
window.r = drawing_renderer

noise.seed(Math.random())

init = () ->
    document.body.appendChild renderer.view

    init_bg()
    init_ground()
    init_house()
    init_person()

    stage.addChild graphics

    setInterval render_graphics, 60
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
#    stage.addChild paper_sprite

house = null
init_house = () ->
    house = new UTIL.geometry_2d()
    window.house = house

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

    vec3.set(house.states["default"].translate_vec, 3, -5, -5)
    vec3.set(house.states["default"].scale_vec, 4, 4, 4)
    house.reset_state()
    drawing_renderer.world.add(house)

next_bg = () ->
    paper_current += 1

    if paper_current is paper_textures.length
        paper_current = 0

    paper_sprite.setTexture paper_textures[paper_current]

ground = null
init_ground = () ->
    ground = new UTIL.geometry_2d()

    ground.add_vertex([-8, 3])
    ground.add_vertex([8, 3])

    ground.reset_state()
    drawing_renderer.world.add(ground)

    far_ground = new UTIL.geometry_2d()

    far_ground.add_vertex([-8, 3])
    far_ground.add_vertex([8, 3])
    vec3.set(far_ground.states["default"].translate_vec, 0, 0, -5)

    far_ground.reset_state()
    drawing_renderer.world.add(far_ground)

person = null
init_person = () ->
    person = new PERSON.person()
    window.person = person

    drawing_renderer.world.add(person)

render_graphics = () ->
    graphics.clear()
    graphics.lineStyle 3, 0x5c6274
    next_bg()

    person.do_stuff()

    drawing_renderer.render_world()

animate = () ->
    renderer.render stage
    requestAnimationFrame animate

person_facing_right = 1
flip_person = () ->
    person.rotate_y(Math.PI)
    person_facing_right = !person_facing_right

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
        when 65
            person.angry()
        when 72
            person.happy()
        when 83
            person.sad()
        when 88
            drawing_renderer.translate(0, 0, 1)
        when 90
            drawing_renderer.translate(0, 0, -1)
        when 87
            person.toggle_walk()

init()

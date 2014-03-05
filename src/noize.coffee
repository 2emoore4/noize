stage = new PIXI.Stage 0xFFFFFF
renderer = new PIXI.WebGLRenderer 688, 480, null, null, true
graphics = new PIXI.Graphics
init = () ->
    document.body.appendChild renderer.view

    init_bg()
    init_house()
    init_ground()

    stage.addChild graphics

    setInterval render_graphics, 200
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

house = new draw_polygon
init_house = () ->
    body = new draw_line
    body.add_point new PIXI.Point 400, 300
    body.add_point new PIXI.Point 494, 295
    body.add_point new PIXI.Point 500, 404
    body.add_point new PIXI.Point 398, 400
    body.add_point new PIXI.Point 400, 300
    house.add_line body

    roof = new draw_line
    roof.add_point new PIXI.Point 400, 300
    roof.add_point new PIXI.Point 450, 250
    roof.add_point new PIXI.Point 494, 295
    roof.add_point new PIXI.Point 400, 300
    house.add_line roof

    door = new draw_line
    door.add_point new PIXI.Point 435, 400
    door.add_point new PIXI.Point 435, 325
    door.add_point new PIXI.Point 465, 325
    door.add_point new PIXI.Point 465, 400
    house.add_line door

ground = new draw_line
init_ground = () ->
    ground.add_point new PIXI.Point 0, 400
    ground.add_point new PIXI.Point 688, 405

animate = () ->
    renderer.render stage
    requestAnimationFrame animate

render_graphics = () ->
    graphics.clear()
    house.render graphics
    ground.render graphics
    next_bg()

init()

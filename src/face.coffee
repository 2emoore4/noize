stage = new PIXI.Stage 0xFFFFFF

w = 688
h = 480

renderer = new PIXI.WebGLRenderer w, h, null, null, true
graphics = new PIXI.Graphics
drawing_renderer = new UTIL.renderer(graphics, w, h)

init = () ->
    document.body.appendChild renderer.view

    init_bg()
    init_face()

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

face = null
init_face = () ->
    face = new UTIL.geometry_2d()
    face.add_vertex([0, 4])
    face.add_vertex([1.5, 3.5])
    face.add_vertex([3, 0])
    face.add_vertex([2.25, -2.5])
    face.add_vertex([0, -4])
    face.add_vertex([-2.25, -2.5])
    face.add_vertex([-3, 0])
    face.add_vertex([-1.5, 3.5])
    face.add_vertex([0, 4])

    mouth = new UTIL.geometry_2d()
    mouth.add_vertex([0, 1.5])
    mouth.add_vertex([0.85, 1.6])
    mouth.add_vertex([0, 1.8])
    mouth.add_vertex([-0.85, 1.6])
    mouth.add_vertex([0, 1.5])
    mouth.translate(0, 0.5, 0)
    face.add(mouth)

    eyes = new UTIL.geometry_2d()

    r_eye = new UTIL.geometry_2d()
    r_eye.add_vertex([1, -1])
    r_eye.add_vertex([0.6, -0.85])
    r_eye.add_vertex([1, -0.7])
    r_eye.add_vertex([1.4, -0.85])
    r_eye.add_vertex([1, -1])
    eyes.add(r_eye)

    l_eye = new UTIL.geometry_2d()
    l_eye.add_vertex([1, -1])
    l_eye.add_vertex([0.6, -0.85])
    l_eye.add_vertex([1, -0.7])
    l_eye.add_vertex([1.4, -0.85])
    l_eye.add_vertex([1, -1])
    l_eye.translate(-2, 0, 0)
    eyes.add(l_eye)

    face.add(eyes)

    brows = new UTIL.geometry_2d()

    r_brow = new UTIL.geometry_2d()
    r_brow.add_vertex([0.5, -1.4])
    r_brow.add_vertex([1.4, -1.4])
    brows.add(r_brow)

    l_brow = new UTIL.geometry_2d()
    l_brow.add_vertex([-0.5, -1.4])
    l_brow.add_vertex([-1.4, -1.4])
    brows.add(l_brow)

    face.add(brows)

    nose = new UTIL.geometry_2d()
    nose.add_vertex([0.1, -0.5])
    nose.add_vertex([0.4, 1])
    nose.add_vertex([-0.4, 1])
    nose.add_vertex([-0.1, -0.5])
    face.add(nose)

    drawing_renderer.world.add(face)

date = new Date()
render_graphics = () ->
    graphics.clear()
    graphics.lineStyle 3, 0x5c6274
    next_bg()

    face.rotate_y(0.04)

    drawing_renderer.render_world()

animate = () ->
    renderer.render stage
    requestAnimationFrame animate

init()

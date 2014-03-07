stage = new PIXI.Stage 0xFFFFFF

w = 688
h = 480
fl = 10.0

renderer = new PIXI.WebGLRenderer w, h, null, null, true
graphics = new PIXI.Graphics

point0 = [0...3].map (i) -> 0.0
point1 = [0...3].map (i) -> 0.0
a = [0...2].map (i) -> 0
b = [0...2].map (i) -> 0

vertices = [
    [ -1,-1,-1], [ 1,-1,-1], [-1, 1,-1], [1, 1,-1],
    [ -1,-1, 1], [ 1,-1, 1], [-1, 1, 1], [1, 1, 1],
    [ 0, 0, 0]
]

edges = [
    [0,1],[2,3],[4,5],[6,7],
    [0,2],[1,3],[4,6],[5,7],
    [0,4],[1,5],[2,6],[3,7],
]

cube = new DRAW.shape vertices, edges
t = new UTIL.matrix

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

house = null
init_house = () ->
    house = new DRAW.polygon

    body = new DRAW.line
    body.add_point new PIXI.Point 400, 300
    body.add_point new PIXI.Point 494, 295
    body.add_point new PIXI.Point 500, 404
    body.add_point new PIXI.Point 398, 400
    body.add_point new PIXI.Point 400, 300
    house.add_line body

    roof = new DRAW.line
    roof.add_point new PIXI.Point 400, 300
    roof.add_point new PIXI.Point 450, 250
    roof.add_point new PIXI.Point 494, 295
    roof.add_point new PIXI.Point 400, 300
    house.add_line roof

    door = new DRAW.line
    door.add_point new PIXI.Point 435, 400
    door.add_point new PIXI.Point 435, 325
    door.add_point new PIXI.Point 465, 325
    door.add_point new PIXI.Point 465, 400
    house.add_line door

ground = null
init_ground = () ->
    ground = new DRAW.line

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

    t.identity()
    t.rotate_y 0.05
    cube.get_matrix().right_multiply t

    for e in [0...cube.get_edges().length]
        i = cube.get_edge e, 0
        j = cube.get_edge e, 1

        cube.get_matrix().transform cube.get_vertices(i), point0
        cube.get_matrix().transform cube.get_vertices(j), point1

        project_point point0, a
        project_point point1, b

        draw_line new PIXI.Point(a[0], a[1]), new PIXI.Point(b[0], b[1])

sub_points = (last_point, point) ->
    mid = new PIXI.Point (point.x + last_point.x) / 2, (point.y + last_point.y) / 2
    length = distance last_point, point

    all_points = null
    if length < 80
        all_points = new Array
        all_points.push mid
        all_points.push point
    else
        low = sub_points last_point, mid
        high = sub_points mid, point
        all_points = low.concat high

    all_points

distance = (p1, p2) ->
    xdiff = p1.x - p2.x
    ydiff = p1.y - p2.y
    Math.sqrt (xdiff * xdiff) + (ydiff * ydiff)

draw_line = (p1, p2) ->
    graphics.moveTo p1.x + noise(), p1.y + noise()

    inter_points = sub_points p1, p2

    for i in [1...inter_points.length]
        graphics.lineTo inter_points[i].x + noise(), inter_points[i].y + noise()

project_point = (xyz, pxy) ->
    x = xyz[0]
    y = xyz[1]
    z = xyz[2]

    pxy[0] = w / 2 + (h * x / (fl - z))
    pxy[1] = h / 2 + (h * y / (fl - z))

noise = () -> (Math.random() - 0.5) * 2

init()

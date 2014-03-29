stage = new PIXI.Stage 0xFFFFFF

w = 688
h = 480

renderer = new PIXI.WebGLRenderer w, h, null, null, true
graphics = new PIXI.Graphics
drawing_renderer = new UTIL.renderer(graphics, w, h)
window.r = drawing_renderer

noise.seed(Math.random())

font_style = {
    "font": "14pt Courier"
    "fill": "#5c6274"
    "align": "center"
}

init = () ->
    document.body.appendChild renderer.view

    init_ground()
    init_house()
    init_people()
    init_text()

    cell0()

    stage.addChild graphics

    setInterval render_graphics, 60
    requestAnimationFrame animate

toiletone = null
toilettwo = null
init_br = () ->
    toiletone = new UTIL.geometry_2d()
    toiletone.add_vertex([0.2, -0.4])
    toiletone.add_vertex([0.8, -0.4])
    toiletone.add_vertex([1, 0])
    toiletone.add_vertex([0, 0])
    toiletone.add_vertex([0.2, -0.4])
    toiletone.add_vertex([-0.2, -0.4])
    toiletone.add_vertex([-0.2, -2])
    toiletone.add_vertex([0.2, -2])
    toiletone.add_vertex([0.2, -0.6])
    toiletone.add_vertex([1, -0.6])
    toiletone.add_vertex([1, -0.4])
    toiletone.add_vertex([0.8, -0.4])
    vec3.set(toiletone.states["default"].scale_vec, 0.3, 0.3, 0.3)
    vec3.set(toiletone.states["default"].translate_vec, -0.8, 2, 0)
    toiletone.reset_state()
    bathroom.add(toiletone)

    pooperone = new UTIL.geometry_2d()
    window.p = pooperone
    pooperone.add_vertex([1.4, 0])
    pooperone.add_vertex([1.1, -0.7])
    pooperone.add_vertex([0.5, -0.6])
    pooperone.add_vertex([0.6, -1.7])
    pooperone.add_vertex([0.8, -1.7])
    pooperone.add_vertex([0.6, -2])
    pooperone.add_vertex([0.4, -1.7])
    pooperone.add_vertex([0.6, -1.7])
    pooperone.add_vertex([0.575, -1.25])
    pooperone.add_vertex([0.8, -1])
    pooperone.add_vertex([1.2, -1.2])
    pooperone.reset_state()
    toiletone.add(pooperone)

    toilettwo = new UTIL.geometry_2d()
    toilettwo.add_vertex([0.2, -0.4])
    toilettwo.add_vertex([0.8, -0.4])
    toilettwo.add_vertex([1, 0])
    toilettwo.add_vertex([0, 0])
    toilettwo.add_vertex([0.2, -0.4])
    toilettwo.add_vertex([-0.2, -0.4])
    toilettwo.add_vertex([-0.2, -2])
    toilettwo.add_vertex([0.2, -2])
    toilettwo.add_vertex([0.2, -0.6])
    toilettwo.add_vertex([1, -0.6])
    toilettwo.add_vertex([1, -0.4])
    toilettwo.add_vertex([0.8, -0.4])
    vec3.set(toilettwo.states["default"].scale_vec, 0.3, 0.3, 0.3)
    vec3.set(toilettwo.states["default"].translate_vec, 0.8, 2, 0)
    vec3.set(toilettwo.states["default"].rotate_vec, 0, Math.PI, 0)
    toilettwo.reset_state()
    bathroom.add(toilettwo)

    poopertwo = new UTIL.geometry_2d()
    poopertwo.add_vertex([1.4, 0])
    poopertwo.add_vertex([1.1, -0.7])
    poopertwo.add_vertex([0.5, -0.6])
    poopertwo.add_vertex([0.6, -1.7])
    poopertwo.add_vertex([0.8, -1.7])
    poopertwo.add_vertex([0.6, -2])
    poopertwo.add_vertex([0.4, -1.7])
    poopertwo.add_vertex([0.6, -1.7])
    poopertwo.add_vertex([0.575, -1.25])
    poopertwo.add_vertex([0.8, -1])
    poopertwo.add_vertex([1.2, -1.2])
    poopertwo.reset_state()
    toilettwo.add(poopertwo)

broker_text = null
buyer_text = null
init_text = () ->
    broker_text = new PIXI.Text("", font_style)
    stage.addChild(broker_text)
    buyer_text = new PIXI.Text("", font_style)
    stage.addChild(buyer_text)

show_broker_text = (text, time) ->
    setTimeout(() ->
        broker_text.setText(text)
        broker_text.position.x = 888
        broker_text.position.y = 50
        for i in [0...700]
            setTimeout(() ->
                broker_text.position.x -= 2
            , 8 * i)
    , time * 5600)

show_buyer_text = (text, time) ->
    setTimeout(() ->
        buyer_text.setText(text)
        buyer_text.position.x = 888
        buyer_text.position.y = 430
        for i in [0...700]
            setTimeout(() ->
                buyer_text.position.x -= 2
            , 8 * i)
    , time * 5600 + 2000)

house = null
window.house = house
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

    vec3.set(house.states["default"].translate_vec, 12, -5, -5)
    vec3.set(house.states["default"].scale_vec, 4, 4, 4)
    house.reset_state()
    drawing_renderer.world.add(house)

ground = null
far_ground = null
init_ground = () ->
    ground = new UTIL.geometry_2d()

    ground.add_vertex([-20, 3])
    ground.add_vertex([10, 3])

    ground.reset_state()
    drawing_renderer.world.add(ground)

    far_ground = new UTIL.geometry_2d()

    far_ground.add_vertex([-25, 3])
    far_ground.add_vertex([15, 3])
    vec3.set(far_ground.states["default"].translate_vec, 0, 0, -5)

    far_ground.reset_state()
    drawing_renderer.world.add(far_ground)

broker = null
buyer = null
init_people = () ->
    broker = new PERSON.person()
    drawing_renderer.world.add(broker)
    vec3.set(broker.states["default"].rotate_vec, 0, Math.PI / 2, 0)
    vec3.set(broker.states["default"].translate_vec, 0, 0, -3)
    broker.rotate_y(Math.PI / 2)
    broker.translate(0, 0, -3)

    buyer = new PERSON.person()
    window.buyer = buyer
    drawing_renderer.world.add(buyer)
    vec3.set(buyer.states["default"].rotate_vec, 0, Math.PI / 2, 0)
    vec3.set(buyer.states["default"].translate_vec, -1, 0, -1)
    buyer.rotate_y(Math.PI / 2)
    buyer.translate(-1, 0, -1)

render_graphics = () ->
    graphics.clear()
    graphics.lineStyle 3, 0x5c6274

    broker.do_stuff()
    broker.happy()

    buyer.do_stuff()
    buyer.sad()

    drawing_renderer.render_world()

animate = () ->
    renderer.render stage
    requestAnimationFrame animate

cell0 = () ->
    console.log("cell 0")
    drawing_renderer.rotate_y(-0.4)

    show_broker_text("now you have to remember,", 0)
    show_buyer_text("yeah?", 0)
    show_broker_text("if you like the neighborhood,", 1)
    show_broker_text("you have to be willing to sacrifice", 2)
    show_buyer_text("on what?", 2)
    show_broker_text("well...price and size", 3)
    show_buyer_text("ok...not sure what you mean", 3)
    show_broker_text("you'll see", 4)

    setTimeout(cell1, 22400)

cell1 = () ->
    for i in [0...100]
        setTimeout(() ->
            house.translate(-0.1, 0, 0)
        , 40 * i)

    setTimeout(() ->
        broker.walking = false
        broker.reset_state()
        buyer.walking = false
        buyer.reset_state()
    , 4000)

    show_broker_text("well here it is. newly renovated, one story.", 1)
    show_buyer_text("doesn't look newly renovated...", 1)
    show_broker_text("I'm just reading the rental listing", 2)
    show_broker_text("there shouldn't be anyone here", 3)
    show_broker_text("let's just walk in", 4)

    setTimeout(cell2, 22400)

cell2 = () ->
    console.log("cell 2")
    for i in [0...130]
        setTimeout(() ->
            drawing_renderer.rotate_y(-0.01)
            drawing_renderer.translate(-0.1, 0, 0)
        , 40 * i)

    next_time = 5200

    setTimeout(() ->
        for i in [0...78]
            setTimeout(() ->
                broker.rotate_y(0.02)
                buyer.rotate_y(0.02)
            , 10 * i)
    , next_time)

    next_time += 78 * 10
    setTimeout(() ->
        broker.walking = true
        buyer.walking = true

        for i in [0...100]
            setTimeout(() ->
                broker.translate(0, 0, -0.05)
                buyer.translate(0, 0, -0.05)
                ground.translate(0, 0, 0.2)
                far_ground.translate(0, 0, 0.2)
                house.translate(0, 0, 0.2)
                drawing_renderer.translate(0.05, 0, 0)
            , 50 * i)
    , next_time)

    next_time += 100 * 50
    setTimeout(() ->
        show_broker_text("it's got a nice kitchen, very spacious", 0)
        show_buyer_text("that's nice. I like to cook.", 0)
        show_buyer_text("this sure is a long hallway", 1)
        show_broker_text("first we'll take a look at the bathroom", 2)
        show_broker_text("the listing says 'jack and jill' style", 3)
        show_buyer_text("what does that mean?", 3)
        show_broker_text("no clue, let's find out", 4)
    , next_time)

    setTimeout(cell3, next_time + 22400)

bathroom = null
cell3 = () ->
    bathroom = new UTIL.geometry_2d()
    window.bathroom = bathroom
    bathroom.add_vertex([-1, 2])
    bathroom.add_vertex([1, 2])
    bathroom.add_vertex([1, 0])
    bathroom.add_vertex([-1, 0])
    bathroom.add_vertex([-1, 2])
    vec3.set(bathroom.states["default"].scale_vec, 5, 5, 5)
    vec3.set(bathroom.states["default"].translate_vec, 0, -6, -23)
    vec3.set(bathroom.states["default"].rotate_vec, 0, Math.PI / 2, 0)
    bathroom.reset_state()

    init_br()

    setTimeout(() ->
        drawing_renderer.world.add(bathroom)
        for i in [0...100]
            setTimeout(() ->
                bathroom.translate(0, 0, 0.03)
            , 10 * i)
    , 1000)

    next_time = 1000 + 100 * 10

    setTimeout(() ->
        broker.walking = false
        buyer.walking = false
        show_buyer_text("wait, do you hear something?", 0)
        show_broker_text("the house is supposed to be empty...", 1)
        show_buyer_text("it's coming from the bathroom", 1)
    , next_time)

    setTimeout(cell4, next_time + 5600)

cell4 = () ->
    console.log("cell 4")

    for i in [0...100]
        setTimeout(() ->
            drawing_renderer.translate(0, 0, 0.07)
            bathroom.translate(0, 0, 0.02)
        , 10 * i)

    next_time = 100 * 10

    show_broker_text("uhhhhhhhh", 0)
    show_buyer_text("are those toilets?", 0)
    show_broker_text("so that's what they mean by jack and jill...", 1)
    show_buyer_text("weird shit.", 1)

    setTimeout(() ->
        for i in [0...100]
            setTimeout(() ->
                drawing_renderer.translate(-1, 0, 0)
            , 100 * i)
        show_broker_text("the", 2)
        show_buyer_text("end", 2)
    , 10000)

init()

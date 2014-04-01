stage = new PIXI.Stage 0xFFFFFF

w = 688
h = 480

transparent = true
antialias = true
renderer = new PIXI.WebGLRenderer w, h, null, transparent, antialias
graphics = new PIXI.Graphics
drawing_renderer = new UTIL.renderer(graphics, w, h)
window.r = drawing_renderer

noise.seed(Math.random())

init = () ->
    document.body.appendChild renderer.view

    init_person()

    stage.addChild graphics

    setInterval render_graphics, 60
    requestAnimationFrame animate

# video
video_element = null # keep this in the outer scope
window.onload = ->
    video_element = document.getElementById("videounder")

video_start = ->
    console.log('starting video playback')
    video_element.play()

# list of things which happen at a certain
# time of the video
video_timing_effects = [
    trigger_time: 0
    what_happens: ->
        # person starts happy
        person.happy()
,
    trigger_time: 1
    what_happens: ->
        # but after a second they get sad
        person.sad()
,
    trigger_time: 3
    what_happens: ->
        # and after waiting 3 seconds, they're mad as all get out.
        person.angry()
]

# callback called before every rendering update
# handles synchronizing animation with video
video_effect = ->
    if video_element is null
        # there are some timing issues on startup
        # ignore the problem until it goes away
        return

    ct = video_element.currentTime

    for vte in video_timing_effects
        if ct > vte.trigger_time and not vte.already_happened
            vte.what_happens()
            vte.already_happened = true

person = null
init_person = () ->
    person = new PERSON.person()
    window.person = person

    drawing_renderer.world.add(person)

render_graphics = () ->
    video_effect()

    graphics.clear()
    graphics.lineStyle 4, 0xffffff

    person.do_stuff()

    drawing_renderer.render_world()

animate = () ->
    renderer.render stage
    requestAnimationFrame animate

window.onkeydown = (event) ->
    console.log(event.which)
    switch event.which
        when 32 # space
            video_start()
        when 37 # left arrow
            drawing_renderer.rotate_y(0.05)
        when 38 # right arrow
            drawing_renderer.rotate_x(-0.05)
        when 39 # up arrow
            drawing_renderer.rotate_y(-0.05)
        when 40 # down arrow
            drawing_renderer.rotate_x(0.05)
        when 65 # 'a'
            person.angry()
        when 72 # 'h'
            person.happy()
        when 74 # 'j'
            person.sit()
        when 75 # 'k'
            person.stand()
        when 78 # 'n'
            person.shake_head()
        when 83 # 's'
            person.sad()
        when 87 # 'w'
            person.toggle_walk()
        when 89 # 'y'
            person.nod_head()

init()

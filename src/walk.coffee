stage = new PIXI.Stage 0xFFFFFF

w = 848
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
video_time = null
song_element = null
vibe_element = null
dialogs = [ null, null, null, null, null]
window.onload = ->
    video_element = document.getElementById("videounder")
    video_time = document.getElementById("time")
    song_element = document.getElementById("song")
    song_element.volume = 0.1
    vibe_element = document.getElementById("vibe")

pause_all_dialog = () ->
    for d in dialogs
        d?.pause()

goto = (time) ->
    video_element.currentTime = time

window.goto = goto

video_toggle = ->
    if video_element.paused
        video_element.play()
        song_element.play()
    else
        video_element.pause()
        song_element.pause()

video_speed_up = ->
    i = 1
    while i < 5
        setTimeout(() ->
            video_element.playbackRate = i
            song_element.playbackRate = (i + 5) / 5
        , 250 * (i - 1))
        i += 0.1

video_speed_down = ->
    i = 5
    while i > 1.1
        setTimeout(() ->
            video_element.playbackRate = i
            song_element.playbackRate = i
        , 250 * (5 - i))
        i -= 0.1

p = () ->
    d1.pause()
    d2.pause()
    d3.pause()
    d4.pause()
    vibe.pause()

window.p = p

# list of things which happen at a certain
# time of the video
video_timing_effects = [
    trigger_time: 0
    what_happens: ->
        person.happy()
        d1.play()
,
    trigger_time: 10.5
    what_happens: ->
        vibe_element.play()
,
    trigger_time: 25
    what_happens: ->
        video_element.currentTime = 50
,
    trigger_time: 72
    what_happens: ->
        video_speed_up()
,
    trigger_time: 113
    what_happens: ->
        video_speed_down()
,
    trigger_time: 113
    what_happens: ->
        d2.play()
,
    trigger_time: 115
    what_happens: ->
        av_in()
,
    trigger_time: 116
    what_happens: ->
        nod()
,
    trigger_time: 121
    what_happens: ->
        person.wave()
,
    trigger_time: 131
    what_happens: ->
        av_out()
,
    trigger_time: 133
    what_happens: ->
        video_speed_up()
,
    trigger_time: 158
    what_happens: ->
        video_speed_down()
,
    trigger_time: 160
    what_happens: ->
        d3.play()
        av_in()
,
    trigger_time: 167
    what_happens: ->
        nod()
,
    trigger_time: 170
    what_happens: ->
        person.sit()
,
    trigger_time: 172
    what_happens: ->
        person.shrug_shoulders()
,
    trigger_time: 174.2
    what_happens: ->
        d4.play()
,
#    trigger_time: 173
#    what_happens: ->
#        video_element.currentTime = 178
#,
    trigger_time: 179
    what_happens: ->
        d4.pause()
,
    trigger_time: 180
    what_happens: ->
        av_out()
,
    trigger_time: 182
    what_happens: ->
        video_speed_up()
,
    trigger_time: 223
    what_happens: ->
        video_speed_down()
,
    trigger_time: 226
    what_happens: ->
        av_in()
,
    trigger_time: 227
    what_happens: ->
        person.stand()
,
    trigger_time: 227.5
    what_happens: ->
        person.toggle_walk()
,
    trigger_time: 233.3
    what_happens: ->
        av_out()
,
    trigger_time: 235
    what_happens: ->
        video_speed_up()
,
    trigger_time: 244
    what_happens: ->
        video_speed_down()
,
    trigger_time: 246.5
    what_happens: ->
        av_in()
,
    trigger_time: 247
    what_happens: ->
        d5.play()
,
    trigger_time: 250
    what_happens: ->
        person.angry()
,
    trigger_time: 257.5
    what_happens: ->
        av_out()
,
    trigger_time: 259
    what_happens: ->
        video_speed_up()
,
    trigger_time: 283
    what_happens: ->
        video_speed_down()
,
    trigger_time: 285.5
    what_happens: ->
        av_in()
        person.sad()
,
    trigger_time: 287.5
    what_happens: ->
        person.toggle_walk()
,
    trigger_time: 289
    what_happens: ->
        person.sit()
        person.happy()
,
    trigger_time: 290
    what_happens: ->
        shake()
,
    trigger_time: 292
    what_happens: ->
        nod()
,
    trigger_time: 294
    what_happens: ->
        av_out()
,
    trigger_time: 296
    what_happens: ->
        video_speed_up()
,
    trigger_time: 351
    what_happens: ->
        video_speed_down()
,
    trigger_time: 353
    what_happens: ->
        av_in()
,
    trigger_time: 362
    what_happens: ->
        av_out()
        av_out()
        av_out()
,
    trigger_time: 364
    what_happens: ->
        video_speed_up()
,
    trigger_time: 386
    what_happens: ->
        video_speed_down()
,
    trigger_time: 388.6
    what_happens: ->
        av_out()
,
    trigger_time: 392
    what_happens: ->
        person.stand()
        d6.play()
,
    trigger_time: 394
    what_happens: ->
        person.wave()
,
    trigger_time: 396
    what_happens: ->
        person.rotate_y(Math.PI / 2)
,
    trigger_time: 397
    what_happens: ->
        person.toggle_walk()
,
    trigger_time: 401.8
    what_happens: ->
        av_in()
]

av_in = ->
    i = 0
    while i < 1.57
        setTimeout(() ->
            r.rotate_y(0.01)
        , 500 * i)
        i += 0.01

window.av_in = av_in

av_out = ->
    i = 0
    while i < 1.57
        setTimeout(() ->
            r.rotate_y(-0.01)
        , 500 * i)
        i += 0.01

# callback called before every rendering update
# handles synchronizing animation with video
video_effect = ->
    if video_element is null
        # there are some timing issues on startup
        # ignore the problem until it goes away
        return

    ct = video_element.currentTime
    video_time.innerText = ct

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

nod = () ->
    person.head_anim = true
    person.nod_head()
    setTimeout(() ->
        person.head_anim = false
    , 760)

shake = () ->
    person.head_anim = true
    person.shake_head()
    setTimeout(() ->
        person.head_anim = false
    , 680)

window.onkeydown = (event) ->
    console.log(event.which)
    switch event.which
        when 32 # space
            video_toggle()
        when 37 # left arrow
            video_element.currentTime -= 0.2
        when 38 # up arrow
            video_element.currentTime += 1
        when 39 # right arrow
            video_element.currentTime += 0.2
        when 40 # down arrow
            video_element.currentTime -= 1
        when 65 # 'a'
            person.angry()
        when 71 # 'g'
            person.wave()
        when 72 # 'h'
            person.happy()
        when 74 # 'j'
            person.sit()
        when 75 # 'k'
            person.stand()
        when 78 # 'n'
            shake()
        when 83 # 's'
            person.sad()
        when 85 # 'u'
            person.shrug_shoulders()
        when 87 # 'w'
            person.toggle_walk()
        when 89 # 'y'
            nod()

init()

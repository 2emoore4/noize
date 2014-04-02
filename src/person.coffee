window.PERSON = {}

class PERSON.person extends UTIL.geometry_2d
    constructor: () ->
        @frame = 0
        @head_rotation = vec3.create()
        @head_rotation[0] = -1.1
        @energy = 100
        @wave_speed = 4
        @wave_position = -1.75
        @angry_wave = false
        @walking = false
        @walk_speed = 3
        @sync_breaker = Math.random() * 3

        super()

        @hip = new UTIL.geometry_2d()
        window.hip = @hip
        @hip.add_vertex([-0.25, 0])
        @hip.add_vertex([0.25, 0])
        @add(@hip)

        @r_upper_leg = new UTIL.geometry_2d()
        @r_upper_leg.add_vertex([0, 0])
        @r_upper_leg.add_vertex([0, 1.27])
        @hip.add(@r_upper_leg)

        @r_lower_leg = new UTIL.geometry_2d()
        @r_lower_leg.add_vertex([0, 0])
        @r_lower_leg.add_vertex([0, 1.27])
        @r_upper_leg.add(@r_lower_leg)

        @l_upper_leg = new UTIL.geometry_2d()
        @l_upper_leg.add_vertex([0, 0])
        @l_upper_leg.add_vertex([0, 1.27])
        @hip.add(@l_upper_leg)

        @l_lower_leg = new UTIL.geometry_2d()
        @l_lower_leg.add_vertex([0, 0])
        @l_lower_leg.add_vertex([0, 1.27])
        @l_upper_leg.add(@l_lower_leg)

        @torso = new UTIL.geometry_2d()
        @torso.add_vertex([0, 0])
        @torso.add_vertex([0, -2])
        @hip.add(@torso)

        @shoulders = new UTIL.geometry_2d()
        @torso.add(@shoulders)

        @r_shoulder = new UTIL.geometry_2d()
        @r_shoulder.add_vertex([0, 0])
        @r_shoulder.add_vertex([-0.25, 0])
        @shoulders.add(@r_shoulder)

        @l_shoulder = new UTIL.geometry_2d()
        @l_shoulder.add_vertex([0, 0])
        @l_shoulder.add_vertex([0.25, 0])
        @shoulders.add(@l_shoulder)

        @l_arm = new UTIL.geometry_2d()
        @l_arm.add_vertex([0, 0])
        @l_arm.add_vertex([1, 0])
        @l_shoulder.add(@l_arm)

        @l_fore = new UTIL.geometry_2d()
        @l_fore.add_vertex([0, 0])
        @l_fore.add_vertex([1, 0])
        @l_arm.add(@l_fore)

        @r_arm = new UTIL.geometry_2d()
        @r_arm.add_vertex([0, 0])
        @r_arm.add_vertex([-1, 0])
        @r_shoulder.add(@r_arm)

        @r_fore = new UTIL.geometry_2d()
        @r_fore.add_vertex([0, 0])
        @r_fore.add_vertex([-1, 0])
        @r_arm.add(@r_fore)

        @neck = new UTIL.geometry_2d()
        @neck.add_vertex([0, 0])
        @neck.add_vertex([0, -0.5])
        @shoulders.add(@neck)

        @head = new UTIL.geometry_2d()
        @head.add_vertex([-0.5, 0])
        @head.add_vertex([0.5, 0])
        @head.add_vertex([0, -1])
        @head.add_vertex([-0.5, 0])
        @neck.add(@head)

        @r_brow = new UTIL.geometry_2d()
        @r_brow.add_vertex([0, 0])
        @r_brow.add_vertex([0.15, 0])
        @head.add(@r_brow)

        @l_brow = new UTIL.geometry_2d()
        @l_brow.add_vertex([0, 0])
        @l_brow.add_vertex([-0.15, 0])
        @head.add(@l_brow)

        @mouth = new UTIL.geometry_2d()
        @mouth.add_vertex([-0.15, 0.05])
        @mouth.add_vertex([0, 0])
        @mouth.add_vertex([0.15, 0.05])
        @head.add(@mouth)

        vec3.set(@hip.states["default"].translate_vec, 0, 0.5, 0)
        vec3.set(@r_upper_leg.states["default"].translate_vec, -0.25, 0, 0)
        vec3.set(@r_upper_leg.states["default"].rotate_vec, 0, 0, 0.15)
        vec3.set(@r_lower_leg.states["default"].translate_vec, 0, 1.27, 0)
        vec3.set(@l_upper_leg.states["default"].translate_vec, 0.25, 0, 0)
        vec3.set(@l_upper_leg.states["default"].rotate_vec, 0, 0, -0.15)
        vec3.set(@l_lower_leg.states["default"].translate_vec, 0, 1.27, 0)
        vec3.set(@shoulders.states["default"].translate_vec, 0, -2, 0)
        vec3.set(@l_arm.states["default"].translate_vec, 0.25, 0, 0)
        vec3.set(@l_arm.states["default"].rotate_vec, 0, 0, 1.4)
        vec3.set(@l_fore.states["default"].translate_vec, 1, 0, 0)
        vec3.set(@l_fore.states["default"].rotate_vec, 0.5, 0, 0.2)
        vec3.set(@r_arm.states["default"].translate_vec, -0.25, 0, 0)
        vec3.set(@r_arm.states["default"].rotate_vec, 0, 0, -1.4)
        vec3.set(@r_fore.states["default"].translate_vec, -1, 0, 0)
        vec3.set(@r_fore.states["default"].rotate_vec, 0.5, 0, -0.2)
        vec3.set(@head.states["default"].translate_vec, 0, -0.5, 0)
        vec3.set(@r_brow.states["default"].translate_vec, 0.05, -0.5, 0)
        vec3.set(@r_brow.states["default"].rotate_vec, 0, 0, 0.4)
        vec3.set(@l_brow.states["default"].translate_vec, -0.05, -0.5, 0)
        vec3.set(@l_brow.states["default"].rotate_vec, 0, 0, -0.4)
        vec3.set(@mouth.states["default"].translate_vec, 0, -0.2, 0)
        vec3.set(@states["default"].scale_vec, 1.8, 1.8, 1.8)
        vec3.set(@states["default"].translate_vec, 8, 2, 0)
        vec3.set(@states["default"].rotate_vec, 0, -Math.PI / 2, 0)
        @reset_state()

        @create_state("sitting")
        vec3.set(@r_upper_leg.states["sitting"].rotate_vec, Math.PI / 2, 0, 0.15)
        vec3.set(@r_lower_leg.states["sitting"].rotate_vec, -Math.PI / 2, 0, 0)
        vec3.set(@l_upper_leg.states["sitting"].rotate_vec, Math.PI / 2, 0, -0.15)
        vec3.set(@l_lower_leg.states["sitting"].rotate_vec, -Math.PI / 2, 0, 0)
        vec3.set(@hip.states["sitting"].translate_vec, 0, 1.5, -1)
        vec3.set(@torso.states["sitting"].rotate_vec, -0.2, 0, 0)
        vec3.set(@neck.states["sitting"].rotate_vec, 0.1, 0, 0)
        vec3.set(@r_arm.states["sitting"].rotate_vec, 0.2, 0, -1.4)
        vec3.set(@r_fore.states["sitting"].rotate_vec, 1.5, 0, -0.2)
        vec3.set(@l_arm.states["sitting"].rotate_vec, 0.2, 0, 1.4)
        vec3.set(@l_fore.states["sitting"].rotate_vec, 1.5, 0, 0.2)

    update_head: () ->
        @head.set_rotation_x(@head_rotation[0] + noise.perlin2(@frame / @energy, @frame / @energy) * 0.2)
        @head.set_rotation_y(@head_rotation[1] + noise.perlin2(@frame / @energy, @frame / @energy) * 1)
        @head.set_rotation_z(@head_rotation[2] + noise.perlin2(@frame / @energy, @frame / @energy) * 0.2)

    update_arms: () ->
        @r_arm.set_rotation_x(noise.perlin2(@frame / @energy, @frame / @energy) * 0.2)
        @r_arm.set_rotation_y(noise.perlin2(@frame / @energy, @frame / @energy) * 1)
        @r_arm.set_rotation_z(-1.4 + noise.perlin2(@frame / @energy, @frame / @energy) * 0.2)
        @l_arm.set_rotation_x(noise.perlin2(@frame / @energy, @frame / @energy) * 0.2)
        @l_arm.set_rotation_y(noise.perlin2(@frame / @energy, @frame / @energy) * 1)
        @l_arm.set_rotation_z(1.4 + noise.perlin2(@frame / @energy, @frame / @energy) * 0.2)

    update_wave: () ->
        if @angry_wave
            @l_fore.set_rotation_x(@wave_position + Math.sin(@frame / @wave_speed) / 2)
        else
            @l_fore.set_rotation_z(@wave_position + Math.sin(@frame / @wave_speed) / 2)

    update_torso: () ->
        @torso.set_rotation_x(noise.perlin2(@frame / @energy, @frame / @energy) * 0.1)
        @torso.set_rotation_y(noise.perlin2(@frame / @energy, @frame / @energy) * 0.1)
        @torso.set_rotation_z(noise.perlin2(@frame / @energy, @frame / @energy) * 0.1)

    walk: () ->
        @hip.set_translation(0, 0.6 - Math.abs(Math.cos(@frame / @walk_speed + @sync_breaker) / 10), 0)
        @hip.set_rotation_z(Math.sin(@frame / @walk_speed + @sync_breaker) / 50)
        @hip.set_rotation_y(-Math.sin(@frame / @walk_speed + @sync_breaker) / 10)
        @shoulders.set_rotation_y(Math.sin(@frame / @walk_speed + @sync_breaker) / 10)
        @torso.set_rotation_z(Math.cos(@frame / @walk_speed + @sync_breaker - 2) / 40)
        @torso.set_rotation_x(-0.1 + Math.sin(@frame / @walk_speed + @sync_breaker / 2 - 1.5) / 40)
        @neck.set_rotation_x(Math.sin(@frame / @walk_speed + @sync_breaker / 2) / 20)
        @r_upper_leg.set_rotation_x(-Math.sin(@frame / @walk_speed + @sync_breaker) / 2.5 + 0.2)
        @r_upper_leg.set_rotation_z(0)
        @l_upper_leg.set_rotation_x(-Math.sin(@frame / @walk_speed + @sync_breaker - Math.PI) / 2.5 + 0.2)
        @l_upper_leg.set_rotation_z(0)
        @r_lower_leg.set_rotation_x(-Math.PI / 8 + Math.sin(@frame / @walk_speed + @sync_breaker) / 4)
        @l_lower_leg.set_rotation_x(-Math.PI / 8 + Math.sin(@frame / @walk_speed + @sync_breaker - Math.PI) / 4)
        @r_arm.set_rotation_z(-Math.PI / 2 + 0.05)
        @r_arm.set_rotation_x(Math.sin(@frame / @walk_speed + @sync_breaker) / 2)
        @r_fore.set_rotation_z(0)
        @r_fore.set_rotation_y(0.2 + Math.sin(@frame / @walk_speed + @sync_breaker - 1) / 5)
        @l_arm.set_rotation_z(Math.PI / 2 - 0.05)
        @l_arm.set_rotation_x(-Math.sin(@frame / @walk_speed + @sync_breaker) / 2)
        @l_fore.set_rotation_z(0)
        @l_fore.set_rotation_y(-0.2 + Math.sin(@frame / @walk_speed + @sync_breaker - 1) / 5)

    toggle_walk: () ->
        if @walking
            # move everything back to standing state
            @stand()
        @walking = !@walking

    stand: () ->
        @reset_state()

    sit: () ->
        @change_state("sitting")

    do_stuff: () ->
        if @walking
            @walk()
            @update_head()

        @frame += 1

    shake_head: () ->
        `
        for (var i = 0; i < 17; i++) {
            (function(head, i) {
                setTimeout(function() {
                    head.set_rotation_y(Math.sin(i / 1.7) / 1.4);
                }, 60 * i);
            }).call(this, this.head, i);
        }
        `
        null

    nod_head: () ->
        `
        for (var i = 0; i < 19; i++) {
            (function(head, i) {
                setTimeout(function() {
                    head.set_rotation_x(Math.sin(i / 1.7 + Math.PI) / 2.5 - 0.5);
                }, 60 * i);
            }).call(this, this.head, i);
        }
        `
        null

    shrug_shoulders: () ->
        `
        for (var i = 0; i < Math.PI; i += 0.1) {
            (function(r_shoulder, l_shoulder, i) {
                setTimeout(function() {
                    r_shoulder.set_translation(0, -Math.sin(i) / 8, 0);
                    r_shoulder.set_rotation_z(Math.sin(i) / 6);
                    l_shoulder.set_translation(0, -Math.sin(i) / 8, 0);
                    l_shoulder.set_rotation_z(-Math.sin(i) / 6);
                }, 120 * i);
            }).call(this, this.r_shoulder, this.l_shoulder, i);
        }
        `
        null

    happy: () ->
        @angry_wave = false
        @energy = 10
        @l_brow.set_rotation_z(0)
        @r_brow.set_rotation_z(0)
        @wave_speed = 2
        @wave_position = -1.37
        @head_rotation[0] = 0
        @mouth.vertices[0][1] = -0.05
        @mouth.vertices[2][1] = -0.05
        @walk_speed = 3

    angry: () ->
        @happy()
        @energy = 5
        @l_brow.set_rotation_z(0.4)
        @r_brow.set_rotation_z(-0.4)
        @angry_wave = true
        @wave_speed = 1
        @wave_position = 0
        @mouth.vertices[0][1] = 0
        @mouth.vertices[2][1] = 0
        @walk_speed = 2

    sad: () ->
        @l_brow.set_rotation_z(-0.4)
        @r_brow.set_rotation_z(0.4)
        @angry_wave = false
        @energy = 100
        @wave_speed = 4
        @wave_position = -1.75
        @head_rotation[0] = -1.1
        @mouth.vertices[0][1] = 0.05
        @mouth.vertices[2][1] = 0.05
        @walk_speed = 4


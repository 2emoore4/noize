window.FISH = {}

class FISH.fish extends UTIL.geometry_2d
    constructor: () ->
        @frame = 0
        @energy = 40

        super()

        @swim_speed = 15

        @body = new UTIL.geometry_2d()
        @body.add_vertex([-1, 0])
        @body.add_vertex([-0.25, 0.6])
        @body.add_vertex([1.5, -0.35])
        @body.add_vertex([1.5, 0.35])
        @body.add_vertex([-0.25, -0.6])
        @body.add_vertex([-1, 0])
        @add(@body)

        @mouth = new UTIL.geometry_2d()
        @mouth.add_vertex([-0.6, 0.3])
        @mouth.add_vertex([-0.3, 0.23])
        @add(@mouth)

        @eye = new UTIL.geometry_2d()
        @eye.add_vertex([-0.55, -0.1])
        @eye.add_vertex([-0.5, -0.1])
        @add(@eye)

        @fin = new UTIL.geometry_2d()
        @fin.add_vertex([-0.1, 0.05])
        @fin.add_vertex([0.25, 0.25])
        @fin.add_vertex([0.28, 0])
        @fin.add_vertex([-0.09, -0.02])
        @add(@fin)

        @reset_state()

    happy: () ->
        @swim_speed = 15
        @mouth.vertices[1][1] = 0.23

    sad: () ->
        @swim_speed = 35
        @mouth.vertices[1][1] = 0.35

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

    wave: () ->
        @r_arm.set_rotation_z(-0.3)
        @r_fore.set_rotation_x(0)
        `
        for (var i = 0; i < 30; i++) {
            (function(fore, i) {
                setTimeout(function() {
                    fore.set_rotation_z(1.37 + Math.sin(i / 1.7) / 1.4);
                }, 60 * i);
            }).call(this, this.r_fore, i);
        }
        (function(arm, fore) {
            setTimeout(function() {
                arm.set_rotation_z(-1.4);
                fore.set_rotation_x(0.5);
                fore.set_rotation_z(-0.2);
            }, 1800);
        }).call(this, this.r_arm, this.r_fore);
        `
        null

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
        @fin.set_rotation_y(Math.sin(@frame/ @swim_speed) / 1.5)

        @frame += 1

    shake_head: () ->
        `
        for (var i = 0; i < 17; i++) {
            (function(head, i) {
                setTimeout(function() {
                    head.set_rotation_y(Math.sin(i / 1.7) / 1.4);
                }, 40 * i);
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
                }, 40 * i);
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


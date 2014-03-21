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

        super()

        @hip = new UTIL.geometry_2d()
        @hip.add_vertex([-0.25, 0])
        @hip.add_vertex([0.25, 0])
        @hip.translate(0, 0.5, 0)
        @add(@hip)

        @r_upper_leg = new UTIL.geometry_2d()
        @r_upper_leg.add_vertex([0, 0])
        @r_upper_leg.add_vertex([0, 1.27])
        @r_upper_leg.translate(-0.25, 0, 0)
        @r_upper_leg.rotate_z(0.15)
        @hip.add(@r_upper_leg)

        @r_lower_leg = new UTIL.geometry_2d()
        @r_lower_leg.add_vertex([0, 0])
        @r_lower_leg.add_vertex([0, 1.27])
        @r_lower_leg.translate(0, 1.27, 0)
        @r_upper_leg.add(@r_lower_leg)

        @l_upper_leg = new UTIL.geometry_2d()
        @l_upper_leg.add_vertex([0, 0])
        @l_upper_leg.add_vertex([0, 1.27])
        @l_upper_leg.translate(0.25, 0, 0)
        @l_upper_leg.rotate_z(-0.15)
        @hip.add(@l_upper_leg)

        @l_lower_leg = new UTIL.geometry_2d()
        @l_lower_leg.add_vertex([0, 0])
        @l_lower_leg.add_vertex([0, 1.27])
        @l_lower_leg.translate(0, 1.27, 0)
        @l_upper_leg.add(@l_lower_leg)

        @torso = new UTIL.geometry_2d()
        @torso.add_vertex([0, 0])
        @torso.add_vertex([0, -2])
        @hip.add(@torso)

        @shoulders = new UTIL.geometry_2d()
        @shoulders.add_vertex([-0.25, 0])
        @shoulders.add_vertex([0.25, 0])
        @shoulders.translate(0, -2, 0)
        @torso.add(@shoulders)

        @l_arm = new UTIL.geometry_2d()
        @l_arm.add_vertex([0, 0])
        @l_arm.add_vertex([1, 0])
        @l_arm.translate(0.25, 0, 0)
        @l_arm.rotate_z(0.4)
        @shoulders.add(@l_arm)

        @l_fore = new UTIL.geometry_2d()
        @l_fore.add_vertex([0, 0])
        @l_fore.add_vertex([1, 0])
        @l_fore.translate(1, 0, 0)
        @l_fore.rotate_z(@wave_position)
        @l_arm.add(@l_fore)

        @r_arm = new UTIL.geometry_2d()
        @r_arm.add_vertex([0, 0])
        @r_arm.add_vertex([-1, 0])
        @r_arm.translate(-0.25, 0, 0)
        @r_arm.rotate_z(-Math.PI / 4)
        @shoulders.add(@r_arm)

        @r_fore = new UTIL.geometry_2d()
        @r_fore.add_vertex([0, 0])
        @r_fore.add_vertex([-1, 0])
        @r_fore.translate(-1, 0, 0)
        @r_fore.rotate_z(-1.25)
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
        @head.translate(0, -0.5, 0)
        @neck.add(@head)

    update_head: () ->
        @head.set_rotation_x(@head_rotation[0] + noise.perlin2(@frame / @energy, @frame / @energy) * 0.2)
        @head.set_rotation_y(@head_rotation[1] + noise.perlin2(@frame / @energy, @frame / @energy) * 1)
        @head.set_rotation_z(@head_rotation[2] + noise.perlin2(@frame / @energy, @frame / @energy) * 0.2)

    update_wave: () ->
        if @angry_wave
            @l_fore.set_rotation_x(@wave_position + Math.sin(@frame / @wave_speed) / 2)
        else
            @l_fore.set_rotation_z(@wave_position + Math.sin(@frame / @wave_speed) / 2)

    update_torso: () ->
        @torso.set_rotation_x(noise.perlin2(@frame / @energy, @frame / @energy) * 0.1)
        @torso.set_rotation_y(noise.perlin2(@frame / @energy, @frame / @energy) * 0.1)
        @torso.set_rotation_z(noise.perlin2(@frame / @energy, @frame / @energy) * 0.1)

    do_stuff: () ->
        @update_head()
        @update_wave()
        @update_torso()

        @frame += 1

    happy: () ->
        @angry_wave = false
        @energy = 10
        @wave_speed = 2
        @l_arm.set_rotation_z(-0.2)
        @wave_position = -1.37
        @head_rotation[0] = 0

    angry: () ->
        @happy()
        @angry_wave = true
        @wave_speed = 1
        @wave_position = 0

    sad: () ->
        @angry_wave = false
        @energy = 100
        @wave_speed = 4
        @l_arm.set_rotation_z(0.4)
        @wave_position = -1.75
        @head_rotation[0] = -1.1


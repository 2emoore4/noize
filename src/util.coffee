window.UTIL = {}

class UTIL.vertex
    constructor: (x, y, z) ->
        @coordinates = [x, y, z]

    set: (pos, value) ->
        @coordinates[pos] = value

class UTIL.face
    constructor: (zero, one, two, three) ->
        @vertices = [zero, one, two, three]

    set: (pos, vertex) ->
        @vertices[pos] = vertex

    get_vertex: (pos) ->
        @vertices[pos]

    length: () ->
        @vertices.length

class UTIL.geometry
    constructor: () ->
        @mesh_m = 10
        @mesh_n = 10
        @vertices = new Array()
        @faces = new Array()
        @matrix = mat4.create()
        @glob_matrix = mat4.create()
        @children = new Array()
        @t = mat4.create()

    transform_by_parent: (parent) ->
        mat4.copy @glob_matrix, parent.get_glob_matrix()
        mat4.multiply @glob_matrix, @glob_matrix, @matrix

    cube: () ->
        @vertices = [
            new UTIL.vertex(-1, -1, 1), new UTIL.vertex(1, -1, 1), new UTIL.vertex(1, 1, 1), new UTIL.vertex(-1, 1, 1),
            new UTIL.vertex(-1, 1, -1), new UTIL.vertex(1, 1, -1), new UTIL.vertex(1, -1, -1), new UTIL.vertex(-1, -1, -1),
            new UTIL.vertex(-1, 1, 1), new UTIL.vertex(1, 1, 1), new UTIL.vertex(1, 1, -1), new UTIL.vertex(-1, 1, -1),
            new UTIL.vertex(-1, -1, 1), new UTIL.vertex(-1, -1, -1), new UTIL.vertex(1, -1, -1), new UTIL.vertex(1, -1, 1),
            new UTIL.vertex(1, -1, 1), new UTIL.vertex(1, -1, -1), new UTIL.vertex(1, 1, -1), new UTIL.vertex(1, 1, 1),
            new UTIL.vertex(-1, -1, -1), new UTIL.vertex(-1, -1, 1), new UTIL.vertex(-1, 1, 1), new UTIL.vertex(-1, 1, -1),
        ]

        @faces = [
            new UTIL.face(0, 1, 2, 3),
            new UTIL.face(4, 5, 6, 7),
            new UTIL.face(8, 9, 10, 11),
            new UTIL.face(12, 13, 14, 15),
            new UTIL.face(16, 17, 18, 19),
            new UTIL.face(20, 21, 22, 23),
        ]

        this

    sphere: () ->
        @vertices = new Array((@mesh_m + 1) * (@mesh_n + 1))
        @faces = new Array(@mesh_m * @mesh_n)
        @mesh_to_faces()

        for m in [0...@mesh_m + 1]
            for n in [0...@mesh_n + 1]
                u = m / @mesh_m
                v = n / @mesh_n

                x = Math.cos(2 * Math.PI * u) * Math.cos(Math.PI * (v - 0.5))
                y = Math.sin(2 * Math.PI * u) * Math.cos(Math.PI * (v - 0.5))
                z = Math.sin(Math.PI * (v - 0.5))

                @vertices[@point_to_vertex(m, n)] = new UTIL.vertex(x, y, z)

        this

    torus: (big_r, little_r) ->
        @vertices = new Array((@mesh_m + 1) * (@mesh_n + 1))
        @faces = new Array(@mesh_m * @mesh_n)
        @mesh_to_faces()

        for m in [0...@mesh_m + 1]
            for n in [0...@mesh_n + 1]
                u = m / @mesh_m
                v = n / @mesh_n

                x = Math.cos(2 * Math.PI * u) * (big_r + little_r * Math.cos(2 * Math.PI * v))
                y = Math.sin(2 * Math.PI * u) * (big_r + little_r * Math.cos(2 * Math.PI * v))
                z = little_r * Math.sin(2 * Math.PI * v)

                @vertices[@point_to_vertex(m, n)] = new UTIL.vertex(x, y, z)

        this

    cylinder: () ->
        @vertices = new Array((@mesh_m + 1) * (@mesh_n + 1))
        @faces = new Array(@mesh_m * @mesh_n)
        @mesh_to_faces()

        for m in [0...@mesh_m + 1]
            for n in [0...@mesh_n + 1]
                u = m / @mesh_m
                v = n / @mesh_n

                x = Math.cos(2 * Math.PI * u) * @r(v)
                y = Math.sin(2 * Math.PI * u) * @r(v)
                z = 0

                if v < 0.5
                    z = -1
                else
                    z = 1

                @vertices[@point_to_vertex(m, n)] = new UTIL.vertex(x, y, z)

        this

    r: (v) ->
        if v is 0 or v is 1 then 0 else 1

    mesh_to_faces: () ->
        for m in [0...@mesh_m]
            for n in [0...@mesh_n]
                current_face = m + (@mesh_m * n)
                @faces[current_face] = new UTIL.face @point_to_vertex(m, n), @point_to_vertex(m + 1, n), @point_to_vertex(m + 1, n + 1), @point_to_vertex(m, n + 1)

    point_to_vertex: (m, n) ->
        m + ((@mesh_m + 1) * n)

    has_vertex: () ->
        if @vertices.length == 0 then false else true

    add: (child) ->
        @children.push child

    remove: (child) ->
        index = @children.indexOf child
        @children = @children.splice index, 1

    translate: (x, y, z) ->
        mat4.identity(@t)
        mat4.translate(@t, @t, [x, y, z])
        mat4.multiply(@matrix, @matrix, @t)

    rotate_x: (a) ->
        mat4.identity(@t)
        mat4.rotateX(@t, @t, a)
        mat4.multiply(@matrix, @matrix, @t)

    rotate_y: (a) ->
        mat4.identity(@t)
        mat4.rotateY(@t, @t, a)
        mat4.multiply(@matrix, @matrix, @t)

    rotate_z: (a) ->
        mat4.identity(@t)
        mat4.rotateZ(@t, @t, a)
        mat4.multiply(@matrix, @matrix, @t)

    scale: (x, y, z) ->
        mat4.identity(@t)
        mat4.scale(@t, @t, [x, y, z])
        mat4.multiply(@matrix, @matrix, @t)


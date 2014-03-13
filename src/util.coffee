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
        @children = new Array()
        @t = mat4.create()

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

        for child in @children
            child.translate(x, y, z)

    rotate_x: (a) ->
        mat4.identity(@t)
        mat4.rotateX(@t, @t, a)
        mat4.multiply(@matrix, @matrix, @t)

        for child in @children
            child.rotate_x(a)

    rotate_y: (a) ->
        mat4.identity(@t)
        mat4.rotateY(@t, @t, a)
        mat4.multiply(@matrix, @matrix, @t)

        for child in @children
            child.rotate_y(a)

    rotate_z: (a) ->
        mat4.identity(@t)
        mat4.rotateZ(@t, @t, a)
        mat4.multiply(@matrix, @matrix, @t)

        for child in @children
            child.rotate_z(a)

    scale: (x, y, z) ->
        mat4.identity(@t)
        mat4.scale(@t, @t, [x, y, z])
        mat4.multiply(@matrix, @matrix, @t)

        for child in @children
            child.scale(x, y, z)

class UTIL.renderer
    constructor: (@g, @w, @h) ->
        @world = new UTIL.geometry()
        @FL = 10
        @point0 = vec3.create()
        @point1 = vec3.create()
        @a = vec2.create()
        @b = vec2.create()
        @temp = vec4.create()

    render_world: () ->
        for child in @world.children
            @render_geometry(child)

    render_geometry: (geo) ->
        if geo.has_vertex()
            for f in [0...geo.faces.length]
                for e in [0...geo.faces[f].length() - 1]
                    i = geo.faces[f].vertices[e]
                    j = geo.faces[f].vertices[e + 1]

                    @transform geo.matrix, geo.vertices[i].coordinates, @point0
                    @transform geo.matrix, geo.vertices[j].coordinates, @point1

                    @project_point @point0, @a
                    @project_point @point1, @b

                    @draw_line(@a, @b)

                i = geo.faces[f].vertices[geo.faces[f].length() - 1]
                j = geo.faces[f].vertices[0]

                @transform geo.matrix, geo.vertices[i].coordinates, @point0
                @transform geo.matrix, geo.vertices[j].coordinates, @point1

                @project_point @point0, @a
                @project_point @point1, @b

                @draw_line(@a, @b)

        for child in geo.children
            @render_geometry(child)

    transform: (mat, src, dst) ->
        if src.length is not dst.length
            console.log "not able to transform point due to dimension error."
        else
            for i in [0...src.length]
                @temp[i] = src[i]
            @temp[src.length] = 1

            for i in [0...3]
                replacement = 0.0
                for j in [0...4]
                    replacement += @temp[j] * mat[i + (4 * j)]
                dst[i] = replacement

    sub_points: (last_point, point) ->
        mid = [(point[0] + last_point[0]) / 2, (point[1] + last_point[1]) / 2]
        length = vec2.distance last_point, point

        all_points = null
        if length < 50
            all_points = new Array
            all_points.push point
        else
            low = @sub_points last_point, mid
            high = @sub_points mid, point
            all_points = low.concat high

        all_points

    draw_line: (p1, p2) ->
        @g.moveTo p1[0] + @noise(), p1[1] + @noise()

        inter_points = @sub_points p1, p2

        for i in [0...inter_points.length]
            @g.lineTo inter_points[i][0] + @noise(), inter_points[i][1] + @noise()

    project_point: (xyz, pxy) ->
        x = xyz[0]
        y = xyz[1]
        z = xyz[2]

        pxy[0] = @w / 2 + (@h * x / (@FL - z))
        pxy[1] = @h / 2 + (@h * y / (@FL - z))

    noise: () -> (Math.random() - 0.5) * 2

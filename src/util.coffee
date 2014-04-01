window.UTIL = {}

###*
* Class to hold coordinates of a three dimensional point.
###
class UTIL.vertex
    constructor: (x, y, z) ->
        @coordinates = [x, y, z]

    set: (pos, value) ->
        @coordinates[pos] = value

###*
* Class to hold collection of vertices which are connected to make a single face.
###
class UTIL.face
    constructor: (zero, one, two, three) ->
        @vertices = [zero, one, two, three]

    set: (pos, vertex) ->
        @vertices[pos] = vertex

    get_vertex: (pos) ->
        @vertices[pos]

    length: () ->
        @vertices.length
###*
* Collection of attributes of a 3d geometry and functions to transform them.
###
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

    ###*
    * Multiplies this geometry's global matrix by its parent's global matrix. This ensures that
    * all of the parent geometry's transformations are corrently applied to this geometry.
    * @param {UTIL.geometry} parent geometry
    ###
    transform_by_parent: (parent) ->
        mat4.copy(@glob_matrix, parent.glob_matrix)
        mat4.multiply(@glob_matrix, @glob_matrix, @matrix)

    ###*
    * Factory method to create cube primitive.
    * @return {UTIL.geometry} this geometry
    ###
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

    ###*
    * Factory method to create sphere primitive.
    * @return {UTIL.geometry} this geometry
    ###
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

    ###*
    * Factory method to create torus primitive.
    * @param {number} outer radius
    * @param {number} inner radius
    * @return {UTIL.geometry} this geometry
    ###
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

    ###*
    * Factory method to create cylinder primitive.
    * @return {UTIL.geometry} this geometry
    ###
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

    ###*
    * Helper function for cylinder factory. Determines if a given vertex is on the outer
    * cap of the cylinder.
    * @return {number} 1 if on cap, 0 if not on cap
    ###
    r: (v) ->
        if v is 0 or v is 1 then 0 else 1

    ###*
    * Groups vertices into faces based on the order which they were created by one of
    * the factory methods.
    ###
    mesh_to_faces: () ->
        for m in [0...@mesh_m]
            for n in [0...@mesh_n]
                current_face = m + (@mesh_m * n)
                @faces[current_face] = new UTIL.face @point_to_vertex(m, n), @point_to_vertex(m + 1, n), @point_to_vertex(m + 1, n + 1), @point_to_vertex(m, n + 1)

    ###*
    * Converts a given point on the mesh to the index of that point in the vertex array.
    * @return {number} index of vertex in array
    ###
    point_to_vertex: (m, n) ->
        m + ((@mesh_m + 1) * n)

    ###*
    * @return {boolean} true if this geometry contains any vertices, else false.
    ###
    has_vertex: () ->
        if @vertices.length == 0 then false else true

    ###*
    * Adds a given geometry to list of children.
    ###
    add: (child) ->
        @children.push child

    ###*
    * Finds and removes a given geometry from list of children.
    ###
    remove: (child) ->
        index = @children.indexOf child
        @children = @children.splice index, 1

    ###*
    * Incremental translation. Adds to current translation.
    ###
    translate: (x, y, z) ->
        mat4.identity(@t)
        mat4.translate(@t, @t, [x, y, z])
        mat4.multiply(@matrix, @matrix, @t)

    ###*
    * Incremental rotation. Adds to current rotation.
    ###
    rotate_x: (a) ->
        mat4.identity(@t)
        mat4.rotateX(@t, @t, a)
        mat4.multiply(@matrix, @matrix, @t)

    ###*
    * Incremental rotation. Adds to current rotation.
    ###
    rotate_y: (a) ->
        mat4.identity(@t)
        mat4.rotateY(@t, @t, a)
        mat4.multiply(@matrix, @matrix, @t)

    ###*
    * Incremental rotation. Adds to current rotation.
    ###
    rotate_z: (a) ->
        mat4.identity(@t)
        mat4.rotateZ(@t, @t, a)
        mat4.multiply(@matrix, @matrix, @t)

    ###*
    * Incremental scale. Multiplies to current scale.
    ###
    scale: (x, y, z) ->
        mat4.identity(@t)
        mat4.scale(@t, @t, [x, y, z])
        mat4.multiply(@matrix, @matrix, @t)

###*
* Holds three vectors which combine to create a 'steady-state' for a geometry. These states
* can be selected and changed to create seamless transitions between multiple states. All of
* the transition logic is done in the actual geometry class.
###
class UTIL.geometry_state
    constructor: () ->
        @rotate_vec = vec3.create()
        @translate_vec = vec3.create()
        @scale_vec = vec3.create()
        vec3.set(@scale_vec, 1, 1, 1)

    copy: () ->
        result = new UTIL.geometry_state()
        vec3.copy(result.rotate_vec, @rotate_vec)
        vec3.copy(result.translate_vec, @translate_vec)
        vec3.copy(result.scale_vec, @scale_vec)
        result

###*
* Collection of attributes of a 2d geometry and functions to transform them.
###
class UTIL.geometry_2d
    constructor: () ->
        @vertices = new Array()
        @matrix = mat4.create()
        @glob_matrix = mat4.create()
        @children = new Array()
        @t = mat4.create()
        @rotate_vec = vec3.create()
        @translate_vec = vec3.create()
        @scale_vec = vec3.create()
        @r_diff = vec3.create()
        @t_diff = vec3.create()
        @s_diff = vec3.create()
        @inc_r_diff = vec3.create()
        @inc_t_diff = vec3.create()
        @inc_s_diff = vec3.create()
        @states = new Object()
        @states["default"] = new UTIL.geometry_state()

    ###*
    * Adds two-dimensional vertex to list of vertices, with default z value of 0. All vertices
    * start with this z value, so that they are 'drawn flat'.
    ###
    add_vertex: (vertex) ->
        @vertices.push([vertex[0], vertex[1], 0])

    ###*
    * Transforms geometry back to its default state.
    ###
    reset_state: () ->
        @change_state("default")

    create_state: (state_name) ->
        @states[state_name] = @states["default"].copy()
        for i in [0...@children.length]
            @children[i].create_state(state_name)

    ###*
    * Transforms this gemoetry based on the three vectors contained in the given state. Rather
    * than perform the transformation immediately, it performs a bunch of incremental
    * transitions, so that it appears smooth.
    ###
    change_state: (state_name) ->
        state = @states[state_name]

        vec3.subtract(@r_diff, state.rotate_vec, @rotate_vec)
        vec3.subtract(@t_diff, state.translate_vec, @translate_vec)
        vec3.subtract(@s_diff, state.scale_vec, @scale_vec)

        vec3.scale(@inc_r_diff, @r_diff, 0.05)
        vec3.scale(@inc_t_diff, @t_diff, 0.05)
        vec3.scale(@inc_s_diff, @s_diff, 0.05)

        `
        for (i = 0; i < 20; i++) {
            (function(r, rd, t, td, s, sd) {
                setTimeout(function() {
                    vec3.add(r, r, rd);
                    vec3.add(t, t, td);
                    vec3.add(s, s, sd);
                }, 10 * i);
            }).call(this, this.rotate_vec, this.inc_r_diff, this.translate_vec, this.inc_t_diff, this.scale_vec, this.inc_s_diff);
        }
        `

        for i in [0...@children.length]
            @children[i].change_state(state_name)

    ###*
    * Multiplies this geometry's global matrix by its parent's global matrix. This ensures that
    * all of the parent geometry's transformations are corrently applied to this geometry.
    * @param {UTIL.geometry} parent geometry
    ###
    transform_by_parent: (parent) ->
        mat4.copy(@glob_matrix, parent.glob_matrix)
        mat4.multiply(@glob_matrix, @glob_matrix, @matrix)

    ###*
    * Sets current transformation matrix based on this geometry's global translation,
    * rotation, and scale vectors.
    ###
    render_prep: () ->
        mat4.identity(@matrix)

        if @translate_vec[0] != 0 or @translate_vec[1] != 0 or @translate_vec[2] != 0
            mat4.identity(@t)
            mat4.translate(@t, @t, @translate_vec)
            mat4.multiply(@matrix, @matrix, @t)

        if @rotate_vec[0] != 0
            mat4.identity(@t)
            mat4.rotateX(@t, @t, @rotate_vec[0])
            mat4.multiply(@matrix, @matrix, @t)

        if @rotate_vec[1] != 0
            mat4.identity(@t)
            mat4.rotateY(@t, @t, @rotate_vec[1])
            mat4.multiply(@matrix, @matrix, @t)

        if @rotate_vec[2] != 0
            mat4.identity(@t)
            mat4.rotateZ(@t, @t, @rotate_vec[2])
            mat4.multiply(@matrix, @matrix, @t)

        if @scale_vec[0] != 1 or @scale_vec[1] != 1 or @scale_vec[2] != 1
            mat4.identity(@t)
            mat4.scale(@t, @t, @scale_vec)
            mat4.multiply(@matrix, @matrix, @t)

    ###*
    * @return {boolean} true if this geometry contains any vertices, else false.
    ###
    has_vertex: () ->
        if @vertices.length == 0 then false else true

    ###*
    * Adds a given geometry to list of children.
    ###
    add: (child) ->
        @children.push child

    ###*
    * Finds and removes a given geometry from list of children.
    ###
    remove: (child) ->
        index = @children.indexOf child
        @children = @children.splice index, 1

    ###*
    * Absolute translation. Equivalant of resetting matrix and translating.
    ###
    set_translation: (x, y, z) ->
        vec3.set(@translate_vec, x, y, z)

    ###*
    * Incremental translation. Adds to current translation.
    ###
    translate: (x, y, z) ->
        @translate_vec[0] += x
        @translate_vec[1] += y
        @translate_vec[2] += z

    ###*
    * Absolute rotation. Equivalent of resetting matrix and rotating.
    ###
    set_rotation_x: (a) ->
        @rotate_vec[0] = a

    ###*
    * Incremental rotation. Adds to current rotation.
    ###
    rotate_x: (a) ->
        @rotate_vec[0] += a

    ###*
    * Absolute rotation. Equivalent of resetting matrix and rotating.
    ###
    set_rotation_y: (a) ->
        @rotate_vec[1] = a

    ###*
    * Incremental rotation. Adds to current rotation.
    ###
    rotate_y: (a) ->
        @rotate_vec[1] += a

    ###*
    * Absolute rotation. Equivalent of resetting matrix and rotating.
    ###
    set_rotation_z: (a) ->
        @rotate_vec[2] = a

    ###*
    * Incremental rotation. Adds to current rotation.
    ###
    rotate_z: (a) ->
        @rotate_vec[2] += a

    ###*
    * Incremental scale. Multiplies to current scale.
    ###
    scale: (x, y, z) ->
        @scale_vec[0] *= x
        @scale_vec[1] *= y
        @scale_vec[2] *= z

    ###*
    * Absolute scale. Equivalent of resetting matrix and scaling.
    ###
    set_scale: (x, y, z) ->
        @scale_vec[0] = x
        @scale_vec[1] = y
        @scale_vec[2] = z

class UTIL.renderer
    constructor: (@g, @w, @h) ->
        @world = new UTIL.geometry()
        @FL = 10
        @point0 = vec3.create()
        @point1 = vec3.create()
        @a = vec2.create()
        @b = vec2.create()
        @temp = vec4.create()
        @t = mat4.create()
        @frame = 0

    ###*
    * Renders all geometries.
    ###
    render_world: () ->
        @render_geometry(@world)
        @frame += 1

    render_geometry: (geo) ->
        if geo instanceof UTIL.geometry
            @render_3d(geo)
        else if geo instanceof UTIL.geometry_2d
            geo.render_prep()
            @render_2d(geo)

    ###*
    * Renders a 2d geometry by performing matrix transformations and projecting 3d points
    * to 2d window space. Then renders all children of this geometry.
    ###
    render_2d: (geo) ->
        if geo.has_vertex()
            for i in [1...geo.vertices.length]
                @transform geo.glob_matrix, geo.vertices[i - 1], @point0
                @transform geo.glob_matrix, geo.vertices[i], @point1

                @project_point @point0, @a
                @project_point @point1, @b

                @draw_line(@a, @b)

        for child in geo.children
            child.transform_by_parent(geo)
            @render_geometry(child)

    ###*
    * Renders a 3d geometry by performing matrix transformations and projecting 3d points
    * to 2d window space. Then renders all children of this geometry.
    ###
    render_3d: (geo) ->
        if geo.has_vertex()
            for f in [0...geo.faces.length]
                for e in [0...geo.faces[f].length() - 1]
                    i = geo.faces[f].vertices[e]
                    j = geo.faces[f].vertices[e + 1]

                    @transform geo.glob_matrix, geo.vertices[i].coordinates, @point0
                    @transform geo.glob_matrix, geo.vertices[j].coordinates, @point1

                    @project_point @point0, @a
                    @project_point @point1, @b

                    @draw_line(@a, @b)

                i = geo.faces[f].vertices[geo.faces[f].length() - 1]
                j = geo.faces[f].vertices[0]

                @transform geo.glob_matrix, geo.vertices[i].coordinates, @point0
                @transform geo.glob_matrix, geo.vertices[j].coordinates, @point1

                @project_point @point0, @a
                @project_point @point1, @b

                @draw_line(@a, @b)

        for child in geo.children
            child.transform_by_parent(geo)
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

    ###*
    * Given two points, returns a list of points that lie on the line which connects those
    * two points.
    ###
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

    ###*
    * Draws a line between two points. This line is not straight because it adds some noise
    * to the endpoints and to the points in between.
    ###
    draw_line: (p1, p2) ->
        @g.moveTo p1[0] + @noise(), p1[1] + @noise()

        inter_points = @sub_points p1, p2

        for i in [0...inter_points.length]
            @g.lineTo inter_points[i][0] + @noise(), inter_points[i][1] + @noise()

    ###*
    * Projects a three dimensional point onto a two dimensional window space.
    ###
    project_point: (xyz, pxy) ->
        x = xyz[0]
        y = xyz[1]
        z = xyz[2]

        pxy[0] = @w / 2 + (@h * x / (@FL - z))
        pxy[1] = @h / 2 + (@h * y / (@FL - z))

    noise: () -> (Math.random() - 0.5) * 2

    ###*
    * Incremental translation of 'world' geometry. Simulates moving the camera.
    ###
    translate: (x, y, z) ->
        mat4.identity(@t)
        mat4.translate(@t, @t, [x, y, z])
        mat4.multiply(@world.glob_matrix, @world.glob_matrix, @t)

    ###*
    * Incremental rotation of 'world' geometry. Simulates rotating the camera.
    ###
    rotate_x: (a) ->
        mat4.identity(@t)
        mat4.rotateX(@t, @t, a)
        mat4.multiply(@world.glob_matrix, @world.glob_matrix, @t)

    ###*
    * Incremental rotation of 'world' geometry. Simulates rotating the camera.
    ###
    rotate_y: (a) ->
        mat4.identity(@t)
        mat4.rotateY(@t, @t, a)
        mat4.multiply(@world.glob_matrix, @world.glob_matrix, @t)

    ###*
    * Incremental rotation of 'world' geometry. Simulates rotating the camera.
    ###
    rotate_z: (a) ->
        mat4.identity(@t)
        mat4.rotateZ(@t, @t, a)
        mat4.multiply(@world.glob_matrix, @world.glob_matrix, @t)

    ###*
    * Incremental scale of 'world' geometry. Simulates zooming..
    ###
    scale: (x, y, z) ->
        mat4.identity(@t)
        mat4.scale(@t, @t, [x, y, z])
        mat4.multiply(@world.glob_matrix, @world.glob_matrix, @t)

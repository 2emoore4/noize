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
        @mesh_m = 20
        @mesh_n = 20
        @vertices = new Array()
        @faces = new Array()
        @matrix = mat4.create()
        mat4.identity @matrix
        @glob_matrix = mat4.create()
        mat4.identity @glob_matrix
        @children = new Array()

    transform_by_parent: (parent) ->
        mat4.identity @glob_matrix
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

    mesh_to_faces: () ->
        for m in [0...mesh_m]
            for n in [0...mesh_n]
                current_face = m + (mesh_m * n)
                @faces[current_face] = new UTIL.face point_to_vertex(m, n), point_to_vertex(m + 1, n), point_to_vertex(m + 1, n + 1), point_to_vertex(m, n + 1)

    point_to_vertex: (m, n) ->
        m + ((mesh_m + 1) * n)

    has_vertex: () ->
        if @vertices.length == 0 then false else true

    add: (child) ->
        @children.push child

    get_child: (i) ->
        @children[i]

    get_num_children: () ->
        @children.length

    remove: (child) ->
        index = @children.indexOf child
        @children = @children.splice index, 1

    get_face: (i) ->
        @faces[i]

    get_num_faces: () ->
        @faces.length

    get_vertex: (i) ->
        @vertices[i]

    get_matrix: () ->
        @matrix

    get_glob_matrix: () ->
        @glob_matrix


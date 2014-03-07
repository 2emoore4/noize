window.UTIL = {}

class UTIL.matrix
    constructor: () ->
        @col = 4
        @row = 4
        @elements = [0...@col].map (x) ->
            [0...@row].map (y) -> 0.0
        @temp_elements = [0...@col].map (x) ->
            [0...@row].map (y) -> 0.0
        @temp = [0...4].map (t) -> 0.0

    identity: () ->
        @zero()
        for i in [0...@row]
            @set i, i, 1

    zero: () ->
        for i in [0...@row]
            for j in [0...@col]
                @set j, i, 0

    set: (col, row, value) ->
        @elements[row][col] = value

    get: (col, row) -> @elements[row][col]

    translate: (x, y, z) ->
        @set 3, 0, x
        @set 3, 1, y
        @set 3, 2, z

    rotate_x: (radians) ->
        @set 1, 1, Math.cos radians
        @set 1, 2, Math.sin radians
        @set 2, 1, -Math.sin radians
        @set 2, 2, Math.cos radians

    rotate_y: (radians) ->
        @set 0, 0, Math.cos radians
        @set 2, 0, Math.sin radians
        @set 0, 2, -Math.sin radians
        @set 2, 2, Math.cos radians

    rotate_z: (radians) ->
        @set 0, 0, Math.cos radians
        @set 1, 0, -Math.sin radians
        @set 0, 1, Math.sin radians
        @set 1, 1, Math.cos radians

    scale: (x, y, z) ->
        @set 0, 0, x
        @set 1, 1, y
        @set 2, 2, z

    left_multiply: (other) ->
        if other.col is not @row
            console.log "attempt to multiply incompatible matrices."
        else
            @temp_copy()

            for i in [0...other.row]
                for j in [0...@temp_elements[0].length]
                    replacement = 0.0
                    for k in [0...other.col]
                        replacement += temp_elements[k][j] * other.get k, i
                    @set j, i, replacement

    right_multiply: (other) ->
        if @col is not other.row
            console.log "attempt to multiply incompatible matrices."
        else
            @temp_copy()

            for i in [0...@temp_elements.length]
                for j in [0...other.col]
                    replacement = 0.0
                    for k in [0...@temp_elements[0].length]
                        replacement += @temp_elements[i][k] * other.get j, k
                    @set j, i, replacement

    temp_copy: () ->
        for row in [0...@row]
            for col in [0...@col]
                @temp_elements[row][col] = @elements[row][col]

    copy_to: (dst) ->
        for row in [0...@row]
            for col in [0...@col]
                dst.set col, row, @elements[row][col]

    transform: (src, dst) ->
        if src.length is not dst.length
            console.log "not able to transform point due to dimension error."
        else
            for i in [0...src.length]
                @temp[i] = src[i]
            @temp[src.length] = 1

            for i in [0...@row - 1]
                replacement = 0.0
                for j in [0...@col]
                    replacement += @temp[j] * @get j, i
                dst[i] = replacement

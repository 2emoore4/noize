class window.draw_line
    constructor: ->
        @points = new Array
        @line_thickness = 3
        @color = 0x5c6274
        @precise = true

    add_point: (point) ->
        if not @precise or @points.length is 0
            @points.push point
        else
            last_point = @points[@points.length - 1]
            inter_points = @sub_points last_point, point

            @points.push inter_point for inter_point in inter_points

    sub_points: (last_point, point) ->
        mid = new PIXI.Point (point.x + last_point.x) / 2, (point.y + last_point.y) / 2
        length = distance last_point, point

        all_points = null
        if length < 80
            all_points = new Array
            all_points.push mid
            all_points.push point
        else
            low = @sub_points last_point, mid
            high = @sub_points mid, point
            all_points = low.concat high

        all_points

    render: (graphics) ->
        graphics.lineStyle @line_thickness, @color

        start = @points[0]
        graphics.moveTo start.x + noise(), start.y + noise()

        for i in [1..@points.length - 1]
            graphics.lineTo @points[i].x + noise(), @points[i].y + noise()

class window.draw_polygon
    constructor: ->
        @lines = new Array

    add_line: (line) ->
        @lines.push line

    render: (graphics) ->
        line.render graphics for line in @lines

distance = (p1, p2) ->
    xdiff = p1.x - p2.x
    ydiff = p1.y - p2.y
    Math.sqrt (xdiff * xdiff) + (ydiff * ydiff)

noise = () -> (Math.random() - 0.5) * 2

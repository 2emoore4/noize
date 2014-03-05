function draw_line() {
    this.points = new Array();
    this.line_thickness = 3;
    this.color = 0x5c6274;
    this.precise = true;

    this.add_point = function(point) {
        if (!this.precise || this.points.length == 0) {
            this.points[this.points.length] = point;
        } else {
            var last_point = this.points[this.points.length - 1];
            var inter_points = this.sub_points(last_point, point);

            for (var i = 0; i < inter_points.length; i++) {
                this.points[this.points.length] = inter_points[i];
            }
        }
    }

    this.sub_points = function(last_point, point) {
        var mid = new PIXI.Point((point.x + last_point.x) / 2, (point.y + last_point.y) / 2);
        var length = distance(last_point, point);

        if (length < 80) {
            var all_points = new Array();
            all_points[0] = mid;
            all_points[1] = point;
        } else {
            var low = this.sub_points(last_point, mid);
            var high = this.sub_points(mid, point);
            all_points = low.concat(high);
        }
        
        return all_points;
    }

    this.render = function(graphics) {
        graphics.lineStyle(this.line_thickness, this.color);

        start = this.points[0];
        graphics.moveTo(start.x + noise(), start.y + noise());

        for (var i = 1; i < this.points.length; i++) {
            next = this.points[i];
            graphics.lineTo(next.x + noise(), next.y + noise());
        }
    }
}

function draw_polygon() {
    this.lines = new Array();

    this.add_line = function(line) {
        this.lines[this.lines.length] = line;
    }

    this.render = function(graphics) {
        for (var i = 0; i < this.lines.length; i++) {
            this.lines[i].render(graphics);
        }
    }
}

function distance(p1, p2) {
    var xdiff = p1.x - p2.x;
    var ydiff = p1.y - p2.y;
    return Math.sqrt((xdiff * xdiff) + (ydiff * ydiff));
}

function noise() {
    return (Math.random() - 0.5) * 2;
}

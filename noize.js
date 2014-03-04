var stage = new PIXI.Stage(0xDDC99F);
var renderer = new PIXI.WebGLRenderer(688, 480, null, null, true);
var font_style = {"font": "14pt Courier", "fill": "#DDC99F", "align": "center"};

var paper_textures, paper_sprite, paper_current;
var graphics;
var house, ground, dude;

document.body.appendChild(renderer.view);

init();

function init() {
    graphics = new PIXI.Graphics();
    init_bg();
    init_house();
    init_ground();
    init_dude();
    stage.addChild(graphics);

    setInterval(render_graphics, 150);

    requestAnimFrame(animate);
}

function init_bg() {
    paper_current = 0;
    paper_textures = new Array();

    paper_textures[0] = PIXI.Texture.fromImage("assets/paper0.png");
    paper_textures[1] = PIXI.Texture.fromImage("assets/paper1.png");
    paper_textures[2] = PIXI.Texture.fromImage("assets/paper2.png");
    paper_textures[3] = PIXI.Texture.fromImage("assets/paper3.png");

    paper_sprite = new PIXI.Sprite(paper_textures[paper_current]);
    stage.addChild(paper_sprite);
}

function next_bg() {
    paper_current++;

    if (paper_current == paper_textures.length) {
        paper_current = 0;
    }

    paper_sprite.setTexture(paper_textures[paper_current]);
}

function init_house() {
    house = new draw_polygon();

    var body = new draw_line();
    body.add_point(new PIXI.Point(400, 300));
    body.add_point(new PIXI.Point(494, 295));
    body.add_point(new PIXI.Point(500, 404));
    body.add_point(new PIXI.Point(398, 400));
    body.add_point(new PIXI.Point(400, 300));
    house.add_line(body);

    var roof = new draw_line();
    roof.add_point(new PIXI.Point(400, 300));
    roof.add_point(new PIXI.Point(450, 250));
    roof.add_point(new PIXI.Point(494, 295));
    roof.add_point(new PIXI.Point(400, 300));
    house.add_line(roof);
}

function init_ground() {
    ground = new draw_line();

    ground.add_point(new PIXI.Point(0, 400));
    ground.add_point(new PIXI.Point(688, 405));
}

function init_dude() {
    dude = new draw_polygon();

    var legs = new draw_line();
    legs.add_point(new PIXI.Point(102, 400));
    legs.add_point(new PIXI.Point(115, 380));
    legs.add_point(new PIXI.Point(130, 402));
    dude.add_line(legs);
}

function noise() {
    return (Math.random() - 0.5) * 2;
}

function render_graphics() {
    graphics.clear();
    house.render(graphics);
    ground.render(graphics);
    dude.render(graphics);
    next_bg();
}

function animate() {
    renderer.render(stage);
    requestAnimationFrame(animate);
}

function handle_key_down(event) {
    console.log(event);
}

function draw_line() {
    this.points = new Array();
    this.line_thickness = 3;
    this.color = 0x5c6274;
    this.precise = 3;

    this.add_point = function(point) {
        if (this.precise < 2 || this.points.length == 0) {
            this.points[this.points.length] = point;
        } else {
            var last_point = this.points[this.points.length - 1];
            var inter_points = this.sub_points(last_point, point, this.precise);

            for (var i = 0; i < inter_points.length; i++) {
                this.points[this.points.length] = inter_points[i];
            }
        }
    }

    this.sub_points = function(last_point, point, precision) {
        var mid = new PIXI.Point((point.x + last_point.x) / 2, (point.y + last_point.y) / 2);

        if (precision == 2) {
            var all_points = new Array();
            all_points[0] = mid;
            all_points[1] = point;
        } else {
            var low = this.sub_points(last_point, mid, precision - 1);
            var high = this.sub_points(mid, point, precision - 1);
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

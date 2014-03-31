# mixed 2d/3d "hand-drawn" rendering engine

======

## requirements

* [node.js](http://nodejs.org/)
* [coffeescript](http://coffeescript.org/)
* some js libraries
  * from root directory, `mkdir third_party`
  * need three scripts in this directory. find the versions I'm using [here](http://evanmoore.no-ip.org/noize/third_party/)
  
## compiling
from root directory, `coffee -m --compile --output lib/ src/`

to watch for changes in source files, and compile automatically, `coffee --watch -m --compile --output lib/ src/`

## testing
a demo animation is located in `index.html`

unless you want to disable your browser's same-origin policy, then use the development web server in the `server/` directory

from `server/`...

* `npm install` (this installs dependencies from `package.json`)
* `node server.js` (this starts the server on port 8888)

now you can view the animation at [localhost:8888](localhost:8888)

## basic code documentation
everything is located in `src/` directory

main renderer classes are in `src/util.coffee`. important classes are `UTIL.geometry` (3d geometry), `UTIL.geometry_2d`, and `UTIL.renderer`. until I write some better documentation, you can see how these classes are used in `UTIL/walk.coffee`.

class `PERSON.person`, from `src/person.coffee` is just an implementation of a 2d geometry, with predetermined vertices, and some built in methods for animating.

I'm using a js library called pixi.js to make it easier to create sprites and interface with webgl.

to see how everything is put together, check out `src/walk.coffee`, which is an example of a full application built with this renderer.


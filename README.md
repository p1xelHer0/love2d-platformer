# love2d-platformer

a platformer writte in love2d using Entity Component System (ECS)

it uses tiled to make levels

https://www.mapeditor.org/

## installation

clone the repo, clone all submodules, open `lib/lurker/lurker.lua` and change line 11:

from: 

`local lume = require((...):gsub("[^/.\\]+$", "lume"))`

to: 

`local lume = require("lib.lume.lume")`

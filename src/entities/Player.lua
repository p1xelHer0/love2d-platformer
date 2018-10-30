local anim8 = require('lib.anim8.anim8')

require('src.components.Animation')
require('src.components.Body')
require('src.components.Camera')
require('src.components.Direction')
require('src.components.Health')
require('src.components.Input')
require('src.components.Playable')
require('src.components.Position')
require('src.components.SpawnPoint')

local
Animation,
Body,
Camera,
Direction,
Health,
Input,
Playable,
Position,
SpawnPoint = Component.load({
  'Animation',
  'Body',
  'Camera',
  'Direction',
  'Health',
  'Input',
  'Position',
  'Playable',
  'SpawnPoint',
  'Trail'
})

local function Player(camera)
  local entity = Entity()

  local size = { w = 5, h = 14, }
  local mass = 8

  local image = love.graphics.newImage('assets/sprites/Player.png')
  local g = anim8.newGrid(16, 16, image:getWidth(), image:getHeight(), 0)

  local animations = {
    movement = anim8.newAnimation(g('1-8', 1), 0.05),
    fall = anim8.newAnimation(g('12-12', 1), 1),
    airborne = anim8.newAnimation(g('11-11', 1), 1),
    idle = anim8.newAnimation(g('9-10', 1), 0.3),
    jump = anim8.newAnimation(g('11-11', 1), 1),
    crouch = anim8.newAnimation(g('13-13', 1), 1),
    dash = anim8.newAnimation(g('14-14', 1), 1),
  }

  entity:add(Animation(image, animations))
  entity:add(Body(size, mass))
  entity:add(Camera(camera))
  entity:add(Direction())
  entity:add(Health(5))
  entity:add(Input())
  entity:add(Playable())
  entity:add(Position())
  entity:add(SpawnPoint('player'))

  return entity
end

return Player

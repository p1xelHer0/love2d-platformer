require('src.components.Body')
require('src.components.Collectible')
require('src.components.Direction')
require('src.components.Position')
require('src.components.SpawnPoint')
require('src.components.Sprite')

local
Body,
Direction,
Collectible,
Position,
SpawnPoint,
Sprite = Component.load({
  'Body',
  'Direction',
  'Collectible',
  'Position',
  'SpawnPoint',
  'Sprite',
})

local function Mustasch(x,y)
  local entity = Entity()

  local size = { w = 8, h = 3, }
  local mass = 0

  local image = love.graphics.newImage('assets/sprites/Mustasch.png')

  entity:add(Body(size, mass))
  entity:add(Direction())
  entity:add(Collectible())
  entity:add(Position(x, y))
  entity:add(Sprite(image))

  return entity
end

return Mustasch

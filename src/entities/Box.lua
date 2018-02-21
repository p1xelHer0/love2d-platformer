require('src.components.Body')
require('src.components.Position')
require('src.components.SpawnPoint')
require('src.components.Sprite')

local
Body,
Position,
SpawnPoint,
Sprite = Component.load({
	'Body',
	'Position',
	'SpawnPoint',
	'Sprite',
})

local function Box()
	local entity = Entity()

	local mass = 100

	local image = love.graphics.newImage('assets/sprites/box.png')

	entity:add(Body(size, mass))
	entity:add(Position())
	entity:add(SpawnPoint('box'))
	entity:add(Sprite(image))

	return entity
end

return Box

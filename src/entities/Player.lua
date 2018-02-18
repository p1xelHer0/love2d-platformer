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

	local size = { w = 6, h = 14, }

	local image = love.graphics.newImage('assets/sprites/Player.png')
	local g = anim8.newGrid(16, 16, image:getWidth(), image:getHeight(), 0)

	local animations = {
		grounded = anim8.newAnimation(g('1-1', 1), 1),
	}

	entity:add(Animation(image, animations))
	entity:add(Body(size))
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

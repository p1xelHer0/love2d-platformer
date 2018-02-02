local anim8 = require('lib.anim8.anim8')

require('src.components.Animation')
require('src.components.Body')
require('src.components.Camera')
require('src.components.Direction')
require('src.components.Position')
require('src.components.Health')
require('src.components.Input')
require('src.components.SpawnPoint')
require('src.components.Sprite')

local
Animation,
Body,
Camera,
Direction,
Position,
Health,
Input,
SpawnPoint,
Sprite = Component.load({
	'Animation',
	'Body',
	'Camera',
	'Direction',
	'Position',
	'Health',
	'Input',
	'SpawnPoint',
	'Sprite',
})

local function Player(camera)
	local entity = Entity()

	local size = { w = 6, h = 14, }

	local image = love.graphics.newImage('assets/sprites/legdude.png')
	local g = anim8.newGrid(16, 16, image:getWidth(), image:getHeight(), 0)

	local animations = {
		stand = anim8.newAnimation(g('1-2', 1), 0.5),
		slide = anim8.newAnimation(g('7-1', 1), 0.5),
		jump = anim8.newAnimation(g('4-1', 1), 0.5),
		crouch = anim8.newAnimation(g('5-1', 1), 0.5),
		fall = anim8.newAnimation(g('6-1', 1), 0.5),
	}

	entity:add(Animation(animations))
	entity:add(Body(size))
	entity:add(Camera(camera))
	entity:add(Direction())
	entity:add(Health(40))
	entity:add(Input())
	entity:add(Position())
	entity:add(SpawnPoint('player'))
	entity:add(Sprite(image))

	return entity
end

return Player

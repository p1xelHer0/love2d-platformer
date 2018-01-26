local anim8 = require('lib.anim8.anim8')

require('src.components.Animation')
require('src.components.Body')
require('src.components.Crouch')
require('src.components.Fall')
require('src.components.Health')
require('src.components.Input')
require('src.components.Jump')
require('src.components.Movement')
require('src.components.Slide')
require('src.components.SpawnPoint')
require('src.components.Sprite')
require('src.components.Stand')

local
Animation,
Body,
Crouch,
Fall,
Health,
Input,
Jump,
Movement,
Slide,
SpawnPoint,
Sprite,
Stand = Component.load({
	'Animation',
	'Body',
	'Crouch',
	'Fall',
	'Health',
	'Input',
	'Jump',
	'Movement',
	'Slide',
	'SpawnPoint',
	'Sprite',
	'Stand',
})

local function Player()
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
	entity:add(Crouch())
	entity:add(Fall())
	entity:add(Health(40))
	entity:add(Input())
	entity:add(Jump())
	entity:add(Movement())
	entity:add(Slide())
	entity:add(SpawnPoint('player'))
	entity:add(Sprite(image))
	entity:add(Stand())

	return entity
end

return Player

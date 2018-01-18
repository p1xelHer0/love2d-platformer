local anim8 = require('lib/anim8/anim8')

require('src/components/Input')
require('src/components/Physics')
require('src/components/Platform')
require('src/components/SpawnPoint')
require('src/components/Sprite')

local Input, Physics, Platform, SpawnPoint, Sprite = Component.load({
	'Input',
	'Physics',
	'Platform',
	'SpawnPoint',
	'Sprite',
})

local function Player()
	local entity = Entity()

	local size = { w = 6, h = 14, }

	local image = love.graphics.newImage('assets/sprites/legdude.png')
	local g = anim8.newGrid(16, 16, image:getWidth(), image:getHeight(), 0)

	local animations = {
		idle = anim8.newAnimation(g('1-3', 1), 0.5),
		jump = anim8.newAnimation(g('5-1', 1), 0.5),
		crouch = anim8.newAnimation(g('6-1', 1), 0.5),
		fall = anim8.newAnimation(g('7-1', 1), 0.5),
	}

	entity:add(Input())
	entity:add(Physics(size))
	entity:add(Platform())
	entity:add(Sprite(image, animations))
	entity:add(SpawnPoint('player'))

	return entity
end

return Player

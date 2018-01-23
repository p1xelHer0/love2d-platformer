local bump = require('lib.bump.bump')
local sti = require('lib.sti.sti')

require('src.components.BumpWorld')
require('src.components.TileMap')
require('src.components.Physics')

local BumpWorld, TileMap, Physics = Component.load({
	'BumpWorld',
	'TileMap',
	'Physics',
})

local function Level(tileMapPath)
	local entity = Entity()

	local world = bump.newWorld()
	local map = sti(tileMapPath, {'bump'})
	map:bump_init(world)

	entity:add(BumpWorld(world))
	entity:add(TileMap(map))
	entity:add(Physics())

	return entity
end

return Level

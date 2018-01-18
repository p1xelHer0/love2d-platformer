local bump = require('lib.bump.bump')
local sti = require('lib.sti.sti')

require('src.components.BumpWorld')
require('src.components.TileMap')

local BumpWorld, TileMap = Component.load({
	'BumpWorld',
	'TileMap',
})

local function Level(tileMapPath)
	local entity = Entity()

	local world = bump.newWorld()
	local map = sti(tileMapPath, {'bump'})
	map:bump_init(world)

	entity:add(BumpWorld(world))
	entity:add(TileMap(map))

	return entity
end

return Level

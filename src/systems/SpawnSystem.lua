local SpawnSystem = class('SpawnSystem', System)

function SpawnSystem:initialize(level)
	System.initialize(self)
	self.bumpWorld = level:get('BumpWorld').world
	self.tileMap = level:get('TileMap').map
end

function SpawnSystem:onAddEntity(entity)
	local platform = entity:get('Platform')
	local physics = entity:get('Physics')
	local spawn_point = entity:get('SpawnPoint').point
	local position = platform.position
	local hitbox = physics.hitbox

	for _, object in pairs(self.tileMap.objects) do
    if object.name == spawn_point then
      position.x, position.y = object.x, object.y
      break
    end
  end

	self.bumpWorld:add(entity, position.x, position.y, hitbox.w, hitbox.h)
end

function SpawnSystem:onRemoveEntity(entity)
	self.bumpWorld:remove(entity)
end

function SpawnSystem:requires()
	return {
		'Physics',
		'Platform',
		'SpawnPoint',
	}
end

return SpawnSystem

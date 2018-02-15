local DeathSystem = class('DeathSystem', System)

function DeathSystem:initialize(level)
	System.initialize(self)
end

local function respawn(entity)
	local health = entity:get('Health')
	local position = entity:get('Position').coordinates
	local spawn_point = entity:get('SpawnPoint')

	if spawn_point then
		position.x = spawn_point.position.x
		position.y = spawn_point.position.y
		health.health = health.health_max
	end
end

function DeathSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local health = entity:get('Health')

		if health.health <= 0 then
			respawn(entity)
		end
	end
end

function DeathSystem:onAddEntity(entity)
end

function DeathSystem:onRemoveEntity(entity)
end

function DeathSystem:requires(entity)
	return {
		'Health',
	}
end

return DeathSystem

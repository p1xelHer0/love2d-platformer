local MovementSystem = class('MovementSystem', System)

function MovementSystem:initialize()
	System.initialize(self)
end

function MovementSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local direction = entity:get('Direction').value
		local speed = entity:get('Movement').speed
		local velocity = entity:get('Body').velocity

		-- Update velocity according to speed and direction
		velocity.x = speed * direction
	end
end

function MovementSystem:onRemoveEntity(entity)
	local velocity = entity:get('Body').velocity

	-- Stop entity when Movement component is removed
	velocity.x = 0
end

function MovementSystem.requires()
	return {
		'Body',
		'Direction',
		'Movement',
	}
end

return MovementSystem

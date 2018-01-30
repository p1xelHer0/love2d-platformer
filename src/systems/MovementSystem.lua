local MovementSystem = class('MovementSystem', System)
function MovementSystem:initialize(level)
	System.initialize(self)
end

function MovementSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local body = entity:get('Body')
		local direction = entity:get('Direction').value
		local movement = entity:get('Movement')

		local velocity = body.velocity

		-- Update velocity according to speed and direction
		velocity.x = movement.speed * direction
	end
end

function MovementSystem:onAddEntity()
end

function MovementSystem:onRemoveEntity(entity)
	local velocity = entity:get('Body').velocity
	-- Stop entity when Movement component is removed
	velocity.x = 0
end

function MovementSystem:requires(entity)
	return {
		'Body',
		'Direction',
		'Movement',
	}
end

return MovementSystem

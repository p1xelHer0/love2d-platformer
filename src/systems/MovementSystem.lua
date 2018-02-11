local round = require('lib.lume.lume').round

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
	local position = entity:get('Position').coordinates
	local direction = entity:get('Direction').value

	-- Stop entity when Movement component is removed
	velocity.x = 0

	-- Round position to integer, according to direction if possible
	local new_position
	if direction == 1 then
		new_position = math.ceil(position.x)
	elseif direction == -1 then
		new_position = math.floor(position.x)
	else
		new_position = round(position.x)
	end
	position.x = new_position
end

function MovementSystem:requires(entity)
	return {
		'Body',
		'Direction',
		'Movement',
		'Position',
	}
end

return MovementSystem

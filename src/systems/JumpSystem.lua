local Airborne = require('src.components.Airborne')

local JumpSystem = class('JumpSystem', System)

function JumpSystem:initialize()
	System.initialize(self)
end

function JumpSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local jump = entity:get('Jump')
		local input = entity:get('Input')
		local velocity = entity:get('Body').velocity

		-- Apply force on entity velocity to jump
		velocity.y = jump.force

		jump.time = jump.time + dt

		if jump.time > jump.time_min then
			jump.cancelable = true
			input.lock = false
		end

		if jump.time > jump.time_max then
			entity:remove('Jump')
		end
	end
end

function JumpSystem:onAddEntity(entity)
	local jump = entity:get('Jump')

	if entity:get('Grounded') then entity:remove('Grounded') end
	if not entity:get('Airborne') then entity:add(Airborne()) end

	-- This way we can wall jump
	if entity:get('Slide') then
		jump.wall = true

		local input = entity:get('Input')
		if input then
			input.lock = true
		end
	end
end

function JumpSystem:onRemoveEntity(entity)
		local input = entity:get('Input')
		if input then
			input.lock = false
		end
end

function JumpSystem.requires()
	return {
		'Body',
		'Jump',
	}
end

return JumpSystem

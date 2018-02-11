local Airborne = require('src.components.Airborne')

local JumpSystem = class('JumpSystem', System)

function JumpSystem:initialize(level)
	System.initialize(self)
end

function JumpSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local jump = entity:get('Jump')
		local velocity = entity:get('Body').velocity
		local direction = entity:get('Direction').value

		-- Apply force on entity velocity to jump
		velocity.y = jump.force

		if jump.wall then
			velocity.x = 50 * -direction
		end

		jump.time = jump.time + dt

		if not jump.wall then
			if jump.time > jump.time_min then
				jump.cancelable = true
			end
		end

		if jump.time > jump.time_max then
			entity:remove('Jump')
		end
	end
end

function JumpSystem:onAddEntity(entity)
	local jump = entity:get('Jump')
	-- This way we can wall jump
	if entity:get('Slide') then
		jump.wall = true
		entity:remove('Slide')
	end
	if entity:get('Stand') then entity:remove('Stand') end

	if not entity:get('Airborne') then entity:add(Airborne()) end
end

function JumpSystem:onRemoveEntity(entity)
end

function JumpSystem:requires(entity)
	return {
		'Body',
		'Jump',
	}
end

return JumpSystem

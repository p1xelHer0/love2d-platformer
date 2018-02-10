local Airborne = require('src.components.Airborne')

local JumpSystem = class('JumpSystem', System)

function JumpSystem:initialize(level)
	System.initialize(self)
end

function JumpSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local jump = entity:get('Jump')
		local velocity = entity:get('Body').velocity

		-- Apply force on entity velocity to jump
		velocity.y = jump.force

		jump.time = jump.time + dt

		if jump.time > jump.time_min then
			jump.cancelable = true
		end

		if jump.time > jump.time_max then
			entity:remove('Jump')
		end
	end
end

function JumpSystem:onAddEntity(entity)
	-- This way we can wall jump
	if entity:get('Slide') then entity:remove('Slide') end
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

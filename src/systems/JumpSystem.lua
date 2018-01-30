local JumpSystem = class('JumpSystem', System)
function JumpSystem:initialize(level)
	System.initialize(self)
end

function JumpSystem:update(dt)
	for _, entity in pairs(self.targets) do
	end
end

function JumpSystem:onAddEntity(entity)
	local force = entity:get('Jump').force
	local velocity = entity:get('Body').velocity

	-- Apply force on entity velocity to jump
	velocity.y = force
	-- This way we can wall jump
	if entity:get('Slide') then entity:remove('Slide') end
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

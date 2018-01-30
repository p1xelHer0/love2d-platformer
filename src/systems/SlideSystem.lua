local SlideSystem = class('SlideSystem', System)
function SlideSystem:initialize(level)
	System.initialize(self)
end

function SlideSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local velocity = entity:get('Body').velocity
		local modifier = entity:get('Slide').modifier

		velocity.y = velocity.y * modifier
	end
end

function SlideSystem:onAddEntity(entity)
	local jump = entity:get('Jump')
	-- We are sliding, no longer jumping
	-- i.e. landing on a wall
	if jump then entity:remove('Jump') end
end

function SlideSystem:onRemoveEntity(entity)
end

function SlideSystem:requires(entity)
	return {
		'Body',
		'Slide',
	}
end

return SlideSystem

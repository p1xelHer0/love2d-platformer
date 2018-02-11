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
	local airborne = entity:get('Airborne')
	local fall = entity:get('Fall')
	local input = entity:get('Input')
	local jump = entity:get('Jump')

	-- We are sliding, no longer jumping
	-- i.e. landing on a wall
	if fall then entity:remove('Fall') end
	if airborne then entity:remove('Airborne') end
	if jump then entity:remove('Jump') end

	if input then input.jump_count = 0 end
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

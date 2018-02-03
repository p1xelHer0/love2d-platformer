local StandSystem = class('StandSystem', System)
function StandSystem:initialize(level)
	System.initialize(self)
end

function StandSystem:update(dt)
	for _, entity in pairs(self.targets) do
	end
end

function StandSystem:onAddEntity(entity)
	local jump = entity:get('Jump')

	-- Standing means landing, we are no longer jumping
	if jump then entity:remove('Jump') end
end

function StandSystem:onRemoveEntity(entity)
end

function StandSystem:requires(entity)
	return {
		'Stand',
	}
end

return StandSystem
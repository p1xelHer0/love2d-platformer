local GroundedSystem = class('GroundedSystem', System)

function GroundedSystem:initialize()
	System.initialize(self)
end

function GroundedSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local input = entity:get('Input')
		if input then
			input.dash_count = 0
		end
	end
end

function GroundedSystem:onAddEntity(entity)
	local airborne = entity:get('Airborne')
	local input = entity:get('Input')
	local jump = entity:get('Jump')
	local slide = entity:get('Slide')

	-- Groundeding means landing, we are no longer jumping, being airborne or sliding
	if airborne then entity:remove('Airborne') end
	if jump then entity:remove('Jump') end
	if slide then entity:remove('Slide') end

	if input then
		input.jump_count = 0
	end
end

function GroundedSystem:onRemoveEntity(entity)
end

function GroundedSystem.requires()
	return {
		'Grounded',
	}
end

return GroundedSystem

local AnimationSystem = class('AnimationSystem', System)

function AnimationSystem:initialize()
	System.initialize(self)
end

function AnimationSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local animations = entity:get('Animation').animations

		animations.stand:update(dt)
	end
end

function AnimationSystem:requires()
	return {
		'Animation',
	}
end

return AnimationSystem

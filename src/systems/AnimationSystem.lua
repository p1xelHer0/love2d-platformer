local AnimationSystem = class('AnimationSystem', System)

function AnimationSystem:initialize()
	System.initialize(self)
end

function AnimationSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local animation = entity:get('Animation')

		if animation.current then
			animation.current:update(dt)
		end
	end
end

function AnimationSystem.requires()
	return {
		'Animation',
	}
end

return AnimationSystem

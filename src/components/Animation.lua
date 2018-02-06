local Animation = Component.create('Animation')

function Animation:initialize(animations)
	self.animations = animations
	self.current = nil
end

return Animation

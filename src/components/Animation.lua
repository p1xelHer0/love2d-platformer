local Animation = Component.create('Animation')

function Animation:initialize(image, animations)
  self.animations = animations
  self.image = image
  self.current = nil
end

return Animation

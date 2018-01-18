local Sprite = Component.create('Sprite')

function Sprite:initialize(image, animations)
	self.image = image
	self.animations = animations
end

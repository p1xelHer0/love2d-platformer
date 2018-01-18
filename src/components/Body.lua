local Body = Component.create('Body')

function Body:initialize(size)
	self.size = size
	self.hitbox = size

	self.velocity = vector(0, 0)

	self.gravity = vector(0, 400)
end

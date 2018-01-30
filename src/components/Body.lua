local Body = Component.create('Body')

function Body:initialize(size)
	self.size = size
	self.hitbox = size

	self.velocity = vector(0, 0)

	self.mass = 8
end

return Body

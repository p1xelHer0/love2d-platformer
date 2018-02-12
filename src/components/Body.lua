local Body = Component.create('Body')

function Body:initialize(size, mass)
	self.size = size or { w = 16, h = 16, }
	self.hitbox = size or { w = 16, h = 16, }

	self.velocity = vector(0, 0)

	self.mass = mass or 8
end

return Body

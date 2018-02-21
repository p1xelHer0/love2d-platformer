local Body = Component.create('Body')

function Body:initialize(hitbox, mass)
	self.hitbox = hitbox or { w = 16, h = 16, }
	self.velocity = vector(0, 0)
	self.mass = mass or 8
end

return Body

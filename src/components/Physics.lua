local Physics = Component.create('Physics')

function Physics:initialize(size)
	self.size = size
	self.hitbox = size

	self.velocity = {
		x = 0,
		y = 0,
	}

	self.gravity = {
		x = 0,
		y = 400,
	}
end

local Platform = Component.create('Platform')

function Platform:initialize()
	self.position = vector(0, 0)

	self.direction = 1

	self.speed = 80

	self.moving = false

	self.jumping = false
	self.jump_prev = false
	self.jump_count = 0
	self.jump_count_max = 2
	self.jump_force = -120

	self.crouching = false
	self.crouch_prev = false
	self.crouch_modifier = 0.5

	self.falling = false
	self.fall_speed = 150

	self.sliding = false
	self.slide_modifier = 0.8

	self.grounded = false
end

local Movement = Component.create('Movement')

function Movement:initialize()
	self.position = vector(0, 0)
	self.moving = false
	self.direction = 1
	self.speed = 80
end

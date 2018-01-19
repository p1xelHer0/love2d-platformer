local Movement = Component.create('Movement')

function Movement:initialize()
	self.moving = false
	self.direction = 1
	self.speed = 80
end

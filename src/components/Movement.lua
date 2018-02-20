local Movement = Component.create('Movement')

function Movement:initialize(speed)
	self.speed = speed or 80
end

return Movement

local Movement = Component.create('Movement')

function Movement:initialize(speed)
	self.speed = speed or 100
end

return Movement

local Trail = Component.create('Trail')

function Trail:initialize()
	self.radius = love.math.random(1, 4)
	self.position = {}
	self.timer = nil
end

return Trail

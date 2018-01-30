local Position = Component.create('Position')

function Position:initialize()
	self.coordinates = vector(0, 50)
end

return Position

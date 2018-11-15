local Position = Component.create('Position')

function Position:initialize(x, y)
  self.coordinates = vector(x or 0, y or 0)
end

return Position

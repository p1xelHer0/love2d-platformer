local SpawnPoint = Component.create('SpawnPoint')

function SpawnPoint:initialize(x, y)
  self.coordinates = vector(x or 0, y or 0)
end

return SpawnPoint

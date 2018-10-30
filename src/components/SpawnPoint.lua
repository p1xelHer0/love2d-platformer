local SpawnPoint = Component.create('SpawnPoint')

function SpawnPoint:initialize(spawn_point)
  self.point = spawn_point
  self.position = { x = 0, y = 0, }
end

return SpawnPoint

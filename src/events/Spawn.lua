local Spawn = class('Spawn')

function Spawn:initialize(name, x, y)
  -- corresponds to Tiled Object Name
  self.name = name
  self.coordinates = vector(x or 0, y or 0)
end

return Spawn

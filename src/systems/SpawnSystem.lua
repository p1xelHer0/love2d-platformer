local Mustasch = require('src.entities.Mustasch')
local Player = require('src.entities.Player')

local SpawnSystem = class("SpawnSystem", System)

function SpawnSystem:fireEvent(event)
  local x, y = event.coordinates.x, event.coordinates.y

  if event.name == "player" then
    engine:addEntity(Player(x, y, camera))
  elseif event.name == "mustasch" then
    engine:addEntity(Mustasch(x, y))
  end
end

return SpawnSystem

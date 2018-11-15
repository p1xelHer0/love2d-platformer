local CameraSystem = class('CameraSystem', System)

function CameraSystem:initialize()
  System.initialize(self)
  self.target = vector(0, 0)
end

function CameraSystem:update(dt)
  for _, entity in pairs(self.targets) do
    local camera = entity:get('Camera').camera
    local position = entity:get('Position').coordinates

    local direction = entity:get('Direction')

    local movement = entity:get('Movement')
    local crouch = entity:get('Crouch')

    -- offset according to player sprite as of now
    self.target = {
      x = position.x + 2,
      y = position.y + 2,
    }

    local _, _, camera_window_width, camera_window_height = camera:getWindow()

    if crouch then
      self.target.y = self.target.y - 7
    end

    self.target.x = lume.round(self.target.x)
    self.target.y = lume.round(self.target.y)

    camera:setPosition(self.target.x, self.target.y)
  end
end

function CameraSystem.requires()
  return {
    'Camera',
    'Position',
  }
end

return CameraSystem

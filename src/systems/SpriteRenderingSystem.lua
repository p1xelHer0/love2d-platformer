local SpriteRenderingSystem = class('AnimationRenderingSystem', System)

function SpriteRenderingSystem:initialize(camera)
  System.initialize(self)
  self.camera = camera
end

function SpriteRenderingSystem:draw()
  love.graphics.setBackgroundColor(33, 33, 33)
  for _, entity in pairs(self.targets) do
    local image = entity:get('Sprite').image

    local position = entity:get('Position').coordinates
    local direction = entity:get('Direction')

    local dir
    if not direction then
      dir = 1
    else
      dir = direction.value
    end

    local offset = {
      x = 0,
      y = 0,
    }

    local draw_properties = {
      image,
      position.x,
      position.y,
      0,
      dir,
      1,
      offset.x,
      offset.y,
    }

    -- Render the animations
    self.camera:draw(
      function()
        love.graphics.draw(unpack(draw_properties))
      end
    )
  end
end

function SpriteRenderingSystem.requires()
  return {
    'Sprite',
  }
end

return SpriteRenderingSystem

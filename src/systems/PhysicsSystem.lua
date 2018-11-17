local Fall = require('src.components.Fall')

local PhysicsSystem = class('PhysicsSystem', System)

function PhysicsSystem:initialize(level)
  System.initialize(self)
  self.gravity = level:get('Physics').gravity
end

function PhysicsSystem:update(dt)
  for _, entity in pairs(self.targets) do
    local body = entity:get('Body')
    local floating =  entity:get('Floating')
    local velocity = body.velocity

    -- We are moving downwards, we are falling
    -- as of now, we might get problems in the future with elevators and such
    if velocity.y > 0 then
      if not entity:get('Fall') then entity:add(Fall()) end
    else
      if entity:get('Fall') then entity:remove('Fall') end
    end

    local modifier = 1
    if floating then
      modifier = floating.modifier
    end

    local max_up = -120
    local max_down = 180

    -- Entity is affected by gravity constantly
    -- Clamp velocity to prevent infinite fallig speed
    -- Apply floating modifier on falling speed
    velocity.y = lume.clamp(
      velocity.y + body.mass * self.gravity.y * dt,
      max_up,
      max_down * modifier
    )

    -- Do the same for x
    velocity.x = lume.clamp(
      velocity.x + body.mass * self.gravity.x * dt,
      max_up,
      max_down
    )
  end
end

function PhysicsSystem.requires()
  return {
    'Body',
  }
end

return PhysicsSystem

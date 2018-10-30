local Airborne = require('src.components.Airborne')

local JumpSystem = class('JumpSystem', System)

function JumpSystem:initialize()
  System.initialize(self)
end

function JumpSystem:update(dt)
  for _, entity in pairs(self.targets) do
    local jump = entity:get('Jump')
    local velocity = entity:get('Body').velocity

    jump.timer_min:update(dt)
    jump.timer_max:update(dt)

    -- Apply force on entity velocity to jump
    velocity.y = jump.force
  end
end

function JumpSystem:onAddEntity(entity)
  local jump = entity:get('Jump')

  jump.timer_min = Timer.new()
  jump.timer_max = Timer.new()

  --  Setup timers
  jump.timer_min:after(
    jump.time_min,
    function()
      jump.cancelable = true
    end
  )

  jump.timer_max:after(
    jump.time_max,
    function()
      entity:remove('Jump')
    end
  )

  if entity:get('Grounded') then entity:remove('Grounded') end
  if not entity:get('Airborne') then entity:add(Airborne()) end

  -- This way we can wall jump
  if entity:get('Slide') then
    jump.wall = true

    local input = entity:get('Input')
    if input then
      input.lock = true
    end
  end
end

function JumpSystem:onRemoveEntity(entity)
    local input = entity:get('Input')
    if input then
      input.lock = false
    end
end

function JumpSystem.requires()
  return {
    'Body',
    'Jump',
  }
end

return JumpSystem

local Dash = require('src.components.Dash')
local Crouch = require('src.components.Crouch')
local Jump = require('src.components.Jump')
local Movement = require('src.components.Movement')

local InputSystem = class('InputSystem', System)

function InputSystem:initialize()
  System.initialize(self)
end

local function can_jump(entity)
  local input = entity:get('Input')

  -- We can only jump while grounded or airborne
  if input.jump_canceled then
    local airborne = entity:get('Airborne')
    local crouch = entity:get('Crouch')
    local grounded = entity:get('Grounded')
    local jump = entity:get('Jump')

    if crouch or jump then
      return false
    elseif airborne then
      -- If we are airborne, we need to check the maxmimum amount of jump
      -- We also need to check if the jump has been canceled
      return input.jump_canceled and input.jump_count < input.jump_count_max
    elseif grounded then
      return true
    end
  end

  return false
end

local function can_crouch(entity)
  local grounded = entity:get('Grounded')

  -- We can only crouch while grounded
  if grounded then
    return true
  end

  return false
end

local function can_dash(entity)
  local crouch = entity:get('Crouch')
  local dash = entity:get('Dash')
  local input = entity:get('Input')

  -- We can only jump while grounded
  if crouch then
    return false
  elseif input.dash_canceled then
    return input.dash_count < input.dash_count_max
  end

  return false
end

function InputSystem:update(dt)
  -- ASD and Space as of now for input
  local left, right, down, space, k =
    love.keyboard.isDown('a'),
    love.keyboard.isDown('d'),
    love.keyboard.isDown('s'),
    love.keyboard.isDown('space'),
    love.keyboard.isDown('k')

  for _, entity in pairs(self.targets) do
    local input = entity:get('Input')

    if not input.lock then
      local dash = entity:get('Dash')
      local crouch = entity:get('Crouch')
      local direction = entity:get('Direction')
      local jump = entity:get('Jump')
      local movement = entity:get('Movement')

      -- Update movement and direction according to L/R
      if left and not right then
        direction.value = -1
        if not movement then
          entity:add(Movement())
        end
      elseif right and not left then
        direction.value = 1
        if not movement then
          entity:add(Movement())
        end
      else
        if movement then entity:remove('Movement') end
      end

      if space and can_jump(entity) then
        entity:add(Jump())
        input.jump_canceled = false
        input.jump_count = input.jump_count + 1
      end

      if not space then
        input.jump_canceled = true
        if jump then
          if jump.cancelable then
            entity:remove('Jump')
          end
        end
      end

      if down and can_crouch(entity) then
        if not crouch then entity:add(Crouch()) end
      end

      if not down then
        if crouch then
          if crouch.cancelable then entity:remove('Crouch') end
        end
      end

      if k then
        if can_dash(entity) then
          entity:add(Dash())
          input.dash_canceled = false
          input.dash_count = input.dash_count + 1
          -- TODO cooldown till dash, fixa
          input.dash_cooldown = 0
        end
      end

      if not k then
        input.dash_canceled = true
      end
    end
  end
end

function InputSystem.requires()
  return {
    'Input',
    'Playable',
  }
end

return InputSystem

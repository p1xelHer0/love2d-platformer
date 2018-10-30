local Airborne = require('src.components.Airborne')
local Grounded = require('src.components.Grounded')

local CollisionSystem = class('CollisionSystem', System)

function CollisionSystem:initialize(level)
  System.initialize(self)
  self.bumpWorld = level:get('BumpWorld').world
  self.tileMap = level:get('TileMap').map
end

function CollisionSystem.kill(entity)
  local health = entity:get('Health')
  if health then
    health.health = 0
  end
end

function CollisionSystem:update(dt)
  for _, entity in pairs(self.targets) do
    local body = entity:get('Body')

    local position = entity:get('Position').coordinates

    local hitbox, velocity = body.hitbox, body.velocity

    -- New position according to velocity and delta
    local newPosition = vector(
      position.x + velocity.x * dt,
      position.y + velocity.y * dt
    )

    -- We need to update the entity if the hitbox changes
    self.bumpWorld:update(entity, position.x, position.y, hitbox.w, hitbox.h)

    -- Move and return collisions
    local collisions, length
    position.x, position.y, collisions, length = self.bumpWorld:move(
      entity, newPosition.x, newPosition.y
    )

    -- No collisions, Entity can't be grounded
    if length == 0 then
      if not entity:get('Airborne') then entity:add(Airborne()) end

      if entity:get('Grounded') then entity:remove('Grounded') end
      if entity:get('Slide') then entity:remove('Slide') end
    else
      for i = 1, length do
        local collision = collisions[i]

        if collision.other then
          if collision.other.layer then
            if collision.other.layer.name == 'Spikes' then
              self.kill(entity)
            end
          end
        end

        -- We collided on bottom
        -- Entity is on the ground
        if collision.normal.y == -1 then
          if not entity:get('Grounded') then entity:add(Grounded()) end
          velocity.y = 0
        end

        -- We collided on top
        -- Entity is on the ceiling
        if collision.normal.y == 1 then
          if entity:get('Jump') then entity:remove('Jump') end
          velocity.y = 0
        end

        -- We collided on L/R
        -- For wall jumping and sliding
        if collision.normal.x == 1 or collision.normal.x == -1 then
          -- We are moving downwards and colliding with a wall, we are sliding
          if entity:get('Fall') then
            -- TODO
            -- if not entity:get('Slide') then entity:add(Slide()) end
          end
        end
      end
    end
  end
end

function CollisionSystem:onAddEntity(entity)
  local position = entity:get('Position').coordinates
  local body = entity:get('Body')
  local spawn_point = entity:get('SpawnPoint')
  local hitbox = body.hitbox

  -- Add the Entity at the spawn_point position if present
  if spawn_point then
    local point = spawn_point.point
    for _, object in pairs(self.tileMap.objects) do
      if object.name == point then
        spawn_point.position.x, spawn_point.position.y = object.x, object.y
        position.x, position.y = object.x, object.y
        break
      end
    end
  end

  self.bumpWorld:add(entity, position.x, position.y, hitbox.w, hitbox.h)
end

function CollisionSystem:onRemoveEntity(entity)
  self.bumpWorld:remove(entity)
end

function CollisionSystem.requires()
  return {
    'Body',
    'Position',
  }
end

return CollisionSystem

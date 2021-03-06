local Airborne = require('src.components.Airborne')
local Floating = require('src.components.Floating')
local Grounded = require('src.components.Grounded')
-- local Slide = require('src.components.Slide')
local SpawnSystem = require('src.systems.SpawnSystem')
local Spawn = require('src.events.Spawn')


local CollisionSystem = class('CollisionSystem', System)

function CollisionSystem:initialize(level)
  System.initialize(self)
  self.bumpWorld = level:get('BumpWorld').world
  self.tileMap = level:get('TileMap').map

  -- Objects in Tiled should be spawned
  for _, object in pairs(self.tileMap.objects) do
    local position = vector(object.x, object.y)
    -- fire `Spawn` event
    eventManager:fireEvent(Spawn(object.name, position.x, position.y))
  end
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
      entity, newPosition.x, newPosition.y, collisionFilter
    )

    -- No collisions, Entity can't be grounded
    if length == 0 then
      if not entity:get('Airborne') then entity:add(Airborne()) end

      if entity:get('Grounded') then entity:remove('Grounded') end
      -- if entity:get('Slide') then entity:remove('Slide') end
    else
      for i = 1, length do
        local collision = collisions[i]
        local other = collision.other
        local collide = true

        if other then
          if other.components then
            if other.components.Collectible then
              -- handle collectibles
              engine:removeEntity(other)
              entity:add(Floating())
              collide = false
            end
          end
        end

        if collide then
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
end

function CollisionSystem:onAddEntity(entity)
  local position = entity:get('Position').coordinates
  local body = entity:get('Body')
  local hitbox = body.hitbox

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

local collisionFilter = function(item, other)
  if other.components then
    if other.components.Collectible then
      return 'cross'
    end
  else
    return 'slide'
  end
end

return CollisionSystem


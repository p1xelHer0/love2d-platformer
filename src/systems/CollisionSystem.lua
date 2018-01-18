local bump = require('lib.bump.bump')
local sti = require('lib.sti.sti')
local round = require('lib.lume.lume').round

local CollisionSystem = class('CollisionSystem', System)

function CollisionSystem:initialize(level)
	System.initialize(self)
	self.bumpWorld = level:get('BumpWorld').world
end

function CollisionSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local platform = entity:get('Platform')
		local physics = entity:get('Physics')

		local position, jump_force, fall_speed =
			platform.position,
			platform.jump_force,
			platform.fall_speed

		local hitbox, velocity = physics.hitbox, physics.velocity

		-- New position according to velocity and delta
		local newPosition = {
			x = position.x + velocity.x * dt,
			y = position.y + velocity.y * dt,
		}

		-- 7 is the amount of pixels the hitbox decreases while crouching
    -- this way the character moves to the ground directly
    -- instead of shrinking and then falling to the ground
		if platform.crouch_prev then
			newPosition.y = newPosition.y + 7
		end

		-- we need to update the entity if the hitbox changes
		self.bumpWorld:update(entity,	position.x, position.y, hitbox.w, hitbox.h)

		-- Move and return collisions
		local collisions, length
		position.x, position.y, collisions, length = self.bumpWorld:move(
			entity, newPosition.x, newPosition.y
		)

		-- No collisions, not grounded nor sliding
		if length == 0 then
			platform.grounded = false
			platform.sliding = false
		end

		-- Collision, grounded
		for i = 1, length do
			local collision = collisions[i]

			-- Entity collides on bottom
			-- Entity is on the ground
			if collision.normal.y == -1 then
				platform.grounded = true
				velocity.y = 0
			end

			-- Entity collides on top
			-- Entity is on the ceiling
			if collision.normal.y == 1 then
				velocity.y = 0
			end

			-- Entity collides on left/right
			-- For wall jumping and sliding
			if collision.normal.x == 1 or collision.normal.x == -1 then
				-- This allows us to wall jump
				platform.sliding = true
			else
				platform.sliding = false
			end
		end
	end
end

function CollisionSystem:onAddEntity(entity)
	if entity:get('SpawnPoint') then
		return
	end
	local platform = entity:get('Platform')
	local physics = entity:get('Physics')
	local position = platform.position
	local hitbox = physics.hitbox

	self.bumpWorld:add(entity, position.x, position.y, hitbox.w, hitbox.h)
end

function CollisionSystem:onRemoveEntity(entity)
	if entity:get('SpawnPoint') then
		return
	end
	self.bumpWorld:remove(entity)
end

function CollisionSystem:requires()
	return {
		'Physics',
		'Platform',
	}
end

return CollisionSystem

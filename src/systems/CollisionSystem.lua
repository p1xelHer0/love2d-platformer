local bump = require('lib.bump.bump')
local sti = require('lib.sti.sti')
local round = require('lib.lume.lume').round

local CollisionSystem = class('CollisionSystem', System)

function CollisionSystem:initialize(level)
	System.initialize(self)
	self.bumpWorld = level:get('BumpWorld').world
	self.tileMap = level:get('TileMap').map
end

function CollisionSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local body = entity:get('Body')

		local movement = entity:get('Movement')

		local crouch = entity:get('Crouch')
		local fall = entity:get('Fall')
		local jump = entity:get('Jump')
		local slide = entity:get('Slide')
		local stand = entity:get('Stand')

		local position, jump_force, fall_speed =
			movement.position,
			jump.jump_force,
			fall.fall_speed

		local hitbox, velocity = body.hitbox, body.velocity

		-- New position according to velocity and delta
		local newPosition = {
			x = position.x + velocity.x * dt,
			y = position.y + velocity.y * dt,
		}

		-- 7 is the amount of pixels the hitbox decreases while crouching
    -- this way the character moves to the ground directly
    -- instead of shrinking and then falling to the ground
		if crouch.crouch_current_frame then
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
			stand.standing = false
			slide.sliding = false
		end

		-- Collision, grounded
		for i = 1, length do
			local collision = collisions[i]

			-- Entity collides on bottom
			-- Entity is on the ground
			if collision.normal.y == -1 then
				stand.standing = true
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
				slide.sliding = true
			else
				slide.sliding = false
			end
		end
	end
end

function CollisionSystem:onAddEntity(entity)
	local movement = entity:get('Movement')
	local body = entity:get('Body')
	local spawn_point = entity:get('SpawnPoint')
	local position = movement.position
	local hitbox = body.hitbox

	if spawn_point then
		local point = spawn_point.point
		for _, object in pairs(self.tileMap.objects) do
			if object.name == point then
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

function CollisionSystem:requires()
	return {
		'Body',
		'Movement',
	}
end

return CollisionSystem

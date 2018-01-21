local bump = require('lib.bump.bump')
local sti = require('lib.sti.sti')

local fsm = require('src.fsm')

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

		local jump = entity:get('Jump')
		local crouch = entity:get('Crouch')
		local fall = entity:get('Fall')
		local slide = entity:get('Slide')
		local stand = entity:get('Stand')

		local position = movement.position

		local hitbox, velocity = body.hitbox, body.velocity

		-- New position according to velocity and delta
		local newPosition = vector(
			position.x + velocity.x * dt,
			position.y + velocity.y * dt
		)

		-- 7 is the amount of pixels the hitbox decreases while crouching
    -- this way the character moves to the ground directly
    -- instead of shrinking and then falling to the ground
		if crouch.crouch_current_frame then
			newPosition.y = newPosition.y + 7
		end

		-- We need to update the entity if the hitbox changes
		 self.bumpWorld:update(entity, position.x, position.y, hitbox.w, hitbox.h)

		-- Move and return collisions
		local collisions, length
		position.x, position.y, collisions, length = self.bumpWorld:move(
			entity, newPosition.x, newPosition.y
		)

		-- No collisions, this means we cant be standing or sliding
		if length == 0 then
			stand.standing = false
			slide.sliding = false
		else
			for i = 1, length do
				local collision = collisions[i]

				-- We collided on bottom
				-- Entity is on the ground
				if collision.normal.y == -1 then
					fsm('land', entity)
				end

				-- We collided on top
				-- Entity is on the ceiling
				if collision.normal.y == 1 then
					velocity.y = 0
				end

				-- We collided on L/R
				-- For wall jumping and sliding
				if collision.normal.x == 1 or collision.normal.x == -1 then
					-- We are moving downwards and colliding with a wall, we are sliding
					if fall.falling then
						fsm('slide', entity)
					end
				end
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

local Slide = require('src.components.Slide')
local Stand = require('src.components.Stand')

local CollisionSystem = class('CollisionSystem', System)

function CollisionSystem:initialize(level)
	System.initialize(self)
	self.bumpWorld = level:get('BumpWorld').world
	self.tileMap = level:get('TileMap').map
end

function CollisionSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local body = entity:get('Body')
		local crouch = entity:get('Crouch')

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

		-- No collisions, Entity can't be standing
		if length == 0 then
			if entity:get('Stand') then entity:remove('Stand') end
			if entity:get('Slide') then entity:remove('Slide') end
		else
			for i = 1, length do
				local collision = collisions[i]

				-- We collided on bottom
				-- Entity is on the ground
				if collision.normal.y == -1 then
					velocity.y = 0
					if not entity:get('Stand') then entity:add(Stand()) end
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
					if entity:get('Fall') then
						if not entity:get('Slide') then entity:add(Slide()) end
					end
				else
					if entity:get('Slide') then entity:remove('Slide') end
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
		'Position',
	}
end

return CollisionSystem

local bump = require('lib.bump.bump')
local sti = require('lib.sti.sti')
local clamp = require('lib.lume.lume').clamp

local CollisionSystem = class('CollisionSystem', System)

function CollisionSystem:initialize(level)
	System.initialize(self)
	self.bumpWorld = level:get('BumpWorld').world
end

function CollisionSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local platform = entity:get('Platform')
		local physics = entity:get('Physics')

		local position, jump_force, fall_speed=
			platform.position, platform.jump_force, platform.fall_speed
		local hitbox, velocity = physics.hitbox, physics.velocity
		local gravity = physics.gravity

		velocity.y = clamp(
			velocity.y + gravity.y * dt, jump_force, fall_speed
		)

		local newPosition = {
			x = position.x + velocity.x * dt,
			y = position.y + velocity.y * dt,
		}

		local collisions, length
		position.x, position.y, collisions, length = self.bumpWorld:move(
		  entity, newPosition.x, newPosition.y
		)

		if length == 0 then
			platform.grounded = false
		end

		for i = 1, length do
			platform.grounded = true
			velocity.y = 0
			local collision = collisions[i]
		end
	end
end

function CollisionSystem:onAddEntity(entity)
	local platform = entity:get('Platform')
	local physics = entity:get('Physics')
	local position = platform.position
	local hitbox = physics.hitbox

	self.bumpWorld:add(entity, position.x, position.y, hitbox.w, hitbox.h)
end

function CollisionSystem:onRemoveEntity(entity)
	self.bumpWorld:remove(entity)
end

function CollisionSystem:requires()
	return {
		'Physics',
		'Platform',
	}
end

return CollisionSystem

local clamp = require('lib.lume.lume').clamp
local PlatformingSystem = class('PlatformingSystem', System)

function PlatformingSystem:initialize()
	System.initialize(self)
end

function PlatformingSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local platform = entity:get('Platform')
		local body = entity:get('Body')

		local hitbox, size, velocity =
			body.hitbox,
			body.size,
			body.velocity

		-- Velocity on the x-axis stops instantly, no acceleraction
		velocity.x = 0

	  -- Apply jump if jumping
		if platform.jumping then
			velocity.y = platform.jump_force
		end

		-- Downwards velocity means the entity is falling
		if velocity.y > 0 then
			platform.falling = true
		else
			platform.falling = false
		end

		-- Add velocity according to direction
		if platform.moving then
			if platform.sliding then
			else
				velocity.x = platform.speed * platform.direction
			end
		end

		-- Entity is affected by gravity constantly
		-- Clamp velocity to prevent infinite fallig speed
			velocity.y = clamp(
				velocity.y + body.gravity.y * dt, platform.jump_force, platform.fall_speed
			)

		-- Modifiers to velocity
		-- Crouching, hitbox is lower
		-- Crouching, move slower on the x-axis
		if platform.crouching then
			hitbox.h = 7
			velocity.x = velocity.x * platform.crouch_modifier
		else
			hitbox.h = 14
		end

		-- Sliding downwards, move slower on the y-axis
		if platform.falling and platform.sliding then
			velocity.y = velocity.y * platform.slide_modifier
		end
	end
end

function PlatformingSystem:requires()
	return {
		'Body',
		'Platform',
	}
end

return PlatformingSystem

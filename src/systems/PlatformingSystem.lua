local clamp = require('lib.lume.lume').clamp
local PlatformingSystem = class('PlatformingSystem', System)

function PlatformingSystem:initialize()
	System.initialize(self)
end

function PlatformingSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local body = entity:get('Body')
		local movement = entity:get('Movement')

		local crouch = entity:get('Crouch')
		local fall = entity:get('Fall')
		local jump = entity:get('Jump')
		local slide = entity:get('Slide')
		local stand = entity:get('Stand')

		local hitbox, size, velocity =
			body.hitbox,
			body.size,
			body.velocity

		-- Velocity on the x-axis stops instantly, no acceleraction
		velocity.x = 0

	  -- Apply jump if jumping
	  if jump then
			if jump.jumping then
				velocity.y = jump.jump_force
			end
		end

		-- Downwards velocity means the entity is falling
		if fall then
			if velocity.y > 0 then
				fall.falling = true
			else
				fall.falling = false
			end
		end

		-- Add velocity according to direction
		if movement.moving then
			velocity.x = movement.speed * movement.direction
		end

		-- Entity is affected by gravity constantly
		-- Clamp velocity to prevent infinite fallig speed
			velocity.y = clamp(
				velocity.y + body.gravity.y * dt, jump.jump_force or 100, fall.fall_speed
			)

		-- Modifiers to velocity
		-- Crouching, hitbox is lower
		-- Crouching, move slower on the x-axis
		if crouch then
			if crouch.crouching then
				hitbox.h = 7
				velocity.x = velocity.x * crouch.crouch_modifier
			else
				hitbox.h = 14
			end
		end

		-- Sliding downwards, move slower on the y-axis
		if slide then
			if slide.sliding then
				velocity.y = velocity.y * slide.slide_modifier
			end
		end
	end
end

function PlatformingSystem:requires()
	return {
		'Body',
		'Movement',
	}
end

return PlatformingSystem

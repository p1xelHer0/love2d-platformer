local clamp = require('lib.lume.lume').clamp
local fsm = require('src.fsm')
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

		-- Add velocity according to direction
		if movement.moving then
			fsm('move', entity)
			velocity.x = movement.speed * movement.direction
		end

		if stand.standing then
			jump.jump_count = 0
		end

	  -- We only apply jump force on the first frame of jumping
		if jump.jump_current_frame then
			fsm('jump', entity)
			velocity.y = jump.jump_force
			jump.jump_count = jump.jump_count + 1
		end


		-- Modifiers to velocity
		-- Crouching, hitbox is lower
		-- Crouching, move slower on the x-axis
		if crouch.crouching then
			fsm('crouch', entity)
			velocity.x = velocity.x * crouch.crouch_modifier
			hitbox.h = 7
		else
			hitbox.h = 14
		end

		-- Sliding downwards, move slower on the y-axis
		if slide.sliding then
			jump.jump_count = jump.jump_count_max - 1
			velocity.y = velocity.y * slide.slide_modifier
		elseif velocity.y > 0 then
			fsm('fall', entity)
		end

		-- Entity is affected by gravity constantly
		-- Clamp velocity to prevent infinite fallig speed
		velocity.y = clamp(
			velocity.y + body.gravity.y * dt, jump.jump_force or 100, fall.fall_speed
		)
	end
end

function PlatformingSystem:requires()
	return {
		'Body',
		'Movement',
	}
end

return PlatformingSystem

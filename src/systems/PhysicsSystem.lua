local clamp = require('lib.lume.lume').clamp
local fsm = require('src.fsm')

local PhysicsSystem = class('PhysicsSystem', System)
function PhysicsSystem:initialize(level)
	System.initialize(self)
	self.gravity = level:get('Physics').gravity
end

function PhysicsSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local body = entity:get('Body')

		local jump = entity:get('Jump')
		local fall = entity:get('Fall')
		local slide = entity:get('Slide')

		local velocity = body.velocity

		-- Sliding downwards, move slower on the y-axis
		-- Also, we can jump again
		if slide.sliding then
			velocity.y = velocity.y * slide.slide_modifier
		-- We are not sliding and moving downwards, we are falling
		elseif velocity.y > 0 then
			fsm('fall', entity)
		end

		-- Entity is affected by gravity constantly
		-- Clamp velocity to prevent infinite fallig speed
		velocity.y = clamp(
			velocity.y + body.mass * self.gravity.y * dt,
			jump.jump_force,
			fall.fall_speed
		)
	end
end

function PhysicsSystem:requires()
	return {
		'Body',
	}
end

return PhysicsSystem

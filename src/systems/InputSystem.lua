local InputSystem = class('InputSystem', System)

function InputSystem:initialize()
	System.initialize(self)
end

function InputSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local input = entity:get('Input')
		local movement = entity:get('Movement')

		local crouch = entity:get('Crouch')
		local fall = entity:get('Fall')
		local jump = entity:get('Jump')
		local slide = entity:get('Slide')
		local stand = entity:get('Stand')

		-- WASD and Space as of now for input
		local left, right, down, space =
			love.keyboard.isDown('a'),
			love.keyboard.isDown('d'),
			love.keyboard.isDown('s'),
			love.keyboard.isDown('space')

		-- We assume we are not jumping or crouching
		jump.jumping = false
		crouch.crouch_current_frame = false

		-- Update movement and direction according to L/R
		if left and not right then
			movement.moving = true
			movement.direction = -1
		elseif right and not left then
			movement.moving = true
			movement.direction = 1
		else
			movement.moving = false
		end

		-- Update crouching according to input
		-- We can only crouch on the ground
		if stand then
			if crouch then
				if down and stand.standing then
					if not crouch.crouching then
						-- Save the first frame of crouching
						crouch.crouch_current_frame = true
					end
					crouch.crouching = true
				end
			end

			if stand.standing then
				-- We cant stand and crouch at the same time
				crouch.crouching = false

				-- Reset jump counter when touching the ground
				jump.jump_count = 0
				-- We did not press jump the frame before
				-- Prevents us from holding jump and fly
				if not space then
					-- If we are standing and not pressing space, we are not jumping
					jump.jump_current_frame = false
				end
			end
		end

		if slide then
			if slide.sliding then
				jump.jump_count = jump.jump_count_max - 1
			end
		end

		-- We pressed jump, we want to jump
		if space then
			-- We can only jump if we did not jump the frame before
			if not jump.jump_prev then
				if
					-- If we are on the ground or sliding, we can always jump
					stand.standing or slide.sliding
					or
					-- We are not on the ground or sliding, we are in the air
					-- We can only jump in the air if:
					--	 We have not exceeded the maximum amount of jumps
					not stand.standing and
					not slide.sliding and
					jump.jump_count < jump.jump_count_max
					then
						jump.jumping = true
						jump.jump_count = jump.jump_count + 1
						jump.jump_prev = true
				end
			end
		end
	end
end

function InputSystem:requires()
	return {
		'Input',
		'Movement',
	}
end

return InputSystem

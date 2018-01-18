local InputSystem = class('InputSystem', System)

function InputSystem:initialize()
	System.initialize(self)
end

function InputSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local platform = entity:get('Platform')
		local input = entity:get('Input')

		-- WASD and Space as of now for input
		local left, right, down, space =
			love.keyboard.isDown('a'),
			love.keyboard.isDown('d'),
			love.keyboard.isDown('s'),
			love.keyboard.isDown('space')

		-- We assume we are not jumping or crouching
		platform.jumping = false
		platform.crouch_prev = false

		-- Update movement and direction according to L/R
		if left and not right then
			platform.moving = true
			platform.direction = -1
		elseif right and not left then
			platform.moving = true
			platform.direction = 1
		else
			platform.moving = false
		end

		-- Update crouching according to input
		-- We can only crouch on the ground
		if down and platform.grounded then
			if not platform.crouching then
				-- save the first frame of crouching
				platform.crouch_prev = true
			end
			platform.crouching = true
		end

		if not down and platform.grounded then
			platform.crouching = false
		end

		-- We did not press jump the frame before
		-- Prevents us from holding jump and fly
		if not space then
			platform.jump_prev = false
		end

		-- Reset jump counter when touching the ground
		if platform.grounded then
			platform.jump_count = 0
		end

		--
		if platform.sliding then
			platform.jump_count = platform.jump_count_max - 1
		end

		-- We pressed jump, we want to jump
		if space then
			-- We can only jump if we did not jump the frame before
			if not platform.jump_prev then
				if
					-- If we are on the ground or sliding, we can always jump
					platform.grounded or platform.sliding
					or
					-- We are not on the ground or sliding, we are in the air
					-- We can only jump in the air if:
					--	 We have not exceeded the maximum amount of jumps
					not platform.grouned and
					not platform.sliding and
					platform.jump_count < platform.jump_count_max
					then
						platform.jumping = true
						platform.jump_count = platform.jump_count + 1
						platform.jump_prev = true
				end
			end
		end
	end
end

function InputSystem:requires()
	return {
		'Input',
		'Platform',
	}
end

return InputSystem

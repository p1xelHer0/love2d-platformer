local fsm = require('src.fsm')
local InputSystem = class('InputSystem', System)

function InputSystem:initialize()
	System.initialize(self)
end

local function can_jump(entity)
	local crouch = entity:get('Crouch')
	local jump = entity:get('Jump')
	local slide = entity:get('Slide')
	local stand = entity:get('Stand')

	if not jump then return false end
	if not stand then return false end

	-- We can only jump if we have released the jump-button the frame before
	if jump.jump_input_stop then
		-- We cant jump while crouching
		if crouch.crouching then
			return false
		-- We can always jump while standing
		elseif stand.standing then
			return true
		-- We only have a set amount of jump in the air or sliding
		elseif jump.jumping or slide.sliding then
			if jump.jump_count < jump.jump_count_max then
				return true
			end
		end
	end

	return false
end

local function can_crouch(entity)
	local crouch = entity:get('Crouch')
	local stand = entity:get('Stand')

	if not crouch then return false end
	if not stand then return false end

	-- We can onlt crouch while standing
	if stand.standing then
		return true
	end

	return false
end

function InputSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local movement = entity:get('Movement')

		local crouch = entity:get('Crouch')
		local jump = entity:get('Jump')
		local slide = entity:get('Slide')
		local stand = entity:get('Stand')

		-- WASD and Space as of now for input
		local left, right, down, space =
			love.keyboard.isDown('a'),
			love.keyboard.isDown('d'),
			love.keyboard.isDown('s'),
			love.keyboard.isDown('space')

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

		-- Reset
		crouch.crouch_current_frame = false
		jump.jump_current_frame = false

		-- We let go of space, this means we can try to jump again
		if not space then
			jump.jump_input_stop = true
		-- We try to jump
		elseif space then
			if can_jump(entity) then
				fsm('jump', entity)
				jump.jumping = true
				jump.jump_current_frame = true
				jump.jump_input_stop = false
			end
		end

		if not down then
			crouch.crouching = false
		-- We try to crouch
		elseif down then
			if can_crouch(entity) then
				if not crouch.crouching then
					-- First frame of crouching
					fsm('crouch', entity)
					crouch.crouch_current_frame = true
				else
					-- Rest of frames crouching
					crouch.crouching = true
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

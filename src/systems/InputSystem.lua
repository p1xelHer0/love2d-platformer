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

	if not jump.jump_current_frame then
		if crouch.crouching then
			return false
		elseif stand.standing or slide.sliding then
			return true
		elseif jump.jumping and jump.jump_count > jump.jump_count_max then
			return true
		end
	end

	return false
end

local function can_crouch(entity)
	local crouch = entity:get('Crouch')
	local stand = entity:get('Stand')

	if not crouch then return false end
	if not stand then return false end

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

		crouch.crouch_current_frame = false

		-- We let go of space, this means we can try to jump again
		if not space then
			jump.jump_current_frame = false
		elseif space then
			if can_jump(entity) then
				if not jump.jumping then
					-- First frame of jumping
					fsm('jump', entity)
					jump.jump_current_frame = true
				end
				jump.jumping = true
			end
		end

		if not down then
			crouch.crouching = false
		elseif down then
			if can_crouch(entity) then
				if not crouch.crouching then
					-- First frame of crouching
					fsm('crouch', entity)
					crouch.crouch_current_frame = true
				else
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

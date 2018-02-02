local Crouch = require('src.components.Crouch')
local Jump = require('src.components.Jump')
local Movement = require('src.components.Movement')

local InputSystem = class('InputSystem', System)

function InputSystem:initialize()
	System.initialize(self)
end

local function can_jump(entity)
	local crouch = entity:get('Crouch')

	-- We cant jump while crouching
	if crouch then
		return false
	end

	return true
end

local function can_crouch(entity)
	local stand = entity:get('Stand')

	-- We can only crouch while standing
	if stand then
		return true
	end

	return false
end

function InputSystem:update(dt)
	-- ASD and Space as of now for input
	local left, right, down, space =
		love.keyboard.isDown('a'),
		love.keyboard.isDown('d'),
		love.keyboard.isDown('s'),
		love.keyboard.isDown('space')

	for _, entity in pairs(self.targets) do
		local crouch = entity:get('Crouch')
		local direction = entity:get('Direction')
		local jump = entity:get('Jump')
		local movement = entity:get('Movement')

		-- Update movement and direction according to L/R
		if left and not right then
			if not movement then
				entity:add(Movement())
			end
			direction.value = -1
		elseif right and not left then
			if not movement then
				entity:add(Movement())
			end
			direction.value = 1
		else
			if movement then entity:remove('Movement') end
		end

		if space and can_jump(entity) then
			if not jump then entity:add(Jump()) end
		end

		if not space then
			if jump then entity:remove('Jump') end
		end

		if down and can_crouch(entity) then
			if not crouch then entity:add(Crouch()) end
		end

		if not down then
			if crouch then
				if crouch.can_stand then entity:remove('Crouch') end
			end
		end
	end
end

function InputSystem:requires()
	return {
		'Input',
	}
end

return InputSystem

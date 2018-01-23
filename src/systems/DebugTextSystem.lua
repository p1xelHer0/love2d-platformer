local DebugTextSystem = class('DebugTextSystem', System)

local function bool_to_square(bool, x, y)
	local color
	if bool then
		color = {0, 255, 0}
	else
		color = {120, 0, 0}
	end
	love.graphics.setColor(unpack(color))
	love.graphics.rectangle('fill', x, y, 4, 4)
	love.graphics.setColor(255, 255, 255)
end

function DebugTextSystem:initialize()
	System.initialize(self)
end

function DebugTextSystem:draw()
	for _, entity in pairs(self.targets) do
		local movement = entity:get('Movement')

		local fall = entity:get('Fall')
		local jump = entity:get('Jump')
		local slide = entity:get('Slide')
		local stand = entity:get('Stand')
		local crouch = entity:get('Crouch')

		local position = movement.position

		local debug_data = {
			stand.standing,
			crouch.crouching,
			jump.jumping,
			fall.falling,
			slide.sliding,
		}

		-- love.graphics.setColor(0, 255, 0)
		love.graphics.print('stand  ', 10, 7)
		bool_to_square(debug_data[1], 50, 7 + 5)
		love.graphics.print('crouch ', 10, 18)
		bool_to_square(debug_data[2], 50, 18 + 5)
		love.graphics.print('jump   ', 10, 29)
		bool_to_square(debug_data[3], 50, 29 + 5)
		love.graphics.print('fall   ', 10, 40)
		bool_to_square(debug_data[4], 50, 40 + 5)
		love.graphics.print('slide  ', 10, 51)
		bool_to_square(debug_data[5], 50, 51 + 5)

		love.graphics.setColor(255, 255, 255, 255)
	end
end

function DebugTextSystem:requires()
	return {
		'Input',
	}
end

return DebugTextSystem

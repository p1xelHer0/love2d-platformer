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

local function print_value(label, bool, x, y)
	love.graphics.print(label, x + 10, y)
	bool_to_square(bool, x + 50, y + 5)
end

function DebugTextSystem:initialize(camera)
	System.initialize(self)
	self.camera = camera
end

function DebugTextSystem:draw()
	for _, entity in pairs(self.targets) do
		local airborne = entity:get('Airborne')
		local fall = entity:get('Fall')
		local jump = entity:get('Jump')
		local dash = entity:get('Dash')
		local slide = entity:get('Slide')
		local grounded = entity:get('Grounded')
		local crouch = entity:get('Crouch')
		local position = entity:get('Position').coordinates
		local velocity = entity:get('Body').velocity

		local debug_data = {
			grounded,
			airborne,
			fall,
			jump,
			dash,
			crouch,
			slide,
		}

		local render_position = position.y
		if crouch then
			render_position = render_position - 7
		end

		self.camera:draw(
			function()
				love.graphics.print(position.x .. ', ' .. position.y, position.x - 10, render_position - 20)
				love.graphics.line(
				  position.x,
				  render_position,
				  position.x + velocity.x / 5,
				  render_position + velocity.y / 5
				)

				print_value('ground', debug_data[1], position.x, render_position)
				print_value('air', debug_data[2], position.x, render_position + 9)
				print_value('fall', debug_data[3], position.x, render_position + 9 * 2)
				print_value('jump', debug_data[4], position.x, render_position + 9 * 3)
				print_value('dash', debug_data[5], position.x, render_position + 9 * 4)
				print_value('crouch', debug_data[6], position.x, render_position + 9 * 5)
				print_value('slide', debug_data[7], position.x, render_position + 9 * 6)
			end
		)

		love.graphics.setColor(255, 255, 255, 255)
	end
end

function DebugTextSystem.requires()
	return {
		'Position',
	}
end

return DebugTextSystem

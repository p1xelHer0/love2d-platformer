local HealthUISystem = class('HealthUISystem', System)

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

function HealthUISystem:initialize(camera)
	System.initialize(self)
	self.camera = camera
end

function HealthUISystem:draw()
	for _, entity in pairs(self.targets) do
		local health = entity:get('Health')

		local current = health.health
		local max = health.health_max

		self.camera:draw(
			function(x, y)
				local bar_position = { x = x + 16, y = y + 16, }
				love.graphics.setColor(0, 100, 0, 255)
				love.graphics.rectangle('fill', bar_position.x, bar_position.y, max, 4)
				love.graphics.setColor(0, 255, 0, 255)
				love.graphics.rectangle('fill', bar_position.x, bar_position.y, current, 4)
				love.graphics.setColor(255, 255, 255, 255)
				local text_position = { x = bar_position.x + 3, y = bar_position.y + 5, }
				local health_label = current .. ' / ' .. max
				love.graphics.print(health_label, text_position.x, text_position.y)
			end
		)
	end
end

function HealthUISystem:requires()
	return {
		'Playable',
		'Health',
	}
end

return HealthUISystem

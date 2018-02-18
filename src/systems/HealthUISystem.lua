local HealthUISystem = class('HealthUISystem', System)

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
				for i = 1, max, 1 do
					love.graphics.setColor(0, 100, 0, 255)
					love.graphics.rectangle('fill', x + i * 16, y + 16, 4, 4)
				end

				love.graphics.setColor(0, 255, 0, 255)

				for i = 1, current, 1 do
					love.graphics.rectangle('fill', x + i * 16, y + 16, 4, 4)
				end
			end
		)

		love.graphics.setColor(255, 255, 255, 255)
	end
end

function HealthUISystem.requires()
	return {
		'Playable',
		'Health',
	}
end

return HealthUISystem

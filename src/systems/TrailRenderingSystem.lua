local TrailRenderingSystem = class('TrailRenderingSystem', System)

function TrailRenderingSystem:initialize(camera)
	System.initialize(self)
	self.camera = camera
end

function TrailRenderingSystem:draw(dt)
	for _, entity in pairs(self.targets) do
		local trail = entity:get('Trail')
		local position = trail.position

		local draw_properties = {
			'fill',
			position.x,
			position.y,
			trail.radius
		}

		self.camera:draw(
			function()
				love.graphics.circle(unpack(draw_properties))
			end
		)

	end
end

function TrailRenderingSystem.requires()
	return {
		'Trail',
		'Position',
	}
end

return TrailRenderingSystem

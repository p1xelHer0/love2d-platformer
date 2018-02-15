local CameraDebugSystem = class('CameraDebugSystem', System)

function CameraDebugSystem:initialize(camera)
	System.initialize(self)
	self.camera = camera
end

function CameraDebugSystem:draw()
	for _, entity in pairs(self.targets) do
		local camera = entity:get('Camera').camera

		local x, y = camera:getPosition()

		love.graphics.setColor(255, 60, 60, 255)

		self.camera:draw(
			function()
				love.graphics.rectangle('fill', x, y, 1, 1)
			end
		)

		love.graphics.setColor(255, 255, 255)
	end
end

function CameraDebugSystem.requires()
	return {
		'Camera',
	}
end

return CameraDebugSystem

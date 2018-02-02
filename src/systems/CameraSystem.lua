local CameraSystem = class('CameraSystem', System)

function CameraSystem:initialize()
	System.initialize(self)
end

function CameraSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local camera = entity:get('Camera').camera
		local position = entity:get('Position').coordinates

		camera:setPosition(position.x - 125, position.y - 70)
	end
end

function CameraSystem:requires()
	return {
		'Camera',
		'Position',
	}
end

return CameraSystem

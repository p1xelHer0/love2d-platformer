local CameraSystem = class('CameraSystem', System)

function CameraSystem:initialize()
	System.initialize(self)
	self.target = vector(0, 0)
end

function CameraSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local camera = entity:get('Camera').camera
		local position = entity:get('Position').coordinates

		local direction = entity:get('Direction')

		local movement = entity:get('Movement')
		local crouch = entity:get('Crouch')

		-- offset according to player sprite as of now
		self.target = {
			x = position.x + 2,
			y = position.y + 2,
		}

		local _, _, camera_window_width, camera_window_height = camera:getWindow()

		-- move the camera in the direction the entity is facing
		-- if direction then
		-- 	self.target.x = self.target.x + camera_window_width / 100 * direction.value

		-- 	-- move the camera even more if the entity is moving
		-- 	if movement then
		-- 		self.target.x = self.target.x + camera_window_width / 50 * direction.value
		-- 	end
		-- end

		-- TODO better solution, crouching as always
		-- if crouch then
		-- 	self.target.y = self.target.y - 7

		-- 	-- move the camera down if the entity has crouched for a certian time
		-- 	if crouch.time > 1 then
		-- 		self.target.y = self.target.y + camera_window_height / 6
		-- 	end
		-- end

		self.target = self.target

		camera:setPosition(self.target.x, self.target.y)
	end
end

function CameraSystem:requires()
	return {
		'Camera',
		'Position',
	}
end

return CameraSystem

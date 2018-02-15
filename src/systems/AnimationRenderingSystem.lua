local SpriteRenderingSystem = class('SpriteRenderingSystem', System)

function SpriteRenderingSystem:initialize(camera)
	System.initialize(self)
	self.camera = camera
end

function SpriteRenderingSystem:draw()
	for _, entity in pairs(self.targets) do
		local animation = entity:get('Animation')
		local position = entity:get('Position').coordinates

		local direction = entity:get('Direction').value

		local crouch = entity:get('Crouch')
		local fall = entity:get('Fall')
		local jump = entity:get('Jump')
		local slide = entity:get('Slide')

		-- Sprite is 2px taller than the sprite, offset accordingly
		local offset = {
			x = 0,
			y = 2,
		}

		-- Update offset according to direction, needed when flipping sprite
		if direction == -1 then
			offset.x = 11
		elseif direction == 1 then
			offset.x = 5
		end

		if crouch then
			offset.y = 9
		end

		local draw_properties = {
			animation.image,
			position.x,
			position.y,
			0,
			direction,
			1,
			offset.x,
			offset.y,
		}

		if fall then
			animation.current = animation.animations.fall
		elseif crouch then
			animation.current = animation.animations.crouch
		elseif jump then
			animation.current = animation.animations.jump
		elseif slide then
			animation.current = animation.animations.slide
		else
			animation.current = animation.animations.grounded
		end

		-- Render the animations
		self.camera:draw(
			function()
				animation.current:draw(unpack(draw_properties))
			end
		)
	end
end

function SpriteRenderingSystem.requires()
	return {
		'Animation',
		'Position',
	}
end

return SpriteRenderingSystem

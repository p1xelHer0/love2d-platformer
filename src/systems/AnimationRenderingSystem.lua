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

		local airborne = entity:get('Airborne')
		local crouch = entity:get('Crouch')
		local dash = entity:get('Dash')
		local fall = entity:get('Fall')
		local jump = entity:get('Jump')
		local movement = entity:get('Movement')
		local slide = entity:get('Slide')

		-- Sprite is 2px taller than the sprite, offset accordingly
		local offset = {
			x = 0,
			y = 2,
		}

		-- Update offset according to direction, needed when flipping sprite
		if direction == -1 then
			offset.x = 10
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

		if dash then
			animation.current = animation.animations.dash
		elseif jump then
			animation.current = animation.animations.jump
		elseif crouch then
			animation.current = animation.animations.crouch
		elseif slide then
			-- animation.current = animation.animations.slide
		elseif fall then
			animation.current = animation.animations.fall
		elseif airborne then
			animation.current = animation.animations.airborne
		elseif movement then
			animation.current = animation.animations.movement
		else
			animation.current = animation.animations.idle
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

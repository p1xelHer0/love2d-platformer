local SpriteRenderingSystem = class('SpriteRenderingSystem', System)

function SpriteRenderingSystem:initialize()
	System.initialize(self)
end

function SpriteRenderingSystem:draw()
	love.graphics.setBackgroundColor(33, 33, 33)
	for _, entity in pairs(self.targets) do
		local platform = entity:get('Platform')
		local sprite = entity:get('Sprite')
		local animation = entity:get('Animation')

		local direction, position = platform.direction, platform.position

		-- States the sprite can be in
		local moving, jumping, crouching, falling, grounded =
			platform.moving,
			platform.jumping,
			platform.crouching,
			platform.falling

		local image = sprite.image
		local animations = animation.animations

		-- Sprite is 2px taller than the sprite, offset accordingly
		local offset = {
			x = 0,
			y = 2,
		}

		-- Update offset according to direction, needed when flipping sprite
		if direction == -1 then
			offset.x = 11
		else
			offset.x = 5
		end

		if crouching then
			offset.y = 9
		end

		local draw_properties = {
			image,
			position.x,
			position.y,
			0,
			direction,
			1,
			offset.x,
			offset.y,
		}

		-- Render the animations
		if falling then
			animations.fall:draw(unpack(draw_properties))
		elseif crouching then
			animations.crouch:draw(unpack(draw_properties))
		elseif jumping then
			animations.jump:draw(unpack(draw_properties))
		else
			animations.idle:draw(unpack(draw_properties))
		end
	end
end

function SpriteRenderingSystem:requires()
	return {
		'Animation',
		'Platform',
		'Sprite',
	}
end

return SpriteRenderingSystem

local HitboxRenderSystem = class('HitboxRenderSystem', System)

function HitboxRenderSystem:initialize(camera)
	System.initialize(self)
	self.camera = camera
end

function HitboxRenderSystem:draw()
	for _, entity in pairs(self.targets) do
		local position = entity:get('Position').coordinates
		local body = entity:get('Body')

		local hitbox = body.hitbox

		love.graphics.setColor(255, 60, 60, 100)

		self.camera:draw(
			function()
				love.graphics.rectangle('fill', position.x, position.y, hitbox.w, hitbox.h)
			end
		)

		love.graphics.setColor(255, 255, 255)
	end
end

function HitboxRenderSystem.requires()
	return {
		'Body',
		'Position',
	}
end

return HitboxRenderSystem

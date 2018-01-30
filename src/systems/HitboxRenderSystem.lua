local HitboxRenderSystem = class('HitboxRenderSystem', System)

function HitboxRenderSystem:initialize()
	System.initialize(self)
end

function HitboxRenderSystem:draw()
	for _, entity in pairs(self.targets) do
		local position = entity:get('Position').coordinates
		local body = entity:get('Body')

		local hitbox = body.hitbox

		love.graphics.setColor(255, 60, 60, 100)
		love.graphics.rectangle('fill', position.x, position.y, hitbox.w, hitbox.h)
		love.graphics.setColor(255, 255, 255)
	end
end

function HitboxRenderSystem:requires()
	return {
		'Body',
		'Position',
	}
end

return HitboxRenderSystem

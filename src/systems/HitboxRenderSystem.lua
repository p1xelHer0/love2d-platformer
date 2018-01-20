local HitboxRenderSystem = class('HitboxRenderSystem', System)

function HitboxRenderSystem:initialize()
	System.initialize(self)
end

function HitboxRenderSystem:draw()
	for _, entity in pairs(self.targets) do
		local movement = entity:get('Movement')
		local body = entity:get('Body')

		local position = movement.position
		local hitbox = body.hitbox

		love.graphics.setColor(255, 60, 60)
		love.graphics.rectangle('line', position.x, position.y, hitbox.w, hitbox.h)
		love.graphics.setColor(255, 255, 255)
	end
end

function HitboxRenderSystem:requires()
	return {
		'Body',
		'Movement',
	}
end

return HitboxRenderSystem

local SpriteSystem = class('SpriteSystem', System)

function SpriteSystem:initialize()
	System.initialize(self)
end

function SpriteSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local platform = entity:get('Platform')
		local sprite = entity:get('Sprite')

		local animations = sprite.animations

		animations.idle:update(dt)
	end
end

function SpriteSystem:requires()
	return {
		'Platform',
		'Sprite',
	}
end

return SpriteSystem

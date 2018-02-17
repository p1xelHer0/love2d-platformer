local Trail = require('src.components.Trail')

local TrailSystem = class('TrailSystem', System)

function TrailSystem:initialize()
	System.initialize(self)
end

function TrailSystem:update(dt)
	for _, entity in pairs(self.targets) do
		local trail = entity:get('Trail')
		local radius, timer = trail.radius, trail.timer
		timer:update(dt)
	end
end

function TrailSystem:onAddEntity(entity)
	local position = entity:get('Position').coordinates
	local trail = entity:get('Trail')
	trail.position = position
	trail.timer = Timer.new()
	trail.timer:after(5, function() print('lul') end)
	trail.timer:tween(
		love.math.random(0.3, 0.5),
		trail,
		{ radius = 0 },
		'linear',
		function()
			entity:remove('Trail')
			entity:add(Trail())
		end
	)
end

function TrailSystem.requires()
	return {
		'Trail',
	}
end

return TrailSystem

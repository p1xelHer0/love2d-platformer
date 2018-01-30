local Health = Component.create('Health')

function Health:initialize(max_health)
	self.health = max_health
	self.health_max = max_health
end

return Health

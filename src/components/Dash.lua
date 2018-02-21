local Dash = Component.create('Dash')

function Dash:initialize()
	self.time_max = 0.15
	self.force = 175
	self.cooldown = 0.3
end

return Dash

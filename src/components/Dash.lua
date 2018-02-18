local Dash = Component.create('Dash')

function Dash:initialize()
	self.timer = nil
	self.time_max = 0.2
	self.force = 250
	self.cooldown = 3
end

return Dash
